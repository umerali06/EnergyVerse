"use client";

import type { PermitTemplateListItem } from "@fev/api-client";
import { useRouter } from "next/navigation";

import { useAuth } from "@/auth/auth-context";
import { formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Select,
  Skeleton,
  TableShell,
} from "@/design-system";

import { usePermitTemplatesData } from "./permit-templates-data";
import { PERMIT_TYPES, permitTypeLabel } from "./permit-types";

export function PermitTemplatesPage() {
  const data = usePermitTemplatesData();
  const router = useRouter();
  const { currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("permits.write") ?? false;

  function row(template: PermitTemplateListItem) {
    return (
      <tr
        className={canWrite ? "cursor-pointer border-b border-border transition-colors last:border-0 hover:bg-elevated/60" : "border-b border-border last:border-0"}
        key={template.id}
        onClick={canWrite ? () => router.push(`/permits/templates/${template.id}`) : undefined}
      >
        <td className="p-3 text-bodySmall font-semibold">{template.name}</td>
        <td className="p-3"><Badge>{permitTypeLabel(template.permitType)}</Badge></td>
        <td className="p-3 font-mono text-caption text-text-secondary">v{template.version}</td>
        <td className="p-3 font-mono text-caption text-text-muted">
          {formatRelativeTime(template.updatedAt)}
        </td>
      </tr>
    );
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Permit-to-work · safety controls
            </p>
            <h1 className="mt-2 text-h2 font-bold">Permit templates</h1>
            <p className="mt-1 max-w-2xl text-bodySmall text-text-secondary">
              Versioned checklists and sequential approval chains used as immutable permit snapshots.
            </p>
          </div>
          {canWrite && <Button onClick={() => router.push("/permits/templates/new")}>Create template</Button>}
        </div>

        <Card className="mt-6 grid gap-3 p-4 sm:grid-cols-2 lg:grid-cols-3">
          <Select
            label="Permit type"
            onChange={(event) => data.setPermitType(event.target.value || null)}
            value={data.permitType ?? ""}
          >
            <option value="">All permit types</option>
            {PERMIT_TYPES.map((type) => <option key={type.value} value={type.value}>{type.label}</option>)}
          </Select>
        </Card>

        <Card className="mt-4 p-0">
          {data.list.status === "loading" && <div className="grid gap-3 p-4"><Skeleton className="h-12" /><Skeleton className="h-12" /><Skeleton className="h-12" /></div>}
          {data.list.status === "error" && <div className="p-5"><EmptyState title="Permit templates unavailable" description="Check your connection and retry." action={<Button variant="ghost" onClick={data.retry}>Retry</Button>} /></div>}
          {data.list.status === "ready" && data.list.items.length === 0 && <div className="p-5"><EmptyState title="No permit templates" description="No templates match this permit type." /></div>}
          {data.list.status === "ready" && data.list.items.length > 0 && <>
            <div className="p-3 text-caption text-text-muted">Showing {data.list.items.length} template{data.list.items.length === 1 ? "" : "s"}</div>
            <TableShell label="Permit templates"><thead><tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted"><th className="p-3">Name</th><th className="p-3">Permit type</th><th className="p-3">Version</th><th className="p-3">Updated</th></tr></thead><tbody>{data.list.items.map(row)}</tbody></TableShell>
            {data.list.nextCursor && <div className="p-4"><Button variant="ghost" loading={data.list.loadingMore} onClick={() => void data.loadMore()}>Load more</Button></div>}
          </>}
        </Card>
      </MotionSection>
    </section>
  );
}
