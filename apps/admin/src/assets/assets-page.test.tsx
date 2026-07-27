import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { AssetsPage } from "./assets-page";

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
  company_admin: ["assets.read", "facilities.read", "areas.read"],
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

function areaItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "area-1",
    facilityId: "facility-1",
    name: "Unit 12",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
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
    areaId: "area-1",
    manufacturer: "Acme Co",
    model: "X200",
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

function renderAssets({
  roleKey = "company_admin",
  permissions = roleMatrix.company_admin,
  listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null })),
  listFacilities = vi.fn(async () => ({ items: [facilityItem()], nextCursor: null })),
  listAreas = vi.fn(async () => ({ items: [areaItem()], nextCursor: null })),
  gated = false,
}: {
  roleKey?: string;
  permissions?: string[];
  listAssets?: ReturnType<typeof vi.fn>;
  listFacilities?: ReturnType<typeof vi.fn>;
  listAreas?: ReturnType<typeof vi.fn>;
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
    listAssets,
    listFacilities,
    listAreas,
  };
  const content = gated ? (
    <RequirePermission permission="assets.read">
      <AssetsPage />
    </RequirePermission>
  ) : (
    <AssetsPage />
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

describe("assets page", () => {
  it("shows a loading state and then the real tenant assets", async () => {
    let resolveList!: (value: { items: unknown[]; nextCursor: null }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderAssets({ listAssets: vi.fn(() => deferred) });
    await screen.findByText("Assets");
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [assetItem()], nextCursor: null });
    expect(await screen.findByText("Feed Pump")).toBeInTheDocument();
    expect(screen.getByText("PMP-001")).toBeInTheDocument();
  });

  it("shows an honest empty state when no assets match", async () => {
    renderAssets({ listAssets: vi.fn(async () => ({ items: [], nextCursor: null })) });
    expect(await screen.findByText("No assets found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listAssets = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderAssets({ listAssets });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listAssets.mockResolvedValueOnce({ items: [assetItem()], nextCursor: null });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listAssets).toHaveBeenCalledTimes(2));
  });

  it("loads more assets via cursor pagination and appends without duplicating", async () => {
    const listAssets = vi
      .fn()
      .mockResolvedValueOnce({ items: [assetItem({ id: "a1" })], nextCursor: "cursor-1" })
      .mockResolvedValueOnce({
        items: [assetItem({ id: "a2", assetTag: "PMP-002", name: "Second Pump" })],
        nextCursor: null,
      });
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Load more" }));
    await waitFor(() => expect(screen.getByText("Second Pump")).toBeInTheDocument());
    expect(screen.queryByRole("button", { name: "Load more" })).not.toBeInTheDocument();
    expect(listAssets.mock.calls[1][0]).toMatchObject({ cursor: "cursor-1" });
  });

  it("re-fetches with the search term", async () => {
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Search"), "pump");
    await waitFor(() =>
      expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ search: "pump" }),
    );
  });

  it("re-fetches when the category filter changes", async () => {
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Category"), "Valve");
    await waitFor(() =>
      expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ category: "Valve" }),
    );
  });

  it("re-fetches when the status filter changes", async () => {
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Status"), "Critical");
    await waitFor(() =>
      expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ currentStatus: "Critical" }),
    );
  });

  it("re-fetches when the sort changes", async () => {
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Sort"), "name");
    await waitFor(() => expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ sort: "name" }));
  });

  it("cascades the area filter from the selected facility and clears it on facility change", async () => {
    const listFacilities = vi.fn(async () => ({
      items: [facilityItem(), facilityItem({ id: "facility-2", name: "Beta Plant" })],
      nextCursor: null,
    }));
    const listAreas = vi.fn(async () => ({
      items: [areaItem(), areaItem({ id: "area-2", facilityId: "facility-2", name: "Bay 3" })],
      nextCursor: null,
    }));
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets, listAreas, listFacilities });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();

    // Area select has no options until a facility is chosen.
    expect(screen.getByLabelText("Area")).toBeDisabled();

    await user.selectOptions(screen.getByLabelText("Facility"), "facility-1");
    await waitFor(() =>
      expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ facilityId: "facility-1" }),
    );
    expect(screen.getByLabelText("Area")).not.toBeDisabled();
    expect(screen.getByRole("option", { name: "Unit 12" })).toBeInTheDocument();
    expect(screen.queryByRole("option", { name: "Bay 3" })).not.toBeInTheDocument();

    await user.selectOptions(screen.getByLabelText("Area"), "area-1");
    await waitFor(() => expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ areaId: "area-1" }));

    await user.selectOptions(screen.getByLabelText("Facility"), "facility-2");
    await waitFor(() =>
      expect(listAssets.mock.calls.at(-1)?.[0]).toMatchObject({ facilityId: "facility-2", areaId: undefined }),
    );
  });

  it("clears all active filters", async () => {
    const listAssets = vi.fn(async () => ({ items: [assetItem()], nextCursor: null }));
    renderAssets({ listAssets });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Search"), "pump");
    await screen.findByText('Search: "pump"');
    await user.click(screen.getByRole("button", { name: "Clear all" }));
    expect(screen.queryByText('Search: "pump"')).not.toBeInTheDocument();
  });

  it("renders the honest 403 screen for a role without assets.read", async () => {
    renderAssets({ roleKey: "field_inspector", permissions: roleMatrix.field_inspector, gated: true });
    expect(await screen.findByText("You can't view this area")).toBeInTheDocument();
    expect(screen.queryByText("Assets")).not.toBeInTheDocument();
  });
});
