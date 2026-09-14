"use client";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";
import { Badge, Button, Card, MotionSection, PageLoader, StatusPill } from "@/design-system";
import type { BillingCatalogResponse } from "@fev/api-client";

import { useSubscription } from "./subscription-context";

/**
 * The subscription screen: what the company bought, what it may use, and how
 * much of each allowance is gone.
 *
 * Everything on the page is resolved server-side. The included/excluded module
 * list is rendered from the subscription's own `features` array intersected
 * with the catalog, never from a tier lookup in the client (D-093) — so a
 * repricing or a new module needs no release here.
 *
 * Usage reads the same ungated dashboard summaries the shell already caches, so
 * this page stays readable on a lapsed subscription: a company that cannot use
 * its modules must still be able to see why.
 */

const currency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 2,
});

/** Human labels for the entitlement keys. Anything unmapped falls back to the
 * key itself rather than being hidden, so a new module is visible immediately
 * even before it gets a label. */
const FEATURE_LABELS: Record<string, string> = {
  assets: "Asset registry, facilities and QR labels",
  inspections: "Inspections and checklist templates",
  ai_media_analysis: "AI photo and video analysis",
  safety_reports: "Safety incident reporting",
  documents: "Controlled document library",
  reports: "Generated reports and exports",
  digital_twin: "3D digital twin facility view",
  ar_inspection: "AR inspection and measurement",
  permits: "Permit to work",
  work_orders: "Work orders",
  vr_training: "VR training",
  sso: "Single sign-on / Azure AD",
  audit_export: "Audit log export",
};

function label(feature: string): string {
  return FEATURE_LABELS[feature] ?? feature;
}

function statusTone(status: string): "healthy" | "info" | "warning" | "critical" {
  switch (status) {
    case "active":
      return "healthy";
    case "trialing":
      return "info";
    case "past_due":
      return "warning";
    default:
      return "critical";
  }
}

function statusLabel(status: string): string {
  switch (status) {
    case "trialing":
      return "Trial";
    case "past_due":
      return "Payment overdue";
    case "canceled":
      return "Cancelled";
    case "incomplete":
      return "Not set up";
    default:
      return "Active";
  }
}

function formatDate(value: Date | null | undefined): string {
  if (!value) return "—";
  return new Intl.DateTimeFormat("en-GB", {
    day: "numeric",
    month: "short",
    year: "numeric",
  }).format(value);
}

function UsageRow({
  resource,
  used,
  limit,
  note,
}: {
  resource: string;
  used: number | null;
  limit: number | null | undefined;
  note: string;
}) {
  const unlimited = limit === null || limit === undefined;
  const ratio = !unlimited && limit > 0 && used !== null ? Math.min(1, used / limit) : null;
  const atLimit = ratio !== null && ratio >= 1;
  const near = ratio !== null && ratio >= 0.8 && !atLimit;
  const remaining = !unlimited && used !== null ? Math.max(0, limit - used) : null;

  return (
    <div className="border-t border-border py-4 first:border-t-0 first:pt-0">
      <div className="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1">
        <span className="text-body font-semibold text-text-primary">{resource}</span>
        <span className="font-mono text-bodySmall text-text-primary">
          {used === null ? "—" : used.toLocaleString("en-US")}
          <span className="text-text-muted">
            {unlimited ? " / unlimited" : ` / ${limit.toLocaleString("en-US")}`}
          </span>
        </span>
      </div>
      {ratio === null ? null : (
        <div
          aria-label={`${resource} usage`}
          aria-valuemax={100}
          aria-valuemin={0}
          aria-valuenow={Math.round(ratio * 100)}
          className="mt-2 h-1.5 overflow-hidden rounded-full bg-elevated"
          role="progressbar"
        >
          <div
            className={`h-full rounded-full ${
              atLimit
                ? "bg-status-critical"
                : near
                  ? "bg-status-warning"
                  : "bg-primary-600 dark:bg-primary-400"
            }`}
            style={{ width: `${ratio * 100}%` }}
          />
        </div>
      )}
      <p className="mt-2 text-caption text-text-muted">
        {atLimit
          ? `You have reached this limit — new ${resource.toLowerCase()} will be refused until you upgrade.`
          : remaining !== null
            ? `${remaining.toLocaleString("en-US")} remaining. ${note}`
            : note}
      </p>
    </div>
  );
}

export function SubscriptionPage({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const { apiClient } = useAuth();
  const { status, subscription, refresh } = useSubscription();

  const catalog = useCachedQuery<BillingCatalogResponse>("billing:catalog", () =>
    apiClient.getBillingCatalog(),
  );
  const summary = useCachedQuery("dashboard:summary:30", () => apiClient.getDashboardSummary(30), {
    enabled: status === "ready",
  });
  const assets = useCachedQuery(
    "dashboard:assets-summary",
    () => apiClient.getDashboardAssetsSummary(),
    { enabled: status === "ready" },
  );

  if (status === "loading") {
    // Whole-screen wait, so the branded loader rather than a bare spinner.
    return <PageLoader label="Loading your subscription" />;
  }

  if (status === "error" || subscription === null) {
    return (
      <section className="p-6">
        <Card className="max-w-xl p-6">
          <h1 className="font-heading text-h3 font-bold">Subscription unavailable</h1>
          <p className="mt-2 text-body text-text-secondary">
            We could not read your subscription just now. Your access is unaffected — this page
            only reports it.
          </p>
          <div className="mt-6">
            <Button onClick={() => void refresh()} variant="ghost">
              Try again
            </Button>
          </div>
        </Card>
      </section>
    );
  }

  const plan = catalog.data?.plans.find((entry) => entry.tier === subscription.tier) ?? null;
  const granted = new Set(subscription.features);
  // Every key the catalog knows about, so "not included" is a real list rather
  // than an absence the reader has to infer.
  const allFeatures = Array.from(
    new Set((catalog.data?.plans ?? []).flatMap((entry) => entry.features)),
  ).sort((a, b) => label(a).localeCompare(label(b)));
  const missing = allFeatures.filter((feature) => !granted.has(feature));
  const richest = catalog.data?.plans.at(-1) ?? null;

  return (
    <section className="p-6">
      <MotionSection className="mx-auto max-w-4xl" reducedMotionOverride={reducedMotionOverride}>
        <h1 className="font-heading text-h1 font-bold text-text-primary">Subscription</h1>
        <p className="mt-2 text-body text-text-secondary">
          What this company is on, what it can use, and how much of each allowance is left.
        </p>

        {/* -------------------------------------------------------- the plan */}
        <Card className="mt-8 p-6">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div>
              <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
                Current plan
              </p>
              <p className="mt-1.5 font-heading text-h2 font-bold text-text-primary">
                {subscription.planName ?? "No plan"}
              </p>
              {plan ? (
                <p className="mt-1 text-bodySmall text-text-secondary">{plan.audience}</p>
              ) : null}
            </div>
            <StatusPill tone={statusTone(subscription.status)}>
              {statusLabel(subscription.status)}
            </StatusPill>
          </div>

          <dl className="mt-6 grid gap-4 border-t border-border pt-5 sm:grid-cols-3">
            <div>
              <dt className="text-caption text-text-muted">List price</dt>
              <dd className="mt-1 font-mono text-bodySmall text-text-primary">
                {plan ? `${currency.format(plan.listMonthlyCents / 100)} / month` : "—"}
              </dd>
            </div>
            <div>
              <dt className="text-caption text-text-muted">
                {subscription.status === "trialing" ? "Trial ends" : "Renews"}
              </dt>
              <dd className="mt-1 font-mono text-bodySmall text-text-primary">
                {formatDate(
                  subscription.status === "trialing"
                    ? subscription.trialEndsAt
                    : subscription.currentPeriodEnd,
                )}
              </dd>
            </div>
            <div>
              <dt className="text-caption text-text-muted">Support</dt>
              <dd className="mt-1 text-bodySmall text-text-primary">{plan?.support ?? "—"}</dd>
            </div>
          </dl>

          {subscription.status === "past_due" ? (
            <p className="mt-5 rounded-lg border border-border bg-elevated p-3.5 text-bodySmall text-status-critical">
              A payment failed. Your access continues while Stripe retries, but update the card to
              avoid interruption.
            </p>
          ) : null}
          {subscription.isEntitled ? null : (
            <p className="mt-5 rounded-lg border border-border bg-elevated p-3.5 text-bodySmall text-status-critical">
              This company has no active subscription, so every operational module is unavailable
              until it is set up.
            </p>
          )}
          {subscription.trialDaysRemaining !== null &&
          subscription.trialDaysRemaining !== undefined ? (
            <p className="mt-5 text-bodySmall text-text-secondary">
              {subscription.trialDaysRemaining === 0
                ? "Your trial ends today. The card on file will be charged to continue."
                : `${subscription.trialDaysRemaining} day${
                    subscription.trialDaysRemaining === 1 ? "" : "s"
                  } left on your trial. Nothing has been charged yet.`}
            </p>
          ) : null}
        </Card>

        {/* ------------------------------------------------------------ usage */}
        <Card className="mt-6 p-6">
          <h2 className="font-heading text-h4 font-semibold text-text-primary">Usage</h2>
          <p className="mt-1 text-bodySmall text-text-secondary">
            Counts are live. The API refuses a create once a limit is reached, so these are the
            numbers that decide it.
          </p>
          <div className="mt-5">
            <UsageRow
              limit={subscription.quotas.seats}
              note="Anyone who signs in counts as a seat."
              resource="Seats"
              used={summary.data?.usersTotal ?? null}
            />
            <UsageRow
              limit={subscription.quotas.assets}
              note="Equipment tracked in the registry."
              resource="Assets"
              used={assets.data?.total ?? null}
            />
            <UsageRow
              limit={subscription.quotas.facilities}
              note="Sites in the asset hierarchy."
              resource="Facilities"
              used={null}
            />
          </div>
        </Card>

        {/* --------------------------------------------------------- modules */}
        <div className="mt-6 grid gap-6 md:grid-cols-2">
          <Card className="p-6">
            <h2 className="font-heading text-h4 font-semibold text-text-primary">Included</h2>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Enforced by the API, not just shown here.
            </p>
            <ul className="mt-4 grid gap-2.5">
              {[...granted]
                .sort((a, b) => label(a).localeCompare(label(b)))
                .map((feature) => (
                  <li className="flex gap-2.5 text-bodySmall text-text-secondary" key={feature}>
                    <span aria-hidden className="text-status-success">
                      ✓
                    </span>
                    {label(feature)}
                  </li>
                ))}
              {granted.size === 0 ? (
                <li className="text-bodySmall text-text-muted">Nothing — no active plan.</li>
              ) : null}
            </ul>
          </Card>

          <Card className="p-6">
            <h2 className="font-heading text-h4 font-semibold text-text-primary">Not included</h2>
            <p className="mt-1 text-bodySmall text-text-secondary">
              {missing.length === 0
                ? "Nothing — this plan includes every module."
                : `Available on a higher plan${richest ? ` (up to ${richest.name})` : ""}.`}
            </p>
            <ul className="mt-4 grid gap-2.5">
              {missing.map((feature) => (
                <li className="flex gap-2.5 text-bodySmall text-text-muted" key={feature}>
                  <span aria-hidden>—</span>
                  {label(feature)}
                </li>
              ))}
            </ul>
            {missing.length > 0 ? (
              <div className="mt-5">
                <Badge>Contact sales to change plan</Badge>
              </div>
            ) : null}
          </Card>
        </div>

        <p className="mt-6 text-caption text-text-muted">
          Billing is handled by Stripe. To change plan, update a card, or download invoices, email{" "}
          <a
            className="font-semibold text-text-secondary underline decoration-border underline-offset-4 hover:text-text-primary"
            href="mailto:sales@flacronenterprises.com?subject=Flacron%20Energy%20subscription"
          >
            sales@flacronenterprises.com
          </a>
          .
        </p>
      </MotionSection>
    </section>
  );
}
