"use client";

import type {
  PlatformCompanyDetail,
  PlatformCompanySummary,
  PlatformStats,
  UpdatePlatformCompanyRequestSubscriptionTierEnum,
} from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

const PAGE_SIZE = 20;

/**
 * Fetches every tenant on the platform (cursor-paginated) plus platform-wide
 * stats through the single FevApiClient instance AuthProvider owns, mirroring
 * the Phase 3.1/3.4 data-fetching hooks. Only ever reachable by a
 * `platform.admin` caller -- gated at the route by RequirePermission.
 */
export function usePlatformCompaniesData() {
  const { apiClient } = useAuth();
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: PlatformCompanySummary[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });
  const [stats, setStats] = useState<{ status: AsyncStatus; value: PlatformStats | null }>({
    status: "loading",
    value: null,
  });

  const requestId = useRef(0);

  const fetchList = useCallback(async () => {
    const id = ++requestId.current;
    setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
    try {
      const page = await apiClient.listPlatformCompanies({ limit: PAGE_SIZE });
      if (requestId.current === id) {
        setList({
          status: "ready",
          items: page.items,
          nextCursor: page.nextCursor ?? null,
          loadingMore: false,
        });
      }
    } catch {
      if (requestId.current === id) {
        setList({ status: "error", items: [], nextCursor: null, loadingMore: false });
      }
    }
  }, [apiClient]);

  const loadMore = useCallback(async () => {
    const cursor = list.nextCursor;
    if (!cursor || list.loadingMore) return;
    setList((current) => ({ ...current, loadingMore: true }));
    try {
      const page = await apiClient.listPlatformCompanies({ cursor, limit: PAGE_SIZE });
      setList((current) => ({
        status: "ready",
        items: [...current.items, ...page.items],
        nextCursor: page.nextCursor ?? null,
        loadingMore: false,
      }));
    } catch {
      setList((current) => ({ ...current, loadingMore: false }));
    }
  }, [apiClient, list.loadingMore, list.nextCursor]);

  const fetchStats = useCallback(async () => {
    setStats({ status: "loading", value: null });
    try {
      const value = await apiClient.getPlatformStats();
      setStats({ status: "ready", value });
    } catch {
      setStats({ status: "error", value: null });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchList();
  }, [fetchList]);

  useEffect(() => {
    void fetchStats();
  }, [fetchStats]);

  const refresh = useCallback(() => {
    void fetchList();
    void fetchStats();
  }, [fetchList, fetchStats]);

  const getCompany = useCallback(
    (companyId: string): Promise<PlatformCompanyDetail> => apiClient.getPlatformCompany(companyId),
    [apiClient],
  );

  const setCompanyStatus = useCallback(
    (companyId: string, status: "active" | "suspended"): Promise<PlatformCompanyDetail> =>
      apiClient.updatePlatformCompanyStatus(companyId, { status }),
    [apiClient],
  );

  const setSubscriptionTier = useCallback(
    (
      companyId: string,
      subscriptionTier: UpdatePlatformCompanyRequestSubscriptionTierEnum,
    ): Promise<PlatformCompanyDetail> => apiClient.updatePlatformCompany(companyId, { subscriptionTier }),
    [apiClient],
  );

  return {
    list,
    retryList: fetchList,
    loadMore,
    stats,
    retryStats: fetchStats,
    refresh,
    getCompany,
    setCompanyStatus,
    setSubscriptionTier,
  };
}
