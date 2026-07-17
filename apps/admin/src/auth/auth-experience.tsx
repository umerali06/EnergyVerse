"use client";

import { type FormEvent, useEffect, useState } from "react";

import { Badge, Button, Card, Input, MotionSection, Spinner, StatusPill } from "@/design-system";

import { useAuth } from "./auth-context";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const strongPassword = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
const resendCooldownSeconds = 60;

export function AuthExperience({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const auth = useAuth();
  const [screen, setScreen] = useState<"login" | "signup">("login");
  if (auth.status === "restoring") {
    return (
      <main className="grid min-h-screen place-items-center bg-background p-6">
        <Spinner label="Restoring session" />
      </main>
    );
  }
  if (
    (auth.status === "verificationRequired" || auth.status === "checkingVerification") &&
    auth.currentUser
  ) {
    return <VerifyEmailScreen reducedMotionOverride={reducedMotionOverride} />;
  }
  if (auth.status === "authenticated" && auth.currentUser) {
    return <AuthenticatedHome reducedMotionOverride={reducedMotionOverride} />;
  }
  if (screen === "signup") {
    return (
      <SignupScreen
        onBack={() => setScreen("login")}
        reducedMotionOverride={reducedMotionOverride}
      />
    );
  }
  return (
    <LoginScreen
      onSignup={() => setScreen("signup")}
      reducedMotionOverride={reducedMotionOverride}
    />
  );
}

function Brand() {
  return (
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
    <main className="relative grid min-h-screen place-items-center overflow-hidden bg-background p-6">
      <div
        aria-hidden
        className="absolute inset-0 bg-[radial-gradient(circle_at_20%_10%,rgba(37,99,235,0.2),transparent_35%),radial-gradient(circle_at_85%_85%,rgba(249,115,22,0.12),transparent_32%)]"
      />
      <MotionSection
        className={`relative z-10 w-full ${wide ? "max-w-2xl" : "max-w-md"}`}
        reducedMotionOverride={reducedMotionOverride}
      >
        <Card className="border-border/90 bg-surface/95 p-8 backdrop-blur">{children}</Card>
      </MotionSection>
    </main>
  );
}

function LoginScreen({
  onSignup,
  reducedMotionOverride,
}: {
  onSignup: () => void;
  reducedMotionOverride?: boolean;
}) {
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
              className="rounded-md px-2 py-1 text-caption font-semibold text-primary-400"
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
        <Button className="w-full" loading={loading} type="submit">
          Login
        </Button>
      </form>
      <div className="mt-6 flex justify-between gap-4 text-bodySmall">
        <button className="cursor-not-allowed text-text-muted" disabled type="button">
          Forgot password?
        </button>
        <button className="font-semibold text-primary-400 hover:text-primary-300" onClick={onSignup} type="button">
          Sign up
        </button>
      </div>
    </AuthShell>
  );
}

type SignupErrors = Partial<Record<"company" | "display" | "email" | "password" | "confirm", string>>;

function SignupScreen({
  onBack,
  reducedMotionOverride,
}: {
  onBack: () => void;
  reducedMotionOverride?: boolean;
}) {
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
      className="rounded-md px-2 py-1 text-caption font-semibold text-primary-400"
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
        <Input disabled={loading} error={errors.company} label="Company name" onChange={(e) => setCompanyName(e.target.value)} value={companyName} />
        <Input disabled={loading} error={errors.display} label="Display name" onChange={(e) => setDisplayName(e.target.value)} value={displayName} />
        <div className="md:col-span-2">
          <Input autoComplete="email" disabled={loading} error={errors.email} label="Email" onChange={(e) => setEmail(e.target.value)} type="email" value={email} />
        </div>
        <Input autoComplete="new-password" disabled={loading} endAdornment={toggle} error={errors.password} label="Password" onChange={(e) => setPassword(e.target.value)} type={showPassword ? "text" : "password"} value={password} />
        <Input autoComplete="new-password" disabled={loading} error={errors.confirm} label="Confirm password" onChange={(e) => setConfirm(e.target.value)} type={showPassword ? "text" : "password"} value={confirm} />
        {authError && <div className="md:col-span-2"><InlineError message={authError} /></div>}
        <div className="flex gap-3 md:col-span-2">
          <Button className="flex-1" disabled={loading} onClick={onBack} type="button" variant="ghost">Back to login</Button>
          <Button className="flex-1" loading={loading} type="submit">Create organization</Button>
        </div>
      </form>
    </AuthShell>
  );
}

function VerifyEmailScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
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
        We sent a verification link to <strong className="text-text-primary">{auth.currentUser?.email}</strong>.
        Open it, then return here to continue.
      </p>
      {auth.error && <div className="mt-5"><InlineError message={auth.error} /></div>}
      <div className="mt-7 grid gap-3">
        <Button loading={auth.status === "checkingVerification"} onClick={() => void auth.refreshVerification()}>
          I&apos;ve verified — continue
        </Button>
        <Button disabled={cooldown > 0} onClick={() => void resend()} variant="ghost">
          {cooldown > 0 ? `Resend available in ${cooldown}s` : "Resend verification"}
        </Button>
        <button className="mt-2 text-bodySmall font-semibold text-primary-400" onClick={() => void auth.signOut()} type="button">
          Back to login
        </button>
      </div>
    </AuthShell>
  );
}

function InlineError({ message }: { message: string }) {
  return <p className="rounded-lg border border-status-critical/40 bg-status-critical/10 p-3 text-bodySmall text-status-critical" role="alert">{message}</p>;
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
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-400">FEV authenticated workspace</p>
            <h1 className="mt-2 text-h2 font-bold capitalize">Welcome, {name}</h1>
            <p className="mt-2 text-text-secondary">{currentUser.email}</p>
          </div>
          <Button onClick={() => void signOut()} variant="ghost">Sign out</Button>
        </header>
        <div className="mt-8 grid gap-6 md:grid-cols-[0.8fr_1.2fr]">
          <Card>
            <StatusPill tone="healthy">Authenticated</StatusPill>
            <dl className="mt-6 grid gap-4 text-body">
              <div><dt className="text-text-muted">Role</dt><dd className="mt-1 font-semibold">{currentUser.roleKey}</dd></div>
              <div><dt className="text-text-muted">Company</dt><dd className="mt-1 font-mono text-bodySmall">{currentUser.companyId}</dd></div>
              <div><dt className="text-text-muted">Firebase UID</dt><dd className="mt-1 break-all font-mono text-bodySmall">{currentUser.uid}</dd></div>
            </dl>
          </Card>
          <Card>
            <h2 className="text-h4 font-bold">Resolved permissions</h2>
            <p className="mt-2 text-body text-text-secondary">Authoritative permissions returned by `/api/v1/auth/me`.</p>
            <div className="mt-5 flex flex-wrap gap-2">
              {[...currentUser.permissions].sort().map((permission) => <Badge key={permission}>{permission}</Badge>)}
            </div>
          </Card>
        </div>
      </MotionSection>
    </main>
  );
}
