"use client";

import { usePathname } from "next/navigation";
import { useEffect, useRef } from "react";

/**
 * Reading-progress bar pinned to the bottom edge of the marketing header.
 *
 * Deliberately not framer-motion: this is a single transform driven by scroll
 * position, and a rAF-throttled listener writing one CSS property avoids
 * mounting a spring for every visitor. Honors prefers-reduced-motion by
 * dropping the width transition, not the indicator — progress is information,
 * not decoration.
 */
export function ScrollProgress() {
  const barRef = useRef<HTMLDivElement>(null);
  const pathname = usePathname();

  useEffect(() => {
    const bar = barRef.current;
    if (!bar) return;

    let frame = 0;
    const write = () => {
      frame = 0;
      const scrollable = document.documentElement.scrollHeight - window.innerHeight;
      const ratio = scrollable > 0 ? window.scrollY / scrollable : 0;
      bar.style.transform = `scaleX(${Math.min(1, Math.max(0, ratio))})`;
    };
    const onScroll = () => {
      if (frame === 0) frame = window.requestAnimationFrame(write);
    };

    write();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      if (frame !== 0) window.cancelAnimationFrame(frame);
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
    };
  }, [pathname]);

  return (
    <div aria-hidden className="absolute inset-x-0 bottom-0 h-[2px] overflow-hidden">
      <div className="mk-progress h-full w-full scale-x-0" ref={barRef} />
    </div>
  );
}

/**
 * Reveals every `[data-reveal]` element on the page as it enters the viewport.
 *
 * One observer for the whole page rather than a wrapper component per section,
 * so the sections themselves stay server-rendered: the hidden state is CSS
 * gated behind the `js-anim` class that the pre-paint bootstrap sets, and this
 * only adds `is-visible`. Elements are unobserved once shown — a reveal that
 * re-hides on scroll-up reads as a glitch, not an effect.
 *
 * Re-scans on every pathname change. This component lives in the `(marketing)`
 * layout, and App Router keeps a layout mounted across navigations inside its
 * own group — so a mount-only effect would observe the landing page's elements
 * and never those of `/pricing` or `/about`, leaving them stuck at opacity 0.
 * A MutationObserver covers anything that mounts after that commit.
 */
export function RevealOnScroll() {
  const pathname = usePathname();

  useEffect(() => {
    const show = (element: Element) => element.classList.add("is-visible");
    // Scoped to <main> so unrelated insertions elsewhere in the app (toasts,
    // portals) do not trigger a rescan. Only childList is watched, so adding
    // `is-visible` cannot retrigger the observer.
    const scope: Node = document.querySelector("main") ?? document.body;

    // No IntersectionObserver (or reduced motion): show everything, always.
    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reduced || typeof IntersectionObserver === "undefined") {
      const revealAll = () => document.querySelectorAll("[data-reveal]").forEach(show);
      revealAll();
      const mutations = new MutationObserver(revealAll);
      mutations.observe(scope, { childList: true, subtree: true });
      return () => mutations.disconnect();
    }

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (!entry.isIntersecting) continue;
          show(entry.target);
          observer.unobserve(entry.target);
        }
      },
      { rootMargin: "0px 0px -12% 0px", threshold: 0.08 },
    );

    const track = (element: HTMLElement) => {
      if (element.classList.contains("is-visible")) return;
      // Anything already on screen reveals immediately, so the hero never
      // animates in behind the fold-line check — and, more importantly, a
      // navigation that lands mid-document never leaves content hidden.
      if (element.getBoundingClientRect().top < window.innerHeight) {
        show(element);
      } else {
        observer.observe(element);
      }
    };

    const scan = () => {
      document.querySelectorAll<HTMLElement>("[data-reveal]").forEach(track);
    };

    scan();
    // A second pass on the next frame catches elements whose layout (and so
    // whose viewport position) is only settled after paint.
    const frame = window.requestAnimationFrame(scan);
    const mutations = new MutationObserver(scan);
    mutations.observe(scope, { childList: true, subtree: true });

    return () => {
      window.cancelAnimationFrame(frame);
      mutations.disconnect();
      observer.disconnect();
    };
  }, [pathname]);

  return null;
}
