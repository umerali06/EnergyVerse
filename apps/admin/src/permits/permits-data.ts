"use client";

import type { FacilityDetail, PermitListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

const PAGE_SIZE = 25;

import { useCachedQuery } from "@/cache/cache-context";

export function usePermitsData() {
  const { apiClient } = useAuth();
  const [permitType, setPermitTypeState] = useState<string | null>(null);
  const [facilityId, setFacilityIdState] = useState<string | null>(null);
  const [extraItems, setExtraItems] = useState<PermitListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify({ permitType, facilityId });

  const permitsQuery = useCachedQuery<{ items: PermitListItem[]; nextCursor: string | null }>(
    `permits:list:${filterKey}`,
    () =>
      apiClient.listPermits({
        permitType: permitType ?? undefined,
        facilityId: facilityId ?? undefined,
        limit: PAGE_SIZE,
      }),
  );

  const facilitiesQuery = useCachedQuery<{ items: FacilityDetail[] }>(
    "facilities:lookup:100",
    () => apiClient.listFacilities({ limit: 100 }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (permitsQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listPermits({
        permitType: permitType ?? undefined,
        facilityId: facilityId ?? undefined,
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
  }, [apiClient, permitType, facilityId, currentNextCursor, loadingMore]);

  const setPermitType = useCallback((type: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setPermitTypeState(type);
  }, []);

  const setFacilityId = useCallback((fac: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setFacilityIdState(fac);
  }, []);

  const listStatus: "loading" | "error" | "ready" = permitsQuery.loading
    ? "loading"
    : permitsQuery.error
      ? "error"
      : "ready";

  const allItems = [...(permitsQuery.data?.items ?? []), ...extraItems];

  return {
    permitType,
    setPermitType,
    facilityId,
    setFacilityId,
    facilities: facilitiesQuery.data?.items ?? [],
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retry: permitsQuery.refetch,
    loadMore,
  };
}
