import Link from "next/link";
import type { HTMLAttributes, ReactNode } from "react";

/**
 * Presentational building blocks for the public marketing pages.
 *
 * Deliberately server-safe: no hooks, no imports from the "use client"
 * design-system modules, so every marketing page stays a fully static server
 * component. That is the whole point of Phase 12 — these pages must render and
 * index without the Firebase auth context that gates the app shell. Styling
 * comes from the generated design tokens (D-016/D-017) plus the `mk-*` classes
 * in globals.css, never raw color values.
 *
 * Reveal-on-scroll is expressed as a `data-reveal` attribute here and driven by
 * the single observer in `RevealOnScroll`, so adding motion to a section never
 * costs it its server rendering.
 */

/** Pill geometry. The public site has few, large actions, so they read as
 * buttons at a glance rather than as the dense square controls the app shell
 * needs; a boxed secondary next to a boxed primary is what made the old
 * cluster look like a toolbar. */
const ctaBase =
  "mk-cta inline-flex min-h-11 items-center justify-center gap-2 rounded-full font-semibold tracking-[0.01em]";

const ctaVariants = {
  /** Brand orange — the primary action everywhere on the public site. Navy ink
   * rather than white: white on the vivid #FB4402 is about 3.4:1, which fails
   * AA at this text size, and the navy pairing is the one D-017 locked. */
  accent: "mk-cta-accent px-7 py-2.5 text-body text-accent-ink",
  /** Outlined pill, for a secondary action that still needs to look clickable. */
  ghost:
    "mk-cta-ghost border border-border mk-chip px-6 py-2.5 text-bodySmall text-text-secondary backdrop-blur",
  /** No box at all — a quiet text action beside a real button. This is what
   * "Log in" should be: available, not competing with the primary. */
  bare: "px-3 py-2 text-bodySmall text-text-secondary transition-colors hover:text-text-primary",
} as const;

export type CtaVariant = keyof typeof ctaVariants;

/** Button-shaped link. The design-system `Button` is a client `motion.button`;
 * navigation on a static page wants a real anchor for crawlers and middle-click. */
export function CtaLink({
  children,
  href,
  variant = "accent",
  className,
  arrow,
}: {
  children: ReactNode;
  href: string;
  variant?: CtaVariant;
  className?: string;
  /** Trailing arrow. On by default for the accent pill in body sections, where
   * it aids scanning; the header passes `false` to keep its cluster compact. */
  arrow?: boolean;
}) {
  const showArrow = arrow ?? variant === "accent";
  const content = (
    <>
      {children}
      {showArrow ? (
        <svg
          aria-hidden
          className="size-3.5 shrink-0"
          fill="none"
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="2.4"
          viewBox="0 0 24 24"
        >
          <path d="M5 12h13M12 5l7 7-7 7" />
        </svg>
      ) : null}
    </>
  );

  // mailto: and other external schemes must stay plain anchors.
  if (!href.startsWith("/")) {
    return (
      <a className={`${ctaBase} ${ctaVariants[variant]} ${className ?? ""}`} href={href}>
        {content}
      </a>
    );
  }
  return (
    <Link className={`${ctaBase} ${ctaVariants[variant]} ${className ?? ""}`} href={href}>
      {content}
    </Link>
  );
}

/** Small uppercase mono label above a heading — the instrumentation cue used
 * throughout the app shell, with a live accent dot. */
export function Eyebrow({ children }: { children: ReactNode }) {
  return (
    <p className="inline-flex w-fit items-center gap-2 rounded-full border border-border mk-chip px-3.5 py-1.5 font-mono text-caption uppercase tracking-[0.18em] text-text-secondary backdrop-blur">
      <span aria-hidden className="size-1.5 rounded-full bg-accent-500" />
      {children}
    </p>
  );
}

export function Section({
  children,
  className,
  id,
  tone = "background",
  reveal = true,
}: {
  children: ReactNode;
  className?: string;
  id?: string;
  tone?: "background" | "surface";
  reveal?: boolean;
}) {
  return (
    <section
      className={`relative px-5 py-20 md:px-8 md:py-28 ${
        tone === "surface" ? "border-y border-border mk-surface-soft" : ""
      }`}
      id={id}
    >
      <div
        className={`mx-auto w-full max-w-6xl ${className ?? ""}`}
        data-reveal={reveal ? "up" : undefined}
      >
        {children}
      </div>
    </section>
  );
}

export function SectionHeading({
  eyebrow,
  title,
  lede,
  align = "left",
  level = 2,
  /** Trailing words of the title rendered in the accent gradient. */
  highlight,
}: {
  eyebrow?: string;
  title: string;
  lede?: string;
  align?: "left" | "center";
  /** Pass 1 for the page's lead heading. Every indexable page needs exactly
   * one h1, and on Pricing/About this component renders it. */
  level?: 1 | 2;
  highlight?: string;
}) {
  const Heading = level === 1 ? "h1" : "h2";
  return (
    <div className={align === "center" ? "mx-auto max-w-3xl text-center" : "max-w-3xl"}>
      {eyebrow ? (
        <div className={align === "center" ? "flex justify-center" : ""}>
          <Eyebrow>{eyebrow}</Eyebrow>
        </div>
      ) : null}
      <Heading
        className={`mt-5 font-heading font-bold leading-[1.08] tracking-[-0.02em] text-text-primary ${
          level === 1 ? "text-display" : "text-h1"
        }`}
      >
        {title}
        {highlight ? <span className="mk-gradient-text"> {highlight}</span> : null}
      </Heading>
      {lede ? (
        <p className="mt-5 text-bodyLarge leading-relaxed text-text-secondary">{lede}</p>
      ) : null}
    </div>
  );
}

/** 1px-border panel on an elevated surface — no drop shadows (D-016). The
 * `mk-panel` class adds the hover lift and the accent hairline wipe. */
export function Panel({
  children,
  className,
  interactive = true,
  ...rest
}: HTMLAttributes<HTMLDivElement> & { interactive?: boolean }) {
  return (
    <div
      className={`overflow-hidden rounded-xl border border-border bg-surface p-6 ${
        interactive ? "mk-panel" : ""
      } ${className ?? ""}`}
      {...rest}
    >
      {children}
    </div>
  );
}

export function FeatureCard({
  title,
  body,
  meta,
  /** Two-digit module index in mono — the instrumentation cue. */
  index,
}: {
  title: string;
  body: string;
  meta?: string;
  index?: number;
}) {
  return (
    <Panel className="flex h-full flex-col">
      {index !== undefined ? (
        <p className="font-mono text-caption text-accent-500">
          {String(index).padStart(2, "0")}
        </p>
      ) : null}
      <h3 className="mt-3 font-heading text-h4 font-semibold text-text-primary">{title}</h3>
      <p className="mt-2.5 flex-1 text-body leading-relaxed text-text-secondary">{body}</p>
      {meta ? (
        <p className="mt-5 border-t border-border pt-3.5 font-mono text-caption text-text-muted">
          {meta}
        </p>
      ) : null}
    </Panel>
  );
}

export function CheckItem({ children }: { children: ReactNode }) {
  return (
    <li className="flex gap-3 text-body leading-relaxed text-text-secondary">
      <span
        aria-hidden
        className="mt-0.5 grid size-5 shrink-0 place-items-center rounded-full mk-accent-soft text-accent-600 dark:text-accent-400"
      >
        <svg
          className="size-3"
          fill="none"
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="3"
          viewBox="0 0 24 24"
        >
          <path d="M20 6 9 17l-5-5" />
        </svg>
      </span>
      <span>{children}</span>
    </li>
  );
}

/** Decorative ambient background — radial brand washes over a fine grid.
 * Absolute and pointer-transparent; the parent must be `relative`. */
export function Ambient() {
  return <div aria-hidden className="mk-ambient" />;
}

export function CtaBand({
  title,
  body,
  primaryHref,
  primaryLabel,
  secondaryHref,
  secondaryLabel,
}: {
  title: string;
  body: string;
  primaryHref: string;
  primaryLabel: string;
  secondaryHref: string;
  secondaryLabel: string;
}) {
  return (
    <Section>
      <div className="relative overflow-hidden rounded-2xl border border-border bg-surface px-6 py-16 text-center md:px-12">
        <Ambient />
        <div className="relative">
          <h2 className="mx-auto max-w-2xl font-heading text-h1 font-bold leading-[1.1] tracking-[-0.02em] text-text-primary">
            {title}
          </h2>
          <p className="mx-auto mt-5 max-w-xl text-bodyLarge leading-relaxed text-text-secondary">
            {body}
          </p>
          <div className="mt-9 flex flex-wrap justify-center gap-3">
            <CtaLink href={primaryHref}>{primaryLabel}</CtaLink>
            <CtaLink href={secondaryHref} variant="ghost">
              {secondaryLabel}
            </CtaLink>
          </div>
        </div>
      </div>
    </Section>
  );
}
