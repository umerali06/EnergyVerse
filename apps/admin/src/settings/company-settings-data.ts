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
export function useCompanySettingsData() {
  const { apiClient } = useAuth();
  const [company, setCompany] = useState<{
    status: AsyncStatus;
    profile: CompanyProfile | null;
  }>({ status: "loading", profile: null });

  const fetchCompany = useCallback(async () => {
    setCompany((current) => ({ ...current, status: "loading" }));
    try {
      const profile = await apiClient.getCompany();
      setCompany({ status: "ready", profile });
    } catch {
      setCompany({ status: "error", profile: null });
    }
  }, [apiClient]);

  useEffect(() => {
    void fetchCompany();
  }, [fetchCompany]);

  const updateCompany = useCallback(
    async (request: UpdateCompanyRequest): Promise<CompanyProfile> => {
      const profile = await apiClient.updateCompany(request);
      setCompany({ status: "ready", profile });
      return profile;
    },
    [apiClient],
  );

  const uploadLogo = useCallback(
    async (file: File): Promise<CompanyProfile> => {
      const profile = await apiClient.uploadCompanyLogo(file);
      setCompany({ status: "ready", profile });
      return profile;
    },
    [apiClient],
  );

  const removeLogo = useCallback(async (): Promise<CompanyProfile> => {
    const profile = await apiClient.removeCompanyLogo();
    setCompany({ status: "ready", profile });
    return profile;
  }, [apiClient]);

  return {
    company,
    retry: () => void fetchCompany(),
    refresh: () => void fetchCompany(),
    updateCompany,
    uploadLogo,
    removeLogo,
  };
}
