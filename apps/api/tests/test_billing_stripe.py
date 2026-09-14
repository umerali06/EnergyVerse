"""Checkout, webhook verification, and subscription reconciliation.

Runs against a fake `StripeGateway`, so no key and no network. The live Stripe
calls themselves are covered separately by `scripts/stripe_sync.py --verify`,
which reads every published price back from the real account.
"""

from __future__ import annotations

import asyncio
from datetime import UTC, datetime
from typing import Any

import pytest
from fastapi import HTTPException

from app.billing.dependencies import require_billing_admin
from app.billing.entitlements import resolve_entitlements
from app.billing.plans import BillingInterval, PlanTier
from app.billing.service import RECONCILING_EVENTS, BillingError, SubscriptionService
from app.billing.stripe_gateway import (
    CheckoutSession,
    CheckoutSessionState,
    SubscriptionSnapshot,
    checkout_state_from_session,
    interval_from_metadata,
    price_lookup_key,
    product_lookup_id,
    snapshot_from_subscription,
    tier_from_metadata,
)
from app.models.base import CompanyScope
from app.models.entities import Company, CompanyUpdate, CurrentUser

NOW = datetime(2026, 9, 8, 12, 0, tzinfo=UTC)
COMPANY_ID = "cmp_acme"


class FakeCompanies:
    def __init__(self, company: Company | None) -> None:
        self._company = company
        self.updates: list[CompanyUpdate] = []

    async def get(self, scope: CompanyScope) -> Company | None:
        if self._company is None or self._company.id != scope.company_id:
            return None
        return self._company

    async def update(
        self, scope: CompanyScope, payload: CompanyUpdate, actor_uid: str
    ) -> Company:
        assert scope.company_id == COMPANY_ID
        assert actor_uid == "system:billing"
        self.updates.append(payload)
        assert self._company is not None
        merged = self._company.model_copy(
            update=payload.model_dump(exclude_unset=True)
        )
        self._company = merged
        return merged


class FakeAudit:
    def __init__(self) -> None:
        self.entries: list[dict[str, Any]] = []

    async def audit(self, scope: CompanyScope, **kwargs: Any) -> None:
        self.entries.append({"company_id": scope.company_id, **kwargs})

    def actions(self) -> list[str]:
        return [str(entry["action"]) for entry in self.entries]


class FakeGateway:
    def __init__(
        self,
        snapshot: SubscriptionSnapshot | None = None,
        session_state: CheckoutSessionState | None = None,
    ) -> None:
        self.snapshot = snapshot
        self.session_state = session_state
        self.checkout_calls: list[dict[str, Any]] = []
        self.retrieved: list[str] = []
        self.sessions_read: list[str] = []

    async def create_checkout_session(self, **kwargs: Any) -> CheckoutSession:
        self.checkout_calls.append(kwargs)
        return CheckoutSession(id="cs_test_123", url="https://checkout.stripe.com/c/cs_test_123")

    async def retrieve_checkout_session(self, session_id: str) -> CheckoutSessionState:
        self.sessions_read.append(session_id)
        assert self.session_state is not None
        return self.session_state

    async def retrieve_subscription(self, subscription_id: str) -> SubscriptionSnapshot:
        self.retrieved.append(subscription_id)
        assert self.snapshot is not None
        return self.snapshot

    def verify_webhook(self, payload: bytes, signature: str) -> dict[str, Any]:
        raise NotImplementedError


def company(
    *, tier: str = "unassigned", status: str = "incomplete"
) -> Company:
    return Company(
        id=COMPANY_ID,
        name="Acme Energy",
        status="active",
        subscription_tier=tier,
        subscription_status=status,
        created_at=NOW,
        updated_at=NOW,
    )


def snapshot(
    *,
    status: str = "trialing",
    tier: PlanTier | None = PlanTier.OPERATIONS,
    interval: BillingInterval | None = BillingInterval.ANNUAL,
    trial_end: int | None = 1_789_000_000,
) -> SubscriptionSnapshot:
    return SubscriptionSnapshot(
        subscription_id="sub_123",
        customer_id="cus_123",
        status=status,
        tier=tier,
        interval=interval,
        trial_end=trial_end,
        current_period_end=1_789_500_000,
    )


def session_state(
    *,
    company_id: str | None = COMPANY_ID,
    subscription_id: str | None = "sub_123",
    status: str = "complete",
    payment_status: str = "no_payment_required",
) -> CheckoutSessionState:
    return CheckoutSessionState(
        session_id="cs_test_123",
        company_id=company_id,
        subscription_id=subscription_id,
        status=status,
        payment_status=payment_status,
    )


def service(
    *,
    companies: FakeCompanies,
    gateway: FakeGateway,
    audit: FakeAudit,
) -> SubscriptionService:
    return SubscriptionService(
        gateway=gateway,  # type: ignore[arg-type]
        companies=companies,  # type: ignore[arg-type]
        audit=audit,  # type: ignore[arg-type]
    )


class TestLookupKeys:
    """Prices are addressed by lookup key, so the keys are a wire contract with
    the Stripe account -- renaming one silently breaks checkout."""

    def test_keys_are_stable_and_namespaced(self) -> None:
        assert price_lookup_key(PlanTier.OPERATIONS, BillingInterval.ANNUAL) == (
            "fev_operations_annual"
        )
        assert price_lookup_key(PlanTier.STARTER, BillingInterval.MONTHLY) == (
            "fev_starter_monthly"
        )
        assert product_lookup_id(PlanTier.ENTERPRISE) == "fev_enterprise"


class TestCheckout:
    def test_starts_a_session_with_the_trial_and_our_metadata(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway()
        audit = FakeAudit()
        result = asyncio.run(service(
            companies=companies, gateway=gateway, audit=audit
        ).start_checkout(
            company_id=COMPANY_ID,
            customer_email="admin@acme.example.invalid",
            tier=PlanTier.OPERATIONS,
            interval=BillingInterval.ANNUAL,
            success_url="https://app.example/ok",
            cancel_url="https://app.example/cancel",
        ))

        assert result.url.startswith("https://checkout.stripe.com/")
        call = gateway.checkout_calls[0]
        assert call["plan"].tier is PlanTier.OPERATIONS
        assert call["interval"] is BillingInterval.ANNUAL
        assert call["company_id"] == COMPANY_ID
        assert call["trial_days"] == 7
        assert "billing.checkout_started" in audit.actions()

    def test_refuses_an_unknown_company(self) -> None:
        companies = FakeCompanies(None)
        with pytest.raises(BillingError) as error:
            asyncio.run(service(
                companies=companies, gateway=FakeGateway(), audit=FakeAudit()
            ).start_checkout(
                company_id=COMPANY_ID,
                customer_email="a@b.invalid",
                tier=PlanTier.STARTER,
                interval=BillingInterval.ANNUAL,
                success_url="https://app.example/ok",
                cancel_url="https://app.example/cancel",
            ))
        assert error.value.code == "company_not_found"

    def test_refuses_a_tier_that_is_not_published(self) -> None:
        companies = FakeCompanies(company())
        with pytest.raises(BillingError) as error:
            asyncio.run(service(
                companies=companies, gateway=FakeGateway(), audit=FakeAudit()
            ).start_checkout(
                company_id=COMPANY_ID,
                customer_email="a@b.invalid",
                tier=PlanTier.UNASSIGNED,
                interval=BillingInterval.ANNUAL,
                success_url="https://app.example/ok",
                cancel_url="https://app.example/cancel",
            ))
        assert error.value.code == "unknown_plan"


class TestConfirmCheckout:
    """Stripe returns the browser before it necessarily delivers
    `checkout.session.completed`, so the completion screen used to poll a read
    model that nothing had written yet -- and on a deployment whose webhook
    endpoint is unreachable, never would. Confirming from the session id Stripe
    itself put in the return URL removes that dependency."""

    def test_grants_the_purchased_tier_without_any_webhook(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot(), session_state())
        audit = FakeAudit()
        outcome = asyncio.run(service(
            companies=companies, gateway=gateway, audit=audit
        ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))

        assert outcome == "reconciled"
        assert gateway.sessions_read == ["cs_test_123"]
        written = companies.updates[-1]
        assert written.subscription_tier == "operations"
        assert written.subscription_status == "trialing"
        assert "billing.checkout_confirmed" in audit.actions()

    def test_state_still_comes_from_a_live_subscription_read(self) -> None:
        """Same rule as the webhook path: nothing is taken from the return URL
        but the session id itself."""
        companies = FakeCompanies(company())
        gateway = FakeGateway(
            snapshot(status="active", tier=PlanTier.STARTER), session_state()
        )
        asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert gateway.retrieved == ["sub_123"]
        assert companies.updates[-1].subscription_tier == "starter"

    def test_confirming_twice_writes_the_same_state(self) -> None:
        """The completion screen retries, and a webhook may land in between."""
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot(), session_state())
        audit = FakeAudit()
        subject = service(companies=companies, gateway=gateway, audit=audit)
        asyncio.run(subject.confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        first = companies.updates[-1].model_dump()
        asyncio.run(subject.confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert companies.updates[-1].model_dump() == first
        assert audit.actions().count("billing.subscription_changed") == 1

    def test_a_session_without_a_subscription_yet_is_pending_not_a_failure(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot(), session_state(subscription_id=None))
        outcome = asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert outcome == "pending"
        assert companies.updates == []

    def test_refuses_a_session_belonging_to_another_company(self) -> None:
        """Without this, a URL carrying someone else's session id would hand
        this tenant that tenant's plan."""
        gateway = FakeGateway(snapshot(), session_state(company_id="cmp_someone_else"))
        with pytest.raises(BillingError) as error:
            asyncio.run(service(
                companies=FakeCompanies(company()), gateway=gateway, audit=FakeAudit()
            ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert error.value.code == "session_mismatch"
        assert gateway.retrieved == []

    def test_refuses_a_session_with_no_company_reference(self) -> None:
        gateway = FakeGateway(snapshot(), session_state(company_id=None))
        with pytest.raises(BillingError) as error:
            asyncio.run(service(
                companies=FakeCompanies(company()), gateway=gateway, audit=FakeAudit()
            ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert error.value.code == "session_mismatch"

    def test_reports_an_expired_session(self) -> None:
        gateway = FakeGateway(snapshot(), session_state(status="expired"))
        with pytest.raises(BillingError) as error:
            asyncio.run(service(
                companies=FakeCompanies(company()), gateway=gateway, audit=FakeAudit()
            ).confirm_checkout(company_id=COMPANY_ID, session_id="cs_test_123"))
        assert error.value.code == "session_expired"


class TestCheckoutSessionMapping:
    def test_reads_the_company_from_the_client_reference(self) -> None:
        state = checkout_state_from_session(
            {
                "id": "cs_1",
                "object": "checkout.session",
                "client_reference_id": COMPANY_ID,
                "subscription": "sub_9",
                "status": "complete",
                "payment_status": "no_payment_required",
            }
        )
        assert state.company_id == COMPANY_ID
        assert state.subscription_id == "sub_9"
        assert state.status == "complete"

    def test_handles_an_expanded_subscription_object(self) -> None:
        state = checkout_state_from_session(
            {
                "id": "cs_2",
                "client_reference_id": COMPANY_ID,
                "subscription": {"id": "sub_expanded"},
            }
        )
        assert state.subscription_id == "sub_expanded"

    def test_falls_back_to_our_metadata_when_the_reference_is_absent(self) -> None:
        state = checkout_state_from_session(
            {
                "id": "cs_3",
                "subscription": None,
                "metadata": {"fev_company_id": COMPANY_ID},
            }
        )
        assert state.company_id == COMPANY_ID
        assert state.subscription_id is None


class TestSnapshotMapping:
    def test_reads_tier_and_interval_from_our_own_metadata(self) -> None:
        """Never inferred from the price amount -- a repricing must not be able
        to mis-assign a plan."""
        result = snapshot_from_subscription(
            {
                "id": "sub_1",
                "object": "subscription",
                "customer": "cus_1",
                "status": "active",
                "trial_end": None,
                "current_period_end": 123,
                "metadata": {"fev_tier": "field", "fev_interval": "monthly"},
            }
        )
        assert result.tier is PlanTier.FIELD
        assert result.interval is BillingInterval.MONTHLY
        assert result.customer_id == "cus_1"

    def test_handles_an_expanded_customer_object(self) -> None:
        result = snapshot_from_subscription(
            {
                "id": "sub_1",
                "object": "subscription",
                "customer": {"id": "cus_expanded"},
                "status": "active",
                "metadata": {},
            }
        )
        assert result.customer_id == "cus_expanded"

    def test_falls_back_to_the_subscription_item_period_end(self) -> None:
        """Recent Stripe API versions moved `current_period_end` onto the item."""
        result = snapshot_from_subscription(
            {
                "id": "sub_1",
                "object": "subscription",
                "customer": "cus_1",
                "status": "active",
                "items": {"data": [{"current_period_end": 999}]},
                "metadata": {},
            }
        )
        assert result.current_period_end == 999

    def test_unknown_metadata_values_resolve_to_none(self) -> None:
        assert tier_from_metadata({"fev_tier": "platinum"}) is None
        assert tier_from_metadata({}) is None
        assert interval_from_metadata({"fev_interval": "weekly"}) is None


class TestReconciliation:
    def test_checkout_completed_grants_the_purchased_tier(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot())
        audit = FakeAudit()
        outcome = asyncio.run(service(
            companies=companies, gateway=gateway, audit=audit
        ).reconcile_event(
            {
                "id": "evt_1",
                "type": "checkout.session.completed",
                "data": {
                    "object": {
                        "object": "checkout.session",
                        "client_reference_id": COMPANY_ID,
                        "subscription": "sub_123",
                    }
                },
            }
        ))

        assert outcome == "reconciled"
        written = companies.updates[-1]
        assert written.subscription_tier == "operations"
        assert written.subscription_status == "trialing"
        assert written.stripe_subscription_id == "sub_123"
        assert written.stripe_customer_id == "cus_123"
        assert written.trial_ends_at is not None
        assert "billing.subscription_changed" in audit.actions()

    def test_state_comes_from_a_live_read_not_the_event_body(self) -> None:
        """Reconciliation re-reads the subscription, which is what makes it
        idempotent and order-independent. A stale/forged body must not win."""
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot(status="active", tier=PlanTier.STARTER))
        asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).reconcile_event(
            {
                "id": "evt_2",
                "type": "customer.subscription.updated",
                "data": {
                    "object": {
                        "object": "subscription",
                        "id": "sub_123",
                        # Body claims enterprise; the live read says starter.
                        "status": "canceled",
                        "metadata": {
                            "fev_company_id": COMPANY_ID,
                            "fev_tier": "enterprise",
                        },
                    }
                },
            }
        ))
        assert gateway.retrieved == ["sub_123"]
        assert companies.updates[-1].subscription_tier == "starter"
        assert companies.updates[-1].subscription_status == "active"

    def test_replaying_the_same_event_is_idempotent(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot())
        audit = FakeAudit()
        subject = service(companies=companies, gateway=gateway, audit=audit)
        event = {
            "id": "evt_3",
            "type": "customer.subscription.created",
            "data": {
                "object": {
                    "object": "subscription",
                    "id": "sub_123",
                    "metadata": {"fev_company_id": COMPANY_ID},
                }
            },
        }
        asyncio.run(subject.reconcile_event(event))
        first = companies.updates[-1].model_dump()
        asyncio.run(subject.reconcile_event(event))
        assert companies.updates[-1].model_dump() == first
        # The tier/status did not change the second time, so no second audit.
        assert audit.actions().count("billing.subscription_changed") == 1

    def test_cancellation_removes_entitlement(self) -> None:
        companies = FakeCompanies(company(tier="operations", status="active"))
        gateway = FakeGateway(snapshot(status="canceled", trial_end=None))
        asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).reconcile_event(
            {
                "id": "evt_4",
                "type": "customer.subscription.deleted",
                "data": {
                    "object": {
                        "object": "subscription",
                        "id": "sub_123",
                        "metadata": {"fev_company_id": COMPANY_ID},
                    }
                },
            }
        ))
        assert companies.updates[-1].subscription_status == "canceled"

    def test_missing_tier_metadata_keeps_the_existing_tier(self) -> None:
        """Guessing a tier from the price would risk granting or removing real
        modules, so an unlabelled subscription leaves the plan alone."""
        companies = FakeCompanies(company(tier="field", status="active"))
        gateway = FakeGateway(snapshot(status="past_due", tier=None, interval=None))
        asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).reconcile_event(
            {
                "id": "evt_5",
                "type": "invoice.payment_failed",
                "data": {
                    "object": {
                        "object": "invoice",
                        "subscription": "sub_123",
                        "metadata": {"fev_company_id": COMPANY_ID},
                    }
                },
            }
        ))
        assert companies.updates[-1].subscription_tier == "field"
        assert companies.updates[-1].subscription_status == "past_due"

    def test_irrelevant_events_are_ignored_without_a_stripe_read(self) -> None:
        gateway = FakeGateway()
        outcome = asyncio.run(service(
            companies=FakeCompanies(company()), gateway=gateway, audit=FakeAudit()
        ).reconcile_event({"id": "evt_6", "type": "customer.created", "data": {"object": {}}}))
        assert outcome == "ignored"
        assert gateway.retrieved == []

    def test_an_event_with_no_company_reference_is_unresolved_not_an_error(self) -> None:
        """Returning an error would make Stripe retry an event we can never
        process, forever."""
        outcome = asyncio.run(service(
            companies=FakeCompanies(company()), gateway=FakeGateway(), audit=FakeAudit()
        ).reconcile_event(
            {
                "id": "evt_7",
                "type": "customer.subscription.updated",
                "data": {"object": {"object": "subscription", "id": "sub_x", "metadata": {}}},
            }
        ))
        assert outcome == "unresolved"

    def test_an_unknown_company_is_logged_not_raised(self) -> None:
        companies = FakeCompanies(company())
        gateway = FakeGateway(snapshot())
        asyncio.run(service(
            companies=companies, gateway=gateway, audit=FakeAudit()
        ).reconcile_event(
            {
                "id": "evt_8",
                "type": "customer.subscription.updated",
                "data": {
                    "object": {
                        "object": "subscription",
                        "id": "sub_123",
                        "metadata": {"fev_company_id": "cmp_someone_else"},
                    }
                },
            }
        ))
        assert companies.updates == []

    def test_the_reconciling_event_set_covers_the_lifecycle(self) -> None:
        for event_type in (
            "checkout.session.completed",
            "customer.subscription.created",
            "customer.subscription.updated",
            "customer.subscription.deleted",
            "invoice.payment_failed",
        ):
            assert event_type in RECONCILING_EVENTS


class TestDescribe:
    def test_returns_the_plan_summary(self) -> None:
        companies = FakeCompanies(company(tier="operations", status="trialing"))
        result = asyncio.run(service(
            companies=companies, gateway=FakeGateway(), audit=FakeAudit()
        ).describe(COMPANY_ID))
        assert result["tier"] == "operations"
        assert result["plan_name"] == "Operations"
        assert result["status"] == "trialing"

    def test_an_unassigned_company_has_no_plan_name(self) -> None:
        companies = FakeCompanies(company())
        result = asyncio.run(service(
            companies=companies, gateway=FakeGateway(), audit=FakeAudit()
        ).describe(COMPANY_ID))
        assert result["plan_name"] is None


class TestBillingAdminGate:
    """`/checkout` deliberately does not require a verified email.

    The signup flow is details -> pay -> use, and a company created seconds ago
    always has an unverified admin. Demanding a mailbox round trip first would
    strand every new tenant at the one step that makes them a customer. What is
    *not* relaxed is the permission, and every module route keeps its
    verified-email gate.
    """

    @staticmethod
    def _user(*, permissions: set[str], verified: bool) -> CurrentUser:
        return CurrentUser(
            uid="firebase-uid",
            email="admin@acme.example.invalid",
            email_verified=verified,
            company_id=COMPANY_ID,
            company_name="Acme Energy",
            company_timezone="UTC",
            company_locale="en-US",
            role_key="company_admin",
            permissions=frozenset(permissions),
        )

    def test_allows_an_unverified_company_admin(self) -> None:
        user = self._user(permissions={"company.settings"}, verified=False)
        assert asyncio.run(require_billing_admin(user)) is user

    def test_still_requires_the_company_settings_permission(self) -> None:
        user = self._user(permissions={"assets.read"}, verified=True)
        with pytest.raises(HTTPException) as error:
            asyncio.run(require_billing_admin(user))
        assert error.value.status_code == 403

    def test_entitlements_resolve_for_an_unverified_admin(self) -> None:
        """The signup completion page polls the subscription while the new
        admin is still unverified, so this must not 403."""
        resolved = resolve_entitlements(company(tier="operations", status="trialing"))
        assert resolved.is_entitled is True
        assert resolved.is_trialing is True
