"""Entitlement resolution and the plan catalog.

The catalog assertions are deliberately literal: the prices and quotas are
published on the public pricing page and charged through Stripe, so a typo here
is a commercial defect, not a styling one. Every number below is the launch
pricing agreed with the product owner on 2026-09-15 (D-107).
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
    ANNUAL_MONTHS_CHARGED,
    CORE_FEATURES,
    PLANS,
    SELF_SERVE_TIERS,
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
    """The published tiers (D-107)."""

    @pytest.mark.parametrize(
        ("tier", "monthly", "annual_total"),
        [
            (PlanTier.PILOT, 49_900, 499_000),
            (PlanTier.STARTER, 99_900, 999_000),
            (PlanTier.FIELD, 199_900, 1_999_000),
            (PlanTier.OPERATIONS, 499_900, 4_999_000),
        ],
    )
    def test_the_published_prices_are_what_is_charged(
        self, tier: PlanTier, monthly: int, annual_total: int
    ) -> None:
        plan = PLANS[tier]
        assert plan.monthly_cents == monthly
        assert plan.annual_total_cents == annual_total
        # The quoted figure is the monthly price, and a year is ten months of
        # it. If this ever drifts, a customer is charged something other than
        # the two numbers printed beside each other on the pricing page.
        assert plan.annual_total_cents == monthly * ANNUAL_MONTHS_CHARGED

    def test_annual_is_two_months_free_on_every_self_serve_tier(self) -> None:
        assert ANNUAL_MONTHS_CHARGED == 10
        for tier in SELF_SERVE_TIERS:
            plan = PLANS[tier]
            assert plan.monthly_cents is not None
            assert plan.annual_total_cents == plan.monthly_cents * 10
            # And never the other way round: annual must be the cheaper way to
            # buy twelve months, or the incentive is a penalty.
            assert plan.annual_total_cents < plan.monthly_cents * 12

    @pytest.mark.parametrize(
        ("tier", "facilities", "assets", "seats"),
        [
            (PlanTier.PILOT, 1, 100, 5),
            (PlanTier.STARTER, 1, 250, 10),
            (PlanTier.FIELD, 2, 750, 25),
            (PlanTier.OPERATIONS, 5, 2_500, 75),
            (PlanTier.ENTERPRISE, None, None, None),
        ],
    )
    def test_quotas_match_the_published_allowances(
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

    def test_quotas_only_grow_up_the_tier_order(self) -> None:
        """Capacity is the ladder, so it must never step down."""
        for lower, higher in zip(TIER_ORDER, TIER_ORDER[1:], strict=False):
            for resource in ("facilities", "assets", "seats"):
                low = PLANS[lower].quotas.limit_for(resource)
                high = PLANS[higher].quotas.limit_for(resource)
                if high is None:  # unlimited beats any number
                    continue
                assert low is not None, f"{lower} is unlimited but {higher} is not"
                assert low <= high, f"{resource} shrinks from {lower} to {higher}"

    def test_the_core_product_starts_at_pilot(self) -> None:
        """The commercial line that shapes the whole UI: every paid tier gets
        AI analysis, AR inspection, work orders and reports, so a customer can
        prove the product on one site and upgrade for capacity (D-107)."""
        core = (
            Feature.AI_MEDIA_ANALYSIS,
            Feature.AR_INSPECTION,
            Feature.WORK_ORDERS,
            Feature.REPORTS,
        )
        for feature in core:
            for tier in TIER_ORDER:
                assert PLANS[tier].has(feature), f"{tier} is missing {feature}"
            assert cheapest_tier_with(feature) is PlanTier.PILOT

    def test_permits_start_at_operations(self) -> None:
        assert not PLANS[PlanTier.PILOT].has(Feature.PERMITS)
        assert not PLANS[PlanTier.STARTER].has(Feature.PERMITS)
        assert not PLANS[PlanTier.FIELD].has(Feature.PERMITS)
        assert PLANS[PlanTier.OPERATIONS].has(Feature.PERMITS)
        assert cheapest_tier_with(Feature.PERMITS) is PlanTier.OPERATIONS

    def test_enterprise_is_custom_quoted_and_not_self_serve(self) -> None:
        plan = PLANS[PlanTier.ENTERPRISE]
        assert plan.custom_quoted is True
        assert plan.self_serve is False
        # No list price at all. A published floor that could be charged is the
        # same as selling Enterprise at its minimum by accident.
        assert plan.monthly_cents is None
        assert plan.annual_total_cents is None
        assert plan.starting_monthly_cents == 999_900
        with pytest.raises(ValueError, match="custom-quoted"):
            plan.price_cents(BillingInterval.MONTHLY)

    def test_every_other_tier_is_self_serve(self) -> None:
        assert SELF_SERVE_TIERS == (
            PlanTier.PILOT,
            PlanTier.STARTER,
            PlanTier.FIELD,
            PlanTier.OPERATIONS,
        )
        for tier in SELF_SERVE_TIERS:
            assert PLANS[tier].self_serve
            assert PLANS[tier].monthly_cents is not None

    def test_vr_sso_and_audit_export_are_enterprise_only(self) -> None:
        for feature in (Feature.VR_TRAINING, Feature.SSO, Feature.AUDIT_EXPORT):
            assert cheapest_tier_with(feature) is PlanTier.ENTERPRISE
            assert not PLANS[PlanTier.OPERATIONS].has(feature)

    def test_every_paid_tier_includes_the_core_product(self) -> None:
        for tier in TIER_ORDER:
            assert CORE_FEATURES <= PLANS[tier].features

    def test_features_only_grow_up_the_tier_order(self) -> None:
        """A higher tier must never lose a module a cheaper one had, or an
        upgrade could silently remove access."""
        for lower, higher in zip(TIER_ORDER, TIER_ORDER[1:], strict=False):
            assert PLANS[lower].features <= PLANS[higher].features

    def test_digital_twin_scope_widens_at_operations(self) -> None:
        assert PLANS[PlanTier.PILOT].digital_twin_scope == "single"
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

    def test_a_lower_tier_keeps_the_core_and_is_refused_only_the_extras(self) -> None:
        result = resolve_entitlements(company(tier="pilot", status="active"))
        assert result.is_entitled
        # The whole point of Pilot: the real product, on less of it.
        assert result.has(Feature.INSPECTIONS)
        assert result.has(Feature.AI_MEDIA_ANALYSIS)
        assert result.has(Feature.AR_INSPECTION)
        assert result.has(Feature.WORK_ORDERS)
        # And not the tiers above it.
        assert not result.has(Feature.PERMITS)
        assert not result.has(Feature.VR_TRAINING)

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
        assert_within_quota(entitlements, resource="assets", current_count=249)

    def test_create_is_refused_at_the_limit(self) -> None:
        entitlements = resolve_entitlements(company(tier="starter", status="active"))
        with pytest.raises(QuotaExceededError) as error:
            assert_within_quota(entitlements, resource="assets", current_count=250)
        assert error.value.resource == "assets"
        assert error.value.limit == 250
        assert error.value.tier is PlanTier.STARTER
        # The quota message names a real next step, which is what makes hitting
        # a cap survivable rather than a dead end.
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
        assert next_tier_above(PlanTier.PILOT) is PlanTier.STARTER
        assert next_tier_above(PlanTier.STARTER) is PlanTier.FIELD
        assert next_tier_above(PlanTier.OPERATIONS) is PlanTier.ENTERPRISE
        assert next_tier_above(PlanTier.ENTERPRISE) is None
        # A company with no plan is pointed at the entry tier, not at whichever
        # tier happened to be cheapest before Pilot existed.
        assert next_tier_above(PlanTier.UNASSIGNED) is PlanTier.PILOT


class TestUpgradeHint:
    def test_names_the_tier_that_unlocks_the_feature(self) -> None:
        hint = upgrade_hint(Feature.PERMITS)
        assert hint["feature"] == "permits"
        assert hint["required_tier"] == "operations"
        assert hint["required_tier_name"] == "Operations"

    def test_core_features_point_at_the_entry_tier(self) -> None:
        assert upgrade_hint(Feature.ASSETS)["required_tier"] == "pilot"
        # Work orders moved down to Pilot with the repricing; an upgrade prompt
        # that still named Operations would send a customer up three tiers for
        # something their current plan already includes.
        assert upgrade_hint(Feature.WORK_ORDERS)["required_tier"] == "pilot"
