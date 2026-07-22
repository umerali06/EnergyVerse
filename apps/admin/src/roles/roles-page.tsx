"use client";

import { useState } from "react";

import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Skeleton,
  TableShell,
} from "@/design-system";

import { CreateRoleModal, RoleDetailModal } from "./role-modals";
import { useRolesData } from "./roles-data";

export function RolesPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const data = useRolesData();
  const [createOpen, setCreateOpen] = useState(false);
  const [selectedRoleId, setSelectedRoleId] = useState<string | null>(null);

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Administration
            </p>
            <h1 className="mt-2 text-h2 font-bold">Roles</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Review the permission model and manage custom roles for your company.
            </p>
          </div>
          <Button onClick={() => setCreateOpen(true)}>Create role</Button>
        </div>

        <Card className="mt-6 p-0">
          {data.roles.status === "loading" && (
            <div className="grid gap-3 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          )}
          {data.roles.status === "error" && (
            <div className="p-4">
              <EmptyState
                action={
                  <Button onClick={data.retryRoles} variant="ghost">
                    Retry
                  </Button>
                }
                description="Couldn't load roles. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.roles.status === "ready" && data.roles.items.length === 0 && (
            <div className="p-4">
              <EmptyState description="No roles exist yet." title="No roles found" />
            </div>
          )}
          {data.roles.status === "ready" && data.roles.items.length > 0 && (
            <TableShell label="Company roles">
              <thead>
                <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                  <th className="p-3 font-semibold" scope="col">
                    Name
                  </th>
                  <th className="p-3 font-semibold" scope="col">
                    Type
                  </th>
                  <th className="p-3 font-semibold" scope="col">
                    Permissions
                  </th>
                  <th className="p-3 font-semibold" scope="col">
                    Users
                  </th>
                  <th className="p-3 font-semibold" scope="col">
                    <span className="sr-only">Actions</span>
                  </th>
                </tr>
              </thead>
              <tbody data-testid="roles-table-body">
                {data.roles.items.map((role) => (
                  <tr className="border-b border-border last:border-0" key={role.id}>
                    <td className="p-3">
                      <span className="block text-bodySmall font-semibold">{role.name}</span>
                      {role.description && (
                        <span className="block text-caption text-text-muted">
                          {role.description}
                        </span>
                      )}
                    </td>
                    <td className="p-3">
                      <Badge>{role.isSystem ? "System" : "Custom"}</Badge>
                    </td>
                    <td className="p-3 font-mono text-bodySmall">{role.permissionCount}</td>
                    <td className="p-3 font-mono text-bodySmall">{role.assignedUserCount}</td>
                    <td className="p-3 text-right">
                      <button
                        className="text-bodySmall font-semibold text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                        onClick={() => setSelectedRoleId(role.id)}
                        type="button"
                      >
                        View
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </TableShell>
          )}
        </Card>
      </MotionSection>

      <CreateRoleModal
        createRole={data.createRole}
        onClose={() => setCreateOpen(false)}
        onCreated={data.refresh}
        open={createOpen}
        permissionGroups={data.catalog.groups}
        roles={data.roles.items}
      />
      <RoleDetailModal
        deleteRole={data.deleteRole}
        getRole={data.getRole}
        onChanged={data.refresh}
        onClose={() => setSelectedRoleId(null)}
        permissionGroups={data.catalog.groups}
        roleId={selectedRoleId}
        updateRole={data.updateRole}
      />
    </section>
  );
}
