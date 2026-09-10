"use client";

import type { WorkOrderListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";
import { registerWidget } from "@/dashboard/widget-registry";
import { Card, Skeleton } from "@/design-system";

type Status = "loading" | "error" | "ready";

function WorkOrdersWidget() {
  const router = useRouter();
  const { apiClient } = useAuth();
  const query = useCachedQuery<{ items: WorkOrderListItem[] }>(
    "dashboard:work-orders:summary",
    () => apiClient.listWorkOrders({ limit: 100 }),
  );

  const status: Status = query.loading ? "loading" : query.error ? "error" : "ready";
  const items = query.data?.items ?? [];
  const openCount = items.filter((item) => item.status === "open" || item.status === "in_progress").length;

  return (
    <Card
      className="cursor-pointer p-4"
      onClick={() => router.push("/work-orders")}
    >
      <div className="flex items-center justify-between">
        <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
          Open work orders
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
        <p className="mt-1 font-mono text-h2 font-bold tabular-nums">{openCount}</p>
      )}
    </Card>
  );
}

registerWidget({
  id: "work-orders.open",
  title: "Open work orders",
  requiredPermission: "work_orders.read",
  requiredFeature: "work_orders",
  size: "sm",
  render: () => <WorkOrdersWidget />,
});
