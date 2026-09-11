"use client";

import type { RoleSummary, UserDetail, UserListItem } from "@fev/api-client";
import { useCallback, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type UserFilters = {
  search: string;
  roleId: string | null;
  status: string | null;
  sort: string;
};

const PAGE_SIZE = 25;
const DEFAULT_FILTERS: UserFilters = { search: "", roleId: null, status: null, sort: "name" };

export function useUsersData() {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<UserFilters>(DEFAULT_FILTERS);
  const [extraItems, setExtraItems] = useState<UserListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify(filters);

  const usersQuery = useCachedQuery<{ items: UserListItem[]; nextCursor?: string | null }>(
    `users:list:${filterKey}`,
    () =>
      apiClient.listUsers({
        search: filters.search.trim() || undefined,
        roleId: filters.roleId ?? undefined,
        status: filters.status ?? undefined,
        sort: filters.sort,
        limit: PAGE_SIZE,
      }),
  );

  const rolesQuery = useCachedQuery<{ items: RoleSummary[] }>(
    "roles:list",
    () => apiClient.listRoles(),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (usersQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listUsers({
        search: filters.search.trim() || undefined,
        roleId: filters.roleId ?? undefined,
        status: filters.status ?? undefined,
        sort: filters.sort,
        cursor,
        limit: PAGE_SIZE,
      });
      setExtraItems((prev) => [...prev, ...page.items]);
      setExtraNextCursor(page.nextCursor ?? null);
    } catch {
      // Toast handles error
    } finally {
      setLoadingMore(false);
    }
  }, [apiClient, filters, currentNextCursor, loadingMore]);

  const listStatus = usersQuery.loading ? "loading" : usersQuery.error ? "error" : "ready";
  const roleStatus = rolesQuery.loading ? "loading" : rolesQuery.error ? "error" : "ready";

  const allItems = [...(usersQuery.data?.items ?? []), ...extraItems];

  const resetPaging = useCallback(() => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
  }, []);

  return {
    filters,
    setSearch: (search: string) => {
      resetPaging();
      setFilters((current) => ({ ...current, search }));
    },
    setRoleFilter: (roleId: string | null) => {
      resetPaging();
      setFilters((current) => ({ ...current, roleId }));
    },
    setStatusFilter: (status: string | null) => {
      resetPaging();
      setFilters((current) => ({ ...current, status }));
    },
    setSort: (sort: string) => {
      resetPaging();
      setFilters((current) => ({ ...current, sort }));
    },
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retryUsers: usersQuery.refetch,
    loadMore,
    roles: {
      status: roleStatus,
      items: rolesQuery.data?.items ?? [],
    },
    retryRoles: rolesQuery.refetch,
    refresh: usersQuery.refetch,
    getUser: useCallback((userId: string) => apiClient.getUser(userId), [apiClient]),
    inviteUser: useCallback(
      (input: { email: string; displayName: string; roleId: string }): Promise<UserDetail> =>
        apiClient.inviteUser(input),
      [apiClient],
    ),
    updateUser: useCallback(
      (userId: string, input: { displayName?: string; roleId?: string }): Promise<UserDetail> =>
        apiClient.updateUser(userId, input),
      [apiClient],
    ),
    setUserStatus: useCallback(
      (userId: string, status: "active" | "inactive"): Promise<UserDetail> =>
        apiClient.setUserStatus(userId, { status }),
      [apiClient],
    ),
  };
}
