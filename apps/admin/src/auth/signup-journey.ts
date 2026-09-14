/**
 * The one description of what signing up involves, and the memory that carries
 * a visitor's plan choice across it.
 *
 * Signup spans four routes and a round trip through Stripe, so "which step am
 * I on" was previously answered separately on each screen — one of them said
 * "Step 2 of 2" while two more steps followed. Naming the sequence once means
 * the stepper, the copy, and the redirects cannot disagree.
 *
 * Order is details -> verify -> plan -> app (D-103). Verification comes before
 * payment because a mailbox nobody can reach is a worse thing to discover after
 * a card has been entered than before, and because it removes the "pay now,
 * verify later" branch that left the last step feeling optional.
 */

export const SIGNUP_STEPS = [
  {
    id: "details",
    label: "Your details",
    description: "Create the organization and its first Company Admin.",
  },
  {
    id: "verify",
    label: "Verify email",
    description: "Confirm the address we will send every alert to.",
  },
  {
    id: "plan",
    label: "Choose a plan",
    description: "Start the free trial. A card is required; nothing is charged today.",
  },
] as const;

export type SignupStepId = (typeof SIGNUP_STEPS)[number]["id"];

export const SIGNUP_STEP_COUNT = SIGNUP_STEPS.length;

export function signupStepNumber(id: SignupStepId): number {
  return SIGNUP_STEPS.findIndex((step) => step.id === id) + 1;
}

/**
 * The plan a visitor clicked on the pricing page.
 *
 * It used to travel as a `?plan=` query parameter, which worked only while
 * registration led straight to the picker. With verification in between — and a
 * verification link that may well be opened in a different tab — the parameter
 * no longer survives the journey, so the choice is parked in `localStorage`
 * instead and cleared once checkout has been started.
 *
 * Every accessor is defensive: storage throws in a private window, and a
 * preselected tier is a convenience, never a correctness requirement. The
 * catalog is still the authority on which tiers exist.
 */
const PLAN_KEY = "fev.signup.plan";
const INTERVAL_KEY = "fev.signup.interval";

export type SignupIntent = {
  tier: string | null;
  interval: "annual" | "monthly" | null;
};

function readKey(key: string): string | null {
  try {
    return window.localStorage.getItem(key);
  } catch {
    return null;
  }
}

function writeKey(key: string, value: string | null): void {
  try {
    if (value === null) window.localStorage.removeItem(key);
    else window.localStorage.setItem(key, value);
  } catch {
    // A visitor with storage disabled simply starts on the entry tier.
  }
}

function asInterval(raw: string | null): "annual" | "monthly" | null {
  return raw === "annual" || raw === "monthly" ? raw : null;
}

/** Capture what the pricing CTA carried, at the point registration is submitted. */
export function rememberSignupIntent(params: URLSearchParams | null): void {
  if (typeof window === "undefined" || params === null) return;
  const tier = params.get("plan");
  if (tier) writeKey(PLAN_KEY, tier);
  const interval = asInterval(params.get("interval"));
  if (interval) writeKey(INTERVAL_KEY, interval);
}

export function readSignupIntent(): SignupIntent {
  if (typeof window === "undefined") return { tier: null, interval: null };
  // A `?plan=` on the current URL still wins: someone who lands directly on the
  // picker from a pricing link should see that plan, not a stale earlier one.
  let fromUrl: URLSearchParams | null = null;
  try {
    fromUrl = new URLSearchParams(window.location.search);
  } catch {
    fromUrl = null;
  }
  return {
    tier: fromUrl?.get("plan") ?? readKey(PLAN_KEY),
    interval: asInterval(fromUrl?.get("interval") ?? null) ?? asInterval(readKey(INTERVAL_KEY)),
  };
}

export function clearSignupIntent(): void {
  if (typeof window === "undefined") return;
  writeKey(PLAN_KEY, null);
  writeKey(INTERVAL_KEY, null);
}
