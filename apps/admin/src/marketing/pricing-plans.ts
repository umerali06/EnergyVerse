/**
 * Published plan catalog for the public pricing page.
 *
 * Mirrors `apps/api/app/billing/plans.py`, which is authoritative — it enforces
 * entitlements and the Stripe Prices are created from it. This copy exists so
 * the marketing pages stay static server components with no API dependency
 * (D-087). The `pricing-catalog.test.ts` suite pins every number against the
 * requirements document so the two cannot drift silently; change them together.
 *
 * Figures are from requirements §22.1. One caveat carried over from the backend
 * catalog: the monthly-billing prices are **derived**, not quoted — the document
 * gives one price per tier plus "monthly billing available at a ~15% premium"
 * without the monthly figures, so these are list × 1.15 rounded to .99 and need
 * product-owner sign-off before a live monthly Price is created.
 */

export type BillingInterval = "monthly" | "annual";

export type PlanTier = "starter" | "field" | "operations" | "enterprise";

export type Plan = {
  tier: PlanTier;
  name: string;
  audience: string;
  /** Annual-equivalent monthly price in cents, as published. */
  listMonthlyCents: number;
  /** Charged up front for twelve months. */
  annualTotalCents: number;
  /** Derived ~15% premium for month-to-month billing. */
  monthlyCents: number;
  quotas: { facilities: number | null; assets: number | null; seats: number | null };
  /** Modules this tier unlocks beyond the base set, in reading order. */
  adds: readonly string[];
  support: string;
  featured: boolean;
  /** Enterprise is quoted from its floor price; a CSM negotiates upward. */
  customQuoted: boolean;
};

/** Trial length, matching `TRIAL_DAYS` in the backend catalog. A payment method
 * is collected up front, so the trial converts rather than stranding a tenant. */
export const TRIAL_DAYS = 7;

/** Modules every paid tier includes (§23.1 MVP scope minus the gated three). */
export const BASE_MODULES: readonly string[] = [
  "Asset registry with facilities, areas, and QR labels",
  "Digital inspections with photo, video, and reading capture",
  "AI photo and video analysis, always inspector-reviewed",
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
    tier: "starter",
    name: "Starter",
    audience: "Very small operator, single well site, independent EPC on one project",
    listMonthlyCents: 99_799,
    annualTotalCents: 1_197_588,
    monthlyCents: 114_799,
    quotas: { facilities: 1, assets: 150, seats: 5 },
    adds: [],
    support: "Email support",
    featured: false,
    customQuoted: false,
  },
  {
    tier: "field",
    name: "Field",
    audience: "Single site or small-to-mid operator, EPC contractor on one project",
    listMonthlyCents: 299_799,
    annualTotalCents: 3_597_588,
    monthlyCents: 344_799,
    quotas: { facilities: 1, assets: 500, seats: 15 },
    adds: [],
    support: "Email support",
    featured: false,
    customQuoted: false,
  },
  {
    tier: "operations",
    name: "Operations",
    audience: "Mid-market multi-site operator, regional utility",
    listMonthlyCents: 999_799,
    annualTotalCents: 11_997_588,
    monthlyCents: 1_149_799,
    quotas: { facilities: 5, assets: 2_500, seats: 75 },
    adds: [
      "AR inspection with dimension measurement",
      "Permit-to-work with approvals",
      "Work orders with supervised sign-off",
      "Static 3D digital twin across every facility",
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
    listMonthlyCents: 2_999_799,
    annualTotalCents: 35_997_588,
    monthlyCents: 3_449_799,
    quotas: { facilities: null, assets: null, seats: null },
    adds: [
      "Everything in Operations",
      "VR training environment",
      "SSO and Azure AD",
      "Audit-log export",
      "Dedicated CSM and custom SLA (99.9% uptime, 4-hr critical response)",
      "Custom onboarding and data migration",
    ],
    support: "Premium support (4-hr critical response, 24/7 on-call)",
    featured: false,
    customQuoted: true,
  },
];

/** Per-seat prices beyond a tier's allotment (§22.2). */
export const seatAddOns = [
  { role: "Field Inspector", cents: 18_999 },
  { role: "Maintenance Technician", cents: 14_999 },
  { role: "Operations Manager", cents: 29_999 },
  { role: "HSE Manager", cents: 34_999, note: "safety and compliance liability premium" },
  { role: "Executive (read-only)", cents: 9_999 },
] as const;

/** Usage and module add-ons (§22.3). */
export const usageAddOns = [
  { label: "Additional tracked assets, per 1,000 beyond allotment", cents: 84_999 },
  { label: "Additional facility or site beyond allotment", cents: 219_799 },
  { label: "AI analysis overage, per 1,000 analyses/mo beyond quota", cents: 59_799 },
  { label: "VR Training module (included at Enterprise)", cents: 349_799 },
  { label: "Advanced Executive Analytics and benchmarking pack", cents: 119_799 },
  { label: "Dedicated Customer Success Manager", cents: 199_799 },
] as const;

/** Whole dollars with thousands separators — the cents are always .99, so they
 * are rendered separately and never rounded away. */
export function formatPrice(cents: number): string {
  const dollars = Math.floor(cents / 100);
  const remainder = cents % 100;
  const formatted = dollars.toLocaleString("en-US");
  return remainder === 0 ? `$${formatted}` : `$${formatted}.${String(remainder).padStart(2, "0")}`;
}

export function quotaLabel(value: number | null, noun: string): string {
  if (value === null) return `Unlimited ${noun}`;
  return `${value.toLocaleString("en-US")} ${noun}`;
}

/** Seat and asset allowances as one line, for a plan card. */
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
    question: "Why is pricing per site rather than per user only?",
    answer:
      "A refinery or pipeline network carries thousands of trackable assets and loses far more per hour of unplanned downtime than a typical field-service operation. The base license reflects the site, with role-based seats layered on top.",
  },
  {
    question: "Who counts as a seat?",
    answer:
      "Anyone who signs in to do field or operational work. Executive read-only, Super Admin, and Company Admin seats are included at no extra charge on every tier — pricing scales on the roles that generate the return.",
  },
  {
    question: "What happens if we outgrow our asset or seat allowance?",
    answer:
      "The platform tells you before it blocks you, and you can either add capacity as an add-on or move up a tier. Assets are unlimited architecturally; the caps are commercial.",
  },
  {
    question: "Does the mobile app really work offline?",
    answer:
      "Yes. Inspections, readings, photos, and work-order updates are written to a local database on the device and pushed through a sync engine when the connection returns, so a crew can complete a full round with no coverage.",
  },
  {
    question: "Can we get SSO, an audit-log export, or a custom SLA?",
    answer:
      "Those are Enterprise-tier capabilities, along with VR training and a dedicated customer success manager. Enterprise is quoted against site count, asset count, and integration scope.",
  },
] as const;

/** Implementation and support services (§22.4). */
export const services = [
  {
    label: "Standard onboarding — data migration, asset import, QR setup, admin training",
    price: "$14,997.99 one-time",
    tiers: "Starter, Field, Operations",
  },
  {
    label:
      "Enterprise onboarding — multi-site rollout, legacy migration, custom integrations, change management",
    price: "$59,997.99–$149,997.99 one-time, scope-dependent",
    tiers: "Enterprise",
  },
  {
    label: "Standard support — business hours, email and chat",
    price: "Included",
    tiers: "All tiers",
  },
  {
    label: "Premium support — 4-hr critical response, 24/7 on-call",
    price: "Included at Enterprise; $4,997.99/mo for lower tiers",
    tiers: "All tiers",
  },
] as const;
