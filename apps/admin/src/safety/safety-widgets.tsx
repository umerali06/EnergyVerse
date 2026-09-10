"use client";

import type { SafetyDashboardSummary } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { registerWidget } from "@/dashboard/widget-registry";
import { Card, DonutChart, Skeleton, type ChartStatus } from "@/design-system";

type Status = "loading" | "error" | "ready";

const CATEGORY_LABELS: Record<string, string> = {
  near_miss: "Near miss",
  unsafe_condition: "Unsafe condition",
  unsafe_behavior: "Unsafe behavior",
  fire: "Fire",
  gas_leak: "Gas leak",
  chemical_spill: "Chemical spill",
  environmental_incident: "Environmental incident",
  equipment_failure: "Equipment failure",
  injury: "Injury",
};

import { useCachedQuery } from "@/cache/cache-context";

function useSafetySummary() {
  const { apiClient } = useAuth();
  const query = useCachedQuery<SafetyDashboardSummary>(
    "dashboard:safety:summary",
    () => apiClient.getDashboardSafetySummary(),
  );
  return {
    status: query.loading ? "loading" : query.error ? "error" : "ready",
    data: query.data,
    retry: query.refetch,
  };
}

function SafetyIncidentsWidget() {
  const router = useRouter();
  const { data, status, retry } = useSafetySummary();
  return (
    <Card className="cursor-pointer p-4" onClick={status === "ready" ? () => router.push("/safety") : undefined}>
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">Safety incidents</p>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status === "error" && <button className="mt-3 font-semibold underline" onClick={(event) => { event.stopPropagation(); void retry(); }} type="button">Retry</button>}
      {status === "ready" && <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{data?.total}</p>}
    </Card>
  );
}

function SafetyByTypeWidget() {
  const { data, status, retry } = useSafetySummary();
  const chartStatus: ChartStatus = status === "ready" && data?.total === 0 ? "empty" : status;
  return (
    <Card className="p-4">
      <h2 className="text-h5 font-bold">Safety incidents by type</h2>
      <div className="mt-4">
        <DonutChart
          data={data?.byCategory.map((item) => ({ label: CATEGORY_LABELS[item.category], value: item.count })) ?? []}
          emptyDescription="Incident types appear here once safety reports are recorded for this tenant."
          emptyTitle="No safety incidents to chart"
          errorDescription="Couldn't load safety incident data. Check your connection and try again."
          onRetry={retry}
          status={chartStatus}
        />
      </div>
    </Card>
  );
}

registerWidget({ id: "safety.total", title: "Safety incidents", requiredPermission: "safety.read", size: "sm", render: () => <SafetyIncidentsWidget /> });
registerWidget({ id: "safety.by-type", title: "Safety incidents by type", requiredPermission: "safety.read", size: "lg", render: () => <SafetyByTypeWidget /> });
