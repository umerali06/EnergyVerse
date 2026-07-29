"use client";

import type {
  AreaDetail,
  AssetDetail,
  AssetHistoryPage,
  AssetListItem,
  AssetQrLabel,
  FacilityDetail,
} from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

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

/**
 * Fetches the company's assets (paginated, filtered, sorted) plus a one-shot
 * facility/area directory used both as filter options and as an id -> name
 * lookup for the list/detail breadcrumb (the asset payloads only carry
 * facilityId/areaId, never names), mirroring the Phase 3.1 users data hook
 * and the Phase 3.4 audit facets/actor-directory pattern.
 *
 * `initialFilters` seeds the filter state once on mount (e.g. a dashboard KPI
 * card linking to `/assets?status=Critical`) -- it is read once, not kept in
 * sync with the URL afterward.
 */
export function useAssetsData(initialFilters: Partial<AssetFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<AssetFilters>({ ...DEFAULT_FILTERS, ...initialFilters });
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: AssetListItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });
  const [facilities, setFacilities] = useState<{ status: AsyncStatus; items: FacilityDetail[] }>({
    status: "loading",
    items: [],
  });
  const [areas, setAreas] = useState<{ status: AsyncStatus; items: AreaDetail[] }>({
    status: "loading",
    items: [],
  });

  const requestId = useRef(0);

  const fetchAssets = useCallback(
    async (current: AssetFilters) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.listAssets({
          search: current.search.trim() || undefined,
          facilityId: current.facilityId ?? undefined,
          areaId: current.areaId ?? undefined,
          category: current.category ?? undefined,
          currentStatus: current.status ?? undefined,
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

  const fetchFacilities = useCallback(async () => {
    setFacilities({ status: "loading", items: [] });
    try {
      const page = await apiClient.listFacilities({ limit: LOOKUP_LIMIT, sort: "name" });
      setFacilities({ status: "ready", items: page.items });
    } catch {
      setFacilities({ status: "error", items: [] });
    }
  }, [apiClient]);

  const fetchAreas = useCallback(async () => {
    setAreas({ status: "loading", items: [] });
    try {
      const page = await apiClient.listAreas({ limit: LOOKUP_LIMIT, sort: "name" });
      setAreas({ status: "ready", items: page.items });
    } catch {
      setAreas({ status: "error", items: [] });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchAssets(filters);
  }, [fetchAssets, filters]);

  useEffect(() => {
    void fetchFacilities();
  }, [fetchFacilities]);

  useEffect(() => {
    void fetchAreas();
  }, [fetchAreas]);

  const retry = useCallback(() => void fetchAssets(filters), [fetchAssets, filters]);

  const setFilter = useCallback(
    <K extends keyof AssetFilters>(key: K, value: AssetFilters[K]) => {
      setFilters((current) => {
        const next = { ...current, [key]: value };
        // Changing facility invalidates any previously selected area.
        if (key === "facilityId") next.areaId = null;
        return next;
      });
    },
    [],
  );

  const clearFilters = useCallback(() => setFilters(DEFAULT_FILTERS), []);

  const getAsset = useCallback(
    (assetId: string): Promise<AssetDetail> => apiClient.getAsset(assetId),
    [apiClient],
  );

  const getAssetHistory = useCallback(
    (assetId: string): Promise<AssetHistoryPage> => apiClient.getAssetHistory(assetId),
    [apiClient],
  );

  const getChildAssets = useCallback(
    (parentAssetId: string): Promise<AssetListItem[]> =>
      apiClient.listAssets({ parentAssetId, limit: LOOKUP_LIMIT }).then((page) => page.items),
    [apiClient],
  );

  const getAssetQrLabel = useCallback(
    (assetId: string): Promise<AssetQrLabel> => apiClient.getAssetQrLabel(assetId),
    [apiClient],
  );

  return {
    filters,
    setFilter,
    clearFilters,
    list,
    retry,
    loadMore,
    facilities,
    areas,
    getAsset,
    getAssetHistory,
    getChildAssets,
    getAssetQrLabel,
  };
}

export function facilityName(facilities: FacilityDetail[], facilityId: string): string {
  return facilities.find((facility) => facility.id === facilityId)?.name ?? facilityId;
}

export function areaName(areas: AreaDetail[], areaId: string | null | undefined): string | null {
  if (!areaId) return null;
  return areas.find((area) => area.id === areaId)?.name ?? areaId;
}
