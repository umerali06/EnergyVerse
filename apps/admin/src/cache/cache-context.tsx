"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useRef,
  useState,
  type ReactNode,
} from "react";

export interface CacheRecord<T = unknown> {
  data: T;
  timestamp: number;
  fetching: boolean;
  error: Error | null;
}

export interface CacheContextValue {
  getCache: <T>(key: string) => CacheRecord<T> | undefined;
  setCache: <T>(key: string, data: T) => void;
  invalidateCache: (keyOrPrefix?: string) => void;
  query: <T>(
    key: string,
    fetcher: () => Promise<T>,
    options?: { ttl?: number; force?: boolean },
  ) => Promise<T>;
  subscribe: (key: string, listener: () => void) => () => void;
}

const ApiCacheContext = createContext<CacheContextValue | null>(null);

const DEFAULT_TTL = 5 * 60 * 1000; // 5 minutes in ms

export function createCacheStore(): CacheContextValue {
  const cacheMap = new Map<string, CacheRecord<unknown>>();
  const listenersMap = new Map<string, Set<() => void>>();

  const notify = (key: string) => {
    listenersMap.get(key)?.forEach((l) => l());
  };

  const getCache = <T,>(key: string): CacheRecord<T> | undefined => {
    return cacheMap.get(key) as CacheRecord<T> | undefined;
  };

  const setCache = <T,>(key: string, data: T) => {
    cacheMap.set(key, {
      data,
      timestamp: Date.now(),
      fetching: false,
      error: null,
    });
    notify(key);
  };

  const invalidateCache = (keyOrPrefix?: string) => {
    if (!keyOrPrefix) {
      cacheMap.clear();
      return;
    }
    const keysToDelete: string[] = [];
    cacheMap.forEach((_, key) => {
      if (key === keyOrPrefix || key.startsWith(keyOrPrefix)) {
        keysToDelete.push(key);
      }
    });
    keysToDelete.forEach((key) => {
      cacheMap.delete(key);
    });
  };

  const subscribe = (key: string, listener: () => void) => {
    if (!listenersMap.has(key)) {
      listenersMap.set(key, new Set());
    }
    const set = listenersMap.get(key)!;
    set.add(listener);
    return () => {
      set.delete(listener);
      if (set.size === 0) listenersMap.delete(key);
    };
  };

  const query = async <T,>(
    key: string,
    fetcher: () => Promise<T>,
    options: { ttl?: number; force?: boolean } = {},
  ): Promise<T> => {
    const ttl = options.ttl ?? DEFAULT_TTL;
    const existing = cacheMap.get(key) as CacheRecord<T> | undefined;
    const now = Date.now();

    if (existing && !options.force && now - existing.timestamp < ttl) {
      return existing.data;
    }

    if (existing) {
      cacheMap.set(key, { ...existing, fetching: true });
      notify(key);
    }

    try {
      const freshData = await fetcher();
      cacheMap.set(key, {
        data: freshData,
        timestamp: Date.now(),
        fetching: false,
        error: null,
      });
      notify(key);
      return freshData;
    } catch (err) {
      const error = err instanceof Error ? err : new Error(String(err));
      cacheMap.set(key, {
        data: existing?.data ?? (null as unknown as T),
        timestamp: Date.now(),
        fetching: false,
        error,
      });
      notify(key);
      throw error;
    }
  };

  return { getCache, setCache, invalidateCache, query, subscribe };
}

export function ApiCacheProvider({ children }: { children: ReactNode }) {
  const storeRef = useRef<CacheContextValue | null>(null);
  if (!storeRef.current) {
    storeRef.current = createCacheStore();
  }

  return (
    <ApiCacheContext.Provider value={storeRef.current}>
      {children}
    </ApiCacheContext.Provider>
  );
}

export function useApiCache() {
  const ctx = useContext(ApiCacheContext);
  const fallbackRef = useRef<CacheContextValue | null>(null);
  if (ctx) return ctx;
  if (!fallbackRef.current) {
    fallbackRef.current = createCacheStore();
  }
  return fallbackRef.current;
}

export interface UseCachedQueryOptions<T> {
  ttl?: number;
  enabled?: boolean;
  initialData?: T;
}

export function useCachedQuery<T>(
  key: string | null,
  fetcher: () => Promise<T>,
  options: UseCachedQueryOptions<T> = {},
) {
  const { enabled = true, ttl, initialData } = options;
  const cache = useApiCache();

  const [, setTick] = useState(0);
  const fetcherRef = useRef(fetcher);
  fetcherRef.current = fetcher;

  // Subscribe to changes on this cache key
  useEffect(() => {
    if (!key || !enabled) return;
    return cache.subscribe(key, () => setTick((t) => t + 1));
  }, [key, enabled, cache]);

  const existing = key ? cache.getCache<T>(key) : undefined;
  const data = existing ? existing.data : initialData ?? null;
  const isStale = !existing || Date.now() - existing.timestamp > (ttl ?? DEFAULT_TTL);
  const isLoading = enabled && Boolean(key) && !existing && !initialData;
  const isRevalidating = existing ? existing.fetching : false;
  const error = existing ? existing.error : null;

  const executeFetch = useCallback(
    async (force = false) => {
      if (!key || !enabled) return;
      try {
        await cache.query(key, () => fetcherRef.current(), { ttl, force });
      } catch {
        // Errors are stored in cache record and accessible via error state
      }
    },
    [key, enabled, ttl, cache],
  );

  // Auto-fetch on mount or when key/enabled changes
  useEffect(() => {
    if (!key || !enabled) return;
    executeFetch(isStale);
  }, [key, enabled, isStale, executeFetch]);

  const refetch = useCallback(() => executeFetch(true), [executeFetch]);

  const mutate = useCallback(
    (newData: T | ((prev: T | null) => T)) => {
      if (!key) return;
      const next = typeof newData === "function" ? (newData as (prev: T | null) => T)(data) : newData;
      cache.setCache(key, next);
    },
    [key, cache, data],
  );

  return {
    data,
    loading: isLoading,
    revalidating: isRevalidating,
    error,
    refetch,
    mutate,
  };
}
