"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { type ReactNode, useEffect } from "react";

import { Button, Card, MotionSection, Spinner, StatusPill } from "@/design-system";

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
  if (destination === "/" || !safeInternalPath(destination)) return "/login";
  return `/login?next=${encodeURIComponent(destination)}`;
}

export function SplashScreen({ label = "Restoring session" }: { label?: string }) {
  return (
    <main
      className="grid min-h-screen place-items-center bg-background p-6"
      data-testid="auth-splash"
    >
      <Spinner label={label} />
    </main>
  );
}

function useNextDestination(): string {
  const params = useSearchParams();
  return safeInternalPath(params.get("next")) ?? "/";
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
 * their intended destination (or Home); unverified users to the verify screen. */
export function PublicOnly({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();
  const destination = useNextDestination();

  useEffect(() => {
    if (auth.status === "authenticated") {
      router.replace(destination);
    } else if (auth.status === "verificationRequired") {
      router.replace("/verify-email");
    }
  }, [auth.status, destination, router]);

  if (auth.status === "restoring" || auth.status === "authenticated") {
    return <SplashScreen />;
  }
  if (auth.status === "verificationRequired") return <SplashScreen />;
  return children;
}

/** Wraps the verify-email route: only reachable while verification is pending. */
export function VerifyEmailGate({ children }: { children: ReactNode }) {
  const auth = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (auth.status === "signedOut") {
      router.replace("/login");
    } else if (auth.status === "authenticated") {
      router.replace("/");
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
            <Button onClick={() => router.replace("/")}>Back to Home</Button>
          </div>
        </Card>
      </MotionSection>
    </section>
  );
}
