"use client";

import type { AssetDashboardSummary } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { registerWidget } from "@/dashboard/widget-registry";
import { Card, DonutChart, Skeleton, type ChartStatus } from "@/design-system";

type AsyncStatus = "loading" | "error" | "ready";
type AsyncSlice = { status: AsyncStatus; data: AssetDashboardSummary | null };

/**
 * Each asset widget fetches independently rather than sharing one hook
 * instance -- a pluggable widget is self-contained by design, so one
 * widget's failure (or a future module's widget failure) can never be
 * entangled with another's. The endpoint itself is cheap (Firestore count()
 * aggregation, see D-039), so the extra requests are not a real cost.
 */
function useAssetDashboardSummary() {
  const { apiClient } = useAuth();
  const [slice, setSlice] = useState<AsyncSlice>({ status: "loading", data: null });
  const requestId = useRef(0);

  const fetchSummary = useCallback(async () => {
    const id = ++requestId.current;
    setSlice({ status: "loading", data: null });
    try {
      const result = await apiClient.getDashboardAssetsSummary();
      if (requestId.current === id) setSlice({ status: "ready", data: result });
    } catch {
      if (requestId.current === id) setSlice({ status: "error", data: null });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchSummary();
  }, [fetchSummary]);

  return { ...slice, retry: fetchSummary };
}

function StatCard({
  label,
  status,
  value,
  onRetry,
  onClick,
  emphasis,
}: {
  label: string;
  status: AsyncStatus;
  value: number | null;
  onRetry: () => void;
  onClick: () => void;
  emphasis?: boolean;
}) {
  return (
    <Card
      className={emphasis ? "cursor-pointer border-status-critical/40 bg-status-critical/5 p-4" : "cursor-pointer p-4"}
      onClick={status === "ready" ? onClick : undefined}
    >
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">{label}</p>
      {status === "loading" && <Skeleton className="mt-3 h-8 w-16" />}
      {status === "error" && (
        <button
          className="mt-3 text-bodySmall font-semibold text-statusStrong-critical underline dark:text-statusSoft-critical"
          onClick={(event) => {
            event.stopPropagation();
            onRetry();
          }}
          type="button"
        >
          Retry
        </button>
      )}
      {status === "ready" && (
        <p
          className={
            emphasis
              ? "mt-1 font-mono text-h2 font-bold tabular-nums text-statusStrong-critical dark:text-statusSoft-critical"
              : "mt-1 font-mono text-h2 font-bold tabular-nums"
          }
        >
          {value}
        </p>
      )}
    </Card>
  );
}

function TotalAssetsWidget() {
  const router = useRouter();
  const { status, data, retry } = useAssetDashboardSummary();
  return (
    <StatCard
      label="Total assets"
      onClick={() => router.push("/assets")}
      onRetry={retry}
      status={status}
      value={data?.total ?? null}
    />
  );
}

function CriticalAssetsWidget() {
  const router = useRouter();
  const { status, data, retry } = useAssetDashboardSummary();
  return (
    <StatCard
      emphasis
      label="Critical assets"
      onClick={() => router.push("/assets?status=Critical")}
      onRetry={retry}
      status={status}
      value={data?.critical ?? null}
    />
  );
}

function AssetConditionWidget() {
  const { status, data, retry } = useAssetDashboardSummary();
  const chartStatus: ChartStatus =
    status === "ready" && data && data.total === 0 ? "empty" : status;
  const slices = data ? [
    { label: "Healthy", value: data.healthy },
    { label: "Warning", value: data.warning },
    { label: "Critical", value: data.critical },
  ] : [];
  return (
    <Card className="p-4">
      <h2 className="text-h5 font-bold">Asset condition</h2>
      <div className="mt-4">
        <DonutChart
          data={slices}
          emptyDescription="Asset condition appears here once assets are recorded for this tenant."
          emptyTitle="No assets to chart yet"
          errorDescription="Couldn't load asset condition data. Check your connection and try again."
          onRetry={retry}
          status={chartStatus}
        />
      </div>
    </Card>
  );
}

registerWidget({
  id: "assets.total",
  title: "Total assets",
  requiredPermission: "assets.read",
  size: "sm",
  render: () => <TotalAssetsWidget />,
});

registerWidget({
  id: "assets.critical",
  title: "Critical assets",
  requiredPermission: "assets.read",
  size: "sm",
  render: () => <CriticalAssetsWidget />,
});

registerWidget({
  id: "assets.condition",
  title: "Asset condition",
  requiredPermission: "assets.read",
  size: "lg",
  render: () => <AssetConditionWidget />,
});
