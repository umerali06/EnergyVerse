"use client";

import type { CompanyProfile, UpdateCompanyRequest } from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";

export type AsyncStatus = "loading" | "error" | "ready";

/**
 * Fetches and mutates the current tenant's company profile through the
 * single FevApiClient instance AuthProvider owns, mirroring the 3.2 roles
 * data hook.
 */
import { useCachedQuery } from "@/cache/cache-context";

export function useCompanySettingsData() {
  const { apiClient } = useAuth();

  const companyQuery = useCachedQuery<CompanyProfile>(
    "company:profile",
    () => apiClient.getCompany(),
  );

  const status: AsyncStatus = companyQuery.loading
    ? "loading"
    : companyQuery.error
      ? "error"
      : "ready";

  const updateCompany = useCallback(
    async (request: UpdateCompanyRequest): Promise<CompanyProfile> => {
      const profile = await apiClient.updateCompany(request);
      companyQuery.mutate(profile);
      return profile;
    },
    [apiClient, companyQuery],
  );

  const uploadLogo = useCallback(
    async (file: File): Promise<CompanyProfile> => {
      const profile = await apiClient.uploadCompanyLogo(file);
      companyQuery.mutate(profile);
      return profile;
    },
    [apiClient, companyQuery],
  );

  const removeLogo = useCallback(async (): Promise<CompanyProfile> => {
    const profile = await apiClient.removeCompanyLogo();
    companyQuery.mutate(profile);
    return profile;
  }, [apiClient, companyQuery]);

  return {
    company: {
      status,
      profile: companyQuery.data,
    },
    retry: companyQuery.refetch,
    refresh: companyQuery.refetch,
    updateCompany,
    uploadLogo,
    removeLogo,
  };
}
