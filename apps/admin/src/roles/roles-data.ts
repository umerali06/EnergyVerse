"use client";

import type {
  CreateRoleRequest,
  PermissionCatalogGroup,
  RoleDetail,
  RoleSummary,
  UpdateRoleRequest,
} from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

/**
 * Fetches the company's role catalog and the global permission catalog
 * through the single FevApiClient instance AuthProvider owns, mirroring the
 * Phase 3.1 users data hook.
 */
export function useRolesData() {
  const { apiClient } = useAuth();
  const [roles, setRoles] = useState<{ status: AsyncStatus; items: RoleSummary[] }>({
    status: "loading",
    items: [],
  });
  const [catalog, setCatalog] = useState<{ status: AsyncStatus; groups: PermissionCatalogGroup[] }>(
    { status: "loading", groups: [] },
  );

  const fetchRoles = useCallback(async () => {
    setRoles((current) => ({ ...current, status: "loading" }));
    try {
      const page = await apiClient.listRoles();
      setRoles({ status: "ready", items: page.items });
    } catch {
      setRoles({ status: "error", items: [] });
    }
  }, [apiClient]);

  const fetchCatalog = useCallback(async () => {
    setCatalog((current) => ({ ...current, status: "loading" }));
    try {
      const result = await apiClient.listPermissionCatalog();
      setCatalog({ status: "ready", groups: result.groups });
    } catch {
      setCatalog({ status: "error", groups: [] });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchRoles();
  }, [fetchRoles]);

  useEffect(() => {
    void fetchCatalog();
  }, [fetchCatalog]);

  const getRole = useCallback((roleId: string): Promise<RoleDetail> => apiClient.getRole(roleId), [
    apiClient,
  ]);

  const createRole = useCallback(
    (input: CreateRoleRequest): Promise<RoleDetail> => apiClient.createRole(input),
    [apiClient],
  );

  const updateRole = useCallback(
    (roleId: string, input: UpdateRoleRequest): Promise<RoleDetail> =>
      apiClient.updateRole(roleId, input),
    [apiClient],
  );

  const deleteRole = useCallback((roleId: string) => apiClient.deleteRole(roleId), [apiClient]);

  return {
    roles,
    retryRoles: () => void fetchRoles(),
    refresh: () => void fetchRoles(),
    catalog,
    retryCatalog: () => void fetchCatalog(),
    getRole,
    createRole,
    updateRole,
    deleteRole,
  };
}
