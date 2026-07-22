import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { useSyncExternalStore } from "react";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { RequireAuth } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { DashboardPage } from "@/dashboard/dashboard-page";

import { AppShell, ComingSoonScreen, NotFoundScreen, sidebarPreferenceKey } from "./app-shell";

const routerControl = vi.hoisted(() => {
  type Snapshot = { path: string; search: string };
  const parse = (url: string): Snapshot => {
    const [path, search = ""] = url.split("?");
    return { path, search };
  };
  let current: Snapshot = parse("/");
  const listeners = new Set<() => void>();
  const emit = () => listeners.forEach((listener) => listener());
  return {
    get current() {
      return current;
    },
    reset(url = "/") {
      current = parse(url);
    },
    push(url: string) {
      current = parse(url);
      emit();
    },
    replace(url: string) {
      current = parse(url);
      emit();
    },
    subscribe(listener: () => void) {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
  };
});

vi.mock("next/navigation", async () => {
  const { useSyncExternalStore: useStore } = await import("react");
  return {
    usePathname: () => useStore(routerControl.subscribe, () => routerControl.current.path),
    useSearchParams: () =>
      new URLSearchParams(useStore(routerControl.subscribe, () => routerControl.current.search)),
    useRouter: () => ({
      back: () => undefined,
      prefetch: () => undefined,
      push: routerControl.push,
      replace: routerControl.replace,
    }),
  };
});

/** Mirror of the Phase 0.4 SYSTEM_ROLE_TEMPLATES matrix (apps/api/app/rbac/constants.py).
 * If this drifts from the API, the table-driven expectations below are wrong. */
const roleMatrix: Record<string, string[]> = {
  company_admin: [
    "assets.read",
    "assets.write",
    "inspections.read",
    "inspections.write",
    "permits.read",
    "permits.approve",
    "work_orders.read",
    "work_orders.write",
    "reports.read",
    "reports.generate",
    "safety.read",
    "safety.write",
    "users.manage",
    "roles.manage",
    "company.settings",
  ],
  operations_manager: [
    "assets.read",
    "assets.write",
    "inspections.read",
    "permits.read",
    "work_orders.read",
    "work_orders.write",
    "reports.read",
    "reports.generate",
    "safety.read",
  ],
  field_inspector: [
    "assets.read",
    "inspections.read",
    "inspections.write",
    "permits.read",
    "work_orders.read",
    "reports.read",
    "reports.generate",
    "safety.read",
    "safety.write",
  ],
  executive: [
    "assets.read",
    "inspections.read",
    "permits.read",
    "work_orders.read",
    "reports.read",
    "safety.read",
  ],
};

const allNavLabels = [
  "Dashboard",
  "Assets",
  "Inspections",
  "Work Orders",
  "Permits",
  "Safety",
  "Reports",
  "Documents",
  "Users",
  "Roles",
  "Admin & Settings",
];

const session: AuthSession = {
  email: "field_inspector@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "firebase-uid",
};

class FakeGateway implements AuthGateway {
  signOutCalls = 0;

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

  async signOut() {
    this.signOutCalls += 1;
  }
}

function setViewportWidth(width: number) {
  Object.defineProperty(window, "matchMedia", {
    configurable: true,
    value: (query: string) => {
      const match = /min-width:\s*(\d+)px/.exec(query);
      const minWidth = match ? Number(match[1]) : 0;
      return {
        addEventListener: () => undefined,
        addListener: () => undefined,
        dispatchEvent: () => false,
        matches: width >= minWidth && minWidth > 0,
        media: query,
        onchange: null,
        removeEventListener: () => undefined,
        removeListener: () => undefined,
      };
    },
  });
}

const comingSoonRoutes: Record<string, string> = {
  "/assets": "Assets",
  "/inspections": "Inspections",
  "/work-orders": "Work Orders",
  "/permits": "Permits",
  "/safety": "Safety",
  "/reports": "Reports",
  "/documents": "Documents",
  "/settings": "Admin & Settings",
};

function ShellHarness({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const path = useSyncExternalStore(routerControl.subscribe, () => routerControl.current.path);
  let page: React.ReactNode;
  if (path === "/") {
    page = <DashboardPage reducedMotionOverride={reducedMotionOverride} />;
  } else if (comingSoonRoutes[path]) {
    page = <ComingSoonScreen moduleName={comingSoonRoutes[path]} />;
  } else if (path === "/login") {
    return <p>Login screen</p>;
  } else {
    page = <NotFoundScreen />;
  }
  return (
    <RequireAuth>
      <AppShell reducedMotionOverride={reducedMotionOverride}>{page}</AppShell>
    </RequireAuth>
  );
}

function renderShell({
  permissions = roleMatrix.field_inspector,
  roleKey = "field_inspector",
  initialPath = "/",
  width = 1280,
  gateway = new FakeGateway(),
  reducedMotionOverride,
}: {
  permissions?: string[];
  roleKey?: string;
  initialPath?: string;
  width?: number;
  gateway?: FakeGateway;
  reducedMotionOverride?: boolean;
} = {}) {
  setViewportWidth(width);
  routerControl.reset(initialPath);
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
    // Real-shaped fixtures so DashboardPage (mounted at "/" by every test
    // that doesn't override initialPath) resolves to a stable ready state.
    getDashboardSummary: vi.fn(async () => ({
      companyName: "Acme Energy",
      subscriptionTier: "standard",
      companyCreatedAt: new Date("2026-01-01T00:00:00Z"),
      usersTotal: 7,
      usersActive: 7,
      rolesTotal: 7,
      auditEvents: 3,
      windowDays: 30,
    })),
    getDashboardActivity: vi.fn(async () => ({ items: [], nextCursor: null })),
    getDashboardActivitySeries: vi.fn(async () => ({
      windowDays: 30,
      points: Array.from({ length: 30 }, (_, index) => ({
        date: new Date(Date.now() - (29 - index) * 86_400_000),
        count: 0,
      })),
    })),
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={gateway}>
          <ShellHarness reducedMotionOverride={reducedMotionOverride} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, gateway };
}

function navLabels(): string[] {
  const nav = screen.getByRole("navigation", { name: "Primary" });
  return within(nav)
    .getAllByRole("link")
    .map((link) => link.textContent ?? "");
}

describe("app shell", () => {
  const adminOnlyLabels = new Set(["Users", "Roles", "Admin & Settings"]);
  it.each([
    ["company_admin", allNavLabels],
    ["operations_manager", allNavLabels.filter((label) => !adminOnlyLabels.has(label))],
    ["field_inspector", allNavLabels.filter((label) => !adminOnlyLabels.has(label))],
    ["executive", allNavLabels.filter((label) => !adminOnlyLabels.has(label))],
  ])("renders exactly the permitted nav items for %s", async (roleKey, expected) => {
    renderShell({ permissions: roleMatrix[roleKey], roleKey });
    await screen.findByRole("navigation", { name: "Primary" });
    expect(navLabels()).toEqual(expected);
  });

  it("renders only the gated items a minimal custom permission set allows", async () => {
    renderShell({ permissions: ["safety.read"], roleKey: "custom_safety_viewer" });
    await screen.findByRole("navigation", { name: "Primary" });
    // Dashboard and Documents carry no requiredPermission by design.
    expect(navLabels()).toEqual(["Dashboard", "Safety", "Documents"]);
  });

  it("hides Platform Admin from a company_admin without platform.admin (3.5)", async () => {
    renderShell({ permissions: roleMatrix.company_admin, roleKey: "company_admin" });
    await screen.findByRole("navigation", { name: "Primary" });
    expect(navLabels()).not.toContain("Platform Admin");
  });

  it("shows Platform Admin to a super_admin holding platform.admin (3.5)", async () => {
    renderShell({
      permissions: [...roleMatrix.company_admin, "platform.admin"],
      roleKey: "super_admin",
    });
    await screen.findByRole("navigation", { name: "Primary" });
    expect(navLabels()).toContain("Platform Admin");
  });

  it("routes on nav click, highlights the active item, and lands on Coming soon", async () => {
    renderShell();
    const user = userEvent.setup();
    const nav = await screen.findByRole("navigation", { name: "Primary" });
    expect(within(nav).getByRole("link", { name: /Dashboard/ })).toHaveAttribute(
      "aria-current",
      "page",
    );
    await user.click(within(nav).getByRole("link", { name: /Assets/ }));
    expect(routerControl.current.path).toBe("/assets");
    expect(await screen.findByText("Assets is coming soon")).toBeInTheDocument();
    expect(within(nav).getByRole("link", { name: /Assets/ })).toHaveAttribute(
      "aria-current",
      "page",
    );
    expect(within(nav).getByRole("link", { name: /Dashboard/ })).not.toHaveAttribute(
      "aria-current",
    );
    expect(screen.getByRole("heading", { level: 1, name: "Assets" })).toBeInTheDocument();
  });

  it("persists the collapsed sidebar preference across renders", async () => {
    const { unmount } = renderShell();
    const user = userEvent.setup();
    const sidebar = await screen.findByTestId("app-sidebar");
    expect(sidebar).toHaveAttribute("data-collapsed", "false");
    await user.click(screen.getByRole("button", { name: "Collapse sidebar" }));
    expect(sidebar).toHaveAttribute("data-collapsed", "true");
    expect(window.localStorage.getItem(sidebarPreferenceKey)).toBe("true");
    unmount();

    renderShell();
    const restored = await screen.findByTestId("app-sidebar");
    await waitFor(() => expect(restored).toHaveAttribute("data-collapsed", "true"));
    expect(screen.getByRole("button", { name: "Expand sidebar" })).toBeInTheDocument();
  });

  it("forces the icon-only rail on tablet without a toggle", async () => {
    renderShell({ width: 800 });
    const sidebar = await screen.findByTestId("app-sidebar");
    await waitFor(() => expect(sidebar).toHaveAttribute("data-collapsed", "true"));
    expect(screen.queryByRole("button", { name: /sidebar/ })).not.toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Open navigation menu" })).not.toBeInTheDocument();
  });

  it("opens a focus-trapped mobile drawer that closes on escape and route change", async () => {
    renderShell({ width: 500 });
    const user = userEvent.setup();
    await waitFor(() => expect(screen.queryByTestId("app-sidebar")).not.toBeInTheDocument());
    await user.click(await screen.findByRole("button", { name: "Open navigation menu" }));
    const drawer = await screen.findByRole("dialog", { name: "Navigation menu" });

    // Focus starts inside and Tab wraps from the last focusable to the first.
    const focusable = within(drawer).getAllByRole("link");
    const closeButton = within(drawer).getByRole("button", { name: "Close navigation menu" });
    expect(drawer.contains(document.activeElement)).toBe(true);
    focusable[focusable.length - 1].focus();
    await user.tab();
    expect(drawer.contains(document.activeElement)).toBe(true);
    expect(document.activeElement).toBe(closeButton);

    await user.keyboard("{Escape}");
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();

    await user.click(screen.getByRole("button", { name: "Open navigation menu" }));
    const reopened = await screen.findByRole("dialog", { name: "Navigation menu" });
    await user.click(within(reopened).getByRole("link", { name: /Safety/ }));
    expect(routerControl.current.path).toBe("/safety");
    await waitFor(() => expect(screen.queryByRole("dialog")).not.toBeInTheDocument());
    expect(await screen.findByText("Safety is coming soon")).toBeInTheDocument();
  });

  it("shows identity in the user menu and signs out through it", async () => {
    const gateway = new FakeGateway();
    renderShell({ gateway });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "User menu" }));
    const menu = screen.getByRole("menu", { name: "User menu" });
    expect(within(menu).getByText("Field Inspector")).toBeInTheDocument();
    expect(within(menu).getByText("field_inspector@acme.example.invalid")).toBeInTheDocument();
    expect(within(menu).getByText("field_inspector")).toBeInTheDocument();
    expect(within(menu).getByText("Acme Energy")).toBeInTheDocument();
    await user.click(within(menu).getByRole("menuitem", { name: "Sign out" }));
    expect(gateway.signOutCalls).toBe(1);
    await waitFor(() => expect(routerControl.current.path).toBe("/login"));
  });

  it("marks search and notifications as disabled placeholders", async () => {
    renderShell();
    const search = await screen.findByLabelText(/Global search/);
    expect(search).toBeDisabled();
    expect(search).toHaveAttribute("placeholder", "Search — coming soon");
    expect(screen.getByRole("button", { name: "Notifications (coming soon)" })).toBeDisabled();
  });

  it("exposes a skip link, landmarks, and a keyboard-reachable nav", async () => {
    renderShell();
    await screen.findByRole("navigation", { name: "Primary" });
    const skipLink = screen.getByRole("link", { name: "Skip to content" });
    expect(skipLink).toHaveAttribute("href", "#main-content");
    expect(screen.getByRole("banner")).toBeInTheDocument();
    expect(screen.getByRole("main")).toHaveAttribute("id", "main-content");
    const user = userEvent.setup();
    await user.tab();
    expect(document.activeElement).toBe(skipLink);
    await user.tab();
    expect(document.activeElement).toHaveTextContent("Dashboard");
  });

  it("renders the branded 404 inside the shell for unknown routes", async () => {
    renderShell({ initialPath: "/does-not-exist" });
    expect(await screen.findByText("This page doesn't exist")).toBeInTheDocument();
    expect(screen.getByRole("navigation", { name: "Primary" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { level: 1, name: "Not found" })).toBeInTheDocument();
  });

  it("renders without animation on the reduced-motion path", async () => {
    const { container } = renderShell({ reducedMotionOverride: true });
    await screen.findByRole("navigation", { name: "Primary" });
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });
});
