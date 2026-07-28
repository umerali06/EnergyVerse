import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { DashboardWidgetGrid } from "@/dashboard/widget-registry";

// Registers the 3 asset widgets exactly once at module load, same as
// dashboard-page.tsx's side-effect import -- the registry is idempotent
// (registerWidget no-ops on a duplicate id), so no per-test reset is needed.
import "./asset-widgets";

const mockPush = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: () => undefined, push: mockPush, replace: vi.fn() }),
}));

class ResizeObserverStub {
  observe() {}
  unobserve() {}
  disconnect() {}
}
vi.stubGlobal("ResizeObserver", ResizeObserverStub);
Object.defineProperty(HTMLElement.prototype, "getBoundingClientRect", {
  configurable: true,
  value: () => ({
    width: 400,
    height: 280,
    top: 0,
    left: 0,
    bottom: 280,
    right: 400,
    x: 0,
    y: 0,
    toJSON() {},
  }),
});

const session: AuthSession = {
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-company_admin",
};

class FakeGateway implements AuthGateway {
  async getIdToken() {
    return "id-token";
  }
  observe(listener: (value: AuthSession | null) => void) {
    listener(session);
    return () => undefined;
  }
  async refreshSession() {
    return session;
  }
  async sendEmailVerification() {}
  async sendPasswordResetEmail() {}
  async signIn() {
    return session;
  }
  async signOut() {}
}

function renderAssetWidgets(getDashboardAssetsSummary: ReturnType<typeof vi.fn>) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(["assets.read"]),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    getDashboardAssetsSummary,
  };
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={new FakeGateway()}>
          <PermissionProvider initialPermissions={["assets.read"]}>
            <DashboardWidgetGrid />
          </PermissionProvider>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

beforeEach(() => {
  mockPush.mockClear();
});

describe("asset dashboard widgets", () => {
  it("renders the real seeded counts, never a hardcoded value", async () => {
    renderAssetWidgets(
      vi.fn(async () => ({
        total: 11,
        healthy: 8,
        warning: 2,
        critical: 1,
        byCategory: [],
        byFacility: [],
      })),
    );
    await waitFor(() => expect(screen.getByText("11")).toBeInTheDocument());
    expect(screen.getByText("1")).toBeInTheDocument();
  });

  it("reflects a different mocked count, proving the value is not hardcoded", async () => {
    renderAssetWidgets(
      vi.fn(async () => ({
        total: 42,
        healthy: 30,
        warning: 10,
        critical: 2,
        byCategory: [],
        byFacility: [],
      })),
    );
    await waitFor(() => expect(screen.getByText("42")).toBeInTheDocument());
    expect(screen.getByText("2")).toBeInTheDocument();
    expect(screen.queryByText("11")).not.toBeInTheDocument();
  });

  it("shows the condition chart's empty state for a zero-count tenant", async () => {
    renderAssetWidgets(
      vi.fn(async () => ({
        total: 0,
        healthy: 0,
        warning: 0,
        critical: 0,
        byCategory: [],
        byFacility: [],
      })),
    );
    expect(await screen.findByText("No assets to chart yet")).toBeInTheDocument();
    await waitFor(() => expect(screen.getAllByText("0").length).toBeGreaterThan(0));
  });

  it("navigates to the pre-filtered assets list when the Critical Assets card is clicked", async () => {
    renderAssetWidgets(
      vi.fn(async () => ({
        total: 11,
        healthy: 8,
        warning: 2,
        critical: 1,
        byCategory: [],
        byFacility: [],
      })),
    );
    await waitFor(() => expect(screen.getByText("1")).toBeInTheDocument());
    await userEvent.setup().click(screen.getByText("Critical assets").closest("section")!);
    expect(mockPush).toHaveBeenCalledWith("/assets?status=Critical");
  });

  it("navigates to the unfiltered assets list when the Total Assets card is clicked", async () => {
    renderAssetWidgets(
      vi.fn(async () => ({
        total: 11,
        healthy: 8,
        warning: 2,
        critical: 1,
        byCategory: [],
        byFacility: [],
      })),
    );
    await waitFor(() => expect(screen.getByText("11")).toBeInTheDocument());
    await userEvent.setup().click(screen.getByText("Total assets").closest("section")!);
    expect(mockPush).toHaveBeenCalledWith("/assets");
  });
});
