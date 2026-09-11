"use client";

import type { ReportDashboardSummary } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { registerWidget } from "@/dashboard/widget-registry";
import { Card, Skeleton } from "@/design-system";

type Status = "loading" | "error" | "ready";

import { useCachedQuery } from "@/cache/cache-context";

function ReportsGeneratedWidget() {
  const router = useRouter();
  const { apiClient } = useAuth();
  const query = useCachedQuery<ReportDashboardSummary>(
    "dashboard:reports:summary",
    () => apiClient.getDashboardReportsSummary(),
  );

  const status: Status = query.loading ? "loading" : query.error ? "error" : "ready";
  const data = query.data;

  return (
    <Card
      className="cursor-pointer p-4"
      onClick={() => router.push("/reports")}
    >
      <div className="flex items-center justify-between">
        <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
          Reports generated
        </p>
        {status === "error" && (
          <button
            className="text-caption font-semibold underline hover:text-text-primary text-text-muted"
            onClick={(event) => {
              event.stopPropagation();
              void query.refetch();
            }}
            type="button"
          >
            Retry
          </button>
        )}
      </div>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status !== "loading" && (
        <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{data?.total ?? 0}</p>
      )}
    </Card>
  );
}

registerWidget({
  id: "reports.total",
  title: "Reports generated",
  requiredPermission: "reports.read",
  size: "sm",
  render: () => <ReportsGeneratedWidget />,
});
