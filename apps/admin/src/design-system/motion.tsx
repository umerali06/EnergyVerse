"use client";

import { motion, useReducedMotion, type Variants } from "framer-motion";
import type { ReactNode } from "react";

import { designTokens } from "./tokens.generated";

const seconds = (milliseconds: number) => milliseconds / 1000;
const easing = designTokens.motion.easing.standard;

export const motionSpec = {
  fast: seconds(designTokens.motion.duration.fast),
  normal: seconds(designTokens.motion.duration.normal),
  slow: seconds(designTokens.motion.duration.slow),
  stagger: seconds(designTokens.motion.staggerMs),
  easing,
} as const;

export const listStagger: Variants = {
  hidden: {},
  visible: {
    transition: { staggerChildren: motionSpec.stagger },
  },
};

export const listItem: Variants = {
  hidden: { opacity: 0, y: 12 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: motionSpec.normal, ease: easing },
  },
};

/** Shared reduced-motion read for any component outside MotionSection that
 * needs to gate its own animation (e.g. chart entry animation). */
export function useReducedMotionPreference(override?: boolean): boolean {
  const systemReduced = useReducedMotion();
  return override ?? Boolean(systemReduced);
}

export function MotionSection({
  children,
  className,
  reducedMotionOverride,
}: {
  children: ReactNode;
  className?: string;
  reducedMotionOverride?: boolean;
}) {
  const systemReduced = useReducedMotion();
  const reduced = reducedMotionOverride ?? systemReduced;
  return (
    <motion.section
      animate={{ opacity: 1, y: 0 }}
      className={className}
      data-motion={reduced ? "reduced" : "full"}
      initial={reduced ? false : { opacity: 0, y: 16 }}
      transition={reduced ? { duration: 0 } : { duration: motionSpec.slow, ease: easing }}
    >
      {children}
    </motion.section>
  );
}
