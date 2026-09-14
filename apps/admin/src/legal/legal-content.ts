/**
 * The operator identity and the shape every legal document is written in.
 *
 * The documents are structured data rather than prose in JSX for three reasons
 * the package itself asks for: a table of contents has to be generated from the
 * real headings, the "Last Updated" date and accepted version have to come from
 * one place, and the same notice text has to appear both in a policy page and
 * as an in-app warning without being retyped.
 *
 * `LEGAL_VERSION` is the string recorded against a user's acceptance. Bump it
 * whenever a material change is published; the API stores whatever is sent, so
 * the value here is what decides whether re-acceptance is required.
 */

export const OPERATOR = {
  product: "Flacron Energy",
  operator: "Flacron Enterprises LLC",
  address: "410 E 95th St, Brooklyn, NY 11212, United States",
  phone: "929-990-1182",
  /** E.164 for the `tel:` link; the display form above stays as published. */
  phoneHref: "tel:+19299901182",
  email: "Contact@flacronenterprises.com",
  platformType:
    "Enterprise AI + AR/VR platform for oil, gas, energy, utilities, and industrial operations",
  branding: "Powered by Flacron Engine",
  tagline: "Smart energy. Endless possibilities. A brighter tomorrow.",
} as const;

/** Recorded against every acceptance. Bump on a material change. */
export const LEGAL_VERSION = "2026-09-14";
export const LEGAL_LAST_UPDATED = "September 14, 2026";

export type LegalBlock =
  | { kind: "p"; text: string }
  | { kind: "list"; items: readonly string[] }
  /** The bordered callouts the package specifies for safety and AI notices. */
  | { kind: "notice"; title: string; text: string; tone?: "info" | "warning" }
  /** Renders the operator identity table; repeated at the foot of each policy. */
  | { kind: "contact" }
  | { kind: "table"; head: readonly string[]; rows: readonly (readonly string[])[] };

export type LegalSection = {
  /** Anchor target, also the table-of-contents link. */
  id: string;
  title: string;
  blocks: readonly LegalBlock[];
};

export type LegalDocument = {
  slug: LegalSlug;
  /** Page `<h1>`; also the link label in the footer and the acceptance text. */
  title: string;
  /** One line under the title, before the first section. */
  lede: string;
  /** Blocks rendered before the first numbered section. */
  intro?: readonly LegalBlock[];
  sections: readonly LegalSection[];
};

export type LegalSlug =
  | "privacy"
  | "terms"
  | "industrial-disclaimer"
  | "refund-policy"
  | "cookie-policy";

/** The routes the package requires, and the labels used in the footer. */
export const LEGAL_ROUTES = [
  { href: "/privacy", label: "Privacy Policy" },
  { href: "/terms", label: "Terms of Service" },
  { href: "/industrial-disclaimer", label: "Industrial Safety Disclaimer" },
  { href: "/refund-policy", label: "Refund & Cancellation Policy" },
  { href: "/cookie-policy", label: "Cookie Policy" },
] as const;
