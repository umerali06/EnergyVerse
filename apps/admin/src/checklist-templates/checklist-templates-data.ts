"use client";

import type { ChecklistTemplateListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

const PAGE_SIZE = 25;

/** Fetches the company's checklist templates (paginated, filterable by
 * category), mirroring the 4.1/4.2 `useAssetsData` shape. */
import { useCachedQuery } from "@/cache/cache-context";

export function useChecklistTemplatesData() {
  const { apiClient } = useAuth();
  const [category, setCategoryState] = useState<string | null>(null);
  const [extraItems, setExtraItems] = useState<ChecklistTemplateListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify({ category });

  const templatesQuery = useCachedQuery<{ items: ChecklistTemplateListItem[]; nextCursor: string | null }>(
    `checklist-templates:list:${filterKey}`,
    () =>
      apiClient.listChecklistTemplates({
        category: category ?? undefined,
        limit: PAGE_SIZE,
      }),
  );

  const currentNextCursor =
    extraNextCursor !== undefined
      ? extraNextCursor
      : (templatesQuery.data?.nextCursor ?? null);

  const loadMore = useCallback(async () => {
    const cursor = currentNextCursor;
    if (!cursor || loadingMore) return;
    setLoadingMore(true);
    try {
      const page = await apiClient.listChecklistTemplates({
        category: category ?? undefined,
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
  }, [apiClient, category, currentNextCursor, loadingMore]);

  const setCategory = useCallback((cat: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setCategoryState(cat);
  }, []);

  const listStatus: AsyncStatus = templatesQuery.loading
    ? "loading"
    : templatesQuery.error
      ? "error"
      : "ready";

  const allItems = [...(templatesQuery.data?.items ?? []), ...extraItems];

  return {
    category,
    setCategory,
    list: {
      status: listStatus,
      items: allItems,
      nextCursor: currentNextCursor,
      loadingMore,
    },
    retry: templatesQuery.refetch,
    loadMore,
  };
}
