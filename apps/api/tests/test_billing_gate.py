"""The entitlement gate as the API actually enforces it.

Phase 13.1 defined `require_feature` and 13.7 applied it to every module router.
Until it was applied the gate was decorative: hiding a module in the two clients
is UX, and an entry-tier tenant could still call the route directly. These cases
pin the server half.

The two gates are independent, and that is the point of most of what follows: an
entry-tier tenant's Company Admin holds every permission and must still be
refused the modules its plan omits, with a 402 that names the tier which unlocks
them. Since D-107 the only module an entry tier omits is permit-to-work — work
orders and AR inspection are core product on every paid tier — so the gate is
exercised against permits, and work orders are now checked for the opposite:
that Pilot can reach them.
"""

from collections.abc import Iterator
from typing import Any
from unittest.mock import AsyncMock

import pytest
from fastapi.testclient import TestClient

from app.auth.dependencies import get_current_user, require_verified_email
from app.billing.dependencies import get_entitlements
from app.billing.plans import PLANS, Feature, PlanTier, cheapest_tier_with
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit

from .conftest import entitlements_for

COMPANY_ID = "acme-energy"

#: Routes that must be refused on a plan without the module. One read per
#: gated router, since the gate is applied at router level.
GATED_READS = [
    ("/api/v1/permits", Feature.PERMITS),
    ("/api/v1/permit-templates", Feature.PERMITS),
]

#: Core modules every paid tier includes; these must stay reachable on Pilot,
#: the cheapest plan anyone can buy. Work orders are on this list since D-107:
#: a customer proving the platform on one site needs the real workflow, not a
#: demonstration of it.
BASE_READS = [
    "/api/v1/assets",
    "/api/v1/inspections",
    "/api/v1/checklist-templates",
    "/api/v1/safety-reports",
    "/api/v1/reports",
    "/api/v1/documents",
    "/api/v1/work-orders",
]


def company_admin() -> CurrentUser:
    """Holds every permission the Company Admin template grants, so any refusal
    below is an entitlement decision and never a permission one."""
    return CurrentUser(
        uid="firebase-uid",
        email="company_admin@acme.example.invalid",
        email_verified=True,
        company_id=COMPANY_ID,
        company_name="Acme Energy",
        company_timezone="UTC",
        company_locale="en-US",
        role_key="company_admin",
        permissions=frozenset(SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys),
    )


@pytest.fixture
def client_on() -> Iterator[Any]:
    """Yields a factory: pick the tier, get a client authenticated as its admin."""
    identity = company_admin()
    audit = AsyncMock()

    app.dependency_overrides[get_current_user] = lambda: identity
    app.dependency_overrides[require_verified_email] = lambda: identity
    app.dependency_overrides[get_access_denial_audit] = lambda: audit

    def make(tier: PlanTier, *, status: str = "active") -> TestClient:
        app.dependency_overrides[get_entitlements] = lambda: entitlements_for(
            tier, status=status
        )
        return TestClient(app, raise_server_exceptions=False)

    yield make

    for dependency in (
        get_current_user,
        require_verified_email,
        get_entitlements,
        get_access_denial_audit,
    ):
        app.dependency_overrides.pop(dependency, None)


class TestPlanGatedModules:
    @pytest.mark.parametrize(("path", "feature"), GATED_READS)
    def test_an_entry_tier_is_refused_with_402_and_an_upgrade_target(
        self, client_on: Any, path: str, feature: Feature
    ) -> None:
        response = client_on(PlanTier.PILOT).get(path)

        # 402, not 403: the caller is allowed, the company has not bought it.
        assert response.status_code == 402, (path, response.text)
        body = response.json()
        assert body["error"] == "plan_upgrade_required"
        details = body["details"]
        assert details["current_tier"] == "pilot"
        # The response names a real plan so the client can offer an upgrade
        # rather than a dead end.
        assert details["required_tier"] == cheapest_tier_with(feature).value
        assert details["required_tier_name"] == PLANS[cheapest_tier_with(feature)].name

    @pytest.mark.parametrize(("path", "feature"), GATED_READS)
    def test_operations_reaches_the_same_routes(
        self, client_on: Any, path: str, feature: Feature
    ) -> None:
        response = client_on(PlanTier.OPERATIONS).get(path)
        assert response.status_code != 402, (path, response.text)

    @pytest.mark.parametrize("path", BASE_READS)
    def test_core_modules_stay_open_on_the_cheapest_tier(
        self, client_on: Any, path: str
    ) -> None:
        response = client_on(PlanTier.PILOT).get(path)
        assert response.status_code != 402, (path, response.text)

    def test_work_orders_are_reachable_on_every_paid_tier(self, client_on: Any) -> None:
        # The D-107 commitment, enforced rather than described: an upgrade can
        # never take work orders away, because no paid tier is without them.
        for tier in (PlanTier.PILOT, PlanTier.STARTER, PlanTier.FIELD, PlanTier.OPERATIONS):
            response = client_on(tier).get("/api/v1/work-orders")
            assert response.status_code != 402, (tier, response.text)

    def test_field_is_gated_exactly_like_starter(self, client_on: Any) -> None:
        # Field buys capacity, not capability.
        response = client_on(PlanTier.FIELD).get("/api/v1/permits")
        assert response.status_code == 402


class TestSubscriptionState:
    def test_an_unpaid_company_is_refused_every_module(self, client_on: Any) -> None:
        client = client_on(PlanTier.STARTER, status="incomplete")
        for path in [*BASE_READS, *(path for path, _ in GATED_READS)]:
            response = client.get(path)
            assert response.status_code == 402, path
            assert response.json()["error"] == "subscription_inactive"

    def test_a_cancelled_company_loses_access(self, client_on: Any) -> None:
        response = client_on(PlanTier.OPERATIONS, status="canceled").get(
            "/api/v1/assets"
        )
        assert response.status_code == 402
        assert response.json()["error"] == "subscription_inactive"

    def test_a_past_due_company_keeps_working(self, client_on: Any) -> None:
        # Stripe retries a failed invoice for weeks; locking an operator out of
        # its permit and safety records over an expired card would be dangerous.
        client = client_on(PlanTier.OPERATIONS, status="past_due")
        assert client.get("/api/v1/assets").status_code != 402
        assert client.get("/api/v1/permits").status_code != 402

    def test_a_trialing_company_has_full_access_to_its_plan(
        self, client_on: Any
    ) -> None:
        client = client_on(PlanTier.OPERATIONS, status="trialing")
        assert client.get("/api/v1/work-orders").status_code != 402


class TestUngatedRoutes:
    """Account and billing surfaces must not depend on the plan, or an unpaid
    company could neither see why it is blocked nor fix it."""

    @pytest.mark.parametrize(
        "path",
        [
            "/api/v1/auth/me",
            "/api/v1/billing/subscription",
            "/api/v1/billing/catalog",
            "/api/v1/dashboard/summary",
            "/api/v1/users",
            "/api/v1/company",
        ],
    )
    def test_reachable_without_an_active_subscription(
        self, client_on: Any, path: str
    ) -> None:
        response = client_on(PlanTier.STARTER, status="incomplete").get(path)
        assert response.status_code != 402, (path, response.text)


class TestCatalogConsistency:
    def test_every_gated_route_maps_to_a_real_catalog_feature(self) -> None:
        for _, feature in GATED_READS:
            tier = cheapest_tier_with(feature)
            assert tier is not None, feature
            assert PLANS[tier].has(feature)

    def test_the_entry_tiers_omit_exactly_permit_to_work(self) -> None:
        # Guards the D-107 shape: everything below Operations is the same
        # product at different capacities, and Operations adds one module.
        operations_only = PLANS[PlanTier.OPERATIONS].features - PLANS[PlanTier.PILOT].features
        assert operations_only == {Feature.PERMITS}
        assert (
            PLANS[PlanTier.PILOT].features
            == PLANS[PlanTier.STARTER].features
            == PLANS[PlanTier.FIELD].features
        )

    def test_no_upgrade_ever_removes_a_module(self) -> None:
        # The property the whole ladder rests on. Asserted over the real tier
        # order rather than spot-checked, so a future tier cannot break it.
        from app.billing.plans import TIER_ORDER

        for lower, higher in zip(TIER_ORDER, TIER_ORDER[1:], strict=False):
            missing = PLANS[lower].features - PLANS[higher].features
            assert not missing, f"upgrading {lower} -> {higher} would remove {missing}"
