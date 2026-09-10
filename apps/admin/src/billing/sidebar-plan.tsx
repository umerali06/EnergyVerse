"use client";

import Link from "next/link";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";

import { useSubscription } from "./subscription-context";

/**
 * Plan and headline usage at the foot of the sidebar.
 *
 * Replaces a footer that only offered "Collapse". An admin needs to know which
 * plan the company is on and how close it is to a cap *before* a create fails
 * with a 402 — and the sidebar is the one surface present on every screen. The
 * collapse control keeps its place beside it as an icon.
 *
 * Caps come from the subscription's quotas; the counts are read through the
 * same cache keys the dashboard uses, so on that page they are already
 * resolved and cost no extra request. A count that has not arrived renders as
 * a dash rather than a fabricated zero.
 */

function statusLabel(status: string): string {
  switch (status) {
    case "trialing":
      return "Trial";
    case "past_due":
      return "Payment due";
    case "canceled":
      return "Cancelled";
    case "incomplete":
      return "Not set up";
    default:
      return "Active";
  }
}

function toneClass(status: string): string {
  switch (status) {
    case "past_due":
      return "text-status-warning";
    case "canceled":
    case "incomplete":
      return "text-status-critical";
    case "trialing":
      return "text-primary-600 dark:text-primary-300";
    default:
      return "text-status-success";
  }
}

/** Compact bar; only rendered when a real count meets a real cap. */
function MiniUsage({
  label,
  used,
  limit,
}: {
  label: string;
  used: number | null;
  limit: number | null | undefined;
}) {
  const unlimited = limit === null || limit === undefined;
  const ratio = !unlimited && limit > 0 && used !== null ? Math.min(1, used / limit) : null;
  const atLimit = ratio !== null && ratio >= 1;
  const near = ratio !== null && ratio >= 0.8 && !atLimit;

  return (
    <div>
      <div className="flex items-baseline justify-between gap-2">
        <span className="text-micro text-text-muted">{label}</span>
        <span className="font-mono text-micro text-text-secondary">
          {used === null ? "—" : used.toLocaleString("en-US")}
          {unlimited ? "" : ` / ${limit.toLocaleString("en-US")}`}
        </span>
      </div>
      {ratio === null ? null : (
        <div
          aria-label={`${label} usage`}
          aria-valuemax={100}
          aria-valuemin={0}
          aria-valuenow={Math.round(ratio * 100)}
          className="mt-1 h-0.5 overflow-hidden rounded-full bg-elevated"
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

export function SidebarPlanSummary({ collapsed }: { collapsed: boolean }) {
  const { status, subscription } = useSubscription();
  const { apiClient } = useAuth();

  // Same cache keys the dashboard uses, so on that page these are already
  // resolved and no extra request is made. Both routes are ungated, so they
  // stay readable on a lapsed subscription.
  const summary = useCachedQuery(
    "dashboard:summary:30",
    () => apiClient.getDashboardSummary(30),
    { enabled: status === "ready" },
  );
  const assets = useCachedQuery(
    "dashboard:assets-summary",
    () => apiClient.getDashboardAssetsSummary(),
    { enabled: status === "ready" },
  );

  const seatsUsed = summary.data?.usersTotal ?? null;
  const assetsUsed = assets.data?.total ?? null;

  if (status !== "ready" || subscription === null) {
    // Silent while loading: a placeholder here would flicker on every
    // navigation, and the dashboard's plan card already reports load failures.
    return null;
  }

  const trialDays = subscription.trialDaysRemaining;

  // Collapsed rail: a single dot carrying the plan in its tooltip, so the
  // information is still reachable without the width.
  if (collapsed) {
    return (
      <Link
        aria-label={`${subscription.planName ?? "No plan"} — ${statusLabel(subscription.status)}. Manage subscription`}
        className="mx-auto grid size-9 place-items-center rounded-lg outline-none hover:bg-elevated focus-visible:ring-2 focus-visible:ring-primary-400"
        href="/settings/subscription"
        title={`${subscription.planName ?? "No plan"} — ${statusLabel(subscription.status)}`}
      >
        <span
          aria-hidden
          className={`size-2 rounded-full ${
            subscription.isEntitled ? "bg-status-success" : "bg-status-critical"
          }`}
        />
      </Link>
    );
  }

  return (
    <div className="grid gap-2.5">
      <Link
        className="group grid gap-0.5 rounded-lg px-2 py-1.5 outline-none hover:bg-elevated focus-visible:ring-2 focus-visible:ring-primary-400"
        href="/settings/subscription"
      >
        <span className="flex items-center justify-between gap-2">
          <span className="text-bodySmall font-semibold text-text-primary">
            {subscription.planName ?? "No plan"}
          </span>
          <span className={`font-mono text-micro ${toneClass(subscription.status)}`}>
            {statusLabel(subscription.status)}
          </span>
        </span>
        {trialDays !== null && trialDays !== undefined ? (
          <span className="text-micro text-text-muted">
            {trialDays === 0 ? "Trial ends today" : `${trialDays} days left`}
          </span>
        ) : (
          <span className="text-micro text-text-muted group-hover:text-text-secondary">
            Manage subscription
          </span>
        )}
      </Link>

      <div className="grid gap-2 px-2">
        <MiniUsage label="Seats" limit={subscription.quotas.seats} used={seatsUsed} />
        <MiniUsage label="Assets" limit={subscription.quotas.assets} used={assetsUsed} />
      </div>
    </div>
  );
}
