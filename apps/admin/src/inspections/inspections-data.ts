"use client";

import type { InspectionDetail, InspectionListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type InspectionFilters = {
  assetId: string | null;
  facilityId: string | null;
  status: string | null;
  inspectorId: string | null;
};

const PAGE_SIZE = 25;
const DEFAULT_FILTERS: InspectionFilters = {
  assetId: null,
  facilityId: null,
  status: null,
  inspectorId: null,
};

/** Fetches the company's inspections (paginated, filtered), mirroring the
 * 4.1/4.2 `useAssetsData` shape. `initialFilters` seeds state once on mount
 * (e.g. the asset-detail Inspections tab scoping the list to one asset). */
export function useInspectionsData(initialFilters: Partial<InspectionFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<InspectionFilters>({
    ...DEFAULT_FILTERS,
    ...initialFilters,
  });
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: InspectionListItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });

  const requestId = useRef(0);

  const fetchInspections = useCallback(
    async (current: InspectionFilters) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.listInspections({
          assetId: current.assetId ?? undefined,
          facilityId: current.facilityId ?? undefined,
          status: current.status ?? undefined,
          inspectorId: current.inspectorId ?? undefined,
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
      const page = await apiClient.listInspections({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        inspectorId: filters.inspectorId ?? undefined,
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

  useEffect(() => {
    void fetchInspections(filters);
  }, [fetchInspections, filters]);

  const retry = useCallback(() => void fetchInspections(filters), [fetchInspections, filters]);

  const setFilter = useCallback(
    <K extends keyof InspectionFilters>(key: K, value: InspectionFilters[K]) => {
      setFilters((current) => ({ ...current, [key]: value }));
    },
    [],
  );

  const clearFilters = useCallback(() => setFilters(DEFAULT_FILTERS), []);

  const getInspection = useCallback(
    (inspectionId: string): Promise<InspectionDetail> => apiClient.getInspection(inspectionId),
    [apiClient],
  );

  return { filters, setFilter, clearFilters, list, retry, loadMore, getInspection };
}
