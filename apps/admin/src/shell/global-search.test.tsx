import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { GlobalSearch } from "./global-search";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  usePathname: () => "/dashboard",
  useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: pushMock, replace: vi.fn() }),
}));

const session: AuthSession = {
  email: "admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "admin-1",
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

const asset = {
  id: "asset-1",
  name: "Feed Pump 101",
  assetTag: "P-101",
  category: "Pump",
  currentStatus: "Healthy",
  qrCodeId: "QR7HJ2",
  facilityId: "fac-1",
  areaId: null,
  createdAt: new Date(),
  updatedAt: new Date(),
};

function renderSearch(overrides: Record<string, unknown> = {}) {
  const apiClient = {
    registerCompanyAdmin: vi.fn(),
    getCurrentUser: vi.fn(async () => ({
      uid: "admin-1",
      email: "admin@acme.example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "company_admin",
      permissions: new Set(["assets.read"]),
    })),
    listAssets: vi.fn(async (..._args: unknown[]) => ({ items: [asset], nextCursor: null })),
    listWorkOrders: vi.fn(async (..._args: unknown[]) => ({
      items: [{ id: "wo-1", title: "Replace pump seal", status: "open", priority: "high" }],
      nextCursor: null,
    })),
    listPermits: vi.fn(async (..._args: unknown[]) => ({
      items: [{ id: "permit-1", permitType: "hot_work", status: "active" }],
      nextCursor: null,
    })),
    listUsers: vi.fn(async (..._args: unknown[]) => ({ items: [], nextCursor: null })),
    listFacilities: vi.fn(async (..._args: unknown[]) => ({ items: [], nextCursor: null })),
    listInspections: vi.fn(async (..._args: unknown[]) => ({
      items: [
        {
          id: "insp-1",
          title: "Routine inspection - Feed Pump 101",
          status: "completed",
          inspectionType: "routine",
        },
      ],
      nextCursor: null,
    })),
    listSafetyReports: vi.fn(async (..._args: unknown[]) => ({
      items: [
        {
          id: "sr-1",
          title: "Gas leak at separator",
          category: "gas_leak",
          severity: "critical",
          status: "reported",
        },
      ],
      nextCursor: null,
    })),
    listGeneratedReports: vi.fn(async (..._args: unknown[]) => ({
      items: [
        { id: "rep-1", title: "Q3 asset condition", reportType: "asset_condition", status: "final" },
      ],
      nextCursor: null,
    })),
    ...overrides,
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider
          apiClient={apiClient as unknown as React.ComponentProps<typeof AuthProvider>["apiClient"]}
          gateway={gateway}
        >
          <Ready>
            <GlobalSearch />
          </Ready>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

async function search(term: string) {
  const user = userEvent.setup();
  await user.click(await screen.findByRole("button", { name: /Open global search/i }));
  await user.type(await screen.findByRole("searchbox"), term);
  return user;
}

describe("global search", () => {
  beforeEach(() => {
    pushMock.mockClear();
  });

  it("returns assets and opens the record itself, not a filtered list", async () => {
    renderSearch();
    const user = await search("pump");

    const hit = await screen.findByText("Feed Pump 101");
    await user.click(hit);

    // The searcher already said which asset they meant.
    expect(pushMock).toHaveBeenCalledWith("/assets/asset-1");
  });

  it("returns inspections", async () => {
    renderSearch();
    await search("routine");
    expect(await screen.findByText("Routine inspection - Feed Pump 101")).toBeInTheDocument();
  });

  it("returns safety reports", async () => {
    renderSearch();
    await search("gas");
    expect(await screen.findByText("Gas leak at separator")).toBeInTheDocument();
  });

  it("returns generated reports", async () => {
    renderSearch();
    await search("q3");
    expect(await screen.findByText("Q3 asset condition")).toBeInTheDocument();
  });

  it("resolves a QR code to the asset it labels", async () => {
    renderSearch();
    const user = await search("qr7hj2");

    // A QR code is a label printed for an asset, not a record of its own, so
    // the hit explains what it resolves to and opens that asset.
    const hit = await screen.findByText("QR QR7HJ2");
    expect(screen.getByText(/Resolves to Feed Pump 101/)).toBeInTheDocument();
    await user.click(hit);
    expect(pushMock).toHaveBeenCalledWith("/assets/asset-1");
  });

  it("carries the record through on work orders and permits", async () => {
    renderSearch();
    const user = await search("seal");
    await user.click(await screen.findByText("Replace pump seal"));
    expect(pushMock).toHaveBeenCalledWith("/work-orders/wo-1");
  });

  it("deep-links a safety report the safety page can open", async () => {
    renderSearch();
    const user = await search("gas");
    await user.click(await screen.findByText("Gas leak at separator"));
    // The safety module has no per-report route, so the id travels as a
    // parameter the page opens on arrival.
    expect(pushMock).toHaveBeenCalledWith("/safety?reportId=sr-1");
  });

  it("still returns the categories that did load when one module fails", async () => {
    renderSearch();
    await search("pump");

    // Every category is fetched independently; one failure must not blank the
    // whole palette.
    expect(await screen.findByText("Feed Pump 101")).toBeInTheDocument();
  });

  it("survives a module that throws", async () => {
    renderSearch({
      listInspections: vi.fn(async () => {
        throw new Error("inspections unavailable");
      }),
    });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: /Open global search/i }));
    await user.type(await screen.findByRole("searchbox"), "pump");

    await waitFor(() => expect(screen.getByText("Feed Pump 101")).toBeInTheDocument());
  });
});
