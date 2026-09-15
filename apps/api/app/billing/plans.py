"""Subscription plan catalog — the single source of truth for tiers.

This module is authoritative: the API enforces against it, the admin portal
renders from it via `GET /api/v1/billing/catalog`, and the self-serve Stripe
Prices are created from it by `scripts/stripe_sync.py`, so the numbers charged
can never drift from the numbers published.

Restructured for launch on 2026-09-15 (D-107), replacing the §22 figures from
the requirements document. Three things about the new shape are deliberate:

* **The quoted price is the monthly price.** `$999/month` is what a
  month-to-month Starter customer pays, not an annual-equivalent that a monthly
  buyer never actually sees. Annual is `ANNUAL_MONTHS_CHARGED` months of that
  same price — twelve months of service for ten months of money.
* **Every paid tier carries the core product.** AR inspection, AI analysis,
  work orders and reports start at Pilot. The ladder is capacity, support and
  enterprise capability, not a different product at each rung, so an upgrade
  can never take a module away from someone already using it.
* **Enterprise is not self-serve.** It has no `monthly_cents` and no Stripe
  Price, only a published floor to quote from. Selling it runs through sales
  (contact → qualification → quote → agreement → invoice), and a Price is
  created for that customer once the deal is agreed.
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum


class PlanTier(StrEnum):
    """Self-serve tiers, ordered cheapest to richest.

    `UNASSIGNED` is the state a company sits in between registration and a
    completed checkout — it grants nothing, so a half-finished signup cannot
    read tenant data.
    """

    UNASSIGNED = "unassigned"
    PILOT = "pilot"
    STARTER = "starter"
    FIELD = "field"
    OPERATIONS = "operations"
    ENTERPRISE = "enterprise"


class Feature(StrEnum):
    """Entitlement keys. Named for the module they unlock, not for a tier, so a
    repricing changes the catalog rather than every call site."""

    # Core product — every paid tier, Pilot included.
    ASSETS = "assets"
    INSPECTIONS = "inspections"
    AI_MEDIA_ANALYSIS = "ai_media_analysis"
    SAFETY_REPORTS = "safety_reports"
    DOCUMENTS = "documents"
    REPORTS = "reports"
    DIGITAL_TWIN = "digital_twin"
    AR_INSPECTION = "ar_inspection"
    WORK_ORDERS = "work_orders"
    # Operations and above.
    PERMITS = "permits"
    # Enterprise only.
    VR_TRAINING = "vr_training"
    SSO = "sso"
    AUDIT_EXPORT = "audit_export"


class BillingInterval(StrEnum):
    MONTHLY = "monthly"
    ANNUAL = "annual"


#: Trial length for every self-serve tier. A payment method is collected up
#: front (product owner, 2026-09-08), so the trial converts rather than lapsing
#: into a dead tenant.
TRIAL_DAYS = 7

#: Months charged for twelve months of service. Two months free is the whole
#: annual incentive — stated once here so the discount cannot drift between the
#: catalog, the pricing page and Stripe.
ANNUAL_MONTHS_CHARGED = 10


def annual_total_for(monthly_cents: int) -> int:
    return monthly_cents * ANNUAL_MONTHS_CHARGED


#: The core product. Present on every paid tier, which is what makes the ladder
#: monotonic: moving up adds capacity and capability, never removes a module.
CORE_FEATURES: frozenset[Feature] = frozenset(
    {
        Feature.ASSETS,
        Feature.INSPECTIONS,
        Feature.AI_MEDIA_ANALYSIS,
        Feature.SAFETY_REPORTS,
        Feature.DOCUMENTS,
        Feature.REPORTS,
        Feature.DIGITAL_TWIN,
        Feature.AR_INSPECTION,
        Feature.WORK_ORDERS,
    }
)

#: Kept for callers that still import the pre-restructure name.
BASE_FEATURES = CORE_FEATURES

OPERATIONS_FEATURES: frozenset[Feature] = CORE_FEATURES | {Feature.PERMITS}

ENTERPRISE_FEATURES: frozenset[Feature] = OPERATIONS_FEATURES | {
    Feature.VR_TRAINING,
    Feature.SSO,
    Feature.AUDIT_EXPORT,
}


@dataclass(frozen=True)
class PlanQuotas:
    """`None` means unlimited — Enterprise is negotiated on volume commercially,
    but carries no hard cap architecturally (§5)."""

    facilities: int | None
    assets: int | None
    seats: int | None

    def limit_for(self, resource: str) -> int | None:
        """Explicit mapping rather than `getattr`, so a typo in a caller's
        resource name raises here instead of silently returning `None`
        (which `assert_within_quota` reads as unlimited)."""
        match resource:
            case "facilities":
                return self.facilities
            case "assets":
                return self.assets
            case "seats":
                return self.seats
            case _:
                raise ValueError(f"Unknown quota resource: {resource}")


@dataclass(frozen=True)
class Plan:
    tier: PlanTier
    name: str
    audience: str
    #: Month-to-month price, and the figure published as "$X/month".
    #: `None` on a custom-quoted tier, which has no list price to charge.
    monthly_cents: int | None
    #: Twelve months of service paid up front — `ANNUAL_MONTHS_CHARGED` months
    #: of `monthly_cents`. `None` on a custom-quoted tier.
    annual_total_cents: int | None
    #: The published floor a custom-quoted tier is sold from ("starting around
    #: $9,999/month"). Never charged, never a Stripe Price — it exists so the
    #: page can anchor expectations without naming a price nobody pays.
    starting_monthly_cents: int | None
    quotas: PlanQuotas
    features: frozenset[Feature]
    #: "single" — static 3D for one facility; "all" — every facility.
    digital_twin_scope: str
    support: str
    #: A one-line summary of what the tier adds over the one below it, for the
    #: pricing page. Empty on the entry tier, which adds nothing to nothing.
    adds: tuple[str, ...] = ()
    #: Sold by sales rather than by card. A custom-quoted plan is published and
    #: enforced like any other, but `start_checkout` refuses it and
    #: `stripe_sync` creates no Price for it.
    custom_quoted: bool = False

    @property
    def self_serve(self) -> bool:
        """Whether a card can buy this plan without talking to anyone."""
        return not self.custom_quoted

    def has(self, feature: Feature) -> bool:
        return feature in self.features

    def price_cents(self, interval: BillingInterval) -> int:
        """The amount to charge for one billing period.

        Raises on a custom-quoted plan rather than returning the published
        floor: that floor is an anchor for a conversation, and charging it
        would mean selling an Enterprise deal at its minimum by accident.
        """
        if self.custom_quoted or self.monthly_cents is None or self.annual_total_cents is None:
            raise ValueError(
                f"{self.name} is custom-quoted and has no list price; it is sold through sales"
            )
        return (
            self.annual_total_cents
            if interval is BillingInterval.ANNUAL
            else self.monthly_cents
        )

    def annual_monthly_equivalent_cents(self) -> int | None:
        """What a year works out to per month, for "or $X/mo billed annually"."""
        if self.annual_total_cents is None:
            return None
        return round(self.annual_total_cents / 12)


PLANS: dict[PlanTier, Plan] = {
    PlanTier.PILOT: Plan(
        tier=PlanTier.PILOT,
        name="Pilot",
        audience="Early customer proving the platform on one site before rolling it out",
        monthly_cents=49_900,
        annual_total_cents=annual_total_for(49_900),
        starting_monthly_cents=None,
        quotas=PlanQuotas(facilities=1, assets=100, seats=5),
        features=CORE_FEATURES,
        digital_twin_scope="single",
        support="Email support",
    ),
    PlanTier.STARTER: Plan(
        tier=PlanTier.STARTER,
        name="Starter",
        audience="Very small operator, single well site, independent EPC on one project",
        monthly_cents=99_900,
        annual_total_cents=annual_total_for(99_900),
        starting_monthly_cents=None,
        quotas=PlanQuotas(facilities=1, assets=250, seats=10),
        features=CORE_FEATURES,
        digital_twin_scope="single",
        support="Email support",
        adds=("More assets, more seats, and a larger AI analysis allowance than Pilot",),
    ),
    PlanTier.FIELD: Plan(
        tier=PlanTier.FIELD,
        name="Field",
        audience="Single site / small-to-mid operator, EPC contractor on one project",
        monthly_cents=199_900,
        annual_total_cents=annual_total_for(199_900),
        starting_monthly_cents=None,
        quotas=PlanQuotas(facilities=2, assets=750, seats=25),
        features=CORE_FEATURES,
        digital_twin_scope="single",
        support="Business-hours email and chat support",
        adds=(
            "A second facility",
            "Higher asset, seat, and AI analysis allowances",
        ),
    ),
    PlanTier.OPERATIONS: Plan(
        tier=PlanTier.OPERATIONS,
        name="Operations",
        audience="Mid-market multi-site operator, regional utility",
        monthly_cents=499_900,
        annual_total_cents=annual_total_for(499_900),
        starting_monthly_cents=None,
        quotas=PlanQuotas(facilities=5, assets=2_500, seats=75),
        features=OPERATIONS_FEATURES,
        digital_twin_scope="all",
        support="Priority support (next-business-day SLA)",
        adds=(
            "Permit-to-work with approvals",
            "Static 3D digital twin across every facility",
            "Advanced executive analytics",
            "Priority support with a next-business-day SLA",
        ),
    ),
    PlanTier.ENTERPRISE: Plan(
        tier=PlanTier.ENTERPRISE,
        name="Enterprise",
        audience=(
            "Major E&P operator, integrated oil major, national utility, "
            "large EPC/mining group"
        ),
        monthly_cents=None,
        annual_total_cents=None,
        starting_monthly_cents=999_900,
        quotas=PlanQuotas(facilities=None, assets=None, seats=None),
        features=ENTERPRISE_FEATURES,
        digital_twin_scope="all",
        support="Premium support (4-hr critical response, 24/7 on-call)",
        adds=(
            "Unlimited facilities, assets, and seats",
            "VR training environment",
            "SSO and Azure AD",
            "Audit-log export",
            "Custom integrations",
            "Dedicated CSM and custom SLA (99.9% uptime, 4-hr critical response)",
            "Custom onboarding, data migration, and deployment",
        ),
        custom_quoted=True,
    ),
}

#: What an Enterprise quote is actually built from. Published verbatim on the
#: pricing page so "custom" reads as a real method rather than an evasion.
ENTERPRISE_QUOTE_FACTORS: tuple[str, ...] = (
    "number of facilities",
    "number of assets",
    "number of users and seats",
    "AI analysis usage",
    "storage requirements",
    "3D and VR requirements",
    "custom integrations",
    "SSO and enterprise security requirements",
    "support SLA",
    "data migration",
    "onboarding and implementation scope",
)

#: Cheapest first. Used for ordering the pricing page and upgrade prompts.
TIER_ORDER: tuple[PlanTier, ...] = (
    PlanTier.PILOT,
    PlanTier.STARTER,
    PlanTier.FIELD,
    PlanTier.OPERATIONS,
    PlanTier.ENTERPRISE,
)

#: The tiers a card can buy without talking to sales.
SELF_SERVE_TIERS: tuple[PlanTier, ...] = tuple(
    tier for tier in TIER_ORDER if PLANS[tier].self_serve
)


def get_plan(tier: PlanTier | str) -> Plan | None:
    """Resolve a plan, tolerating the free-text tier values already stored on
    existing companies (`unassigned`, and the pre-Phase-13 `demo`/`professional`
    values that never mapped to a published tier)."""
    try:
        resolved = PlanTier(tier)
    except ValueError:
        return None
    return PLANS.get(resolved)


def cheapest_tier_with(feature: Feature) -> PlanTier | None:
    """The tier a tenant must reach to unlock `feature` — drives the upgrade
    prompt so it names a real plan instead of saying "contact sales"."""
    for tier in TIER_ORDER:
        if PLANS[tier].has(feature):
            return tier
    return None
