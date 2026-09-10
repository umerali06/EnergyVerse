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
import { useCachedQuery } from "@/cache/cache-context";

export function useRolesData() {
  const { apiClient } = useAuth();

  const rolesQuery = useCachedQuery<{ items: RoleSummary[] }>(
    "roles:list",
    () => apiClient.listRoles(),
  );

  const catalogQuery = useCachedQuery<{ groups: PermissionCatalogGroup[] }>(
    "permission-catalog:list",
    () => apiClient.listPermissionCatalog(),
  );

  const rolesStatus: AsyncStatus = rolesQuery.loading
    ? "loading"
    : rolesQuery.error
      ? "error"
      : "ready";
  const catalogStatus: AsyncStatus = catalogQuery.loading
    ? "loading"
    : catalogQuery.error
      ? "error"
      : "ready";

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
    roles: {
      status: rolesStatus,
      items: rolesQuery.data?.items ?? [],
    },
    retryRoles: rolesQuery.refetch,
    refresh: rolesQuery.refetch,
    catalog: {
      status: catalogStatus,
      groups: catalogQuery.data?.groups ?? [],
    },
    retryCatalog: catalogQuery.refetch,
    getRole,
    createRole,
    updateRole,
    deleteRole,
  };
}
