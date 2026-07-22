"use client";

import type { AuditLogEntry } from "@fev/api-client";
import { useState } from "react";

import { actionIcons } from "@/dashboard/icons";
import {
  actionIconKey,
  describeAction,
  formatCompanyDateTime,
  formatRelativeTime,
  formatTarget,
} from "@/dashboard/format";
import {
  Button,
  Card,
  EmptyState,
  FilterChip,
  Input,
  MotionSection,
  Select,
  Skeleton,
  TableShell,
  Tooltip,
  cn,
} from "@/design-system";

import { useAuditLogData } from "./audit-data";

function downloadCsv(content: string, filename: string): void {
  const blob = new Blob([content], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

function MetadataPanel({ label, value }: { label: string; value: unknown }) {
  return (
    <div>
      <p className="font-mono text-caption uppercase tracking-[0.14em] text-text-muted">{label}</p>
      <pre className="mt-1 overflow-x-auto rounded-md bg-elevated p-3 font-mono text-caption text-text-secondary">
        {JSON.stringify(value, null, 2)}
      </pre>
    </div>
  );
}

function MetadataDetail({ metadata }: { metadata: Record<string, unknown> }) {
  const hasBeforeAfter = "before" in metadata || "after" in metadata;
  if (hasBeforeAfter) {
    return (
      <div className="grid gap-3 sm:grid-cols-2">
        {"before" in metadata && <MetadataPanel label="Before" value={metadata.before} />}
        {"after" in metadata && <MetadataPanel label="After" value={metadata.after} />}
      </div>
    );
  }
  if (Object.keys(metadata).length === 0) {
    return <p className="text-bodySmall text-text-muted">No additional details for this event.</p>;
  }
  return <MetadataPanel label="Details" value={metadata} />;
}

function AuditRow({
  entry,
  expanded,
  onToggle,
  dateFormat,
}: {
  entry: AuditLogEntry;
  expanded: boolean;
  onToggle: () => void;
  dateFormat: { locale?: string; timeZone?: string };
}) {
  return (
    <>
      <tr className="border-b border-border last:border-0">
        <td className="p-3">
          <button
            aria-expanded={expanded}
            className="flex items-center gap-2 text-left"
            onClick={onToggle}
            type="button"
          >
            <svg
              aria-hidden
              className={cn("size-3.5 shrink-0 text-text-muted transition-transform", expanded && "rotate-90")}
              fill="none"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              viewBox="0 0 24 24"
            >
              <path d="M9 6l6 6-6 6" />
            </svg>
            <span
              className="font-mono text-caption text-text-secondary"
              title={formatCompanyDateTime(entry.createdAt, dateFormat)}
            >
              {formatRelativeTime(entry.createdAt)}
            </span>
          </button>
        </td>
        <td className="p-3">
          <span className="block text-bodySmall font-semibold">
            {entry.actorName ?? "Unknown user"}
          </span>
          {entry.actorRole && (
            <span className="block text-caption text-text-muted">{entry.actorRole}</span>
          )}
        </td>
        <td className="p-3">
          <span className="inline-flex items-center gap-1.5 text-bodySmall">
            <span className="text-text-muted">{actionIcons[actionIconKey(entry.action)]}</span>
            {describeAction(entry.action)}
          </span>
        </td>
        <td className="p-3 font-mono text-caption text-text-muted">
          {formatTarget(entry.targetType, entry.targetId)}
        </td>
      </tr>
      {expanded && (
        <tr className="border-b border-border bg-elevated/40 last:border-0">
          <td className="p-4" colSpan={4}>
            <MetadataDetail metadata={entry.metadata as Record<string, unknown>} />
          </td>
        </tr>
      )}
    </>
  );
}

export function AuditLogPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const data = useAuditLogData();
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [exporting, setExporting] = useState(false);
  const dateFormat = { locale: data.locale, timeZone: data.timeZone };

  function toggleExpanded(id: string) {
    setExpanded((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  async function handleExport() {
    setExporting(true);
    try {
      const csv = await data.exportCsv();
      downloadCsv(csv, `audit-log-${data.filters.fromDate}-${data.filters.toDate}.csv`);
    } catch {
      // FevApiClient already surfaced the unified-envelope toast.
    } finally {
      setExporting(false);
    }
  }

  const activeChips: Array<{ key: string; label: string; clear: () => void }> = [
    data.filters.actorUid
      ? {
          key: "actorUid",
          label: `Actor: ${
            data.actors.items.find((user) => user.id === data.filters.actorUid)?.displayName ??
            data.filters.actorUid
          }`,
          clear: () => data.setFilter("actorUid", null),
        }
      : null,
    data.filters.action
      ? {
          key: "action",
          label: `Action: ${describeAction(data.filters.action)}`,
          clear: () => data.setFilter("action", null),
        }
      : null,
    data.filters.targetType
      ? {
          key: "targetType",
          label: `Target: ${data.filters.targetType}`,
          clear: () => data.setFilter("targetType", null),
        }
      : null,
    data.filters.q
      ? { key: "q", label: `Search: "${data.filters.q}"`, clear: () => data.setFilter("q", "") }
      : null,
  ].filter((chip): chip is { key: string; label: string; clear: () => void } => chip !== null);

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Administration
            </p>
            <h1 className="mt-2 text-h2 font-bold">Audit Log</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              The complete, filterable record of every change made in your company.
            </p>
          </div>
          <Tooltip content={data.list.items.length === 0 ? "No events to export" : "Export the current filtered set as CSV"}>
            <Button
              disabled={data.list.items.length === 0}
              loading={exporting}
              onClick={() => void handleExport()}
              variant="ghost"
            >
              Export CSV
            </Button>
          </Tooltip>
        </div>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <Input
              label="From"
              onChange={(event) => data.setFilter("fromDate", event.target.value)}
              type="date"
              value={data.filters.fromDate}
            />
            <Input
              label="To"
              onChange={(event) => data.setFilter("toDate", event.target.value)}
              type="date"
              value={data.filters.toDate}
            />
            <Input
              label="Search"
              onChange={(event) => data.setFilter("q", event.target.value)}
              placeholder="Search target or details"
              value={data.filters.q}
            />
            <Select
              label="Actor"
              onChange={(event) => data.setFilter("actorUid", event.target.value || null)}
              value={data.filters.actorUid ?? ""}
            >
              <option value="">All actors</option>
              {data.actors.items.map((user) => (
                <option key={user.id} value={user.id}>
                  {user.displayName}
                </option>
              ))}
            </Select>
            <Select
              label="Action"
              onChange={(event) => data.setFilter("action", event.target.value || null)}
              value={data.filters.action ?? ""}
            >
              <option value="">All actions</option>
              {data.facets.actions.map((action) => (
                <option key={action} value={action}>
                  {describeAction(action)}
                </option>
              ))}
            </Select>
            <Select
              label="Target type"
              onChange={(event) => data.setFilter("targetType", event.target.value || null)}
              value={data.filters.targetType ?? ""}
            >
              <option value="">All targets</option>
              {data.facets.targetTypes.map((targetType) => (
                <option key={targetType} value={targetType}>
                  {targetType}
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

        {data.list.truncated && (
          <div className="mt-4 rounded-md border border-status-warning/40 bg-status-warning/10 p-3 text-bodySmall text-status-warningDeep dark:text-status-warning">
            This date range holds more events than can be shown at once. Narrow the range for a
            complete view.
          </div>
        )}

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
                description="Couldn't load the audit log. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState
                description="No events match these filters."
                title="No events found"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <TableShell label="Audit log">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Timestamp
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Actor
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Action
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Target
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="audit-table-body">
                  {data.list.items.map((entry) => (
                    <AuditRow
                      dateFormat={dateFormat}
                      entry={entry}
                      expanded={expanded.has(entry.id)}
                      key={entry.id}
                      onToggle={() => toggleExpanded(entry.id)}
                    />
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
    </section>
  );
}
