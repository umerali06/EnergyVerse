import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { AuditLogPage } from "./audit-page";

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

function auditEntry(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "event-1",
    actorUid: "demo-acme-field_inspector",
    actorName: "Acme Field Inspector",
    actorRole: "Field Inspector",
    action: "user.updated",
    targetType: "user",
    targetId: "demo-acme-field_inspector",
    metadata: { before: { status: "inactive" }, after: { status: "active" } },
    createdAt: new Date("2026-07-20T10:00:00Z"),
    ...overrides,
  };
}

async function findRow(text: string) {
  const body = await screen.findByTestId("audit-table-body");
  return within(body).findByText(text);
}

function Screen({
  permissions,
  reducedMotionOverride,
}: {
  permissions: string[];
  reducedMotionOverride?: boolean;
}) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <RequirePermission permission="audit.read">
        <AuditLogPage reducedMotionOverride={reducedMotionOverride} />
      </RequirePermission>
    </PermissionProvider>
  );
}

function renderAudit({
  permissions = ["audit.read"],
  listAuditLogs = vi.fn(async () => ({ items: [auditEntry()], nextCursor: null, truncated: false })),
  getAuditLogFacets = vi.fn(async () => ({ actions: ["user.updated"], targetTypes: ["user"] })),
  listUsers = vi.fn(async () => ({
    items: [{ id: "demo-acme-field_inspector", displayName: "Acme Field Inspector" }],
    nextCursor: null,
  })),
  exportAuditLogs = vi.fn(async () => "timestamp,actor_uid\n"),
  reducedMotionOverride,
}: {
  permissions?: string[];
  listAuditLogs?: ReturnType<typeof vi.fn>;
  getAuditLogFacets?: ReturnType<typeof vi.fn>;
  listUsers?: ReturnType<typeof vi.fn>;
  exportAuditLogs?: ReturnType<typeof vi.fn>;
  reducedMotionOverride?: boolean;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    companyTimezone: "America/Chicago",
    companyLocale: "en-US",
    roleKey: "company_admin",
    permissions: new Set(permissions),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    registerCompanyAdmin: vi.fn(),
    listAuditLogs,
    getAuditLogFacets,
    listUsers,
    exportAuditLogs,
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <Screen permissions={permissions} reducedMotionOverride={reducedMotionOverride} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("audit log page", () => {
  it("shows a loading state and then the real tenant audit entries", async () => {
    let resolveList!: (value: { items: unknown[]; nextCursor: null; truncated: boolean }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderAudit({ listAuditLogs: vi.fn(() => deferred) });
    await screen.findByText("Audit Log");
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [auditEntry()], nextCursor: null, truncated: false });
    expect(await findRow("Acme Field Inspector")).toBeInTheDocument();
  });

  it("denies a role without audit.read with the branded 403", async () => {
    renderAudit({ permissions: ["reports.read"] });
    expect(await screen.findByText("403 — No access")).toBeInTheDocument();
  });

  it("shows an honest empty state when no events match", async () => {
    renderAudit({ listAuditLogs: vi.fn(async () => ({ items: [], nextCursor: null, truncated: false })) });
    expect(await screen.findByText("No events found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listAuditLogs = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderAudit({ listAuditLogs });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listAuditLogs.mockResolvedValueOnce({ items: [auditEntry()], nextCursor: null, truncated: false });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listAuditLogs).toHaveBeenCalledTimes(2));
  });

  it("refetches with the selected action filter", async () => {
    const listAuditLogs = vi.fn(async (_options?: Record<string, unknown>) => ({
      items: [auditEntry()],
      nextCursor: null,
      truncated: false,
    }));
    renderAudit({ listAuditLogs });
    await findRow("Acme Field Inspector");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Action"), "user.updated");
    await waitFor(() =>
      expect(listAuditLogs.mock.calls.at(-1)?.[0]).toMatchObject({ action: "user.updated" }),
    );
  });

  it("expands a row to reveal the before/after diff", async () => {
    renderAudit();
    await findRow("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { expanded: false }));
    expect(await screen.findByText("Before")).toBeInTheDocument();
    expect(screen.getByText("After")).toBeInTheDocument();
    expect(screen.getByText(/"inactive"/)).toBeInTheDocument();
    expect(screen.getByText(/"active"/)).toBeInTheDocument();
  });

  it("shows a truncated-range notice when the server caps the window", async () => {
    renderAudit({
      listAuditLogs: vi.fn(async () => ({
        items: [auditEntry()],
        nextCursor: null,
        truncated: true,
      })),
    });
    expect(await screen.findByText(/more events than can be shown/i)).toBeInTheDocument();
  });

  it("disables export when there are no results", async () => {
    renderAudit({ listAuditLogs: vi.fn(async () => ({ items: [], nextCursor: null, truncated: false })) });
    await screen.findByText("No events found");
    expect(screen.getByRole("button", { name: "Export CSV" })).toBeDisabled();
  });

  it("exports the filtered set as a downloaded CSV", async () => {
    const createObjectURL = vi.fn(() => "blob:mock-url");
    const revokeObjectURL = vi.fn();
    vi.stubGlobal("URL", { ...URL, createObjectURL, revokeObjectURL });
    const exportAuditLogs = vi.fn(async () => "timestamp,actor_uid\n2026-07-20T10:00:00Z,demo\n");
    renderAudit({ exportAuditLogs });
    await findRow("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Export CSV" }));
    await waitFor(() => expect(exportAuditLogs).toHaveBeenCalledTimes(1));
    expect(createObjectURL).toHaveBeenCalledTimes(1);
    vi.unstubAllGlobals();
  });

  it("renders without animation on the reduced-motion path", async () => {
    const { container } = renderAudit({ reducedMotionOverride: true });
    await findRow("Acme Field Inspector");
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });

  it("shows the exact timestamp in the tenant timezone on hover", async () => {
    renderAudit();
    await findRow("Acme Field Inspector");
    const timestamp = screen.getByTitle(/2026/);
    expect(timestamp).toBeInTheDocument();
  });
});
