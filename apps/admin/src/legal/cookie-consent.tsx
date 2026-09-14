"use client";

import { useCallback, useEffect, useState } from "react";

import { Button } from "@/design-system";

import { LEGAL_VERSION } from "./legal-content";

/**
 * Cookie banner and preference centre.
 *
 * Three rules from the package drive the shape of this. Rejection is never
 * hidden or made harder than acceptance — "Reject Non-Essential" sits beside
 * "Accept All" with the same prominence, not behind "Manage Preferences".
 * Strictly necessary technologies are shown as always-active rather than as a
 * toggle that pretends to be a choice. And the decision is always reopenable,
 * through the footer control, which is why the open state is driven by a window
 * event rather than by local state alone.
 *
 * The stored record carries the legal version, so republishing a materially
 * changed policy re-asks rather than silently inheriting an older consent.
 */

const STORAGE_KEY = "fev.cookie-consent";
export const COOKIE_PREFERENCES_EVENT = "fev:open-cookie-preferences";

export type ConsentCategories = {
  /** Always true. Present in the record so an export shows the full picture. */
  necessary: true;
  preferences: boolean;
  analytics: boolean;
  marketing: boolean;
};

type ConsentRecord = ConsentCategories & { version: string; decidedAt: string };

const ALL_ON: ConsentCategories = {
  necessary: true,
  preferences: true,
  analytics: true,
  marketing: true,
};
const ESSENTIAL_ONLY: ConsentCategories = {
  necessary: true,
  preferences: false,
  analytics: false,
  marketing: false,
};

function readConsent(): ConsentRecord | null {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as ConsentRecord;
    // A record written against an older policy version is not a decision about
    // the current one.
    if (parsed.version !== LEGAL_VERSION) return null;
    return parsed;
  } catch {
    return null;
  }
}

function writeConsent(categories: ConsentCategories): void {
  try {
    const record: ConsentRecord = {
      ...categories,
      version: LEGAL_VERSION,
      decidedAt: new Date().toISOString(),
    };
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(record));
  } catch {
    // Storage disabled. The banner reappears next visit, which is the correct
    // failure: no consent is recorded, so nothing optional may run.
  }
}

/** What the rest of the app should consult before loading an optional script. */
export function hasConsent(category: keyof ConsentCategories): boolean {
  if (typeof window === "undefined") return false;
  if (category === "necessary") return true;
  return readConsent()?.[category] === true;
}

function Toggle({
  label,
  description,
  checked,
  onChange,
  locked = false,
}: {
  label: string;
  description: string;
  checked: boolean;
  onChange?: (next: boolean) => void;
  locked?: boolean;
}) {
  return (
    <div className="flex items-start justify-between gap-4 border-b border-border py-4 last:border-b-0">
      <div className="min-w-0">
        <p className="text-bodySmall font-semibold text-text-primary">{label}</p>
        <p className="mt-1 text-caption leading-relaxed text-text-secondary">{description}</p>
      </div>
      {locked ? (
        <span className="shrink-0 rounded-full border border-border px-3 py-1 font-mono text-micro uppercase tracking-wider text-text-muted">
          Always active
        </span>
      ) : (
        <label className="flex shrink-0 cursor-pointer items-center gap-2">
          <input
            aria-label={label}
            checked={checked}
            className="size-4 accent-accent-500"
            onChange={(event) => onChange?.(event.target.checked)}
            type="checkbox"
          />
          <span className="text-caption font-semibold text-text-secondary">
            {checked ? "On" : "Off"}
          </span>
        </label>
      )}
    </div>
  );
}

export function CookieConsent() {
  const [decided, setDecided] = useState(true);
  const [managing, setManaging] = useState(false);
  const [draft, setDraft] = useState<ConsentCategories>(ESSENTIAL_ONLY);

  useEffect(() => {
    const stored = readConsent();
    setDecided(stored !== null);
    if (stored) setDraft({ ...stored, necessary: true });
  }, []);

  useEffect(() => {
    const open = () => {
      setDraft(readConsent() ?? ESSENTIAL_ONLY);
      setManaging(true);
    };
    window.addEventListener(COOKIE_PREFERENCES_EVENT, open);
    return () => window.removeEventListener(COOKIE_PREFERENCES_EVENT, open);
  }, []);

  const decide = useCallback((categories: ConsentCategories) => {
    writeConsent(categories);
    setDecided(true);
    setManaging(false);
  }, []);

  if (decided && !managing) return null;

  if (managing) {
    return (
      <div
        aria-labelledby="cookie-preferences-title"
        aria-modal="true"
        className="fixed inset-0 z-modal grid place-items-end overflow-y-auto bg-black/50 p-4 backdrop-blur-sm sm:place-items-center"
        role="dialog"
      >
        <div className="w-full max-w-lg rounded-xl border border-border bg-surface p-6 shadow-xl">
          <h2
            className="font-heading text-h3 font-bold text-text-primary"
            id="cookie-preferences-title"
          >
            Cookie preferences
          </h2>
          <p className="mt-2 text-bodySmall leading-relaxed text-text-secondary">
            Choose which optional technologies Flacron Energy may use. You can change this at any
            time from the Cookie Preferences link in the footer.
          </p>

          <div className="mt-5">
            <Toggle
              checked
              description="Authentication, authorization, security, session management, billing, fraud prevention, load balancing, and storing your consent choice."
              label="Strictly necessary"
              locked
            />
            <Toggle
              checked={draft.preferences}
              description="Remembering your organization, language, theme, and interface preferences."
              label="Preferences"
              onChange={(next) => setDraft((current) => ({ ...current, preferences: next }))}
            />
            <Toggle
              checked={draft.analytics}
              description="Performance and error monitoring, and understanding which features are used."
              label="Analytics"
              onChange={(next) => setDraft((current) => ({ ...current, analytics: next }))}
            />
            <Toggle
              checked={draft.marketing}
              description="Marketing attribution, where permitted."
              label="Marketing"
              onChange={(next) => setDraft((current) => ({ ...current, marketing: next }))}
            />
          </div>

          <div className="mt-6 flex flex-wrap gap-3">
            <Button onClick={() => decide({ ...draft, necessary: true })}>Save preferences</Button>
            <Button onClick={() => decide(ALL_ON)} variant="ghost">
              Accept all
            </Button>
            <Button onClick={() => decide(ESSENTIAL_ONLY)} variant="ghost">
              Reject non-essential
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div
      aria-label="Your privacy choices"
      className="fixed inset-x-0 bottom-0 z-toast border-t border-border bg-surface/95 p-4 backdrop-blur md:p-5"
      role="region"
    >
      <div className="mx-auto flex w-full max-w-6xl flex-col gap-4 lg:flex-row lg:items-center">
        <div className="min-w-0 flex-1">
          <p className="text-bodySmall font-semibold text-text-primary">Your privacy choices</p>
          <p className="mt-1 text-caption leading-relaxed text-text-secondary">
            Flacron Energy uses necessary technologies to securely operate the service. With your
            permission, we may also use optional preference, analytics, and marketing technologies
            to improve the experience and understand how Flacron Energy is used.
          </p>
        </div>
        <div className="flex shrink-0 flex-wrap gap-2">
          <Button onClick={() => decide(ALL_ON)}>Accept all</Button>
          <Button onClick={() => decide(ESSENTIAL_ONLY)} variant="ghost">
            Reject non-essential
          </Button>
          <Button
            onClick={() => {
              setDraft(ESSENTIAL_ONLY);
              setManaging(true);
            }}
            variant="ghost"
          >
            Manage preferences
          </Button>
        </div>
      </div>
    </div>
  );
}

/** Footer control that reopens the consent manager after a decision. */
export function CookiePreferencesButton({ className }: { className?: string }) {
  return (
    <button
      className={
        className ??
        "text-bodySmall text-text-secondary transition-colors hover:text-accent-600 dark:hover:text-accent-400"
      }
      onClick={() => window.dispatchEvent(new Event(COOKIE_PREFERENCES_EVENT))}
      type="button"
    >
      Cookie Preferences
    </button>
  );
}
