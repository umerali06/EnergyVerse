"use client";

import type { AssetDetail, AssetHistoryEvent, AssetListItem, AssetMediaResponse } from "@fev/api-client";
import Link from "next/link";
import { useEffect, useState } from "react";
import { useAuth } from "@/auth/auth-context";
import { useToast } from "@/design-system";

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
  type StatusTone,
} from "@/design-system";

import { areaName, facilityName, useAssetsData, type AsyncStatus } from "./assets-data";
import { QrLabelTab } from "./qr-label-tab";
import { InspectionsTab } from "@/inspections/asset-inspections-tab";

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

const MEDIA_RULES = {
  photo: { accept: "image/jpeg,image/png,image/webp,image/heic", max: 10 * 1024 * 1024 },
  document: { accept: "application/pdf,.doc,.docx,image/jpeg,image/png,image/webp", max: 25 * 1024 * 1024 },
  manual: { accept: "application/pdf,.doc,.docx", max: 50 * 1024 * 1024 },
} as const;

function formatBytes(size: number) {
  return size < 1024 * 1024 ? `${Math.ceil(size / 1024)} KB` : `${(size / 1024 / 1024).toFixed(1)} MB`;
}

function MediaGroup({
  assetId, canWrite, items, kind, onChanged,
}: {
  assetId: string; canWrite: boolean; items: AssetMediaResponse[];
  kind: "photo" | "document" | "manual"; onChanged: (asset: AssetDetail) => void;
}) {
  const { apiClient } = useAuth();
  const toast = useToast();
  const [uploading, setUploading] = useState(false);
  const title = kind === "photo" ? "Photos" : kind === "document" ? "Documents" : "Manuals";
  async function upload(file?: File) {
    if (!file) return;
    if (file.size > MEDIA_RULES[kind].max) {
      toast.error(`${title.slice(0, -1)} must be ${MEDIA_RULES[kind].max / 1024 / 1024} MB or smaller`);
      return;
    }
    const accepted = MEDIA_RULES[kind].accept.split(",");
    if (!accepted.some((type) => type.startsWith(".") ? file.name.toLowerCase().endsWith(type) : file.type === type)) {
      toast.error(`This file type is not allowed for ${title.toLowerCase()}`);
      return;
    }
    setUploading(true);
    try {
      onChanged(await apiClient.uploadAssetMedia(assetId, kind, file));
      toast.success(`${title.slice(0, -1)} uploaded`);
    } finally { setUploading(false); }
  }
  async function remove(media: AssetMediaResponse) {
    if (!window.confirm(`Remove ${media.filename}?`)) return;
    onChanged(await apiClient.deleteAssetMedia(assetId, media.id));
    toast.success("Media removed");
  }
  return (
    <section className="rounded-lg border border-border p-4">
      <div className="flex items-center justify-between gap-3">
        <h3 className="text-h4 font-semibold">{title}</h3>
        {canWrite && (
          <label className="cursor-pointer rounded-md border border-border px-3 py-2 text-caption font-semibold hover:bg-elevated">
            {uploading ? "Uploading…" : "Add file"}
            <input className="sr-only" disabled={uploading} type="file" accept={MEDIA_RULES[kind].accept} onChange={(e) => void upload(e.target.files?.[0])} />
          </label>
        )}
      </div>
      {uploading && <div aria-label="Upload progress" className="mt-3 h-1 animate-pulse rounded bg-primary-500" />}
      {items.length === 0 ? <p className="mt-3 text-bodySmall text-text-muted">No {title.toLowerCase()} attached.</p> : (
        <div className="mt-3 grid gap-3 sm:grid-cols-2">
          {items.map((media) => (
            <article className="overflow-hidden rounded-md border border-border bg-elevated" key={media.id}>
              {/* Signed Storage hosts are dynamic per environment and cannot be statically allow-listed. */}
              {/* eslint-disable-next-line @next/next/no-img-element */}
              {kind === "photo" && <img alt={media.filename} className="h-36 w-full object-cover" src={media.url} />}
              <div className="flex items-center justify-between gap-2 p-3">
                <div className="min-w-0"><a className="block truncate text-bodySmall font-semibold text-primary-700 dark:text-primary-300" href={media.url} rel="noreferrer" target="_blank">{media.filename}</a><span className="font-mono text-caption text-text-muted">{formatBytes(media.size)}</span></div>
                {canWrite && <Button onClick={() => void remove(media)} variant="ghost">Remove</Button>}
              </div>
            </article>
          ))}
        </div>
      )}
    </section>
  );
}

function MediaTab({ asset, canWrite, onChanged }: { asset: AssetDetail; canWrite: boolean; onChanged: (asset: AssetDetail) => void }) {
  const mediaCount = (asset.photos?.length ?? 0) + (asset.documents?.length ?? 0) + (asset.manuals?.length ?? 0);
  if (mediaCount === 0 && !canWrite) {
    return (
      <EmptyState
        description="No photos, documents, or manuals have been attached."
        title="No photos or documents yet"
      />
    );
  }
  return (
    <div className="grid gap-4">
      <MediaGroup assetId={asset.id} canWrite={canWrite} items={asset.photos ?? []} kind="photo" onChanged={onChanged} />
      <MediaGroup assetId={asset.id} canWrite={canWrite} items={asset.documents ?? []} kind="document" onChanged={onChanged} />
      <MediaGroup assetId={asset.id} canWrite={canWrite} items={asset.manuals ?? []} kind="manual" onChanged={onChanged} />
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
  const { currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("assets.write") ?? false;
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
              {canWrite && (
                <Link href={`/assets/${state.asset.id}/edit`}>
                  <Button variant="ghost">Edit</Button>
                </Link>
              )}
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
                    content: <InspectionsTab assetId={state.asset.id} />,
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
                    content: <MediaTab asset={state.asset} canWrite={canWrite} onChanged={(asset) => setState({ status: "ready", asset })} />,
                  },
                  {
                    id: "qr-code",
                    label: "QR Code",
                    content: (
                      <QrLabelTab
                        assetId={state.asset.id}
                        assetTag={state.asset.assetTag}
                        getAssetQrLabel={data.getAssetQrLabel}
                        name={state.asset.name}
                      />
                    ),
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
