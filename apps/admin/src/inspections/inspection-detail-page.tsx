"use client";

import type { ChecklistTemplateDetail, InspectionDetail } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { formatCompanyDateTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Skeleton,
  StatusPill,
  type StatusTone,
  useToast,
} from "@/design-system";

import { AnnotationOverlay, damageTypeLabel } from "./annotation-overlay";
import { statusLabel, statusTone } from "./inspections-page";
import { SignaturePreview } from "./signature-preview";

/** Mirrors the backend's `READINGS_CONDITION_TO_ASSET_STATUS` mapping (Phase
 * 7.7) so the admin review surface previews the same asset-health impact a
 * completed inspection's condition will cause. */
function readingsConditionTone(condition: string): StatusTone {
  switch (condition) {
    case "Excellent":
    case "Good":
      return "healthy";
    case "Fair":
    case "Poor":
      return "warning";
    case "Critical":
      return "critical";
    default:
      return "info";
  }
}

function formatVoiceNoteDuration(durationMs: number): string {
  const totalSeconds = Math.round(durationMs / 1000);
  const minutes = Math.floor(totalSeconds / 60)
    .toString()
    .padStart(2, "0");
  const seconds = (totalSeconds % 60).toString().padStart(2, "0");
  return `${minutes}:${seconds}`;
}

function Field({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">{label}</p>
      <p className="mt-0.5 text-bodySmall text-text-primary">{value}</p>
    </div>
  );
}

export function InspectionDetailPage({
  inspectionId,
  reducedMotionOverride,
}: {
  inspectionId: string;
  reducedMotionOverride?: boolean;
}) {
  const { apiClient, currentUser } = useAuth();
  const router = useRouter();
  const toast = useToast();
  const canWrite = currentUser?.permissions.has("inspections.write") ?? false;
  const [state, setState] = useState<{
    status: "loading" | "error" | "ready";
    inspection: InspectionDetail | null;
  }>({ status: "loading", inspection: null });
  const [template, setTemplate] = useState<ChecklistTemplateDetail | null>(null);
  const [showAnnotations, setShowAnnotations] = useState(true);

  useEffect(() => {
    let active = true;
    setState({ status: "loading", inspection: null });
    apiClient
      .getInspection(inspectionId)
      .then((inspection) => {
        if (active) setState({ status: "ready", inspection });
      })
      .catch(() => {
        if (active) setState({ status: "error", inspection: null });
      });
    return () => {
      active = false;
    };
  }, [apiClient, inspectionId]);

  useEffect(() => {
    let active = true;
    setTemplate(null);
    const templateId = state.inspection?.checklistTemplateId;
    if (!templateId) return;
    // Best-effort: the checklist section already renders fine from the
    // inspection's own item snapshot without this -- it only adds the
    // template's name to the section header for admin clarity.
    apiClient
      .getChecklistTemplate(templateId)
      .then((detail) => {
        if (active) setTemplate(detail);
      })
      .catch(() => {
        /* name display is optional; the snapshot itself still renders */
      });
    return () => {
      active = false;
    };
  }, [apiClient, state.inspection?.checklistTemplateId]);

  async function cancel() {
    if (!state.inspection || !window.confirm("Cancel this inspection?")) return;
    const updated = await apiClient.cancelInspection(state.inspection.id);
    setState({ status: "ready", inspection: updated });
    toast.success("Inspection cancelled");
  }

  async function remove() {
    if (!state.inspection || !window.confirm("Delete this inspection? This cannot be undone."))
      return;
    await apiClient.deleteInspection(state.inspection.id);
    toast.success("Inspection deleted");
    router.push("/inspections");
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-4xl" reducedMotionOverride={reducedMotionOverride}>
        {state.status === "loading" && (
          <div className="grid gap-3">
            <Skeleton className="h-8 w-64" />
            <Skeleton className="h-32 w-full" />
          </div>
        )}
        {state.status === "error" && (
          <EmptyState
            description="Couldn't load this inspection. Check your connection and try again."
            title="Something went wrong"
          />
        )}
        {state.status === "ready" && state.inspection && (
          <>
            <div className="flex flex-wrap items-start justify-between gap-4">
              <div>
                <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
                  {statusLabel(state.inspection.inspectionType)} inspection
                </p>
                <h1 className="mt-2 text-h2 font-bold">
                  {state.inspection.title ?? "Untitled inspection"}
                </h1>
                <div className="mt-2 flex flex-wrap items-center gap-2">
                  <StatusPill tone={statusTone(state.inspection.status)}>
                    {statusLabel(state.inspection.status)}
                  </StatusPill>
                  <Badge>Revision {state.inspection.revision}</Badge>
                </div>
              </div>
              {canWrite && (
                <div className="flex gap-2">
                  {(state.inspection.status === "draft" ||
                    state.inspection.status === "in_progress") && (
                    <Button onClick={() => void cancel()} variant="ghost">
                      Cancel inspection
                    </Button>
                  )}
                  <Button onClick={() => void remove()} variant="ghost">
                    Delete
                  </Button>
                </div>
              )}
            </div>

            <Card className="mt-6 grid gap-6 p-5">
              <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <Field label="Asset" value={state.inspection.assetId} />
                <Field label="Inspector" value={state.inspection.inspectorId} />
                <Field
                  label="Started"
                  value={
                    state.inspection.startedAt
                      ? formatCompanyDateTime(state.inspection.startedAt)
                      : "—"
                  }
                />
                <Field
                  label="Completed"
                  value={
                    state.inspection.completedAt
                      ? formatCompanyDateTime(state.inspection.completedAt)
                      : "—"
                  }
                />
                <Field
                  label="Created"
                  value={formatCompanyDateTime(state.inspection.createdAt)}
                />
                <Field
                  label="Last updated"
                  value={formatCompanyDateTime(state.inspection.updatedAt)}
                />
              </div>

              {state.inspection.notes && (
                <div>
                  <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                    Notes
                  </p>
                  <p className="mt-1 text-bodySmall text-text-secondary">
                    {state.inspection.notes}
                  </p>
                </div>
              )}

              <div>
                <div className="flex flex-wrap items-baseline justify-between gap-2">
                  <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                    Checklist
                    {template && ` — ${template.name} (v${template.version})`}
                  </p>
                  {(state.inspection.checklistItemsSnapshot ?? []).length > 0 && (
                    <p className="text-caption text-text-muted">
                      Filled in the field — read-only here
                    </p>
                  )}
                </div>
                {(state.inspection.checklistItemsSnapshot ?? []).length === 0 ? (
                  <p className="mt-1 text-bodySmall text-text-muted">
                    No checklist template has been assigned yet.
                  </p>
                ) : (
                  <ul className="mt-2 grid gap-2">
                    {(state.inspection.checklistItemsSnapshot ?? []).map((item) => {
                      const response = (state.inspection!.checklistResponses ?? []).find(
                        (candidate) => candidate.itemId === item.id,
                      );
                      return (
                        <li
                          className="flex items-center justify-between gap-3 rounded-md border border-border p-3"
                          key={item.id}
                        >
                          <span className="text-bodySmall">
                            {item.label}
                            {item.required && (
                              <span className="text-text-muted"> (required)</span>
                            )}
                            <span className="ml-2 font-mono text-caption text-text-muted">
                              {item.itemType}
                            </span>
                          </span>
                          <span className="font-mono text-caption text-text-secondary">
                            {response?.value === undefined || response?.value === null
                              ? "Not answered"
                              : String(response.value)}
                          </span>
                        </li>
                      );
                    })}
                  </ul>
                )}
              </div>

              <div data-testid="media-section">
                <div className="flex items-center justify-between">
                  <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                    Media
                    {(state.inspection.media ?? []).length > 0 &&
                      ` (${state.inspection.media!.length})`}
                  </p>
                  {(state.inspection.annotations ?? []).length > 0 && (
                    <button
                      aria-pressed={showAnnotations}
                      className="font-mono text-caption text-text-secondary underline-offset-2 hover:underline"
                      onClick={() => setShowAnnotations((value) => !value)}
                      type="button"
                    >
                      {showAnnotations ? "Hide annotations" : "Show annotations"}
                    </button>
                  )}
                </div>
                {(state.inspection.media ?? []).length === 0 ? (
                  <p className="mt-1 text-bodySmall text-text-muted">
                    No media has been captured yet.
                  </p>
                ) : (
                  <ul className="mt-2 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
                    {state.inspection.media!.map((item) => {
                      const linkedItem = (state.inspection!.checklistItemsSnapshot ?? []).find(
                        (candidate) => candidate.id === item.checklistItemId,
                      );
                      const itemAnnotations = (state.inspection!.annotations ?? []).filter(
                        (annotation) => annotation.mediaLocalId === item.localId,
                      );
                      const damageTypes = Array.from(
                        new Set(itemAnnotations.map((a) => damageTypeLabel(a.damageType))),
                      );
                      return (
                        <li key={item.id}>
                          <a
                            className="group relative block overflow-hidden rounded-md border border-border"
                            href={item.url}
                            rel="noreferrer"
                            target="_blank"
                          >
                            {item.kind === "photo" ? (
                              // eslint-disable-next-line @next/next/no-img-element -- signed, tenant-scoped Storage URL, not a static/optimizable asset
                              <img
                                alt={item.filename}
                                className="h-28 w-full bg-elevated object-cover"
                                src={item.url}
                              />
                            ) : (
                              <div className="flex h-28 w-full items-center justify-center bg-elevated text-caption text-text-muted">
                                Video
                              </div>
                            )}
                            {showAnnotations && item.kind === "photo" && (
                              <AnnotationOverlay annotations={itemAnnotations} />
                            )}
                            {item.beforeAfterTag && (
                              <span className="absolute left-1 top-1 rounded-sm border border-border bg-elevated px-1.5 py-0.5 font-mono text-caption capitalize">
                                {item.beforeAfterTag}
                              </span>
                            )}
                          </a>
                          <p className="mt-1 font-mono text-caption text-text-muted">
                            {formatCompanyDateTime(item.capturedAt)}
                          </p>
                          {item.gpsLat != null && item.gpsLng != null && (
                            <p className="font-mono text-caption text-text-muted">
                              {item.gpsLat.toFixed(4)}, {item.gpsLng.toFixed(4)}
                            </p>
                          )}
                          {linkedItem && (
                            <p className="text-caption text-text-secondary">{linkedItem.label}</p>
                          )}
                          {damageTypes.length > 0 && (
                            <p className="text-caption text-text-secondary">
                              {damageTypes.join(", ")}
                            </p>
                          )}
                        </li>
                      );
                    })}
                  </ul>
                )}
              </div>

              <div data-testid="voice-notes-section">
                <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                  Voice notes
                  {(state.inspection.voiceNotes ?? []).length > 0 &&
                    ` (${state.inspection.voiceNotes!.length})`}
                </p>
                {(state.inspection.voiceNotes ?? []).length === 0 ? (
                  <p className="mt-1 text-bodySmall text-text-muted">
                    No voice notes have been recorded yet.
                  </p>
                ) : (
                  <ul className="mt-2 grid gap-3">
                    {state.inspection.voiceNotes!.map((note) => {
                      const linkedItem = (
                        state.inspection!.checklistItemsSnapshot ?? []
                      ).find((candidate) => candidate.id === note.checklistItemId);
                      return (
                        <li
                          className="flex flex-wrap items-center gap-3 rounded-md border border-border p-3"
                          key={note.id}
                        >
                          <audio className="h-8" controls preload="none" src={note.url} />
                          <span className="font-mono text-caption text-text-muted">
                            {formatVoiceNoteDuration(note.durationMs)}
                          </span>
                          {linkedItem && (
                            <span className="text-caption text-text-secondary">
                              {linkedItem.label}
                            </span>
                          )}
                        </li>
                      );
                    })}
                  </ul>
                )}
              </div>

              <div data-testid="readings-section">
                <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                  Readings
                </p>
                {state.inspection.readings ? (
                  <div className="mt-2 grid gap-3 rounded-md border border-border p-3">
                    <div className="flex flex-wrap items-center gap-2">
                      <StatusPill tone={readingsConditionTone(state.inspection.readings.condition)}>
                        {statusLabel(state.inspection.readings.condition)}
                      </StatusPill>
                      {state.inspection.readings.priorityLevel && (
                        <Badge>Priority: {statusLabel(state.inspection.readings.priorityLevel)}</Badge>
                      )}
                      {state.inspection.readings.leakObserved && <Badge>Leak observed</Badge>}
                    </div>
                    <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                      {state.inspection.readings.temperatureC != null && (
                        <Field
                          label="Temperature"
                          value={`${state.inspection.readings.temperatureC} °C`}
                        />
                      )}
                      {state.inspection.readings.pressureBar != null && (
                        <Field label="Pressure" value={`${state.inspection.readings.pressureBar} bar`} />
                      )}
                      {state.inspection.readings.noiseLevelDb != null && (
                        <Field
                          label="Noise level"
                          value={`${state.inspection.readings.noiseLevelDb} dB`}
                        />
                      )}
                      {state.inspection.readings.vibrationObservation && (
                        <Field
                          label="Vibration"
                          value={state.inspection.readings.vibrationObservation}
                        />
                      )}
                      {state.inspection.readings.operationalStatus && (
                        <Field
                          label="Operational status"
                          value={statusLabel(state.inspection.readings.operationalStatus)}
                        />
                      )}
                      {state.inspection.readings.recordedAt && (
                        <Field
                          label="Recorded"
                          value={formatCompanyDateTime(state.inspection.readings.recordedAt)}
                        />
                      )}
                    </div>
                    {state.inspection.readings.comments && (
                      <Field label="Comments" value={state.inspection.readings.comments} />
                    )}
                    {state.inspection.readings.recommendations && (
                      <Field
                        label="Recommendations"
                        value={state.inspection.readings.recommendations}
                      />
                    )}
                  </div>
                ) : (
                  <p className="mt-1 text-bodySmall text-text-muted">
                    No manual status readings have been logged yet.
                  </p>
                )}
              </div>

              <div data-testid="signature-section">
                <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                  Signature
                </p>
                {state.inspection.signature ? (
                  <div className="mt-2 grid gap-3 rounded-md border border-border p-3">
                    <div className="flex flex-wrap items-center gap-2">
                      <StatusPill tone="healthy">Signed</StatusPill>
                      <StatusPill
                        tone={
                          state.inspection.signature.inspectionRevision === state.inspection.revision
                            ? "info"
                            : "warning"
                        }
                      >
                        {state.inspection.signature.inspectionRevision === state.inspection.revision
                          ? `Valid at revision ${state.inspection.signature.inspectionRevision}`
                          : `Superseded (signed revision ${state.inspection.signature.inspectionRevision}, now at ${state.inspection.revision})`}
                      </StatusPill>
                    </div>
                    <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                      <Field label="Signer" value={state.inspection.signature.signerName} />
                      <Field label="Role" value={statusLabel(state.inspection.signature.signerRole)} />
                      <Field
                        label="Signed at"
                        value={formatCompanyDateTime(state.inspection.signature.signedAt)}
                      />
                    </div>
                    <SignaturePreview strokes={state.inspection.signature.strokes} />
                  </div>
                ) : (
                  <p className="mt-1 text-bodySmall text-text-muted">
                    This inspection has not been signed off yet.
                  </p>
                )}
              </div>
            </Card>
          </>
        )}
      </MotionSection>
    </section>
  );
}
