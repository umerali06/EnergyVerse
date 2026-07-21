"use client";

import { useState } from "react";

import { formatRelativeTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  Input,
  MotionSection,
  Select,
  Skeleton,
  StatusPill,
  TableShell,
  cn,
} from "@/design-system";

import { InviteUserModal, UserDetailModal } from "./user-modals";
import { useUsersData } from "./users-data";

function initialsFor(email: string): string {
  const name = email.split("@")[0];
  const parts = name.split(/[._-]+/).filter(Boolean);
  const first = parts[0]?.[0] ?? "?";
  const second = parts[1]?.[0] ?? name[1] ?? "";
  return `${first}${second}`.toUpperCase();
}

const SORT_OPTIONS: Array<{ value: string; label: string }> = [
  { value: "name", label: "Name (A–Z)" },
  { value: "-name", label: "Name (Z–A)" },
  { value: "-created_at", label: "Newest first" },
  { value: "created_at", label: "Oldest first" },
];

export function UsersPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const data = useUsersData();
  const [inviteOpen, setInviteOpen] = useState(false);
  const [selectedUserId, setSelectedUserId] = useState<string | null>(null);

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-6xl" reducedMotionOverride={reducedMotionOverride}>
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Administration
            </p>
            <h1 className="mt-2 text-h2 font-bold">Users</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Manage who has access to your company and what they can do.
            </p>
          </div>
          <Button onClick={() => setInviteOpen(true)}>Invite user</Button>
        </div>

        <Card className="mt-6 p-4">
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            <Input
              label="Search"
              onChange={(event) => data.setSearch(event.target.value)}
              placeholder="Name or email"
              value={data.filters.search}
            />
            <Select
              label="Role"
              onChange={(event) => data.setRoleFilter(event.target.value || null)}
              value={data.filters.roleId ?? ""}
            >
              <option value="">All roles</option>
              {data.roles.items.map((role) => (
                <option key={role.id} value={role.id}>
                  {role.name}
                </option>
              ))}
            </Select>
            <Select
              label="Status"
              onChange={(event) => data.setStatusFilter(event.target.value || null)}
              value={data.filters.status ?? ""}
            >
              <option value="">All statuses</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
            </Select>
            <Select
              label="Sort"
              onChange={(event) => data.setSort(event.target.value)}
              value={data.filters.sort}
            >
              {SORT_OPTIONS.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
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
              <Skeleton className="h-10 w-full" />
            </div>
          )}
          {data.list.status === "error" && (
            <div className="p-4">
              <EmptyState
                action={
                  <Button onClick={data.retryUsers} variant="ghost">
                    Retry
                  </Button>
                }
                description="Couldn't load users. Check your connection and try again."
                title="Something went wrong"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length === 0 && (
            <div className="p-4">
              <EmptyState
                description="No users match your current filters."
                title="No users found"
              />
            </div>
          )}
          {data.list.status === "ready" && data.list.items.length > 0 && (
            <>
              <TableShell label="Company users">
                <thead>
                  <tr className="border-b border-border text-caption uppercase tracking-[0.1em] text-text-muted">
                    <th className="p-3 font-semibold" scope="col">
                      Name
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Role
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Status
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      Updated
                    </th>
                    <th className="p-3 font-semibold" scope="col">
                      <span className="sr-only">Actions</span>
                    </th>
                  </tr>
                </thead>
                <tbody data-testid="users-table-body">
                  {data.list.items.map((user) => (
                    <tr className="border-b border-border last:border-0" key={user.id}>
                      <td className="p-3">
                        <div className="flex items-center gap-3">
                          <span
                            aria-hidden
                            className="grid size-8 shrink-0 place-items-center rounded-full bg-primary-800/10 font-mono text-caption font-semibold text-primary-700 dark:bg-primary-400/20 dark:text-primary-300"
                          >
                            {initialsFor(user.email)}
                          </span>
                          <span>
                            <span className="block text-bodySmall font-semibold">
                              {user.displayName}
                            </span>
                            <span className="block font-mono text-caption text-text-muted">
                              {user.email}
                            </span>
                          </span>
                        </div>
                      </td>
                      <td className="p-3">
                        <Badge>{user.roleName}</Badge>
                      </td>
                      <td className="p-3">
                        <StatusPill tone={user.status === "active" ? "healthy" : "critical"}>
                          {user.status}
                        </StatusPill>
                      </td>
                      <td className="p-3 font-mono text-caption text-text-muted">
                        {formatRelativeTime(user.updatedAt)}
                      </td>
                      <td className="p-3 text-right">
                        <button
                          className={cn(
                            "text-bodySmall font-semibold text-primary-700 underline-offset-2 hover:underline dark:text-primary-300",
                          )}
                          onClick={() => setSelectedUserId(user.id)}
                          type="button"
                        >
                          View
                        </button>
                      </td>
                    </tr>
                  ))}
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

      <InviteUserModal
        onClose={() => setInviteOpen(false)}
        onInvited={data.refresh}
        open={inviteOpen}
        roles={data.roles.items}
        users={data}
      />
      <UserDetailModal
        getUser={data.getUser}
        onChanged={data.refresh}
        onClose={() => setSelectedUserId(null)}
        roles={data.roles.items}
        setUserStatus={data.setUserStatus}
        updateUser={data.updateUser}
        userId={selectedUserId}
      />
    </section>
  );
}
