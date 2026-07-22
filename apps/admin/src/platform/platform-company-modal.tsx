"use client";

import {
  UpdatePlatformCompanyRequestSubscriptionTierEnum,
  type PlatformCompanyDetail,
} from "@fev/api-client";
import { useEffect, useState } from "react";

import {
  Badge,
  Button,
  ConfirmDialog,
  Modal,
  Select,
  Skeleton,
  StatusPill,
} from "@/design-system";

const TIER_OPTIONS = Object.values(UpdatePlatformCompanyRequestSubscriptionTierEnum);

function tierLabel(tier: string): string {
  return tier.charAt(0).toUpperCase() + tier.slice(1);
}

export function PlatformCompanyModal({
  companyId,
  getCompany,
  onChanged,
  onClose,
  setCompanyStatus,
  setSubscriptionTier,
}: {
  companyId: string | null;
  getCompany: (companyId: string) => Promise<PlatformCompanyDetail>;
  onChanged: () => void;
  onClose: () => void;
  setCompanyStatus: (
    companyId: string,
    status: "active" | "suspended",
  ) => Promise<PlatformCompanyDetail>;
  setSubscriptionTier: (
    companyId: string,
    tier: UpdatePlatformCompanyRequestSubscriptionTierEnum,
  ) => Promise<PlatformCompanyDetail>;
}) {
  const [status, setStatus] = useState<"loading" | "error" | "ready">("loading");
  const [detail, setDetail] = useState<PlatformCompanyDetail | null>(null);
  const [tier, setTier] = useState<UpdatePlatformCompanyRequestSubscriptionTierEnum>(
    UpdatePlatformCompanyRequestSubscriptionTierEnum.Demo,
  );
  const [savingTier, setSavingTier] = useState(false);
  const [confirmingSuspend, setConfirmingSuspend] = useState(false);
  const [savingStatus, setSavingStatus] = useState(false);

  useEffect(() => {
    if (!companyId) return;
    let cancelled = false;
    setStatus("loading");
    setConfirmingSuspend(false);
    void getCompany(companyId)
      .then((result) => {
        if (cancelled) return;
        setDetail(result);
        setTier(result.subscriptionTier as UpdatePlatformCompanyRequestSubscriptionTierEnum);
        setStatus("ready");
      })
      .catch(() => {
        if (!cancelled) setStatus("error");
      });
    return () => {
      cancelled = true;
    };
    // getCompany is a stable callback scoped to [apiClient] from
    // usePlatformCompaniesData -- only companyId should retrigger this.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId]);

  if (!companyId) return null;

  async function saveTier() {
    if (!detail) return;
    setSavingTier(true);
    try {
      const updated = await setSubscriptionTier(detail.id, tier);
      setDetail(updated);
      onChanged();
    } finally {
      setSavingTier(false);
    }
  }

  async function toggleStatus() {
    if (!detail) return;
    setSavingStatus(true);
    try {
      const nextStatus = detail.status === "active" ? "suspended" : "active";
      const updated = await setCompanyStatus(detail.id, nextStatus);
      setDetail(updated);
      setConfirmingSuspend(false);
      onChanged();
    } finally {
      setSavingStatus(false);
    }
  }

  return (
    <>
      <Modal onClose={onClose} open={Boolean(companyId) && !confirmingSuspend} title="Company">
      {status === "loading" && (
        <div className="grid gap-3">
          <Skeleton className="h-6 w-40" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </div>
      )}
      {status === "error" && (
        <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical">
          Couldn&apos;t load this company. Close and try again.
        </p>
      )}
      {status === "ready" && detail && (
        <div className="grid gap-4">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div>
              <h3 className="text-h4 font-bold">{detail.name}</h3>
              <p className="font-mono text-caption text-text-muted">{detail.id}</p>
            </div>
            <StatusPill tone={detail.status === "active" ? "healthy" : "critical"}>
              {detail.status}
            </StatusPill>
          </div>

          <dl className="grid grid-cols-2 gap-3 text-bodySmall">
            <div>
              <dt className="text-caption uppercase tracking-[0.1em] text-text-muted">Industry</dt>
              <dd>{detail.industry ?? "Not set"}</dd>
            </div>
            <div>
              <dt className="text-caption uppercase tracking-[0.1em] text-text-muted">
                Contact email
              </dt>
              <dd>{detail.contactEmail ?? "Not set"}</dd>
            </div>
            <div>
              <dt className="text-caption uppercase tracking-[0.1em] text-text-muted">Users</dt>
              <dd>
                <Badge>{detail.usersTotal}</Badge>
              </dd>
            </div>
            <div>
              <dt className="text-caption uppercase tracking-[0.1em] text-text-muted">Roles</dt>
              <dd>
                <Badge>{detail.rolesTotal}</Badge>
              </dd>
            </div>
          </dl>

          <div className="grid gap-2 border-t border-border pt-4">
            <Select
              label="Subscription tier"
              onChange={(event) =>
                setTier(event.target.value as UpdatePlatformCompanyRequestSubscriptionTierEnum)
              }
              value={tier}
            >
              {TIER_OPTIONS.map((option) => (
                <option key={option} value={option}>
                  {tierLabel(option)}
                </option>
              ))}
            </Select>
            <Button
              className="justify-self-start"
              disabled={tier === detail.subscriptionTier}
              loading={savingTier}
              onClick={() => void saveTier()}
              variant="ghost"
            >
              Save tier
            </Button>
          </div>

          <div className="flex justify-end gap-2 border-t border-border pt-4">
            <Button
              onClick={() => setConfirmingSuspend(true)}
              variant={detail.status === "active" ? "danger" : "primary"}
            >
              {detail.status === "active" ? "Suspend company" : "Reactivate company"}
            </Button>
          </div>
        </div>
      )}
      </Modal>

      {detail && (
        <ConfirmDialog
          confirmLabel={detail.status === "active" ? "Suspend" : "Reactivate"}
          consequence={
            detail.status === "active"
              ? `All ${detail.usersTotal} of this tenant's users immediately lose access. This action is audited to both this tenant's audit trail and the platform trail. The tenant can be reactivated later.`
              : "This restores sign-in access for every user in this tenant. This action is audited to both this tenant's audit trail and the platform trail."
          }
          loading={savingStatus}
          onCancel={() => setConfirmingSuspend(false)}
          onConfirm={() => void toggleStatus()}
          open={confirmingSuspend}
          title={detail.status === "active" ? "Suspend this company?" : "Reactivate this company?"}
          tone={detail.status === "active" ? "danger" : "primary"}
        />
      )}
    </>
  );
}
