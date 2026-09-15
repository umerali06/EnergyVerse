"""The billing routes as HTTP, not as services.

`test_billing_stripe.py` covers `SubscriptionService` directly, which is where
the reconciliation rules belong. That left a real gap: nothing exercised the
route layer — the dependency wiring, the status codes, and the response
assembly — and a live run against real Stripe test keys found a defect sitting
exactly there. `_subscription_response` had been left calling itself, so
`POST /billing/checkout/confirm` answered 500 with a `RecursionError` on every
request, while the service beneath it was perfectly correct and every
service-level test passed.

The lesson these cases encode: a helper shared by two routes needs a test
through at least one of them, because a service test cannot see the route that
calls it.
"""

from collections.abc import Iterator
from types import SimpleNamespace
from typing import Any
from unittest.mock import AsyncMock

import pytest
from fastapi.testclient import TestClient

from app.api.v1.billing import get_subscription_service
from app.auth.dependencies import get_current_user, require_verified_email
from app.billing.dependencies import get_company_repository, get_entitlements
from app.billing.plans import PlanTier
from app.billing.service import BillingError
from app.main import app
from app.models.entities import Company, CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES

from .conftest import entitlements_for
from .test_billing_stripe import NOW

COMPANY_ID = "acme-energy"
CATALOG = "/api/v1/billing/catalog"


def company_admin(*, permissions: set[str] | None = None) -> CurrentUser:
    return CurrentUser(
        uid="firebase-uid",
        email="company_admin@acme.example.invalid",
        email_verified=True,
        company_id=COMPANY_ID,
        company_name="Acme Energy",
        company_timezone="UTC",
        company_locale="en-US",
        role_key="company_admin",
        permissions=frozenset(
            permissions
            if permissions is not None
            else SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys
        ),
    )


def company(*, tier: str = "operations", status: str = "trialing") -> Company:
    return Company(
        id=COMPANY_ID,
        name="Acme Energy",
        status="active",
        subscription_tier=tier,
        subscription_status=status,
        created_at=NOW,
        updated_at=NOW,
    )


class FakeCompanies:
    def __init__(self, record: Company | None) -> None:
        self._record = record

    async def get(self, scope: Any) -> Company | None:
        return self._record


@pytest.fixture
def billing_client() -> Iterator[Any]:
    """Yields a factory taking the confirm outcome (or an error to raise) and
    the company state the handler will re-read afterwards."""
    identity = company_admin()
    app.dependency_overrides[get_current_user] = lambda: identity
    app.dependency_overrides[require_verified_email] = lambda: identity
    app.dependency_overrides[get_entitlements] = lambda: entitlements_for(
        PlanTier.OPERATIONS, status="trialing"
    )

    def make(
        *,
        outcome: str | Exception = "reconciled",
        record: Company | None = None,
        user: CurrentUser | None = None,
    ) -> TestClient:
        if user is not None:
            app.dependency_overrides[get_current_user] = lambda: user
            app.dependency_overrides[require_verified_email] = lambda: user
        service = AsyncMock()
        if isinstance(outcome, Exception):
            service.confirm_checkout.side_effect = outcome
        else:
            service.confirm_checkout.return_value = outcome
        app.dependency_overrides[get_subscription_service] = lambda: service
        app.dependency_overrides[get_company_repository] = lambda: FakeCompanies(
            company() if record is None else record
        )
        client = TestClient(app, raise_server_exceptions=False)
        client.service = service  # type: ignore[attr-defined]
        return client

    yield make

    for dependency in (
        get_current_user,
        require_verified_email,
        get_entitlements,
        get_subscription_service,
        get_company_repository,
    ):
        app.dependency_overrides.pop(dependency, None)


class TestConfirmCheckoutRoute:
    def test_returns_the_freshly_resolved_plan(self, billing_client: Any) -> None:
        """The regression this file exists for: this answered 500 before, and
        no service-level test could see it."""
        client = billing_client()

        response = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_test_123"}
        )

        assert response.status_code == 200, response.text
        body = response.json()
        assert body["outcome"] == "reconciled"
        plan = body["subscription"]
        assert plan["tier"] == "operations"
        assert plan["status"] == "trialing"
        assert plan["is_entitled"] is True
        assert "work_orders" in plan["features"]
        client.service.confirm_checkout.assert_awaited_once_with(
            company_id=COMPANY_ID, session_id="cs_test_123"
        )

    def test_the_echoed_plan_matches_the_read_model_exactly(
        self, billing_client: Any
    ) -> None:
        """Both come from `_subscription_response`; if they ever disagree the
        completion screen and the shell would show different plans."""
        client = billing_client()

        confirmed = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_test_123"}
        ).json()["subscription"]
        read = client.get("/api/v1/billing/subscription").json()

        assert confirmed == read

    def test_reads_the_company_after_confirming_not_before(
        self, billing_client: Any
    ) -> None:
        """The injected entitlements resolved before the write, so reusing them
        would report a company that just paid as still unsubscribed. Here the
        dependency says `unassigned` and the re-read says `operations`."""
        app.dependency_overrides[get_entitlements] = lambda: entitlements_for(
            PlanTier.UNASSIGNED, status="incomplete"
        )
        client = billing_client(record=company(tier="operations", status="trialing"))

        body = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_test_123"}
        ).json()

        assert body["subscription"]["tier"] == "operations"
        assert body["subscription"]["is_entitled"] is True

    def test_pending_is_a_200_with_an_unentitled_plan(self, billing_client: Any) -> None:
        client = billing_client(
            outcome="pending", record=company(tier="unassigned", status="incomplete")
        )

        response = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_test_123"}
        )

        # Stripe has the session but has not attached a subscription yet. The
        # completion screen retries on this; an error would end the flow.
        assert response.status_code == 200
        assert response.json()["outcome"] == "pending"
        assert response.json()["subscription"]["is_entitled"] is False

    def test_a_mismatched_session_is_400_not_500(self, billing_client: Any) -> None:
        client = billing_client(
            outcome=BillingError("session_mismatch", "Not this company's session")
        )

        response = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_someone_else"}
        )

        assert response.status_code == 400
        assert response.json()["error"] == "session_mismatch"

    def test_requires_the_company_settings_permission(self, billing_client: Any) -> None:
        client = billing_client(user=company_admin(permissions={"assets.read"}))

        response = client.post(
            "/api/v1/billing/checkout/confirm", json={"session_id": "cs_test_123"}
        )

        assert response.status_code == 403
        client.service.confirm_checkout.assert_not_awaited()

    def test_rejects_an_empty_session_id(self, billing_client: Any) -> None:
        client = billing_client()

        response = client.post("/api/v1/billing/checkout/confirm", json={"session_id": ""})

        assert response.status_code == 422
        client.service.confirm_checkout.assert_not_awaited()


class TestSubscriptionRoute:
    def test_reports_an_unentitled_company_without_failing(
        self, billing_client: Any
    ) -> None:
        """The state every new company is in between verifying and paying; the
        admin shell reads exactly this to send them to the plan step."""
        app.dependency_overrides[get_entitlements] = lambda: entitlements_for(
            PlanTier.UNASSIGNED, status="incomplete"
        )
        client = billing_client()

        response = client.get("/api/v1/billing/subscription")

        assert response.status_code == 200
        body = response.json()
        assert body["is_entitled"] is False
        assert body["features"] == []
        # Zero, not unlimited: an unentitled company fails closed.
        assert body["quotas"]["assets"] == 0


class TestCatalogRoute:
    """What the pricing page and the checkout picker actually receive.

    Public, so these run without any auth override -- and that is deliberate:
    a prospective customer has no account, and a catalog they cannot read is a
    pricing page that cannot render.

    Asserted in snake_case, which is what the API emits; the camelCase the
    clients see is the generated client's doing, and `serialization.test.ts`
    guards that side (D-095).
    """

    def test_publishes_every_tier_cheapest_first(self) -> None:
        body = TestClient(app).get("/api/v1/billing/catalog").json()

        assert [plan["tier"] for plan in body["plans"]] == [
            "pilot",
            "starter",
            "field",
            "operations",
            "enterprise",
        ]
        assert body["trial_days"] == 7
        assert body["annual_months_charged"] == 10

    def test_the_prices_on_the_wire_are_the_published_ones(self) -> None:
        plans = {plan["tier"]: plan for plan in TestClient(app).get(CATALOG).json()["plans"]}

        assert plans["pilot"]["monthly_cents"] == 49_900
        assert plans["starter"]["monthly_cents"] == 99_900
        assert plans["field"]["monthly_cents"] == 199_900
        assert plans["operations"]["monthly_cents"] == 499_900
        # Both figures reach the client, so a checkout can show what a year
        # costs beside what a month costs without computing either itself.
        assert plans["starter"]["annual_total_cents"] == 999_000
        assert plans["starter"]["annual_monthly_equivalent_cents"] == 83_250

    def test_enterprise_carries_a_floor_and_no_buyable_price(self) -> None:
        plans = {plan["tier"]: plan for plan in TestClient(app).get(CATALOG).json()["plans"]}
        enterprise = plans["enterprise"]

        assert enterprise["self_serve"] is False
        assert enterprise["custom_quoted"] is True
        assert enterprise["monthly_cents"] is None
        assert enterprise["annual_total_cents"] is None
        assert enterprise["starting_monthly_cents"] == 999_900
        # The old published figure must not reappear anywhere on the wire: the
        # product owner asked specifically that it stop being shown.
        assert "2999799" not in TestClient(app).get(CATALOG).text

    def test_the_quote_factors_are_published(self) -> None:
        factors = TestClient(app).get(CATALOG).json()["enterprise_quote_factors"]
        assert "number of facilities" in factors
        assert "support SLA" in factors


class TestCheckoutRoute:
    def test_a_custom_quoted_tier_cannot_be_bought_with_a_card(
        self, billing_client: Any
    ) -> None:
        """Enterprise has no Stripe Price, so a checkout against it would fail
        somewhere worse. It is refused here, at the edge, with a reason a client
        can turn into "talk to sales" rather than a generic failure."""
        client = billing_client()
        client.service.start_checkout.side_effect = BillingError(
            "plan_requires_sales", "Enterprise is custom-quoted. Contact sales for a quote."
        )

        response = client.post(
            "/api/v1/billing/checkout",
            json={"tier": "enterprise", "interval": "monthly"},
        )

        assert response.status_code == 400
        assert response.json()["error"] == "plan_requires_sales"

    def test_a_self_serve_tier_still_opens_a_session(self, billing_client: Any) -> None:
        client = billing_client()
        client.service.start_checkout.return_value = SimpleNamespace(
            id="cs_test_123", url="https://checkout.stripe.test/cs_test_123"
        )

        response = client.post(
            "/api/v1/billing/checkout",
            json={"tier": "pilot", "interval": "monthly"},
        )

        assert response.status_code == 200, response.text
        assert response.json()["session_id"] == "cs_test_123"
