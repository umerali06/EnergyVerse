import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { WorkOrdersPage } from "./work-orders-page";

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
  company_admin: ["work_orders.read", "work_orders.write", "work_orders.close"],
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

function workOrderItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "wo-1",
    assetId: "asset-1",
    facilityId: "facility-1",
    title: "Replace pump seal",
    priority: "high",
    status: "open",
    technicianId: null,
    dueDate: null,
    revision: 1,
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

function renderWorkOrders({
  roleKey = "company_admin",
  permissions = roleMatrix.company_admin,
  listWorkOrders = vi.fn(async () => ({ items: [workOrderItem()], nextCursor: null })),
  listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null })),
  listFacilities = vi.fn(async () => ({ items: [facilityItem()], nextCursor: null })),
  listUsers = vi.fn(async () => ({ items: [userItem()], nextCursor: null })),
  createWorkOrder = vi.fn(async () => workOrderItem({ id: "wo-new", title: "New Work Order" })),
  gated = false,
}: {
  roleKey?: string;
  permissions?: string[];
  listWorkOrders?: ReturnType<typeof vi.fn>;
  listAssets?: ReturnType<typeof vi.fn>;
  listFacilities?: ReturnType<typeof vi.fn>;
  listUsers?: ReturnType<typeof vi.fn>;
  createWorkOrder?: ReturnType<typeof vi.fn>;
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
    listWorkOrders,
    listAssets,
    listFacilities,
    listUsers,
    createWorkOrder,
  };
  const content = gated ? (
    <RequirePermission permission="work_orders.read">
      <WorkOrdersPage />
    </RequirePermission>
  ) : (
    <WorkOrdersPage />
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

describe("work orders page", () => {
  it("shows a loading state and then the real tenant work orders", async () => {
    let resolveList!: (value: { items: unknown[]; nextCursor: null }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderWorkOrders({ listWorkOrders: vi.fn(() => deferred) });
    await screen.findByText("Work Orders");
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [workOrderItem()], nextCursor: null });
    expect(await screen.findByText("Replace pump seal")).toBeInTheDocument();
  });

  it("shows an honest empty state when no work orders match", async () => {
    renderWorkOrders({ listWorkOrders: vi.fn(async () => ({ items: [], nextCursor: null })) });
    expect(await screen.findByText("No work orders found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listWorkOrders = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderWorkOrders({ listWorkOrders });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listWorkOrders.mockResolvedValueOnce({ items: [workOrderItem()], nextCursor: null });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listWorkOrders).toHaveBeenCalledTimes(2));
  });

  it("renders the honest 403 screen for a role without work_orders.read", async () => {
    renderWorkOrders({
      roleKey: "field_inspector",
      permissions: roleMatrix.field_inspector,
      gated: true,
    });
    expect(await screen.findByText("You can't view this area")).toBeInTheDocument();
    expect(screen.queryByText("Work Orders")).not.toBeInTheDocument();
  });

  it("re-fetches when the status filter changes", async () => {
    const listWorkOrders = vi.fn(async () => ({ items: [workOrderItem()], nextCursor: null }));
    renderWorkOrders({ listWorkOrders });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Status"), "assigned");
    await waitFor(() =>
      expect(listWorkOrders.mock.calls.at(-1)?.[0]).toMatchObject({ status: "assigned" }),
    );
  });

  it("re-fetches when the asset filter changes", async () => {
    const listWorkOrders = vi.fn(async () => ({ items: [workOrderItem()], nextCursor: null }));
    renderWorkOrders({ listWorkOrders });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Asset"), "asset-1");
    await waitFor(() =>
      expect(listWorkOrders.mock.calls.at(-1)?.[0]).toMatchObject({ assetId: "asset-1" }),
    );
  });

  it("filters by priority client-side without re-fetching (no server param exists)", async () => {
    const listWorkOrders = vi.fn(async () => ({
      items: [
        workOrderItem({ id: "wo-1", title: "High priority job", priority: "high" }),
        workOrderItem({ id: "wo-2", title: "Low priority job", priority: "low" }),
      ],
      nextCursor: null,
    }));
    renderWorkOrders({ listWorkOrders });
    await screen.findByText("High priority job");
    expect(screen.getByText("Low priority job")).toBeInTheDocument();
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Priority"), "high");
    await waitFor(() => expect(screen.queryByText("Low priority job")).not.toBeInTheDocument());
    expect(screen.getByText("High priority job")).toBeInTheDocument();
    expect(listWorkOrders).toHaveBeenCalledTimes(1);
  });

  it("loads more work orders via cursor pagination and appends without duplicating", async () => {
    const listWorkOrders = vi
      .fn()
      .mockResolvedValueOnce({ items: [workOrderItem({ id: "wo-1" })], nextCursor: "cursor-1" })
      .mockResolvedValueOnce({
        items: [workOrderItem({ id: "wo-2", title: "Second Work Order" })],
        nextCursor: null,
      });
    renderWorkOrders({ listWorkOrders });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Load more" }));
    await waitFor(() => expect(screen.getByText("Second Work Order")).toBeInTheDocument());
    expect(screen.queryByRole("button", { name: "Load more" })).not.toBeInTheDocument();
    expect(listWorkOrders.mock.calls[1][0]).toMatchObject({ cursor: "cursor-1" });
  });

  it("hides the create button for a role without work_orders.write", async () => {
    renderWorkOrders({ roleKey: "field_inspector", permissions: ["work_orders.read"] });
    await screen.findByText("Work Orders");
    expect(screen.queryByRole("button", { name: "Create work order" })).not.toBeInTheDocument();
  });

  it("creates a work order through the modal and refreshes the list", async () => {
    const listWorkOrders = vi.fn(async () => ({ items: [workOrderItem()], nextCursor: null }));
    const createWorkOrder = vi.fn(async () => workOrderItem({ id: "wo-new" }));
    renderWorkOrders({ listWorkOrders, createWorkOrder });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Create work order" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.selectOptions(dialog.getByLabelText("Asset"), "asset-1");
    await user.type(dialog.getByLabelText("Title"), "New Work Order");
    await user.selectOptions(dialog.getByLabelText("Priority"), "critical");
    await user.click(dialog.getByRole("button", { name: "Create work order" }));
    await waitFor(() =>
      expect(createWorkOrder).toHaveBeenCalledWith(
        expect.objectContaining({
          assetId: "asset-1",
          title: "New Work Order",
          priority: "critical",
        }),
      ),
    );
    await waitFor(() => expect(listWorkOrders).toHaveBeenCalledTimes(2));
    await waitFor(() => expect(screen.queryByRole("dialog")).not.toBeInTheDocument());
  });

  it("rejects an empty title before calling the API", async () => {
    const createWorkOrder = vi.fn();
    renderWorkOrders({ createWorkOrder });
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Create work order" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.click(dialog.getByRole("button", { name: "Create work order" }));
    expect(await dialog.findByText("Enter a title")).toBeInTheDocument();
    expect(createWorkOrder).not.toHaveBeenCalled();
  });

  it("clears all active filters", async () => {
    renderWorkOrders();
    await screen.findByText("Replace pump seal");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Status"), "assigned");
    await screen.findByText("Status: Assigned");
    await user.click(screen.getByRole("button", { name: "Clear all" }));
    expect(screen.queryByText("Status: Assigned")).not.toBeInTheDocument();
  });
});
