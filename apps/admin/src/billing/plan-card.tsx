"use client";

import Link from "next/link";

import { Card, Spinner, StatusPill } from "@/design-system";

import { useSubscription } from "./subscription-context";

/**
 * The company's plan, on the dashboard.
 *
 * Shows what was bought, how long a trial has left, and usage against each
 * quota — the three things an admin needs before they hit a limit rather than
 * after. Limits come from the API's resolved entitlements, never from a
 * client-side tier table (D-093).
 *
 * Usage counts are passed in by the dashboard, which already loads them for its
 * KPI cards; this component does no fetching of its own.
 */

function toneFor(status: string): "healthy" | "warning" | "critical" | "info" {
  switch (status) {
    case "active":
      return "healthy";
    case "trialing":
      return "info";
    case "past_due":
      return "warning";
    case "canceled":
      return "critical";
    default:
      return "warning";
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

function UsageRow({
  label,
  used,
  limit,
}: {
  label: string;
  used: number | null;
  limit: number | null | undefined;
}) {
  const unlimited = limit === null || limit === undefined;
  // Only a real count against a real cap can produce a percentage; anything
  // else renders as text rather than a misleading empty bar.
  const ratio = !unlimited && limit > 0 && used !== null ? Math.min(1, used / limit) : null;
  const atLimit = ratio !== null && ratio >= 1;
  const near = ratio !== null && ratio >= 0.8 && !atLimit;

  return (
    <div>
      <div className="flex items-baseline justify-between gap-3">
        <span className="text-bodySmall text-text-secondary">{label}</span>
        <span className="font-mono text-caption text-text-primary">
          {used === null ? "—" : used.toLocaleString("en-US")}
          {unlimited ? (
            <span className="text-text-muted"> / unlimited</span>
          ) : (
            <span className="text-text-muted"> / {limit.toLocaleString("en-US")}</span>
          )}
        </span>
      </div>
      {ratio === null ? null : (
        <div
          aria-label={`${label} usage`}
          aria-valuemax={100}
          aria-valuemin={0}
          aria-valuenow={Math.round(ratio * 100)}
          className="mt-1.5 h-1 overflow-hidden rounded-full bg-elevated"
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
    </div>
  );
}

export function PlanCard({
  facilitiesUsed = null,
  assetsUsed = null,
  seatsUsed = null,
}: {
  facilitiesUsed?: number | null;
  assetsUsed?: number | null;
  seatsUsed?: number | null;
}) {
  const { status, subscription } = useSubscription();

  if (status === "loading") {
    return (
      <Card className="p-5">
        <p className="flex items-center gap-2.5 text-bodySmall text-text-secondary">
          <Spinner label="Loading your plan" size="sm" />
          Loading your plan
        </p>
      </Card>
    );
  }

  if (status === "error" || subscription === null) {
    return (
      <Card className="p-5">
        <p className="text-bodySmall text-text-secondary">
          We could not load your plan just now. Your access is unaffected.
        </p>
      </Card>
    );
  }

  const trialDays = subscription.trialDaysRemaining;
  const quotas = subscription.quotas;

  return (
    <Card className="p-5">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            Your plan
          </p>
          <p className="mt-1.5 font-heading text-h3 font-bold text-text-primary">
            {subscription.planName ?? "No plan"}
          </p>
        </div>
        <StatusPill tone={toneFor(subscription.status)}>
          {statusLabel(subscription.status)}
        </StatusPill>
      </div>

      {subscription.isEntitled ? null : (
        <p className="mt-3 text-bodySmall text-text-secondary">
          This company has no active subscription, so its modules are unavailable.
        </p>
      )}

      {trialDays !== null && trialDays !== undefined ? (
        <p className="mt-3 text-bodySmall text-text-secondary">
          {trialDays === 0
            ? "Your trial ends today."
            : `${trialDays} day${trialDays === 1 ? "" : "s"} left on your trial.`}
        </p>
      ) : null}

      {subscription.status === "past_due" ? (
        <p className="mt-3 text-bodySmall text-status-critical">
          A payment failed. Your access continues while Stripe retries — update your card to avoid
          interruption.
        </p>
      ) : null}

      <div className="mt-5 grid gap-3.5 border-t border-border pt-4">
        <UsageRow label="Facilities" limit={quotas.facilities} used={facilitiesUsed} />
        <UsageRow label="Assets" limit={quotas.assets} used={assetsUsed} />
        <UsageRow label="Seats" limit={quotas.seats} used={seatsUsed} />
      </div>

      <div className="mt-5 border-t border-border pt-4">
        <Link
          className="text-bodySmall font-semibold text-primary-600 underline decoration-border underline-offset-4 hover:text-primary-700 dark:text-primary-400"
          href="/settings"
        >
          Manage subscription
        </Link>
      </div>
    </Card>
  );
}
