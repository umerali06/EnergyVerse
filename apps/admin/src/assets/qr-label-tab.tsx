"use client";

import type { AssetQrLabel } from "@fev/api-client";
import { useEffect, useRef, useState } from "react";
import QRCode from "react-qr-code";

import { Button, EmptyState, Skeleton } from "@/design-system";

type LoadState = "loading" | "ready" | "error";

function downloadSvg(svg: SVGSVGElement, filename: string) {
  const serialized = new XMLSerializer().serializeToString(svg);
  const blob = new Blob([serialized], { type: "image/svg+xml;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}

export function QrLabelTab({
  assetId,
  assetTag,
  getAssetQrLabel,
  name,
}: {
  assetId: string;
  assetTag: string;
  getAssetQrLabel: (assetId: string) => Promise<AssetQrLabel>;
  name: string;
}) {
  const [state, setState] = useState<{ label: AssetQrLabel | null; status: LoadState }>({
    label: null,
    status: "loading",
  });
  const printAreaRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let active = true;
    setState({ label: null, status: "loading" });
    getAssetQrLabel(assetId)
      .then((label) => {
        if (active) setState({ label, status: "ready" });
      })
      .catch(() => {
        if (active) setState({ label: null, status: "error" });
      });
    return () => {
      active = false;
    };
  }, [assetId, getAssetQrLabel]);

  if (state.status === "loading") {
    return (
      <div className="grid gap-3">
        <Skeleton className="h-48 w-48" />
        <Skeleton className="h-4 w-40" />
      </div>
    );
  }

  if (state.status === "error" || !state.label?.url) {
    return (
      <EmptyState
        description="Couldn't load a QR code for this asset. Check your connection and try again."
        title="QR code unavailable"
      />
    );
  }

  const { label } = state;

  return (
    <div className="grid gap-4">
      <div
        className="grid max-w-xs gap-3 rounded-lg border border-border p-5 text-center"
        data-print-area
        data-testid="qr-print-area"
        ref={printAreaRef}
      >
        <QRCode
          className="mx-auto h-auto max-w-full"
          value={label.url ?? ""}
          viewBox="0 0 256 256"
        />
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
            {assetTag}
          </p>
          <p className="text-bodySmall font-semibold">{name}</p>
        </div>
      </div>
      <div className="flex flex-wrap gap-2 print:hidden">
        <Button onClick={() => window.print()} variant="ghost">
          Print
        </Button>
        <Button
          onClick={() => {
            const svg = printAreaRef.current?.querySelector("svg");
            if (svg) downloadSvg(svg, `${assetTag}-qr.svg`);
          }}
          variant="ghost"
        >
          Download
        </Button>
      </div>
    </div>
  );
}
