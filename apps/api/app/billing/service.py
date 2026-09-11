"""Checkout initiation and webhook reconciliation.

Reconciliation deliberately does **not** trust the event body for state. Any
relevant event triggers a fresh `retrieve_subscription` and the company document
is written from that. Two consequences, both wanted:

* **Idempotent.** A redelivered event writes the same absolute state, so no
  processed-event ledger is needed.
* **Order-independent.** Stripe does not guarantee delivery order, and an
  `updated` arriving before a `created` would otherwise regress a tenant's plan.
  Reading live state makes the ordering irrelevant.

The cost is one extra Stripe read per event, which is trivial next to getting a
subscription tier wrong.
"""

from __future__ import annotations

import logging
from datetime import UTC, datetime
from typing import Any

from app.audit.service import AuditService
from app.billing.plans import PLANS, TRIAL_DAYS, BillingInterval, PlanTier, get_plan
from app.billing.stripe_gateway import (
    CheckoutSession,
    StripeGateway,
    SubscriptionSnapshot,
)
from app.db.repositories.companies import CompanyRepository
from app.models.base import CompanyScope
from app.models.entities import CompanyUpdate

logger = logging.getLogger(__name__)

BILLING_ACTOR = "system:billing"

#: Events that change what a tenant may do. Anything else is acknowledged and
#: ignored — Stripe sends a great deal we have no opinion about, and a 200 stops
#: it retrying.
RECONCILING_EVENTS = frozenset(
    {
        "checkout.session.completed",
        "customer.subscription.created",
        "customer.subscription.updated",
        "customer.subscription.deleted",
        "invoice.payment_failed",
        "invoice.paid",
    }
)


class BillingError(Exception):
    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code
        self.message = message


def _timestamp(value: int | None) -> datetime | None:
    return datetime.fromtimestamp(value, tz=UTC) if value else None


class SubscriptionService:
    def __init__(
        self,
        *,
        gateway: StripeGateway,
        companies: CompanyRepository,
        audit: AuditService,
    ) -> None:
        self._gateway = gateway
        self._companies = companies
        self._audit = audit

    # ---------------------------------------------------------- checkout

    async def start_checkout(
        self,
        *,
        company_id: str,
        customer_email: str,
        tier: PlanTier,
        interval: BillingInterval,
        success_url: str,
        cancel_url: str,
    ) -> CheckoutSession:
        plan = PLANS.get(tier)
        if plan is None:
            raise BillingError("unknown_plan", f"No such plan: {tier}")

        scope = CompanyScope(company_id=company_id)
        company = await self._companies.get(scope)
        if company is None:
            raise BillingError("company_not_found", "Company does not exist")

        session = await self._gateway.create_checkout_session(
            plan=plan,
            interval=interval,
            company_id=company_id,
            customer_email=customer_email,
            trial_days=TRIAL_DAYS,
            success_url=success_url,
            cancel_url=cancel_url,
        )
        await self._audit.audit(
            scope,
            actor_uid=BILLING_ACTOR,
            action="billing.checkout_started",
            target_type="company",
            target_id=company_id,
            metadata={
                "tier": tier.value,
                "interval": interval.value,
                "session_id": session.id,
            },
        )
        return session

    # ------------------------------------------------------ reconciliation

    async def reconcile_event(self, event: dict[str, Any]) -> str:
        """Apply one verified Stripe event. Returns a short outcome string for
        the response body and the logs."""
        event_type = str(event.get("type") or "")
        if event_type not in RECONCILING_EVENTS:
            return "ignored"

        payload = dict((event.get("data") or {}).get("object") or {})
        company_id = self._company_id_from(payload)
        subscription_id = self._subscription_id_from(payload)

        if company_id is None or subscription_id is None:
            # Nothing actionable. Logged rather than raised: returning non-200
            # would make Stripe retry an event we can never process.
            logger.warning(
                "Billing event %s carried no company/subscription reference", event_type
            )
            return "unresolved"

        snapshot = await self._gateway.retrieve_subscription(subscription_id)
        await self._apply(company_id, snapshot, event_type=event_type)
        return "reconciled"

    def _company_id_from(self, payload: dict[str, Any]) -> str | None:
        metadata = dict(payload.get("metadata") or {})
        # `client_reference_id` is set on the Checkout Session; subscription
        # objects carry our metadata instead.
        return (
            metadata.get("fev_company_id")
            or payload.get("client_reference_id")
            or None
        )

    def _subscription_id_from(self, payload: dict[str, Any]) -> str | None:
        # A Checkout Session references the subscription; a subscription object
        # *is* it; an invoice points back at it.
        candidate = payload.get("subscription") or (
            payload.get("id") if str(payload.get("object")) == "subscription" else None
        )
        if isinstance(candidate, dict):
            return str(candidate.get("id") or "") or None
        return str(candidate) if candidate else None

    async def _apply(
        self,
        company_id: str,
        snapshot: SubscriptionSnapshot,
        *,
        event_type: str,
    ) -> None:
        scope = CompanyScope(company_id=company_id)
        company = await self._companies.get(scope)
        if company is None:
            logger.warning("Billing event referenced unknown company %s", company_id)
            return

        # The tier comes from our own subscription metadata. If it is missing we
        # keep whatever the company already had rather than guessing from the
        # price — a wrong tier grants or removes real modules.
        tier = snapshot.tier.value if snapshot.tier else company.subscription_tier
        if snapshot.tier is None:
            logger.warning(
                "Subscription %s has no fev_tier metadata; keeping tier %s",
                snapshot.subscription_id,
                company.subscription_tier,
            )

        update = CompanyUpdate(
            subscription_tier=tier,
            subscription_status=snapshot.status,
            billing_interval=snapshot.interval.value if snapshot.interval else None,
            trial_ends_at=_timestamp(snapshot.trial_end),
            current_period_end=_timestamp(snapshot.current_period_end),
            stripe_customer_id=snapshot.customer_id or None,
            stripe_subscription_id=snapshot.subscription_id,
        )
        changed = (
            company.subscription_tier != tier
            or company.subscription_status != snapshot.status
        )
        await self._companies.update(scope, update, BILLING_ACTOR)

        if changed:
            await self._audit.audit(
                scope,
                actor_uid=BILLING_ACTOR,
                action="billing.subscription_changed",
                target_type="company",
                target_id=company_id,
                metadata={
                    "event": event_type,
                    "from_tier": company.subscription_tier,
                    "to_tier": tier,
                    "from_status": company.subscription_status,
                    "to_status": snapshot.status,
                    "subscription_id": snapshot.subscription_id,
                },
            )

    # ---------------------------------------------------------- read model

    async def describe(self, company_id: str) -> dict[str, Any]:
        """Plan summary for the dashboard card and the billing page."""
        company = await self._companies.get(CompanyScope(company_id=company_id))
        if company is None:
            raise BillingError("company_not_found", "Company does not exist")
        plan = get_plan(company.subscription_tier)
        return {
            "tier": company.subscription_tier,
            "plan_name": plan.name if plan else None,
            "status": company.subscription_status,
            "billing_interval": company.billing_interval,
            "trial_ends_at": company.trial_ends_at,
            "current_period_end": company.current_period_end,
        }
