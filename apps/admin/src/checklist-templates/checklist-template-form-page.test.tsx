import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { ChecklistTemplateFormPage } from "./checklist-template-form-page";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({
    back: vi.fn(),
    prefetch: vi.fn(),
    push: pushMock,
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
    async sendPasswordResetEmail() {},
    async signIn() {
      return session;
    },
    async signOut() {},
  };
}

function DashboardWithPermissions({ templateId }: { templateId?: string }) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <ChecklistTemplateFormPage templateId={templateId} />
    </PermissionProvider>
  );
}

function renderForm({
  templateId,
  createChecklistTemplate = vi.fn(async () => ({
    id: "template-new",
    name: "New Template",
    category: "Generic",
    version: 1,
    items: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  })),
  updateChecklistTemplate = vi.fn(async () => ({
    id: templateId ?? "template-1",
    name: "Updated Template",
    category: "Generic",
    version: 2,
    items: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  })),
  getChecklistTemplate = vi.fn(async () => ({
    id: templateId ?? "template-1",
    name: "Existing Template",
    category: "Pumps",
    description: "A pump checklist",
    version: 1,
    items: [
      { id: "item-1", label: "Looks fine", itemType: "boolean", required: true },
    ],
    createdAt: new Date(),
    updatedAt: new Date(),
  })),
}: {
  templateId?: string;
  createChecklistTemplate?: ReturnType<typeof vi.fn>;
  updateChecklistTemplate?: ReturnType<typeof vi.fn>;
  getChecklistTemplate?: ReturnType<typeof vi.fn>;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(["checklist_templates.read", "checklist_templates.write"]),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    createChecklistTemplate,
    updateChecklistTemplate,
    getChecklistTemplate,
    deleteChecklistTemplate: vi.fn(async () => ({ id: templateId, deleted: true })),
  };
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <DashboardWithPermissions templateId={templateId} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

describe("checklist template form page", () => {
  it("creates a template with a single checklist item", async () => {
    const createChecklistTemplate = vi.fn(async () => ({
      id: "template-new",
      name: "New Template",
      category: "Generic",
      version: 1,
      items: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    }));
    renderForm({ createChecklistTemplate });
    await screen.findByRole("heading", { name: "Create template" });
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Name"), "New Template");
    await user.type(screen.getByLabelText("Label"), "Looks fine");
    await user.click(screen.getByRole("button", { name: "Create template" }));
    expect(createChecklistTemplate).toHaveBeenCalledWith(
      expect.objectContaining({
        name: "New Template",
        items: [expect.objectContaining({ label: "Looks fine", itemType: "boolean" })],
      }),
    );
    expect(pushMock).toHaveBeenCalledWith("/checklist-templates/template-new");
  });

  it("rejects a select item with no options", async () => {
    renderForm();
    await screen.findByRole("heading", { name: "Create template" });
    const user = userEvent.setup();
    await user.type(screen.getByLabelText("Name"), "New Template");
    await user.type(screen.getByLabelText("Label"), "Condition");
    await user.selectOptions(screen.getByLabelText("Type"), "select");
    await user.click(screen.getByRole("button", { name: "Create template" }));
    expect(await screen.findByText("Select items need at least one option")).toBeInTheDocument();
  });

  it("loads an existing template for editing and prefills its fields", async () => {
    renderForm({ templateId: "template-1" });
    expect(await screen.findByDisplayValue("Existing Template")).toBeInTheDocument();
    expect(screen.getByDisplayValue("Looks fine")).toBeInTheDocument();
  });

  it("saves changes to an existing template", async () => {
    const updateChecklistTemplate = vi.fn(async () => ({
      id: "template-1",
      name: "Existing Template Updated",
      category: "Pumps",
      version: 2,
      items: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    }));
    renderForm({ templateId: "template-1", updateChecklistTemplate });
    await screen.findByDisplayValue("Existing Template");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Save changes" }));
    expect(updateChecklistTemplate).toHaveBeenCalledWith(
      "template-1",
      expect.objectContaining({ name: "Existing Template" }),
    );
    expect(pushMock).toHaveBeenCalledWith("/checklist-templates/template-1");
  });
});
