/**
 * Route constants shared by the marketing site, the app shell, and SEO.
 *
 * Phase 12 moved the signed-in dashboard off `/` so the public marketing
 * landing page could own it. Every redirect that used to target `/` now targets
 * `APP_HOME`, so the app's home can move again without hunting for literals.
 */

/** Where an authenticated user lands: post-login, post-verification, and every
 * "back to the app" affordance. */
export const APP_HOME = "/dashboard";

/** Step 2 of signup: confirm the mailbox. Everything after it — the plan
 * picker, Stripe, the app — is behind a verified address (D-103). */
export const VERIFY_EMAIL = "/verify-email";

/** Step 3 of signup: choose a plan and go to Stripe. Reachable once the
 * address is verified and until the company has an active subscription. */
export const SIGNUP_BILLING = "/signup/plan";

/** Where Stripe returns the browser after a completed checkout. */
export const SIGNUP_COMPLETE = "/signup/complete";

/** Public, indexable, unguarded marketing pages. Includes the legal package
 * (D-105): every policy must be reachable without an account and must be
 * crawlable, since customers and reviewers read them before signing up. */
export const marketingRoutes = [
  "/",
  "/pricing",
  "/about",
  "/contact",
  "/privacy",
  "/terms",
  "/industrial-disclaimer",
  "/refund-policy",
  "/cookie-policy",
] as const;

/** Public, indexable auth pages. Guarded by `PublicOnly` — an authenticated
 * visitor is bounced to `APP_HOME` — but crawlable so signup is findable. */
export const authRoutes = ["/login", "/signup", "/forgot-password"] as const;

/**
 * Everything behind authentication, as robots.txt prefixes. Kept explicit
 * rather than derived from `navGroups` because several private routes are not
 * nav items (`/qr`, `/rbac-demo`, `/verify-email`, `/design-system`). Add new
 * private top-level segments here.
 */
export const privateRoutePrefixes = [
  "/dashboard",
  "/assets",
  "/inspections",
  "/digital-twin",
  "/checklist-templates",
  "/work-orders",
  "/permits",
  "/safety",
  "/reports",
  "/documents",
  "/users",
  "/roles",
  "/settings",
  "/audit",
  "/platform",
  "/qr",
  "/rbac-demo",
  "/verify-email",
  "/design-system",
  // The signup billing steps carry a session; never crawl them.
  "/signup/plan",
  "/signup/complete",
] as const;
