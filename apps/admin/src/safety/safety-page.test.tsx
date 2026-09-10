import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { SafetyPage } from "./safety-page";

const session: AuthSession = {
  email: "hse@example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "hse-1",
};
const gateway: AuthGateway = {
  getIdToken: async () => "token",
  observe: (listener) => {
    listener(session);
    return () => undefined;
  },
  refreshSession: async () => session,
  sendEmailVerification: async () => undefined,
  sendPasswordResetEmail: async () => undefined,
  signIn: async () => session,
  signOut: async () => undefined,
};

function report(overrides: Record<string, unknown> = {}) {
  return {
    id: "sr-1",
    title: "Gas leak at separator",
    category: "gas_leak",
    severity: "critical",
    status: "reported",
    reporterId: "inspector-1",
    assignedManagerId: null,
    occurredAt: new Date("2026-08-16T10:00:00Z"),
    revision: 1,
    createdAt: new Date("2026-08-16T10:01:00Z"),
    updatedAt: new Date("2026-08-16T10:01:00Z"),
    description: "Strong odor detected.",
    evidence: [],
    correctiveActions: [],
    createdBy: "inspector-1",
    ...overrides,
  };
}

function Ready({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  if (!auth.currentUser) return null;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      {children}
    </PermissionProvider>
  );
}

function setup() {
  const apiClient = {
    getCurrentUser: vi.fn(async () => ({
      uid: "hse-1",
      email: "hse@example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "hse_manager",
      permissions: new Set(["safety.read", "safety.write", "safety.close"]),
    })),
    registerCompanyAdmin: vi.fn(),
    listSafetyReports: vi.fn(async () => ({ items: [report()], nextCursor: null })),
    getSafetyReport: vi.fn(async () => report()),
    transitionSafetyReport: vi.fn(async (_id, request) =>
      report({ status: request.status, revision: 2 }),
    ),
    createSafetyReport: vi.fn(),
    uploadSafetyEvidence: vi.fn(),
    createCorrectiveAction: vi.fn(),
    closeSafetyReport: vi.fn(),
    deleteSafetyEvidence: vi.fn(),
    assignSafetyReport: vi.fn(),
    updateCorrectiveAction: vi.fn(),
    cancelCorrectiveAction: vi.fn(),
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={gateway}>
          <Ready>
            <SafetyPage />
          </Ready>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

describe("safety reports page", () => {
  it("loads real incident data and opens its detail", async () => {
    const api = setup();
    expect(await screen.findByText("Gas leak at separator")).toBeInTheDocument();
    await userEvent.click(screen.getByText("Gas leak at separator"));
    expect(await screen.findByText("Strong odor detected.")).toBeInTheDocument();
    expect(api.getSafetyReport).toHaveBeenCalledWith("sr-1");
  });

  it("exposes the controlled next lifecycle action to HSE", async () => {
    const api = setup();
    await userEvent.click(await screen.findByText("Gas leak at separator"));
    await userEvent.click(await screen.findByRole("button", { name: "Move to Under review" }));
    await waitFor(() =>
      expect(api.transitionSafetyReport).toHaveBeenCalledWith("sr-1", {
        status: "under_review",
        expectedRevision: 1,
      }),
    );
  });
});
