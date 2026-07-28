import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { designTokens } from "@/design-system/tokens.generated";

import { DashboardPage } from "./dashboard-page";

// DashboardPage's Quick Actions and asset KPI widgets use next/navigation's
// router. `mockPush` is mutable so the one test that cares about navigation
// (the Critical Assets card) can observe it; every other test leaves it as a
// no-op stub.
let mockPush = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: () => undefined, push: mockPush, replace: vi.fn() }),
}));

// jsdom has no real layout: recharts' ResponsiveContainer measures via
// ResizeObserver + getBoundingClientRect and renders nothing at 0×0. Give it
// a stable non-zero size so the chart SVG actually mounts.
class ResizeObserverStub {
  observe() {}
  unobserve() {}
  disconnect() {}
}
vi.stubGlobal("ResizeObserver", ResizeObserverStub);
Object.defineProperty(HTMLElement.prototype, "getBoundingClientRect", {
  configurable: true,
  value: () => ({
    width: 800,
    height: 280,
    top: 0,
    left: 0,
    bottom: 280,
    right: 800,
    x: 0,
    y: 0,
    toJSON() {},
  }),
});

const session: AuthSession = {
  email: "field_inspector@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "firebase-uid",
};

/** Mirrors the 0.4 SYSTEM_ROLE_TEMPLATES matrix (apps/api/app/rbac/constants.py).
 * Only company_admin/super_admin hold users.manage and roles.manage. */
const roleMatrix: Record<string, string[]> = {
  company_admin: [
    "assets.read",
    "reports.read",
    "reports.generate",
    "users.manage",
    "roles.manage",
    "company.settings",
  ],
  field_inspector: ["assets.read", "reports.read", "reports.generate"],
  operations_manager: ["assets.read", "assets.write", "reports.read", "reports.generate"],
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

const readySummary = {
  companyName: "Acme Energy",
  subscriptionTier: "standard",
  companyCreatedAt: new Date("2026-01-01T00:00:00Z"),
  usersTotal: 7,
  usersActive: 6,
  rolesTotal: 7,
  auditEvents: 12,
  windowDays: 30,
};

const emptySummary = {
  ...readySummary,
  usersTotal: 1,
  usersActive: 1,
  auditEvents: 0,
};

const readyAssetsSummary = {
  total: 11,
  healthy: 8,
  warning: 2,
  critical: 1,
  byCategory: [],
  byFacility: [],
};

function seriesFor(window: number, nonZeroCount = 0) {
  return {
    windowDays: window,
    points: Array.from({ length: window }, (_, index) => ({
      date: new Date(Date.now() - (window - 1 - index) * 86_400_000),
      count: index === window - 1 ? nonZeroCount : 0,
    })),
  };
}

function activityItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "evt-1",
    actorUid: "demo-acme-field_inspector",
    actorName: "Acme Field Inspector",
    action: "company.updated",
    targetType: "company",
    targetId: "acme-energy",
    createdAt: new Date(Date.now() - 5 * 60_000),
    ...overrides,
  };
}

/** Seeds PermissionProvider from the resolved identity, same as RequireAuth
 * does in route-guards.tsx — scoped narrowly here since these tests exercise
 * DashboardPage directly rather than the full router/shell stack. */
function DashboardWithPermissions({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
}) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <DashboardPage reducedMotionOverride={reducedMotionOverride} />
    </PermissionProvider>
  );
}

function renderDashboard({
  roleKey = "field_inspector",
  permissions = roleMatrix.field_inspector,
  getDashboardSummary = vi.fn(async () => readySummary),
  getDashboardActivity = vi.fn(async () => ({ items: [activityItem()], nextCursor: null })),
  getDashboardActivitySeries = vi.fn(async () => seriesFor(30, 4)),
  getDashboardAssetsSummary = vi.fn(async () => readyAssetsSummary),
  reducedMotionOverride,
}: {
  roleKey?: string;
  permissions?: string[];
  getDashboardSummary?: ReturnType<typeof vi.fn>;
  getDashboardActivity?: ReturnType<typeof vi.fn>;
  getDashboardActivitySeries?: ReturnType<typeof vi.fn>;
  getDashboardAssetsSummary?: ReturnType<typeof vi.fn>;
  reducedMotionOverride?: boolean;
} = {}) {
  const identity = {
    uid: "firebase-uid",
    email: "field_inspector@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey,
    permissions: new Set(permissions),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    registerCompanyAdmin: vi.fn(),
    getDashboardSummary,
    getDashboardActivity,
    getDashboardActivitySeries,
    getDashboardAssetsSummary,
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={new FakeGateway()}>
          <DashboardWithPermissions reducedMotionOverride={reducedMotionOverride} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("dashboard page", () => {
  it("shows loading skeletons and then renders the real summary data", async () => {
    let resolveSummary!: (value: typeof readySummary) => void;
    const deferred = new Promise<typeof readySummary>((resolve) => {
      resolveSummary = resolve;
    });
    const { container } = renderDashboard({
      roleKey: "company_admin",
      permissions: roleMatrix.company_admin,
      getDashboardSummary: vi.fn(() => deferred),
    });
    await screen.findByText("Users in company");
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveSummary(readySummary);
    await waitFor(() => expect(screen.getAllByText("7")).toHaveLength(2)); // usersTotal + rolesTotal
    expect(screen.getByText("6")).toBeInTheDocument(); // usersActive
    expect(container.querySelector(".animate-shimmer")).not.toBeInTheDocument();
  });

  it("renders the honest empty state for a fresh tenant with no activity", async () => {
    renderDashboard({
      roleKey: "company_admin",
      permissions: roleMatrix.company_admin,
      getDashboardSummary: vi.fn(async () => emptySummary),
      getDashboardActivity: vi.fn(async () => ({ items: [], nextCursor: null })),
      getDashboardActivitySeries: vi.fn(async () => seriesFor(30, 0)),
    });
    expect(await screen.findByText("No activity to chart yet")).toBeInTheDocument();
    expect(await screen.findByText("No activity yet")).toBeInTheDocument();
    expect(screen.getAllByText("0").length).toBeGreaterThan(0);
  });

  it("shows a retry-capable error state when the summary request fails", async () => {
    const getDashboardSummary = vi.fn().mockRejectedValue(new Error("boom"));
    renderDashboard({ getDashboardSummary });
    const retryButtons = await screen.findAllByRole("button", { name: "Retry" });
    expect(retryButtons.length).toBeGreaterThan(0);
    expect(getDashboardSummary).toHaveBeenCalledTimes(1);
    const user = userEvent.setup();
    await user.click(retryButtons[0]);
    await waitFor(() => expect(getDashboardSummary).toHaveBeenCalledTimes(2));
  });

  it("shows the activity feed's own error state independently of the chart", async () => {
    renderDashboard({ getDashboardActivity: vi.fn().mockRejectedValue(new Error("down")) });
    expect(
      await screen.findByText("Couldn't load recent activity. Check your connection and try again."),
    ).toBeInTheDocument();
  });

  it("refetches summary and series when the window switcher changes", async () => {
    const getDashboardSummary = vi.fn(async () => readySummary);
    const getDashboardActivitySeries = vi.fn(async () => seriesFor(30, 4));
    renderDashboard({ getDashboardSummary, getDashboardActivitySeries });
    await screen.findByText("Activity");
    await waitFor(() => expect(getDashboardSummary).toHaveBeenCalledWith(30));
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "7 days" }));
    await waitFor(() => expect(getDashboardSummary).toHaveBeenCalledWith(7));
    await waitFor(() => expect(getDashboardActivitySeries).toHaveBeenCalledWith(7));
    expect(screen.getByRole("button", { name: "7 days" })).toHaveAttribute("aria-pressed", "true");
  });

  it("loads more activity via cursor pagination and appends without duplicating", async () => {
    const getDashboardActivity = vi
      .fn()
      .mockResolvedValueOnce({
        items: [activityItem({ id: "evt-1" })],
        nextCursor: "cursor-1",
      })
      .mockResolvedValueOnce({
        items: [activityItem({ id: "evt-2", action: "user.provisioned" })],
        nextCursor: null,
      });
    renderDashboard({ getDashboardActivity });
    const feed = await screen.findByTestId("activity-feed");
    expect(within(feed).getAllByRole("listitem")).toHaveLength(1);
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Load more" }));
    await waitFor(() => expect(within(feed).getAllByRole("listitem")).toHaveLength(2));
    expect(screen.queryByRole("button", { name: "Load more" })).not.toBeInTheDocument();
    expect(getDashboardActivity).toHaveBeenCalledTimes(2);
    expect(getDashboardActivity.mock.calls[1][0]).toMatchObject({ cursor: "cursor-1" });
  });

  it.each([
    ["company_admin", ["Users in company", "Active users", "Roles configured"]],
    ["field_inspector", []],
    ["operations_manager", []],
  ])("shows exactly the permission-gated stat cards for %s", async (roleKey, expectedExtra) => {
    renderDashboard({ roleKey, permissions: roleMatrix[roleKey] });
    await screen.findByText(/Audit events/);
    for (const label of ["Users in company", "Active users", "Roles configured"]) {
      if (expectedExtra.includes(label)) {
        expect(screen.getByText(label)).toBeInTheDocument();
      } else {
        expect(screen.queryByText(label)).not.toBeInTheDocument();
      }
    }
  });

  it("renders real asset KPI widgets for assets.read holders, never a placeholder", async () => {
    renderDashboard({ roleKey: "field_inspector", permissions: ["assets.read", "reports.read"] });
    expect(await screen.findByText("Total assets")).toBeInTheDocument();
    expect(screen.getByText("Critical assets")).toBeInTheDocument();
    expect(screen.getByText("Asset condition")).toBeInTheDocument();
    await waitFor(() => expect(screen.getByText("11")).toBeInTheDocument());
    expect(screen.getByText("1")).toBeInTheDocument();
    // The old static "Asset metrics appear once enabled" tile is gone now
    // that assets is a real, registered widget.
    expect(
      screen.queryByText("Asset metrics appear once the Assets module is enabled."),
    ).not.toBeInTheDocument();
  });

  it("does not render asset widgets for a role without assets.read", async () => {
    renderDashboard({ roleKey: "custom", permissions: ["reports.read"] });
    await screen.findByText(/Audit events/);
    expect(screen.queryByText("Total assets")).not.toBeInTheDocument();
    expect(screen.queryByText("Critical assets")).not.toBeInTheDocument();
  });

  it("navigates to the filtered asset list when the Critical Assets card is clicked", async () => {
    mockPush = vi.fn();
    renderDashboard({ roleKey: "field_inspector", permissions: ["assets.read", "reports.read"] });
    await waitFor(() => expect(screen.getByText("1")).toBeInTheDocument());
    await userEvent.setup().click(screen.getByText("Critical assets").closest("section")!);
    expect(mockPush).toHaveBeenCalledWith("/assets?status=Critical");
  });

  it("shows the reserved KPI empty state only for modules that don't exist yet", async () => {
    renderDashboard({
      roleKey: "custom",
      permissions: ["assets.read", "reports.read", "work_orders.read"],
    });
    expect(await screen.findByText("Work Orders")).toBeInTheDocument();
    expect(
      screen.getByText("Work order metrics appear once the Work Orders module is enabled."),
    ).toBeInTheDocument();
    expect(screen.queryByText("Permits")).not.toBeInTheDocument();
    expect(screen.queryByText("Safety & Incidents")).not.toBeInTheDocument();
  });

  it("shows each asset widget's own error state without breaking the rest of the dashboard", async () => {
    renderDashboard({
      roleKey: "field_inspector",
      permissions: ["assets.read", "reports.read"],
      getDashboardAssetsSummary: vi.fn().mockRejectedValue(new Error("boom")),
    });
    await screen.findByText("Activity");
    // The condition chart's own error state (D-020's chart wrapper), not a
    // dashboard-wide crash.
    expect(await screen.findByText("Couldn't load this chart")).toBeInTheDocument();
    // Everything else on the dashboard (unrelated to the asset endpoint)
    // keeps working.
    expect(screen.getByText("Recent activity")).toBeInTheDocument();
    expect(screen.getByText("Total assets")).toBeInTheDocument();
  });

  it("renders without animation on the reduced-motion path", async () => {
    const { container } = renderDashboard({ reducedMotionOverride: true });
    await screen.findByText("Activity");
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });

  it("draws the chart using design-token colors, never a hardcoded hex", async () => {
    const { container } = renderDashboard({
      getDashboardActivitySeries: vi.fn(async () => seriesFor(30, 6)),
    });
    await screen.findByText("Activity");
    const path = await waitFor(() => {
      const found = container.querySelector("path.recharts-area-curve");
      if (!found) throw new Error("chart path not rendered yet");
      return found;
    });
    const stroke = path.getAttribute("stroke");
    expect(stroke).toBe(designTokens.color.primary["400"]);
  });
});
