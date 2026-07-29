"use client";

import Link from "next/link";

import { EmptyState, Skeleton, StatusPill, TableShell } from "@/design-system";
import { formatRelativeTime } from "@/dashboard/format";

import { useInspectionsData } from "./inspections-data";
import { statusLabel, statusTone } from "./inspections-page";

/** The asset-detail Inspections tab (D-033 resolution) -- scoped to one
 * asset via `useInspectionsData`'s `initialFilters`, mirroring the History
 * tab's shape. Full filtering/sorting lives on the standalone `/inspections`
 * list; this is a read-only, at-a-glance view. */
export function InspectionsTab({ assetId }: { assetId: string }) {
  const data = useInspectionsData({ assetId });

  if (data.list.status === "loading") {
    return (
      <div className="grid gap-2">
        <Skeleton className="h-8 w-full" />
        <Skeleton className="h-8 w-full" />
      </div>
    );
  }
  if (data.list.status === "error") {
    return (
      <EmptyState
        description="Couldn't load this asset's inspections."
        title="Something went wrong"
      />
    );
  }
  if (data.list.items.length === 0) {
    return (
      <EmptyState
        description="No inspections have been recorded for this asset yet."
        title="No inspections yet"
      />
    );
  }
  return (
    <TableShell label="Asset inspections">
      <thead>
        <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
          <th className="p-3 font-semibold" scope="col">
            Status
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
      <tbody>
        {data.list.items.map((inspection) => (
          <tr className="border-b border-border last:border-0" key={inspection.id}>
            <td className="p-3">
              <StatusPill tone={statusTone(inspection.status)}>
                {statusLabel(inspection.status)}
              </StatusPill>
            </td>
            <td className="p-3 text-bodySmall font-semibold">
              <Link
                className="text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                href={`/inspections/${inspection.id}`}
              >
                {inspection.title ?? "Untitled"}
              </Link>
            </td>
            <td className="p-3 font-mono text-caption text-text-secondary">
              {inspection.inspectorId}
            </td>
            <td
              className="p-3 font-mono text-caption text-text-muted"
              title={inspection.updatedAt.toISOString()}
            >
              {formatRelativeTime(inspection.updatedAt)}
            </td>
          </tr>
        ))}
      </tbody>
    </TableShell>
  );
}
