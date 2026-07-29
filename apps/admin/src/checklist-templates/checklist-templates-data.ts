"use client";

import type { ChecklistTemplateListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

const PAGE_SIZE = 25;

/** Fetches the company's checklist templates (paginated, filterable by
 * category), mirroring the 4.1/4.2 `useAssetsData` shape. */
export function useChecklistTemplatesData() {
  const { apiClient } = useAuth();
  const [category, setCategory] = useState<string | null>(null);
  const [list, setList] = useState<{
    status: AsyncStatus;
    items: ChecklistTemplateListItem[];
    nextCursor: string | null;
    loadingMore: boolean;
  }>({ status: "loading", items: [], nextCursor: null, loadingMore: false });

  const requestId = useRef(0);

  const fetchTemplates = useCallback(
    async (currentCategory: string | null) => {
      const id = ++requestId.current;
      setList({ status: "loading", items: [], nextCursor: null, loadingMore: false });
      try {
        const page = await apiClient.listChecklistTemplates({
          category: currentCategory ?? undefined,
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
      const page = await apiClient.listChecklistTemplates({
        category: category ?? undefined,
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
  }, [apiClient, category, list.loadingMore, list.nextCursor]);

  useEffect(() => {
    void fetchTemplates(category);
  }, [fetchTemplates, category]);

  const retry = useCallback(() => void fetchTemplates(category), [fetchTemplates, category]);

  return { category, setCategory, list, retry, loadMore };
}
