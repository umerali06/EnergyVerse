"""Resolves what a company may actually do, from its plan and its payment state.

Two gates stack, and both are enforced server-side (§2, §24):

* **Permissions** answer "may this *person* do it" — `require_permission`.
* **Entitlements** answer "has this *company* paid for it" — `require_feature`
  and `assert_within_quota` here.

They are independent on purpose. A Company Admin holds `work_orders.write` on
every tier, but a Starter tenant has no work-order module at all, so the
permission passing is not sufficient. Conversely an Operations tenant has the
module while its Field Inspector still cannot close a work order.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from enum import StrEnum

from app.billing.plans import (
    PLANS,
    TIER_ORDER,
    Feature,
    Plan,
    PlanTier,
    cheapest_tier_with,
    get_plan,
)
from app.models.entities import Company


class SubscriptionStatus(StrEnum):
    """Mirrors the Stripe subscription statuses we act on, plus `INCOMPLETE`
    for a company that registered but never finished checkout."""

    INCOMPLETE = "incomplete"
    TRIALING = "trialing"
    ACTIVE = "active"
    PAST_DUE = "past_due"
    CANCELED = "canceled"


#: Statuses that grant the plan's features. `PAST_DUE` deliberately still
#: grants access: Stripe retries a failed enterprise invoice for weeks, and
#: locking an operator out of its safety and permit records over a expired
#: corporate card would be both dangerous and commercially absurd. The admin
#: portal surfaces a payment banner instead, and `CANCELED` is the hard stop.
ENTITLED_STATUSES: frozenset[SubscriptionStatus] = frozenset(
    {
        SubscriptionStatus.TRIALING,
        SubscriptionStatus.ACTIVE,
        SubscriptionStatus.PAST_DUE,
    }
)


def parse_status(raw: str | None) -> SubscriptionStatus:
    try:
        return SubscriptionStatus(raw or "")
    except ValueError:
        return SubscriptionStatus.INCOMPLETE


@dataclass(frozen=True)
class Entitlements:
    """The resolved answer for one company at one moment."""

    tier: PlanTier
    status: SubscriptionStatus
    plan: Plan | None
    features: frozenset[Feature]
    trial_ends_at: datetime | None
    current_period_end: datetime | None

    @property
    def is_entitled(self) -> bool:
        """Whether the subscription grants anything at all."""
        return self.plan is not None and self.status in ENTITLED_STATUSES

    @property
    def is_trialing(self) -> bool:
        return self.status is SubscriptionStatus.TRIALING

    def has(self, feature: Feature) -> bool:
        return feature in self.features

    def trial_days_remaining(self, now: datetime | None = None) -> int | None:
        """Whole days left, floored at zero. `None` when not on a trial, so the
        dashboard can tell "no trial" apart from "trial expires today"."""
        if not self.is_trialing or self.trial_ends_at is None:
            return None
        moment = now or datetime.now(UTC)
        remaining = self.trial_ends_at - moment
        return max(0, remaining.days + (1 if remaining.seconds else 0))

    def limit_for(self, resource: str) -> int | None:
        """Quota for `facilities` / `assets` / `seats`; `None` is unlimited.
        An unentitled company gets 0 rather than unlimited — failing closed."""
        if self.plan is None or not self.is_entitled:
            return 0
        return self.plan.quotas.limit_for(resource)


def resolve_entitlements(company: Company) -> Entitlements:
    """Pure function of the stored company document — no I/O, so every caller
    (dependency, dashboard, admin portal) resolves identically."""
    status = parse_status(company.subscription_status)
    plan = get_plan(company.subscription_tier)
    entitled = plan is not None and status in ENTITLED_STATUSES
    return Entitlements(
        tier=plan.tier if plan else PlanTier.UNASSIGNED,
        status=status,
        plan=plan,
        features=plan.features if (plan and entitled) else frozenset(),
        trial_ends_at=company.trial_ends_at,
        current_period_end=company.current_period_end,
    )


class QuotaExceededError(Exception):
    """Raised when a create would take a tenant past its plan's allowance."""

    def __init__(self, *, resource: str, limit: int, current: int, tier: PlanTier) -> None:
        super().__init__(f"{resource} limit of {limit} reached on the {tier.value} plan")
        self.resource = resource
        self.limit = limit
        self.current = current
        self.tier = tier
        self.upgrade_tier = next_tier_above(tier)


def next_tier_above(tier: PlanTier) -> PlanTier | None:
    """The next plan up, for an upgrade prompt that names a real destination."""
    if tier not in TIER_ORDER:
        return TIER_ORDER[0]
    index = TIER_ORDER.index(tier)
    return TIER_ORDER[index + 1] if index + 1 < len(TIER_ORDER) else None


def assert_within_quota(
    entitlements: Entitlements,
    *,
    resource: str,
    current_count: int,
) -> None:
    """Guard a create. `current_count` is the tenant's existing row count, so
    the caller does the counting and this stays free of I/O."""
    limit = entitlements.limit_for(resource)
    if limit is None:
        return
    if current_count >= limit:
        raise QuotaExceededError(
            resource=resource,
            limit=limit,
            current=current_count,
            tier=entitlements.tier,
        )


def upgrade_hint(feature: Feature) -> dict[str, str | None]:
    """Structured detail for a 402 body, so the client can render a real
    upgrade call to action rather than parsing a message string."""
    tier = cheapest_tier_with(feature)
    return {
        "feature": feature.value,
        "required_tier": tier.value if tier else None,
        "required_tier_name": PLANS[tier].name if tier else None,
    }
