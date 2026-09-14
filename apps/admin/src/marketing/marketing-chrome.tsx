"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { useAuth } from "@/auth/auth-context";
import { Logo, ThemeToggleIcon } from "@/design-system";
import { APP_HOME } from "@/navigation/routes";

import { ScrollProgress } from "./marketing-motion";
import { CtaLink } from "./marketing-ui";

const navLinks = [
  { href: "/", label: "Product" },
  { href: "/pricing", label: "Pricing" },
  { href: "/about", label: "About" },
] as const;


/**
 * Public site header. Auth-aware but never a gate: the marketing pages stay
 * readable signed in or out, and only the call to action changes. While the
 * Firebase session is still restoring we render neither CTA, so a returning
 * user never sees "Log in" flash before "Go to dashboard".
 */
export function MarketingHeader() {
  const auth = useAuth();
  const pathname = usePathname();
  const signedIn = auth.status === "authenticated";
  const settled = auth.status !== "restoring" && auth.status !== "checkingVerification";

  return (
    <header className="sticky top-0 z-20 border-b border-border mk-glass backdrop-blur-xl">
      <div className="mx-auto grid w-full max-w-6xl grid-cols-[auto_1fr_auto] items-center gap-4 px-5 py-3 md:px-8">
        <Link aria-label="Flacron Energy home" className="shrink-0" href="/">
          <Logo height={26} priority variant="wordmark" />
        </Link>

        <nav aria-label="Site" className="hidden items-center justify-center gap-1 md:flex">
          {navLinks.map((link) => {
            const active = pathname === link.href;
            return (
              <Link
                aria-current={active ? "page" : undefined}
                className={`relative rounded-md px-3 py-1.5 text-bodySmall font-medium transition-colors after:absolute after:inset-x-3 after:-bottom-0.5 after:h-0.5 after:rounded-full after:bg-accent-500 after:transition-transform after:duration-200 after:content-[''] ${
                  active
                    ? "text-text-primary after:scale-x-100"
                    : "text-text-secondary after:scale-x-0 hover:text-text-primary hover:after:scale-x-100"
                }`}
                href={link.href}
                key={link.href}
              >
                {link.label}
              </Link>
            );
          })}
        </nav>

        <div className="flex items-center justify-end gap-1.5">
          <ThemeToggleIcon />
          {settled ? (
            signedIn ? (
              <CtaLink arrow={false} href={APP_HOME}>
                Go to dashboard
              </CtaLink>
            ) : (
              <>
                <CtaLink className="hidden sm:inline-flex" href="/login" variant="bare">
                  Log in
                </CtaLink>
                <CtaLink arrow={false} href="/signup">
                  Start free trial
                </CtaLink>
              </>
            )
          ) : null}
        </div>
      </div>

      {/* Small screens: the same destinations as a scrollable strip, so the
          header never needs a drawer of its own. */}
      <nav
        aria-label="Site (compact)"
        className="flex gap-1 overflow-x-auto border-t border-border px-5 py-2 md:hidden"
      >
        {navLinks.map((link) => (
          <Link
            aria-current={pathname === link.href ? "page" : undefined}
            className={`shrink-0 rounded-md px-3 py-1 text-bodySmall font-medium ${
              pathname === link.href
                ? "bg-elevated text-text-primary"
                : "text-text-secondary hover:text-text-primary"
            }`}
            href={link.href}
            key={link.href}
          >
            {link.label}
          </Link>
        ))}
        <Link
          className="ml-auto shrink-0 rounded-md px-3 py-1 text-bodySmall font-medium text-text-secondary hover:text-text-primary"
          href={signedIn ? APP_HOME : "/login"}
        >
          {signedIn ? "Dashboard" : "Log in"}
        </Link>
      </nav>

      {/* Reading progress for the page below, on the header's bottom edge. */}
      <ScrollProgress />
    </header>
  );
}

const footerColumns = [
  {
    heading: "Product",
    links: [
      { href: "/", label: "Overview" },
      { href: "/pricing", label: "Pricing" },
      { href: "/about", label: "About" },
    ],
  },
  {
    heading: "Get started",
    links: [
      { href: "/signup", label: "Create an organization" },
      { href: "/login", label: "Sign in" },
      { href: "/forgot-password", label: "Reset password" },
    ],
  },
] as const;

export function MarketingFooter() {
  return (
    <footer className="relative border-t border-border mk-surface-soft px-5 py-16 md:px-8">
      <div className="mx-auto grid w-full max-w-6xl gap-10 md:grid-cols-[1.4fr_1fr_1fr]">
        <div>
          <Logo height={24} variant="wordmark" />
          <p className="mt-4 max-w-xs text-bodySmall text-text-secondary">
            Field operations intelligence for energy companies — assets, inspections, work orders,
            permits, and safety in one auditable system.
          </p>
        </div>
        {footerColumns.map((column) => (
          <div key={column.heading}>
            <h2 className="font-mono text-caption uppercase tracking-[0.18em] text-text-muted">
              {column.heading}
            </h2>
            <ul className="mt-4 grid gap-2.5">
              {column.links.map((link) => (
                <li key={link.href}>
                  <Link
                    className="text-bodySmall text-text-secondary transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                    href={link.href}
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="mx-auto mt-12 flex w-full max-w-6xl flex-wrap items-center gap-x-4 gap-y-2 border-t border-border pt-6 text-caption text-text-muted">
        <p>© {new Date().getFullYear()} Flacron Enterprises. All rights reserved.</p>
        <p className="ml-auto flex items-center gap-2 font-mono">
          <span aria-hidden className="size-1.5 rounded-full bg-accent-500" />
          Flacron Energy
        </p>
      </div>
    </footer>
  );
}
