"use client";

import type { InspectionListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";

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

import { useInspectionsData } from "./inspections-data";

function statusTone(status: string): StatusTone {
  switch (status) {
    case "completed":
      return "healthy";
    case "in_progress":
      return "warning";
    case "cancelled":
      return "critical";
    default:
      return "info";
  }
}

function statusLabel(status: string): string {
  return status.replace(/_/g, " ").replace(/^\w/, (letter) => letter.toUpperCase());
}

export function InspectionsPage({
  reducedMotionOverride,
}: { reducedMotionOverride?: boolean } = {}) {
  const data = useInspectionsData();
  const router = useRouter();

  const activeChips: Array<{ key: string; label: string; clear: () => void }> = [
    data.filters.status
      ? {
          key: "status",
          label: `Status: ${statusLabel(data.filters.status)}`,
          clear: () => data.setFilter("status", null),
        }
      : null,
  ].filter((chip): chip is { key: string; label: string; clear: () => void } => chip !== null);

  function renderRow(inspection: InspectionListItem) {
    return (
      <tr
        className="cursor-pointer border-b border-border last:border-0 hover:bg-elevated/60"
        key={inspection.id}
        onClick={() => router.push(`/inspections/${inspection.id}`)}
      >
        <td className="p-3">
          <StatusPill tone={statusTone(inspection.status)}>
            {statusLabel(inspection.status)}
          </StatusPill>
        </td>
        <td className="p-3">
          <Badge>{statusLabel(inspection.inspectionType)}</Badge>
        </td>
        <td className="p-3 text-bodySmall font-semibold">{inspection.title ?? "Untitled"}</td>
        <td className="p-3 font-mono text-caption text-text-secondary">{inspection.inspectorId}</td>
        <td
          className="p-3 font-mono text-caption text-text-muted"
          title={inspection.updatedAt.toISOString()}
        >
          {formatRelativeTime(inspection.updatedAt)}
        </td>
      </tr>
    );
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
          Operations
        </p>
        <h1 className="mt-2 text-h2 font-bold">Inspections</h1>
        <p className="mt-1 text-bodySmall text-text-secondary">
          Every inspection recorded across your facilities.
        </p>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <Select
              label="Status"
              onChange={(event) => data.setFilter("status", event.target.value || null)}
              value={data.filters.status ?? ""}
            >
              <option value="">All statuses</option>
              <option value="draft">Draft</option>
              <option value="in_progress">In progress</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
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
                description="Couldn't load inspections. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState
                description="No inspections match these filters."
                title="No inspections found"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <div className="flex items-center justify-between p-3 text-caption text-text-muted">
                <span>
                  Showing {data.list.items.length} inspection
                  {data.list.items.length === 1 ? "" : "s"}
                </span>
              </div>
              <TableShell label="Inspections">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Status
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Type
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Title
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Inspector
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Updated
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="inspections-table-body">
                  {data.list.items.map(renderRow)}
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
    </section>
  );
}

export { statusLabel, statusTone };
