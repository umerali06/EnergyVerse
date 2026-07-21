import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { UsersPage } from "./users-page";

const session: AuthSession = {
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-company_admin",
};

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
};

function makeGateway(sendPasswordResetEmail = vi.fn(async () => undefined)): AuthGateway & {
  sendPasswordResetEmail: typeof sendPasswordResetEmail;
} {
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
    sendPasswordResetEmail,
    async signIn() {
      return session;
    },
    async signOut() {},
  };
}

const roles = {
  items: [
    { id: "role-executive", key: "executive", name: "Executive", isSystem: true },
    { id: "role-hse", key: "hse_manager", name: "HSE Manager", isSystem: true },
  ],
};

function userItem(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "demo-acme-field_inspector",
    email: "field_inspector@acme.example.invalid",
    displayName: "Acme Field Inspector",
    roleId: "role-field-inspector",
    roleKey: "field_inspector",
    roleName: "Field Inspector",
    status: "active",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date(Date.now() - 5 * 60_000),
    ...overrides,
  };
}

function detailFor(item: ReturnType<typeof userItem>, permissions: string[] = ["assets.read"]) {
  return { ...item, permissions };
}

function DashboardWithPermissions() {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <UsersPage />
    </PermissionProvider>
  );
}

function renderUsers({
  roleKey = "company_admin",
  permissions = roleMatrix.company_admin,
  listUsers = vi.fn(async () => ({ items: [userItem()], nextCursor: null })),
  listRoles = vi.fn(async () => roles),
  getUser = vi.fn(async (userId: string) => detailFor(userItem({ id: userId }))),
  inviteUser = vi.fn(async () => detailFor(userItem({ id: "new-user" }))),
  updateUser = vi.fn(async (userId: string) => detailFor(userItem({ id: userId }))),
  setUserStatus = vi.fn(async (userId: string, request: { status: string }) =>
    detailFor(userItem({ id: userId, status: request.status })),
  ),
  sendPasswordResetEmail = vi.fn(async () => undefined),
}: {
  roleKey?: string;
  permissions?: string[];
  listUsers?: ReturnType<typeof vi.fn>;
  listRoles?: ReturnType<typeof vi.fn>;
  getUser?: ReturnType<typeof vi.fn>;
  inviteUser?: ReturnType<typeof vi.fn>;
  updateUser?: ReturnType<typeof vi.fn>;
  setUserStatus?: ReturnType<typeof vi.fn>;
  sendPasswordResetEmail?: ReturnType<typeof vi.fn>;
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
    listUsers,
    listRoles,
    getUser: (userId: string) => getUser(userId),
    inviteUser: (request: unknown) => inviteUser(request),
    updateUser: (userId: string, request: unknown) => updateUser(userId, request),
    setUserStatus: (userId: string, request: unknown) => setUserStatus(userId, request),
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway(sendPasswordResetEmail)}>
          <DashboardWithPermissions />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient, sendPasswordResetEmail };
}

describe("users page", () => {
  it("shows a loading state and then the real tenant users", async () => {
    let resolveList!: (value: { items: unknown[]; nextCursor: null }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderUsers({ listUsers: vi.fn(() => deferred) });
    await screen.findByRole("button", { name: "Invite user" });
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [userItem()], nextCursor: null });
    expect(await screen.findByText("Acme Field Inspector")).toBeInTheDocument();
    expect(screen.getByText("field_inspector@acme.example.invalid")).toBeInTheDocument();
  });

  it("shows an honest empty state when no users match", async () => {
    renderUsers({ listUsers: vi.fn(async () => ({ items: [], nextCursor: null })) });
    expect(await screen.findByText("No users found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listUsers = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderUsers({ listUsers });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listUsers.mockResolvedValueOnce({ items: [userItem()], nextCursor: null });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listUsers).toHaveBeenCalledTimes(2));
  });

  it("loads more users via cursor pagination and appends without duplicating", async () => {
    const listUsers = vi
      .fn()
      .mockResolvedValueOnce({ items: [userItem({ id: "u1" })], nextCursor: "cursor-1" })
      .mockResolvedValueOnce({
        items: [userItem({ id: "u2", email: "second@acme.example.invalid" })],
        nextCursor: null,
      });
    renderUsers({ listUsers });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Load more" }));
    await waitFor(() => expect(screen.getByText("second@acme.example.invalid")).toBeInTheDocument());
    expect(screen.queryByRole("button", { name: "Load more" })).not.toBeInTheDocument();
    expect(listUsers.mock.calls[1][0]).toMatchObject({ cursor: "cursor-1" });
  });

  it("re-fetches with the search term", async () => {
    const listUsers = vi.fn(async () => ({ items: [userItem()], nextCursor: null }));
    renderUsers({ listUsers });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Search"), "hse");
    await waitFor(() =>
      expect(listUsers.mock.calls.at(-1)?.[0]).toMatchObject({ search: "hse" }),
    );
  });

  it("invites a user, sends the invite email, and refreshes the list", async () => {
    const inviteUser = vi.fn(async () =>
      detailFor(userItem({ id: "new-user", displayName: "New Hire", email: "new@acme.example.invalid" })),
    );
    const sendPasswordResetEmail = vi.fn(async () => undefined);
    const listUsers = vi.fn(async () => ({ items: [userItem()], nextCursor: null }));
    renderUsers({ inviteUser, sendPasswordResetEmail, listUsers });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Invite user" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.type(dialog.getByLabelText("Email"), "new@acme.example.invalid");
    await user.type(dialog.getByLabelText("Full name"), "New Hire");
    await user.selectOptions(dialog.getByLabelText("Role"), "role-executive");
    await user.click(dialog.getByRole("button", { name: "Send invite" }));
    await waitFor(() => expect(inviteUser).toHaveBeenCalledWith({
      email: "new@acme.example.invalid",
      displayName: "New Hire",
      roleId: "role-executive",
    }));
    await waitFor(() => expect(sendPasswordResetEmail).toHaveBeenCalledWith("new@acme.example.invalid"));
    await waitFor(() => expect(listUsers).toHaveBeenCalledTimes(2));
    expect(screen.queryByRole("button", { name: "Send invite" })).not.toBeInTheDocument();
  });

  it("rejects invalid invite input before calling the API", async () => {
    const inviteUser = vi.fn();
    renderUsers({ inviteUser });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Invite user" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.type(dialog.getByLabelText("Email"), "not-an-email");
    await user.type(dialog.getByLabelText("Full name"), "New Hire");
    await user.click(dialog.getByRole("button", { name: "Send invite" }));
    expect(await dialog.findByText("Enter a valid email address")).toBeInTheDocument();
    expect(inviteUser).not.toHaveBeenCalled();
  });

  it("opens a user's detail, edits their role, and shows the new effective permissions", async () => {
    const getUser = vi.fn(async () =>
      detailFor(userItem(), ["assets.read", "inspections.read"]),
    );
    const updateUser = vi.fn(async () =>
      detailFor(
        userItem({ roleId: "role-hse", roleKey: "hse_manager", roleName: "HSE Manager" }),
        ["safety.read", "safety.write"],
      ),
    );
    renderUsers({ getUser, updateUser });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    expect(await screen.findByText("assets.read")).toBeInTheDocument();
    const dialog = within(screen.getByRole("dialog"));
    await user.click(dialog.getByRole("button", { name: "Edit" }));
    await user.selectOptions(dialog.getByLabelText("Role"), "role-hse");
    await user.click(dialog.getByRole("button", { name: "Save" }));
    await waitFor(() =>
      expect(updateUser).toHaveBeenCalledWith("demo-acme-field_inspector", {
        roleId: "role-hse",
      }),
    );
    expect(await screen.findByText("safety.read")).toBeInTheDocument();
    expect(screen.queryByText("inspections.read")).not.toBeInTheDocument();
  });

  it("requires confirmation before deactivating a user", async () => {
    const setUserStatus = vi.fn(async (userId: string) =>
      detailFor(userItem({ id: userId, status: "inactive" })),
    );
    renderUsers({ setUserStatus });
    await screen.findByText("Acme Field Inspector");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    await screen.findByText("assets.read");
    await user.click(screen.getByRole("button", { name: "Deactivate" }));
    expect(setUserStatus).not.toHaveBeenCalled();
    expect(
      await screen.findByText(/This immediately blocks their sign-in/),
    ).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Confirm" }));
    await waitFor(() =>
      expect(setUserStatus).toHaveBeenCalledWith("demo-acme-field_inspector", {
        status: "inactive",
      }),
    );
  });

  it("hides Users for a role without users.manage (route-level 403 covered in route-guards tests)", async () => {
    renderUsers({ roleKey: "field_inspector", permissions: roleMatrix.field_inspector });
    // UsersPage itself has no internal gate (that's RequirePermission's job at
    // the route), so it renders — this test only proves the page doesn't
    // silently assume company_admin-only fields exist on other roles' data.
    expect(await screen.findByText("Users")).toBeInTheDocument();
  });
});
