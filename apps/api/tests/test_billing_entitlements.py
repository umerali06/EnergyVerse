"""Entitlement resolution and the plan catalog.

The catalog assertions are deliberately literal: the prices and quotas are
published on the public pricing page and charged through Stripe, so a typo here
is a commercial defect, not a styling one. Every number below is checked
against requirements §22.1.
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest

from app.billing.entitlements import (
    ENTITLED_STATUSES,
    QuotaExceededError,
    SubscriptionStatus,
    assert_within_quota,
    next_tier_above,
    parse_status,
    resolve_entitlements,
    upgrade_hint,
)
from app.billing.plans import (
    BASE_FEATURES,
    PLANS,
    TIER_ORDER,
    TRIAL_DAYS,
    BillingInterval,
    Feature,
    PlanTier,
    cheapest_tier_with,
    get_plan,
)
from app.models.entities import Company

NOW = datetime(2026, 9, 8, 12, 0, tzinfo=UTC)


def company(
    *,
    tier: str = "operations",
    status: str = "active",
    trial_ends_at: datetime | None = None,
) -> Company:
    return Company(
        id="cmp_test",
        name="Test Operator",
        status="active",
        subscription_tier=tier,
        subscription_status=status,
        trial_ends_at=trial_ends_at,
        created_at=NOW,
        updated_at=NOW,
    )


class TestPlanCatalog:
    """§22.1 — the published tiers."""

    @pytest.mark.parametrize(
        ("tier", "list_monthly", "annual_total"),
        [
            (PlanTier.STARTER, 99_799, 1_197_588),
            (PlanTier.FIELD, 299_799, 3_597_588),
            (PlanTier.OPERATIONS, 999_799, 11_997_588),
            (PlanTier.ENTERPRISE, 2_999_799, 35_997_588),
        ],
    )
    def test_prices_match_the_requirements_document(
        self, tier: PlanTier, list_monthly: int, annual_total: int
    ) -> None:
        plan = PLANS[tier]
        assert plan.list_monthly_cents == list_monthly
        assert plan.annual_total_cents == annual_total
        # The annual total must be exactly twelve months at the list price;
        # the ~15% premium applies only to monthly billing.
        assert plan.annual_total_cents == plan.list_monthly_cents * 12

    @pytest.mark.parametrize(
        ("tier", "facilities", "assets", "seats"),
        [
            (PlanTier.STARTER, 1, 150, 5),
            (PlanTier.FIELD, 1, 500, 15),
            (PlanTier.OPERATIONS, 5, 2_500, 75),
            (PlanTier.ENTERPRISE, None, None, None),
        ],
    )
    def test_quotas_match_the_requirements_document(
        self,
        tier: PlanTier,
        facilities: int | None,
        assets: int | None,
        seats: int | None,
    ) -> None:
        quotas = PLANS[tier].quotas
        assert quotas.facilities == facilities
        assert quotas.assets == assets
        assert quotas.seats == seats

    def test_monthly_billing_carries_the_premium_over_the_list_price(self) -> None:
        for plan in PLANS.values():
            assert plan.monthly_cents > plan.list_monthly_cents
            premium = plan.monthly_cents / plan.list_monthly_cents
            assert 1.14 < premium < 1.16

    def test_ar_permits_and_work_orders_start_at_operations(self) -> None:
        """The commercial line that shapes the whole UI: Starter and Field have
        no AR inspection, no permits, and no work orders (§22.1)."""
        gated = (Feature.AR_INSPECTION, Feature.PERMITS, Feature.WORK_ORDERS)
        for feature in gated:
            assert not PLANS[PlanTier.STARTER].has(feature)
            assert not PLANS[PlanTier.FIELD].has(feature)
            assert PLANS[PlanTier.OPERATIONS].has(feature)
            assert PLANS[PlanTier.ENTERPRISE].has(feature)
            assert cheapest_tier_with(feature) is PlanTier.OPERATIONS

    def test_vr_sso_and_audit_export_are_enterprise_only(self) -> None:
        for feature in (Feature.VR_TRAINING, Feature.SSO, Feature.AUDIT_EXPORT):
            assert cheapest_tier_with(feature) is PlanTier.ENTERPRISE
            assert not PLANS[PlanTier.OPERATIONS].has(feature)

    def test_every_paid_tier_includes_the_base_modules(self) -> None:
        for tier in TIER_ORDER:
            assert BASE_FEATURES <= PLANS[tier].features

    def test_features_only_grow_up_the_tier_order(self) -> None:
        """A higher tier must never lose a module a cheaper one had, or an
        upgrade could silently remove access."""
        for lower, higher in zip(TIER_ORDER, TIER_ORDER[1:], strict=False):
            assert PLANS[lower].features <= PLANS[higher].features

    def test_digital_twin_scope_widens_at_operations(self) -> None:
        assert PLANS[PlanTier.STARTER].digital_twin_scope == "single"
        assert PLANS[PlanTier.FIELD].digital_twin_scope == "single"
        assert PLANS[PlanTier.OPERATIONS].digital_twin_scope == "all"
        assert PLANS[PlanTier.ENTERPRISE].digital_twin_scope == "all"

    def test_price_for_interval_selects_the_right_amount(self) -> None:
        plan = PLANS[PlanTier.FIELD]
        assert plan.price_cents(BillingInterval.ANNUAL) == plan.annual_total_cents
        assert plan.price_cents(BillingInterval.MONTHLY) == plan.monthly_cents

    def test_trial_is_seven_days(self) -> None:
        assert TRIAL_DAYS == 7

    def test_unassigned_and_legacy_tiers_resolve_to_no_plan(self) -> None:
        """Companies created before Phase 13 hold `unassigned`, and the old API
        literal allowed `demo`/`professional`, which were never published."""
        assert get_plan("unassigned") is None
        assert get_plan("demo") is None
        assert get_plan("professional") is None
        assert get_plan("nonsense") is None


class TestResolveEntitlements:
    def test_active_subscription_grants_the_plan_features(self) -> None:
        result = resolve_entitlements(company(tier="operations", status="active"))
        assert result.is_entitled
        assert result.tier is PlanTier.OPERATIONS
        assert result.has(Feature.WORK_ORDERS)
        assert not result.has(Feature.VR_TRAINING)

    def test_a_lower_tier_is_refused_the_gated_modules(self) -> None:
        result = resolve_entitlements(company(tier="starter", status="active"))
        assert result.is_entitled
        assert result.has(Feature.INSPECTIONS)
        assert not result.has(Feature.WORK_ORDERS)
        assert not result.has(Feature.PERMITS)
        assert not result.has(Feature.AR_INSPECTION)

    def test_trialing_grants_full_access_to_the_chosen_plan(self) -> None:
        result = resolve_entitlements(
            company(status="trialing", trial_ends_at=NOW + timedelta(days=5))
        )
        assert result.is_entitled
        assert result.is_trialing
        assert result.has(Feature.WORK_ORDERS)

    def test_past_due_still_grants_access(self) -> None:
        """Deliberate: locking an operator out of live permit and safety records
        over a failed card would be unsafe. The portal shows a banner instead."""
        result = resolve_entitlements(company(status="past_due"))
        assert result.is_entitled
        assert SubscriptionStatus.PAST_DUE in ENTITLED_STATUSES

    @pytest.mark.parametrize("status", ["incomplete", "canceled"])
    def test_unpaid_states_grant_nothing(self, status: str) -> None:
        result = resolve_entitlements(company(status=status))
        assert not result.is_entitled
        assert result.features == frozenset()
        for feature in Feature:
            assert not result.has(feature)

    def test_an_unassigned_tier_grants_nothing_even_when_marked_active(self) -> None:
        """A half-finished signup must not read tenant data just because some
        other process stamped the status."""
        result = resolve_entitlements(company(tier="unassigned", status="active"))
        assert not result.is_entitled
        assert result.tier is PlanTier.UNASSIGNED
        assert result.features == frozenset()

    def test_unknown_status_text_fails_closed(self) -> None:
        assert parse_status("something-else") is SubscriptionStatus.INCOMPLETE
        assert parse_status(None) is SubscriptionStatus.INCOMPLETE
        assert not resolve_entitlements(company(status="something-else")).is_entitled

    def test_trial_days_remaining_counts_whole_days_and_floors_at_zero(self) -> None:
        result = resolve_entitlements(
            company(status="trialing", trial_ends_at=NOW + timedelta(days=3, hours=2))
        )
        assert result.trial_days_remaining(NOW) == 4
        expired = resolve_entitlements(
            company(status="trialing", trial_ends_at=NOW - timedelta(days=1))
        )
        assert expired.trial_days_remaining(NOW) == 0

    def test_trial_days_remaining_is_none_when_not_trialing(self) -> None:
        """`None` distinguishes "not on a trial" from "trial ends today", which
        the dashboard renders very differently."""
        assert resolve_entitlements(company(status="active")).trial_days_remaining(NOW) is None


class TestQuotas:
    def test_create_is_allowed_below_the_limit(self) -> None:
        entitlements = resolve_entitlements(company(tier="starter", status="active"))
        assert_within_quota(entitlements, resource="assets", current_count=149)

    def test_create_is_refused_at_the_limit(self) -> None:
        entitlements = resolve_entitlements(company(tier="starter", status="active"))
        with pytest.raises(QuotaExceededError) as error:
            assert_within_quota(entitlements, resource="assets", current_count=150)
        assert error.value.resource == "assets"
        assert error.value.limit == 150
        assert error.value.tier is PlanTier.STARTER
        assert error.value.upgrade_tier is PlanTier.FIELD

    def test_enterprise_is_unlimited(self) -> None:
        entitlements = resolve_entitlements(company(tier="enterprise", status="active"))
        assert entitlements.limit_for("assets") is None
        assert_within_quota(entitlements, resource="assets", current_count=1_000_000)

    def test_an_unentitled_company_has_a_zero_quota(self) -> None:
        entitlements = resolve_entitlements(company(status="canceled"))
        assert entitlements.limit_for("assets") == 0
        with pytest.raises(QuotaExceededError):
            assert_within_quota(entitlements, resource="assets", current_count=0)

    def test_next_tier_above_walks_the_order_then_stops(self) -> None:
        assert next_tier_above(PlanTier.STARTER) is PlanTier.FIELD
        assert next_tier_above(PlanTier.OPERATIONS) is PlanTier.ENTERPRISE
        assert next_tier_above(PlanTier.ENTERPRISE) is None
        assert next_tier_above(PlanTier.UNASSIGNED) is PlanTier.STARTER


class TestUpgradeHint:
    def test_names_the_tier_that_unlocks_the_feature(self) -> None:
        hint = upgrade_hint(Feature.WORK_ORDERS)
        assert hint["feature"] == "work_orders"
        assert hint["required_tier"] == "operations"
        assert hint["required_tier_name"] == "Operations"

    def test_base_features_point_at_the_cheapest_tier(self) -> None:
        assert upgrade_hint(Feature.ASSETS)["required_tier"] == "starter"
