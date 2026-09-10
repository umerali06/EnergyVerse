"use client";

import type { PermitDashboardSummary } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { registerWidget } from "@/dashboard/widget-registry";
import { Card, Skeleton } from "@/design-system";

type Status = "loading" | "error" | "ready";

import { useCachedQuery } from "@/cache/cache-context";

function ActivePermitsWidget() {
  const router = useRouter();
  const { apiClient } = useAuth();
  const query = useCachedQuery<PermitDashboardSummary>(
    "dashboard:permits:summary",
    () => apiClient.getDashboardPermitsSummary(),
  );

  const status: Status = query.loading ? "loading" : query.error ? "error" : "ready";
  const data = query.data;

  return (
    <Card
      className="cursor-pointer p-4"
      onClick={status === "ready" ? () => router.push("/permits") : undefined}
    >
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
        Active permits
      </p>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status === "error" && (
        <button
          className="mt-3 font-semibold underline"
          onClick={(event) => {
            event.stopPropagation();
            void query.refetch();
          }}
          type="button"
        >
          Retry
        </button>
      )}
      {status === "ready" && (
        <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{data?.active ?? 0}</p>
      )}
    </Card>
  );
}

registerWidget({
  id: "permits.active",
  title: "Active permits",
  requiredPermission: "permits.read",
  requiredFeature: "permits",
  size: "sm",
  render: () => <ActivePermitsWidget />,
});
