"use client";

import type { RoleSummary, UserDetail, UserListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type UserFilters = {
  search: string;
  roleId: string | null;
  status: string | null;
  sort: string;
};

const PAGE_SIZE = 25;
const DEFAULT_FILTERS: UserFilters = { search: "", roleId: null, status: null, sort: "name" };

/**
 * Fetches the company's users (paginated, filtered, sorted) and its
 * assignable role catalog through the single FevApiClient instance
 * AuthProvider owns, mirroring the Phase 2.2 dashboard data hook.
 */
export function useUsersData() {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<UserFilters>(DEFAULT_FILTERS);
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: UserListItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });
  const [roles, setRoles] = useState<{ status: AsyncStatus; items: RoleSummary[] }>({
    status: "loading",
    items: [],
  });

  const requestId = useRef(0);

  const fetchUsers = useCallback(
    async (current: UserFilters) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.listUsers({
          search: current.search.trim() || undefined,
          roleId: current.roleId ?? undefined,
          status: current.status ?? undefined,
          sort: current.sort,
          limit: PAGE_SIZE,
        });
        if (requestId.current === id) {
          setList({
            status: "ready",
            items: page.items,
            nextCursor: page.nextCursor ?? null,
            loadingMore: false,
          });
        }
      } catch {
        // FevApiClient already surfaced the unified-envelope toast; this
        // local state just drives the retry-capable error UI.
        if (requestId.current === id) {
          setList({ status: "error", items: [], nextCursor: null, loadingMore: false });
        }
      }
    },
    [apiClient],
  );

  const loadMore = useCallback(async () => {
    const cursor = list.nextCursor;
    if (!cursor || list.loadingMore) return;
    setList((current) => ({ ...current, loadingMore: true }));
    try {
      const page = await apiClient.listUsers({
        search: filters.search.trim() || undefined,
        roleId: filters.roleId ?? undefined,
        status: filters.status ?? undefined,
        sort: filters.sort,
        cursor,
        limit: PAGE_SIZE,
      });
      setList((current) => ({
        status: "ready",
        items: [...current.items, ...page.items],
        nextCursor: page.nextCursor ?? null,
        loadingMore: false,
      }));
    } catch {
      setList((current) => ({ ...current, loadingMore: false }));
    }
  }, [apiClient, filters, list.loadingMore, list.nextCursor]);

  const fetchRoles = useCallback(async () => {
    setRoles({ status: "loading", items: [] });
    try {
      const page = await apiClient.listRoles();
      setRoles({ status: "ready", items: page.items });
    } catch {
      setRoles({ status: "error", items: [] });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchUsers(filters);
  }, [fetchUsers, filters]);

  useEffect(() => {
    void fetchRoles();
  }, [fetchRoles]);

  const refresh = useCallback(() => void fetchUsers(filters), [fetchUsers, filters]);

  const getUser = useCallback((userId: string) => apiClient.getUser(userId), [apiClient]);

  const inviteUser = useCallback(
    (input: { email: string; displayName: string; roleId: string }): Promise<UserDetail> =>
      apiClient.inviteUser(input),
    [apiClient],
  );

  const updateUser = useCallback(
    (userId: string, input: { displayName?: string; roleId?: string }): Promise<UserDetail> =>
      apiClient.updateUser(userId, input),
    [apiClient],
  );

  const setUserStatus = useCallback(
    (userId: string, status: "active" | "inactive"): Promise<UserDetail> =>
      apiClient.setUserStatus(userId, { status }),
    [apiClient],
  );

  return {
    filters,
    setSearch: (search: string) => setFilters((current) => ({ ...current, search })),
    setRoleFilter: (roleId: string | null) => setFilters((current) => ({ ...current, roleId })),
    setStatusFilter: (status: string | null) => setFilters((current) => ({ ...current, status })),
    setSort: (sort: string) => setFilters((current) => ({ ...current, sort })),
    list,
    retryUsers: refresh,
    loadMore,
    roles,
    retryRoles: () => void fetchRoles(),
    refresh,
    getUser,
    inviteUser,
    updateUser,
    setUserStatus,
  };
}
