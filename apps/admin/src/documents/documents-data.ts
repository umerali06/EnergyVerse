"use client";

import type { DocumentListItem, DocumentListPage } from "@fev/api-client";
import { useCallback, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { useCachedQuery } from "@/cache/cache-context";

export function useDocumentsData() {
  const { apiClient } = useAuth();
  const [categoryFilter, setCategoryFilter] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState<string>("");

  const queryKey = `documents:list:${categoryFilter || "all"}:${searchQuery || "all"}`;

  const query = useCachedQuery<DocumentListPage>(queryKey, () =>
    apiClient.listDocuments({
      category: categoryFilter || undefined,
      search: searchQuery || undefined,
      limit: 50,
    }),
  );

  const setCategory = useCallback((cat: string | null) => {
    setCategoryFilter(cat);
  }, []);

  const setSearch = useCallback((q: string) => {
    setSearchQuery(q);
  }, []);

  return {
    documents: query.data?.items ?? [],
    loading: query.loading,
    error: query.error,
    categoryFilter,
    searchQuery,
    setCategory,
    setSearch,
    refetch: query.refetch,
  };
}
