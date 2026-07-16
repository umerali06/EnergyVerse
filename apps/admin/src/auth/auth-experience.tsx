"use client";

import { type FormEvent, useState } from "react";

import { Badge, Button, Card, Input, MotionSection, Spinner, StatusPill } from "@/design-system";

import { useAuth } from "./auth-context";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function AuthExperience({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const auth = useAuth();
  if (auth.status === "restoring") {
    return (
      <main className="grid min-h-screen place-items-center bg-background p-6">
        <Spinner label="Restoring session" />
      </main>
    );
  }
  if (auth.status === "authenticated" && auth.currentUser) {
    return <AuthenticatedHome reducedMotionOverride={reducedMotionOverride} />;
  }
  return <LoginScreen reducedMotionOverride={reducedMotionOverride} />;
}

function LoginScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const { error: authError, signIn, status } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState<{ email?: string; password?: string }>({});
  const loading = status === "signingIn";

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const nextErrors: { email?: string; password?: string } = {};
    if (!email.trim()) nextErrors.email = "Email is required";
    else if (!emailPattern.test(email.trim())) nextErrors.email = "Enter a valid email address";
    if (!password) nextErrors.password = "Password is required";
    setErrors(nextErrors);
    if (Object.keys(nextErrors).length > 0 || loading) return;
    await signIn(email.trim(), password);
  }

  return (
    <main className="relative grid min-h-screen place-items-center overflow-hidden bg-background p-6">
      <div
        aria-hidden
        className="absolute inset-0 bg-[radial-gradient(circle_at_20%_10%,rgba(37,99,235,0.2),transparent_35%),radial-gradient(circle_at_85%_85%,rgba(249,115,22,0.12),transparent_32%)]"
      />
      <MotionSection
        className="relative z-10 w-full max-w-md"
        reducedMotionOverride={reducedMotionOverride}
      >
        <Card className="border-border/90 bg-surface/95 p-8 backdrop-blur">
          <div className="mb-8 flex items-center gap-3">
            <span className="grid size-12 place-items-center rounded-xl bg-primary-500 font-mono text-h5 font-black text-white shadow-glow">
              F
            </span>
            <div>
              <p className="text-h4 font-bold tracking-tight">Flacron EnergyVerse</p>
              <p className="text-caption uppercase tracking-[0.22em] text-text-muted">
                Field operations intelligence
              </p>
            </div>
          </div>
          <div className="mb-6">
            <StatusPill tone="info">Secure access</StatusPill>
            <h1 className="mt-4 text-h2 font-bold">Welcome back</h1>
            <p className="mt-2 text-body text-text-secondary">
              Sign in with your company-issued account.
            </p>
          </div>
          <form className="grid gap-5" noValidate onSubmit={submit}>
            <Input
              autoComplete="email"
              disabled={loading}
              error={errors.email}
              label="Email"
              onChange={(event) => setEmail(event.target.value)}
              placeholder="name@company.com"
              type="email"
              value={email}
            />
            <Input
              autoComplete="current-password"
              disabled={loading}
              endAdornment={
                <button
                  aria-label={showPassword ? "Hide password" : "Show password"}
                  className="rounded-md px-2 py-1 text-caption font-semibold text-primary-400 hover:text-primary-300"
                  onClick={() => setShowPassword((value) => !value)}
                  type="button"
                >
                  {showPassword ? "Hide" : "Show"}
                </button>
              }
              error={errors.password}
              label="Password"
              onChange={(event) => setPassword(event.target.value)}
              placeholder="Enter your password"
              type={showPassword ? "text" : "password"}
              value={password}
            />
            {authError && (
              <p
                className="rounded-lg border border-status-critical/40 bg-status-critical/10 p-3 text-bodySmall text-status-critical"
                role="alert"
              >
                {authError}
              </p>
            )}
            <Button className="w-full" loading={loading} type="submit">
              Login
            </Button>
          </form>
          <div className="mt-6 flex justify-between gap-4 text-bodySmall">
            <button
              className="cursor-not-allowed text-text-muted"
              disabled
              title="Available in Phase 1.3"
              type="button"
            >
              Forgot password?
            </button>
            <button
              className="cursor-not-allowed text-text-muted"
              disabled
              title="Available in Phase 1.2"
              type="button"
            >
              Sign up
            </button>
          </div>
        </Card>
      </MotionSection>
    </main>
  );
}

function AuthenticatedHome({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const { currentUser, signOut } = useAuth();
  if (!currentUser) return null;
  const name = currentUser.email.split("@")[0].replace(/[._-]+/g, " ");
  return (
    <main className="min-h-screen bg-background p-6 md:p-10">
      <MotionSection className="mx-auto max-w-5xl" reducedMotionOverride={reducedMotionOverride}>
        <header className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-400">
              FEV authenticated workspace
            </p>
            <h1 className="mt-2 text-h2 font-bold capitalize">Welcome, {name}</h1>
            <p className="mt-2 text-text-secondary">{currentUser.email}</p>
          </div>
          <Button onClick={() => void signOut()} variant="ghost">
            Sign out
          </Button>
        </header>
        <div className="mt-8 grid gap-6 md:grid-cols-[0.8fr_1.2fr]">
          <Card>
            <StatusPill tone="healthy">Authenticated</StatusPill>
            <dl className="mt-6 grid gap-4 text-body">
              <div>
                <dt className="text-text-muted">Role</dt>
                <dd className="mt-1 font-semibold">{currentUser.roleKey}</dd>
              </div>
              <div>
                <dt className="text-text-muted">Company</dt>
                <dd className="mt-1 font-mono text-bodySmall">{currentUser.companyId}</dd>
              </div>
              <div>
                <dt className="text-text-muted">Firebase UID</dt>
                <dd className="mt-1 break-all font-mono text-bodySmall">{currentUser.uid}</dd>
              </div>
            </dl>
          </Card>
          <Card>
            <h2 className="text-h4 font-bold">Resolved permissions</h2>
            <p className="mt-2 text-body text-text-secondary">
              Authoritative permissions returned by `/api/v1/auth/me`.
            </p>
            <div className="mt-5 flex flex-wrap gap-2">
              {[...currentUser.permissions].sort().map((permission) => (
                <Badge key={permission}>{permission}</Badge>
              ))}
            </div>
          </Card>
        </div>
      </MotionSection>
    </main>
  );
}
