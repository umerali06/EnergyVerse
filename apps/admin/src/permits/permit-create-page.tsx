"use client";

import type { AssetListItem, PermitRiskAssessmentInput } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Button, Card, EmptyState, Input, MotionSection, Select, Textarea, useToast } from "@/design-system";

import { PERMIT_TYPES, type PermitType } from "./permit-types";

type RiskDraft = PermitRiskAssessmentInput;

const EMPTY_RISK: RiskDraft = {
  hazard: "",
  personsAtRisk: "",
  initialLikelihood: 1,
  initialSeverity: 1,
  controls: "",
  residualLikelihood: 1,
  residualSeverity: 1,
};

function score(likelihood: number, severity: number) {
  return likelihood * severity;
}

function band(value: number) {
  if (value <= 4) return "Low";
  if (value <= 9) return "Medium";
  if (value <= 16) return "High";
  return "Critical";
}

export function PermitCreatePage() {
  const { apiClient, currentUser } = useAuth();
  const router = useRouter();
  const toast = useToast();
  const canWrite = currentUser?.permissions.has("permits.write") ?? false;
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [saving, setSaving] = useState(false);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [permitType, setPermitType] = useState<PermitType>("hot_work");
  const [facilityId, setFacilityId] = useState("");
  const [areaId, setAreaId] = useState("");
  const [assetId, setAssetId] = useState("");
  const [templateId, setTemplateId] = useState("");
  const [workerIds, setWorkerIds] = useState<string[]>([]);
  const [validFrom, setValidFrom] = useState("");
  const [validUntil, setValidUntil] = useState("");
  const [risks, setRisks] = useState<RiskDraft[]>([{ ...EMPTY_RISK }]);
  const [facilities, setFacilities] = useState<{ id: string; name: string }[]>([]);
  const [areas, setAreas] = useState<{ id: string; name: string }[]>([]);
  const [assets, setAssets] = useState<AssetListItem[]>([]);
  const [templates, setTemplates] = useState<{ id: string; name: string }[]>([]);
  const [workers, setWorkers] = useState<{ id: string; displayName: string; email: string }[]>([]);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!canWrite) {
      setLoading(false);
      return;
    }
    let active = true;
    Promise.all([
      apiClient.listFacilities({ status: "active", limit: 100 }),
      apiClient.listUsers({ status: "active", limit: 100 }),
    ])
      .then(([facilityPage, userPage]) => {
        if (!active) return;
        setFacilities(facilityPage.items);
        setWorkers(userPage.items);
        setLoading(false);
      })
      .catch(() => {
        if (!active) return;
        setLoadError(true);
        setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [apiClient, canWrite]);

  useEffect(() => {
    if (!canWrite) return;
    let active = true;
    setTemplateId("");
    void apiClient.listPermitTemplates({ permitType, limit: 100 }).then((page) => {
      if (active) setTemplates(page.items);
    }).catch(() => {
      if (active) setTemplates([]);
    });
    return () => {
      active = false;
    };
  }, [apiClient, canWrite, permitType]);

  useEffect(() => {
    setAreaId("");
    setAssetId("");
    setAreas([]);
    setAssets([]);
    if (!facilityId) return;
    let active = true;
    void Promise.all([
      apiClient.listAreas({ facilityId, limit: 100 }),
      apiClient.listAssets({ facilityId, limit: 100 }),
    ]).then(([areaPage, assetPage]) => {
      if (!active) return;
      setAreas(areaPage.items);
      setAssets(assetPage.items);
    });
    return () => {
      active = false;
    };
  }, [apiClient, facilityId]);

  function updateRisk(index: number, patch: Partial<RiskDraft>) {
    setRisks((items) => items.map((item, itemIndex) => itemIndex === index ? { ...item, ...patch } : item));
  }

  function validate() {
    const next: Record<string, string> = {};
    if (title.trim().length < 2) next.title = "Enter at least 2 characters";
    if (!description.trim()) next.description = "Description is required";
    if (!facilityId) next.facility = "Select a facility";
    if (!templateId) next.template = "Select a matching template";
    if (workerIds.length === 0) next.workers = "Assign at least one worker";
    if (!validFrom || !validUntil || new Date(validUntil) <= new Date(validFrom)) {
      next.validity = "Validity end must be after its start";
    }
    risks.forEach((risk, index) => {
      if (!risk.hazard.trim()) next[`hazard-${index}`] = "Hazard is required";
      if (!risk.personsAtRisk.trim()) next[`people-${index}`] = "People at risk are required";
      if (!risk.controls.trim()) next[`controls-${index}`] = "Control measures are required";
      if (score(risk.residualLikelihood, risk.residualSeverity) > score(risk.initialLikelihood, risk.initialSeverity)) {
        next[`risk-${index}`] = "Residual risk cannot exceed initial risk";
      }
    });
    setErrors(next);
    return Object.keys(next).length === 0;
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (!validate()) return;
    setSaving(true);
    try {
      const permit = await apiClient.createPermit({
        title: title.trim(),
        description: description.trim(),
        permitType,
        facilityId,
        areaId: areaId || undefined,
        assetId: assetId || undefined,
        templateId,
        validFrom: new Date(validFrom),
        validUntil: new Date(validUntil),
        workerIds,
        riskAssessment: risks.map((risk) => ({
          ...risk,
          hazard: risk.hazard.trim(),
          personsAtRisk: risk.personsAtRisk.trim(),
          controls: risk.controls.trim(),
        })),
      });
      toast.success(`Permit ${permit.permitNumber} created`);
      router.push(`/permits/${permit.id}`);
    } catch {
      toast.error("Permit could not be created. Review the form and try again.");
    } finally {
      setSaving(false);
    }
  }

  if (!canWrite) {
    return <section className="p-10"><EmptyState title="No access" description="permits.write is required to create permits." /></section>;
  }
  if (loading) return <section className="p-10">Loading permit setup…</section>;
  if (loadError) {
    return <section className="p-10"><EmptyState title="Permit setup unavailable" description="Facilities and workers could not be loaded." action={<Button onClick={() => window.location.reload()}>Retry</Button>} /></section>;
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-5xl">
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">Permit-to-work · controlled preparation</p>
        <h1 className="mt-2 text-h2 font-bold">Create permit draft</h1>
        <p className="mt-1 text-bodySmall text-text-secondary">Risk values are recalculated and validated by the server.</p>
        <form className="mt-6 grid gap-5" onSubmit={submit} noValidate>
          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Work scope</h2>
            <Input label="Title" value={title} error={errors.title} onChange={(event) => setTitle(event.target.value)} />
            <Select label="Permit type" value={permitType} onChange={(event) => setPermitType(event.target.value as PermitType)}>
              {PERMIT_TYPES.map((type) => <option key={type.value} value={type.value}>{type.label}</option>)}
            </Select>
            <div className="md:col-span-2"><Textarea label="Work description" rows={4} value={description} error={errors.description} onChange={(event) => setDescription(event.target.value)} /></div>
          </Card>

          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Location and safety template</h2>
            <Select label="Facility" value={facilityId} error={errors.facility} onChange={(event) => setFacilityId(event.target.value)}>
              <option value="">Select facility</option>
              {facilities.map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
            </Select>
            <Select label="Permit template" value={templateId} error={errors.template} onChange={(event) => setTemplateId(event.target.value)}>
              <option value="">Select matching template</option>
              {templates.map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
            </Select>
            <Select label="Area (optional)" value={areaId} disabled={!facilityId} onChange={(event) => setAreaId(event.target.value)}>
              <option value="">No specific area</option>
              {areas.map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
            </Select>
            <Select label="Asset (optional)" value={assetId} disabled={!facilityId} onChange={(event) => setAssetId(event.target.value)}>
              <option value="">No specific asset</option>
              {assets.filter((item) => !areaId || item.areaId === areaId).map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
            </Select>
          </Card>

          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Validity and assigned workers</h2>
            <Input type="datetime-local" label="Valid from" value={validFrom} error={errors.validity} onChange={(event) => setValidFrom(event.target.value)} />
            <Input type="datetime-local" label="Valid until" value={validUntil} onChange={(event) => setValidUntil(event.target.value)} />
            <Select multiple label="Assigned workers" value={workerIds} error={errors.workers} onChange={(event) => setWorkerIds(Array.from(event.target.selectedOptions, (option) => option.value))}>
              {workers.map((worker) => <option key={worker.id} value={worker.id}>{worker.displayName} · {worker.email}</option>)}
            </Select>
            <p className="self-end text-caption text-text-muted">Use Ctrl/Cmd or Shift to select multiple workers.</p>
          </Card>

          <Card className="grid gap-4 p-5">
            <div className="flex flex-wrap items-center justify-between gap-3">
              <div><h2 className="text-h4 font-semibold">5×5 risk assessment</h2><p className="text-caption text-text-muted">High or Critical residual risk will block submission.</p></div>
              <Button type="button" variant="ghost" onClick={() => setRisks((items) => [...items, { ...EMPTY_RISK }])}>Add hazard</Button>
            </div>
            {risks.map((risk, index) => {
              const initial = score(risk.initialLikelihood, risk.initialSeverity);
              const residual = score(risk.residualLikelihood, risk.residualSeverity);
              return (
                <div key={index} className="grid gap-3 rounded-md border border-border bg-elevated/30 p-4 md:grid-cols-2">
                  <Input label={`Hazard ${index + 1}`} value={risk.hazard} error={errors[`hazard-${index}`]} onChange={(event) => updateRisk(index, { hazard: event.target.value })} />
                  <Input label="Persons at risk" value={risk.personsAtRisk} error={errors[`people-${index}`]} onChange={(event) => updateRisk(index, { personsAtRisk: event.target.value })} />
                  <RiskScale label="Initial likelihood" value={risk.initialLikelihood} onChange={(value) => updateRisk(index, { initialLikelihood: value })} />
                  <RiskScale label="Initial severity" value={risk.initialSeverity} onChange={(value) => updateRisk(index, { initialSeverity: value })} />
                  <div className="md:col-span-2"><Textarea label="Control measures" rows={3} value={risk.controls} error={errors[`controls-${index}`]} onChange={(event) => updateRisk(index, { controls: event.target.value })} /></div>
                  <RiskScale label="Residual likelihood" value={risk.residualLikelihood} onChange={(value) => updateRisk(index, { residualLikelihood: value })} />
                  <RiskScale label="Residual severity" value={risk.residualSeverity} onChange={(value) => updateRisk(index, { residualSeverity: value })} />
                  <p className="text-caption">Initial: <strong>{initial} · {band(initial)}</strong></p>
                  <p className="text-caption">Residual: <strong>{residual} · {band(residual)}</strong></p>
                  {errors[`risk-${index}`] && <p className="text-caption text-statusStrong-critical md:col-span-2">{errors[`risk-${index}`]}</p>}
                  <div className="md:col-span-2"><Button type="button" variant="ghost" disabled={risks.length === 1} onClick={() => setRisks((items) => items.filter((_, itemIndex) => itemIndex !== index))}>Remove hazard</Button></div>
                </div>
              );
            })}
          </Card>
          <div className="flex justify-end gap-3"><Button type="button" variant="ghost" onClick={() => router.push("/permits")}>Cancel</Button><Button type="submit" loading={saving}>Create draft</Button></div>
        </form>
      </MotionSection>
    </section>
  );
}

function RiskScale({ label, value, onChange }: { label: string; value: number; onChange: (value: number) => void }) {
  return <Select label={label} value={value} onChange={(event) => onChange(Number(event.target.value))}>{[1, 2, 3, 4, 5].map((option) => <option key={option} value={option}>{option}</option>)}</Select>;
}
