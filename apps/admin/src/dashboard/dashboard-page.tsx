"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { usePermissions } from "@/auth/permissions";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Skeleton,
  StatusPill,
  TimeSeriesChart,
  cn,
  type ChartStatus,
} from "@/design-system";
import { navIcons } from "@/navigation/nav-config";

import {
  activityWindows,
  useDashboardData,
  type ActivityWindowDays,
} from "./dashboard-data";
import { actionIcons } from "./icons";
import {
  actionIconKey,
  describeAction,
  formatChartDay,
  formatCompanyDate,
  formatRelativeTime,
  formatTarget,
} from "./format";

function greetingName(email: string): string {
  return email
    .split("@")[0]
    .split(/[._-]+/)
    .filter(Boolean)
    .map((part) => part[0].toUpperCase() + part.slice(1))
    .join(" ");
}

function DashboardHeader() {
  const { currentUser } = useAuth();
  const [renderedAt] = useState(() => new Date());
  if (!currentUser) return null;
  return (
    <div className="flex flex-wrap items-start justify-between gap-4">
      <div>
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
          Dashboard
        </p>
        <h1 className="mt-2 text-h2 font-bold">Welcome, {greetingName(currentUser.email)}</h1>
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Badge>{currentUser.roleKey}</Badge>
          <span className="text-bodySmall text-text-secondary">{currentUser.companyName}</span>
        </div>
      </div>
      <p className="font-mono text-bodySmall text-text-muted" suppressHydrationWarning>
        {renderedAt.toLocaleDateString(undefined, {
          weekday: "long",
          month: "long",
          day: "numeric",
        })}
        {" · "}
        {renderedAt.toLocaleTimeString(undefined, { hour: "numeric", minute: "2-digit" })}
      </p>
    </div>
  );
}

function StatValue({
  label,
  status,
  value,
  onRetry,
}: {
  label: string;
  status: ChartStatus;
  value: number | null;
  onRetry: () => void;
}) {
  return (
    <Card className="p-4">
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">{label}</p>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status === "error" && (
        <button
          className="mt-3 text-bodySmall font-semibold text-statusStrong-critical underline dark:text-statusSoft-critical"
          onClick={onRetry}
          type="button"
        >
          Retry
        </button>
      )}
      {status === "ready" && (
        <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{value}</p>
      )}
    </Card>
  );
}

const windowLabel: Record<ActivityWindowDays, string> = {
  7: "7 days",
  30: "30 days",
  90: "90 days",
};

function WindowSwitcher({
  value,
  onChange,
}: {
  value: ActivityWindowDays;
  onChange: (window: ActivityWindowDays) => void;
}) {
  return (
    <div aria-label="Activity window" className="flex gap-1 rounded-md border border-border p-1" role="group">
      {activityWindows.map((window) => (
        <button
          aria-pressed={window === value}
          className={cn(
            "rounded px-2.5 py-1 text-bodySmall font-semibold transition-colors",
            window === value
              ? "bg-primary-800 text-white dark:bg-primary-400 dark:text-primary-900"
              : "text-text-secondary hover:bg-elevated",
          )}
          key={window}
          onClick={() => onChange(window)}
          type="button"
        >
          {windowLabel[window]}
        </button>
      ))}
    </div>
  );
}

function QuickActionsCard() {
  const router = useRouter();
  const { can } = usePermissions();
  const isDev = process.env.NODE_ENV === "development";
  const actions = [
    {
      key: "assets-demo",
      label: "Assets demo",
      description: "See the assets.write permission gate in action.",
      route: "/rbac-demo",
      icon: navIcons.assets,
      visible: can("assets.write"),
    },
    {
      key: "settings",
      label: "Admin & Settings",
      description: "Company configuration — coming soon.",
      route: "/settings",
      icon: navIcons.settings,
      visible: can("company.settings"),
    },
    {
      key: "design-system",
      label: "Design system",
      description: "Component and token showcase (development only).",
      route: "/design-system",
      icon: navIcons.dashboard,
      visible: isDev,
    },
  ].filter((action) => action.visible);

  return (
    <Card className="p-4">
      <h2 className="text-h5 font-bold">Quick actions</h2>
      <ul className="mt-4 grid gap-2">
        {actions.map((action) => (
          <li key={action.key}>
            <button
              className="flex w-full items-center gap-3 rounded-md border border-border p-3 text-left transition-colors hover:border-primary-400/60 hover:bg-elevated"
              onClick={() => router.push(action.route)}
              type="button"
            >
              {action.icon}
              <span>
                <span className="block text-bodySmall font-semibold">{action.label}</span>
                <span className="block text-caption text-text-muted">{action.description}</span>
              </span>
            </button>
          </li>
        ))}
        {actions.length === 0 && (
          <li className="text-bodySmall text-text-muted">
            No quick actions are available for your role yet.
          </li>
        )}
      </ul>
    </Card>
  );
}

const reservedKpiModules = [
  { label: "Assets", permission: "assets.read", copy: "Asset metrics appear once the Assets module is enabled." },
  {
    label: "Work Orders",
    permission: "work_orders.read",
    copy: "Work order metrics appear once the Work Orders module is enabled.",
  },
  { label: "Permits", permission: "permits.read", copy: "Permit metrics appear once the Permits module is enabled." },
  {
    label: "Safety & Incidents",
    permission: "safety.read",
    copy: "Safety and incident metrics appear once the Safety module is enabled.",
  },
] as const;

/** The visual contract 2.3's pluggable KPI framework will fill in. Every
 * tile is an honest empty state — never a placeholder number. */
function ReservedKpiRegion() {
  const { can } = usePermissions();
  const modules = reservedKpiModules.filter((module) => can(module.permission));
  if (modules.length === 0) return null;
  return (
    <Card className="p-4">
      <h2 className="text-h5 font-bold">On the roadmap</h2>
      <div className="mt-4 grid gap-3">
        {modules.map((module) => (
          <div className="rounded-md border border-dashed border-border p-3" key={module.label}>
            <p className="text-bodySmall font-semibold">{module.label}</p>
            <p className="mt-1 text-caption text-text-muted">{module.copy}</p>
          </div>
        ))}
      </div>
    </Card>
  );
}

function ActivityFeedItem({
  actorName,
  actorUid,
  action,
  targetType,
  targetId,
  createdAt,
}: {
  actorName?: string | null;
  actorUid: string;
  action: string;
  targetType: string;
  targetId: string;
  createdAt: Date;
}) {
  return (
    <li className="flex items-start gap-3 py-3">
      <span className="mt-0.5 text-text-muted">{actionIcons[actionIconKey(action)]}</span>
      <p className="flex-1 text-bodySmall">
        <span className="font-semibold">{actorName ?? actorUid}</span> {describeAction(action)}{" "}
        <span className="font-mono text-caption text-text-muted">
          {formatTarget(targetType, targetId)}
        </span>
      </p>
      <span className="shrink-0 font-mono text-caption text-text-muted">
        {formatRelativeTime(createdAt)}
      </span>
    </li>
  );
}

export function DashboardPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const { currentUser } = useAuth();
  const { can } = usePermissions();
  const data = useDashboardData();
  if (!currentUser) return null;

  const showUsers = can("users.manage");
  const showRoles = can("roles.manage");

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <DashboardHeader />
        <div className="mt-8 grid gap-6 lg:grid-cols-[1fr_320px]">
          <div className="grid gap-6">
            {(showUsers || showRoles) && (
              <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
                {showUsers && (
                  <StatValue
                    label="Users in company"
                    onRetry={data.retrySummary}
                    status={data.summary.status}
                    value={data.summary.data?.usersTotal ?? null}
                  />
                )}
                {showUsers && (
                  <StatValue
                    label="Active users"
                    onRetry={data.retrySummary}
                    status={data.summary.status}
                    value={data.summary.data?.usersActive ?? null}
                  />
                )}
                {showRoles && (
                  <StatValue
                    label="Roles configured"
                    onRetry={data.retrySummary}
                    status={data.summary.status}
                    value={data.summary.data?.rolesTotal ?? null}
                  />
                )}
                <StatValue
                  label={`Audit events (${windowLabel[data.window]})`}
                  onRetry={data.retrySummary}
                  status={data.summary.status}
                  value={data.summary.data?.auditEvents ?? null}
                />
              </div>
            )}
            {!showUsers && !showRoles && (
              <div className="grid grid-cols-1 gap-4">
                <StatValue
                  label={`Audit events (${windowLabel[data.window]})`}
                  onRetry={data.retrySummary}
                  status={data.summary.status}
                  value={data.summary.data?.auditEvents ?? null}
                />
              </div>
            )}

            <Card className="p-4">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <h2 className="text-h5 font-bold">Activity</h2>
                <WindowSwitcher onChange={data.setWindow} value={data.window} />
              </div>
              <div className="mt-4">
                <TimeSeriesChart
                  data={data.series.points.map((point) => ({
                    label: formatChartDay(point.date),
                    value: point.count,
                  }))}
                  emptyDescription="Activity appears here once events are recorded for this tenant."
                  emptyTitle="No activity to chart yet"
                  errorDescription="Couldn't load activity data. Check your connection and try again."
                  onRetry={data.retrySeries}
                  status={
                    data.series.status === "ready" && data.series.points.every((p) => p.count === 0)
                      ? "empty"
                      : data.series.status
                  }
                  valueLabel="Events"
                />
              </div>
            </Card>

            <Card className="p-4">
              <h2 className="text-h5 font-bold">Recent activity</h2>
              {data.activity.status === "loading" && (
                <div className="mt-4 grid gap-3">
                  <Skeleton className="h-10 w-full" />
                  <Skeleton className="h-10 w-full" />
                  <Skeleton className="h-10 w-full" />
                </div>
              )}
              {data.activity.status === "error" && (
                <div className="mt-4">
                  <EmptyState
                    action={
                      <Button onClick={data.retryActivity} variant="ghost">
                        Retry
                      </Button>
                    }
                    description="Couldn't load recent activity. Check your connection and try again."
                    title="Something went wrong"
                  />
                </div>
              )}
              {data.activity.status === "ready" && data.activity.items.length === 0 && (
                <div className="mt-4">
                  <EmptyState
                    description="Activity will appear here as your team uses FEV."
                    title="No activity yet"
                  />
                </div>
              )}
              {data.activity.status === "ready" && data.activity.items.length > 0 && (
                <>
                  <ul className="mt-2 divide-y divide-border" data-testid="activity-feed">
                    {data.activity.items.map((item) => (
                      <ActivityFeedItem
                        action={item.action}
                        actorName={item.actorName}
                        actorUid={item.actorUid}
                        createdAt={item.createdAt}
                        key={item.id}
                        targetId={item.targetId}
                        targetType={item.targetType}
                      />
                    ))}
                  </ul>
                  {data.activity.nextCursor && (
                    <div className="mt-3">
                      <Button
                        loading={data.activity.loadingMore}
                        onClick={() => void data.loadMoreActivity()}
                        variant="ghost"
                      >
                        Load more
                      </Button>
                    </div>
                  )}
                </>
              )}
            </Card>
          </div>

          <div className="grid gap-6">
            <QuickActionsCard />
            <ReservedKpiRegion />
            {data.summary.status === "ready" && data.summary.data && (
              <Card className="p-4">
                <StatusPill tone="info">{data.summary.data.subscriptionTier}</StatusPill>
                <p className="mt-3 text-bodySmall text-text-secondary">
                  Company since {formatCompanyDate(data.summary.data.companyCreatedAt)}
                </p>
              </Card>
            )}
          </div>
        </div>
      </MotionSection>
    </section>
  );
}
