"use client";

import type { CreateGeneratedReportRequestReportTypeEnum } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useMemo, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import {
  Button,
  Card,
  EmptyState,
  Input,
  MotionSection,
  Select,
  Skeleton,
  useToast,
} from "@/design-system";

type ReportType = CreateGeneratedReportRequestReportTypeEnum;
type SourceOption = { id: string; label: string; detail: string };

const TYPES: Array<{ value: ReportType; label: string; permission: string | null }> = [
  { value: "inspection", label: "Inspection", permission: "inspections.read" },
  { value: "maintenance", label: "Maintenance", permission: "work_orders.read" },
  { value: "safety", label: "Safety", permission: "safety.read" },
  { value: "executive_summary", label: "Executive summary", permission: null },
  { value: "asset_health", label: "Asset health", permission: "assets.read" },
];

export function ReportCreatePage() {
  const { apiClient, currentUser } = useAuth();
  const router = useRouter();
  const toast = useToast();
  const canGenerate = currentUser?.permissions.has("reports.generate") ?? false;
  const [reportType, setReportType] = useState<ReportType>("inspection");
  const [title, setTitle] = useState("");
  const [sourceId, setSourceId] = useState("");
  const [sources, setSources] = useState<SourceOption[]>([]);
  const [loadingSources, setLoadingSources] = useState(false);
  const [sourceError, setSourceError] = useState(false);
  const [saving, setSaving] = useState(false);
  const [validationError, setValidationError] = useState<string | null>(null);
  const selectedType = useMemo(
    () => TYPES.find((item) => item.value === reportType)!,
    [reportType],
  );
  const canReadSource =
    !selectedType.permission || currentUser?.permissions.has(selectedType.permission);
  const needsSource = reportType !== "executive_summary";

  useEffect(() => {
    setSourceId("");
    setSources([]);
    setSourceError(false);
    if (!canGenerate || !canReadSource || !needsSource) return;
    let active = true;
    setLoadingSources(true);
    const request =
      reportType === "inspection"
        ? apiClient
            .listInspections({ limit: 100 })
            .then((page) =>
              page.items.map((item) => ({
                id: item.id,
                label: item.title ?? item.id,
                detail: `${item.inspectionType} · ${item.status}`,
              })),
            )
        : reportType === "maintenance"
          ? apiClient
              .listWorkOrders({ limit: 100 })
              .then((page) =>
                page.items.map((item) => ({
                  id: item.id,
                  label: item.title,
                  detail: `${item.priority} · ${item.status}`,
                })),
              )
          : reportType === "safety"
            ? apiClient
                .listSafetyReports({ limit: 100 })
                .then((page) =>
                  page.items.map((item) => ({
                    id: item.id,
                    label: item.title,
                    detail: `${item.severity} · ${item.status}`,
                  })),
                )
            : apiClient
                .listAssets({ limit: 100 })
                .then((page) =>
                  page.items.map((item) => ({
                    id: item.id,
                    label: `${item.assetTag} · ${item.name}`,
                    detail: `${item.category} · ${item.currentStatus}`,
                  })),
                );
    void request
      .then((items) => {
        if (active) setSources(items);
      })
      .catch(() => {
        if (active) setSourceError(true);
      })
      .finally(() => {
        if (active) setLoadingSources(false);
      });
    return () => {
      active = false;
    };
  }, [apiClient, canGenerate, canReadSource, needsSource, reportType]);

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (needsSource && !sourceId) {
      setValidationError("Select an authoritative source record");
      return;
    }
    setValidationError(null);
    setSaving(true);
    try {
      await apiClient.generateReport({
        id: crypto.randomUUID(),
        reportType,
        sourceId: needsSource ? sourceId : undefined,
        title: title.trim() || undefined,
      });
      toast.success("Advisory report draft generated");
      router.push("/reports");
    } catch {
      toast.error("Unable to generate report draft");
    } finally {
      setSaving(false);
    }
  }

  if (!canGenerate)
    return (
      <section className="p-6 md:p-10">
        <EmptyState
          title="Report generation unavailable"
          description="reports.generate permission is required."
        />
      </section>
    );

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-3xl">
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
          Advisory AI · human-reviewed draft
        </p>
        <h1 className="mt-2 text-h2 font-bold">Generate report</h1>
        <p className="mt-1 text-bodySmall text-text-secondary">
          Choose an authoritative tenant source. AI narrative remains editable and cannot finalize
          without human attestation.
        </p>
        <form className="mt-6 grid gap-5" onSubmit={(event) => void submit(event)}>
          <Card className="grid gap-4">
            <Select
              label="Report type"
              value={reportType}
              onChange={(event) => setReportType(event.target.value as ReportType)}
            >
              {TYPES.map((type) => (
                <option key={type.value} value={type.value}>
                  {type.label}
                </option>
              ))}
            </Select>
            <Input
              hint="Optional. A source-derived title is used when empty."
              label="Report title"
              maxLength={200}
              onChange={(event) => setTitle(event.target.value)}
              value={title}
            />
            {needsSource && !canReadSource && (
              <EmptyState
                title="Source permission required"
                description={`${selectedType.permission} is required to generate this report type.`}
              />
            )}
            {needsSource && canReadSource && loadingSources && <Skeleton className="h-16" />}
            {needsSource && canReadSource && sourceError && (
              <EmptyState
                title="Sources unavailable"
                description="The authoritative source list could not be loaded."
              />
            )}
            {needsSource && canReadSource && !loadingSources && !sourceError && (
              <Select
                error={validationError ?? undefined}
                label="Authoritative source"
                onChange={(event) => {
                  setSourceId(event.target.value);
                  setValidationError(null);
                }}
                value={sourceId}
              >
                <option value="">Select source</option>
                {sources.map((source) => (
                  <option key={source.id} value={source.id}>
                    {source.label} — {source.detail}
                  </option>
                ))}
              </Select>
            )}
            {!needsSource && (
              <p className="rounded-md border border-border bg-elevated p-3 text-bodySmall text-text-secondary">
                Executive summaries use current bounded tenant metrics and do not accept a single
                source record.
              </p>
            )}
          </Card>
          <div className="flex justify-end gap-3">
            <Button variant="ghost" onClick={() => router.push("/reports")}>
              Cancel
            </Button>
            <Button disabled={!canReadSource || sourceError} loading={saving} type="submit">
              Generate draft
            </Button>
          </div>
        </form>
      </MotionSection>
    </section>
  );
}
