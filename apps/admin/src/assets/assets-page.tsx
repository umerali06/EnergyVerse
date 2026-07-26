"use client";

import type { AssetListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";

import { formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  FilterChip,
  Input,
  MotionSection,
  Select,
  Skeleton,
  StatusPill,
  TableShell,
  type StatusTone,
} from "@/design-system";

import { areaName, facilityName, useAssetsData } from "./assets-data";

const CATEGORY_OPTIONS = [
  "Pump",
  "Compressor",
  "Vessel",
  "Valve",
  "Tank",
  "Generator",
  "Sensor",
  "Other",
];

function statusTone(status: string): StatusTone {
  return status.toLowerCase() as StatusTone;
}

export function AssetsPage({ reducedMotionOverride }: { reducedMotionOverride?: boolean } = {}) {
  const data = useAssetsData();
  const router = useRouter();

  const areaOptions = data.filters.facilityId
    ? data.areas.items.filter((area) => area.facilityId === data.filters.facilityId)
    : [];

  const activeChips: Array<{ key: string; label: string; clear: () => void }> = [
    data.filters.search
      ? { key: "search", label: `Search: "${data.filters.search}"`, clear: () => data.setFilter("search", "") }
      : null,
    data.filters.facilityId
      ? {
          key: "facilityId",
          label: `Facility: ${facilityName(data.facilities.items, data.filters.facilityId)}`,
          clear: () => data.setFilter("facilityId", null),
        }
      : null,
    data.filters.areaId
      ? {
          key: "areaId",
          label: `Area: ${areaName(data.areas.items, data.filters.areaId)}`,
          clear: () => data.setFilter("areaId", null),
        }
      : null,
    data.filters.category
      ? { key: "category", label: `Category: ${data.filters.category}`, clear: () => data.setFilter("category", null) }
      : null,
    data.filters.status
      ? { key: "status", label: `Status: ${data.filters.status}`, clear: () => data.setFilter("status", null) }
      : null,
  ].filter((chip): chip is { key: string; label: string; clear: () => void } => chip !== null);

  function renderRow(asset: AssetListItem) {
    const facility = facilityName(data.facilities.items, asset.facilityId);
    const area = areaName(data.areas.items, asset.areaId);
    return (
      <tr
        className="cursor-pointer border-b border-border last:border-0 hover:bg-elevated/60"
        key={asset.id}
        onClick={() => router.push(`/assets/${asset.id}`)}
      >
        <td className="p-3 font-mono text-caption text-text-secondary">{asset.assetTag}</td>
        <td className="p-3 text-bodySmall font-semibold">{asset.name}</td>
        <td className="p-3">
          <Badge>{asset.category}</Badge>
        </td>
        <td className="p-3 text-bodySmall text-text-secondary">
          {facility}
          {area && <span className="text-text-muted"> → {area}</span>}
        </td>
        <td className="p-3">
          <StatusPill tone={statusTone(asset.currentStatus)}>{asset.currentStatus}</StatusPill>
        </td>
        <td className="p-3 text-bodySmall text-text-secondary">
          {asset.manufacturer ?? "—"}
          {asset.model && <span className="text-text-muted"> / {asset.model}</span>}
        </td>
        <td className="p-3 font-mono text-caption text-text-muted" title={asset.updatedAt.toISOString()}>
          {formatRelativeTime(asset.updatedAt)}
        </td>
      </tr>
    );
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
            Operations
          </p>
          <h1 className="mt-2 text-h2 font-bold">Assets</h1>
          <p className="mt-1 text-bodySmall text-text-secondary">
            Every physical asset tracked across your facilities.
          </p>
        </div>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <Input
              label="Search"
              onChange={(event) => data.setFilter("search", event.target.value)}
              placeholder="Name, tag, or serial"
              value={data.filters.search}
            />
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
              disabled={!data.filters.facilityId}
              hint={!data.filters.facilityId ? "Select a facility first" : undefined}
              label="Area"
              onChange={(event) => data.setFilter("areaId", event.target.value || null)}
              value={data.filters.areaId ?? ""}
            >
              <option value="">All areas</option>
              {areaOptions.map((area) => (
                <option key={area.id} value={area.id}>
                  {area.name}
                </option>
              ))}
            </Select>
            <Select
              label="Category"
              onChange={(event) => data.setFilter("category", event.target.value || null)}
              value={data.filters.category ?? ""}
            >
              <option value="">All categories</option>
              {CATEGORY_OPTIONS.map((category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </Select>
            <Select
              label="Status"
              onChange={(event) => data.setFilter("status", event.target.value || null)}
              value={data.filters.status ?? ""}
            >
              <option value="">All statuses</option>
              <option value="Healthy">Healthy</option>
              <option value="Warning">Warning</option>
              <option value="Critical">Critical</option>
            </Select>
            <Select
              label="Sort"
              onChange={(event) => data.setFilter("sort", event.target.value)}
              value={data.filters.sort}
            >
              <option value="-created_at">Newest first</option>
              <option value="created_at">Oldest first</option>
              <option value="name">Name (A–Z)</option>
              <option value="-name">Name (Z–A)</option>
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
                description="Couldn't load assets. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState description="No assets match these filters." title="No assets found" />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <div className="flex items-center justify-between p-3 text-caption text-text-muted">
                <span>Showing {data.list.items.length} asset{data.list.items.length === 1 ? "" : "s"}</span>
              </div>
              <TableShell label="Assets">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Asset tag
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Name
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Category
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Location
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Status
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Manufacturer / model
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Updated
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="assets-table-body">{data.list.items.map(renderRow)}</tbody>
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
    </section>
  );
}
