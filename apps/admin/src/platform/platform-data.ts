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
import { useCachedQuery } from "@/cache/cache-context";

export function usePlatformCompaniesData() {
  const { apiClient } = useAuth();
  const [extraItems, setExtraItems] = useState<PlatformCompanySummary[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const companiesQuery = useCachedQuery<{ items: PlatformCompanySummary[]; nextCursor: string | null }>(
    "platform:companies:list",
    () => apiClient.listPlatformCompanies({ limit: PAGE_SIZE }),
  );

  const statsQuery = useCachedQuery<PlatformStats>(
    "platform:stats",
    () => apiClient.getPlatformStats(),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (companiesQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listPlatformCompanies({ cursor, limit: PAGE_SIZE });
      setExtraItems((prev) => [...prev, ...page.items]);
      setExtraNextCursor(page.nextCursor ?? null);
    } catch {
      // Toast handles error
    } finally {
      setLoadingMore(false);
    }
  }, [apiClient, currentNextCursor, loadingMore]);

  const refresh = useCallback(() => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    void companiesQuery.refetch();
    void statsQuery.refetch();
  }, [companiesQuery, statsQuery]);

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

  const listStatus: AsyncStatus = companiesQuery.loading
    ? "loading"
    : companiesQuery.error
      ? "error"
      : "ready";
  const statsStatus: AsyncStatus = statsQuery.loading
    ? "loading"
    : statsQuery.error
      ? "error"
      : "ready";

  const allItems = [...(companiesQuery.data?.items ?? []), ...extraItems];

  return {
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retryList: companiesQuery.refetch,
    loadMore,
    stats: {
      status: statsStatus,
      value: statsQuery.data,
    },
    retryStats: statsQuery.refetch,
    refresh,
    getCompany,
    setCompanyStatus,
    setSubscriptionTier,
  };
}
