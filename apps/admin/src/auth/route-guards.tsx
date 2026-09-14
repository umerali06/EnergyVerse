"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { type ReactNode, useEffect } from "react";

import { SubscriptionProvider, useSubscription } from "@/billing/subscription-context";
import { Button, Card, Logo, LogoLoader, MotionSection, Spinner, StatusPill } from "@/design-system";
import { APP_HOME, SIGNUP_BILLING, VERIFY_EMAIL } from "@/navigation/routes";

import { useAuth } from "./auth-context";
import { PermissionProvider, usePermissions } from "./permissions";

// Firebase auth state lives only in the browser (D-011: client SDK + one auth
// provider), so route protection is a client-layout concern: Next.js middleware
// never sees the session and cannot make this decision.

export function safeInternalPath(raw: string | null | undefined): string | null {
  if (!raw || !raw.startsWith("/") || raw.startsWith("//")) return null;
  return raw;
}

export function loginPathFor(pathname: string, search?: string): string {
  const destination = `${pathname}${search ? `?${search}` : ""}`;
  if (destination === APP_HOME || !safeInternalPath(destination)) return "/login";
  return `/login?next=${encodeURIComponent(destination)}`;
}

export function SplashScreen({ label = "Restoring session" }: { label?: string }) {
  return (
    <main
      className="grid min-h-screen place-items-center bg-background p-6"
      data-testid="auth-splash"
    >
      <LogoLoader label={label} />
    </main>
  );
}

function useNextDestination(): string {
  const params = useSearchParams();
  return safeInternalPath(params.get("next")) ?? APP_HOME;
}

/** Wraps protected routes: splash while restoring, login redirect (preserving the
 * intended destination), verify redirect for unverified users, and a permission
 * context seeded from the authoritative `/me` payload once authenticated. */
export function RequireAuth({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const search = params.toString();

  useEffect(() => {
    if (auth.status === "signedOut") {
      router.replace(loginPathFor(pathname, search));
    } else if (auth.status === "verificationRequired") {
      router.replace("/verify-email");
    }
  }, [auth.status, pathname, router, search]);

  if (auth.status === "authenticated" && auth.currentUser) {
    return (
      <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
        {children}
      </PermissionProvider>
    );
  }
  return <SplashScreen />;
}

/** Wraps login/signup/forgot-password: already-authenticated users are sent to
 * their intended destination (or Home); unverified users to verification.
 *
 * An unverified user goes to `/verify-email` and nowhere else (D-103). The
 * previous order sent them to the plan picker first, which meant a brand-new
 * admin met the card form before they had confirmed the mailbox everything
 * else in the product is sent to — and, because the verify step then sat
 * *after* payment, it read as optional. Verification is now the gate the rest
 * of signup is behind. */
export function PublicOnly({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();
  const destination = useNextDestination();

  useEffect(() => {
    if (auth.status === "authenticated") {
      router.replace(destination);
    } else if (auth.status === "verificationRequired") {
      router.replace(VERIFY_EMAIL);
    }
  }, [auth.status, destination, router]);

  if (auth.status === "restoring" || auth.status === "authenticated") {
    return <SplashScreen />;
  }
  if (auth.status === "verificationRequired") return <SplashScreen />;
  return children;
}

/** Wraps the plan picker and the post-Stripe completion screen.
 *
 * Admits a verified account that has not finished paying. Both directions are
 * closed: a signed-out visitor goes back to registration, and an unverified one
 * to `/verify-email`, so the plan step can never be reached ahead of its turn
 * (D-103) — including by pasting the URL. */
export function RequireAccount({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (auth.status === "signedOut") router.replace("/signup");
    else if (auth.status === "verificationRequired") router.replace(VERIFY_EMAIL);
  }, [auth.status, router]);

  if (auth.status === "authenticated") return children;
  return <SplashScreen label="Preparing your workspace" />;
}

/** Wraps the verify-email route: only reachable while verification is pending.
 *
 * Once verified, where to go next is a billing question, so the decision is
 * handed to `SubscriptionRouter` rather than hard-coded here — a new admin owes
 * a plan, a returning one does not. */
export function VerifyEmailGate({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (auth.status === "signedOut") router.replace("/login");
  }, [auth.status, router]);

  if (auth.status === "verificationRequired" || auth.status === "checkingVerification") {
    return children;
  }
  if (auth.status === "authenticated") {
    return (
      <SubscriptionProvider>
        <SubscriptionRouter />
      </SubscriptionProvider>
    );
  }
  return <SplashScreen />;
}

/** Sends a freshly verified admin on: to the plan picker if the company has no
 * subscription, otherwise into the app. Renders nothing but a splash — it
 * exists purely to make that choice once the plan is known. */
function SubscriptionRouter() {
  const router = useRouter();
  const destination = useEntitledDestination();

  useEffect(() => {
    if (destination !== null) router.replace(destination);
  }, [destination, router]);

  return <SplashScreen label="Preparing your workspace" />;
}

/**
 * `APP_HOME` when the company has an active subscription, `SIGNUP_BILLING`
 * when it does not, and `null` while the answer is still unknown.
 *
 * A failed load resolves to the plan picker rather than the app. That is the
 * safe direction: the picker forwards straight back out again the moment it
 * reads an entitled subscription, whereas guessing "entitled" would drop
 * someone into a shell whose every module then 402s.
 */
function useEntitledDestination(): string | null {
  const auth = useAuth();
  const { status, subscription } = useSubscription();

  // Read from the identity rather than `usePermissions`: this runs on
  // /verify-email too, which has no PermissionProvider above it, and `/me` is
  // the same payload that provider is seeded from.
  //
  // Platform staff administer tenants and are not themselves a paying tenant;
  // gating them on a subscription would lock the operators out of the console
  // they need to fix billing with.
  if (auth.currentUser?.permissions.has("platform.admin") === true) return APP_HOME;
  if (status === "loading") return null;
  return subscription?.isEntitled === true ? APP_HOME : SIGNUP_BILLING;
}

/**
 * The paid gate on the app shell.
 *
 * Without it, anything that landed an unsubscribed admin on a protected route —
 * a bookmark, a back button, or the "Continue anyway" escape hatch the
 * completion screen used to offer — produced a dashboard with no plan behind
 * it: nav filtered down to nothing and every request answered 402. Redirecting
 * to the picker turns that dead end into the step they still owe.
 *
 * Must be rendered inside `SubscriptionProvider`, and therefore inside
 * `RequireAuth` — only an authenticated session can read a subscription.
 */
export function RequireSubscription({ children }: { children: ReactNode }) {
  const router = useRouter();
  const destination = useEntitledDestination();

  useEffect(() => {
    if (destination !== null && destination !== APP_HOME) router.replace(destination);
  }, [destination, router]);

  if (destination === APP_HOME) return children;
  return <SplashScreen label="Checking your subscription" />;
}

/** Client-side permission gate for protected pages. UX only — FastAPI's
 * require_permission/require_verified_email remain authoritative. */
export function RequirePermission({
  permission,
  children,
  reducedMotionOverride,
}: {
  permission: string;
  children: ReactNode;
  reducedMotionOverride?: boolean;
}) {
  const { can } = usePermissions();
  if (can(permission)) return children;
  return <NoAccessScreen permission={permission} reducedMotionOverride={reducedMotionOverride} />;
}

export function NoAccessScreen({
  permission,
  reducedMotionOverride,
}: {
  permission?: string;
  reducedMotionOverride?: boolean;
}) {
  const router = useRouter();
  // Rendered inside the 2.1 app shell's content area, not full-screen.
  return (
    <section className="relative grid min-h-[60vh] place-items-center p-6">
      <MotionSection
        className="relative z-10 w-full max-w-md"
        reducedMotionOverride={reducedMotionOverride}
      >
        <Card className="border-border/90 bg-surface/95 p-8 backdrop-blur">
          <StatusPill tone="critical">403 — No access</StatusPill>
          <h1 className="mt-4 text-h2 font-bold">You can&apos;t view this area</h1>
          <p className="mt-3 text-body text-text-secondary" role="alert">
            Your role doesn&apos;t include the permission required for this page
            {permission ? (
              <>
                {" "}
                (<span className="font-mono text-bodySmall">{permission}</span>)
              </>
            ) : null}
            . If you believe this is a mistake, contact your company admin.
          </p>
          <div className="mt-7 grid gap-3">
            <Button onClick={() => router.replace(APP_HOME)}>Back to Home</Button>
          </div>
        </Card>
      </MotionSection>
    </section>
  );
}
