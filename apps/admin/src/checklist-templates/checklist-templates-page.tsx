"use client";

import type { ChecklistTemplateListItem } from "@fev/api-client";
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

import { useChecklistTemplatesData } from "./checklist-templates-data";

export const CHECKLIST_TEMPLATE_CATEGORIES = [
  "Generic",
  "Pumps",
  "Compressors",
  "Pipelines",
  "Tanks",
  "Motors",
  "Valves",
  "Electrical Panels",
  "Generators",
  "Transformers",
  "Wellheads",
  "Other",
];

export function ChecklistTemplatesPage({
  reducedMotionOverride,
}: { reducedMotionOverride?: boolean } = {}) {
  const data = useChecklistTemplatesData();
  const router = useRouter();
  const { currentUser } = useAuth();
  const canWrite = currentUser?.permissions.has("checklist_templates.write") ?? false;

  function renderRow(template: ChecklistTemplateListItem) {
    return (
      <tr
        className={
          canWrite
            ? "cursor-pointer border-b border-border last:border-0 hover:bg-elevated/60"
            : "border-b border-border last:border-0"
        }
        key={template.id}
        onClick={canWrite ? () => router.push(`/checklist-templates/${template.id}`) : undefined}
      >
        <td className="p-3 text-bodySmall font-semibold">{template.name}</td>
        <td className="p-3">
          <Badge>{template.category}</Badge>
        </td>
        <td className="p-3 font-mono text-caption text-text-secondary">v{template.version}</td>
        <td
          className="p-3 font-mono text-caption text-text-muted"
          title={template.updatedAt.toISOString()}
        >
          {formatRelativeTime(template.updatedAt)}
        </td>
      </tr>
    );
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Operations
            </p>
            <h1 className="mt-2 text-h2 font-bold">Checklist Templates</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Reusable per-category checklists inspections are answered against.
            </p>
          </div>
          {canWrite && (
            <Button onClick={() => router.push("/checklist-templates/new")}>
              Create template
            </Button>
          )}
        </div>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <Select
              label="Category"
              onChange={(event) => data.setCategory(event.target.value || null)}
              value={data.category ?? ""}
            >
              <option value="">All categories</option>
              {CHECKLIST_TEMPLATE_CATEGORIES.map((category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </Select>
          </div>
        </Card>

        <Card className="mt-4 p-0">
          {data.list.status === "loading" && (
            <div className="grid gap-3 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          )}
          {data.list.status === "error" && (
            <div className="p-4">
              <EmptyState
                action={
                  <Button onClick={data.retry} variant="ghost">
                    Retry
                  </Button>
                }
                description="Couldn't load checklist templates. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState
                description="No checklist templates match this filter."
                title="No templates found"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <div className="flex items-center justify-between p-3 text-caption text-text-muted">
                <span>
                  Showing {data.list.items.length} template
                  {data.list.items.length === 1 ? "" : "s"}
                </span>
              </div>
              <TableShell label="Checklist templates">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Name
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Category
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Version
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Updated
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="checklist-templates-table-body">
                  {data.list.items.map(renderRow)}
                </tbody>
              </TableShell>
              {data.list.nextCursor && (
                <div className="p-4">
                  <Button
                    loading={data.list.loadingMore}
                    onClick={() => void data.loadMore()}
                    variant="ghost"
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
