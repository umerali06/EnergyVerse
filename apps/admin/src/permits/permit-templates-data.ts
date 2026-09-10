"use client";

import type { PermitTemplateListItem } from "@fev/api-client";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";

const PAGE_SIZE = 25;

import { useCachedQuery } from "@/cache/cache-context";

export function usePermitTemplatesData() {
  const { apiClient } = useAuth();
  const [permitType, setPermitTypeState] = useState<string | null>(null);
  const [extraItems, setExtraItems] = useState<PermitTemplateListItem[]>([]);
  const [extraNextCursor, setExtraNextCursor] = useState<string | null | undefined>(undefined);
  const [loadingMore, setLoadingMore] = useState(false);

  const filterKey = JSON.stringify({ permitType });

  const templatesQuery = useCachedQuery<{ items: PermitTemplateListItem[]; nextCursor?: string | null }>(
    `permit-templates:list:${filterKey}`,
    () =>
      apiClient.listPermitTemplates({
        permitType: permitType ?? undefined,
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
      const page = await apiClient.listPermitTemplates({
        permitType: permitType ?? undefined,
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
  }, [apiClient, permitType, currentNextCursor, loadingMore]);

  const setPermitType = useCallback((type: string | null) => {
    setExtraItems([]);
    setExtraNextCursor(undefined);
    setPermitTypeState(type);
  }, []);

  const listStatus: "loading" | "error" | "ready" = templatesQuery.loading
    ? "loading"
    : templatesQuery.error
      ? "error"
      : "ready";

  const allItems = [...(templatesQuery.data?.items ?? []), ...extraItems];

  return {
    permitType,
    setPermitType,
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
