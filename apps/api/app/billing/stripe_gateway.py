"""The only module that talks to Stripe.

Everything else in `app.billing` works on plain values, so the checkout service,
the webhook reconciler, and their tests never need a network or a key. Same
boundary pattern as `ReportNarrativeClient` (D-084) and `AuthAdmin`.

Prices are addressed by **lookup key**, not by stored id. A lookup key is
deterministic (`fev_operations_annual`), unique per Stripe account mode, and
survives a Price being archived and recreated — so nothing has to commit a
`price_...` id, and the same code path works against test and live keys without
a per-environment mapping. `scripts/stripe_sync.py` creates them from the plan
catalog; this module resolves them.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import Any, Protocol

from app.billing.plans import BillingInterval, Plan, PlanTier
from app.core.settings import settings

logger = logging.getLogger(__name__)

#: Prefix keeps FEV's prices identifiable in a Stripe account that may later
#: carry other Flacron products (FlacronBuild, MedVerse).
LOOKUP_PREFIX = "fev"


def price_lookup_key(tier: PlanTier, interval: BillingInterval) -> str:
    return f"{LOOKUP_PREFIX}_{tier.value}_{interval.value}"


def product_lookup_id(tier: PlanTier) -> str:
    """Deterministic Product id, so re-running the sync updates in place rather
    than accumulating duplicate products."""
    return f"{LOOKUP_PREFIX}_{tier.value}"


class StripeNotConfiguredError(Exception):
    """No secret key. Raised rather than defaulting to a no-op: a billing call
    that silently succeeds without charging is worse than an outage."""


class StripeGatewayError(Exception):
    """A Stripe call failed. Carries a safe message for the client envelope."""

    def __init__(self, message: str, *, code: str = "stripe_error") -> None:
        super().__init__(message)
        self.code = code


@dataclass(frozen=True)
class CheckoutSession:
    id: str
    url: str


@dataclass(frozen=True)
class SubscriptionSnapshot:
    """The subset of a Stripe subscription the platform stores. Deliberately
    small — Stripe stays the system of record for billing detail; the company
    document only needs enough to resolve entitlements."""

    subscription_id: str
    customer_id: str
    status: str
    tier: PlanTier | None
    interval: BillingInterval | None
    trial_end: int | None
    current_period_end: int | None


class StripeGateway(Protocol):
    """Injectable seam. Tests pass a fake; production passes `LiveStripeGateway`."""

    async def create_checkout_session(
        self,
        *,
        plan: Plan,
        interval: BillingInterval,
        company_id: str,
        customer_email: str,
        trial_days: int,
        success_url: str,
        cancel_url: str,
    ) -> CheckoutSession: ...

    async def retrieve_subscription(self, subscription_id: str) -> SubscriptionSnapshot: ...

    def verify_webhook(self, payload: bytes, signature: str) -> dict[str, Any]: ...


def _require_stripe() -> Any:
    if not settings.stripe_configured:
        raise StripeNotConfiguredError("STRIPE_SECRET_KEY is not configured")
    import stripe

    stripe.api_key = settings.stripe_secret_key
    return stripe


def tier_from_metadata(metadata: dict[str, Any] | None) -> PlanTier | None:
    """Tier is read back from our own metadata rather than inferred from the
    price amount, so a repricing cannot mis-assign a plan."""
    raw = (metadata or {}).get("fev_tier")
    if not raw:
        return None
    try:
        return PlanTier(str(raw))
    except ValueError:
        logger.warning("Stripe metadata carried an unknown tier: %s", raw)
        return None


def interval_from_metadata(metadata: dict[str, Any] | None) -> BillingInterval | None:
    raw = (metadata or {}).get("fev_interval")
    if not raw:
        return None
    try:
        return BillingInterval(str(raw))
    except ValueError:
        return None


class LiveStripeGateway:
    """Real Stripe calls. Every method translates a Stripe exception into
    `StripeGatewayError` so route handlers never leak SDK types."""

    async def _price_id(self, tier: PlanTier, interval: BillingInterval) -> str:
        stripe = _require_stripe()
        key = price_lookup_key(tier, interval)
        try:
            found = await stripe.Price.list_async(lookup_keys=[key], active=True, limit=1)
        except Exception as error:  # noqa: BLE001 - SDK raises a wide family
            raise StripeGatewayError(f"Could not resolve price {key}") from error
        data = found.data
        if not data:
            raise StripeGatewayError(
                f"No active Stripe price for {key}. Run scripts/stripe_sync.py.",
                code="price_missing",
            )
        return str(data[0].id)

    async def create_checkout_session(
        self,
        *,
        plan: Plan,
        interval: BillingInterval,
        company_id: str,
        customer_email: str,
        trial_days: int,
        success_url: str,
        cancel_url: str,
    ) -> CheckoutSession:
        stripe = _require_stripe()
        price_id = await self._price_id(plan.tier, interval)
        try:
            session = await stripe.checkout.Session.create_async(
                mode="subscription",
                line_items=[{"price": price_id, "quantity": 1}],
                customer_email=customer_email,
                # `client_reference_id` is echoed back on the completed event,
                # which is how the webhook finds the company without trusting
                # anything the browser sends back.
                client_reference_id=company_id,
                subscription_data={
                    "trial_period_days": trial_days,
                    "metadata": {
                        "fev_company_id": company_id,
                        "fev_tier": plan.tier.value,
                        "fev_interval": interval.value,
                    },
                },
                metadata={
                    "fev_company_id": company_id,
                    "fev_tier": plan.tier.value,
                    "fev_interval": interval.value,
                },
                # A card is collected up front so the trial converts rather than
                # stranding a tenant (product owner, 2026-09-08).
                payment_method_collection="always",
                success_url=success_url,
                cancel_url=cancel_url,
                allow_promotion_codes=True,
            )
        except Exception as error:  # noqa: BLE001
            raise StripeGatewayError("Could not start checkout") from error
        created = session.to_dict()
        url = created.get("url")
        if not url:
            raise StripeGatewayError("Stripe returned a session with no URL")
        return CheckoutSession(id=str(created["id"]), url=str(url))

    async def retrieve_subscription(self, subscription_id: str) -> SubscriptionSnapshot:
        stripe = _require_stripe()
        try:
            subscription = await stripe.Subscription.retrieve_async(subscription_id)
        except Exception as error:  # noqa: BLE001
            raise StripeGatewayError("Could not read subscription") from error
        return snapshot_from_subscription(subscription.to_dict())

    def verify_webhook(self, payload: bytes, signature: str) -> dict[str, Any]:
        if not settings.stripe_webhook_secret:
            raise StripeNotConfiguredError("STRIPE_WEBHOOK_SECRET is not configured")
        stripe = _require_stripe()
        try:
            event = stripe.Webhook.construct_event(
                payload, signature, settings.stripe_webhook_secret
            )
        except Exception as error:  # noqa: BLE001
            # Signature failures are the security boundary of the whole billing
            # flow: an unverified event could grant a paid tier for free.
            raise StripeGatewayError(
                "Webhook signature verification failed", code="invalid_signature"
            ) from error
        return dict(event)


def snapshot_from_subscription(subscription: dict[str, Any]) -> SubscriptionSnapshot:
    """Map a Stripe subscription payload onto the fields the platform stores.

    Takes a plain dict — the gateway calls `.to_dict()` and webhook payloads are
    already JSON — so this stays free of SDK types and testable with a literal.
    Shared by the gateway and the webhook reconciler, so a subscription read one
    way cannot resolve differently from the other."""
    metadata = dict(subscription.get("metadata") or {})
    customer = subscription.get("customer")
    # `current_period_end` moved onto the subscription item in recent API
    # versions; fall back so either shape reconciles.
    period_end = subscription.get("current_period_end")
    if period_end is None:
        items = (subscription.get("items") or {}).get("data") or []
        if items:
            period_end = items[0].get("current_period_end")
    return SubscriptionSnapshot(
        subscription_id=str(subscription["id"]),
        customer_id=str(customer["id"] if isinstance(customer, dict) else customer or ""),
        status=str(subscription.get("status") or "incomplete"),
        tier=tier_from_metadata(metadata),
        interval=interval_from_metadata(metadata),
        trial_end=subscription.get("trial_end"),
        current_period_end=period_end,
    )


def get_stripe_gateway() -> StripeGateway:
    return LiveStripeGateway()
