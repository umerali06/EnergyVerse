import Link from "next/link";

import { LEGAL_ROUTES } from "./legal-content";

/**
 * The commercial disclosures the package requires before money changes hands.
 *
 * Two placements, one source. The pricing page has to say that published
 * pricing is annual, that monthly carries a premium, that enterprise may be
 * custom-quoted, and that taxes may apply. The checkout has to say the same
 * and additionally link every policy the purchase is subject to — a customer
 * should not have to leave the payment step to find out what they are agreeing
 * to.
 */

export function PricingLegalNote({ className }: { className?: string }) {
  return (
    <p
      className={`text-caption leading-relaxed text-text-muted ${className ?? ""}`}
      data-testid="pricing-legal-note"
    >
      Plan features, facility limits, asset limits, seat limits, AI usage, support levels, and
      add-ons are subject to the applicable{" "}
      <Link
        className="underline underline-offset-2 hover:text-accent-600 dark:hover:text-accent-400"
        href="/terms"
      >
        Terms of Service
      </Link>
      , order form, and enterprise agreement. Taxes may apply. Published tier pricing is billed
      annually unless otherwise stated. Monthly billing, where offered, may carry an approximately
      15% premium. Enterprise pricing may be custom-quoted.
    </p>
  );
}

/**
 * Shown on the plan step, beside the button that opens Stripe. Names what the
 * purchase is subject to and links each policy, so the disclosures are present
 * before payment is authorized rather than only after.
 */
export function CheckoutLegalNote({ className }: { className?: string }) {
  return (
    <div
      className={`rounded-lg border border-border bg-elevated p-4 ${className ?? ""}`}
      data-testid="checkout-legal-note"
    >
      <p className="text-caption leading-relaxed text-text-secondary">
        The tier, billing interval, base price, and included facilities, assets, and seats shown
        above are what will be charged. Subscriptions renew automatically for the billing period
        shown at checkout unless cancelled or non-renewed. Taxes and usage-based charges may apply.
        Published tier pricing is billed annually; monthly billing, where offered, may carry an
        approximately 15% premium.
      </p>
      <ul className="mt-3 flex flex-wrap gap-x-4 gap-y-1">
        {LEGAL_ROUTES.filter((route) => route.href !== "/cookie-policy").map((route) => (
          <li key={route.href}>
            <Link
              className="text-caption font-semibold text-accent-600 underline underline-offset-2 dark:text-accent-400"
              href={route.href}
              rel="noreferrer"
              target="_blank"
            >
              {route.label}
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

/** The one-line acceptance shown on the sign-in and sign-up screens. */
export function AuthLegalNote({ className }: { className?: string }) {
  return (
    <p className={`text-caption leading-relaxed text-text-muted ${className ?? ""}`}>
      By creating or activating an account, you agree to the{" "}
      <Link
        className="underline underline-offset-2 hover:text-accent-600 dark:hover:text-accent-400"
        href="/terms"
      >
        Terms of Service
      </Link>{" "}
      and{" "}
      <Link
        className="underline underline-offset-2 hover:text-accent-600 dark:hover:text-accent-400"
        href="/privacy"
      >
        Privacy Policy
      </Link>{" "}
      and acknowledge the{" "}
      <Link
        className="underline underline-offset-2 hover:text-accent-600 dark:hover:text-accent-400"
        href="/industrial-disclaimer"
      >
        AI, AR/VR, Industrial Safety &amp; Operations Disclaimer
      </Link>
      .
    </p>
  );
}
