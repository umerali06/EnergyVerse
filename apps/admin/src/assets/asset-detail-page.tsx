"use client";

import type { AssetDetail, AssetHistoryEvent, AssetListItem } from "@fev/api-client";
import Link from "next/link";
import { useEffect, useState } from "react";

import { formatCompanyDateTime, formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Skeleton,
  StatusPill,
  Tabs,
  TableShell,
  Tooltip,
  type StatusTone,
} from "@/design-system";

import { areaName, facilityName, useAssetsData, type AsyncStatus } from "./assets-data";

function statusTone(status: string): StatusTone {
  return status.toLowerCase() as StatusTone;
}

function Field({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">{label}</p>
      <p className="mt-0.5 text-bodySmall text-text-primary">{value}</p>
    </div>
  );
}

function OverviewTab({
  asset,
  facilities,
  areas,
  getChildAssets,
}: {
  asset: AssetDetail;
  facilities: ReturnType<typeof useAssetsData>["facilities"]["items"];
  areas: ReturnType<typeof useAssetsData>["areas"]["items"];
  getChildAssets: (parentAssetId: string) => Promise<AssetListItem[]>;
}) {
  const [children, setChildren] = useState<{ status: AsyncStatus; items: AssetListItem[] }>({
    status: "loading",
    items: [],
  });

  useEffect(() => {
    let active = true;
    getChildAssets(asset.id)
      .then((items) => {
        if (active) setChildren({ status: "ready", items });
      })
      .catch(() => {
        if (active) setChildren({ status: "error", items: [] });
      });
    return () => {
      active = false;
    };
  }, [asset.id, getChildAssets]);

  const hasGps = asset.gpsLat != null && asset.gpsLng != null;

  return (
    <div className="grid gap-6">
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <Field label="Manufacturer" value={asset.manufacturer ?? "—"} />
        <Field label="Model" value={asset.model ?? "—"} />
        <Field label="Serial number" value={asset.serialNumber ?? "—"} />
        <Field
          label="Installation date"
          value={asset.installationDate ? formatCompanyDateTime(asset.installationDate) : "—"}
        />
        <Field label="Facility" value={facilityName(facilities, asset.facilityId)} />
        <Field label="Area" value={areaName(areas, asset.areaId) ?? "—"} />
      </div>

      {asset.description && (
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Description</p>
          <p className="mt-1 text-bodySmall text-text-secondary">{asset.description}</p>
        </div>
      )}

      <div>
        <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Location</p>
        {hasGps ? (
          <p className="mt-1 flex flex-wrap items-center gap-2 text-bodySmall">
            <span className="font-mono text-text-secondary">
              {asset.gpsLat!.toFixed(6)}, {asset.gpsLng!.toFixed(6)}
            </span>
            <a
              className="font-semibold text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
              href={`https://www.google.com/maps?q=${asset.gpsLat},${asset.gpsLng}`}
              rel="noopener noreferrer"
              target="_blank"
            >
              View on map
            </a>
          </p>
        ) : (
          <p className="mt-1 text-bodySmall text-text-muted">No location recorded.</p>
        )}
      </div>

      {asset.parentAssetId && (
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Parent asset</p>
          <Link
            className="mt-1 inline-block font-mono text-bodySmall text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
            href={`/assets/${asset.parentAssetId}`}
          >
            {asset.parentAssetId}
          </Link>
        </div>
      )}

      <div>
        <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Sub-assets</p>
        {children.status === "loading" && <Skeleton className="mt-2 h-8 w-48" />}
        {children.status === "ready" && children.items.length === 0 && (
          <p className="mt-1 text-bodySmall text-text-muted">No sub-assets.</p>
        )}
        {children.status === "ready" && children.items.length > 0 && (
          <ul className="mt-2 grid gap-1">
            {children.items.map((child) => (
              <li key={child.id}>
                <Link
                  className="text-bodySmall text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                  href={`/assets/${child.id}`}
                >
                  {child.name}{" "}
                  <span className="font-mono text-caption text-text-muted">({child.assetTag})</span>
                </Link>
              </li>
            ))}
          </ul>
        )}
      </div>

      <div className="grid gap-4 border-t border-border pt-4 sm:grid-cols-2">
        <Field label="Created" value={formatCompanyDateTime(asset.createdAt)} />
        <Field label="Last updated" value={formatCompanyDateTime(asset.updatedAt)} />
      </div>
    </div>
  );
}

function HistoryTab({
  assetId,
  getAssetHistory,
}: {
  assetId: string;
  getAssetHistory: (assetId: string) => Promise<{ items?: AssetHistoryEvent[] }>;
}) {
  const [state, setState] = useState<{ status: AsyncStatus; items: AssetHistoryEvent[] }>({
    status: "loading",
    items: [],
  });

  useEffect(() => {
    let active = true;
    getAssetHistory(assetId)
      .then((page) => {
        if (active) setState({ status: "ready", items: page.items ?? [] });
      })
      .catch(() => {
        if (active) setState({ status: "error", items: [] });
      });
    return () => {
      active = false;
    };
  }, [assetId, getAssetHistory]);

  if (state.status === "loading") {
    return (
      <div className="grid gap-2">
        <Skeleton className="h-8 w-full" />
        <Skeleton className="h-8 w-full" />
      </div>
    );
  }
  if (state.status === "error") {
    return <EmptyState description="Couldn't load this asset's history." title="Something went wrong" />;
  }
  if (state.items.length === 0) {
    return <EmptyState description="No history has been recorded for this asset yet." title="No history yet" />;
  }
  return (
    <TableShell label="Asset history">
      <thead>
        <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
          <th className="p-3 font-semibold" scope="col">
            When
          </th>
          <th className="p-3 font-semibold" scope="col">
            Type
          </th>
          <th className="p-3 font-semibold" scope="col">
            Summary
          </th>
        </tr>
      </thead>
      <tbody>
        {state.items.map((event) => (
          <tr className="border-b border-border last:border-0" key={event.id}>
            <td className="p-3 font-mono text-caption text-text-secondary">
              {formatRelativeTime(event.occurredAt)}
            </td>
            <td className="p-3 text-bodySmall">{event.type}</td>
            <td className="p-3 text-bodySmall text-text-secondary">{event.summary}</td>
          </tr>
        ))}
      </tbody>
    </TableShell>
  );
}

function MediaTab({ asset }: { asset: AssetDetail }) {
  const mediaCount = (asset.photos?.length ?? 0) + (asset.documents?.length ?? 0) + (asset.manuals?.length ?? 0);
  if (mediaCount === 0) {
    return (
      <EmptyState
        description="Photos, documents, and manuals will appear here once uploads land in Phase 4.3."
        title="No photos or documents yet"
      />
    );
  }
  return (
    <div className="grid gap-4">
      {asset.photos && asset.photos.length > 0 && (
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Photos</p>
          <p className="mt-1 text-bodySmall text-text-secondary">{asset.photos.length} photo(s)</p>
        </div>
      )}
      {asset.documents && asset.documents.length > 0 && (
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Documents</p>
          <p className="mt-1 text-bodySmall text-text-secondary">{asset.documents.length} document(s)</p>
        </div>
      )}
      {asset.manuals && asset.manuals.length > 0 && (
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">Manuals</p>
          <p className="mt-1 text-bodySmall text-text-secondary">{asset.manuals.length} manual(s)</p>
        </div>
      )}
    </div>
  );
}

export function AssetDetailPage({
  assetId,
  reducedMotionOverride,
}: {
  assetId: string;
  reducedMotionOverride?: boolean;
}) {
  const data = useAssetsData();
  const [state, setState] = useState<{ status: AsyncStatus; asset: AssetDetail | null }>({
    status: "loading",
    asset: null,
  });

  useEffect(() => {
    let active = true;
    setState({ status: "loading", asset: null });
    data
      .getAsset(assetId)
      .then((asset) => {
        if (active) setState({ status: "ready", asset });
      })
      .catch(() => {
        if (active) setState({ status: "error", asset: null });
      });
    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [assetId]);

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        {state.status === "loading" && (
          <div className="grid gap-3">
            <Skeleton className="h-8 w-64" />
            <Skeleton className="h-32 w-full" />
          </div>
        )}
        {state.status === "error" && (
          <EmptyState description="Couldn't load this asset. Check your connection and try again." title="Something went wrong" />
        )}
        {state.status === "ready" && state.asset && (
          <>
            <div className="flex flex-wrap items-start justify-between gap-4">
              <div>
                <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
                  {state.asset.assetTag}
                </p>
                <h1 className="mt-2 text-h2 font-bold">{state.asset.name}</h1>
                <div className="mt-2 flex flex-wrap items-center gap-2">
                  <Badge>{state.asset.category}</Badge>
                  <StatusPill tone={statusTone(state.asset.currentStatus)}>
                    {state.asset.currentStatus}
                  </StatusPill>
                  <span className="text-bodySmall text-text-secondary">
                    {facilityName(data.facilities.items, state.asset.facilityId)}
                    {areaName(data.areas.items, state.asset.areaId) && (
                      <> → {areaName(data.areas.items, state.asset.areaId)}</>
                    )}
                  </span>
                </div>
              </div>
              <Tooltip content="Editing assets arrives in Phase 4.3">
                <Button disabled variant="ghost">
                  Edit
                </Button>
              </Tooltip>
            </div>

            <Card className="mt-6 p-4">
              <Tabs
                items={[
                  {
                    id: "overview",
                    label: "Overview",
                    content: (
                      <OverviewTab
                        areas={data.areas.items}
                        asset={state.asset}
                        facilities={data.facilities.items}
                        getChildAssets={data.getChildAssets}
                      />
                    ),
                  },
                  {
                    id: "inspections",
                    label: "Inspections",
                    content: <EmptyState description="Inspections will appear here once Phase 7 lands." title="No inspections yet" />,
                  },
                  {
                    id: "work-orders",
                    label: "Work Orders",
                    content: <EmptyState description="Work orders will appear here once Phase 11 lands." title="No work orders yet" />,
                  },
                  {
                    id: "history",
                    label: "History",
                    content: <HistoryTab assetId={state.asset.id} getAssetHistory={data.getAssetHistory} />,
                  },
                  {
                    id: "media",
                    label: "Media",
                    content: <MediaTab asset={state.asset} />,
                  },
                ]}
              />
            </Card>
          </>
        )}
      </MotionSection>
    </section>
  );
}
