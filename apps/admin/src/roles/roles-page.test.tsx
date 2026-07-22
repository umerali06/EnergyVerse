import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { RolesPage } from "./roles-page";

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

const catalog = {
  groups: [
    {
      group: "assets",
      items: [
        { key: "assets.read", group: "assets", description: "View assets" },
        { key: "assets.write", group: "assets", description: "Create and update assets" },
      ],
    },
    {
      group: "users",
      items: [{ key: "users.manage", group: "users", description: "Manage company users" }],
    },
    {
      group: "platform",
      items: [{ key: "platform.admin", group: "platform", description: "Administer the FEV platform" }],
    },
  ],
};

function roleSummary(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "role-hr",
    key: "role-hr",
    name: "HR Manager",
    description: "Handles onboarding",
    isSystem: false,
    permissionCount: 1,
    assignedUserCount: 0,
    ...overrides,
  };
}

function roleDetailFor(summary: ReturnType<typeof roleSummary>, permissionKeys: string[] = ["users.manage"]) {
  return { ...summary, permissionKeys };
}

function DashboardWithPermissions() {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <RolesPage />
    </PermissionProvider>
  );
}

function renderRoles({
  permissions = ["roles.manage", "users.manage"],
  listRoles = vi.fn(async () => ({ items: [roleSummary()] })),
  listPermissionCatalog = vi.fn(async () => catalog),
  getRole = vi.fn(async (roleId: string) => roleDetailFor(roleSummary({ id: roleId }))),
  createRole = vi.fn(async () => roleDetailFor(roleSummary({ id: "new-role", name: "New Role" }))),
  updateRole = vi.fn(async (roleId: string) => roleDetailFor(roleSummary({ id: roleId }))),
  deleteRole = vi.fn(async () => ({ id: "role-hr", deleted: true })),
}: {
  permissions?: string[];
  listRoles?: ReturnType<typeof vi.fn>;
  listPermissionCatalog?: ReturnType<typeof vi.fn>;
  getRole?: ReturnType<typeof vi.fn>;
  createRole?: ReturnType<typeof vi.fn>;
  updateRole?: ReturnType<typeof vi.fn>;
  deleteRole?: ReturnType<typeof vi.fn>;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(permissions),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    registerCompanyAdmin: vi.fn(),
    listRoles,
    listPermissionCatalog,
    getRole: (roleId: string) => getRole(roleId),
    createRole: (request: unknown) => createRole(request),
    updateRole: (roleId: string, request: unknown) => updateRole(roleId, request),
    deleteRole: (roleId: string) => deleteRole(roleId),
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <DashboardWithPermissions />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("roles page", () => {
  it("shows a loading state and then the role list", async () => {
    let resolveList!: (value: { items: unknown[] }) => void;
    const deferred = new Promise((resolve) => {
      resolveList = resolve as typeof resolveList;
    });
    const { container } = renderRoles({ listRoles: vi.fn(() => deferred) });
    await screen.findByRole("button", { name: "Create role" });
    expect(container.querySelector(".animate-shimmer")).toBeInTheDocument();
    resolveList({ items: [roleSummary()] });
    expect(await screen.findByText("HR Manager")).toBeInTheDocument();
  });

  it("shows an honest empty state when no roles exist", async () => {
    renderRoles({ listRoles: vi.fn(async () => ({ items: [] })) });
    expect(await screen.findByText("No roles found")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the list request fails", async () => {
    const listRoles = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderRoles({ listRoles });
    const retry = await screen.findByRole("button", { name: "Retry" });
    listRoles.mockResolvedValueOnce({ items: [roleSummary()] });
    await userEvent.setup().click(retry);
    await waitFor(() => expect(listRoles).toHaveBeenCalledTimes(2));
  });

  it("creates a blank role with the checked permissions", async () => {
    const createRole = vi.fn(async () => roleDetailFor(roleSummary({ id: "new-role", name: "New Role" })));
    renderRoles({ createRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Create role" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.type(dialog.getByLabelText("Name"), "New Role");
    await user.click(dialog.getByLabelText("assets.read", { exact: false }));
    await user.click(dialog.getByRole("button", { name: "Create role" }));
    await waitFor(() =>
      expect(createRole).toHaveBeenCalledWith({
        name: "New Role",
        description: "",
        permissionKeys: ["assets.read"],
        cloneFromRoleId: undefined,
      }),
    );
  });

  it("does not offer platform.admin to a Company Admin", async () => {
    renderRoles();
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Create role" }));
    const dialog = within(screen.getByRole("dialog"));
    expect(dialog.queryByLabelText("platform.admin")).not.toBeInTheDocument();
  });

  it("clones permissions from an existing role", async () => {
    const createRole = vi.fn(async () => roleDetailFor(roleSummary({ id: "clone-role" })));
    renderRoles({ createRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Create role" }));
    const dialog = within(screen.getByRole("dialog"));
    await user.type(dialog.getByLabelText("Name"), "Cloned");
    await user.selectOptions(dialog.getByLabelText("Clone from"), "role-hr");
    expect(dialog.queryByTestId("permission-matrix")).not.toBeInTheDocument();
    await user.click(dialog.getByRole("button", { name: "Create role" }));
    await waitFor(() =>
      expect(createRole).toHaveBeenCalledWith({
        name: "Cloned",
        description: "",
        permissionKeys: [],
        cloneFromRoleId: "role-hr",
      }),
    );
  });

  it("renders a system role as read-only with no edit or delete actions", async () => {
    const getRole = vi.fn(async () =>
      roleDetailFor(
        roleSummary({ id: "role-admin", name: "Company Admin", isSystem: true, assignedUserCount: 1 }),
        ["users.manage", "roles.manage"],
      ),
    );
    renderRoles({ getRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    expect(await screen.findByText(/System roles are read-only/)).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Edit" })).not.toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Delete" })).not.toBeInTheDocument();
  });

  it("shows an impact warning and permission diff before saving a role with assigned users", async () => {
    const getRole = vi.fn(async () =>
      roleDetailFor(roleSummary({ assignedUserCount: 3 }), ["users.manage"]),
    );
    const updateRole = vi.fn(async () =>
      roleDetailFor(roleSummary({ assignedUserCount: 3 }), ["users.manage", "assets.read"]),
    );
    renderRoles({ getRole, updateRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    await screen.findByText("users.manage");
    await user.click(screen.getByRole("button", { name: "Edit" }));
    await user.click(screen.getByLabelText("assets.read", { exact: false }));
    await user.click(screen.getByRole("button", { name: "Save" }));
    expect(updateRole).not.toHaveBeenCalled();
    expect(await screen.findByText(/3 users currently/)).toBeInTheDocument();
    expect(screen.getByText("+ assets.read")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Confirm save" }));
    await waitFor(() =>
      expect(updateRole).toHaveBeenCalledWith("role-hr", {
        permissionKeys: ["users.manage", "assets.read"],
      }),
    );
  });

  it("saves immediately when no users are assigned to the role", async () => {
    const getRole = vi.fn(async () => roleDetailFor(roleSummary({ assignedUserCount: 0 }), ["users.manage"]));
    const updateRole = vi.fn(async () =>
      roleDetailFor(roleSummary({ assignedUserCount: 0 }), ["assets.read"]),
    );
    renderRoles({ getRole, updateRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    await screen.findByText("users.manage");
    await user.click(screen.getByRole("button", { name: "Edit" }));
    await user.click(screen.getByLabelText("users.manage", { exact: false }));
    await user.click(screen.getByLabelText("assets.read", { exact: false }));
    await user.click(screen.getByRole("button", { name: "Save" }));
    await waitFor(() =>
      expect(updateRole).toHaveBeenCalledWith("role-hr", {
        permissionKeys: ["assets.read"],
      }),
    );
  });

  it("blocks delete when users are assigned and links to the filtered users list", async () => {
    const getRole = vi.fn(async () => roleDetailFor(roleSummary({ assignedUserCount: 2 })));
    renderRoles({ getRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    await screen.findByText("users.manage");
    expect(screen.getByRole("button", { name: "Delete" })).toBeDisabled();
    expect(screen.getByRole("link", { name: "View assigned users" })).toHaveAttribute(
      "href",
      "/users?roleId=role-hr",
    );
  });

  it("deletes an unassigned role after confirmation", async () => {
    const getRole = vi.fn(async () => roleDetailFor(roleSummary({ assignedUserCount: 0 })));
    const deleteRole = vi.fn(async () => ({ id: "role-hr", deleted: true }));
    renderRoles({ getRole, deleteRole });
    await screen.findByText("HR Manager");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "View" }));
    await screen.findByText("users.manage");
    await user.click(screen.getByRole("button", { name: "Delete" }));
    expect(deleteRole).not.toHaveBeenCalled();
    await user.click(screen.getByRole("button", { name: "Confirm delete" }));
    await waitFor(() => expect(deleteRole).toHaveBeenCalledWith("role-hr"));
  });
});
