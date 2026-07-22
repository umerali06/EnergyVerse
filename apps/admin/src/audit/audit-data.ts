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
export function useAuditLogData() {
  const { apiClient, currentUser } = useAuth();
  const [filters, setFilters] = useState<AuditLogFilters>(defaultFilters);
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: AuditLogEntry[];
    nextCursor: string | null;
    loadingMore: boolean;
    truncated: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false, truncated: false });
  const [facets, setFacets] = useState<{
    status: AsyncStatus;
    actions: string[];
    targetTypes: string[];
  }>({ status: "loading", actions: [], targetTypes: [] });
  const [actors, setActors] = useState<{ status: AsyncStatus; items: UserListItem[] }>({
    status: "loading",
    items: [],
  });

  const requestId = useRef(0);
  const facetsRequestId = useRef(0);

  const fetchList = useCallback(
    async (current: AuditLogFilters) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false, truncated: false });
      try {
        const page = await apiClient.listAuditLogs({
          fromDate: current.fromDate || undefined,
          toDate: current.toDate || undefined,
          actorUid: current.actorUid ?? undefined,
          action: current.action ?? undefined,
          targetType: current.targetType ?? undefined,
          q: current.q.trim() || undefined,
          limit: PAGE_SIZE,
        });
        if (requestId.current === id) {
          setList({
            status: "ready",
            items: page.items,
            nextCursor: page.nextCursor ?? null,
            loadingMore: false,
            truncated: page.truncated,
          });
        }
      } catch {
        // FevApiClient already surfaced the unified-envelope toast; this
        // local state just drives the retry-capable error UI.
        if (requestId.current === id) {
          setList({ status: "error", items: [], nextCursor: null, loadingMore: false, truncated: false });
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
      setList((current) => ({
        status: "ready",
        items: [...current.items, ...page.items],
        nextCursor: page.nextCursor ?? null,
        loadingMore: false,
        truncated: current.truncated || page.truncated,
      }));
    } catch {
      setList((current) => ({ ...current, loadingMore: false }));
    }
  }, [apiClient, filters, list.loadingMore, list.nextCursor]);

  const fetchFacets = useCallback(
    async (fromDate: string, toDate: string) => {
      const id = ++facetsRequestId.current;
      setFacets({ status: "loading", actions: [], targetTypes: [] });
      try {
        const result = await apiClient.getAuditLogFacets({
          fromDate: fromDate || undefined,
          toDate: toDate || undefined,
        });
        if (facetsRequestId.current === id) {
          setFacets({ status: "ready", actions: result.actions, targetTypes: result.targetTypes });
        }
      } catch {
        if (facetsRequestId.current === id) setFacets({ status: "error", actions: [], targetTypes: [] });
      }
    },
    [apiClient],
  );

  const fetchActors = useCallback(async () => {
    setActors({ status: "loading", items: [] });
    try {
      const page = await apiClient.listUsers({ limit: ACTOR_DIRECTORY_LIMIT, sort: "name" });
      setActors({ status: "ready", items: page.items });
    } catch {
      setActors({ status: "error", items: [] });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchList(filters);
  }, [fetchList, filters]);

  useEffect(() => {
    void fetchFacets(filters.fromDate, filters.toDate);
  }, [fetchFacets, filters.fromDate, filters.toDate]);

  useEffect(() => {
    void fetchActors();
  }, [fetchActors]);

  const retry = useCallback(() => void fetchList(filters), [fetchList, filters]);

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

  const setFilter = useCallback(
    <K extends keyof AuditLogFilters>(key: K, value: AuditLogFilters[K]) => {
      setFilters((current) => ({ ...current, [key]: value }));
    },
    [],
  );

  const clearFilters = useCallback(() => {
    setFilters((current) => ({ ...defaultFilters(), fromDate: current.fromDate, toDate: current.toDate }));
  }, []);

  return {
    filters,
    setFilter,
    clearFilters,
    list,
    retry,
    loadMore,
    exportCsv,
    facets,
    actors,
    timeZone: currentUser?.companyTimezone,
    locale: currentUser?.companyLocale,
  };
}
