"use client";

import type {
  GeneratedReportExportResponseFormatEnum,
  GeneratedReportListItem,
} from "@fev/api-client";
import { useState } from "react";
import { useRouter } from "next/navigation";

import { useAuth } from "@/auth/auth-context";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Select,
  Skeleton,
  TableShell,
  useToast,
} from "@/design-system";

import { useReportsData } from "./reports-data";

const REPORT_TYPES = ["inspection", "maintenance", "safety", "executive_summary", "asset_health"];
const EXPORT_FORMATS: GeneratedReportExportResponseFormatEnum[] = ["pdf", "docx", "xlsx"];

function titleCase(value: string): string {
  return value.replaceAll("_", " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

export function ReportsPage() {
  const data = useReportsData();
  const { apiClient, currentUser } = useAuth();
  const router = useRouter();
  const toast = useToast();
  const [exporting, setExporting] = useState<string | null>(null);

  async function exportReport(
    report: GeneratedReportListItem,
    format: GeneratedReportExportResponseFormatEnum,
  ) {
    const key = `${report.id}:${format}`;
    setExporting(key);
    try {
      const artifact = await apiClient.exportGeneratedReport(report.id, format);
      const link = document.createElement("a");
      link.href = artifact.url;
      link.download = artifact.filename;
      link.rel = "noopener";
      link.click();
      toast.success(`${format.toUpperCase()} export ready`);
    } catch {
      toast.error(`Unable to export ${format.toUpperCase()}`);
    } finally {
      setExporting(null);
    }
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-7xl">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Advisory AI · finalized evidence
            </p>
            <h1 className="mt-2 text-h2 font-bold">Reports</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Review tenant report snapshots and download finalized private exports.
            </p>
          </div>
          {currentUser?.permissions.has("reports.generate") && (
            <Button onClick={() => router.push("/reports/new")}>Generate report</Button>
          )}
        </div>

        <Card className="mt-6 grid gap-3 sm:grid-cols-2">
          <Select
            label="Report type"
            value={data.reportType ?? ""}
            onChange={(event) => data.setReportType(event.target.value || null)}
          >
            <option value="">All types</option>
            {REPORT_TYPES.map((type) => (
              <option key={type} value={type}>
                {titleCase(type)}
              </option>
            ))}
          </Select>
          <Select
            label="Status"
            value={data.status ?? ""}
            onChange={(event) => data.setStatus(event.target.value || null)}
          >
            <option value="">All statuses</option>
            <option value="draft">Draft</option>
            <option value="finalized">Finalized</option>
          </Select>
        </Card>

        <Card className="mt-4 p-0">
          {data.list.status === "loading" && (
            <div className="grid gap-3 p-4">
              <Skeleton className="h-12" />
              <Skeleton className="h-12" />
            </div>
          )}
          {data.list.status === "error" && (
            <div className="p-5">
              <EmptyState
                title="Reports unavailable"
                description="Check your connection and retry."
                action={
                  <Button variant="ghost" onClick={data.retry}>
                    Retry
                  </Button>
                }
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-5">
              <EmptyState
                title="No reports found"
                description="No generated reports match these filters."
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <TableShell label="Generated report library">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3">Report</th>
                    <th className="p-3">Type</th>
                    <th className="p-3">Status</th>
                    <th className="p-3">Updated</th>
                    <th className="p-3">Exports</th>
                  </tr>
                </thead>
                <tbody>
                  {data.list.items.map((report) => (
                    <tr className="border-b border-border last:border-0" key={report.id}>
                      <td className="p-3">
                        <button className="text-left text-bodySmall font-semibold text-primary-700 hover:underline dark:text-primary-300" onClick={() => router.push(`/reports/${report.id}`)} type="button">{report.title}</button>
                        <p className="font-mono text-caption text-text-muted">{report.id}</p>
                      </td>
                      <td className="p-3 text-bodySmall">{titleCase(report.reportType)}</td>
                      <td className="p-3">
                        <Badge>{titleCase(report.status)}</Badge>
                      </td>
                      <td className="p-3 font-mono text-caption text-text-muted">
                        {report.updatedAt.toLocaleString()}
                      </td>
                      <td className="p-3">
                        {report.status === "finalized" ? (
                          <div className="flex flex-wrap gap-2">
                            {EXPORT_FORMATS.map((format) => (
                              <Button
                                aria-label={`Export ${report.title} as ${format.toUpperCase()}`}
                                className="min-h-8 px-2.5 py-1"
                                key={format}
                                loading={exporting === `${report.id}:${format}`}
                                onClick={() => void exportReport(report, format)}
                                variant="ghost"
                              >
                                {format.toUpperCase()}
                              </Button>
                            ))}
                          </div>
                        ) : (
                          <span className="text-caption text-text-muted">Finalize to export</span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </TableShell>
              {data.list.nextCursor && (
                <div className="p-4">
                  <Button
                    variant="ghost"
                    loading={data.list.loadingMore}
                    onClick={() => void data.loadMore()}
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
