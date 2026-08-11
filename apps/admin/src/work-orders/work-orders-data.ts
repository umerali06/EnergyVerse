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
export function useWorkOrdersData(initialFilters: Partial<WorkOrderFilters> = {}) {
  const { apiClient } = useAuth();
  const [filters, setFilters] = useState<WorkOrderFilters>({
    ...DEFAULT_FILTERS,
    ...initialFilters,
  });
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: WorkOrderListItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });
  const [assets, setAssets] = useState<{ status: AsyncStatus; items: AssetListItem[] }>({
    status: "loading",
    items: [],
  });
  const [facilities, setFacilities] = useState<{ status: AsyncStatus; items: FacilityDetail[] }>({
    status: "loading",
    items: [],
  });
  const [technicians, setTechnicians] = useState<{ status: AsyncStatus; items: UserListItem[] }>({
    status: "loading",
    items: [],
  });

  const requestId = useRef(0);

  const fetchWorkOrders = useCallback(
    async (current: WorkOrderFilters) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.listWorkOrders({
          assetId: current.assetId ?? undefined,
          facilityId: current.facilityId ?? undefined,
          status: current.status ?? undefined,
          technicianId: current.technicianId ?? undefined,
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
      const page = await apiClient.listWorkOrders({
        assetId: filters.assetId ?? undefined,
        facilityId: filters.facilityId ?? undefined,
        status: filters.status ?? undefined,
        technicianId: filters.technicianId ?? undefined,
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

  const fetchAssets = useCallback(async () => {
    setAssets({ status: "loading", items: [] });
    try {
      const page = await apiClient.listAssets({ limit: LOOKUP_LIMIT, sort: "name" });
      setAssets({ status: "ready", items: page.items });
    } catch {
      setAssets({ status: "error", items: [] });
    }
  }, [apiClient]);

  const fetchFacilities = useCallback(async () => {
    setFacilities({ status: "loading", items: [] });
    try {
      const page = await apiClient.listFacilities({ limit: LOOKUP_LIMIT, sort: "name" });
      setFacilities({ status: "ready", items: page.items });
    } catch {
      setFacilities({ status: "error", items: [] });
    }
  }, [apiClient]);

  const fetchTechnicians = useCallback(async () => {
    setTechnicians({ status: "loading", items: [] });
    try {
      const page = await apiClient.listUsers({ limit: LOOKUP_LIMIT, sort: "name" });
      setTechnicians({ status: "ready", items: page.items });
    } catch {
      setTechnicians({ status: "error", items: [] });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchWorkOrders(filters);
    // `filters.priority` deliberately excluded: it has no server-side query
    // param (see the type above), so toggling it must not trigger a
    // redundant network request -- work-orders-page.tsx applies it as a
    // client-side filter over whatever page is already loaded.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fetchWorkOrders, filters.status, filters.assetId, filters.facilityId, filters.technicianId]);

  useEffect(() => {
    void fetchAssets();
  }, [fetchAssets]);

  useEffect(() => {
    void fetchFacilities();
  }, [fetchFacilities]);

  useEffect(() => {
    void fetchTechnicians();
  }, [fetchTechnicians]);

  const retry = useCallback(() => void fetchWorkOrders(filters), [fetchWorkOrders, filters]);

  const setFilter = useCallback(
    <K extends keyof WorkOrderFilters>(key: K, value: WorkOrderFilters[K]) => {
      setFilters((current) => ({ ...current, [key]: value }));
    },
    [],
  );

  const clearFilters = useCallback(() => setFilters(DEFAULT_FILTERS), []);

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
    list,
    retry,
    loadMore,
    assets,
    facilities,
    technicians,
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
