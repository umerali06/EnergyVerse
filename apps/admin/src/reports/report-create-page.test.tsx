import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { ReportCreatePage } from "./report-create-page";

const push = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ push }) }));

const session: AuthSession = {
  email: "manager@example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "manager-1",
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

function Ready({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  if (!auth.currentUser) return null;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      {children}
    </PermissionProvider>
  );
}

function setup(permissions = ["reports.generate", "inspections.read"]) {
  const apiClient = {
    getCurrentUser: vi.fn(async () => ({
      uid: "manager-1",
      email: "manager@example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "operations_manager",
      permissions: new Set(permissions),
    })),
    registerCompanyAdmin: vi.fn(),
    listInspections: vi.fn(async () => ({
      items: [
        {
          id: "inspection-1",
          title: "Separator inspection",
          inspectionType: "routine",
          status: "completed",
          assetId: "asset-1",
          facilityId: "facility-1",
          inspectorId: "inspector-1",
          revision: 3,
          createdAt: new Date(),
          updatedAt: new Date(),
        },
      ],
      nextCursor: null,
    })),
    listWorkOrders: vi.fn(),
    listSafetyReports: vi.fn(),
    listAssets: vi.fn(),
    generateReport: vi.fn(async (request) => ({ id: request.id })),
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={gateway}>
          <Ready>
            <ReportCreatePage />
          </Ready>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

beforeEach(() => {
  push.mockReset();
  vi.stubGlobal("crypto", { randomUUID: () => "report-new-1" });
});

describe("report create page", () => {
  it("loads permitted authoritative sources and generates a real draft", async () => {
    const api = setup();
    await screen.findByRole("option", { name: /Separator inspection/ });
    await userEvent.selectOptions(screen.getByLabelText("Authoritative source"), "inspection-1");
    await userEvent.type(screen.getByLabelText("Report title"), "Weekly inspection report");
    await userEvent.click(screen.getByRole("button", { name: "Generate draft" }));
    await waitFor(() =>
      expect(api.generateReport).toHaveBeenCalledWith({
        id: "report-new-1",
        reportType: "inspection",
        sourceId: "inspection-1",
        title: "Weekly inspection report",
      }),
    );
    expect(push).toHaveBeenCalledWith("/reports");
  });

  it("generates an executive summary without requesting or sending a source", async () => {
    const api = setup();
    await userEvent.selectOptions(await screen.findByLabelText("Report type"), "executive_summary");
    expect(await screen.findByText(/do not accept a single source record/)).toBeInTheDocument();
    await userEvent.click(screen.getByRole("button", { name: "Generate draft" }));
    await waitFor(() =>
      expect(api.generateReport).toHaveBeenCalledWith({
        id: "report-new-1",
        reportType: "executive_summary",
        sourceId: undefined,
        title: undefined,
      }),
    );
  });

  it("blocks the form and source reads without reports.generate", async () => {
    const api = setup(["inspections.read"]);
    expect(await screen.findByText("Report generation unavailable")).toBeInTheDocument();
    expect(api.listInspections).not.toHaveBeenCalled();
  });
});
