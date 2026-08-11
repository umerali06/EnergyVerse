"use client";

import type { WorkOrderListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  FilterChip,
  MotionSection,
  Select,
  Skeleton,
  StatusPill,
  TableShell,
  type StatusTone,
} from "@/design-system";

import { CreateWorkOrderModal } from "./work-order-modals";
import { assetLabel, facilityName, technicianName, useWorkOrdersData } from "./work-orders-data";

export function statusTone(status: string): StatusTone | null {
  switch (status) {
    case "open":
    case "assigned":
      return "info";
    case "in_progress":
    case "pending_review":
      return "warning";
    case "closed":
      return "healthy";
    default:
      // "cancelled" has no matching StatusTone -- rendered as a plain Badge.
      return null;
  }
}

export function statusLabel(status: string): string {
  return status.replace(/_/g, " ").replace(/^\w/, (letter) => letter.toUpperCase());
}

export function priorityTone(priority: string): StatusTone {
  switch (priority) {
    case "low":
      return "healthy";
    case "medium":
      return "info";
    case "high":
      return "warning";
    default:
      return "critical";
  }
}

export function priorityLabel(priority: string): string {
  return priority.replace(/^\w/, (letter) => letter.toUpperCase());
}

export function StatusBadge({ status }: { status: string }) {
  const tone = statusTone(status);
  if (!tone) return <Badge>{statusLabel(status)}</Badge>;
  return <StatusPill tone={tone}>{statusLabel(status)}</StatusPill>;
}

export function WorkOrdersPage({
  reducedMotionOverride,
}: { reducedMotionOverride?: boolean } = {}) {
  const data = useWorkOrdersData();
  const router = useRouter();
  const { currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("work_orders.write") ?? false;
  const [createOpen, setCreateOpen] = useState(false);

  // The backend has no server-side priority filter (see ListWorkOrdersRequest
  // in the generated client); this narrows the currently loaded page only.
  const visibleItems = data.filters.priority
    ? data.list.items.filter((item) => item.priority === data.filters.priority)
    : data.list.items;

  const activeChips: Array<{ key: string; label: string; clear: () => void }> = [
    data.filters.status
      ? {
          key: "status",
          label: `Status: ${statusLabel(data.filters.status)}`,
          clear: () => data.setFilter("status", null),
        }
      : null,
    data.filters.priority
      ? {
          key: "priority",
          label: `Priority: ${priorityLabel(data.filters.priority)}`,
          clear: () => data.setFilter("priority", null),
        }
      : null,
    data.filters.assetId
      ? {
          key: "assetId",
          label: `Asset: ${assetLabel(data.assets.items, data.filters.assetId)}`,
          clear: () => data.setFilter("assetId", null),
        }
      : null,
    data.filters.facilityId
      ? {
          key: "facilityId",
          label: `Facility: ${facilityName(data.facilities.items, data.filters.facilityId)}`,
          clear: () => data.setFilter("facilityId", null),
        }
      : null,
    data.filters.technicianId
      ? {
          key: "technicianId",
          label: `Technician: ${technicianName(data.technicians.items, data.filters.technicianId) ?? data.filters.technicianId}`,
          clear: () => data.setFilter("technicianId", null),
        }
      : null,
  ].filter((chip): chip is { key: string; label: string; clear: () => void } => chip !== null);

  function renderRow(workOrder: WorkOrderListItem) {
    const technician = technicianName(data.technicians.items, workOrder.technicianId);
    return (
      <tr
        className="cursor-pointer border-b border-border last:border-0 hover:bg-elevated/60"
        key={workOrder.id}
        onClick={() => router.push(`/work-orders/${workOrder.id}`)}
      >
        <td className="p-3 text-bodySmall font-semibold">{workOrder.title}</td>
        <td className="p-3 text-bodySmall text-text-secondary">
          {assetLabel(data.assets.items, workOrder.assetId)}
        </td>
        <td className="p-3">
          <StatusPill tone={priorityTone(workOrder.priority)}>
            {priorityLabel(workOrder.priority)}
          </StatusPill>
        </td>
        <td className="p-3">
          <StatusBadge status={workOrder.status} />
        </td>
        <td className="p-3 text-bodySmall text-text-secondary">{technician ?? "Unassigned"}</td>
        <td className="p-3 font-mono text-caption text-text-muted">
          {workOrder.dueDate ? formatRelativeTime(workOrder.dueDate) : "—"}
        </td>
      </tr>
    );
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Operations
            </p>
            <h1 className="mt-2 text-h2 font-bold">Work Orders</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Repairs and maintenance work tracked across your facilities.
            </p>
          </div>
          {canWrite && <Button onClick={() => setCreateOpen(true)}>Create work order</Button>}
        </div>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <Select
              label="Status"
              onChange={(event) => data.setFilter("status", event.target.value || null)}
              value={data.filters.status ?? ""}
            >
              <option value="">All statuses</option>
              <option value="open">Open</option>
              <option value="assigned">Assigned</option>
              <option value="in_progress">In progress</option>
              <option value="pending_review">Pending review</option>
              <option value="closed">Closed</option>
              <option value="cancelled">Cancelled</option>
            </Select>
            <Select
              label="Priority"
              onChange={(event) => data.setFilter("priority", event.target.value || null)}
              value={data.filters.priority ?? ""}
            >
              <option value="">All priorities</option>
              <option value="low">Low</option>
              <option value="medium">Medium</option>
              <option value="high">High</option>
              <option value="critical">Critical</option>
            </Select>
            <Select
              label="Asset"
              onChange={(event) => data.setFilter("assetId", event.target.value || null)}
              value={data.filters.assetId ?? ""}
            >
              <option value="">All assets</option>
              {data.assets.items.map((asset) => (
                <option key={asset.id} value={asset.id}>
                  {asset.name} ({asset.assetTag})
                </option>
              ))}
            </Select>
            <Select
              label="Facility"
              onChange={(event) => data.setFilter("facilityId", event.target.value || null)}
              value={data.filters.facilityId ?? ""}
            >
              <option value="">All facilities</option>
              {data.facilities.items.map((facility) => (
                <option key={facility.id} value={facility.id}>
                  {facility.name}
                </option>
              ))}
            </Select>
            <Select
              label="Technician"
              onChange={(event) => data.setFilter("technicianId", event.target.value || null)}
              value={data.filters.technicianId ?? ""}
            >
              <option value="">All technicians</option>
              {data.technicians.items.map((user) => (
                <option key={user.id} value={user.id}>
                  {user.displayName}
                </option>
              ))}
            </Select>
          </div>
          {activeChips.length > 0 && (
            <div className="mt-3 flex flex-wrap items-center gap-2">
              {activeChips.map((chip) => (
                <FilterChip key={chip.key} onDismiss={chip.clear}>
                  {chip.label}
                </FilterChip>
              ))}
              <button
                className="text-caption font-semibold text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                onClick={data.clearFilters}
                type="button"
              >
                Clear all
              </button>
            </div>
          )}
        </Card>

        <Card className="mt-4 p-0">
          {data.list.status === "loading" && (
            <div className="grid gap-3 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          )}
          {data.list.status === "error" && (
            <div className="p-4">
              <EmptyState
                action={
                  <Button onClick={data.retry} variant="ghost">
                    Retry
                  </Button>
                }
                description="Couldn't load work orders. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && visibleItems.length === 0 && (
            <div className="p-4">
              <EmptyState
                description="No work orders match these filters."
                title="No work orders found"
              />
            </div>
          )}
          {data.list.status === "ready" && visibleItems.length > 0 && (
            <>
              <div className="flex items-center justify-between p-3 text-caption text-text-muted">
                <span>
                  Showing {visibleItems.length} work order{visibleItems.length === 1 ? "" : "s"}
                </span>
              </div>
              <TableShell label="Work orders">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Title
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Asset
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Priority
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Status
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Technician
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Due
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="work-orders-table-body">{visibleItems.map(renderRow)}</tbody>
              </TableShell>
              {data.list.nextCursor && (
                <div className="p-4">
                  <Button loading={data.list.loadingMore} onClick={() => void data.loadMore()} variant="ghost">
                    Load more
                  </Button>
                </div>
              )}
            </>
          )}
        </Card>
      </MotionSection>

      <CreateWorkOrderModal
        assets={data.assets.items}
        onClose={() => setCreateOpen(false)}
        onCreated={data.retry}
        open={createOpen}
        workOrders={data}
      />
    </section>
  );
}
