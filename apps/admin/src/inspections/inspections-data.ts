"use client";

import type { InspectionDetail, InspectionListItem, UserListItem } from "@fev/api-client";
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
const LOOKUP_LIMIT = 100;
const DEFAULT_FILTERS: InspectionFilters = {
  assetId: null,
  facilityId: null,
  status: null,
  inspectorId: null,
};

/** Fetches the company's inspections (paginated, filtered), mirroring the
 * 4.1/4.2 `useAssetsData` shape. `initialFilters` seeds state once on mount
 * (e.g. the asset-detail Inspections tab scoping the list to one asset). */
import { useCachedQuery } from "@/cache/cache-context";

/**
 * Inspections carry only an `inspectorId`; a reviewer needs the person's name.
 * Falls back to the raw identifier so a user outside the fetched page (or a
 * deactivated account) still renders something traceable rather than blank.
 */
export function inspectorName(
  users: readonly UserListItem[],
  inspectorId: string | null | undefined,
): string | null {
  if (!inspectorId) return null;
  return users.find((user) => user.id === inspectorId)?.displayName ?? inspectorId;
}

export function useInspectionsData(initialFilters: Partial<InspectionFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<InspectionFilters>({
    ...DEFAULT_FILTERS,
    ...initialFilters,
  });
  const [extraItems, setExtraItems] = useState<InspectionListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify(filters);

  const inspectionsQuery = useCachedQuery<{ items: InspectionListItem[]; nextCursor?: string | null }>(
    `inspections:list:${filterKey}`,
    () =>
      apiClient.listInspections({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        inspectorId: filters.inspectorId ?? undefined,
        limit: PAGE_SIZE,
      }),
  );

  const usersQuery = useCachedQuery<{ items: UserListItem[] }>(
    "users:directory:100",
    () => apiClient.listUsers({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (inspectionsQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listInspections({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        inspectorId: filters.inspectorId ?? undefined,
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

  const setFilter = useCallback(
    <K extends keyof InspectionFilters>(key: K, value: InspectionFilters[K]) => {
      setExtraItems([]);
      setExtraNextCursor(undefined);
      setFilters((current) => ({ ...current, [key]: value }));
    },
    [],
  );

  const clearFilters = useCallback(() => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setFilters(DEFAULT_FILTERS);
  }, []);

  const getInspection = useCallback(
    (inspectionId: string): Promise<InspectionDetail> => apiClient.getInspection(inspectionId),
    [apiClient],
  );

  const listStatus: AsyncStatus = inspectionsQuery.loading
    ? "loading"
    : inspectionsQuery.error
      ? "error"
      : "ready";

  const allItems = [...(inspectionsQuery.data?.items ?? []), ...extraItems];

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
    users: { items: usersQuery.data?.items ?? [] },
    retry: inspectionsQuery.refetch,
    loadMore,
    getInspection,
  };
}
