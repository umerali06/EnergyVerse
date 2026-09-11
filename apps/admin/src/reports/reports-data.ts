"use client";

import type { GeneratedReportListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

const PAGE_SIZE = 25;

import { useCachedQuery } from "@/cache/cache-context";

export function useReportsData() {
  const { apiClient } = useAuth();
  const [reportType, setReportTypeState] = useState<string | null>(null);
  const [status, setStatusState] = useState<string | null>(null);
  const [extraItems, setExtraItems] = useState<GeneratedReportListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify({ reportType, status });

  const reportsQuery = useCachedQuery<{ items: GeneratedReportListItem[]; nextCursor?: string | null }>(
    `reports:list:${filterKey}`,
    () =>
      apiClient.listGeneratedReports({
        reportType: reportType ?? undefined,
        status: status ?? undefined,
        limit: PAGE_SIZE,
      }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (reportsQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listGeneratedReports({
        reportType: reportType ?? undefined,
        status: status ?? undefined,
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
  }, [apiClient, reportType, status, currentNextCursor, loadingMore]);

  const setReportType = useCallback((type: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setReportTypeState(type);
  }, []);

  const setStatus = useCallback((st: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setStatusState(st);
  }, []);

  const listStatus: "loading" | "error" | "ready" = reportsQuery.loading
    ? "loading"
    : reportsQuery.error
      ? "error"
      : "ready";

  const allItems = [...(reportsQuery.data?.items ?? []), ...extraItems];

  return {
    reportType,
    setReportType,
    status,
    setStatus,
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retry: reportsQuery.refetch,
    loadMore,
  };
}
