import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { PlatformPage } from "./platform-page";

vi.mock("next/navigation", () => ({
  useRouter: () => ({
    back: vi.fn(),
    prefetch: vi.fn(),
    push: vi.fn(),
    replace: vi.fn(),
  }),
}));

const session: AuthSession = {
  email: "super_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-super_admin",
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
    sendPasswordResetEmail: vi.fn(async () => undefined),
    async signIn() {
      return session;
    },
    async signOut() {},
  };
}

function company(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "acme-energy",
    name: "Acme Energy",
    status: "active",
    subscriptionTier: "professional",
    usersTotal: 12,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function companyDetail(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    ...company(overrides),
    industry: "Electric Utility",
    contactEmail: "ops@acme.example.invalid",
    rolesTotal: 7,
    ...overrides,
  };
}

function stats(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    totalCompanies: 2,
    totalUsers: 19,
    activeTenants: 2,
    recentSignups: 1,
    windowDays: 30,
    ...overrides,
  };
}

function Screen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <RequirePermission permission="platform.admin">
        <PlatformPage reducedMotionOverride={reducedMotionOverride} />
      </RequirePermission>
    </PermissionProvider>
  );
}

function renderPlatform({
  permissions = ["platform.admin"],
  listPlatformCompanies = vi.fn(async () => ({
    items: [company(), company({ id: "beta-utilities", name: "Beta Utilities", usersTotal: 7 })],
    nextCursor: null,
  })),
  getPlatformStats = vi.fn(async () => stats()),
  getPlatformCompany = vi.fn(async () => companyDetail()),
  updatePlatformCompanyStatus = vi.fn(async () => companyDetail({ status: "suspended" })),
  updatePlatformCompany = vi.fn(async () => companyDetail({ subscriptionTier: "enterprise" })),
  reducedMotionOverride,
}: {
  permissions?: string[];
  listPlatformCompanies?: ReturnType<typeof vi.fn>;
  getPlatformStats?: ReturnType<typeof vi.fn>;
  getPlatformCompany?: ReturnType<typeof vi.fn>;
  updatePlatformCompanyStatus?: ReturnType<typeof vi.fn>;
  updatePlatformCompany?: ReturnType<typeof vi.fn>;
  reducedMotionOverride?: boolean;
} = {}) {
  const identity = {
    uid: "demo-acme-super_admin",
    email: "super_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "super_admin",
    permissions: new Set(permissions),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    registerCompanyAdmin: vi.fn(),
    listPlatformCompanies,
    getPlatformStats,
    getPlatformCompany,
    updatePlatformCompanyStatus,
    updatePlatformCompany,
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <Screen reducedMotionOverride={reducedMotionOverride} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("platform administration page", () => {
  it("shows a loading state and then real tenants with user counts", async () => {
    let resolveList!: (value: { items: unknown[]; nextCursor: null }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderPlatform({ listPlatformCompanies: vi.fn(() => deferred) });
    await screen.findByText("Platform Administration");
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [company(), company({ id: "beta-utilities", name: "Beta Utilities" })], nextCursor: null });
    expect(await screen.findByText("Acme Energy")).toBeInTheDocument();
    expect(screen.getByText("Beta Utilities")).toBeInTheDocument();
  });

  it("denies a role without platform.admin with the branded 403", async () => {
    renderPlatform({ permissions: ["company.settings"] });
    expect(await screen.findByText("403 — No access")).toBeInTheDocument();
  });

  it("shows an honest empty state when no companies exist", async () => {
    renderPlatform({
      listPlatformCompanies: vi.fn(async () => ({ items: [], nextCursor: null })),
    });
    expect(await screen.findByText("No companies found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listPlatformCompanies = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderPlatform({ listPlatformCompanies });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listPlatformCompanies.mockResolvedValueOnce({ items: [company()], nextCursor: null });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listPlatformCompanies).toHaveBeenCalledTimes(2));
  });

  it("renders real platform stats, not placeholder numbers", async () => {
    renderPlatform();
    await screen.findByText("Acme Energy");
    // totalCompanies and activeTenants are both 2 in this fixture, so assert
    // against the two stats with distinct values instead of an ambiguous "2".
    expect(await screen.findByText("19", { selector: "p" })).toBeInTheDocument();
    expect(screen.getByText("1", { selector: "p" })).toBeInTheDocument();
    expect(screen.getAllByText("2", { selector: "p" })).toHaveLength(2);
  });

  it("opens a confirmation before suspending, and cancel leaves status untouched", async () => {
    const updatePlatformCompanyStatus = vi.fn(async () => companyDetail({ status: "suspended" }));
    renderPlatform({ updatePlatformCompanyStatus });
    const user = userEvent.setup();
    await user.click((await screen.findAllByRole("button", { name: "View" }))[0]);
    await screen.findByText("Electric Utility");
    await user.click(screen.getByRole("button", { name: "Suspend company" }));
    expect(await screen.findByText("Suspend this company?")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Cancel" }));
    expect(updatePlatformCompanyStatus).not.toHaveBeenCalled();
  });

  it("suspends a company on confirm and reflects the new status", async () => {
    const updatePlatformCompanyStatus = vi.fn(async () => companyDetail({ status: "suspended" }));
    renderPlatform({ updatePlatformCompanyStatus });
    const user = userEvent.setup();
    await user.click((await screen.findAllByRole("button", { name: "View" }))[0]);
    await screen.findByText("Electric Utility");
    await user.click(screen.getByRole("button", { name: "Suspend company" }));
    await screen.findByText("Suspend this company?");
    await user.click(screen.getByRole("button", { name: "Suspend" }));
    await waitFor(() => expect(updatePlatformCompanyStatus).toHaveBeenCalledWith("acme-energy", { status: "suspended" }));
    expect(await screen.findByText("suspended")).toBeInTheDocument();
  });

  it("reactivates a suspended company on confirm", async () => {
    const updatePlatformCompanyStatus = vi.fn(async () => companyDetail({ status: "active" }));
    renderPlatform({
      getPlatformCompany: vi.fn(async () => companyDetail({ status: "suspended" })),
      updatePlatformCompanyStatus,
    });
    const user = userEvent.setup();
    await user.click((await screen.findAllByRole("button", { name: "View" }))[0]);
    await screen.findByText("Electric Utility");
    await user.click(screen.getByRole("button", { name: "Reactivate company" }));
    await screen.findByText("Reactivate this company?");
    await user.click(screen.getByRole("button", { name: "Reactivate" }));
    await waitFor(() => expect(updatePlatformCompanyStatus).toHaveBeenCalledWith("acme-energy", { status: "active" }));
  });

  it("updates the subscription tier and persists it", async () => {
    const updatePlatformCompany = vi.fn(async () => companyDetail({ subscriptionTier: "enterprise" }));
    renderPlatform({ updatePlatformCompany });
    const user = userEvent.setup();
    await user.click((await screen.findAllByRole("button", { name: "View" }))[0]);
    await screen.findByText("Electric Utility");
    await user.selectOptions(screen.getByLabelText("Subscription tier"), "enterprise");
    await user.click(screen.getByRole("button", { name: "Save tier" }));
    await waitFor(() =>
      expect(updatePlatformCompany).toHaveBeenCalledWith("acme-energy", { subscriptionTier: "enterprise" }),
    );
  });

  it("renders without animation on the reduced-motion path", async () => {
    const { container } = renderPlatform({ reducedMotionOverride: true });
    await screen.findByText("Acme Energy");
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });
});
