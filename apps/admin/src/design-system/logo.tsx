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
  className,
}: {
  variant?: LogoVariant;
  height?: number;
  decorative?: boolean;
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
      height={height}
      src={`/brand/logo-${variant}-${theme}.png`}
      width={width}
    />
  );
}
