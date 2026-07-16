"use client";

import { createContext, type ReactNode, useContext, useMemo } from "react";

import { useToast } from "@/design-system";

import {
  FevApiClient,
  type FevApiClientOptions,
  type TokenProvider,
  type UnauthorizedHook,
} from "./client";

const ApiClientContext = createContext<FevApiClient | null>(null);

export function ApiProvider({
  children,
  client,
  getIdToken,
  onUnauthorized,
}: {
  children: ReactNode;
  client?: FevApiClient;
  getIdToken?: TokenProvider;
  onUnauthorized?: UnauthorizedHook;
}) {
  const toast = useToast();
  const value = useMemo(() => {
    if (client) return client;
    const options: FevApiClientOptions = {
      getIdToken,
      onUnauthorized,
      toast,
    };
    return new FevApiClient(options);
  }, [client, getIdToken, onUnauthorized, toast]);

  return <ApiClientContext.Provider value={value}>{children}</ApiClientContext.Provider>;
}

export function useApiClient(): FevApiClient {
  const client = useContext(ApiClientContext);
  if (client === null) throw new Error("useApiClient requires ApiProvider");
  return client;
}

export function useOptionalApiClient(): FevApiClient | null {
  return useContext(ApiClientContext);
}
