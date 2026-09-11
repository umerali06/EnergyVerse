"""Subscription plan catalog — the single source of truth for tiers.

Every price, quota, and feature flag here comes from the requirements document
(§22 Pricing & Packaging). This module is authoritative: the API enforces
against it, the admin portal renders from it via `GET /api/v1/billing/catalog`,
and the Stripe Prices are created from it by `scripts/stripe_sync.py` so the
numbers charged can never drift from the numbers published.

Two things in here are deliberately flagged rather than assumed:

* `monthly_cents` is **derived**, not quoted. The document lists one price per
  tier and says "Billed annually; monthly billing available at a ~15% premium"
  without giving the monthly figures, so these are the annual-equivalent
  monthly price times 1.15 rounded to a .99 boundary. They need product-owner
  sign-off before a monthly Price is created in live mode.
* The feature split follows §22.1's "Included" column literally: AR inspection,
  permit-to-work, and work orders are Operations-and-above. That means a
  Starter or Field tenant has no work-order module, and therefore no use for
  the Maintenance Technician role. Confirmed with the product owner on
  2026-09-08; raise it again if seat pricing for that role starts at Starter.
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
    STARTER = "starter"
    FIELD = "field"
    OPERATIONS = "operations"
    ENTERPRISE = "enterprise"


class Feature(StrEnum):
    """Entitlement keys. Named for the module they unlock, not for a tier, so a
    repricing changes the catalog rather than every call site."""

    # Base modules — every paid tier.
    ASSETS = "assets"
    INSPECTIONS = "inspections"
    AI_MEDIA_ANALYSIS = "ai_media_analysis"
    SAFETY_REPORTS = "safety_reports"
    DOCUMENTS = "documents"
    REPORTS = "reports"
    DIGITAL_TWIN = "digital_twin"
    # Operations and above.
    AR_INSPECTION = "ar_inspection"
    PERMITS = "permits"
    WORK_ORDERS = "work_orders"
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

BASE_FEATURES: frozenset[Feature] = frozenset(
    {
        Feature.ASSETS,
        Feature.INSPECTIONS,
        Feature.AI_MEDIA_ANALYSIS,
        Feature.SAFETY_REPORTS,
        Feature.DOCUMENTS,
        Feature.REPORTS,
        Feature.DIGITAL_TWIN,
    }
)

OPERATIONS_FEATURES: frozenset[Feature] = BASE_FEATURES | {
    Feature.AR_INSPECTION,
    Feature.PERMITS,
    Feature.WORK_ORDERS,
}

ENTERPRISE_FEATURES: frozenset[Feature] = OPERATIONS_FEATURES | {
    Feature.VR_TRAINING,
    Feature.SSO,
    Feature.AUDIT_EXPORT,
}


@dataclass(frozen=True)
class PlanQuotas:
    """`None` means unlimited — Enterprise carries a volume-tiered infra fee
    above 25,000 assets commercially, but no hard cap architecturally (§5)."""

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
    #: Annual-equivalent monthly price, as published in §22.1.
    list_monthly_cents: int
    #: Total charged for twelve months up front.
    annual_total_cents: int
    #: Derived monthly-billing price (~15% premium). See module docstring.
    monthly_cents: int
    quotas: PlanQuotas
    features: frozenset[Feature]
    #: "single" — static 3D for one facility; "all" — every facility (§22.1).
    digital_twin_scope: str
    support: str
    #: Enterprise is custom-quoted from this floor; the self-serve Price is the
    #: entry point and a CSM negotiates up from there.
    custom_quoted: bool = False

    def has(self, feature: Feature) -> bool:
        return feature in self.features

    def price_cents(self, interval: BillingInterval) -> int:
        return (
            self.annual_total_cents
            if interval is BillingInterval.ANNUAL
            else self.monthly_cents
        )


PLANS: dict[PlanTier, Plan] = {
    PlanTier.STARTER: Plan(
        tier=PlanTier.STARTER,
        name="Starter",
        audience="Very small operator, single well site, independent EPC on one project",
        list_monthly_cents=99_799,
        annual_total_cents=1_197_588,
        monthly_cents=114_799,
        quotas=PlanQuotas(facilities=1, assets=150, seats=5),
        features=BASE_FEATURES,
        digital_twin_scope="single",
        support="Email support",
    ),
    PlanTier.FIELD: Plan(
        tier=PlanTier.FIELD,
        name="Field",
        audience="Single site / small-to-mid operator, EPC contractor on one project",
        list_monthly_cents=299_799,
        annual_total_cents=3_597_588,
        monthly_cents=344_799,
        quotas=PlanQuotas(facilities=1, assets=500, seats=15),
        features=BASE_FEATURES,
        digital_twin_scope="single",
        support="Email support",
    ),
    PlanTier.OPERATIONS: Plan(
        tier=PlanTier.OPERATIONS,
        name="Operations",
        audience="Mid-market multi-site operator, regional utility",
        list_monthly_cents=999_799,
        annual_total_cents=11_997_588,
        monthly_cents=1_149_799,
        quotas=PlanQuotas(facilities=5, assets=2_500, seats=75),
        features=OPERATIONS_FEATURES,
        digital_twin_scope="all",
        support="Priority support (next-business-day SLA)",
    ),
    PlanTier.ENTERPRISE: Plan(
        tier=PlanTier.ENTERPRISE,
        name="Enterprise",
        audience=(
            "Major E&P operator, integrated oil major, national utility, "
            "large EPC/mining group"
        ),
        list_monthly_cents=2_999_799,
        annual_total_cents=35_997_588,
        monthly_cents=3_449_799,
        quotas=PlanQuotas(facilities=None, assets=None, seats=None),
        features=ENTERPRISE_FEATURES,
        digital_twin_scope="all",
        support="Premium support (4-hr critical response, 24/7 on-call)",
        custom_quoted=True,
    ),
}

#: Cheapest first. Used for ordering the pricing page and upgrade prompts.
TIER_ORDER: tuple[PlanTier, ...] = (
    PlanTier.STARTER,
    PlanTier.FIELD,
    PlanTier.OPERATIONS,
    PlanTier.ENTERPRISE,
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
