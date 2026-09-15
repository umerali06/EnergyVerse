/**
 * Published plan catalog for the public pricing page.
 *
 * Mirrors `apps/api/app/billing/plans.py`, which is authoritative — it enforces
 * entitlements and the Stripe Prices are created from it. This copy exists so
 * the marketing pages stay static server components with no API dependency
 * (D-087). `pricing-catalog.test.ts` pins every number against the backend
 * catalog so the two cannot drift silently; change them together.
 *
 * Restructured for launch on 2026-09-15 (D-107):
 *
 * - The quoted price is the **monthly** price. Annual is ten months of it —
 *   twelve months of service for ten months of money.
 * - Every paid tier carries the core product (AI, AR, work orders, reports).
 *   Tiers differ on capacity, support, and enterprise capability, so an upgrade
 *   never takes away a module someone was already using.
 * - Enterprise is **not self-serve**: no list price, no Stripe Price, no card.
 *   It publishes a floor to anchor the conversation and routes to sales.
 */

export type BillingInterval = "monthly" | "annual";

export type PlanTier = "pilot" | "starter" | "field" | "operations" | "enterprise";

export type Plan = {
  tier: PlanTier;
  name: string;
  audience: string;
  /** Month-to-month price in cents. `null` on a custom-quoted tier. */
  monthlyCents: number | null;
  /** Twelve months of service, paid up front. `null` on a custom-quoted tier. */
  annualTotalCents: number | null;
  /** The floor a custom-quoted tier is sold from. Never charged. */
  startingMonthlyCents: number | null;
  quotas: { facilities: number | null; assets: number | null; seats: number | null };
  /** What this tier adds over the one below it, in reading order. */
  adds: readonly string[];
  support: string;
  featured: boolean;
  /** Sold by sales rather than by card. */
  customQuoted: boolean;
};

/** Trial length, matching `TRIAL_DAYS` in the backend catalog. A payment method
 * is collected up front, so the trial converts rather than stranding a tenant. */
export const TRIAL_DAYS = 7;

/** Months charged for twelve months of service — the whole annual incentive.
 * Matches `ANNUAL_MONTHS_CHARGED` in the backend catalog. */
export const ANNUAL_MONTHS_CHARGED = 10;

/** The core product, on every paid tier including Pilot. */
export const BASE_MODULES: readonly string[] = [
  "Asset registry with facilities, areas, and QR labels",
  "Digital inspections with photo, video, and reading capture",
  "AI photo and video analysis, always inspector-reviewed",
  "AR inspection with dimension measurement",
  "Work orders with supervised sign-off",
  "Manual asset condition logging",
  "Safety incident reporting",
  "Controlled document library",
  "AI report generation with PDF, Word, and Excel export",
  "Static 3D digital twin",
  "Offline mobile app for Android, iOS, and web",
  "Seven built-in roles with server-enforced permissions and audit log",
];

export const plans: readonly Plan[] = [
  {
    tier: "pilot",
    name: "Pilot",
    audience: "Early customer proving the platform on one site before rolling it out",
    monthlyCents: 49_900,
    annualTotalCents: 499_000,
    startingMonthlyCents: null,
    quotas: { facilities: 1, assets: 100, seats: 5 },
    adds: [],
    support: "Email support",
    featured: false,
    customQuoted: false,
  },
  {
    tier: "starter",
    name: "Starter",
    audience: "Very small operator, single well site, independent EPC on one project",
    monthlyCents: 99_900,
    annualTotalCents: 999_000,
    startingMonthlyCents: null,
    quotas: { facilities: 1, assets: 250, seats: 10 },
    adds: ["More assets, more seats, and a larger AI analysis allowance than Pilot"],
    support: "Email support",
    featured: false,
    customQuoted: false,
  },
  {
    tier: "field",
    name: "Field",
    audience: "Single site or small-to-mid operator, EPC contractor on one project",
    monthlyCents: 199_900,
    annualTotalCents: 1_999_000,
    startingMonthlyCents: null,
    quotas: { facilities: 2, assets: 750, seats: 25 },
    adds: ["A second facility", "Higher asset, seat, and AI analysis allowances"],
    support: "Business-hours email and chat support",
    featured: false,
    customQuoted: false,
  },
  {
    tier: "operations",
    name: "Operations",
    audience: "Mid-market multi-site operator, regional utility",
    monthlyCents: 499_900,
    annualTotalCents: 4_999_000,
    startingMonthlyCents: null,
    quotas: { facilities: 5, assets: 2_500, seats: 75 },
    adds: [
      "Permit-to-work with approvals",
      "Static 3D digital twin across every facility",
      "Advanced executive analytics",
      "Priority support with a next-business-day SLA",
    ],
    support: "Priority support (next-business-day SLA)",
    featured: true,
    customQuoted: false,
  },
  {
    tier: "enterprise",
    name: "Enterprise",
    audience:
      "Major E&P operator, integrated oil major, national utility, large EPC or mining group",
    monthlyCents: null,
    annualTotalCents: null,
    startingMonthlyCents: 999_900,
    quotas: { facilities: null, assets: null, seats: null },
    adds: [
      "Unlimited facilities, assets, and seats",
      "VR training environment",
      "SSO and Azure AD",
      "Audit-log export",
      "Custom integrations",
      "Dedicated CSM and custom SLA (99.9% uptime, 4-hr critical response)",
      "Custom onboarding, data migration, and deployment",
    ],
    support: "Premium support (4-hr critical response, 24/7 on-call)",
    featured: false,
    customQuoted: true,
  },
];

/**
 * What an Enterprise quote is built from.
 *
 * Published verbatim so "custom pricing" reads as a real method rather than an
 * evasion. Matches `ENTERPRISE_QUOTE_FACTORS` in the backend catalog.
 */
export const enterpriseQuoteFactors: readonly string[] = [
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
];

/**
 * The only things billed separately from the plan.
 *
 * Deliberately short. A launch price list with a line item for every role and
 * every module reads as a maze, and a buyer who cannot tell what a year costs
 * does not buy — so seats are not sold à la carte at all: more seats means the
 * next tier up. `cents: null` means the extra is scoped and quoted rather than
 * carrying a list price.
 *
 * The amounts here are proposed against the new base prices and are the one
 * part of this catalog not dictated by the product owner — confirm before the
 * first order form goes out.
 */
export const addOns = [
  { label: "Additional facility or site", cents: 49_900, unit: "per facility, per month" },
  { label: "Additional tracked assets", cents: 29_900, unit: "per 1,000 assets, per month" },
  { label: "Additional AI analysis volume", cents: 19_900, unit: "per 1,000 analyses, per month" },
  { label: "VR training environment", cents: 99_900, unit: "per month, included at Enterprise" },
  {
    label: "Premium support and custom SLA",
    cents: 99_900,
    unit: "per month, included at Enterprise",
  },
  { label: "Custom 3D facility modeling", cents: null, unit: "quoted per facility" },
  { label: "Custom integrations", cents: null, unit: "quoted per integration" },
  { label: "Data migration from legacy systems", cents: null, unit: "quoted by scope" },
] as const;

/** Implementation and support services. */
export const services = [
  {
    label: "Standard onboarding — data migration, asset import, QR setup, admin training",
    price: "$4,999 one-time",
    tiers: "Pilot, Starter, Field, Operations",
  },
  {
    label:
      "Enterprise onboarding — multi-site rollout, legacy migration, custom integrations, change management",
    price: "Quoted with the contract",
    tiers: "Enterprise",
  },
  {
    label: "Founding-customer terms — discounted or waived implementation, negotiated rate",
    price: "Applied as a discount code at checkout",
    tiers: "By agreement",
  },
  {
    label: "Standard support — business hours, email and chat",
    price: "Included",
    tiers: "All tiers",
  },
] as const;

/** Whole dollars with thousands separators; cents shown only when non-zero. */
export function formatPrice(cents: number): string {
  const dollars = Math.floor(cents / 100);
  const remainder = cents % 100;
  const formatted = dollars.toLocaleString("en-US");
  return remainder === 0 ? `$${formatted}` : `$${formatted}.${String(remainder).padStart(2, "0")}`;
}

/** What an annual plan works out to per month, for "or $X/mo billed annually". */
export function annualMonthlyEquivalentCents(plan: Plan): number | null {
  return plan.annualTotalCents === null ? null : Math.round(plan.annualTotalCents / 12);
}

export function quotaLabel(value: number | null, noun: string): string {
  if (value === null) return `Unlimited ${noun}`;
  return `${value.toLocaleString("en-US")} ${noun}`;
}

/** Facility, asset, and seat allowances as one line, for a plan card. */
export function allowanceLine(plan: Plan): string {
  const facilities =
    plan.quotas.facilities === null
      ? "Unlimited facilities"
      : `${plan.quotas.facilities} ${plan.quotas.facilities === 1 ? "facility" : "facilities"}`;
  return `${facilities} · ${quotaLabel(plan.quotas.assets, "assets")} · ${quotaLabel(
    plan.quotas.seats,
    "seats",
  )}`;
}

/** Questions a buyer asks before starting a trial. */
export const pricingFaqs = [
  {
    question: "How does the free trial work?",
    answer: `Pick a plan, enter a card, and you get ${TRIAL_DAYS} days on that plan's full feature set. Nothing is charged until the trial ends, and you can cancel inside the portal before then.`,
  },
  {
    question: "What is the difference between monthly and annual?",
    answer: `The same plan either way. Monthly is the price on the card; annual charges ${ANNUAL_MONTHS_CHARGED} months up front for twelve months of service, so a year costs two months less. You choose at checkout and can see both prices before you pay.`,
  },
  {
    question: "What do I actually get on Pilot?",
    answer:
      "The real product on one site: AI photo and video analysis, AR inspection with measurement, work orders, QR asset scanning, and reports — with a smaller asset, seat, and AI allowance. It exists so you can prove the value internally before committing to a rollout.",
  },
  {
    question: "Do I lose anything by starting small?",
    answer:
      "No. Every paid tier includes the core platform; moving up adds capacity, permit-to-work, 3D across every site, VR training, SSO, and support commitments. An upgrade never removes a module you were already using.",
  },
  {
    question: "What happens if we outgrow our asset or seat allowance?",
    answer:
      "The platform tells you before it blocks you. Extra facilities, assets, and AI volume can be added on, and more seats means the next tier up — seats are not sold one at a time, because a price list nobody can total is worse than a tier change.",
  },
  {
    question: "Does the mobile app really work offline?",
    answer:
      "Yes. Inspections, readings, photos, and work-order updates are written to a local database on the device and pushed through a sync engine when the connection returns, so a crew can complete a full round with no coverage.",
  },
  {
    question: "How is Enterprise priced?",
    answer: `Custom, starting around ${formatPrice(999_900)}/month. It is quoted against ${enterpriseQuoteFactors.slice(0, 4).join(", ")}, and the rest of the scope — so it is a conversation with sales, not a checkout page.`,
  },
  {
    question: "Do you offer founding-customer pricing?",
    answer:
      "Yes. Founding customers get a negotiated rate and discounted or waived implementation. Discounts are issued as a code you apply at checkout, so the price you agreed is the price you are charged.",
  },
] as const;
