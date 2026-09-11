import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { WorkOrderDetailPage } from "./work-order-detail-page";

vi.mock("next/navigation", () => ({
  useRouter: () => ({
    back: vi.fn(),
    prefetch: vi.fn(),
    push: vi.fn(),
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
  supervisor: ["work_orders.read", "work_orders.write", "work_orders.close"],
  writer_only: ["work_orders.read", "work_orders.write"],
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

function assetItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "asset-1",
    assetTag: "PMP-001",
    name: "Feed Pump",
    category: "Pump",
    currentStatus: "Healthy",
    facilityId: "facility-1",
    areaId: null,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function facilityItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "facility-1",
    name: "Acme Refinery",
    status: "active",
    timezone: "UTC",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function userItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "tech-1",
    displayName: "Jamie Tech",
    email: "jamie@acme.example.invalid",
    roleId: "role-technician",
    roleKey: "maintenance_technician",
    roleName: "Maintenance Technician",
    status: "active",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function workOrderDetail(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "wo-1",
    assetId: "asset-1",
    facilityId: "facility-1",
    title: "Replace pump seal",
    description: "Seal is leaking, needs replacement.",
    priority: "high",
    status: "open",
    technicianId: null,
    assignedAt: null,
    assignedBy: null,
    acceptedAt: null,
    submittedAt: null,
    closedAt: null,
    closedBy: null,
    cancelledAt: null,
    laborHours: null,
    materialsUsed: [],
    completionNotes: null,
    dueDate: null,
    sourceInspectionId: null,
    revision: 1,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    createdBy: "demo-acme-company_admin",
    updatedAt: new Date("2026-01-02T00:00:00Z"),
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

function renderDetail({
  roleKey = "supervisor",
  permissions = roleMatrix.supervisor,
  getWorkOrder = vi.fn(async () => workOrderDetail()),
  listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null })),
  listFacilities = vi.fn(async () => ({ items: [facilityItem()], nextCursor: null })),
  listUsers = vi.fn(async () => ({ items: [userItem()], nextCursor: null })),
  assignWorkOrder = vi.fn(async () =>
    workOrderDetail({ technicianId: "tech-1", status: "assigned" }),
  ),
  closeWorkOrder = vi.fn(async () => workOrderDetail({ status: "closed" })),
  cancelWorkOrder = vi.fn(async () => workOrderDetail({ status: "cancelled" })),
  gated = false,
}: {
  roleKey?: string;
  permissions?: string[];
  getWorkOrder?: ReturnType<typeof vi.fn>;
  listAssets?: ReturnType<typeof vi.fn>;
  listFacilities?: ReturnType<typeof vi.fn>;
  listUsers?: ReturnType<typeof vi.fn>;
  assignWorkOrder?: ReturnType<typeof vi.fn>;
  closeWorkOrder?: ReturnType<typeof vi.fn>;
  cancelWorkOrder?: ReturnType<typeof vi.fn>;
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
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    registerCompanyAdmin: vi.fn(),
    getWorkOrder,
    listAssets,
    listFacilities,
    listUsers,
    assignWorkOrder,
    closeWorkOrder,
    cancelWorkOrder,
  };
  const content = gated ? (
    <RequirePermission permission="work_orders.read">
      <WorkOrderDetailPage workOrderId="wo-1" />
    </RequirePermission>
  ) : (
    <WorkOrderDetailPage workOrderId="wo-1" />
  );
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <DashboardWithPermissions>{content}</DashboardWithPermissions>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("work order detail page", () => {
  it("shows a loading state and then the real work order", async () => {
    renderDetail();
    expect(await screen.findByText("Replace pump seal")).toBeInTheDocument();
    expect(screen.getByText("Feed Pump (PMP-001)")).toBeInTheDocument();
    expect(screen.getByText("Acme Refinery")).toBeInTheDocument();
  });

  it("shows a retry-friendly error state when the fetch fails", async () => {
    const getWorkOrder = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderDetail({ getWorkOrder });
    expect(await screen.findByText("Something went wrong")).toBeInTheDocument();
  });

  it("renders the honest 403 screen for a role without work_orders.read", async () => {
    renderDetail({
      roleKey: "field_inspector",
      permissions: roleMatrix.field_inspector,
      gated: true,
    });
    expect(await screen.findByText("You can't view this area")).toBeInTheDocument();
    expect(screen.queryByText("Replace pump seal")).not.toBeInTheDocument();
  });

  it("shows the review section once a work order is pending review", async () => {
    const getWorkOrder = vi.fn(async () =>
      workOrderDetail({
        status: "pending_review",
        technicianId: "tech-1",
        submittedAt: new Date("2026-01-03T00:00:00Z"),
        laborHours: 3.5,
        materialsUsed: ["Seal kit", "Lubricant"],
        completionNotes: "Replaced the seal and tested for leaks.",
      }),
    );
    renderDetail({ getWorkOrder });
    await screen.findByText("Replace pump seal");
    expect(screen.getByText("Completion details")).toBeInTheDocument();
    expect(screen.getByText("3.5")).toBeInTheDocument();
    expect(screen.getByText("Seal kit")).toBeInTheDocument();
    expect(screen.getByText("Lubricant")).toBeInTheDocument();
    expect(screen.getByText("Replaced the seal and tested for leaks.")).toBeInTheDocument();
  });

  it("assigns a technician through the modal", async () => {
    const assignWorkOrder = vi.fn(async () =>
      workOrderDetail({ technicianId: "tech-1", status: "assigned" }),
    );
    const getWorkOrder = vi
      .fn()
      .mockResolvedValueOnce(workOrderDetail())
      .mockResolvedValueOnce(workOrderDetail({ technicianId: "tech-1", status: "assigned" }));
    renderDetail({ assignWorkOrder, getWorkOrder });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Assign" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.selectOptions(dialog.getByLabelText("Technician"), "tech-1");
    await user.click(dialog.getByRole("button", { name: "Assign" }));
    await waitFor(() =>
      expect(assignWorkOrder).toHaveBeenCalledWith(
        "wo-1",
        expect.objectContaining({ technicianId: "tech-1", expectedRevision: 1 }),
      ),
    );
    await waitFor(() => expect(getWorkOrder).toHaveBeenCalledTimes(2));
  });

  it("hides the assign action for a status past the assignable window", async () => {
    const getWorkOrder = vi.fn(async () =>
      workOrderDetail({ status: "in_progress", technicianId: "tech-1" }),
    );
    renderDetail({ getWorkOrder });
    await screen.findByText("Replace pump seal");
    expect(screen.queryByRole("button", { name: /Assign|Reassign/ })).not.toBeInTheDocument();
  });

  it("hides the close action for a role holding only work_orders.write", async () => {
    const getWorkOrder = vi.fn(async () =>
      workOrderDetail({ status: "pending_review", technicianId: "tech-1" }),
    );
    renderDetail({ getWorkOrder, permissions: roleMatrix.writer_only, roleKey: "writer_only" });
    await screen.findByText("Replace pump seal");
    expect(screen.queryByRole("button", { name: "Close" })).not.toBeInTheDocument();
    // Cancel stays available to a .write holder even without .close.
    expect(screen.getByRole("button", { name: "Cancel" })).toBeInTheDocument();
  });

  it("closes a pending-review work order for a role holding work_orders.close", async () => {
    const closeWorkOrder = vi.fn(async () => workOrderDetail({ status: "closed" }));
    const getWorkOrder = vi.fn(async () =>
      workOrderDetail({ status: "pending_review", technicianId: "tech-1" }),
    );
    renderDetail({ getWorkOrder, closeWorkOrder });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Close" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.click(dialog.getByRole("button", { name: "Close work order" }));
    await waitFor(() => expect(closeWorkOrder).toHaveBeenCalledWith("wo-1"));
  });

  it("cancels a non-terminal work order", async () => {
    const cancelWorkOrder = vi.fn(async () => workOrderDetail({ status: "cancelled" }));
    renderDetail({ cancelWorkOrder });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Cancel" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.click(dialog.getByRole("button", { name: "Cancel work order" }));
    await waitFor(() => expect(cancelWorkOrder).toHaveBeenCalledWith("wo-1"));
  });

  it("hides cancel for a terminal (closed) work order", async () => {
    const getWorkOrder = vi.fn(async () => workOrderDetail({ status: "closed" }));
    renderDetail({ getWorkOrder });
    await screen.findByText("Replace pump seal");
    expect(screen.queryByRole("button", { name: "Cancel" })).not.toBeInTheDocument();
  });
});
