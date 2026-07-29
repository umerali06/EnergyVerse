import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { ChecklistTemplatesPage } from "./checklist-templates-page";

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
  company_admin: ["checklist_templates.read", "checklist_templates.write"],
  field_inspector: ["checklist_templates.read"],
  executive: ["reports.read"],
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

function templateItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "template-1",
    name: "Pump Inspection Checklist",
    category: "Pumps",
    version: 1,
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

function renderTemplates({
  roleKey = "company_admin",
  permissions = roleMatrix.company_admin,
  listChecklistTemplates = vi.fn(async () => ({ items: [templateItem()], nextCursor: null })),
  gated = false,
}: {
  roleKey?: string;
  permissions?: string[];
  listChecklistTemplates?: ReturnType<typeof vi.fn>;
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
  const apiClient = { getCurrentUser: vi.fn(async () => identity), listChecklistTemplates };
  const content = gated ? (
    <RequirePermission permission="checklist_templates.read">
      <ChecklistTemplatesPage />
    </RequirePermission>
  ) : (
    <ChecklistTemplatesPage />
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

describe("checklist templates page", () => {
  it("renders real tenant templates", async () => {
    renderTemplates();
    expect(await screen.findByText("Pump Inspection Checklist")).toBeInTheDocument();
    expect(screen.getByText("v1")).toBeInTheDocument();
  });

  it("shows the Create template button for a write-permitted role", async () => {
    renderTemplates();
    await screen.findByText("Pump Inspection Checklist");
    expect(screen.getByRole("button", { name: "Create template" })).toBeInTheDocument();
  });

  it("hides the Create template button and row navigation for a read-only role", async () => {
    renderTemplates({
      roleKey: "field_inspector",
      permissions: roleMatrix.field_inspector,
    });
    await screen.findByText("Pump Inspection Checklist");
    expect(screen.queryByRole("button", { name: "Create template" })).not.toBeInTheDocument();
    await userEvent.setup().click(screen.getByText("Pump Inspection Checklist"));
    expect(pushMock).not.toHaveBeenCalled();
  });

  it("navigates to the edit page on row click for a write-permitted role", async () => {
    renderTemplates();
    await screen.findByText("Pump Inspection Checklist");
    await userEvent.setup().click(screen.getByText("Pump Inspection Checklist"));
    expect(pushMock).toHaveBeenCalledWith("/checklist-templates/template-1");
  });

  it("shows an honest empty state when no templates match", async () => {
    renderTemplates({
      listChecklistTemplates: vi.fn(async () => ({ items: [], nextCursor: null })),
    });
    expect(await screen.findByText("No templates found")).toBeInTheDocument();
  });

  it("re-fetches when the category filter changes", async () => {
    const listChecklistTemplates = vi.fn(async () => ({
      items: [templateItem()],
      nextCursor: null,
    }));
    renderTemplates({ listChecklistTemplates });
    await screen.findByText("Pump Inspection Checklist");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Category"), "Tanks");
    await waitFor(() =>
      expect(listChecklistTemplates.mock.calls.at(-1)?.[0]).toMatchObject({ category: "Tanks" }),
    );
  });

  it("renders the honest 403 screen for a role without checklist_templates.read", async () => {
    renderTemplates({ roleKey: "executive", permissions: roleMatrix.executive, gated: true });
    expect(await screen.findByText("You can't view this area")).toBeInTheDocument();
    expect(screen.queryByText("Checklist Templates")).not.toBeInTheDocument();
  });
});
