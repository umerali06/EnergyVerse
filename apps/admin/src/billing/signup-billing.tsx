"use client";

import { useRouter } from "next/navigation";
import { useCallback, useEffect, useMemo, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Button, Card, Logo, MotionSection, PageLoader, StatusPill } from "@/design-system";
import { APP_HOME } from "@/navigation/routes";
import type {
  BillingCatalogResponse,
  BillingPlanResponse,
  SubscriptionResponse,
} from "@fev/api-client";

/**
 * Step 2 of signup, and the page Stripe returns to.
 *
 * The plan list comes from `GET /billing/catalog` — the same catalog the API
 * enforces against — rather than from a copy in the client, so the picker can
 * never offer a tier the server will not sell. Amounts are rendered from the
 * catalog's cents values for the same reason.
 */

const currency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 2,
});

function money(cents: number): string {
  return currency.format(cents / 100);
}

type Interval = "annual" | "monthly";

function BillingShell({ children }: { children: React.ReactNode }) {
  return (
    <main className="min-h-screen bg-background px-5 py-12 md:px-8">
      <div className="mx-auto w-full max-w-5xl">
        <Logo height={26} priority variant="wordmark" />
        {children}
      </div>
    </main>
  );
}

function PlanCard({
  plan,
  interval,
  selected,
  onSelect,
}: {
  plan: BillingPlanResponse;
  interval: Interval;
  selected: boolean;
  onSelect: () => void;
}) {
  const amount = interval === "annual" ? plan.annualTotalCents : plan.monthlyCents;
  const per = interval === "annual" ? "per year" : "per month";
  const quotas = plan.quotas;
  const facilities =
    quotas.facilities === null || quotas.facilities === undefined
      ? "Unlimited facilities"
      : quotas.facilities === 1
        ? "1 facility"
        : `${quotas.facilities} facilities`;
  const assets =
    quotas.assets === null || quotas.assets === undefined
      ? "Unlimited assets"
      : `${quotas.assets.toLocaleString("en-US")} assets`;
  const seats =
    quotas.seats === null || quotas.seats === undefined
      ? "Unlimited seats"
      : `${quotas.seats} seats`;

  return (
    <button
      aria-pressed={selected}
      className={`flex h-full flex-col rounded-xl border p-5 text-left transition-colors ${
        selected
          ? "border-accent-500 bg-elevated"
          : "border-border bg-surface hover:border-primary-400/60"
      }`}
      data-plan-tier={plan.tier}
      onClick={onSelect}
      type="button"
    >
      <span className="flex items-center gap-2">
        <span className="text-bodySmall font-semibold text-text-primary">{plan.name}</span>
        {plan.customQuoted ? (
          <span className="rounded-full border border-border px-2 py-0.5 font-mono text-micro uppercase tracking-wider text-text-muted">
            from
          </span>
        ) : null}
      </span>
      <span className="mt-3 font-heading text-h2 font-bold leading-none text-text-primary">
        {money(amount)}
      </span>
      <span className="mt-1 text-caption text-text-muted">{per}</span>
      <span className="mt-4 grid gap-1 font-mono text-micro text-text-secondary">
        <span>{facilities}</span>
        <span>{assets}</span>
        <span>{seats}</span>
      </span>
      <span className="mt-4 border-t border-border pt-3 text-caption text-text-secondary">
        {plan.support}
      </span>
    </button>
  );
}

export function SignupPlanScreen({ reducedMotionOverride }: { reducedMotionOverride?: boolean }) {
  const router = useRouter();
  const auth = useAuth();
  const client = auth.apiClient;
  const [catalog, setCatalog] = useState<BillingCatalogResponse | null>(null);
  const [tier, setTier] = useState<string | null>(null);
  const [interval, setInterval] = useState<Interval>("annual");
  const [loadError, setLoadError] = useState<string | null>(null);
  const [checkoutError, setCheckoutError] = useState<string | null>(null);
  const [redirecting, setRedirecting] = useState(false);

  // Already subscribed? Then this step is behind us. Forward rather than
  // letting someone buy a second subscription for the same company.
  useEffect(() => {
    const controller = new AbortController();
    void (async () => {
      try {
        const subscription = await client.getSubscription(controller.signal);
        if (subscription.isEntitled) {
          router.replace(auth.status === "authenticated" ? APP_HOME : "/verify-email");
        }
      } catch {
        // A failure here just means we cannot skip the step; the picker stands.
      }
    })();
    return () => controller.abort();
  }, [auth.status, client, router]);

  useEffect(() => {
    const controller = new AbortController();
    void (async () => {
      try {
        const loaded = await client.getBillingCatalog(controller.signal);
        setCatalog(loaded);
        // Pre-select whatever the visitor clicked on the pricing page, else the
        // entry tier.
        const wanted =
          new URLSearchParams(window.location.search).get("plan") ?? loaded.plans[0]?.tier;
        const match = loaded.plans.find((plan) => plan.tier === wanted);
        setTier((match ?? loaded.plans[0])?.tier ?? null);
      } catch {
        if (!controller.signal.aborted) {
          setLoadError("We could not load the plans. Check your connection and retry.");
        }
      }
    })();
    return () => controller.abort();
  }, [client]);

  const selected = useMemo(
    () => catalog?.plans.find((plan) => plan.tier === tier) ?? null,
    [catalog, tier],
  );

  const startCheckout = useCallback(async () => {
    if (!selected || redirecting) return;
    setCheckoutError(null);
    setRedirecting(true);
    try {
      const session = await client.createCheckoutSession({
        tier: selected.tier,
        interval,
      });
      // Full navigation, not a router push: the destination is Stripe.
      window.location.assign(session.checkoutUrl);
    } catch {
      setRedirecting(false);
      setCheckoutError(
        "We could not open the secure checkout. Nothing was charged — please try again.",
      );
    }
  }, [client, interval, redirecting, selected]);

  return (
    <BillingShell>
      <MotionSection className="mt-8" reducedMotionOverride={reducedMotionOverride}>
        <StatusPill tone="info">Step 2 of 2</StatusPill>
        <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
          Choose your plan
        </h1>
        <p className="mt-2 max-w-2xl text-body text-text-secondary">
          {catalog
            ? `Your ${catalog.trialDays}-day trial starts as soon as checkout completes. A card is required, and nothing is charged until the trial ends.`
            : "Your free trial starts as soon as checkout completes."}
        </p>

        {/* Registration already sent a verification link, and nothing told the
            person so — they would meet the requirement for the first time on
            the verify screen. Setting the expectation here costs a line and
            stops the last step feeling like a surprise. */}
        <p className="mt-3 flex max-w-2xl items-start gap-2 text-bodySmall text-text-muted">
          <svg
            aria-hidden
            className="mt-0.5 size-4 shrink-0"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="1.8"
            viewBox="0 0 24 24"
          >
            <path d="M3 7.5 12 13l9-5.5" />
            <rect height="14" rx="2" width="18" x="3" y="5" />
          </svg>
          <span>
            We have emailed a verification link
            {auth.currentUser?.email ? ` to ${auth.currentUser.email}` : ""}. You will confirm it
            right after checkout — no need to leave this tab now.
          </span>
        </p>

        {loadError ? (
          <Card className="mt-8 p-6">
            <p className="text-body text-text-secondary" role="alert">
              {loadError}
            </p>
            <div className="mt-5">
              <Button onClick={() => window.location.reload()} variant="ghost">
                Retry
              </Button>
            </div>
          </Card>
        ) : catalog === null ? (
          <PageLoader label="Loading plans" />
        ) : (
          <>
            <div
              aria-label="Billing interval"
              className="mt-8 inline-flex rounded-full border border-border bg-surface p-1"
              role="group"
            >
              {(["annual", "monthly"] as const).map((option) => (
                <button
                  aria-pressed={interval === option}
                  className={`rounded-full px-4 py-1.5 text-bodySmall font-semibold capitalize transition-colors ${
                    interval === option
                      ? "bg-accent-500 text-accent-ink"
                      : "text-text-secondary hover:text-text-primary"
                  }`}
                  key={option}
                  onClick={() => setInterval(option)}
                  type="button"
                >
                  {option}
                </button>
              ))}
            </div>
            <p className="mt-2 text-caption text-text-muted">
              Annual billing is the listed price; monthly carries a premium.
            </p>

            <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
              {catalog.plans.map((plan) => (
                <PlanCard
                  interval={interval}
                  key={plan.tier}
                  onSelect={() => setTier(plan.tier)}
                  plan={plan}
                  selected={plan.tier === tier}
                />
              ))}
            </div>

            {checkoutError ? (
              <p className="mt-6 text-bodySmall text-status-critical" role="alert">
                {checkoutError}
              </p>
            ) : null}

            <div className="mt-8 flex flex-wrap items-center gap-4">
              <Button loading={redirecting} onClick={startCheckout}>
                {selected
                  ? `Start ${catalog.trialDays}-day trial on ${selected.name}`
                  : "Continue to secure checkout"}
              </Button>
              <p className="text-caption text-text-muted">
                You will be taken to Stripe. We never see your card details.
              </p>
            </div>
          </>
        )}
      </MotionSection>
    </BillingShell>
  );
}

/**
 * Names the outstanding email verification wherever a signup can end.
 *
 * The link is sent during registration, but nothing used to say so: whichever
 * way the flow finished, the requirement appeared for the first time on the
 * verify screen. Rendered on both completion branches — the successful one and
 * the "still confirming" one — because either can be a person's last step.
 */
function VerifyEmailNote() {
  const auth = useAuth();
  return (
    <Card className="mt-8 max-w-xl p-5">
      <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
        One thing left
      </p>
      <p className="mt-2.5 text-bodySmall leading-relaxed text-text-secondary">
        Open the verification link we emailed
        {auth.currentUser?.email ? (
          <>
            {" to "}
            <span className="font-mono text-text-primary">{auth.currentUser.email}</span>
          </>
        ) : (
          " to you"
        )}
        . Your subscription is already set up — this just confirms the address, and the app stays
        locked until you do. Check spam if it has not arrived; you can resend it from the next
        screen.
      </p>
    </Card>
  );
}

/**
 * The page Stripe returns to. Polls the subscription until the webhook has
 * landed, because Stripe redirects the browser back before it has necessarily
 * delivered `checkout.session.completed` — the redirect is not the confirmation.
 */
export function SignupCompleteScreen({
  reducedMotionOverride,
  pollIntervalMs = 2_000,
  maxAttempts = 20,
}: {
  reducedMotionOverride?: boolean;
  pollIntervalMs?: number;
  maxAttempts?: number;
}) {
  const router = useRouter();
  const auth = useAuth();
  const client = auth.apiClient;
  const [subscription, setSubscription] = useState<SubscriptionResponse | null>(null);
  const [attempts, setAttempts] = useState(0);
  const [timedOut, setTimedOut] = useState(false);

  useEffect(() => {
    if (subscription?.isEntitled) return;
    if (attempts >= maxAttempts) {
      setTimedOut(true);
      return;
    }
    const controller = new AbortController();
    const timer = window.setTimeout(
      () => {
        void (async () => {
          try {
            const next = await client.getSubscription(controller.signal);
            setSubscription(next);
          } catch {
            // Keep polling: a transient failure is not a failed payment.
          } finally {
            if (!controller.signal.aborted) setAttempts((count) => count + 1);
          }
        })();
      },
      // Check immediately on mount, then back off to the interval.
      attempts === 0 ? 0 : pollIntervalMs,
    );
    return () => {
      controller.abort();
      window.clearTimeout(timer);
    };
  }, [attempts, client, maxAttempts, pollIntervalMs, subscription]);

  const entitled = subscription?.isEntitled === true;
  const destination = auth.status === "authenticated" ? APP_HOME : "/verify-email";

  return (
    <BillingShell>
      <MotionSection className="mt-8" reducedMotionOverride={reducedMotionOverride}>
        {entitled ? (
          <>
            <StatusPill tone="healthy">Subscription active</StatusPill>
            <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
              You are on {subscription?.planName ?? "your plan"}
            </h1>
            <p className="mt-2 max-w-xl text-body text-text-secondary">
              {subscription?.trialDaysRemaining !== null &&
              subscription?.trialDaysRemaining !== undefined
                ? `Your trial runs for another ${subscription.trialDaysRemaining} day${
                    subscription.trialDaysRemaining === 1 ? "" : "s"
                  }.`
                : "Your subscription is active."}{" "}
              {auth.status === "authenticated"
                ? "Your workspace is ready."
                : "One last step: confirm your email address."}
            </p>
            <div className="mt-7">
              <Button onClick={() => router.replace(destination)}>
                {auth.status === "authenticated" ? "Go to dashboard" : "Verify your email"}
              </Button>
            </div>
            {auth.status === "authenticated" ? null : <VerifyEmailNote />}
          </>
        ) : timedOut ? (
          <>
            <StatusPill tone="warning">Still confirming</StatusPill>
            <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
              Your payment is being confirmed
            </h1>
            <p className="mt-2 max-w-xl text-body text-text-secondary" role="status">
              Stripe has taken your details but we have not received the confirmation yet. This
              usually resolves within a minute and nothing is lost — reload to check again.
            </p>
            <div className="mt-7 flex flex-wrap gap-3">
              <Button
                onClick={() => {
                  setTimedOut(false);
                  setAttempts(0);
                }}
              >
                Check again
              </Button>
              <Button onClick={() => router.replace(destination)} variant="ghost">
                Continue anyway
              </Button>
            </div>
            {auth.status === "authenticated" ? null : <VerifyEmailNote />}
          </>
        ) : (
          <>
            <StatusPill tone="info">Finishing up</StatusPill>
            <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
              Activating your subscription
            </h1>
            <p className="mt-2 max-w-xl text-body text-text-secondary" role="status">
              Confirming your payment with Stripe.
            </p>
            <PageLoader label="Confirming your subscription" />
          </>
        )}
      </MotionSection>
    </BillingShell>
  );
}
