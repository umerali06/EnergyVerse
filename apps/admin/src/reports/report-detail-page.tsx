"use client";

import type { GeneratedReportDetail } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Badge, Button, Card, Checkbox, EmptyState, Input, Modal, MotionSection, Skeleton, Textarea, useToast } from "@/design-system";

type Action = "regenerate" | "finalize" | "delete";

function titleCase(value: string) {
  return value.replaceAll("_", " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function lines(value: string): string[] {
  return value.split("\n").map((item) => item.trim()).filter(Boolean);
}

function snapshotRows(value: unknown, prefix = ""): Array<[string, string]> {
  if (Array.isArray(value)) return value.flatMap((item, index) => snapshotRows(item, `${prefix}[${index}]`));
  if (value && typeof value === "object") return Object.entries(value).flatMap(([key, item]) => snapshotRows(item, prefix ? `${prefix}.${key}` : key));
  return [[prefix, value === null || value === undefined ? "" : String(value)]];
}

export function ReportDetailPage({ reportId }: { reportId: string }) {
  const { apiClient, currentUser } = useAuth();
  const router = useRouter();
  const toast = useToast();
  const [report, setReport] = useState<GeneratedReportDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [saving, setSaving] = useState(false);
  const [action, setAction] = useState<Action | null>(null);
  const [attested, setAttested] = useState(false);
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [findings, setFindings] = useState("");
  const [recommendations, setRecommendations] = useState("");
  const [riskScore, setRiskScore] = useState("");
  const canGenerate = currentUser?.permissions.has("reports.generate") ?? false;

  const apply = useCallback((detail: GeneratedReportDetail) => {
    setReport(detail);
    setTitle(detail.title);
    setSummary(detail.narrative.summary);
    setFindings((detail.narrative.findings ?? []).join("\n"));
    setRecommendations((detail.narrative.recommendations ?? []).join("\n"));
    setRiskScore(detail.narrative.riskScore === null || detail.narrative.riskScore === undefined ? "" : String(detail.narrative.riskScore));
  }, []);

  const load = useCallback(async () => {
    setLoading(true);
    setLoadError(false);
    try { apply(await apiClient.getGeneratedReport(reportId)); }
    catch { setLoadError(true); }
    finally { setLoading(false); }
  }, [apiClient, apply, reportId]);

  useEffect(() => { void load(); }, [load]);

  async function save(event: FormEvent) {
    event.preventDefault();
    if (!report || !title.trim() || !summary.trim()) return;
    setSaving(true);
    try {
      const updated = await apiClient.updateGeneratedReport(report.id, {
        expectedRevision: report.revision,
        title: title.trim(),
        summary: summary.trim(),
        findings: lines(findings),
        recommendations: lines(recommendations),
        riskScore: riskScore === "" ? undefined : Number(riskScore),
      });
      apply(updated);
      toast.success("Human report edits saved");
    } catch {
      toast.error("The report changed or the edit was rejected. Current state has been reloaded.");
      await load();
    } finally { setSaving(false); }
  }

  async function confirmAction() {
    if (!report || !action || (action === "finalize" && !attested)) return;
    setSaving(true);
    try {
      if (action === "delete") {
        await apiClient.deleteGeneratedReport(report.id);
        toast.success("Draft report deleted");
        router.push("/reports");
        return;
      }
      const updated = action === "regenerate"
        ? await apiClient.regenerateGeneratedReport(report.id, report.revision)
        : await apiClient.finalizeGeneratedReport(report.id, report.revision);
      apply(updated);
      toast.success(action === "regenerate" ? "Advisory narrative regenerated from current source data" : "Report finalized and locked");
      setAction(null);
      setAttested(false);
    } catch {
      toast.error("The action was rejected. Current report state has been reloaded.");
      setAction(null);
      setAttested(false);
      await load();
    } finally { setSaving(false); }
  }

  if (loading) return <section className="grid gap-4 p-10"><Skeleton className="h-20" /><Skeleton className="h-72" /></section>;
  if (loadError || !report) return <section className="p-10"><EmptyState title="Report unavailable" description="The report could not be loaded or is outside your tenant." action={<Button onClick={() => void load()}>Retry</Button>} /></section>;
  const draft = report.status === "draft";

  return <section className="p-6 md:p-10"><MotionSection className="mx-auto grid max-w-6xl gap-5">
    <header className="flex flex-wrap items-start justify-between gap-4"><div><p className="font-mono text-caption text-primary-600 dark:text-primary-400">{titleCase(report.reportType)} · revision {report.revision}</p><h1 className="mt-2 text-h2 font-bold">{report.title}</h1><p className="mt-1 text-bodySmall text-text-secondary">AI model {report.aiModel} · source revision {report.sourceRevision ?? "snapshot aggregate"}</p></div><div className="flex flex-wrap gap-2"><Badge>{titleCase(report.status)}</Badge><Button variant="ghost" onClick={() => router.push("/reports")}>Back to reports</Button></div></header>

    {!draft && <Card><p className="font-semibold text-statusStrong-healthy dark:text-statusSoft-healthy">Finalized report · immutable</p><p className="mt-1 text-bodySmall text-text-secondary">Attested by {report.finalizedBy} on {report.finalizedAt?.toLocaleString()}. Export formats are available from the report library.</p></Card>}

    <form className="grid gap-5" onSubmit={(event) => void save(event)}>
      <Card className="grid gap-4"><Input disabled={!draft || !canGenerate} label="Report title" maxLength={200} onChange={(event) => setTitle(event.target.value)} required value={title} /><Textarea disabled={!draft || !canGenerate} label="Executive summary" maxLength={10000} onChange={(event) => setSummary(event.target.value)} required value={summary} /><Textarea disabled={!draft || !canGenerate} hint="One finding per line" label="Findings" onChange={(event) => setFindings(event.target.value)} value={findings} /><Textarea disabled={!draft || !canGenerate} hint="One recommendation per line" label="Recommendations" onChange={(event) => setRecommendations(event.target.value)} value={recommendations} /><Input disabled={!draft || !canGenerate} label="Risk score" max={100} min={0} onChange={(event) => setRiskScore(event.target.value)} step="0.1" type="number" value={riskScore} /></Card>
      {draft && canGenerate && <div className="flex flex-wrap justify-end gap-2"><Button variant="danger" onClick={() => setAction("delete")}>Delete draft</Button><Button variant="ghost" onClick={() => setAction("regenerate")}>Regenerate from source</Button><Button loading={saving} type="submit">Save human edits</Button><Button variant="accent" onClick={() => setAction("finalize")}>Finalize report</Button></div>}
    </form>

    <Card><h2 className="text-h4 font-bold">Authoritative source snapshot</h2><p className="mt-1 text-caption text-text-muted">Frozen report input; regeneration explicitly replaces it only while this report is a draft.</p><div className="mt-4 overflow-x-auto"><table className="w-full text-left text-bodySmall"><thead><tr className="border-b border-border"><th className="p-2">Field</th><th className="p-2">Value</th></tr></thead><tbody>{snapshotRows(report.sourceSnapshot).map(([field, value]) => <tr className="border-b border-border last:border-0" key={field}><td className="p-2 font-mono text-caption">{field}</td><td className="p-2">{value}</td></tr>)}</tbody></table></div></Card>

    <Modal onClose={() => { if (!saving) { setAction(null); setAttested(false); } }} open={action !== null} title={action === "finalize" ? "Finalize and lock report" : action === "regenerate" ? "Regenerate advisory narrative" : "Delete draft report"}>
      <p>{action === "finalize" ? "Finalization is permanent. Confirm that you reviewed the advisory AI narrative and authoritative source snapshot." : action === "regenerate" ? "Current human edits will be replaced using the latest authoritative source data." : "This audited action permanently removes the draft from the report library."}</p>
      {action === "finalize" && <Checkbox checked={attested} className="mt-4" label="I reviewed this report and attest that it is ready to finalize" onChange={setAttested} />}
      <div className="mt-5 flex justify-end gap-2"><Button disabled={saving} variant="ghost" onClick={() => { setAction(null); setAttested(false); }}>Cancel</Button><Button disabled={action === "finalize" && !attested} loading={saving} variant={action === "delete" ? "danger" : action === "finalize" ? "accent" : "primary"} onClick={() => void confirmAction()}>{action === "finalize" ? "Finalize and lock" : action === "regenerate" ? "Regenerate" : "Delete draft"}</Button></div>
    </Modal>
  </MotionSection></section>;
}
