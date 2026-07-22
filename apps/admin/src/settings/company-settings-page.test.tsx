import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { RequirePermission } from "@/auth/route-guards";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { CompanySettingsPage } from "./company-settings-page";

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

function companyProfile(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "acme-energy",
    name: "Acme Energy",
    industry: "Electric Utility",
    timezone: "America/Chicago",
    locale: "en-US",
    contactEmail: "ops@acme.example.invalid",
    contactPhone: "+1-555-0100",
    subscriptionTier: "professional",
    logoUrl: null,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    usersTotal: 12,
    rolesTotal: 6,
    ...overrides,
  };
}

function Screen({ permissions }: { permissions: string[] }) {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <RequirePermission permission="company.settings">
        <CompanySettingsPage />
      </RequirePermission>
    </PermissionProvider>
  );
}

function renderSettings({
  permissions = ["company.settings"],
  getCompany = vi.fn(async () => companyProfile()),
  updateCompany = vi.fn(async (request: Record<string, unknown>) =>
    companyProfile(request),
  ),
  uploadCompanyLogo = vi.fn(async () => companyProfile({ logoUrl: "https://storage.example/logo" })),
  removeCompanyLogo = vi.fn(async () => companyProfile({ logoUrl: null })),
}: {
  permissions?: string[];
  getCompany?: ReturnType<typeof vi.fn>;
  updateCompany?: ReturnType<typeof vi.fn>;
  uploadCompanyLogo?: ReturnType<typeof vi.fn>;
  removeCompanyLogo?: ReturnType<typeof vi.fn>;
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
    getCompany,
    updateCompany,
    uploadCompanyLogo,
    removeCompanyLogo,
  };
  const view = render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <Screen permissions={permissions} />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, apiClient };
}

describe("company settings page", () => {
  it("shows a loading state and then the profile", async () => {
    let resolveGet!: (value: ReturnType<typeof companyProfile>) => void;
    const deferred = new Promise((resolve) => {
      resolveGet = resolve as typeof resolveGet;
    });
    const { container } = renderSettings({ getCompany: vi.fn(() => deferred) });
    await waitFor(() => expect(container.querySelector(".animate-shimmer")).toBeInTheDocument());
    resolveGet(companyProfile());
    expect(await screen.findByDisplayValue("Acme Energy")).toBeInTheDocument();
  });

  it("shows a retry-capable error state when the profile request fails", async () => {
    const getCompany = vi.fn().mockRejectedValueOnce(new Error("boom"));
    renderSettings({ getCompany });
    const retry = await screen.findByRole("button", { name: "Retry" });
    getCompany.mockResolvedValueOnce(companyProfile());
    await userEvent.setup().click(retry);
    await waitFor(() => expect(getCompany).toHaveBeenCalledTimes(2));
    expect(await screen.findByDisplayValue("Acme Energy")).toBeInTheDocument();
  });

  it("denies a role without company.settings with the branded 403", async () => {
    renderSettings({ permissions: ["reports.read"] });
    expect(await screen.findByText("403 — No access")).toBeInTheDocument();
    expect(screen.getByText("company.settings")).toBeInTheDocument();
  });

  it("tracks dirty state, saves changes, and discards them", async () => {
    const updateCompany = vi.fn(async (request: Record<string, unknown>) =>
      companyProfile(request),
    );
    renderSettings({ updateCompany });
    const nameField = await screen.findByDisplayValue("Acme Energy");
    expect(screen.getByRole("button", { name: "Save" })).toBeDisabled();

    const user = userEvent.setup();
    await user.clear(nameField);
    await user.type(nameField, "Acme Energy Holdings");
    expect(screen.getByRole("button", { name: "Save" })).toBeEnabled();

    await user.click(screen.getByRole("button", { name: "Discard" }));
    expect(nameField).toHaveValue("Acme Energy");
    expect(screen.getByRole("button", { name: "Save" })).toBeDisabled();

    await user.clear(nameField);
    await user.type(nameField, "Acme Energy Holdings");
    await user.click(screen.getByRole("button", { name: "Save" }));
    await waitFor(() =>
      expect(updateCompany).toHaveBeenCalledWith(
        expect.objectContaining({ name: "Acme Energy Holdings" }),
      ),
    );
    expect(await screen.findByText(/Company settings saved/)).toBeInTheDocument();
  }, 15000); // two full clear+type roundtrips legitimately exceed the 5s default

  it("rejects an empty company name before saving", async () => {
    const updateCompany = vi.fn(async (request: Record<string, unknown>) =>
      companyProfile(request),
    );
    renderSettings({ updateCompany });
    const nameField = await screen.findByDisplayValue("Acme Energy");
    const user = userEvent.setup();
    await user.clear(nameField);
    await user.type(nameField, "A");
    await user.click(screen.getByRole("button", { name: "Save" }));
    expect(await screen.findByText("Enter a company name")).toBeInTheDocument();
    expect(updateCompany).not.toHaveBeenCalled();
  });

  it("uploads a logo with a preview and allows removing it", async () => {
    const uploadCompanyLogo = vi.fn(
      async () => companyProfile({ logoUrl: "https://storage.example/logo" }),
    );
    const removeCompanyLogo = vi.fn(async () => companyProfile({ logoUrl: null }));
    renderSettings({ uploadCompanyLogo, removeCompanyLogo });
    await screen.findByDisplayValue("Acme Energy");

    const file = new File(["logo-bytes"], "logo.png", { type: "image/png" });
    const input = screen.getByLabelText("Company logo file", { exact: false });
    await userEvent.setup().upload(input, file);

    await waitFor(() => expect(uploadCompanyLogo).toHaveBeenCalledWith(file));
    expect(await screen.findByText(/Logo updated/)).toBeInTheDocument();

    const removeButton = await screen.findByRole("button", { name: "Remove" });
    await userEvent.setup().click(removeButton);
    await waitFor(() => expect(removeCompanyLogo).toHaveBeenCalled());
    expect(await screen.findByText(/Logo removed/)).toBeInTheDocument();
  });

  it("rejects an oversized logo before uploading", async () => {
    const uploadCompanyLogo = vi.fn(async () => companyProfile());
    renderSettings({ uploadCompanyLogo });
    await screen.findByDisplayValue("Acme Energy");

    const tooLarge = new File([new Uint8Array(5 * 1024 * 1024 + 1)], "logo.png", {
      type: "image/png",
    });
    const input = screen.getByLabelText("Company logo file", { exact: false });
    await userEvent.setup().upload(input, tooLarge);
    expect(await screen.findByText(/must be 5 MB or smaller/)).toBeInTheDocument();
    expect(uploadCompanyLogo).not.toHaveBeenCalled();
  });

  it("rejects a wrong-type logo dropped onto the dropzone", async () => {
    // userEvent.upload() enforces the input's `accept` filter itself, so a
    // mismatched type never reaches the change handler that way -- drag/drop
    // bypasses `accept`, which is exactly the path client validation guards.
    const uploadCompanyLogo = vi.fn(async () => companyProfile());
    renderSettings({ uploadCompanyLogo });
    await screen.findByDisplayValue("Acme Energy");

    const wrongType = new File(["gif-bytes"], "logo.gif", { type: "image/gif" });
    const dropzone = screen.getByTestId("logo-dropzone");
    fireEvent.drop(dropzone, { dataTransfer: { files: [wrongType] } });

    expect(await screen.findByText(/must be a PNG, JPEG, or WEBP/)).toBeInTheDocument();
    expect(uploadCompanyLogo).not.toHaveBeenCalled();
  });
});
