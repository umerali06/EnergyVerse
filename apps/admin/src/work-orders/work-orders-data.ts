"use client";

import type {
  AssetListItem,
  AssignWorkOrderRequest,
  CreateWorkOrderRequest,
  FacilityDetail,
  UserListItem,
  WorkOrderDetail,
  WorkOrderListItem,
} from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type WorkOrderFilters = {
  status: string | null;
  // The backend's list-work-orders endpoint has no `priority` query
  // parameter (see ListWorkOrdersRequest in the generated client) -- this is
  // applied client-side over whatever page is currently loaded, same spirit
  // as a search box rather than a server-backed filter.
  priority: string | null;
  assetId: string | null;
  facilityId: string | null;
  technicianId: string | null;
};

const PAGE_SIZE = 25;
const LOOKUP_LIMIT = 100;
const DEFAULT_FILTERS: WorkOrderFilters = {
  status: null,
  priority: null,
  assetId: null,
  facilityId: null,
  technicianId: null,
};

/**
 * Fetches the company's work orders (paginated, filtered) plus the asset,
 * facility, and technician directories used both as filter options and as
 * id -> name lookups for the list/detail views, mirroring the Phase 4.1
 * `useAssetsData` hook. `initialFilters` seeds filter state once on mount
 * (e.g. the asset-detail Work Orders tab scoping the list to one asset).
 */
import { useCachedQuery } from "@/cache/cache-context";

export function useWorkOrdersData(initialFilters: Partial<WorkOrderFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<WorkOrderFilters>({
    ...DEFAULT_FILTERS,
    ...initialFilters,
  });
  const [extraItems, setExtraItems] = useState<WorkOrderListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify({
    assetId: filters.assetId,
    facilityId: filters.facilityId,
    status: filters.status,
    technicianId: filters.technicianId,
  });

  const workOrdersQuery = useCachedQuery<{ items: WorkOrderListItem[]; nextCursor?: string | null }>(
    `work-orders:list:${filterKey}`,
    () =>
      apiClient.listWorkOrders({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        technicianId: filters.technicianId ?? undefined,
        limit: PAGE_SIZE,
      }),
  );

  const assetsQuery = useCachedQuery<{ items: AssetListItem[] }>(
    "assets:lookup:100",
    () => apiClient.listAssets({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const facilitiesQuery = useCachedQuery<{ items: FacilityDetail[] }>(
    "facilities:lookup:100",
    () => apiClient.listFacilities({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const techniciansQuery = useCachedQuery<{ items: UserListItem[] }>(
    "users:technicians:100",
    () => apiClient.listUsers({ limit: LOOKUP_LIMIT, sort: "name" }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (workOrdersQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listWorkOrders({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        technicianId: filters.technicianId ?? undefined,
        cursor,
        limit: PAGE_SIZE,
      });
      setExtraItems((prev) => [...prev, ...page.items]);
      setExtraNextCursor(page.nextCursor ?? null);
    } catch {
      // Handled by toast
    } finally {
      setLoadingMore(false);
    }
  }, [apiClient, filters, currentNextCursor, loadingMore]);

  const setFilter = useCallback(
    <K extends keyof WorkOrderFilters>(key: K, value: WorkOrderFilters[K]) => {
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

  const listStatus: AsyncStatus = workOrdersQuery.loading
    ? "loading"
    : workOrdersQuery.error
      ? "error"
      : "ready";
  const assetsStatus: AsyncStatus = assetsQuery.loading
    ? "loading"
    : assetsQuery.error
      ? "error"
      : "ready";
  const facilitiesStatus: AsyncStatus = facilitiesQuery.loading
    ? "loading"
    : facilitiesQuery.error
      ? "error"
      : "ready";
  const techniciansStatus: AsyncStatus = techniciansQuery.loading
    ? "loading"
    : techniciansQuery.error
      ? "error"
      : "ready";

  const allItems = [...(workOrdersQuery.data?.items ?? []), ...extraItems];

  const getWorkOrder = useCallback(
    (workOrderId: string): Promise<WorkOrderDetail> => apiClient.getWorkOrder(workOrderId),
    [apiClient],
  );

  const createWorkOrder = useCallback(
    (request: CreateWorkOrderRequest): Promise<WorkOrderDetail> =>
      apiClient.createWorkOrder(request),
    [apiClient],
  );

  const assignWorkOrder = useCallback(
    (workOrderId: string, request: AssignWorkOrderRequest): Promise<WorkOrderDetail> =>
      apiClient.assignWorkOrder(workOrderId, request),
    [apiClient],
  );

  const closeWorkOrder = useCallback(
    (workOrderId: string): Promise<WorkOrderDetail> => apiClient.closeWorkOrder(workOrderId),
    [apiClient],
  );

  const cancelWorkOrder = useCallback(
    (workOrderId: string): Promise<WorkOrderDetail> => apiClient.cancelWorkOrder(workOrderId),
    [apiClient],
  );

  const deleteWorkOrder = useCallback(
    (workOrderId: string) => apiClient.deleteWorkOrder(workOrderId),
    [apiClient],
  );

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
    retry: workOrdersQuery.refetch,
    loadMore,
    assets: {
      status: assetsStatus,
      items: assetsQuery.data?.items ?? [],
    },
    facilities: {
      status: facilitiesStatus,
      items: facilitiesQuery.data?.items ?? [],
    },
    technicians: {
      status: techniciansStatus,
      items: techniciansQuery.data?.items ?? [],
    },
    getWorkOrder,
    createWorkOrder,
    assignWorkOrder,
    closeWorkOrder,
    cancelWorkOrder,
    deleteWorkOrder,
  };
}

export function assetLabel(assets: AssetListItem[], assetId: string): string {
  const asset = assets.find((item) => item.id === assetId);
  return asset ? `${asset.name} (${asset.assetTag})` : assetId;
}

export function facilityName(facilities: FacilityDetail[], facilityId: string): string {
  return facilities.find((facility) => facility.id === facilityId)?.name ?? facilityId;
}

export function technicianName(
  technicians: UserListItem[],
  technicianId: string | null | undefined,
): string | null {
  if (!technicianId) return null;
  return technicians.find((user) => user.id === technicianId)?.displayName ?? technicianId;
}

/**
 * Users whose role suggests they're a field technician -- `UserListItem`
 * exposes `roleKey` cheaply (no extra fetch), so the assign-technician picker
 * narrows to `maintenance_technician` when at least one exists and falls back
 * to the full directory otherwise rather than showing an empty picker.
 */
export function technicianOptions(technicians: UserListItem[]): UserListItem[] {
  const matches = technicians.filter((user) => user.roleKey === "maintenance_technician");
  return matches.length > 0 ? matches : technicians;
}
