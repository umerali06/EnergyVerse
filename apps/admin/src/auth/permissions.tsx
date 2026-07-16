"use client";

import { createContext, type ReactNode, useContext, useEffect, useMemo, useState } from "react";

import { ApiClientError, type FevApiClient, useOptionalApiClient } from "@/api";

type PermissionStatus = "loading" | "ready" | "unauthenticated" | "error";

type PermissionAccess = {
  can: (key: string) => boolean;
  hasAny: (keys: readonly string[]) => boolean;
  hasAll: (keys: readonly string[]) => boolean;
};

type PermissionContextValue = PermissionAccess & {
  permissions: ReadonlySet<string>;
  status: PermissionStatus;
};

export function createPermissionAccess(permissions: Iterable<string>): PermissionAccess {
  const permissionSet = new Set(permissions);
  return {
    can: (key) => permissionSet.has(key),
    hasAny: (keys) => keys.some((key) => permissionSet.has(key)),
    hasAll: (keys) => keys.every((key) => permissionSet.has(key)),
  };
}

const PermissionContext = createContext<PermissionContextValue | null>(null);

export function PermissionProvider({
  children,
  apiClient,
  initialPermissions,
}: {
  children: ReactNode;
  apiClient?: Pick<FevApiClient, "getCurrentUser">;
  initialPermissions?: readonly string[];
}) {
  const contextClient = useOptionalApiClient();
  const client = apiClient ?? contextClient;
  const seeded = initialPermissions !== undefined;
  const [permissions, setPermissions] = useState<ReadonlySet<string>>(
    () => new Set(initialPermissions ?? []),
  );
  const [status, setStatus] = useState<PermissionStatus>(seeded ? "ready" : "loading");

  useEffect(() => {
    if (seeded) return;
    if (client === null) {
      setPermissions(new Set());
      setStatus("error");
      return;
    }
    const activeClient = client;

    const controller = new AbortController();
    async function loadCurrentUser() {
      try {
        const currentUser = await activeClient.getCurrentUser(controller.signal);
        setPermissions(new Set(currentUser.permissions));
        setStatus("ready");
      } catch (error) {
        if (error instanceof ApiClientError && error.code === "request_cancelled") return;
        setPermissions(new Set());
        setStatus(
          error instanceof ApiClientError && error.status === 401 ? "unauthenticated" : "error",
        );
      }
    }

    void loadCurrentUser();
    return () => controller.abort();
  }, [client, seeded]);

  const value = useMemo<PermissionContextValue>(() => {
    const access = createPermissionAccess(permissions);
    return { permissions, status, ...access };
  }, [permissions, status]);

  return <PermissionContext.Provider value={value}>{children}</PermissionContext.Provider>;
}

export function usePermissions(): PermissionContextValue {
  const context = useContext(PermissionContext);
  if (context === null) {
    throw new Error("Permission hooks require PermissionProvider");
  }
  return context;
}

export function useCan(permission: string): boolean {
  return usePermissions().can(permission);
}

export function Can({
  permission,
  children,
  fallback = null,
}: {
  permission: string;
  children: ReactNode;
  fallback?: ReactNode;
}) {
  return useCan(permission) ? children : fallback;
}
