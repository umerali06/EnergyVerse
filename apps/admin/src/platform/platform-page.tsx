"use client";

import { useState } from "react";

import {
  Badge,
  Button,
  Card,
  DonutChart,
  EmptyState,
  MotionSection,
  Skeleton,
  StatusPill,
  TableShell,
  type ChartStatus,
} from "@/design-system";

import { PlatformCompanyModal } from "./platform-company-modal";
import { usePlatformCompaniesData } from "./platform-data";

function StatTile({
  label,
  status,
  value,
}: {
  label: string;
  status: ChartStatus;
  value: number | null;
}) {
  return (
    <Card className="p-4">
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">{label}</p>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status === "ready" && (
        <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{value}</p>
      )}
    </Card>
  );
}

export function PlatformPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const data = usePlatformCompaniesData();
  const [selectedCompanyId, setSelectedCompanyId] = useState<string | null>(null);

  const statsStatus: ChartStatus =
    data.stats.status === "loading" ? "loading" : data.stats.status === "error" ? "error" : "ready";
  const stats = data.stats.value;
  const donutData =
    stats && stats.totalCompanies > 0
      ? [
          { label: "Active", value: stats.activeTenants },
          { label: "Suspended", value: stats.totalCompanies - stats.activeTenants },
        ].filter((slice) => slice.value > 0)
      : [];

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <div className="flex items-center gap-2">
              <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
                Platform
              </p>
              <Badge>Cross-tenant</Badge>
            </div>
            <h1 className="mt-2 text-h2 font-bold">Platform Administration</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Manage every tenant on FEV — company status, subscription tier, and platform-wide
              oversight. Every action here is audited.
            </p>
          </div>
        </div>

        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <StatTile label="Companies" status={statsStatus} value={stats?.totalCompanies ?? null} />
          <StatTile label="Active tenants" status={statsStatus} value={stats?.activeTenants ?? null} />
          <StatTile label="Total users" status={statsStatus} value={stats?.totalUsers ?? null} />
          <StatTile
            label={`New signups (${stats?.windowDays ?? 30}d)`}
            status={statsStatus}
            value={stats?.recentSignups ?? null}
          />
        </div>

        <Card className="mt-4 p-4">
          <p className="mb-2 font-mono text-caption uppercase tracking-[0.14em] text-text-muted">
            Tenant status mix
          </p>
          <DonutChart
            data={donutData}
            emptyDescription="No tenants exist yet."
            emptyTitle="No tenants"
            errorDescription="Couldn't load platform stats. Check your connection and try again."
            height={220}
            onRetry={data.retryStats}
            status={
              statsStatus === "ready" && donutData.length === 0 ? "empty" : statsStatus
            }
          />
        </Card>

        <Card className="mt-4 p-0">
          {data.list.status === "loading" && (
            <div className="grid gap-3 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          )}
          {data.list.status === "error" && (
            <div className="p-4">
              <EmptyState
                action={
                  <Button onClick={data.retryList} variant="ghost">
                    Retry
                  </Button>
                }
                description="Couldn't load companies. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState description="No companies exist yet." title="No companies found" />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <TableShell label="Platform companies">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Company
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Status
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Tier
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Users
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      <span className="sr-only">Actions</span>
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="platform-companies-table-body">
                  {data.list.items.map((company) => (
                    <tr className="border-b border-border last:border-0" key={company.id}>
                      <td className="p-3">
                        <span className="block text-bodySmall font-semibold">{company.name}</span>
                        <span className="block font-mono text-caption text-text-muted">
                          {company.id}
                        </span>
                      </td>
                      <td className="p-3">
                        <StatusPill tone={company.status === "active" ? "healthy" : "critical"}>
                          {company.status}
                        </StatusPill>
                      </td>
                      <td className="p-3">
                        <Badge>{company.subscriptionTier}</Badge>
                      </td>
                      <td className="p-3 font-mono text-bodySmall">{company.usersTotal}</td>
                      <td className="p-3 text-right">
                        <button
                          className="text-bodySmall font-semibold text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                          onClick={() => setSelectedCompanyId(company.id)}
                          type="button"
                        >
                          View
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </TableShell>
              {data.list.nextCursor && (
                <div className="p-4">
                  <Button
                    loading={data.list.loadingMore}
                    onClick={() => void data.loadMore()}
                    variant="ghost"
                  >
                    Load more
                  </Button>
                </div>
              )}
            </>
          )}
        </Card>
      </MotionSection>

      <PlatformCompanyModal
        companyId={selectedCompanyId}
        getCompany={data.getCompany}
        onChanged={data.refresh}
        onClose={() => setSelectedCompanyId(null)}
        setCompanyStatus={data.setCompanyStatus}
        setSubscriptionTier={data.setSubscriptionTier}
      />
    </section>
  );
}
