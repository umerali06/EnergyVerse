"use client";

import type { PermitDetail } from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Badge, Button, Card, EmptyState, MotionSection, Skeleton, Textarea, useToast } from "@/design-system";

import { permitTypeLabel } from "./permit-types";

type Action = "approve" | "reject" | "activate" | "suspend" | "resume" | "revoke" | "close";

function titleCase(value: string) {
  return value.replaceAll("_", " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

export function PermitDetailPage({ permitId }: { permitId: string }) {
  const { apiClient, currentUser } = useAuth();
  const toast = useToast();
  const [permit, setPermit] = useState<PermitDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [selectedChecklist, setSelectedChecklist] = useState<Set<string>>(new Set());
  const [action, setAction] = useState<Action | null>(null);
  const [reason, setReason] = useState("");
  const [attested, setAttested] = useState(false);
  const [saving, setSaving] = useState(false);

  const canWrite = currentUser?.permissions.has("permits.write") ?? false;
  const canApprove = currentUser?.permissions.has("permits.approve") ?? false;

  const load = useCallback(async () => {
    setLoading(true);
    setLoadError(false);
    try {
      const detail = await apiClient.getPermit(permitId);
      setPermit(detail);
      setSelectedChecklist(new Set(detail.checklistSnapshot.filter((item) => item.completed).map((item) => item.id)));
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }, [apiClient, permitId]);

  useEffect(() => {
    void load();
  }, [load]);

  async function applyAction() {
    if (!permit || !action || !attested) return;
    if (["reject", "suspend", "revoke", "close"].includes(action) && !reason.trim()) return;
    setSaving(true);
    try {
      let updated: PermitDetail;
      if (action === "approve" || action === "reject") {
        updated = await apiClient.decidePermitApproval(permit.id, {
          decision: action,
          digitalSignatureAttestation: true,
          expectedRevision: permit.revision,
          rejectionReason: action === "reject" ? reason.trim() : undefined,
        });
      } else if (action === "activate") {
        updated = await apiClient.activatePermit(permit.id, { activationAttestation: true, expectedRevision: permit.revision });
      } else if (action === "suspend") {
        updated = await apiClient.suspendPermit(permit.id, { expectedRevision: permit.revision, reason: reason.trim() });
      } else if (action === "resume") {
        updated = await apiClient.resumePermit(permit.id, { expectedRevision: permit.revision, resumeAttestation: true });
      } else if (action === "revoke") {
        updated = await apiClient.revokePermit(permit.id, { expectedRevision: permit.revision, reason: reason.trim() });
      } else {
        updated = await apiClient.closePermit(permit.id, { closeAttestation: true, closeoutNotes: reason.trim(), expectedRevision: permit.revision });
      }
      setPermit(updated);
      setAction(null);
      setReason("");
      setAttested(false);
      toast.success(`Permit ${titleCase(action)} completed`);
    } catch {
      toast.error("The permit changed or the transition was rejected. Current state has been reloaded.");
      await load();
    } finally {
      setSaving(false);
    }
  }

  async function submit() {
    if (!permit || !attested) return;
    setSaving(true);
    try {
      const updated = await apiClient.submitPermit(permit.id, {
        completedChecklistItemIds: [...selectedChecklist],
        expectedRevision: permit.revision,
        issuerAttestation: true,
      });
      setPermit(updated);
      setAction(null);
      setAttested(false);
      toast.success("Permit submitted for approval");
    } catch {
      toast.error("Submission was rejected. Current permit state has been reloaded.");
      await load();
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <section className="grid gap-4 p-10"><Skeleton className="h-16" /><Skeleton className="h-64" /></section>;
  if (loadError || !permit) return <section className="p-10"><EmptyState title="Permit unavailable" description="The permit could not be loaded or is outside your tenant." action={<Button onClick={() => void load()}>Retry</Button>} /></section>;

  const acknowledgements = new Set(permit.workerAcknowledgements.map((item) => item.workerId));
  const pendingApproval = permit.approvalSnapshot.find((step) => step.status === "pending");
  const requiresReason = action && ["reject", "suspend", "revoke", "close"].includes(action);

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto grid max-w-7xl gap-5">
        <header className="flex flex-wrap items-start justify-between gap-4">
          <div><p className="font-mono text-caption text-primary-600 dark:text-primary-400">{permit.permitNumber} · revision {permit.revision}</p><h1 className="mt-2 text-h2 font-bold">{permit.title}</h1><p className="mt-1 text-bodySmall text-text-secondary">{permitTypeLabel(permit.permitType)} · {permit.templateName} v{permit.templateVersion}</p></div>
          <div className="flex gap-2"><Badge>{titleCase(permit.status)}</Badge><Badge>{titleCase(permit.highestResidualRisk)} residual risk</Badge></div>
        </header>

        <Card className="grid gap-4 p-5 md:grid-cols-4">
          <Detail label="Valid from" value={permit.validFrom.toLocaleString()} />
          <Detail label="Valid until" value={permit.validUntil.toLocaleString()} />
          <Detail label="Facility ID" value={permit.facilityId} mono />
          <Detail label="Workers" value={`${acknowledgements.size} / ${permit.workerCount} acknowledged`} />
          <div className="md:col-span-4"><Detail label="Work description" value={permit.description} /></div>
        </Card>

        <div className="grid gap-5 lg:grid-cols-2">
          <Card className="p-5"><h2 className="text-h4 font-semibold">Safety checklist</h2><div className="mt-4 grid gap-3">{permit.checklistSnapshot.map((item) => <label key={item.id} className="flex items-start gap-3 rounded-md border border-border p-3 text-bodySmall"><input type="checkbox" disabled={permit.status !== "draft" || !canWrite} checked={selectedChecklist.has(item.id)} onChange={(event) => setSelectedChecklist((current) => { const next = new Set(current); event.target.checked ? next.add(item.id) : next.delete(item.id); return next; })} /><span><strong>{item.label}</strong>{item.required && <span className="ml-2 text-statusStrong-critical">Required</span>}{item.helpText && <span className="mt-1 block text-caption text-text-muted">{item.helpText}</span>}{item.completedAt && <span className="mt-1 block text-caption text-text-muted">Completed {item.completedAt.toLocaleString()}</span>}</span></label>)}</div></Card>
          <Card className="p-5"><h2 className="text-h4 font-semibold">Sequential approvals</h2><div className="mt-4 grid gap-3">{permit.approvalSnapshot.map((step, index) => <div key={step.id} className="rounded-md border border-border p-3"><div className="flex justify-between gap-3"><strong className="text-bodySmall">{index + 1}. {step.label}</strong><Badge>{titleCase(step.status)}</Badge></div><p className="mt-1 font-mono text-caption text-text-muted">Role {step.approverRoleId}</p>{step.signedAt && <p className="mt-1 text-caption text-text-muted">Signed {step.signedAt.toLocaleString()}</p>}{step.rejectionReason && <p className="mt-1 text-caption text-statusStrong-critical">{step.rejectionReason}</p>}</div>)}</div></Card>
        </div>

        <Card className="p-5"><h2 className="text-h4 font-semibold">Risk assessment</h2><div className="mt-4 grid gap-3">{permit.riskAssessment.map((risk) => <div key={risk.id} className="grid gap-2 rounded-md border border-border p-3 md:grid-cols-4"><div className="md:col-span-2"><strong className="text-bodySmall">{risk.hazard}</strong><p className="text-caption text-text-muted">At risk: {risk.personsAtRisk}</p></div><p className="text-caption">Initial <strong>{risk.initialScore} · {titleCase(risk.initialBand)}</strong></p><p className="text-caption">Residual <strong>{risk.residualScore} · {titleCase(risk.residualBand)}</strong></p><p className="text-bodySmall md:col-span-4">Controls: {risk.controls}</p></div>)}</div></Card>

        <Card className="p-5"><h2 className="text-h4 font-semibold">Controlled actions</h2><p className="mt-1 text-caption text-text-muted">Every transition is revision-checked, server-signed, and audited.</p><div className="mt-4 flex flex-wrap gap-2">
          {permit.status === "draft" && canWrite && <Button onClick={() => { setAction("approve"); setAttested(false); }}>Prepare submission</Button>}
          {permit.status === "pending_approval" && canApprove && <><Button onClick={() => setAction("approve")}>Approve {pendingApproval?.label}</Button><Button variant="ghost" onClick={() => setAction("reject")}>Reject</Button></>}
          {permit.status === "pending_signatures" && canWrite && <Button disabled={acknowledgements.size !== permit.workerCount} onClick={() => setAction("activate")}>Activate permit</Button>}
          {permit.status === "active" && canApprove && <><Button variant="ghost" onClick={() => setAction("suspend")}>Suspend</Button><Button variant="ghost" onClick={() => setAction("close")}>Close</Button><Button variant="danger" onClick={() => setAction("revoke")}>Revoke</Button></>}
          {permit.status === "suspended" && canApprove && <><Button onClick={() => setAction("resume")}>Resume</Button><Button variant="danger" onClick={() => setAction("revoke")}>Revoke</Button></>}
          {!((permit.status === "draft" && canWrite) || (permit.status === "pending_approval" && canApprove) || (permit.status === "pending_signatures" && canWrite) || (["active", "suspended"].includes(permit.status) && canApprove)) && <p className="text-bodySmall text-text-muted">No lifecycle action is available for your role in the current state.</p>}
        </div></Card>

        {action && <Card className="border-primary-400/50 p-5"><h2 className="text-h4 font-semibold">{permit.status === "draft" ? "Submit permit" : `${titleCase(action)} permit`}</h2>{permit.status === "draft" && <p className="mt-2 text-bodySmall">Confirm every required checklist item before signing the issuer attestation.</p>}{requiresReason && <div className="mt-4"><Textarea label={action === "close" ? "Closeout notes" : "Reason"} value={reason} onChange={(event) => setReason(event.target.value)} /></div>}<label className="mt-4 flex items-start gap-3 text-bodySmall"><input type="checkbox" checked={attested} onChange={(event) => setAttested(event.target.checked)} /><span>I attest that this controlled action is accurate and authorize my server-derived digital signature.</span></label><div className="mt-4 flex gap-2"><Button variant="ghost" onClick={() => { setAction(null); setReason(""); setAttested(false); }}>Cancel</Button><Button loading={saving} disabled={!attested || Boolean(requiresReason && !reason.trim())} onClick={() => void (permit.status === "draft" ? submit() : applyAction())}>Confirm {permit.status === "draft" ? "submission" : action}</Button></div></Card>}
      </MotionSection>
    </section>
  );
}

function Detail({ label, value, mono = false }: { label: string; value: string; mono?: boolean }) {
  return <div><p className="text-caption uppercase tracking-wide text-text-muted">{label}</p><p className={mono ? "mt-1 break-all font-mono text-caption" : "mt-1 text-bodySmall"}>{value}</p></div>;
}
