"use client";

/* eslint-disable @next/next/no-img-element */

import { useTheme } from "./theme-provider";

export type LogoVariant = "mark" | "wordmark" | "full";

const intrinsic: Record<LogoVariant, { width: number; height: number }> = {
  mark: { width: 1092, height: 379 },
  wordmark: { width: 1092, height: 497 },
  full: { width: 1092, height: 639 },
};

/**
 * Brand logo that auto-selects the light/dark asset from the active theme.
 * Call sites never reference file paths, so adding a theme variant later
 * only touches this component. Assets live in /public/brand (admin) and
 * assets/brand (mobile) — derived from the owner-supplied master lockup
 * (white background removed, dark variant = navy → light recolor).
 */
export function Logo({
  variant = "wordmark",
  height = 32,
  decorative = false,
  priority = false,
  className,
}: {
  variant?: LogoVariant;
  height?: number;
  decorative?: boolean;
  /** Set on above-the-fold brand placements (login hero) to help LCP. */
  priority?: boolean;
  className?: string;
}) {
  const { theme } = useTheme();
  const box = intrinsic[variant];
  const width = Math.round((box.width / box.height) * height);
  return (
    <img
      alt={decorative ? "" : "Flacron EnergyVerse"}
      aria-hidden={decorative || undefined}
      className={className}
      fetchPriority={priority ? "high" : undefined}
      height={height}
      loading={priority ? "eager" : undefined}
      src={`/brand/logo-${variant}-${theme}.png`}
      width={width}
    />
  );
}

/**
 * Ultra-premium orbital logo loader: places the brand logo at the center of dual
 * rotating gradient & dashed orbit rings with ambient backlight glowing aura.
 */
export function LogoLoader({
  height = 36,
  label = "Restoring session",
  variant = "mark",
}: {
  height?: number;
  label?: string;
  variant?: LogoVariant;
}) {
  // Ported from the Flutter `LogoLoader` (apps/mobile/lib/design_system/logo.dart)
  // so both clients show the identical loader. Three layers, matching its
  // widget tree exactly: a 120px accent aura, a 100px arc sweeping over a faint
  // full-circle track, and a 76px circular glass disc holding the mark.
  //
  // The earlier admin version had drifted: a rounded-*square* core, a second
  // dashed counter-rotating ring, a pulsing logo, and a gradient progress bar —
  // none of which exist on mobile.
  return (
    <div className="relative flex flex-col items-center justify-center gap-6" role="status">
      <div className="relative grid size-[120px] place-items-center">
        {/* Ambient aura. Mobile uses a blurred accent box-shadow; the blurred
            radial fill is the CSS equivalent. */}
        <div className="mk-loader-aura absolute size-[120px] rounded-full" />

        {/* Faint full-circle track, then the sweeping arc over it — the two
            halves of Flutter's CircularProgressIndicator. */}
        <div className="mk-loader-track absolute size-[100px] rounded-full border-[3px]" />
        <div className="mk-loader-arc absolute size-[100px] rounded-full border-[3px] border-transparent" />

        {/* Circular glass disc, not a rounded square. */}
        <div className="mk-loader-disc relative grid size-[76px] place-items-center rounded-full border">
          <Logo decorative height={height} priority variant={variant} />
        </div>
      </div>

      <span className="font-mono text-caption font-bold uppercase tracking-[0.18em] text-primary-600 dark:text-primary-400">
        {label}
      </span>
      <span className="sr-only">{label}</span>
    </div>
  );
}


/**
 * Page-level loading state, for a screen that has nothing to show yet.
 *
 * Uses the same orbital `LogoLoader` as the auth splash so a slow page reads
 * as the product working rather than as a bare spinner dropped into a layout.
 * Reserved for whole-screen waits — a single card or table that is still
 * loading should use `Spinner` or a skeleton so the rest of the page stays
 * usable.
 */
export function PageLoader({
  label = "Loading",
  /** Fills the app shell's content area rather than the whole viewport. */
  inShell = true,
}: {
  label?: string;
  inShell?: boolean;
}) {
  return (
    <div
      className={
        inShell
          ? "grid min-h-[60vh] place-items-center p-6"
          : "grid min-h-screen place-items-center bg-background p-6"
      }
      data-testid="page-loader"
    >
      <LogoLoader label={label} />
    </div>
  );
}
