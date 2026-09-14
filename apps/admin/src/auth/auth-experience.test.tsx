import { act, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { useSyncExternalStore } from "react";
import { describe, expect, it, vi } from "vitest";

import { ApiClientError } from "@/api";
import { SubscriptionProvider } from "@/billing/subscription-context";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { DashboardPage } from "@/dashboard/dashboard-page";
import { AppShell } from "@/shell/app-shell";
import { LEGAL_VERSION } from "@/legal/legal-content";
import { APP_HOME } from "@/navigation/routes";

import { AuthProvider } from "./auth-context";
import {
  ForgotPasswordScreen,
  LoginScreen,
  RbacDemoScreen,
  SignupScreen,
  VerifyEmailScreen,
} from "./auth-experience";
import { ClientAuthError, type AuthGateway, type AuthSession } from "./firebase-gateway";
import {
  PublicOnly,
  RequireAuth,
  RequirePermission,
  RequireSubscription,
  VerifyEmailGate,
} from "./route-guards";

const routerControl = vi.hoisted(() => {
  // Literal, not the APP_HOME import: vi.hoisted runs before module imports.
  const home = "/dashboard";
  type Snapshot = { path: string; search: string };
  const parse = (url: string): Snapshot => {
    const [path, search = ""] = url.split("?");
    return { path, search };
  };
  let current: Snapshot = parse(home);
  let history: Snapshot[] = [];
  const listeners = new Set<() => void>();
  const emit = () => listeners.forEach((listener) => listener());
  return {
    get current() {
      return current;
    },
    reset(url = home) {
      current = parse(url);
      history = [];
    },
    push(url: string) {
      history.push(current);
      current = parse(url);
      emit();
    },
    replace(url: string) {
      current = parse(url);
      emit();
    },
    back() {
      const previous = history.pop();
      if (previous) {
        current = previous;
        emit();
      }
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
      back: routerControl.back,
      prefetch: () => undefined,
      push: routerControl.push,
      replace: routerControl.replace,
    }),
  };
});

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
  companyName: "Acme Energy",
  roleKey: "field_inspector",
  permissions: new Set(["assets.read", "inspections.write", "reports.generate"]),
};

const writerIdentity = {
  ...identity,
  roleKey: "operations_manager",
  permissions: new Set([...identity.permissions, "assets.write"]),
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

/** Mirrors the src/app route composition over the mocked next/navigation router. */
function AppRouterHarness({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const path = useSyncExternalStore(routerControl.subscribe, () => routerControl.current.path);
  switch (path) {
    case "/login":
      return (
        <PublicOnly>
          <LoginScreen reducedMotionOverride={reducedMotionOverride} />
        </PublicOnly>
      );
    case "/signup":
      return (
        <PublicOnly>
          <SignupScreen reducedMotionOverride={reducedMotionOverride} />
        </PublicOnly>
      );
    case "/forgot-password":
      return (
        <PublicOnly>
          <ForgotPasswordScreen reducedMotionOverride={reducedMotionOverride} />
        </PublicOnly>
      );
    case "/verify-email":
      return (
        <VerifyEmailGate>
          <VerifyEmailScreen reducedMotionOverride={reducedMotionOverride} />
        </VerifyEmailGate>
      );
    case "/signup/plan":
      // The real screen is covered by signup-billing.test.tsx; the harness only
      // needs somewhere for the subscription gate to land.
      return <p>Choose your plan</p>;
    case "/rbac-demo":
      return (
        <RequireAuth>
          <RequireSubscription>
            <AppShell reducedMotionOverride={reducedMotionOverride}>
              <RequirePermission
                permission="assets.write"
                reducedMotionOverride={reducedMotionOverride}
              >
                <RbacDemoScreen reducedMotionOverride={reducedMotionOverride} />
              </RequirePermission>
            </AppShell>
          </RequireSubscription>
        </RequireAuth>
      );
    default:
      return (
        <RequireAuth>
          <RequireSubscription>
            <AppShell reducedMotionOverride={reducedMotionOverride}>
              <DashboardPage reducedMotionOverride={reducedMotionOverride} />
            </AppShell>
          </RequireSubscription>
        </RequireAuth>
      );
  }
}

/** Minimal real-shaped fixtures for the three dashboard endpoints so any
 * test that reaches APP_HOME (the Dashboard) resolves to a stable ready state
 * without asserting on dashboard content itself — that's covered by
 * dashboard-page.test.tsx. */
/** Every entitlement, so nav filtering never hides what an auth case asserts. */
const fullPlan = {
  tier: "enterprise",
  planName: "Enterprise",
  status: "active",
  isEntitled: true,
  features: [
    "assets",
    "inspections",
    "ai_media_analysis",
    "safety_reports",
    "documents",
    "reports",
    "digital_twin",
    "ar_inspection",
    "permits",
    "work_orders",
    "vr_training",
    "sso",
    "audit_export",
  ],
  trialEndsAt: null,
  trialDaysRemaining: null,
  currentPeriodEnd: null,
  quotas: { facilities: null, assets: null, seats: null },
};

function defaultDashboardApi() {
  return {
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
}

function renderAuth({
  apiResult = identity,
  gateway = new FakeGateway(),
  initialPath = APP_HOME,
  reducedMotionOverride,
  subscription = fullPlan,
  sendVerificationEmail,
}: {
  apiResult?: typeof identity | Error;
  gateway?: AuthGateway;
  initialPath?: string;
  reducedMotionOverride?: boolean;
  subscription?: typeof fullPlan | null;
  sendVerificationEmail?: ReturnType<typeof vi.fn>;
} = {}) {
  routerControl.reset(initialPath);
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
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider
          apiClient={{
            getCurrentUser,
            registerCompanyAdmin,
            ...(sendVerificationEmail ? { sendVerificationEmail } : {}),
            ...defaultDashboardApi(),
          }}
          gateway={gateway}
        >
          {/* AppShell filters its nav by the company's plan, so the harness
              supplies one. Most cases are about auth, not billing. */}
          <SubscriptionProvider initialSubscription={subscription}>
            <AppRouterHarness reducedMotionOverride={reducedMotionOverride} />
          </SubscriptionProvider>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return { ...view, getCurrentUser, registerCompanyAdmin };
}

async function submitCredentials() {
  const user = userEvent.setup();
  await user.type(await screen.findByLabelText("Email"), "field_inspector@acme.example.invalid");
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
    expect(screen.getByRole("heading", { name: /Welcome, Field Inspector/ })).toBeInTheDocument();
    expect(routerControl.current.path).toBe(APP_HOME);
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

  it("restores an existing session behind the splash without a login flash", async () => {
    const { getCurrentUser } = renderAuth({ gateway: new FakeGateway(session) });
    expect(screen.getByTestId("auth-splash")).toBeInTheDocument();
    expect(screen.queryByLabelText("Email")).not.toBeInTheDocument();
    expect(await screen.findByText("field_inspector")).toBeInTheDocument();
    expect(getCurrentUser).toHaveBeenCalledOnce();
    expect(routerControl.current.path).toBe(APP_HOME);
  });

  it("expires a dead session with the session-expired toast and a login redirect", async () => {
    const gateway = new FakeGateway(session);
    renderAuth({
      apiResult: new ApiClientError("unauthenticated", "Not authenticated", 401),
      gateway,
    });
    expect((await screen.findAllByText(/Your session has expired/)).length).toBeGreaterThan(0);
    expect(await screen.findByRole("button", { name: "Login" })).toBeInTheDocument();
    expect(gateway.signOutCalls).toBe(1);
    expect(routerControl.current.path).toBe("/login");
  });

  it("signs out, returns to login, and keeps protected content hidden on back-nav", async () => {
    const gateway = new FakeGateway(session);
    renderAuth({ gateway });
    const user = userEvent.setup();
    await screen.findByText("field_inspector");
    await user.click(screen.getByRole("button", { name: "User menu" }));
    await user.click(screen.getByRole("menuitem", { name: "Sign out" }));
    expect(await screen.findByRole("button", { name: "Login" })).toBeInTheDocument();
    expect(gateway.signOutCalls).toBe(1);
    // Simulate back/deep navigation to the protected URL after logout.
    act(() => routerControl.push(APP_HOME));
    expect(await screen.findByRole("button", { name: "Login" })).toBeInTheDocument();
    expect(screen.queryByText("field_inspector")).not.toBeInTheDocument();
  });

  it("redirects an unauthenticated deep link to login and returns there after login", async () => {
    renderAuth({ apiResult: writerIdentity, initialPath: "/rbac-demo" });
    await waitFor(() => expect(routerControl.current.path).toBe("/login"));
    expect(routerControl.current.search).toBe("next=%2Frbac-demo");
    await submitCredentials();
    expect(await screen.findByText("Assets demo")).toBeInTheDocument();
    expect(routerControl.current.path).toBe("/rbac-demo");
  });

  it("renders the branded 403 page for a role without the permission", async () => {
    const { container } = renderAuth({
      gateway: new FakeGateway(session),
      initialPath: "/rbac-demo",
      reducedMotionOverride: true,
    });
    expect(await screen.findByText("403 — No access")).toBeInTheDocument();
    expect(screen.getByText("assets.write")).toBeInTheDocument();
    expect(screen.queryByText("Assets demo")).not.toBeInTheDocument();
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Back to Home" }));
    expect(await screen.findByText("field_inspector")).toBeInTheDocument();
  });

  it("lets a role with the permission through the gate", async () => {
    renderAuth({
      apiResult: writerIdentity,
      gateway: new FakeGateway(session),
      initialPath: "/rbac-demo",
    });
    expect(await screen.findByText("Assets demo")).toBeInTheDocument();
    expect(screen.queryByText("403 — No access")).not.toBeInTheDocument();
  });

  it("redirects an authenticated user away from login to the app home", async () => {
    renderAuth({ gateway: new FakeGateway(session), initialPath: "/login" });
    expect(await screen.findByText("field_inspector")).toBeInTheDocument();
    expect(routerControl.current.path).toBe(APP_HOME);
  });

  it("routes an unverified user to verify and blocks protected routes", async () => {
    renderAuth({
      apiResult: { ...identity, emailVerified: false },
      gateway: new FakeGateway(session),
      initialPath: "/rbac-demo",
    });
    expect(await screen.findByText("Verify your email")).toBeInTheDocument();
    expect(routerControl.current.path).toBe("/verify-email");
    expect(screen.queryByText("Assets demo")).not.toBeInTheDocument();
  });

  it("sends an unsubscribed admin to the plan step instead of an empty shell", async () => {
    // Anything that lands an unsubscribed admin on a protected route — a
    // bookmark, a back button — used to render a dashboard with no plan behind
    // it: nav filtered to nothing, every request answering 402.
    renderAuth({
      gateway: new FakeGateway(session),
      subscription: { ...fullPlan, isEntitled: false, features: [], tier: "unassigned" },
    });

    expect(await screen.findByText("Choose your plan")).toBeInTheDocument();
    await waitFor(() => expect(routerControl.current.path).toBe("/signup/plan"));
    expect(screen.queryByText("field_inspector")).not.toBeInTheDocument();
  });

  it("refreshes the session on demand to surface new claims", async () => {
    const gateway = new FakeGateway(session);
    const refreshSpy = vi.spyOn(gateway, "refreshSession");
    const { getCurrentUser } = renderAuth({ gateway });
    const user = userEvent.setup();
    await screen.findByText("field_inspector");
    await user.click(screen.getByRole("button", { name: "User menu" }));
    await user.click(screen.getByRole("menuitem", { name: "Refresh session" }));
    await waitFor(() => expect(refreshSpy).toHaveBeenCalledOnce());
    await waitFor(() => expect(getCurrentUser).toHaveBeenCalledTimes(2));
  });

  it("renders the reduced-motion entrance path", async () => {
    const { container } = renderAuth({ reducedMotionOverride: true });
    await screen.findByRole("button", { name: "Login" });
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });

  it("validates signup fields and password strength before registration", async () => {
    const { registerCompanyAdmin } = renderAuth({ initialPath: "/signup" });
    const user = userEvent.setup();
    // The acknowledgment has to be ticked before the button is even live, so
    // the validation messages are reached through it rather than around it.
    await user.click(await screen.findByRole("checkbox"));
    await user.click(screen.getByRole("button", { name: "Accept & continue" }));
    expect(screen.getByText("Company name is required")).toBeInTheDocument();
    expect(screen.getByText("Display name is required")).toBeInTheDocument();
    expect(screen.getByText("Email is required")).toBeInTheDocument();
    expect(screen.getByText("Password is required")).toBeInTheDocument();
    expect(registerCompanyAdmin).not.toHaveBeenCalled();
  });

  it("will not register until the legal acknowledgment is accepted", async () => {
    // Required by the legal package: the box is never pre-checked, and
    // "Accept & continue" stays disabled until it is ticked.
    const { registerCompanyAdmin } = renderAuth({ initialPath: "/signup" });
    const user = userEvent.setup();
    const acknowledgment = await screen.findByRole("checkbox");
    expect(acknowledgment).not.toBeChecked();
    expect(screen.getByRole("button", { name: "Accept & continue" })).toBeDisabled();

    await user.type(screen.getByLabelText("Company name"), "Northstar Energy");
    await user.type(screen.getByLabelText("Display name"), "First Admin");
    await user.type(screen.getByLabelText("Email"), "admin@northstar.example");
    await user.type(screen.getByLabelText("Password"), "StrongPass1");
    await user.type(screen.getByLabelText("Confirm password"), "StrongPass1");
    // Every other field is valid and it is still not submittable.
    expect(screen.getByRole("button", { name: "Accept & continue" })).toBeDisabled();
    expect(registerCompanyAdmin).not.toHaveBeenCalled();

    await user.click(acknowledgment);
    expect(screen.getByRole("button", { name: "Accept & continue" })).toBeEnabled();
  });

  it("registers a company admin, sends verification, and shows verify screen", async () => {
    const gateway = new FakeGateway();
    const unverified = { ...identity, emailVerified: false, roleKey: "company_admin" };
    const { registerCompanyAdmin } = renderAuth({
      apiResult: unverified,
      gateway,
      initialPath: "/signup",
    });
    const user = userEvent.setup();
    await user.type(await screen.findByLabelText("Company name"), "Northstar Energy");
    await user.type(screen.getByLabelText("Display name"), "First Admin");
    await user.type(screen.getByLabelText("Email"), "admin@northstar.example");
    await user.type(screen.getByLabelText("Password"), "StrongPass1");
    await user.type(screen.getByLabelText("Confirm password"), "StrongPass1");
    await user.click(screen.getByRole("checkbox"));
    await user.click(screen.getByRole("button", { name: "Accept & continue" }));

    expect(await screen.findByText("Verify your email")).toBeInTheDocument();
    // Verification, not the card form: a mailbox nobody can reach is found out
    // before payment rather than after it (D-103).
    expect(routerControl.current.path).toBe("/verify-email");
    expect(routerControl.current.path).not.toBe("/signup/plan");
    // The acceptance travels with the registration, so the record exists at the
    // moment the account does rather than being written afterwards.
    expect(registerCompanyAdmin).toHaveBeenCalledWith({
      companyName: "Northstar Energy",
      displayName: "First Admin",
      email: "admin@northstar.example",
      password: "StrongPass1",
      termsAccepted: true,
      privacyAccepted: true,
      safetyDisclaimerAccepted: true,
      legalVersion: LEGAL_VERSION,
      acceptanceSource: "web",
    });
    // No branded sender was supplied here, so it falls back to the provider's.
    expect(gateway.sendVerificationCalls).toBe(1);
    await waitFor(() =>
      expect(screen.getByRole("button", { name: /Resend available/ })).toBeDisabled(),
    );
  });

  it("prefers the branded SES email over the provider's unbranded default", async () => {
    // Firebase's own mail comes from a firebaseapp.com sender and lands in spam
    // often enough that verification looked broken rather than pending.
    const gateway = new FakeGateway();
    const sendVerificationEmail = vi.fn(async () => ({ sent: true }));
    renderAuth({
      apiResult: { ...identity, emailVerified: false, roleKey: "company_admin" },
      gateway,
      initialPath: "/signup",
      sendVerificationEmail,
    });
    const user = userEvent.setup();
    await user.type(await screen.findByLabelText("Company name"), "Northstar Energy");
    await user.type(screen.getByLabelText("Display name"), "First Admin");
    await user.type(screen.getByLabelText("Email"), "admin@northstar.example");
    await user.type(screen.getByLabelText("Password"), "StrongPass1");
    await user.type(screen.getByLabelText("Confirm password"), "StrongPass1");
    await user.click(screen.getByRole("checkbox"));
    await user.click(screen.getByRole("button", { name: "Accept & continue" }));

    await waitFor(() => expect(sendVerificationEmail).toHaveBeenCalledOnce());
    expect(gateway.sendVerificationCalls).toBe(0);
  });

  it("falls back to the provider's sender when SES is unavailable", async () => {
    const gateway = new FakeGateway(session);
    const sendVerificationEmail = vi.fn(async () => {
      throw new ApiClientError("email_not_configured", "No SES", 503);
    });
    renderAuth({
      apiResult: { ...identity, emailVerified: false },
      gateway,
      sendVerificationEmail,
    });
    const user = userEvent.setup();
    expect(await screen.findByText("Verify your email")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Resend verification" }));

    // An unbranded link in spam still beats no link at all.
    await waitFor(() => expect(gateway.sendVerificationCalls).toBe(1));
  });

  it("routes an unverified login to verify and resends with cooldown", async () => {
    const gateway = new FakeGateway(session);
    renderAuth({ apiResult: { ...identity, emailVerified: false }, gateway });
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
    await user.click(await screen.findByRole("button", { name: "Send reset link" }));
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
    renderAuth({ gateway, initialPath: "/forgot-password" });
    const user = userEvent.setup();
    await user.type(await screen.findByLabelText("Email"), "known@example.com");
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
    renderAuth({ gateway, initialPath: "/forgot-password" });
    const user = userEvent.setup();
    await user.type(await screen.findByLabelText("Email"), "missing@example.com");
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
    renderAuth({ gateway, initialPath: "/forgot-password" });
    const user = userEvent.setup();
    await user.type(await screen.findByLabelText("Email"), "operator@example.com");
    await user.click(screen.getByRole("button", { name: "Send reset link" }));
    expect((await screen.findAllByText(message)).length).toBeGreaterThan(0);
    expect(screen.queryByText("Reset link requested")).not.toBeInTheDocument();
  });

  it("renders forgot password with reduced motion", async () => {
    const { container } = renderAuth({
      initialPath: "/forgot-password",
      reducedMotionOverride: true,
    });
    expect(await screen.findByText("Forgot password")).toBeInTheDocument();
    expect(container.querySelector('[data-motion="reduced"]')).toBeInTheDocument();
  });
});
