"use client";

import type { PermissionCatalogGroup, RoleDetail, RoleSummary } from "@fev/api-client";
import Link from "next/link";
import { useEffect, useMemo, useState } from "react";

import { ApiClientError } from "@/api";
import { Badge, Button, Card, Input, Modal, Select, Skeleton, Textarea, useToast } from "@/design-system";

import { PermissionMatrix } from "./permission-matrix";
import type { useRolesData } from "./roles-data";

type RolesData = ReturnType<typeof useRolesData>;

/** platform.admin is super-admin-only (D-025) and never offered to a Company Admin. */
function companyManageableGroups(
  groups: readonly PermissionCatalogGroup[],
): PermissionCatalogGroup[] {
  return groups.filter((group) => group.group !== "platform");
}

function diffPermissions(before: readonly string[], after: ReadonlySet<string>) {
  const beforeSet = new Set(before);
  const added = [...after].filter((key) => !beforeSet.has(key)).sort();
  const removed = before.filter((key) => !after.has(key)).sort();
  return { added, removed };
}

function PermissionDiff({ added, removed }: { added: string[]; removed: string[] }) {
  if (added.length === 0 && removed.length === 0) return null;
  return (
    <div className="grid gap-1.5">
      {added.map((key) => (
        <p className="font-mono text-caption text-status-successDeep dark:text-status-success" key={`added-${key}`}>
          + {key}
        </p>
      ))}
      {removed.map((key) => (
        <p
          className="font-mono text-caption text-statusStrong-critical dark:text-statusSoft-critical"
          key={`removed-${key}`}
        >
          − {key}
        </p>
      ))}
    </div>
  );
}

export function CreateRoleModal({
  createRole,
  onClose,
  onCreated,
  open,
  permissionGroups,
  roles,
}: {
  createRole: RolesData["createRole"];
  onClose: () => void;
  onCreated: () => void;
  open: boolean;
  permissionGroups: readonly PermissionCatalogGroup[];
  roles: readonly RoleSummary[];
}) {
  const toast = useToast();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [cloneFromRoleId, setCloneFromRoleId] = useState("");
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setName("");
      setDescription("");
      setCloneFromRoleId("");
      setSelected(new Set());
      setError(null);
    }
  }, [open]);

  const groups = useMemo(() => companyManageableGroups(permissionGroups), [permissionGroups]);
  const cloning = cloneFromRoleId !== "";

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    if (name.trim().length < 2) {
      setError("Enter a role name");
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      const created = await createRole({
        name: name.trim(),
        description: description.trim(),
        permissionKeys: cloning ? [] : [...selected],
        cloneFromRoleId: cloning ? cloneFromRoleId : undefined,
      });
      toast.success(`Created role "${created.name}"`);
      onCreated();
      onClose();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Modal onClose={onClose} open={open} title="Create role">
      <form className="grid gap-4" noValidate onSubmit={handleSubmit}>
        <Input label="Name" onChange={(event) => setName(event.target.value)} value={name} />
        <Textarea
          label="Description"
          onChange={(event) => setDescription(event.target.value)}
          value={description}
        />
        <Select
          hint="Clone an existing role's permissions as a starting point, or start blank."
          label="Clone from"
          onChange={(event) => setCloneFromRoleId(event.target.value)}
          value={cloneFromRoleId}
        >
          <option value="">Start blank</option>
          {roles.map((role) => (
            <option key={role.id} value={role.id}>
              {role.name}
            </option>
          ))}
        </Select>
        {!cloning && (
          <PermissionMatrix
            groups={groups}
            onToggle={(key, checked) =>
              setSelected((current) => {
                const next = new Set(current);
                if (checked) next.add(key);
                else next.delete(key);
                return next;
              })
            }
            selected={selected}
          />
        )}
        {error && (
          <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
            {error}
          </p>
        )}
        <div className="mt-2 flex justify-end gap-2">
          <Button onClick={onClose} type="button" variant="ghost">
            Cancel
          </Button>
          <Button loading={submitting} type="submit">
            Create role
          </Button>
        </div>
      </form>
    </Modal>
  );
}

export function RoleDetailModal({
  deleteRole,
  getRole,
  onChanged,
  onClose,
  permissionGroups,
  roleId,
  updateRole,
}: {
  deleteRole: RolesData["deleteRole"];
  getRole: RolesData["getRole"];
  onChanged: () => void;
  onClose: () => void;
  permissionGroups: readonly PermissionCatalogGroup[];
  roleId: string | null;
  updateRole: RolesData["updateRole"];
}) {
  const toast = useToast();
  const [status, setStatus] = useState<"loading" | "error" | "ready">("loading");
  const [detail, setDetail] = useState<RoleDetail | null>(null);
  const [editing, setEditing] = useState(false);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [confirmingSave, setConfirmingSave] = useState(false);
  const [confirmingDelete, setConfirmingDelete] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!roleId) return;
    let cancelled = false;
    setStatus("loading");
    setEditing(false);
    setConfirmingSave(false);
    setConfirmingDelete(false);
    setError(null);
    void getRole(roleId)
      .then((result) => {
        if (cancelled) return;
        setDetail(result);
        setName(result.name);
        setDescription(result.description);
        setSelected(new Set(result.permissionKeys));
        setStatus("ready");
      })
      .catch(() => {
        if (!cancelled) setStatus("error");
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [roleId]);

  if (!roleId) return null;
  const groups = companyManageableGroups(permissionGroups);
  const diff = detail ? diffPermissions(detail.permissionKeys, selected) : { added: [], removed: [] };
  const hasPermissionChanges = diff.added.length > 0 || diff.removed.length > 0;
  const hasChanges =
    detail !== null &&
    (name.trim() !== detail.name || description !== detail.description || hasPermissionChanges);

  async function persist() {
    if (!detail) return;
    setSaving(true);
    setError(null);
    try {
      const input: { name?: string; description?: string; permissionKeys?: string[] } = {};
      if (name.trim() !== detail.name) input.name = name.trim();
      if (description !== detail.description) input.description = description;
      if (hasPermissionChanges) input.permissionKeys = [...selected];
      const updated = await updateRole(detail.id, input);
      setDetail(updated);
      setSelected(new Set(updated.permissionKeys));
      setEditing(false);
      setConfirmingSave(false);
      toast.success("Role updated");
      onChanged();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
      setConfirmingSave(false);
    } finally {
      setSaving(false);
    }
  }

  function handleSaveClick() {
    if (detail && detail.assignedUserCount > 0 && hasPermissionChanges) {
      setConfirmingSave(true);
      return;
    }
    void persist();
  }

  async function handleDelete() {
    if (!detail) return;
    setSaving(true);
    setError(null);
    try {
      await deleteRole(detail.id);
      toast.success(`Deleted role "${detail.name}"`);
      onChanged();
      onClose();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
      setConfirmingDelete(false);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal onClose={onClose} open title={editing ? "Edit role" : "Role details"}>
      {status === "loading" && (
        <div className="grid gap-3">
          <Skeleton className="h-6 w-2/3" />
          <Skeleton className="h-4 w-1/2" />
          <Skeleton className="h-32 w-full" />
        </div>
      )}
      {status === "error" && (
        <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical">
          Couldn&apos;t load this role. Close and try again.
        </p>
      )}
      {status === "ready" && detail && !editing && (
        <div className="grid gap-4">
          <div>
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="text-h5 font-bold">{detail.name}</h3>
              <Badge>{detail.isSystem ? "System" : "Custom"}</Badge>
            </div>
            {detail.description && (
              <p className="mt-1 text-bodySmall text-text-secondary">{detail.description}</p>
            )}
          </div>
          <p className="text-caption text-text-muted">
            {detail.assignedUserCount} user{detail.assignedUserCount === 1 ? "" : "s"} assigned
          </p>
          <Card className="p-3">
            <p className="text-caption font-semibold uppercase tracking-[0.14em] text-text-muted">
              Permissions
            </p>
            <div className="mt-2 flex flex-wrap gap-1.5">
              {detail.permissionKeys.map((permission) => (
                <Badge className="font-mono text-micro" key={permission}>
                  {permission}
                </Badge>
              ))}
            </div>
          </Card>
          {detail.isSystem && (
            <p className="text-caption text-text-muted" role="status">
              System roles are read-only and cannot be renamed, re-permissioned, or deleted.
            </p>
          )}
          {error && (
            <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
              {error}
            </p>
          )}
          {!confirmingDelete ? (
            <div className="flex flex-wrap justify-end gap-2">
              {!detail.isSystem && (
                <Button
                  disabled={detail.assignedUserCount > 0}
                  onClick={() => setConfirmingDelete(true)}
                  title={
                    detail.assignedUserCount > 0
                      ? "Reassign every user on this role before deleting it"
                      : undefined
                  }
                  variant="danger"
                >
                  Delete
                </Button>
              )}
              {!detail.isSystem && (
                <Button onClick={() => setEditing(true)} variant="ghost">
                  Edit
                </Button>
              )}
            </div>
          ) : (
            <Card className="border-status-critical/40 p-3">
              <p className="text-bodySmall">
                This permanently removes the &quot;{detail.name}&quot; role. This cannot be undone.
              </p>
              <div className="mt-3 flex justify-end gap-2">
                <Button onClick={() => setConfirmingDelete(false)} variant="ghost">
                  Cancel
                </Button>
                <Button loading={saving} onClick={() => void handleDelete()} variant="danger">
                  Confirm delete
                </Button>
              </div>
            </Card>
          )}
          {!detail.isSystem && detail.assignedUserCount > 0 && (
            <Link
              className="text-caption text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
              href={`/users?roleId=${detail.id}`}
            >
              View assigned users
            </Link>
          )}
        </div>
      )}
      {status === "ready" && detail && editing && !confirmingSave && (
        <div className="grid gap-4">
          <Input label="Name" onChange={(event) => setName(event.target.value)} value={name} />
          <Textarea
            label="Description"
            onChange={(event) => setDescription(event.target.value)}
            value={description}
          />
          <PermissionMatrix
            groups={groups}
            onToggle={(key, checked) =>
              setSelected((current) => {
                const next = new Set(current);
                if (checked) next.add(key);
                else next.delete(key);
                return next;
              })
            }
            selected={selected}
          />
          {error && (
            <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
              {error}
            </p>
          )}
          <div className="flex justify-end gap-2">
            <Button onClick={() => setEditing(false)} variant="ghost">
              Cancel
            </Button>
            <Button disabled={!hasChanges} loading={saving} onClick={handleSaveClick}>
              Save
            </Button>
          </div>
        </div>
      )}
      {status === "ready" && detail && editing && confirmingSave && (
        <div className="grid gap-4">
          <Card className="border-status-warning/40 p-3">
            <p className="text-bodySmall font-semibold">
              {detail.assignedUserCount} user{detail.assignedUserCount === 1 ? "" : "s"} currently
              hold this role and will be affected immediately.
            </p>
            <div className="mt-3">
              <PermissionDiff added={diff.added} removed={diff.removed} />
            </div>
          </Card>
          {error && (
            <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
              {error}
            </p>
          )}
          <div className="flex justify-end gap-2">
            <Button onClick={() => setConfirmingSave(false)} variant="ghost">
              Cancel
            </Button>
            <Button loading={saving} onClick={() => void persist()}>
              Confirm save
            </Button>
          </div>
        </div>
      )}
    </Modal>
  );
}
