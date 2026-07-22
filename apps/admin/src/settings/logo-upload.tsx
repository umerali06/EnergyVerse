"use client";

import { useEffect, useRef, useState } from "react";

import { ApiClientError } from "@/api";
import { Button, useToast } from "@/design-system";

const ALLOWED_TYPES = new Set(["image/png", "image/jpeg", "image/webp"]);
const MAX_BYTES = 5 * 1024 * 1024;

function validate(file: File): string | null {
  if (!ALLOWED_TYPES.has(file.type)) return "Logo must be a PNG, JPEG, or WEBP image";
  if (file.size > MAX_BYTES) return "Logo must be 5 MB or smaller";
  return null;
}

export function LogoUpload({
  logoUrl,
  onRemove,
  onUpload,
}: {
  logoUrl: string | null;
  onRemove: () => Promise<unknown>;
  onUpload: (file: File) => Promise<unknown>;
}) {
  const toast = useToast();
  const inputRef = useRef<HTMLInputElement>(null);
  const [dragging, setDragging] = useState(false);
  const [preview, setPreview] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    return () => {
      if (preview) URL.revokeObjectURL(preview);
    };
  }, [preview]);

  async function handleFile(file: File) {
    const validation = validate(file);
    if (validation) {
      setError(validation);
      return;
    }
    setError(null);
    setBusy(true);
    const objectUrl = URL.createObjectURL(file);
    setPreview(objectUrl);
    try {
      await onUpload(file);
      toast.success("Logo updated");
    } catch (failure) {
      setPreview(null);
      URL.revokeObjectURL(objectUrl);
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setBusy(false);
    }
  }

  async function handleRemove() {
    setBusy(true);
    setError(null);
    try {
      await onRemove();
      setPreview(null);
      toast.success("Logo removed");
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setBusy(false);
    }
  }

  const displayUrl = preview ?? logoUrl;

  return (
    <div className="grid gap-3">
      <div
        className="grid place-items-center rounded-lg border border-dashed border-border p-6 text-center transition-colors data-[dragging=true]:border-primary-400 data-[dragging=true]:bg-elevated"
        data-dragging={dragging}
        data-testid="logo-dropzone"
        onDragLeave={(event) => {
          event.preventDefault();
          setDragging(false);
        }}
        onDragOver={(event) => {
          event.preventDefault();
          setDragging(true);
        }}
        onDrop={(event) => {
          event.preventDefault();
          setDragging(false);
          const file = event.dataTransfer.files[0];
          if (file) void handleFile(file);
        }}
      >
        {displayUrl ? (
          // eslint-disable-next-line @next/next/no-img-element -- signed Storage URL, not a static asset
          <img
            alt="Company logo"
            className="mb-3 max-h-24 max-w-full rounded-md object-contain"
            src={displayUrl}
          />
        ) : (
          <span className="mb-3 font-mono text-micro uppercase tracking-[0.2em] text-text-muted">
            no logo
          </span>
        )}
        <p className="text-bodySmall text-text-secondary">
          Drag and drop a logo here, or choose a file
        </p>
        <p className="mt-1 text-caption text-text-muted">PNG, JPEG, or WEBP, up to 5 MB</p>
        <input
          accept="image/png,image/jpeg,image/webp"
          aria-label="Company logo file"
          className="sr-only"
          onChange={(event) => {
            const file = event.target.files?.[0];
            event.target.value = "";
            if (file) void handleFile(file);
          }}
          ref={inputRef}
          type="file"
        />
        <div className="mt-4 flex gap-2">
          <Button
            loading={busy}
            onClick={() => inputRef.current?.click()}
            type="button"
            variant="ghost"
          >
            {displayUrl ? "Replace logo" : "Choose file"}
          </Button>
          {displayUrl && (
            <Button loading={busy} onClick={() => void handleRemove()} type="button" variant="danger">
              Remove
            </Button>
          )}
        </div>
      </div>
      {error && (
        <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
          {error}
        </p>
      )}
    </div>
  );
}
