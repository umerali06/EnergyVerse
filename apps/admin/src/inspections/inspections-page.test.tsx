import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { InspectionsPage } from "./inspections-page";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({
    back: vi.fn(),
    prefetch: vi.fn(),
    push: pushMock,
    replace: vi.fn(),
  }),
}));

const session: AuthSession = {
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-company_admin",
};

const roleMatrix: Record<string, string[]> = {
  company_admin: ["inspections.read", "inspections.write"],
  field_inspector: ["reports.read"],
};

function makeGateway(): AuthGateway {
  return {
    async getIdToken() {
      return "id-token";
    },
    observe(listener: (value: AuthSession | null) => void) {
      listener(session);
      return () => undefined;
    },
    async refreshSession() {
      return session;
    },
    async sendEmailVerification() {},
    async sendPasswordResetEmail() {},
    async signIn() {
      return session;
    },
    async signOut() {},
  };
}

function inspectionItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "inspection-1",
    assetId: "asset-1",
    facilityId: "facility-1",
    areaId: null,
    inspectorId: "demo-acme-field_inspector",
    status: "completed",
    inspectionType: "routine",
    title: "Q3 Routine Inspection",
    checklistTemplateId: null,
    startedAt: new Date("2026-01-02T00:00:00Z"),
    completedAt: new Date("2026-01-03T00:00:00Z"),
    revision: 2,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date(Date.now() - 5 * 60_000),
    ...overrides,
  };
}

function DashboardWithPermissions({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      {children}
    </PermissionProvider>
  );
}

function renderInspections({
  roleKey = "company_admin",
  permissions = roleMatrix.company_admin,
  listInspections = vi.fn(async () => ({ items: [inspectionItem()], nextCursor: null })),
  gated = false,
}: {
  roleKey?: string;
  permissions?: string[];
  listInspections?: ReturnType<typeof vi.fn>;
  gated?: boolean;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey,
    permissions: new Set(permissions),
  };
  const apiClient = { getCurrentUser: vi.fn(async () => identity), listInspections };
  const content = gated ? (
    <RequirePermission permission="inspections.read">
      <InspectionsPage />
    </RequirePermission>
  ) : (
    <InspectionsPage />
  );
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <DashboardWithPermissions>{content}</DashboardWithPermissions>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

describe("inspections page", () => {
  it("renders real tenant inspections", async () => {
    renderInspections();
    expect(await screen.findByText("Q3 Routine Inspection")).toBeInTheDocument();
    const body = screen.getByTestId("inspections-table-body");
    expect(within(body).getByText("Completed")).toBeInTheDocument();
  });

  it("shows an honest empty state when no inspections match", async () => {
    renderInspections({ listInspections: vi.fn(async () => ({ items: [], nextCursor: null })) });
    expect(await screen.findByText("No inspections found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listInspections = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderInspections({ listInspections });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listInspections.mockResolvedValueOnce({ items: [inspectionItem()], nextCursor: null });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listInspections).toHaveBeenCalledTimes(2));
  });

  it("re-fetches when the status filter changes", async () => {
    const listInspections = vi.fn(async () => ({ items: [inspectionItem()], nextCursor: null }));
    renderInspections({ listInspections });
    await screen.findByText("Q3 Routine Inspection");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Status"), "in_progress");
    await waitFor(() =>
      expect(listInspections.mock.calls.at(-1)?.[0]).toMatchObject({ status: "in_progress" }),
    );
  });

  it("navigates to the inspection detail page on row click", async () => {
    renderInspections();
    await screen.findByText("Q3 Routine Inspection");
    const user = userEvent.setup();
    await user.click(screen.getByText("Q3 Routine Inspection"));
    expect(pushMock).toHaveBeenCalledWith("/inspections/inspection-1");
  });

  it("renders the honest 403 screen for a role without inspections.read", async () => {
    renderInspections({
      roleKey: "field_inspector",
      permissions: roleMatrix.field_inspector,
      gated: true,
    });
    expect(await screen.findByText("You can't view this area")).toBeInTheDocument();
    expect(screen.queryByText("Inspections")).not.toBeInTheDocument();
  });
});
