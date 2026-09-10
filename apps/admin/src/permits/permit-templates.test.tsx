import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { PermitTemplateFormPage } from "./permit-template-form-page";
import { PermitTemplatesPage } from "./permit-templates-page";

const pushMock = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: pushMock, replace: vi.fn() }) }));

const session: AuthSession = { email: "admin@acme.test", emailVerified: true, getIdToken: vi.fn(async (..._args: unknown[]) => "token"), uid: "admin" };
const gateway: AuthGateway = {
  async getIdToken() { return "token"; },
  observe(listener) { listener(session); return () => undefined; },
  async refreshSession() { return session; },
  async sendEmailVerification() {}, async sendPasswordResetEmail() {},
  async signIn() { return session; }, async signOut() {},
};

function Harness({ apiClient, permissions, children }: { apiClient: Record<string, unknown>; permissions: string[]; children: React.ReactNode }) {
  const identity = { uid: "admin", email: "admin@acme.test", emailVerified: true, companyId: "acme", companyName: "Acme", roleKey: "company_admin", permissions: new Set(permissions) };
  return <ThemeProvider><ToastProvider><AuthProvider gateway={gateway} apiClient={{ registerCompanyAdmin: vi.fn(), getCurrentUser: vi.fn(async (..._args: unknown[]) => identity), ...apiClient }}><Ready>{children}</Ready></AuthProvider></ToastProvider></ThemeProvider>;
}

function Ready({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  return auth.status === "authenticated" ? children : <p>restoring</p>;
}

const template = {
  id: "pt-1", name: "Hot work standard", permitType: "hot_work" as const, description: "Controlled welding", version: 3,
  checklistItems: [{ id: "c1", label: "Gas test complete", required: true }],
  approvalSteps: [{ id: "a1", label: "HSE approval", approverRoleId: "role-hse", required: true }],
  createdAt: new Date("2026-08-01T00:00:00Z"), updatedAt: new Date("2026-08-19T00:00:00Z"),
};
const roles = { items: [{ id: "role-hse", key: "hse_manager", name: "HSE Manager", description: "Safety", isSystem: true, permissionCount: 1, assignedUserCount: 1 }] };

describe("permit template admin", () => {
  it("lists real templates and filters by permit type", async () => {
    const listPermitTemplates = vi.fn(async (..._args: unknown[]) => ({ items: [template], nextCursor: null }));
    render(<Harness permissions={["permits.read", "permits.write"]} apiClient={{ listPermitTemplates }}><PermitTemplatesPage /></Harness>);
    expect(await screen.findByText("Hot work standard")).toBeInTheDocument();
    await userEvent.setup().selectOptions(screen.getByLabelText("Permit type"), "confined_space");
    await waitFor(() => expect(listPermitTemplates.mock.calls.at(-1)?.[0]).toMatchObject({ permitType: "confined_space" }));
  });

  it("keeps template mutation controls hidden for read-only roles", async () => {
    render(<Harness permissions={["permits.read"]} apiClient={{ listPermitTemplates: vi.fn(async (..._args: unknown[]) => ({ items: [template], nextCursor: null })) }}><PermitTemplatesPage /></Harness>);
    await screen.findByText("Hot work standard");
    expect(screen.queryByRole("button", { name: "Create template" })).not.toBeInTheDocument();
    await userEvent.setup().click(screen.getByText("Hot work standard"));
    expect(pushMock).not.toHaveBeenCalled();
  });

  it("creates an ordered template using a real tenant role", async () => {
    const createPermitTemplate = vi.fn(async (..._args: unknown[]) => ({ ...template, id: "pt-new", version: 1 }));
    render(<Harness permissions={["permits.read", "permits.write"]} apiClient={{ listRoles: vi.fn(async (..._args: unknown[]) => roles), createPermitTemplate }}><PermitTemplateFormPage /></Harness>);
    await screen.findByRole("heading", { name: "Create permit template" });
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Name"), "Hot work standard");
    await user.type(screen.getByLabelText("Control 1"), "Gas test complete");
    await user.type(screen.getByLabelText("Step 1 label"), "HSE approval");
    await user.selectOptions(screen.getByLabelText("Approver role"), "role-hse");
    await user.click(screen.getByRole("button", { name: "Create template" }));
    expect(createPermitTemplate).toHaveBeenCalledWith(expect.objectContaining({ checklistItems: [expect.objectContaining({ label: "Gas test complete" })], approvalSteps: [expect.objectContaining({ approverRoleId: "role-hse" })] }));
    expect(pushMock).toHaveBeenCalledWith("/permits/templates/pt-new");
  });

  it("saves an edit with the loaded optimistic version", async () => {
    const updatePermitTemplate = vi.fn(async (..._args: unknown[]) => ({ ...template, version: 4 }));
    render(<Harness permissions={["permits.write"]} apiClient={{ listRoles: vi.fn(async (..._args: unknown[]) => roles), getPermitTemplate: vi.fn(async (..._args: unknown[]) => template), updatePermitTemplate }}><PermitTemplateFormPage templateId="pt-1" /></Harness>);
    await screen.findByDisplayValue("Hot work standard");
    await userEvent.setup().click(screen.getByRole("button", { name: "Save new version" }));
    expect(updatePermitTemplate).toHaveBeenCalledWith("pt-1", expect.objectContaining({ expectedVersion: 3 }));
  });

  it("validates checklist and approval labels before a write", async () => {
    const createPermitTemplate = vi.fn();
    render(<Harness permissions={["permits.write"]} apiClient={{ listRoles: vi.fn(async (..._args: unknown[]) => roles), createPermitTemplate }}><PermitTemplateFormPage /></Harness>);
    await screen.findByRole("heading", { name: "Create permit template" });
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Name"), "Valid template name");
    await user.click(screen.getByRole("button", { name: "Create template" }));
    expect(await screen.findAllByText("Label is required")).toHaveLength(2);
    expect(createPermitTemplate).not.toHaveBeenCalled();
  });

  it("renders a branded permission state when permits.write is absent", async () => {
    render(<Harness permissions={["permits.read"]} apiClient={{}}><PermitTemplateFormPage /></Harness>);
    expect(await screen.findByText("No access")).toBeInTheDocument();
    expect(screen.getByText("permits.write is required to manage permit templates.")).toBeInTheDocument();
  });
});
