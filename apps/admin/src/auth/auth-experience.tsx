"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { type FormEvent, useEffect, useState } from "react";

import { Button, Card, Input, Logo, MotionSection, StatusPill } from "@/design-system";

import { useAuth } from "./auth-context";
import { safeInternalPath } from "./route-guards";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const strongPassword = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
const resendCooldownSeconds = 60;

/** Navigation between the public auth screens, preserving the intended
 * destination captured by RequireAuth's login redirect. */
function usePublicAuthNav() {
  const router = useRouter();
  const params = useSearchParams();
  const next = safeInternalPath(params.get("next"));
  const suffix = next ? `?next=${encodeURIComponent(next)}` : "";
  return {
    toForgotPassword: () => router.push(`/forgot-password${suffix}`),
    toLogin: () => router.push(`/login${suffix}`),
    toSignup: () => router.push(`/signup${suffix}`),
  };
}

function Brand() {
  return (
    <div className="mb-8">
      <Logo height={64} priority variant="wordmark" />
    </div>
  );
}

function AuthShell({
  children,
  reducedMotionOverride,
  wide = false,
}: {
  children: React.ReactNode;
  reducedMotionOverride?: boolean;
  wide?: boolean;
}) {
  return (
    <main className="relative grid min-h-screen place-items-center bg-background p-6">
      <MotionSection
        className={`relative z-10 w-full ${wide ? "max-w-2xl" : "max-w-md"}`}
        reducedMotionOverride={reducedMotionOverride}
      >
        <Card className="border-t-2 border-t-primary-500/70 p-6 md:p-8">{children}</Card>
      </MotionSection>
    </main>
  );
}

export function LoginScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const { toForgotPassword, toSignup } = usePublicAuthNav();
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
    <AuthShell reducedMotionOverride={reducedMotionOverride}>
      <Brand />
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
              className="rounded-md px-2 py-1 text-caption font-semibold text-primary-600 dark:text-primary-400"
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
        {authError && <InlineError message={authError} />}
        <Button className="w-full" loading={loading} type="submit" variant="accent">
          Login
        </Button>
      </form>
      <div className="mt-6 flex justify-between gap-4 text-bodySmall">
        <button
          className="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
          onClick={toForgotPassword}
          type="button"
        >
          Forgot password?
        </button>
        <button
          className="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
          onClick={toSignup}
          type="button"
        >
          Sign up
        </button>
      </div>
    </AuthShell>
  );
}

export function ForgotPasswordScreen({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
}) {
  const { toLogin: onBack } = usePublicAuthNav();
  const auth = useAuth();
  const [email, setEmail] = useState("");
  const [emailError, setEmailError] = useState<string>();
  const [sent, setSent] = useState(false);
  const [cooldown, setCooldown] = useState(0);
  const loading = auth.status === "sendingPasswordReset";

  useEffect(() => {
    if (!auth.passwordResetSentAt) {
      setCooldown(0);
      return;
    }
    const update = () => {
      const elapsed = Math.floor((Date.now() - auth.passwordResetSentAt!) / 1000);
      setCooldown(Math.max(0, resendCooldownSeconds - elapsed));
    };
    update();
    const timer = window.setInterval(update, 1_000);
    return () => window.clearInterval(timer);
  }, [auth.passwordResetSentAt]);

  async function send(event?: FormEvent<HTMLFormElement>) {
    event?.preventDefault();
    const normalized = email.trim();
    const nextError = !normalized
      ? "Email is required"
      : !emailPattern.test(normalized)
        ? "Enter a valid email address"
        : undefined;
    setEmailError(nextError);
    if (nextError || loading || (sent && cooldown > 0)) return;
    if (await auth.sendPasswordReset(normalized)) setSent(true);
  }

  if (sent) {
    return (
      <AuthShell reducedMotionOverride={reducedMotionOverride}>
        <Brand />
        <StatusPill tone="healthy">Check your inbox</StatusPill>
        <h1 className="mt-4 text-h2 font-bold">Reset link requested</h1>
        <p className="mt-3 text-body text-text-secondary" role="status">
          If an account exists for that email, a reset link has been sent.
        </p>
        <p className="mt-3 text-bodySmall text-text-muted">
          Complete the password change in Firebase&apos;s secure hosted flow.
        </p>
        {auth.error && (
          <div className="mt-5">
            <InlineError message={auth.error} />
          </div>
        )}
        <div className="mt-7 grid gap-3">
          <Button
            disabled={cooldown > 0}
            loading={loading}
            onClick={() => void send()}
            variant="ghost"
          >
            {cooldown > 0 ? `Resend available in ${cooldown}s` : "Resend reset link"}
          </Button>
          <button
            className="mt-2 text-bodySmall font-semibold text-primary-600 dark:text-primary-400"
            onClick={onBack}
            type="button"
          >
            Back to login
          </button>
        </div>
      </AuthShell>
    );
  }

  return (
    <AuthShell reducedMotionOverride={reducedMotionOverride}>
      <Brand />
      <StatusPill tone="info">Account recovery</StatusPill>
      <h1 className="mt-4 text-h2 font-bold">Forgot password</h1>
      <p className="mt-2 text-body text-text-secondary">
        Enter your email and we&apos;ll request a secure Firebase reset link.
      </p>
      <form className="mt-7 grid gap-5" noValidate onSubmit={send}>
        <Input
          autoComplete="email"
          disabled={loading}
          error={emailError}
          label="Email"
          onChange={(event) => setEmail(event.target.value)}
          placeholder="name@company.com"
          type="email"
          value={email}
        />
        {auth.error && <InlineError message={auth.error} />}
        <Button className="w-full" loading={loading} type="submit" variant="accent">
          Send reset link
        </Button>
        <button
          className="text-bodySmall font-semibold text-primary-600 dark:text-primary-400"
          disabled={loading}
          onClick={onBack}
          type="button"
        >
          Back to login
        </button>
      </form>
    </AuthShell>
  );
}

type SignupErrors = Partial<
  Record<"company" | "display" | "email" | "password" | "confirm", string>
>;

export function SignupScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const { toLogin: onBack } = usePublicAuthNav();
  const { error: authError, register, status } = useAuth();
  const [companyName, setCompanyName] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState<SignupErrors>({});
  const loading = status === "signingUp";

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const next: SignupErrors = {};
    if (companyName.trim().length < 2) next.company = "Company name is required";
    if (displayName.trim().length < 2) next.display = "Display name is required";
    if (!email.trim()) next.email = "Email is required";
    else if (!emailPattern.test(email.trim())) next.email = "Enter a valid email address";
    if (!password) next.password = "Password is required";
    else if (!strongPassword.test(password)) {
      next.password = "Use 8+ characters with upper, lower, and a number";
    }
    if (!confirm) next.confirm = "Confirm your password";
    else if (confirm !== password) next.confirm = "Passwords do not match";
    setErrors(next);
    if (Object.keys(next).length > 0 || loading) return;
    await register({
      companyName: companyName.trim(),
      displayName: displayName.trim(),
      email: email.trim(),
      password,
    });
  }

  const toggle = (
    <button
      aria-label={showPassword ? "Hide passwords" : "Show passwords"}
      className="rounded-md px-2 py-1 text-caption font-semibold text-primary-600 dark:text-primary-400"
      onClick={() => setShowPassword((value) => !value)}
      type="button"
    >
      {showPassword ? "Hide" : "Show"}
    </button>
  );

  return (
    <AuthShell reducedMotionOverride={reducedMotionOverride} wide>
      <Brand />
      <StatusPill tone="info">Create organization</StatusPill>
      <h1 className="mt-4 text-h2 font-bold">Start your FEV workspace</h1>
      <p className="mt-2 text-body text-text-secondary">
        You will become the first Company Admin for this new organization.
      </p>
      <form className="mt-7 grid gap-5 md:grid-cols-2" noValidate onSubmit={submit}>
        <Input
          disabled={loading}
          error={errors.company}
          label="Company name"
          onChange={(e) => setCompanyName(e.target.value)}
          value={companyName}
        />
        <Input
          disabled={loading}
          error={errors.display}
          label="Display name"
          onChange={(e) => setDisplayName(e.target.value)}
          value={displayName}
        />
        <div className="md:col-span-2">
          <Input
            autoComplete="email"
            disabled={loading}
            error={errors.email}
            label="Email"
            onChange={(e) => setEmail(e.target.value)}
            type="email"
            value={email}
          />
        </div>
        <Input
          autoComplete="new-password"
          disabled={loading}
          endAdornment={toggle}
          error={errors.password}
          label="Password"
          onChange={(e) => setPassword(e.target.value)}
          type={showPassword ? "text" : "password"}
          value={password}
        />
        <Input
          autoComplete="new-password"
          disabled={loading}
          error={errors.confirm}
          label="Confirm password"
          onChange={(e) => setConfirm(e.target.value)}
          type={showPassword ? "text" : "password"}
          value={confirm}
        />
        {authError && (
          <div className="md:col-span-2">
            <InlineError message={authError} />
          </div>
        )}
        <div className="flex gap-3 md:col-span-2">
          <Button
            className="flex-1"
            disabled={loading}
            onClick={onBack}
            type="button"
            variant="ghost"
          >
            Back to login
          </Button>
          <Button className="flex-1" loading={loading} type="submit" variant="accent">
            Create organization
          </Button>
        </div>
      </form>
    </AuthShell>
  );
}

export function VerifyEmailScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const auth = useAuth();
  const [cooldown, setCooldown] = useState(0);
  useEffect(() => {
    if (!auth.verificationSentAt) {
      setCooldown(0);
      return;
    }
    const update = () => {
      const elapsed = Math.floor((Date.now() - auth.verificationSentAt!) / 1000);
      setCooldown(Math.max(0, resendCooldownSeconds - elapsed));
    };
    update();
    const timer = window.setInterval(update, 1_000);
    return () => window.clearInterval(timer);
  }, [auth.verificationSentAt]);

  async function resend() {
    if (cooldown > 0) return;
    await auth.resendVerification();
  }

  return (
    <AuthShell reducedMotionOverride={reducedMotionOverride}>
      <Brand />
      <StatusPill tone="warning">Verification required</StatusPill>
      <h1 className="mt-4 text-h2 font-bold">Verify your email</h1>
      <p className="mt-3 text-body text-text-secondary">
        We sent a verification link to{" "}
        <strong className="text-text-primary">{auth.currentUser?.email}</strong>. Open it, then
        return here to continue.
      </p>
      {auth.error && (
        <div className="mt-5">
          <InlineError message={auth.error} />
        </div>
      )}
      <div className="mt-7 grid gap-3">
        <Button
          loading={auth.status === "checkingVerification"}
          onClick={() => void auth.refreshVerification()}
        >
          I&apos;ve verified — continue
        </Button>
        <Button disabled={cooldown > 0} onClick={() => void resend()} variant="ghost">
          {cooldown > 0 ? `Resend available in ${cooldown}s` : "Resend verification"}
        </Button>
        <button
          className="mt-2 text-bodySmall font-semibold text-primary-600 dark:text-primary-400"
          onClick={() => void auth.signOut()}
          type="button"
        >
          Back to login
        </button>
      </div>
    </AuthShell>
  );
}

function InlineError({ message }: { message: string }) {
  return (
    <p
      className="rounded-lg border border-status-critical/40 bg-status-critical/10 p-3 text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical"
      role="alert"
    >
      {message}
    </p>
  );
}

// The authenticated Home placeholder (welcome + role + raw permission chips)
// from Phase 1.1 has been replaced by the real dashboard — see
// @/dashboard/dashboard-page. This module now only owns the public auth
// screens, verify-email, and the RBAC demo route below.

export function RbacDemoScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const router = useRouter();
  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-3xl" reducedMotionOverride={reducedMotionOverride}>
        <Card className="p-8">
          <StatusPill tone="healthy">Access granted</StatusPill>
          <h1 className="mt-4 text-h2 font-bold">Assets demo</h1>
          <p className="mt-3 text-body text-text-secondary">
            This page requires the <span className="font-mono text-bodySmall">assets.write</span>{" "}
            permission. The client gate mirrors the authoritative FastAPI{" "}
            <span className="font-mono text-bodySmall">require_permission</span> dependency on{" "}
            <span className="font-mono text-bodySmall">/api/v1/_rbac-demo/single</span>.
          </p>
          <div className="mt-7">
            <Button onClick={() => router.push("/")} variant="ghost">
              Back to Home
            </Button>
          </div>
        </Card>
      </MotionSection>
    </section>
  );
}
