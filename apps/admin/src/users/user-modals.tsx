"use client";

import type { RoleSummary, UserDetail } from "@fev/api-client";
import { useEffect, useState } from "react";

import { ApiClientError } from "@/api";
import { useAuth } from "@/auth/auth-context";
import { Badge, Button, Card, Input, Modal, Select, Skeleton, StatusPill, useToast } from "@/design-system";

import { useUsersData } from "./users-data";

type UsersData = ReturnType<typeof useUsersData>;

function RoleOptions({ roles }: { roles: readonly RoleSummary[] }) {
  return (
    <>
      {roles.map((role) => (
        <option key={role.id} value={role.id}>
          {role.name}
        </option>
      ))}
    </>
  );
}

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function InviteUserModal({
  onClose,
  onInvited,
  open,
  roles,
  users,
}: {
  onClose: () => void;
  onInvited: () => void;
  open: boolean;
  roles: readonly RoleSummary[];
  users: UsersData;
}) {
  const { sendUserInviteEmail } = useAuth();
  const toast = useToast();
  const [email, setEmail] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [roleId, setRoleId] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setEmail("");
      setDisplayName("");
      setRoleId(roles[0]?.id ?? "");
      setError(null);
    }
  }, [open, roles]);

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    if (!EMAIL_PATTERN.test(email.trim())) {
      setError("Enter a valid email address");
      return;
    }
    if (displayName.trim().length < 2) {
      setError("Enter the person's name");
      return;
    }
    if (!roleId) {
      setError("Choose a role");
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      const invited = await users.inviteUser({
        email: email.trim(),
        displayName: displayName.trim(),
        roleId,
      });
      const sent = await sendUserInviteEmail(invited.email);
      toast.success(
        sent
          ? `Invited ${invited.displayName} — they'll get an email to set their password and sign in.`
          : `${invited.displayName} was added, but the invite email couldn't be sent. They can use "Forgot password" to set one.`,
      );
      onInvited();
      onClose();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Modal onClose={onClose} open={open} title="Invite user">
      <form className="grid gap-4" noValidate onSubmit={handleSubmit}>
        <Input
          label="Email"
          onChange={(event) => setEmail(event.target.value)}
          type="email"
          value={email}
        />
        <Input
          label="Full name"
          onChange={(event) => setDisplayName(event.target.value)}
          value={displayName}
        />
        <Select
          label="Role"
          onChange={(event) => setRoleId(event.target.value)}
          value={roleId}
        >
          <option disabled value="">
            Choose a role
          </option>
          <RoleOptions roles={roles} />
        </Select>
        {error && (
          <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
            {error}
          </p>
        )}
        <p className="text-caption text-text-muted">
          They&apos;ll receive an email with a link to set their password. Once set, they can sign
          in immediately with the role you chose above.
        </p>
        <div className="mt-2 flex justify-end gap-2">
          <Button onClick={onClose} type="button" variant="ghost">
            Cancel
          </Button>
          <Button loading={submitting} type="submit">
            Send invite
          </Button>
        </div>
      </form>
    </Modal>
  );
}

export function UserDetailModal({
  getUser,
  onChanged,
  onClose,
  roles,
  setUserStatus,
  updateUser,
  userId,
}: {
  getUser: UsersData["getUser"];
  onChanged: () => void;
  onClose: () => void;
  roles: readonly RoleSummary[];
  setUserStatus: UsersData["setUserStatus"];
  updateUser: UsersData["updateUser"];
  userId: string | null;
}) {
  const { currentUser } = useAuth();
  const toast = useToast();
  const [status, setStatus] = useState<"loading" | "error" | "ready">("loading");
  const [detail, setDetail] = useState<UserDetail | null>(null);
  const [editing, setEditing] = useState(false);
  const [displayName, setDisplayName] = useState("");
  const [roleId, setRoleId] = useState("");
  const [saving, setSaving] = useState(false);
  const [confirmingStatus, setConfirmingStatus] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!userId) return;
    let cancelled = false;
    setStatus("loading");
    setEditing(false);
    setConfirmingStatus(false);
    setError(null);
    void getUser(userId)
      .then((result) => {
        if (cancelled) return;
        setDetail(result);
        setDisplayName(result.displayName);
        setRoleId(result.roleId);
        setStatus("ready");
      })
      .catch(() => {
        if (!cancelled) setStatus("error");
      });
    return () => {
      cancelled = true;
    };
    // getUser is a useCallback from useUsersData scoped to [apiClient], which
    // is stable for the AuthProvider's lifetime -- only userId should retrigger this.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [userId]);

  if (!userId) return null;
  const isSelf = currentUser?.uid === userId;

  async function saveChanges() {
    if (!detail) return;
    setSaving(true);
    setError(null);
    try {
      const input: { displayName?: string; roleId?: string } = {};
      if (displayName.trim() !== detail.displayName) input.displayName = displayName.trim();
      if (roleId !== detail.roleId) input.roleId = roleId;
      const updated = await updateUser(detail.id, input);
      setDetail(updated);
      setEditing(false);
      toast.success("User updated");
      onChanged();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSaving(false);
    }
  }

  async function toggleStatus() {
    if (!detail) return;
    const next = detail.status === "active" ? "inactive" : "active";
    setSaving(true);
    setError(null);
    try {
      const updated = await setUserStatus(detail.id, next);
      setDetail(updated);
      setConfirmingStatus(false);
      toast.success(next === "inactive" ? "User deactivated" : "User activated");
      onChanged();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal onClose={onClose} open title={editing ? "Edit user" : "User details"}>
      {status === "loading" && (
        <div className="grid gap-3">
          <Skeleton className="h-6 w-2/3" />
          <Skeleton className="h-4 w-1/2" />
          <Skeleton className="h-24 w-full" />
        </div>
      )}
      {status === "error" && (
        <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical">
          Couldn&apos;t load this user. Close and try again.
        </p>
      )}
      {status === "ready" && detail && !editing && (
        <div className="grid gap-4">
          <div>
            <h3 className="text-h5 font-bold">{detail.displayName}</h3>
            <p className="font-mono text-bodySmall text-text-muted">{detail.email}</p>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <Badge>{detail.roleName}</Badge>
            <StatusPill tone={detail.status === "active" ? "healthy" : "critical"}>
              {detail.status}
            </StatusPill>
          </div>
          <Card className="p-3">
            <p className="text-caption font-semibold uppercase tracking-[0.14em] text-text-muted">
              Effective permissions
            </p>
            <div className="mt-2 flex flex-wrap gap-1.5">
              {detail.permissions.map((permission) => (
                <Badge className="font-mono text-micro" key={permission}>
                  {permission}
                </Badge>
              ))}
            </div>
          </Card>
          {error && (
            <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
              {error}
            </p>
          )}
          {!confirmingStatus ? (
            <div className="flex flex-wrap justify-end gap-2">
              {isSelf && (
                <p className="mr-auto self-center text-caption text-text-muted">
                  You can&apos;t change your own role or status here.
                </p>
              )}
              <Button
                disabled={isSelf}
                onClick={() => setConfirmingStatus(true)}
                variant={detail.status === "active" ? "danger" : "primary"}
              >
                {detail.status === "active" ? "Deactivate" : "Activate"}
              </Button>
              <Button disabled={isSelf} onClick={() => setEditing(true)} variant="ghost">
                Edit
              </Button>
            </div>
          ) : (
            <Card className="border-status-critical/40 p-3">
              <p className="text-bodySmall">
                {detail.status === "active"
                  ? "This immediately blocks their sign-in. They can be reactivated later."
                  : "This restores their sign-in access with their current role."}
              </p>
              <div className="mt-3 flex justify-end gap-2">
                <Button onClick={() => setConfirmingStatus(false)} variant="ghost">
                  Cancel
                </Button>
                <Button
                  loading={saving}
                  onClick={() => void toggleStatus()}
                  variant={detail.status === "active" ? "danger" : "primary"}
                >
                  Confirm
                </Button>
              </div>
            </Card>
          )}
        </div>
      )}
      {status === "ready" && detail && editing && (
        <div className="grid gap-4">
          <Input
            label="Full name"
            onChange={(event) => setDisplayName(event.target.value)}
            value={displayName}
          />
          <Select label="Role" onChange={(event) => setRoleId(event.target.value)} value={roleId}>
            <RoleOptions roles={roles} />
          </Select>
          {error && (
            <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
              {error}
            </p>
          )}
          <div className="flex justify-end gap-2">
            <Button onClick={() => setEditing(false)} variant="ghost">
              Cancel
            </Button>
            <Button loading={saving} onClick={() => void saveChanges()}>
              Save
            </Button>
          </div>
        </div>
      )}
    </Modal>
  );
}
