"use client";

import type { AuditLogEntry, UserListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

export type AuditLogFilters = {
  fromDate: string;
  toDate: string;
  actorUid: string | null;
  action: string | null;
  targetType: string | null;
  q: string;
};

const PAGE_SIZE = 20;
const DEFAULT_WINDOW_DAYS = 90;
const ACTOR_DIRECTORY_LIMIT = 100;

function isoDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}

function defaultFilters(): AuditLogFilters {
  const now = new Date();
  const start = new Date(now);
  start.setUTCDate(start.getUTCDate() - DEFAULT_WINDOW_DAYS);
  return {
    fromDate: isoDate(start),
    toDate: isoDate(now),
    actorUid: null,
    action: null,
    targetType: null,
    q: "",
  };
}

/**
 * Fetches the company's audit trail (date-bounded, filtered, cursor-paginated)
 * through the single FevApiClient instance AuthProvider owns, mirroring the
 * Phase 2.2 dashboard and 3.1 users data-fetching hooks.
 */
import { useCachedQuery } from "@/cache/cache-context";

export function useAuditLogData() {
  const { apiClient, currentUser } = useAuth();
  const [filters, setFilters] = useState<AuditLogFilters>(defaultFilters);
  const [extraItems, setExtraItems] = useState<AuditLogEntry[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify(filters);

  const auditLogsQuery = useCachedQuery<{ items: AuditLogEntry[]; nextCursor: string | null; truncated: boolean }>(
    `audit:list:${filterKey}`,
    () =>
      apiClient.listAuditLogs({
        fromDate: filters.fromDate || undefined,
        toDate: filters.toDate || undefined,
        actorUid: filters.actorUid ?? undefined,
        action: filters.action ?? undefined,
        targetType: filters.targetType ?? undefined,
        q: filters.q.trim() || undefined,
        limit: PAGE_SIZE,
      }),
  );

  const facetsQuery = useCachedQuery<{ actions: string[]; targetTypes: string[] }>(
    `audit:facets:${filters.fromDate}:${filters.toDate}`,
    () =>
      apiClient.getAuditLogFacets({
        fromDate: filters.fromDate || undefined,
        toDate: filters.toDate || undefined,
      }),
  );

  const actorsQuery = useCachedQuery<{ items: UserListItem[] }>(
    "users:actors:100",
    () => apiClient.listUsers({ limit: ACTOR_DIRECTORY_LIMIT, sort: "name" }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (auditLogsQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listAuditLogs({
        fromDate: filters.fromDate || undefined,
        toDate: filters.toDate || undefined,
        actorUid: filters.actorUid ?? undefined,
        action: filters.action ?? undefined,
        targetType: filters.targetType ?? undefined,
        q: filters.q.trim() || undefined,
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
    <K extends keyof AuditLogFilters>(key: K, value: AuditLogFilters[K]) => {
      setExtraItems([]);
      setExtraNextCursor(undefined);
      setFilters((current) => ({ ...current, [key]: value }));
    },
    [],
  );

  const clearFilters = useCallback(() => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setFilters((current) => ({ ...defaultFilters(), fromDate: current.fromDate, toDate: current.toDate }));
  }, []);

  const exportCsv = useCallback(
    () =>
      apiClient.exportAuditLogs({
        fromDate: filters.fromDate || undefined,
        toDate: filters.toDate || undefined,
        actorUid: filters.actorUid ?? undefined,
        action: filters.action ?? undefined,
        targetType: filters.targetType ?? undefined,
        q: filters.q.trim() || undefined,
      }),
    [apiClient, filters],
  );

  const listStatus: AsyncStatus = auditLogsQuery.loading
    ? "loading"
    : auditLogsQuery.error
      ? "error"
      : "ready";
  const facetsStatus: AsyncStatus = facetsQuery.loading
    ? "loading"
    : facetsQuery.error
      ? "error"
      : "ready";
  const actorsStatus: AsyncStatus = actorsQuery.loading
    ? "loading"
    : actorsQuery.error
      ? "error"
      : "ready";

  const allItems = [...(auditLogsQuery.data?.items ?? []), ...extraItems];

  return {
    filters,
    setFilter,
    clearFilters,
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
      truncated: auditLogsQuery.data?.truncated ?? false,
    },
    retry: auditLogsQuery.refetch,
    loadMore,
    exportCsv,
    facets: {
      status: facetsStatus,
      actions: facetsQuery.data?.actions ?? [],
      targetTypes: facetsQuery.data?.targetTypes ?? [],
    },
    actors: {
      status: actorsStatus,
      items: actorsQuery.data?.items ?? [],
    },
    timeZone: currentUser?.companyTimezone,
    locale: currentUser?.companyLocale,
  };
}
