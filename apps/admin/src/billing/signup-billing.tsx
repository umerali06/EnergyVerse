"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import { ApiClientError } from "@/api";
import { useAuth } from "@/auth/auth-context";
import { SignupSteps } from "@/auth/signup-steps";
import { CheckoutLegalNote } from "@/legal/commercial-notices";
import {
  clearSignupIntent,
  readSignupIntent,
  SIGNUP_STEP_COUNT,
  signupStepNumber,
} from "@/auth/signup-journey";
import { Button, Card, Logo, MotionSection, PageLoader, StatusPill } from "@/design-system";
import { APP_HOME, SIGNUP_BILLING } from "@/navigation/routes";
import type {
  BillingCatalogResponse,
  BillingPlanResponse,
  SubscriptionResponse,
} from "@fev/api-client";

/**
 * The last step of signup, and the page Stripe returns to.
 *
 * The plan list comes from `GET /billing/catalog` — the same catalog the API
 * enforces against — rather than from a copy in the client, so the picker can
 * never offer a tier the server will not sell. Amounts are rendered from the
 * catalog's cents values for the same reason.
 *
 * By the time either screen renders, the admin's email is already verified
 * (D-103): `RequireAccount` will not admit anyone else. That is what lets the
 * completion screen finish in the app rather than handing off to a further
 * step.
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
        <div className="mt-8">
          <SignupSteps current="plan" />
        </div>
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
  // A custom-quoted plan has no amount at either interval; it publishes a floor
  // to anchor the conversation and is bought through sales.
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

  const body = (
    <>
      <span className="flex items-center gap-2">
        <span className="text-bodySmall font-semibold text-text-primary">{plan.name}</span>
        {plan.selfServe ? null : (
          <span className="rounded-full border border-border px-2 py-0.5 font-mono text-micro uppercase tracking-wider text-text-muted">
            custom
          </span>
        )}
      </span>
      {plan.selfServe ? (
        <>
          <span className="mt-3 font-heading text-h2 font-bold leading-none text-text-primary">
            {money(amount ?? 0)}
          </span>
          <span className="mt-1 text-caption text-text-muted">{per}</span>
          {/* Both prices, before payment: the interval toggle changes what is
              charged, so the alternative has to be visible rather than found. */}
          <span className="mt-1 font-mono text-micro text-text-muted">
            {interval === "annual"
              ? `${money(plan.monthlyCents ?? 0)}/mo if billed monthly`
              : `${money(plan.annualTotalCents ?? 0)}/yr if billed annually`}
          </span>
        </>
      ) : (
        <>
          <span className="mt-3 font-heading text-h4 font-bold leading-tight text-text-primary">
            Custom pricing
          </span>
          <span className="mt-1 text-caption text-text-muted">
            Starting around {money(plan.startingMonthlyCents ?? 0)}/month
          </span>
        </>
      )}
      <span className="mt-4 grid gap-1 font-mono text-micro text-text-secondary">
        <span>{facilities}</span>
        <span>{assets}</span>
        <span>{seats}</span>
      </span>
      <span className="mt-4 border-t border-border pt-3 text-caption text-text-secondary">
        {plan.support}
      </span>
    </>
  );

  const shell =
    "flex h-full flex-col rounded-xl border p-5 text-left transition-colors";

  // Not a selectable option at all: there is no Price to open a session
  // against, so offering it as one would end in a 400 from the API.
  if (!plan.selfServe) {
    return (
      <Link
        className={`${shell} border-dashed border-border bg-surface hover:border-primary-400/60`}
        data-plan-tier={plan.tier}
        href="/contact?topic=enterprise"
      >
        {body}
        <span className="mt-4 text-caption font-semibold text-primary-600 dark:text-primary-400">
          Request a quote →
        </span>
      </Link>
    );
  }

  return (
    <button
      aria-pressed={selected}
      className={`${shell} ${
        selected
          ? "border-accent-500 bg-elevated"
          : "border-border bg-surface hover:border-primary-400/60"
      }`}
      data-plan-tier={plan.tier}
      onClick={onSelect}
      type="button"
    >
      {body}
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
        if (subscription.isEntitled) router.replace(APP_HOME);
      } catch {
        // A failure here just means we cannot skip the step; the picker stands.
      }
    })();
    return () => controller.abort();
  }, [client, router]);

  useEffect(() => {
    const controller = new AbortController();
    void (async () => {
      try {
        const loaded = await client.getBillingCatalog(controller.signal);
        setCatalog(loaded);
        // Pre-select whatever the visitor clicked on the pricing page — carried
        // here through registration and verification — else the entry tier.
        const intent = readSignupIntent();
        const match = loaded.plans.find((plan) => plan.tier === intent.tier);
        setTier((match ?? loaded.plans[0])?.tier ?? null);
        if (intent.interval) setInterval(intent.interval);
      } catch {
        if (!controller.signal.aborted) {
          setLoadError("We could not load the plans. Check your connection and retry.");
        }
      }
    })();
    return () => controller.abort();
  }, [client]);

  const selected = useMemo(
    // A custom-quoted tier is never "selected", even if an intent carried one
    // in from a pricing-page link: there is no Price to check out against.
    () => catalog?.plans.find((plan) => plan.tier === tier && plan.selfServe) ?? null,
    [catalog, tier],
  );

  // Only a Company Admin may attach billing (`require_billing_admin`). Anyone
  // else who arrives here — an invited inspector whose company never finished
  // checkout, sent on by `RequireSubscription` — cannot act, and offering them
  // a picker whose button answers 403 would be a second dead end.
  const canBuy = auth.currentUser?.permissions.has("company.settings") !== false;

  const startCheckout = useCallback(async () => {
    if (!selected || redirecting) return;
    setCheckoutError(null);
    setRedirecting(true);
    try {
      const session = await client.createCheckoutSession({
        tier: selected.tier,
        interval,
      });
      // The choice has been acted on; nothing downstream should re-apply it.
      clearSignupIntent();
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
        <StatusPill tone="info">
          Step {signupStepNumber("plan")} of {SIGNUP_STEP_COUNT}
        </StatusPill>
        <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
          Choose your plan
        </h1>
        <p className="mt-2 max-w-2xl text-body text-text-secondary">
          {catalog
            ? `Your ${catalog.trialDays}-day trial starts as soon as checkout completes. A card is required, and nothing is charged until the trial ends.`
            : "Your free trial starts as soon as checkout completes."}
        </p>
        <p className="mt-3 max-w-2xl text-bodySmall text-text-muted">
          This is the last step — your workspace opens as soon as the subscription is active.
        </p>

        {!canBuy ? (
          <Card className="mt-8 max-w-xl p-6">
            <p className="text-body text-text-secondary" role="alert">
              Your company does not have an active subscription yet, and only a Company Admin can
              start one. Ask your admin to sign in and choose a plan — everything else is ready.
            </p>
            <div className="mt-5">
              <Button onClick={() => void auth.signOut()} variant="ghost">
                Sign out
              </Button>
            </div>
          </Card>
        ) : loadError ? (
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
              {catalog.annualMonthsCharged
                ? `Annual is charged as ${catalog.annualMonthsCharged} months for twelve months of service — ${12 - catalog.annualMonthsCharged} months free.`
                : "Choose how you would like to be billed."}
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

            {selected ? (
              // Say the exact amount and cadence before the button that leaves
              // for Stripe, so nothing about the charge is first seen there.
              <p className="mt-6 text-bodySmall text-text-secondary" data-testid="checkout-summary">
                <strong className="font-semibold text-text-primary">{selected.name}</strong> —{" "}
                {interval === "annual"
                  ? `${money(selected.annualTotalCents ?? 0)} per year (${money(
                      selected.annualMonthlyEquivalentCents ?? 0,
                    )}/mo), billed annually`
                  : `${money(selected.monthlyCents ?? 0)} per month, billed monthly`}
                . Nothing is charged for {catalog.trialDays} days.
              </p>
            ) : null}

            <div className="mt-6 flex flex-wrap items-center gap-4">
              <Button disabled={!selected} loading={redirecting} onClick={startCheckout}>
                {selected
                  ? `Start ${catalog.trialDays}-day trial on ${selected.name}`
                  : "Choose a plan to continue"}
              </Button>
              <p className="text-caption text-text-muted">
                You will be taken to Stripe. We never see your card details.
              </p>
            </div>
            <p className="mt-3 text-caption text-text-muted">
              Have a founding-customer or discount code? Enter it on the Stripe checkout page —
              the discounted amount is shown there before you pay.
            </p>

            {/* Required before payment authorization: what is being bought,
                how it renews, and every policy it is subject to. */}
            <CheckoutLegalNote className="mt-8 max-w-3xl" />
          </>
        )}
      </MotionSection>
    </BillingShell>
  );
}

/** The support address shown when confirmation genuinely cannot be completed.
 * Named once so the two failure branches cannot drift. */
const BILLING_SUPPORT_EMAIL = "support@flacronenterprises.com";

type ConfirmState = "confirming" | "active" | "failed";

/**
 * The page Stripe returns to.
 *
 * Stripe redirects the browser back as soon as the payment page is finished,
 * which is **before** it has necessarily delivered `checkout.session.completed`
 * — the redirect is not the confirmation. This screen used to do nothing but
 * poll the read model waiting for that webhook, so a webhook that was slow, or
 * an endpoint that was not reachable at all, showed a completed purchase as a
 * failure and then offered "Continue anyway", which dropped the person into an
 * app with no plan behind it.
 *
 * It now confirms actively: Stripe substitutes the session id into the success
 * URL, and `POST /billing/checkout/confirm` reads that session back and applies
 * the subscription. The webhook is still the authority for everything that
 * happens later (renewals, failures, cancellation) — this just removes it from
 * the critical path of signup. Polling remains as the fallback for the one case
 * confirmation cannot cover: a return URL that arrived without a session id.
 */
export function SignupCompleteScreen({
  reducedMotionOverride,
  pollIntervalMs = 2_000,
  maxAttempts = 20,
  /** A beat on the success state before the workspace opens, so the plan name
   * is readable rather than a flash. */
  redirectDelayMs = 1_200,
}: {
  reducedMotionOverride?: boolean;
  pollIntervalMs?: number;
  maxAttempts?: number;
  redirectDelayMs?: number;
}) {
  const router = useRouter();
  const auth = useAuth();
  const client = auth.apiClient;
  const [subscription, setSubscription] = useState<SubscriptionResponse | null>(null);
  const [attempts, setAttempts] = useState(0);
  const [state, setState] = useState<ConfirmState>("confirming");
  // Bumping this restarts the effect for the "Check again" button.
  const [round, setRound] = useState(0);
  const sessionId = useRef<string | null>(null);

  if (sessionId.current === null && typeof window !== "undefined") {
    sessionId.current = new URLSearchParams(window.location.search).get("session_id");
  }

  useEffect(() => {
    if (state === "active") return;
    if (attempts >= maxAttempts) {
      setState("failed");
      return;
    }
    const controller = new AbortController();
    const timer = window.setTimeout(
      () => {
        void (async () => {
          try {
            // Ask Stripe about this exact session first. `pending` means Stripe
            // has the session but has not attached a subscription to it yet, so
            // it is a reason to try again, not a failure.
            const id = sessionId.current;
            if (id) {
              const confirmed = await client.confirmCheckoutSession(id, controller.signal);
              setSubscription(confirmed.subscription);
              if (confirmed.subscription.isEntitled) {
                setState("active");
                return;
              }
            } else {
              // No session id to confirm against — a hand-typed or truncated
              // return URL. Fall back to the read model, which a webhook will
              // have filled in.
              const next = await client.getSubscription(controller.signal);
              setSubscription(next);
              if (next.isEntitled) {
                setState("active");
                return;
              }
            }
          } catch (failure) {
            // A transient failure is not a failed payment, so keep trying —
            // but a 400 is the server's considered answer about this session
            // (it belongs to another company, or it expired), and repeating it
            // twenty times only delays the message that actually helps.
            if (failure instanceof ApiClientError && failure.status === 400) {
              if (!controller.signal.aborted) setState("failed");
              return;
            }
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
  }, [attempts, client, maxAttempts, pollIntervalMs, round, state]);

  // Nothing is left to decide once the subscription is live: the email is
  // already verified, so the workspace is simply open. The button stays for
  // anyone who would rather click than wait.
  useEffect(() => {
    if (state !== "active") return;
    const timer = window.setTimeout(() => router.replace(APP_HOME), redirectDelayMs);
    return () => window.clearTimeout(timer);
  }, [redirectDelayMs, router, state]);

  const retry = useCallback(() => {
    setState("confirming");
    setAttempts(0);
    setRound((value) => value + 1);
  }, []);

  return (
    <BillingShell>
      <MotionSection className="mt-8" reducedMotionOverride={reducedMotionOverride}>
        {state === "active" ? (
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
              Your workspace is ready — taking you there now.
            </p>
            <div className="mt-7">
              <Button onClick={() => router.replace(APP_HOME)}>Go to dashboard</Button>
            </div>
          </>
        ) : state === "failed" ? (
          <>
            <StatusPill tone="warning">Not confirmed yet</StatusPill>
            <h1 className="mt-4 font-heading text-h1 font-bold text-text-primary">
              We could not confirm your subscription
            </h1>
            <p className="mt-2 max-w-xl text-body text-text-secondary" role="status">
              Stripe has your details, but we have not been able to read the completed subscription
              back. Nothing is lost and you have not been charged twice — checking again is safe.
            </p>
            <div className="mt-7 flex flex-wrap gap-3">
              <Button onClick={retry}>Check again</Button>
              <Button onClick={() => router.replace(SIGNUP_BILLING)} variant="ghost">
                Back to plans
              </Button>
            </div>
            {/* No "continue anyway": the app is unusable without a plan, and
                offering it only moved the dead end one screen later. */}
            <Card className="mt-8 max-w-xl p-5">
              <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
                Still stuck?
              </p>
              <p className="mt-2.5 text-bodySmall leading-relaxed text-text-secondary">
                Email{" "}
                <a
                  className="font-mono text-text-primary underline underline-offset-2"
                  href={`mailto:${BILLING_SUPPORT_EMAIL}`}
                >
                  {BILLING_SUPPORT_EMAIL}
                </a>{" "}
                {sessionId.current ? (
                  <>
                    and quote checkout reference{" "}
                    <span className="font-mono text-text-primary">{sessionId.current}</span>
                  </>
                ) : (
                  "with the email address you signed up with"
                )}
                . We can activate the subscription by hand.
              </p>
            </Card>
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
