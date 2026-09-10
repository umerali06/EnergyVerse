import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { afterEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { ReportsPage } from "./reports-page";

const push = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ push }) }));

const session: AuthSession = {
  email: "executive@example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "executive-1",
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

function report(status: "draft" | "finalized", id: string, title: string) {
  return {
    id,
    title,
    reportType: "executive_summary" as const,
    sourceId: null,
    status,
    revision: 1,
    createdAt: new Date("2026-08-20T10:00:00Z"),
    updatedAt: new Date("2026-08-20T11:00:00Z"),
    createdBy: "manager-1",
    finalizedAt: status === "finalized" ? new Date("2026-08-20T11:00:00Z") : null,
    finalizedBy: status === "finalized" ? "manager-1" : null,
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
      uid: "executive-1",
      email: "executive@example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "executive",
      permissions: new Set(["reports.read"]),
    })),
    registerCompanyAdmin: vi.fn(),
    listGeneratedReports: vi.fn(async () => ({
      items: [
        report("finalized", "report-final", "Weekly safety summary"),
        report("draft", "report-draft", "Draft inspection report"),
      ],
      nextCursor: null,
    })),
    exportGeneratedReport: vi.fn(async () => ({
      reportId: "report-final",
      format: "pdf" as const,
      filename: "weekly-safety-summary.pdf",
      contentType: "application/pdf",
      size: 2048,
      generatedBy: "executive-1",
      generatedAt: new Date("2026-08-20T12:00:00Z"),
      url: "https://storage.example.invalid/signed-report",
    })),
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={gateway}>
          <Ready>
            <ReportsPage />
          </Ready>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

afterEach(() => vi.restoreAllMocks());

describe("reports page", () => {
  it("renders the real report library and keeps draft exports unavailable", async () => {
    const api = setup();
    expect(await screen.findByText("Weekly safety summary")).toBeInTheDocument();
    expect(screen.getByText("Draft inspection report")).toBeInTheDocument();
    expect(screen.getByText("Finalize to export")).toBeInTheDocument();
    expect(api.listGeneratedReports).toHaveBeenCalledWith({
      reportType: undefined,
      status: undefined,
      limit: 25,
    });
    expect(screen.getAllByRole("button", { name: /Export Weekly safety summary as/ })).toHaveLength(
      3,
    );
  });

  it("requests a fresh private export and starts the signed download", async () => {
    const click = vi
      .spyOn(HTMLAnchorElement.prototype, "click")
      .mockImplementation(() => undefined);
    const api = setup();
    await userEvent.click(
      await screen.findByRole("button", { name: "Export Weekly safety summary as PDF" }),
    );
    await waitFor(() =>
      expect(api.exportGeneratedReport).toHaveBeenCalledWith("report-final", "pdf"),
    );
    expect(click).toHaveBeenCalledOnce();
    expect(await screen.findByText(/PDF export ready/)).toBeInTheDocument();
  });

  it("sends report type and status filters to the tenant API", async () => {
    const api = setup();
    await screen.findByText("Weekly safety summary");
    await userEvent.selectOptions(screen.getByLabelText("Report type"), "safety");
    await userEvent.selectOptions(screen.getByLabelText("Status"), "finalized");
    await waitFor(() =>
      expect(api.listGeneratedReports).toHaveBeenLastCalledWith({
        reportType: "safety",
        status: "finalized",
        limit: 25,
      }),
    );
  });
});
