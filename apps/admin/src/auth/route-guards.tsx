"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { type ReactNode, useEffect } from "react";

import { Button, Card, Logo, LogoLoader, MotionSection, Spinner, StatusPill } from "@/design-system";
import { APP_HOME, SIGNUP_BILLING } from "@/navigation/routes";

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

/** Preserves the plan a visitor picked on the pricing page across registration,
 * so step 2 opens on that tier instead of resetting to the entry plan. */
function useBillingStepPath(): string {
  const params = useSearchParams();
  const plan = params.get("plan");
  return plan ? `${SIGNUP_BILLING}?plan=${encodeURIComponent(plan)}` : SIGNUP_BILLING;
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
 * their intended destination (or Home); unverified users to the billing step.
 *
 * An unverified user goes to `SIGNUP_BILLING` rather than straight to
 * `/verify-email` because paying is the next step in the funnel (D-092) and a
 * company created seconds ago has no subscription. That page forwards to
 * `/verify-email` as soon as one exists, so a returning unverified user with an
 * active plan still lands in the right place — one extra hop, self-correcting,
 * and no race against this redirect. */
export function PublicOnly({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();
  const destination = useNextDestination();
  const billingStep = useBillingStepPath();

  useEffect(() => {
    if (auth.status === "authenticated") {
      router.replace(destination);
    } else if (auth.status === "verificationRequired") {
      router.replace(billingStep);
    }
  }, [auth.status, billingStep, destination, router]);

  if (auth.status === "restoring" || auth.status === "authenticated") {
    return <SplashScreen />;
  }
  if (auth.status === "verificationRequired") return <SplashScreen />;
  return children;
}

/** Wraps the billing steps that sit between registration and a usable account.
 *
 * Admits anyone whose account exists — `authenticated` *or* still unverified —
 * because checkout deliberately precedes email verification (D-092). Only a
 * signed-out visitor is pushed back to the details form. */
export function RequireAccount({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (auth.status === "signedOut") router.replace("/signup");
  }, [auth.status, router]);

  if (
    auth.status === "authenticated" ||
    auth.status === "verificationRequired" ||
    auth.status === "checkingVerification"
  ) {
    return children;
  }
  return <SplashScreen label="Preparing your workspace" />;
}

/** Wraps the verify-email route: only reachable while verification is pending. */
export function VerifyEmailGate({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (auth.status === "signedOut") {
      router.replace("/login");
    } else if (auth.status === "authenticated") {
      router.replace(APP_HOME);
    }
  }, [auth.status, router]);

  if (auth.status === "verificationRequired" || auth.status === "checkingVerification") {
    return children;
  }
  return <SplashScreen />;
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
