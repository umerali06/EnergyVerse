import type { Metadata } from "next";
import Link from "next/link";

import { ContactForm } from "@/legal/contact-form";
import { LEGAL_ROUTES, OPERATOR } from "@/legal/legal-content";
import { OperatorTable } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Contact",
  "Enterprise support for AI, AR inspections, assets, safety workflows, permits, work orders, reports, 3D visualization, VR training, billing, and platform administration.",
  "/contact",
);

export default function ContactPage() {
  return (
    <div className="px-5 py-14 md:px-8 md:py-20">
      <div className="mx-auto grid w-full max-w-6xl gap-12 lg:grid-cols-[minmax(0,1.35fr)_minmax(0,1fr)]">
        <div className="min-w-0">
          <h1 className="font-heading text-h1 font-bold leading-tight text-text-primary">
            Contact {OPERATOR.product}
          </h1>
          <p className="mt-3 max-w-2xl text-body leading-relaxed text-text-secondary">
            Enterprise support for AI, AR inspections, assets, safety workflows, permits, work
            orders, reports, 3D visualization, VR training, billing, and platform administration.
          </p>

          <div className="mt-10">
            <h2 className="font-heading text-h3 font-bold text-text-primary">Send us a message</h2>
            <div className="mt-6">
              <ContactForm />
            </div>
          </div>
        </div>

        <aside className="min-w-0">
          <h2 className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            Operator
          </h2>
          <OperatorTable />

          <div className="rounded-lg border border-border bg-elevated p-5">
            <p className="text-bodySmall font-semibold text-text-primary">Prefer email or phone?</p>
            <p className="mt-2 grid gap-1 text-bodySmall text-text-secondary">
              <a
                className="transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                href={`mailto:${OPERATOR.email}`}
              >
                {OPERATOR.email}
              </a>
              <a
                className="transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                href={OPERATOR.phoneHref}
              >
                {OPERATOR.phone}
              </a>
            </p>
          </div>

          <h2 className="mt-10 font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            Policies
          </h2>
          <ul className="mt-4 grid gap-2 border-l border-border pl-4">
            {LEGAL_ROUTES.map((route) => (
              <li key={route.href}>
                <Link
                  className="text-bodySmall text-text-secondary transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                  href={route.href}
                >
                  {route.label}
                </Link>
              </li>
            ))}
          </ul>
        </aside>
      </div>
    </div>
  );
}
