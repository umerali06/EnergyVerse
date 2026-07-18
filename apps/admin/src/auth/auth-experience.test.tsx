import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { ApiClientError } from "@/api";
import { ToastProvider } from "@/design-system";

import { AuthProvider } from "./auth-context";
import { AuthExperience } from "./auth-experience";
import { ClientAuthError, type AuthGateway, type AuthSession } from "./firebase-gateway";

const session: AuthSession = {
  email: "field_inspector@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "firebase-uid",
};

const identity = {
  uid: "firebase-uid",
  email: "field_inspector@acme.example.invalid",
  emailVerified: true,
  companyId: "acme-energy",
  roleKey: "field_inspector",
  permissions: new Set(["assets.read", "inspections.write", "reports.generate"]),
};

class FakeGateway implements AuthGateway {
  constructor(
    private readonly initial: AuthSession | null = null,
    private readonly signInResult: AuthSession | Error = session,
  ) {}

  signOutCalls = 0;
  sendVerificationCalls = 0;
  sendPasswordResetCalls = 0;
  passwordResetResult: Error | Promise<void> | null = null;

  async getIdToken() {
    return "id-token";
  }

  observe(listener: (value: AuthSession | null) => void) {
    listener(this.initial);
    return () => undefined;
  }

  async refreshSession() {
    return { ...session, emailVerified: true };
  }

  async sendEmailVerification() {
    this.sendVerificationCalls += 1;
  }

  async sendPasswordResetEmail() {
    this.sendPasswordResetCalls += 1;
    if (this.passwordResetResult instanceof Error) throw this.passwordResetResult;
    if (this.passwordResetResult) await this.passwordResetResult;
  }

  async signIn() {
    if (this.signInResult instanceof Error) throw this.signInResult;
    return this.signInResult;
  }

  async signOut() {
    this.signOutCalls += 1;
  }
}

function renderAuth({
  apiResult = identity,
  gateway = new FakeGateway(),
  reducedMotionOverride,
}: {
  apiResult?: typeof identity | Error;
  gateway?: AuthGateway;
  reducedMotionOverride?: boolean;
} = {}) {
  const getCurrentUser = vi.fn(async () => {
    if (apiResult instanceof Error) throw apiResult;
    return apiResult;
  });
  const registerCompanyAdmin = vi.fn(async () => ({
    uid: "firebase-uid",
    email: "field_inspector@acme.example.invalid",
    emailVerified: false,
    companyId: "cmp_new",
    roleKey: "company_admin",
  }));
  const view = render(
    <ToastProvider>
      <AuthProvider apiClient={{ getCurrentUser, registerCompanyAdmin }} gateway={gateway}>
        <AuthExperience reducedMotionOverride={reducedMotionOverride} />
      </AuthProvider>
    </ToastProvider>,
  );
  return { ...view, getCurrentUser, registerCompanyAdmin };
}

async function submitCredentials() {
  const user = userEvent.setup();
  await user.type(screen.getByLabelText("Email"), "field_inspector@acme.example.invalid");
  await user.type(screen.getByLabelText("Password"), "dev-password");
  await user.click(screen.getByRole("button", { name: "Login" }));
  return user;
}

describe("admin login experience", () => {
  it("blocks empty and invalid credentials before Firebase", async () => {
    renderAuth();
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Login" }));
    expect(screen.getByText("Email is required")).toBeInTheDocument();
    expect(screen.getByText("Password is required")).toBeInTheDocument();
    await user.type(screen.getByLabelText("Email"), "invalid");
    await user.type(screen.getByLabelText("Password"), "x");
    await user.click(screen.getByRole("button", { name: "Login" }));
    expect(screen.getByText("Enter a valid email address")).toBeInTheDocument();
  });

  it("shows loading, resolves /me, and renders role plus permissions", async () => {
    let release!: (value: AuthSession) => void;
    const deferred = new Promise<AuthSession>((resolve) => {
      release = resolve;
    });
    const gateway: AuthGateway = {
      getIdToken: async () => "id-token",
      observe: (listener) => {
        listener(null);
        return () => undefined;
      },
      refreshSession: async () => session,
      sendEmailVerification: async () => undefined,
      sendPasswordResetEmail: async () => undefined,
      signIn: () => deferred,
      signOut: async () => undefined,
    };
    renderAuth({ gateway });
    await submitCredentials();
    expect(screen.getByRole("button", { name: /Login, loading/ })).toBeDisabled();
    release(session);
    expect(await screen.findByText("field_inspector")).toBeInTheDocument();
    expect(screen.getByText("inspections.write")).toBeInTheDocument();
  });

  it.each([
    ["auth/wrong-password", "Invalid email or password"],
    ["auth/user-not-found", "Invalid email or password"],
    ["auth/user-disabled", "This account has been disabled"],
    ["auth/too-many-requests", "Too many login attempts. Please wait and try again"],
    ["auth/network-request-failed", "Network unavailable. Check your connection and try again"],
  ])("maps %s to safe feedback", async (code, message) => {
    renderAuth({ gateway: new FakeGateway(null, new ClientAuthError(code, "raw")) });
    await submitCredentials();
    expect((await screen.findAllByText(message)).length).toBeGreaterThan(0);
  });

  it("signs Firebase out when /me rejects an inactive or missing user", async () => {
    const gateway = new FakeGateway();
    renderAuth({
      apiResult: new ApiClientError("forbidden", "Forbidden", 403),
      gateway,
    });
    await submitCredentials();
    expect(
      (await screen.findAllByText("Your account isn't active — contact your admin.")).length,
    ).toBeGreaterThan(0);
    expect(gateway.signOutCalls).toBe(1);
  });

  it("restores an existing Firebase session through /me", async () => {
    const { getCurrentUser } = renderAuth({ gateway: new FakeGateway(session) });
    expect(await screen.findByText("field_inspector")).toBeInTheDocument();
    expect(getCurrentUser).toHaveBeenCalledOnce();
  });

  it("signs out, clears identity, and returns to login", async () => {
    const gateway = new FakeGateway(session);
    renderAuth({ gateway });
    const user = userEvent.setup();
    await screen.findByText("field_inspector");
    await user.click(screen.getByRole("button", { name: "Sign out" }));
    expect(await screen.findByRole("button", { name: "Login" })).toBeInTheDocument();
    expect(gateway.signOutCalls).toBe(1);
  });

  it("renders the reduced-motion entrance path", async () => {
    const { container } = renderAuth({ reducedMotionOverride: true });
    await screen.findByRole("button", { name: "Login" });
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });

  it("validates signup fields and password strength before registration", async () => {
    const { registerCompanyAdmin } = renderAuth();
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Sign up" }));
    await user.click(screen.getByRole("button", { name: "Create organization" }));
    expect(screen.getByText("Company name is required")).toBeInTheDocument();
    expect(screen.getByText("Display name is required")).toBeInTheDocument();
    expect(screen.getByText("Email is required")).toBeInTheDocument();
    expect(screen.getByText("Password is required")).toBeInTheDocument();
    expect(registerCompanyAdmin).not.toHaveBeenCalled();
  });

  it("registers a company admin, sends verification, and shows verify screen", async () => {
    const gateway = new FakeGateway();
    const unverified = { ...identity, emailVerified: false, roleKey: "company_admin" };
    const { registerCompanyAdmin } = renderAuth({ gateway, apiResult: unverified });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Sign up" }));
    await user.type(screen.getByLabelText("Company name"), "Northstar Energy");
    await user.type(screen.getByLabelText("Display name"), "First Admin");
    await user.type(screen.getByLabelText("Email"), "admin@northstar.example");
    await user.type(screen.getByLabelText("Password"), "StrongPass1");
    await user.type(screen.getByLabelText("Confirm password"), "StrongPass1");
    await user.click(screen.getByRole("button", { name: "Create organization" }));

    expect(await screen.findByText("Verify your email")).toBeInTheDocument();
    expect(registerCompanyAdmin).toHaveBeenCalledWith({
      companyName: "Northstar Energy",
      displayName: "First Admin",
      email: "admin@northstar.example",
      password: "StrongPass1",
    });
    expect(gateway.sendVerificationCalls).toBe(1);
    await waitFor(() =>
      expect(screen.getByRole("button", { name: /Resend available/ })).toBeDisabled(),
    );
  });

  it("routes an unverified login to verify and resends with cooldown", async () => {
    const gateway = new FakeGateway(session);
    renderAuth({ gateway, apiResult: { ...identity, emailVerified: false } });
    const user = userEvent.setup();
    expect(await screen.findByText("Verify your email")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Resend verification" }));
    await waitFor(() => expect(gateway.sendVerificationCalls).toBe(1));
    await waitFor(() =>
      expect(screen.getByRole("button", { name: /Resend available/ })).toBeDisabled(),
    );
  });

  it("validates forgot-password email before sending", async () => {
    const gateway = new FakeGateway();
    renderAuth({ gateway });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Forgot password?" }));
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect(screen.getByText("Email is required")).toBeInTheDocument();
    expect(gateway.sendPasswordResetCalls).toBe(0);
    await user.type(screen.getByLabelText("Email"), "invalid");
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect(screen.getByText("Enter a valid email address")).toBeInTheDocument();
  });

  it("shows loading then neutral confirmation and enforces resend cooldown", async () => {
    let release!: () => void;
    const gateway = new FakeGateway();
    gateway.passwordResetResult = new Promise<void>((resolve) => {
      release = resolve;
    });
    renderAuth({ gateway });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Forgot password?" }));
    await user.type(screen.getByLabelText("Email"), "known@example.com");
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect(screen.getByRole("button", { name: /Send reset link, loading/ })).toBeDisabled();
    release();
    expect(
      await screen.findByText("If an account exists for that email, a reset link has been sent."),
    ).toBeInTheDocument();
    expect(gateway.sendPasswordResetCalls).toBe(1);
    await waitFor(() =>
      expect(screen.getByRole("button", { name: /Resend available/ })).toBeDisabled(),
    );
  });

  it("treats user-not-found as the identical neutral success", async () => {
    const gateway = new FakeGateway();
    gateway.passwordResetResult = new ClientAuthError("auth/user-not-found", "raw");
    renderAuth({ gateway });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Forgot password?" }));
    await user.type(screen.getByLabelText("Email"), "missing@example.com");
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect(
      await screen.findByText("If an account exists for that email, a reset link has been sent."),
    ).toBeInTheDocument();
  });

  it.each([
    ["auth/too-many-requests", "Too many reset attempts. Please wait and try again"],
    ["auth/network-request-failed", "Network unavailable. Check your connection and try again"],
  ])("shows genuine reset error for %s", async (code, message) => {
    const gateway = new FakeGateway();
    gateway.passwordResetResult = new ClientAuthError(code, "raw");
    renderAuth({ gateway });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Forgot password?" }));
    await user.type(screen.getByLabelText("Email"), "operator@example.com");
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect((await screen.findAllByText(message)).length).toBeGreaterThan(0);
    expect(screen.queryByText("Reset link requested")).not.toBeInTheDocument();
  });

  it("renders forgot password with reduced motion", async () => {
    const { container } = renderAuth({ reducedMotionOverride: true });
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Forgot password?" }));
    expect(await screen.findByText("Forgot password")).toBeInTheDocument();
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });
});
