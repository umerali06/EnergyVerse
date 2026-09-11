"use client";

import type {
  CreatePermitTemplateRequest,
  PermitApprovalTemplateStepInput,
  PermitChecklistTemplateItemInput,
  RoleSummary,
} from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { ApiClientError } from "@/api/client";
import { Button, Card, EmptyState, Input, MotionSection, Select, Textarea, useToast } from "@/design-system";

import { PERMIT_TYPES, type PermitType } from "./permit-types";

type ChecklistDraft = PermitChecklistTemplateItemInput;
type ApprovalDraft = PermitApprovalTemplateStepInput;

const EMPTY_CHECKLIST: ChecklistDraft = { label: "", required: true };
const EMPTY_APPROVAL: ApprovalDraft = { label: "", approverRoleId: "", required: true };

function move<T>(items: T[], from: number, to: number) {
  if (to < 0 || to >= items.length) return items;
  const copy = [...items];
  const [item] = copy.splice(from, 1);
  copy.splice(to, 0, item);
  return copy;
}

export function PermitTemplateFormPage({ templateId }: { templateId?: string }) {
  const router = useRouter();
  const toast = useToast();
  const { apiClient, currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("permits.write") ?? false;
  const [name, setName] = useState("");
  const [permitType, setPermitType] = useState<PermitType>("hot_work");
  const [description, setDescription] = useState("");
  const [checklist, setChecklist] = useState<ChecklistDraft[]>([{ ...EMPTY_CHECKLIST }]);
  const [approvals, setApprovals] = useState<ApprovalDraft[]>([{ ...EMPTY_APPROVAL }]);
  const [roles, setRoles] = useState<RoleSummary[]>([]);
  const [version, setVersion] = useState(1);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!canWrite) {
      setLoading(false);
      return;
    }
    let active = true;
    Promise.all([apiClient.listRoles(), templateId ? apiClient.getPermitTemplate(templateId) : null])
      .then(([roleList, template]) => {
        if (!active) return;
        setRoles(roleList.items);
        if (template) {
          setName(template.name);
          setPermitType(template.permitType);
          setDescription(template.description ?? "");
          setVersion(template.version);
          setChecklist(template.checklistItems.map((item) => ({ ...item })));
          setApprovals(template.approvalSteps.map((step) => ({ ...step })));
        }
        setLoading(false);
      })
      .catch(() => { if (active) { setLoadError(true); setLoading(false); } });
    return () => { active = false; };
  }, [apiClient, canWrite, templateId]);

  function validate() {
    const next: Record<string, string> = {};
    if (name.trim().length < 2) next.name = "Enter at least 2 characters";
    checklist.forEach((item, index) => { if (!item.label.trim()) next[`check-${index}`] = "Label is required"; });
    approvals.forEach((step, index) => {
      if (!step.label.trim()) next[`approval-${index}`] = "Label is required";
      if (!step.approverRoleId) next[`role-${index}`] = "Select an approval role";
    });
    setErrors(next);
    return Object.keys(next).length === 0;
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (!validate()) return;
    setSaving(true);
    const payload: CreatePermitTemplateRequest = {
      name: name.trim(),
      permitType,
      description: description.trim() || undefined,
      checklistItems: checklist.map((item) => ({ ...item, label: item.label.trim(), helpText: item.helpText?.trim() || undefined })),
      approvalSteps: approvals.map((step) => ({ ...step, label: step.label.trim() })),
    };
    try {
      const saved = templateId
        ? await apiClient.updatePermitTemplate(templateId, { ...payload, expectedVersion: version })
        : await apiClient.createPermitTemplate(payload);
      toast.success(templateId ? "Permit template updated" : "Permit template created");
      router.push(`/permits/templates/${saved.id}`);
    } catch (error) {
      if (error instanceof ApiClientError && error.code === "permit_template_version_conflict") {
        setErrors({ form: "This template changed in another session. Reload before saving." });
      }
    } finally { setSaving(false); }
  }

  async function removeTemplate() {
    if (!templateId || !window.confirm("Delete this permit template? Existing permit snapshots will remain unchanged.")) return;
    await apiClient.deletePermitTemplate(templateId);
    toast.success("Permit template deleted");
    router.push("/permits");
  }

  if (!canWrite) return <section className="p-10"><EmptyState title="No access" description="permits.write is required to manage permit templates." /></section>;
  if (loading) return <section className="p-10">Loading permit template…</section>;
  if (loadError) return <section className="p-10"><EmptyState title="Template unavailable" description="The template or tenant roles could not be loaded." action={<Button onClick={() => window.location.reload()}>Retry</Button>} /></section>;

  return (
    <section className="p-6 md:p-10"><MotionSection className="mx-auto max-w-5xl">
      <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">Permit-to-work · template builder</p>
      <h1 className="mt-2 text-h2 font-bold">{templateId ? "Edit permit template" : "Create permit template"}</h1>
      <p className="mt-1 text-bodySmall text-text-secondary">Order is significant. New permits freeze this version; existing permits never change.</p>
      <form className="mt-6 grid gap-5" onSubmit={submit}>
        {errors.form && <Card className="border-statusStrong-critical p-4 text-bodySmall text-statusStrong-critical">{errors.form}</Card>}
        <Card className="grid gap-4 p-5 md:grid-cols-2">
          <h2 className="text-h4 font-semibold md:col-span-2">Template identity</h2>
          <Input label="Name" required value={name} error={errors.name} onChange={(e) => setName(e.target.value)} />
          <Select label="Permit type" value={permitType} onChange={(e) => setPermitType(e.target.value as PermitType)}>{PERMIT_TYPES.map((type) => <option key={type.value} value={type.value}>{type.label}</option>)}</Select>
          <div className="md:col-span-2"><Textarea label="Description (optional)" rows={3} value={description} onChange={(e) => setDescription(e.target.value)} /></div>
          {templateId && <p className="font-mono text-caption text-text-muted md:col-span-2">Current version: v{version}</p>}
        </Card>

        <Card className="grid gap-4 p-5">
          <div className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="text-h4 font-semibold">Checklist controls</h2><p className="text-caption text-text-muted">Workers and issuers confirm these controls before authorization.</p></div><Button type="button" variant="ghost" onClick={() => setChecklist((items) => [...items, { ...EMPTY_CHECKLIST }])}>Add control</Button></div>
          {checklist.map((item, index) => <div className="grid gap-3 rounded-md border border-border bg-elevated/30 p-4 md:grid-cols-2" key={item.id ?? `new-${index}`}>
            <Input label={`Control ${index + 1}`} value={item.label} error={errors[`check-${index}`]} onChange={(e) => setChecklist((items) => items.map((row, i) => i === index ? { ...row, label: e.target.value } : row))} />
            <Input label="Help text (optional)" value={item.helpText ?? ""} onChange={(e) => setChecklist((items) => items.map((row, i) => i === index ? { ...row, helpText: e.target.value } : row))} />
            <label className="flex items-center gap-2 text-bodySmall"><input type="checkbox" checked={item.required} onChange={(e) => setChecklist((items) => items.map((row, i) => i === index ? { ...row, required: e.target.checked } : row))} />Required</label>
            <div className="flex justify-end gap-2"><Button type="button" variant="ghost" disabled={index === 0} onClick={() => setChecklist((items) => move(items, index, index - 1))}>Move up</Button><Button type="button" variant="ghost" disabled={index === checklist.length - 1} onClick={() => setChecklist((items) => move(items, index, index + 1))}>Move down</Button><Button type="button" variant="ghost" disabled={checklist.length === 1} onClick={() => setChecklist((items) => items.filter((_, i) => i !== index))}>Remove</Button></div>
          </div>)}
        </Card>

        <Card className="grid gap-4 p-5">
          <div className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="text-h4 font-semibold">Sequential approvals</h2><p className="text-caption text-text-muted">Approvers must act in this exact order.</p></div><Button type="button" variant="ghost" onClick={() => setApprovals((items) => [...items, { ...EMPTY_APPROVAL }])}>Add approval</Button></div>
          {approvals.map((step, index) => <div className="grid gap-3 rounded-md border border-border bg-elevated/30 p-4 md:grid-cols-2" key={step.id ?? `new-${index}`}>
            <Input label={`Step ${index + 1} label`} value={step.label} error={errors[`approval-${index}`]} onChange={(e) => setApprovals((items) => items.map((row, i) => i === index ? { ...row, label: e.target.value } : row))} />
            <Select label="Approver role" value={step.approverRoleId} error={errors[`role-${index}`]} onChange={(e) => setApprovals((items) => items.map((row, i) => i === index ? { ...row, approverRoleId: e.target.value } : row))}><option value="">Select role</option>{roles.map((role) => <option key={role.id} value={role.id}>{role.name}</option>)}</Select>
            <label className="flex items-center gap-2 text-bodySmall"><input type="checkbox" checked={step.required} onChange={(e) => setApprovals((items) => items.map((row, i) => i === index ? { ...row, required: e.target.checked } : row))} />Required approval</label>
            <div className="flex justify-end gap-2"><Button type="button" variant="ghost" disabled={index === 0} onClick={() => setApprovals((items) => move(items, index, index - 1))}>Move up</Button><Button type="button" variant="ghost" disabled={index === approvals.length - 1} onClick={() => setApprovals((items) => move(items, index, index + 1))}>Move down</Button><Button type="button" variant="ghost" disabled={approvals.length === 1} onClick={() => setApprovals((items) => items.filter((_, i) => i !== index))}>Remove</Button></div>
          </div>)}
        </Card>

        <div className="flex flex-wrap justify-between gap-3"><div>{templateId && <Button type="button" variant="ghost" onClick={() => void removeTemplate()}>Delete template</Button>}</div><div className="flex gap-3"><Button type="button" variant="ghost" onClick={() => router.push("/permits")}>Cancel</Button><Button type="submit" loading={saving}>{templateId ? "Save new version" : "Create template"}</Button></div></div>
      </form>
    </MotionSection></section>
  );
}
