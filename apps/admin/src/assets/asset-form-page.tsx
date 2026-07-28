"use client";

import type { AssetDetail, CreateAssetRequest } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useMemo, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Button, Card, Input, MotionSection, Select, useToast } from "@/design-system";
import { useAssetsData } from "./assets-data";

const CATEGORIES = [
  "Pumps", "Compressors", "Pipelines", "Tanks", "Motors", "Valves",
  "Electrical Panels", "Generators", "Transformers", "Wellheads", "Other",
];

type Values = {
  name: string; assetTag: string; category: string; categoryOther: string;
  parentAssetId: string; manufacturer: string; model: string; serialNumber: string;
  installationDate: string; description: string; facilityId: string; areaId: string;
  gpsLat: string; gpsLng: string; currentStatus: "Healthy" | "Warning" | "Critical";
};

const EMPTY: Values = {
  name: "", assetTag: "", category: "Pumps", categoryOther: "", parentAssetId: "",
  manufacturer: "", model: "", serialNumber: "", installationDate: "", description: "",
  facilityId: "", areaId: "", gpsLat: "", gpsLng: "", currentStatus: "Healthy",
};

function fromAsset(asset: AssetDetail): Values {
  return {
    name: asset.name, assetTag: asset.assetTag, category: asset.category,
    categoryOther: asset.categoryOther ?? "", parentAssetId: asset.parentAssetId ?? "",
    manufacturer: asset.manufacturer ?? "", model: asset.model ?? "",
    serialNumber: asset.serialNumber ?? "",
    installationDate: asset.installationDate?.toISOString().slice(0, 10) ?? "",
    description: asset.description ?? "", facilityId: asset.facilityId,
    areaId: asset.areaId ?? "", gpsLat: asset.gpsLat?.toString() ?? "",
    gpsLng: asset.gpsLng?.toString() ?? "", currentStatus: asset.currentStatus,
  };
}

export function AssetFormPage({ assetId }: { assetId?: string }) {
  const router = useRouter();
  const toast = useToast();
  const { apiClient } = useAuth();
  const data = useAssetsData();
  const [values, setValues] = useState(EMPTY);
  const [initial, setInitial] = useState(EMPTY);
  const [loading, setLoading] = useState(Boolean(assetId));
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const dirty = JSON.stringify(values) !== JSON.stringify(initial);

  useEffect(() => {
    if (!assetId) return;
    apiClient.getAsset(assetId).then((asset) => {
      const next = fromAsset(asset);
      setValues(next); setInitial(next); setLoading(false);
    }).catch(() => setLoading(false));
  }, [apiClient, assetId]);

  useEffect(() => {
    const guard = (event: BeforeUnloadEvent) => {
      if (dirty) { event.preventDefault(); event.returnValue = ""; }
    };
    window.addEventListener("beforeunload", guard);
    return () => window.removeEventListener("beforeunload", guard);
  }, [dirty]);

  const areas = useMemo(
    () => data.areas.items.filter((area) => area.facilityId === values.facilityId),
    [data.areas.items, values.facilityId],
  );
  const set = (key: keyof Values, value: string) =>
    setValues((current) => ({ ...current, [key]: value }));

  function validate() {
    const next: Record<string, string> = {};
    if (values.name.trim().length < 2) next.name = "Enter at least 2 characters";
    if (!values.assetTag.trim()) next.assetTag = "Asset tag is required";
    if (!values.facilityId) next.facilityId = "Facility is required";
    if (values.category === "Other" && !values.categoryOther.trim()) next.categoryOther = "Specify the category";
    const lat = values.gpsLat === "" ? null : Number(values.gpsLat);
    const lng = values.gpsLng === "" ? null : Number(values.gpsLng);
    if (lat !== null && (Number.isNaN(lat) || lat < -90 || lat > 90)) next.gpsLat = "Latitude must be -90 to 90";
    if (lng !== null && (Number.isNaN(lng) || lng < -180 || lng > 180)) next.gpsLng = "Longitude must be -180 to 180";
    if ((lat === null) !== (lng === null)) next.gpsLng = "Enter both coordinates";
    setErrors(next);
    return Object.keys(next).length === 0;
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (!validate()) return;
    setSaving(true);
    const request: CreateAssetRequest = {
      facilityId: values.facilityId, areaId: values.areaId || undefined,
      parentAssetId: values.parentAssetId || undefined, assetTag: values.assetTag.trim(),
      name: values.name.trim(), category: values.category,
      categoryOther: values.categoryOther || undefined, manufacturer: values.manufacturer || undefined,
      model: values.model || undefined, serialNumber: values.serialNumber || undefined,
      installationDate: values.installationDate ? new Date(`${values.installationDate}T00:00:00Z`) : undefined,
      description: values.description || undefined,
      gpsLat: values.gpsLat ? Number(values.gpsLat) : undefined,
      gpsLng: values.gpsLng ? Number(values.gpsLng) : undefined,
      currentStatus: values.currentStatus,
    };
    try {
      const asset = assetId
        ? await apiClient.updateAsset(assetId, request)
        : await apiClient.createAsset(request);
      toast.success(assetId ? "Asset updated" : "Asset created");
      setInitial(values);
      router.push(`/assets/${asset.id}`);
    } finally { setSaving(false); }
  }

  function cancel() {
    if (!dirty || window.confirm("Discard unsaved changes?")) router.back();
  }

  if (loading) return <section className="p-10">Loading asset…</section>;
  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-4xl">
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">Asset registry</p>
        <h1 className="mt-2 text-h2 font-bold">{assetId ? "Edit asset" : "Create asset"}</h1>
        <form className="mt-6 grid gap-4" onSubmit={submit}>
          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Identity</h2>
            <Input error={errors.name} label="Name" onChange={(e) => set("name", e.target.value)} required value={values.name} />
            <Input error={errors.assetTag} label="Asset tag" onChange={(e) => set("assetTag", e.target.value)} required value={values.assetTag} />
            <Select label="Category" onChange={(e) => set("category", e.target.value)} value={values.category}>{CATEGORIES.map((item) => <option key={item}>{item}</option>)}</Select>
            {values.category === "Other" && <Input error={errors.categoryOther} label="Other category" onChange={(e) => set("categoryOther", e.target.value)} value={values.categoryOther} />}
            <Select label="Parent asset (optional)" onChange={(e) => set("parentAssetId", e.target.value)} value={values.parentAssetId}><option value="">No parent</option>{data.list.items.filter((a) => a.id !== assetId).map((a) => <option key={a.id} value={a.id}>{a.name} · {a.assetTag}</option>)}</Select>
            <Select label="Initial status" onChange={(e) => set("currentStatus", e.target.value)} value={values.currentStatus}><option>Healthy</option><option>Warning</option><option>Critical</option></Select>
          </Card>
          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Details</h2>
            <Input label="Manufacturer" onChange={(e) => set("manufacturer", e.target.value)} value={values.manufacturer} />
            <Input label="Model" onChange={(e) => set("model", e.target.value)} value={values.model} />
            <Input label="Serial number" onChange={(e) => set("serialNumber", e.target.value)} value={values.serialNumber} />
            <Input label="Installation date" onChange={(e) => set("installationDate", e.target.value)} type="date" value={values.installationDate} />
            <Input className="md:col-span-2" label="Description" onChange={(e) => set("description", e.target.value)} value={values.description} />
          </Card>
          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Location</h2>
            <Select error={errors.facilityId} label="Facility" onChange={(e) => { setValues((v) => ({ ...v, facilityId: e.target.value, areaId: "" })); }} required value={values.facilityId}><option value="">Select facility</option>{data.facilities.items.map((f) => <option key={f.id} value={f.id}>{f.name}</option>)}</Select>
            <Select disabled={!values.facilityId} label="Area (optional)" onChange={(e) => set("areaId", e.target.value)} value={values.areaId}><option value="">No area</option>{areas.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}</Select>
            <Input error={errors.gpsLat} inputMode="decimal" label="GPS latitude" onChange={(e) => set("gpsLat", e.target.value)} value={values.gpsLat} />
            <Input error={errors.gpsLng} inputMode="decimal" label="GPS longitude" onChange={(e) => set("gpsLng", e.target.value)} value={values.gpsLng} />
          </Card>
          <div className="flex justify-end gap-3"><Button onClick={cancel} type="button" variant="ghost">Cancel</Button><Button loading={saving} type="submit">{assetId ? "Save changes" : "Create asset"}</Button></div>
        </form>
      </MotionSection>
    </section>
  );
}
