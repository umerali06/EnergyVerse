"use client";

import type { DashboardActivityItem, DashboardSeriesPoint, DashboardSummary } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type ActivityWindowDays = 7 | 30 | 90;
export const activityWindows: readonly ActivityWindowDays[] = [7, 30, 90];

type AsyncStatus = "loading" | "error" | "ready";

type AsyncSlice<T> = {
  status: AsyncStatus;
  data: T | null;
};

const ACTIVITY_PAGE_SIZE = 20;

/**
 * Fetches the three real dashboard endpoints (summary, activity-series,
 * paginated activity) through the single FevApiClient instance AuthProvider
 * owns — so token injection, 401 retry, and the unified error-envelope toast
 * all come for free. Never invents a number: every field here is either
 * `null` (not loaded / errored) or a value that came back from the API.
 */
export function useDashboardData() {
  const { apiClient } = useAuth();
  const [window, setWindowState] = useState<ActivityWindowDays>(30);
  const [summary, setSummary] = useState<AsyncSlice<DashboardSummary>>({
    status: "loading",
    data: null,
  });
  const [series, setSeries] = useState<AsyncSlice<DashboardSeriesPoint[]>>({
    status: "loading",
    data: null,
  });
  const [activity, setActivity] = useState<{
    status: AsyncStatus;
    items: DashboardActivityItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });
  const [actionFilter, setActionFilter] = useState<string | null>(null);

  const requestId = useRef(0);

  const fetchSummary = useCallback(
    async (forWindow: ActivityWindowDays) => {
      const id = ++requestId.current;
      setSummary({ status: "loading", data: null });
      try {
        const result = await apiClient.getDashboardSummary(forWindow);
        if (requestId.current === id) setSummary({ status: "ready", data: result });
      } catch {
        // FevApiClient already surfaced the unified-envelope toast; this
        // local state just drives the retry-capable error UI.
        if (requestId.current === id) setSummary({ status: "error", data: null });
      }
    },
    [apiClient],
  );

  const seriesRequestId = useRef(0);
  const fetchSeries = useCallback(
    async (forWindow: ActivityWindowDays) => {
      const id = ++seriesRequestId.current;
      setSeries({ status: "loading", data: null });
      try {
        const result = await apiClient.getDashboardActivitySeries(forWindow);
        if (seriesRequestId.current === id) {
          setSeries({ status: "ready", data: result.points });
        }
      } catch {
        if (seriesRequestId.current === id) setSeries({ status: "error", data: null });
      }
    },
    [apiClient],
  );

  const activityRequestId = useRef(0);
  const fetchActivity = useCallback(
    async (filter: string | null) => {
      const id = ++activityRequestId.current;
      setActivity({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.getDashboardActivity({
          limit: ACTIVITY_PAGE_SIZE,
          action: filter ?? undefined,
        });
        if (activityRequestId.current === id) {
          setActivity({
            status: "ready",
            items: page.items,
            nextCursor: page.nextCursor ?? null,
            loadingMore: false,
          });
        }
      } catch {
        if (activityRequestId.current === id) {
          setActivity({ status: "error", items: [], nextCursor: null, loadingMore: false });
        }
      }
    },
    [apiClient],
  );

  const loadMoreActivity = useCallback(async () => {
    setActivity((current) => {
      if (!current.nextCursor || current.loadingMore) return current;
      return { ...current, loadingMore: true };
    });
    const cursor = activity.nextCursor;
    if (!cursor) return;
    try {
      const page = await apiClient.getDashboardActivity({
        limit: ACTIVITY_PAGE_SIZE,
        cursor,
        action: actionFilter ?? undefined,
      });
      setActivity((current) => ({
        status: "ready",
        items: [...current.items, ...page.items],
        nextCursor: page.nextCursor ?? null,
        loadingMore: false,
      }));
    } catch {
      setActivity((current) => ({ ...current, loadingMore: false }));
    }
  }, [apiClient, activity.nextCursor, actionFilter]);

  useEffect(() => {
    void fetchSummary(window);
    void fetchSeries(window);
  }, [fetchSummary, fetchSeries, window]);

  useEffect(() => {
    void fetchActivity(actionFilter);
  }, [fetchActivity, actionFilter]);

  return {
    window,
    setWindow: setWindowState,
    summary,
    retrySummary: () => void fetchSummary(window),
    series: { status: series.status, points: series.data ?? [] },
    retrySeries: () => void fetchSeries(window),
    activity,
    retryActivity: () => void fetchActivity(actionFilter),
    loadMoreActivity,
    actionFilter,
    setActionFilter,
  };
}
