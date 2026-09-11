import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { SafetyPage } from "./safety-page";

let searchParams = new URLSearchParams();

vi.mock("next/navigation", () => ({
  useSearchParams: () => searchParams,
}));

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
    category: "gas_leak" as const,
    severity: "critical" as const,
    status: "reported" as const,
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

function setup(overrides: Record<string, unknown> = {}) {
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
    ...overrides,
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
  beforeEach(() => {
    searchParams = new URLSearchParams();
  });

  it("opens the report a deep link names", async () => {
    // Global search and notifications both arrive this way, since safety has
    // no per-report route of its own.
    searchParams = new URLSearchParams("reportId=sr-1");
    const api = setup();

    expect(await screen.findByText("Strong odor detected.")).toBeInTheDocument();
    expect(api.getSafetyReport).toHaveBeenCalledWith("sr-1");
  });

  it("does not open anything without a deep link", async () => {
    const api = setup();

    expect(await screen.findByText("Gas leak at separator")).toBeInTheDocument();
    expect(api.getSafetyReport).not.toHaveBeenCalled();
  });

  it("loads real incident data and opens its detail", async () => {
    const api = setup();
    expect(await screen.findByText("Gas leak at separator")).toBeInTheDocument();
    await userEvent.click(screen.getByText("Gas leak at separator"));
    expect(await screen.findByText("Strong odor detected.")).toBeInTheDocument();
    expect(api.getSafetyReport).toHaveBeenCalledWith("sr-1");
  });

  it("shows a failure state, not an empty incident history, when the list request fails", async () => {
    setup({
      listSafetyReports: vi.fn(async () => {
        throw new Error("upstream unavailable");
      }),
    });

    expect(await screen.findByText("Safety reports could not be loaded")).toBeInTheDocument();
    // A failed request must never be presented as a record of zero incidents.
    expect(screen.queryByText("No safety reports")).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Retry" })).toBeInTheDocument();
  });

  it("recovers the list when the retry succeeds", async () => {
    const listSafetyReports = vi
      .fn()
      .mockRejectedValueOnce(new Error("upstream unavailable"))
      .mockResolvedValue({ items: [report()], nextCursor: null });
    setup({ listSafetyReports });

    await userEvent.click(await screen.findByRole("button", { name: "Retry" }));

    expect(await screen.findByText("Gas leak at separator")).toBeInTheDocument();
    expect(screen.queryByText("Safety reports could not be loaded")).not.toBeInTheDocument();
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
