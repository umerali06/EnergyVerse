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
  getIdToken: vi.fn(async () => "id-token"),
  uid: "firebase-uid",
};

const identity = {
  uid: "firebase-uid",
  email: "field_inspector@acme.example.invalid",
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

  async getIdToken() {
    return "id-token";
  }

  observe(listener: (value: AuthSession | null) => void) {
    listener(this.initial);
    return () => undefined;
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
  const view = render(
    <ToastProvider>
      <AuthProvider apiClient={{ getCurrentUser }} gateway={gateway}>
        <AuthExperience reducedMotionOverride={reducedMotionOverride} />
      </AuthProvider>
    </ToastProvider>,
  );
  return { ...view, getCurrentUser };
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
});
