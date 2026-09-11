"use client";

import type {
  AreaDetail,
  AssetDetail,
  AssetHistoryPage,
  AssetListItem,
  AssetQrLabel,
  FacilityDetail,
} from "@fev/api-client";
import { useCallback, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type AssetFilters = {
  search: string;
  facilityId: string | null;
  areaId: string | null;
  category: string | null;
  status: string | null;
  sort: string;
};

const PAGE_SIZE = 25;
const LOOKUP_LIMIT = 100;
const DEFAULT_FILTERS: AssetFilters = {
  search: "",
  facilityId: null,
  areaId: null,
  category: null,
  status: null,
  sort: "-created_at",
};

export function useAssetsData(initialFilters: Partial<AssetFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<AssetFilters>({ ...DEFAULT_FILTERS, ...initialFilters });
  const [extraItems, setExtraItems] = useState<AssetListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify(filters);

  const assetsQuery = useCachedQuery<{ items: AssetListItem[]; nextCursor?: string | null }>(
    `assets:list:${filterKey}`,
    () =>
      apiClient.listAssets({
        search: filters.search.trim() || undefined,
        facilityId: filters.facilityId ?? undefined,
        areaId: filters.areaId ?? undefined,
        category: filters.category ?? undefined,
        currentStatus: filters.status ?? undefined,
        sort: filters.sort,
        limit: PAGE_SIZE,
      }),
  );

  const facilitiesQuery = useCachedQuery<{ items: FacilityDetail[] }>(
    "facilities:lookup:100",
    () => apiClient.listFacilities({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const areasQuery = useCachedQuery<{ items: AreaDetail[] }>(
    "areas:lookup:100",
    () => apiClient.listAreas({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (assetsQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listAssets({
        search: filters.search.trim() || undefined,
        facilityId: filters.facilityId ?? undefined,
        areaId: filters.areaId ?? undefined,
        category: filters.category ?? undefined,
        currentStatus: filters.status ?? undefined,
        sort: filters.sort,
        cursor,
        limit: PAGE_SIZE,
      });
      setExtraItems((prev) => [...prev, ...page.items]);
      setExtraNextCursor(page.nextCursor ?? null);
    } catch {
      // Toast
    } finally {
      setLoadingMore(false);
    }
  }, [apiClient, filters, currentNextCursor, loadingMore]);

  const setFilter = useCallback(
    <K extends keyof AssetFilters>(key: K, value: AssetFilters[K]) => {
      setExtraItems([]);
      setExtraNextCursor(undefined);
      setFilters((current) => {
        const next = { ...current, [key]: value };
        if (key === "facilityId") next.areaId = null;
        return next;
      });
    },
    [],
  );

  const clearFilters = useCallback(() => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setFilters(DEFAULT_FILTERS);
  }, []);

  const listStatus = assetsQuery.loading ? "loading" : assetsQuery.error ? "error" : "ready";
  const facilityStatus = facilitiesQuery.loading ? "loading" : facilitiesQuery.error ? "error" : "ready";
  const areaStatus = areasQuery.loading ? "loading" : areasQuery.error ? "error" : "ready";

  const allItems = [...(assetsQuery.data?.items ?? []), ...extraItems];

  return {
    filters,
    setFilter,
    clearFilters,
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retry: assetsQuery.refetch,
    loadMore,
    facilities: {
      status: facilityStatus,
      items: facilitiesQuery.data?.items ?? [],
    },
    areas: {
      status: areaStatus,
      items: areasQuery.data?.items ?? [],
    },
    getAsset: useCallback((assetId: string) => apiClient.getAsset(assetId), [apiClient]),
    getAssetHistory: useCallback(
      (assetId: string) => apiClient.getAssetHistory(assetId),
      [apiClient],
    ),
    getChildAssets: useCallback(
      (parentAssetId: string) =>
        apiClient.listAssets({ parentAssetId, limit: LOOKUP_LIMIT }).then((page) => page.items),
      [apiClient],
    ),
    getAssetQrLabel: useCallback(
      (assetId: string) => apiClient.getAssetQrLabel(assetId),
      [apiClient],
    ),
  };
}

export function facilityName(facilities: FacilityDetail[], facilityId: string): string {
  return facilities.find((facility) => facility.id === facilityId)?.name ?? facilityId;
}

export function areaName(areas: AreaDetail[], areaId: string | null | undefined): string | null {
  if (!areaId) return null;
  return areas.find((area) => area.id === areaId)?.name ?? areaId;
}
