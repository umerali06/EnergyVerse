"use client";

import type { DashboardActivityItem, DashboardSeriesPoint, DashboardSummary } from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";

export type ActivityWindowDays = 7 | 30 | 90;
export const activityWindows: readonly ActivityWindowDays[] = [7, 30, 90];

type AsyncStatus = "loading" | "error" | "ready";

const ACTIVITY_PAGE_SIZE = 20;

export function useDashboardData() {
  const { apiClient } = useAuth();
  const [window, setWindowState] = useState<ActivityWindowDays>(30);
  const [actionFilter, setActionFilterState] = useState<string | null>(null);
  const [extraActivityItems, setExtraActivityItems] = useState<DashboardActivityItem[]>([]);
  const [extraActivityNextCursor, setExtraActivityNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMoreActivity, setLoadingMoreActivity] = useState(false);

  const summaryQuery = useCachedQuery<DashboardSummary>(
    `dashboard:summary:${window}`,
    () => apiClient.getDashboardSummary(window),
  );

  const seriesQuery = useCachedQuery<{ windowDays: number; points: DashboardSeriesPoint[] }>(
    `dashboard:series:${window}`,
    () => apiClient.getDashboardActivitySeries(window),
  );

  const activityQuery = useCachedQuery<{ items: DashboardActivityItem[]; nextCursor: string | null }>(
    `dashboard:activity:${actionFilter ?? "all"}`,
    () =>
      apiClient.getDashboardActivity({
        limit: ACTIVITY_PAGE_SIZE,
        action: actionFilter ?? undefined,
      }),
  );

  const currentActivityNextCursor =
    extraActivityNextCursor !== undefined
      ? extraActivityNextCursor
      : (activityQuery.data?.nextCursor ?? null);

  const loadMoreActivity = useCallback(async () => {
    const cursor = currentActivityNextCursor;
    if (!cursor || loadingMoreActivity) return;
    setLoadingMoreActivity(true);
    try {
      const page = await apiClient.getDashboardActivity({
        limit: ACTIVITY_PAGE_SIZE,
        cursor,
        action: actionFilter ?? undefined,
      });
      setExtraActivityItems((prev) => [...prev, ...page.items]);
      setExtraActivityNextCursor(page.nextCursor ?? null);
    } catch {
      // Toast handles error
    } finally {
      setLoadingMoreActivity(false);
    }
  }, [apiClient, actionFilter, currentActivityNextCursor, loadingMoreActivity]);

  const setActionFilter = useCallback((filter: string | null) => {
    setExtraActivityItems([]);
    setExtraActivityNextCursor(undefined);
    setActionFilterState(filter);
  }, []);

  const summaryStatus: AsyncStatus = summaryQuery.loading
    ? "loading"
    : summaryQuery.error
      ? "error"
      : "ready";
  const seriesStatus: AsyncStatus = seriesQuery.loading
    ? "loading"
    : seriesQuery.error
      ? "error"
      : "ready";
  const activityStatus: AsyncStatus = activityQuery.loading
    ? "loading"
    : activityQuery.error
      ? "error"
      : "ready";

  const allActivityItems = [
    ...(activityQuery.data?.items ?? []),
    ...extraActivityItems,
  ];

  return {
    window,
    setWindow: setWindowState,
    summary: {
      status: summaryStatus,
      data: summaryQuery.data,
    },
    retrySummary: summaryQuery.refetch,
    series: {
      status: seriesStatus,
      points: seriesQuery.data?.points ?? [],
    },
    retrySeries: seriesQuery.refetch,
    activity: {
      status: activityStatus,
      items: allActivityItems,
      nextCursor: currentActivityNextCursor,
      loadingMore: loadingMoreActivity,
    },
    retryActivity: activityQuery.refetch,
    loadMoreActivity,
    actionFilter,
    setActionFilter,
  };
}
