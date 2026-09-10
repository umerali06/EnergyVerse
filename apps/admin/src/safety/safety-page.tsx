"use client";

import type { SafetyReportDetail, SafetyReportListItem } from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  ErrorState,
  Input,
  MotionSection,
  Select,
  StatusPill,
  Textarea,
} from "@/design-system";

const categories = [
  "near_miss",
  "unsafe_condition",
  "unsafe_behavior",
  "fire",
  "gas_leak",
  "chemical_spill",
  "environmental_incident",
  "equipment_failure",
  "injury",
] as const;
const severities = ["low", "medium", "high", "critical"] as const;

const label = (value: string) =>
  value.replace(/_/g, " ").replace(/^\w/, (letter) => letter.toUpperCase());
const tone = (value: string) =>
  value === "critical"
    ? "critical"
    : value === "high"
      ? "warning"
      : value === "closed" || value === "resolved" || value === "completed"
        ? "healthy"
        : "info";

export function SafetyPage() {
  const { apiClient, currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("safety.write") ?? false;
  const canManage = currentUser?.permissions.has("safety.close") ?? false;
  const [items, setItems] = useState<SafetyReportListItem[]>([]);
  const [selected, setSelected] = useState<SafetyReportDetail | null>(null);
  const [status, setStatus] = useState("");
  const [severity, setSeverity] = useState("");
  const [loading, setLoading] = useState(true);
  const [listError, setListError] = useState<string | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);
  const [showCreate, setShowCreate] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setListError(null);
    try {
      const page = await apiClient.listSafetyReports({
        status: status || undefined,
        severity: severity || undefined,
        limit: 100,
      });
      setItems(page.items);
    } catch {
      setItems([]);
      setListError("Safety reports could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, [apiClient, severity, status]);

  useEffect(() => {
    void load();
  }, [load]);

  async function open(reportId: string) {
    setActionError(null);
    try {
      setSelected(await apiClient.getSafetyReport(reportId));
    } catch {
      setActionError("The safety report could not be loaded.");
    }
  }

  async function refreshDetail(updated: SafetyReportDetail) {
    setSelected(updated);
    await load();
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-7xl">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              HSE control center
            </p>
            <h1 className="mt-2 text-h2 font-bold">Safety Reports</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Report hazards, control corrective work, and preserve an auditable incident record.
            </p>
          </div>
          {canWrite && (
            <Button onClick={() => setShowCreate((value) => !value)}>
              {showCreate ? "Cancel" : "Report incident"}
            </Button>
          )}
        </div>

        {showCreate && (
          <CreateReportForm
            onCreated={(report) => {
              setShowCreate(false);
              void refreshDetail(report);
            }}
          />
        )}
        {actionError && (
          <Card className="mt-5 border-critical p-4 text-bodySmall text-critical">
            {actionError}
          </Card>
        )}

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <Select
              label="Status"
              value={status}
              onChange={(event) => setStatus(event.target.value)}
            >
              <option value="">All statuses</option>
              {(
                [
                  "reported",
                  "under_review",
                  "corrective_action",
                  "resolved",
                  "closed",
                  "cancelled",
                ] as const
              ).map((value) => (
                <option key={value} value={value}>
                  {label(value)}
                </option>
              ))}
            </Select>
            <Select
              label="Severity"
              value={severity}
              onChange={(event) => setSeverity(event.target.value)}
            >
              <option value="">All severities</option>
              {severities.map((value) => (
                <option key={value} value={value}>
                  {label(value)}
                </option>
              ))}
            </Select>
          </div>
        </Card>

        <div className="mt-6 grid gap-6 lg:grid-cols-[minmax(0,1fr)_minmax(340px,0.9fr)]">
          <Card className="overflow-hidden">
            {loading ? (
              <p className="p-6 text-bodySmall text-text-secondary">Loading safety reports…</p>
            ) : listError ? (
              <ErrorState
                title="Safety reports could not be loaded"
                description="The incident history is unavailable, so this list is not a record of zero incidents. Retry, or contact an administrator if it persists."
                action={<Button onClick={() => void load()}>Retry</Button>}
              />
            ) : items.length === 0 ? (
              <EmptyState
                title="No safety reports"
                description="No incidents match the selected filters."
              />
            ) : (
              <div className="divide-y divide-border">
                {items.map((report) => (
                  <button
                    className="flex w-full items-center justify-between gap-4 p-4 text-left transition-colors hover:bg-elevated"
                    key={report.id}
                    onClick={() => void open(report.id)}
                  >
                    <span>
                      <span className="block font-semibold">{report.title}</span>
                      <span className="mt-1 block text-caption text-text-secondary">
                        {label(report.category)} · {formatRelativeTime(report.occurredAt)}
                      </span>
                    </span>
                    <span className="flex flex-col items-end gap-2">
                      <StatusPill tone={tone(report.severity)}>{label(report.severity)}</StatusPill>
                      <Badge>{label(report.status)}</Badge>
                    </span>
                  </button>
                ))}
              </div>
            )}
          </Card>
          {selected ? (
            <ReportDetail
              report={selected}
              canManage={canManage}
              canWrite={canWrite}
              onUpdated={refreshDetail}
            />
          ) : (
            <Card className="p-6">
              <EmptyState
                title="Select an incident"
                description="Review evidence, corrective actions, and lifecycle controls."
              />
            </Card>
          )}
        </div>
      </MotionSection>
    </section>
  );
}

function CreateReportForm({ onCreated }: { onCreated: (report: SafetyReportDetail) => void }) {
  const { apiClient } = useAuth();
  const [busy, setBusy] = useState(false);
  return (
    <Card className="mt-6 p-5">
      <form
        className="grid gap-4 md:grid-cols-2"
        onSubmit={async (event) => {
          event.preventDefault();
          setBusy(true);
          const data = new FormData(event.currentTarget);
          try {
            onCreated(
              await apiClient.createSafetyReport({
                id: crypto.randomUUID(),
                title: String(data.get("title")),
                description: String(data.get("description")),
                category: String(data.get("category")) as never,
                severity: String(data.get("severity")) as never,
                occurredAt: new Date(String(data.get("occurredAt"))),
              }),
            );
          } finally {
            setBusy(false);
          }
        }}
      >
        <Input label="Title" name="title" required minLength={3} />
        <Input label="Occurred at" name="occurredAt" required type="datetime-local" />
        <Select label="Category" name="category" required>
          {categories.map((value) => (
            <option key={value} value={value}>
              {label(value)}
            </option>
          ))}
        </Select>
        <Select label="Severity" name="severity" required>
          {severities.map((value) => (
            <option key={value} value={value}>
              {label(value)}
            </option>
          ))}
        </Select>
        <div className="md:col-span-2">
          <Textarea label="Description" name="description" required rows={4} />
        </div>
        <div className="md:col-span-2">
          <Button disabled={busy} type="submit">
            {busy ? "Submitting…" : "Submit safety report"}
          </Button>
        </div>
      </form>
    </Card>
  );
}

function ReportDetail({
  report,
  canManage,
  canWrite,
  onUpdated,
}: {
  report: SafetyReportDetail;
  canManage: boolean;
  canWrite: boolean;
  onUpdated: (report: SafetyReportDetail) => void;
}) {
  const { apiClient } = useAuth();
  const evidence = report.evidence ?? [];
  const correctiveActions = report.correctiveActions ?? [];
  const terminal = report.status === "closed" || report.status === "cancelled";
  const next =
    report.status === "reported"
      ? "under_review"
      : report.status === "under_review"
        ? "corrective_action"
        : report.status === "corrective_action"
          ? "resolved"
          : null;
  return (
    <Card className="p-5">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h2 className="text-h3 font-bold">{report.title}</h2>
          <p className="mt-1 text-caption text-text-secondary">
            {label(report.category)} · Reporter {report.reporterId}
          </p>
        </div>
        <StatusPill tone={tone(report.severity)}>{label(report.severity)}</StatusPill>
      </div>
      <p className="mt-4 whitespace-pre-wrap text-bodySmall text-text-secondary">
        {report.description}
      </p>
      {canManage && !terminal && (
        <div className="mt-5 space-y-3">
          <form
            className="flex gap-2"
            onSubmit={(event) => {
              event.preventDefault();
              const managerId = String(new FormData(event.currentTarget).get("managerId"));
              void apiClient
                .assignSafetyReport(report.id, {
                  managerId,
                  expectedRevision: report.revision,
                })
                .then(onUpdated);
            }}
          >
            <Input
              aria-label="Manager user ID"
              defaultValue={report.assignedManagerId ?? ""}
              label="Manager user ID"
              name="managerId"
              placeholder="Manager user ID"
              required
            />
            <Button type="submit">Assign manager</Button>
          </form>
          <div className="flex flex-wrap gap-2">
            {next && (
              <Button
                onClick={() =>
                  void apiClient
                    .transitionSafetyReport(report.id, {
                      status: next as never,
                      expectedRevision: report.revision,
                    })
                    .then(onUpdated)
                }
              >
                Move to {label(next)}
              </Button>
            )}
            {report.status === "resolved" && (
              <Button onClick={() => void apiClient.closeSafetyReport(report.id).then(onUpdated)}>
                Close incident
              </Button>
            )}
          </div>
        </div>
      )}

      <h3 className="mt-7 font-bold">Evidence</h3>
      <div className="mt-3 grid gap-3 sm:grid-cols-2">
        {evidence.map((item) => (
          <div className="rounded-md border border-border p-3" key={item.id}>
            <a
              className="text-bodySmall hover:text-primary-400"
              href={item.url}
              rel="noreferrer"
              target="_blank"
            >
              <span className="block font-semibold">{item.filename}</span>
              <span className="text-caption text-text-muted">
                {label(item.kind)} · {(item.size / 1024 / 1024).toFixed(1)} MiB
              </span>
            </a>
            {canManage && !terminal && (
              <Button
                className="mt-2"
                onClick={() =>
                  void apiClient.deleteSafetyEvidence(report.id, item.id).then(onUpdated)
                }
                variant="ghost"
              >
                Remove
              </Button>
            )}
          </div>
        ))}
      </div>
      {evidence.length === 0 && (
        <p className="mt-2 text-bodySmall text-text-muted">No evidence attached.</p>
      )}
      {canWrite && !terminal && (
        <label className="mt-3 block text-bodySmall font-semibold">
          Add photo or video
          <input
            className="mt-2 block w-full text-caption"
            type="file"
            accept="image/jpeg,image/png,image/webp,image/heic,video/mp4,video/quicktime,video/webm"
            onChange={(event) => {
              const file = event.target.files?.[0];
              if (!file) return;
              void apiClient
                .uploadSafetyEvidence(
                  report.id,
                  file.type.startsWith("video/") ? "video" : "photo",
                  file,
                )
                .then(onUpdated);
            }}
          />
        </label>
      )}

      <h3 className="mt-7 font-bold">Corrective actions</h3>
      <div className="mt-3 space-y-3">
        {correctiveActions.map((action) => (
          <div className="rounded-md border border-border p-3" key={action.id}>
            <div className="flex justify-between gap-3">
              <span className="font-semibold">{action.description}</span>
              <Badge>{label(action.status)}</Badge>
            </div>
            <p className="mt-1 text-caption text-text-muted">
              Assignee {action.assigneeId} · due {formatRelativeTime(action.dueDate)}
            </p>
            {action.completionNotes && (
              <p className="mt-2 text-bodySmall text-text-secondary">{action.completionNotes}</p>
            )}
            {canManage &&
              !terminal &&
              action.status !== "completed" &&
              action.status !== "cancelled" && (
                <ActionControls actionId={action.id} reportId={report.id} onUpdated={onUpdated} />
              )}
          </div>
        ))}
      </div>
      {correctiveActions.length === 0 && (
        <p className="mt-2 text-bodySmall text-text-muted">No corrective actions assigned.</p>
      )}
      {canManage && !terminal && <ActionForm reportId={report.id} onUpdated={onUpdated} />}
    </Card>
  );
}

function ActionControls({
  reportId,
  actionId,
  onUpdated,
}: {
  reportId: string;
  actionId: string;
  onUpdated: (report: SafetyReportDetail) => void;
}) {
  const { apiClient } = useAuth();
  return (
    <div className="mt-3 grid gap-2 sm:grid-cols-2">
      <form
        className="flex gap-2"
        onSubmit={(event) => {
          event.preventDefault();
          const notes = String(new FormData(event.currentTarget).get("notes"));
          void apiClient
            .updateCorrectiveAction(reportId, actionId, {
              status: "completed",
              completionNotes: notes,
            })
            .then(onUpdated);
        }}
      >
        <Input aria-label="Completion notes" label="Completion notes" name="notes" placeholder="Completion notes" required />
        <Button type="submit">Complete</Button>
      </form>
      <form
        className="flex gap-2"
        onSubmit={(event) => {
          event.preventDefault();
          const reason = String(new FormData(event.currentTarget).get("reason"));
          void apiClient.cancelCorrectiveAction(reportId, actionId, { reason }).then(onUpdated);
        }}
      >
        <Input
          aria-label="Cancellation reason"
          label="Cancellation reason"
          name="reason"
          placeholder="Cancellation reason"
          required
        />
        <Button type="submit" variant="ghost">
          Cancel action
        </Button>
      </form>
    </div>
  );
}

function ActionForm({
  reportId,
  onUpdated,
}: {
  reportId: string;
  onUpdated: (report: SafetyReportDetail) => void;
}) {
  const { apiClient } = useAuth();
  return (
    <form
      className="mt-4 grid gap-3"
      onSubmit={(event) => {
        event.preventDefault();
        const data = new FormData(event.currentTarget);
        void apiClient
          .createCorrectiveAction(reportId, {
            id: crypto.randomUUID(),
            description: String(data.get("description")),
            assigneeId: String(data.get("assigneeId")),
            dueDate: new Date(String(data.get("dueDate"))),
            priority: String(data.get("priority")) as never,
          })
          .then(onUpdated);
        event.currentTarget.reset();
      }}
    >
      <Input label="Corrective action" name="description" required />
      <Input label="Assignee user ID" name="assigneeId" required />
      <Input label="Due date" name="dueDate" type="datetime-local" required />
      <Select label="Priority" name="priority">
        {severities.map((value) => (
          <option key={value} value={value}>
            {label(value)}
          </option>
        ))}
      </Select>
      <Button type="submit">Assign corrective action</Button>
    </form>
  );
}
