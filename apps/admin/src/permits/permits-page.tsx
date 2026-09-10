"use client";

import type { PermitListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";

import { useAuth } from "@/auth/auth-context";
import { Badge, Button, Card, EmptyState, MotionSection, Select, Skeleton, TableShell } from "@/design-system";

import { PERMIT_TYPES, permitTypeLabel } from "./permit-types";
import { usePermitsData } from "./permits-data";

function titleCase(value: string) { return value.replaceAll("_", " ").replace(/\b\w/g, (letter) => letter.toUpperCase()); }

export function PermitsPage() {
  const data = usePermitsData();
  const router = useRouter();
  const { currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("permits.write") ?? false;
  const facilityNames = new Map(data.facilities.map((facility) => [facility.id, facility.name]));

  function row(permit: PermitListItem) {
    return <tr key={permit.id} className="cursor-pointer border-b border-border transition-colors last:border-0 hover:bg-elevated/60" onClick={() => router.push(`/permits/${permit.id}`)}>
      <td className="p-3"><p className="font-mono text-caption text-primary-600 dark:text-primary-400">{permit.permitNumber}</p><p className="text-bodySmall font-semibold">{permit.title}</p></td>
      <td className="p-3 text-bodySmall">{permitTypeLabel(permit.permitType)}</td>
      <td className="p-3 text-bodySmall">{facilityNames.get(permit.facilityId) ?? permit.facilityId}</td>
      <td className="p-3"><Badge>{titleCase(permit.status)}</Badge></td>
      <td className="p-3"><Badge>{titleCase(permit.highestResidualRisk)}</Badge></td>
      <td className="p-3 text-caption text-text-muted">{permit.workerCount}</td>
      <td className="p-3 font-mono text-caption text-text-muted">{permit.validUntil.toLocaleString()}</td>
    </tr>;
  }

  return <section className="p-6 md:p-10"><MotionSection className="mx-auto max-w-7xl">
    <div className="flex flex-wrap items-start justify-between gap-4"><div><p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">Permit-to-work · control center</p><h1 className="mt-2 text-h2 font-bold">Permits</h1><p className="mt-1 text-bodySmall text-text-secondary">Prepare, authorize, activate, and close controlled work.</p></div><div className="flex gap-3"><Button variant="ghost" onClick={() => router.push("/permits/templates")}>Manage templates</Button>{canWrite && <Button onClick={() => router.push("/permits/new")}>Create permit</Button>}</div></div>
    <Card className="mt-6 grid gap-3 p-4 sm:grid-cols-2 lg:grid-cols-3"><Select label="Permit type" value={data.permitType ?? ""} onChange={(e) => data.setPermitType(e.target.value || null)}><option value="">All types</option>{PERMIT_TYPES.map((type) => <option key={type.value} value={type.value}>{type.label}</option>)}</Select><Select label="Facility" value={data.facilityId ?? ""} onChange={(e) => data.setFacilityId(e.target.value || null)}><option value="">All facilities</option>{data.facilities.map((facility) => <option key={facility.id} value={facility.id}>{facility.name}</option>)}</Select></Card>
    <Card className="mt-4 p-0">{data.list.status === "loading" && <div className="grid gap-3 p-4"><Skeleton className="h-12" /><Skeleton className="h-12" /></div>}{data.list.status === "error" && <div className="p-5"><EmptyState title="Permits unavailable" description="Check your connection and retry." action={<Button variant="ghost" onClick={data.retry}>Retry</Button>} /></div>}{data.list.status === "ready" && data.list.items.length === 0 && <div className="p-5"><EmptyState title="No permits found" description="No permits match these filters." /></div>}{data.list.status === "ready" && data.list.items.length > 0 && <><TableShell label="Permit register"><thead><tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted"><th className="p-3">Permit</th><th className="p-3">Type</th><th className="p-3">Facility</th><th className="p-3">Status</th><th className="p-3">Residual risk</th><th className="p-3">Workers</th><th className="p-3">Valid until</th></tr></thead><tbody>{data.list.items.map(row)}</tbody></TableShell>{data.list.nextCursor && <div className="p-4"><Button variant="ghost" loading={data.list.loadingMore} onClick={() => void data.loadMore()}>Load more</Button></div>}</>}</Card>
  </MotionSection></section>;
}
