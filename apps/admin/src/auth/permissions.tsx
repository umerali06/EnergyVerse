"use client";

import { createContext, type ReactNode, useContext, useEffect, useMemo, useState } from "react";

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

type CurrentUserResponse = {
  permissions: string[];
};

const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

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
  accessToken,
  initialPermissions,
}: {
  children: ReactNode;
  accessToken?: string;
  initialPermissions?: readonly string[];
}) {
  const seeded = initialPermissions !== undefined;
  const [permissions, setPermissions] = useState<ReadonlySet<string>>(
    () => new Set(initialPermissions ?? []),
  );
  const [status, setStatus] = useState<PermissionStatus>(seeded ? "ready" : "loading");

  useEffect(() => {
    if (seeded) return;

    const controller = new AbortController();
    async function loadCurrentUser() {
      try {
        const headers: HeadersInit = accessToken ? { Authorization: `Bearer ${accessToken}` } : {};
        const response = await fetch(`${apiBaseUrl.replace(/\/$/, "")}/api/v1/auth/me`, {
          cache: "no-store",
          headers,
          signal: controller.signal,
        });
        if (response.status === 401) {
          setPermissions(new Set());
          setStatus("unauthenticated");
          return;
        }
        if (!response.ok) {
          throw new Error(`/me returned HTTP ${response.status}`);
        }
        const currentUser = (await response.json()) as CurrentUserResponse;
        if (!Array.isArray(currentUser.permissions)) {
          throw new Error("/me returned invalid permissions");
        }
        setPermissions(new Set(currentUser.permissions));
        setStatus("ready");
      } catch (error) {
        if (!(error instanceof DOMException && error.name === "AbortError")) {
          setPermissions(new Set());
          setStatus("error");
        }
      }
    }

    void loadCurrentUser();
    return () => controller.abort();
  }, [accessToken, seeded]);

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
