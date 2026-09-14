"use client";

import { SIGNUP_STEPS, type SignupStepId, signupStepNumber } from "./signup-journey";

/**
 * The progress indicator shown on every signup screen.
 *
 * Present on all four of them deliberately. Signup leaves the app entirely for
 * Stripe and comes back, and the two screens either side of that jump are the
 * ones where people abandon: seeing "2 of 3 — verify email" and then "3 of 3 —
 * choose a plan" tells someone how much is left and, on return, that the trip
 * to Stripe was the last of it.
 *
 * Rendered as an ordered list rather than a row of divs so the sequence and the
 * current position are conveyed to a screen reader without relying on colour —
 * `aria-current="step"` marks where the person is, and completed steps say so
 * in text rather than only with a tick.
 */
export function SignupSteps({ current }: { current: SignupStepId }) {
  const activeNumber = signupStepNumber(current);

  return (
    <nav aria-label="Signup progress" className="w-full">
      <ol className="flex flex-col gap-3 sm:flex-row sm:items-start sm:gap-0">
        {SIGNUP_STEPS.map((step, index) => {
          const number = index + 1;
          const state =
            number < activeNumber ? "complete" : number === activeNumber ? "current" : "upcoming";
          return (
            <li
              aria-current={state === "current" ? "step" : undefined}
              className="flex flex-1 items-center gap-3 sm:flex-col sm:items-start sm:gap-0"
              key={step.id}
              data-step-state={state}
            >
              <span className="flex w-full items-center gap-3 sm:gap-2">
                <span
                  aria-hidden
                  className={`grid size-7 shrink-0 place-items-center rounded-full border font-mono text-micro font-semibold transition-colors ${
                    state === "complete"
                      ? "border-accent-500 bg-accent-500 text-accent-ink"
                      : state === "current"
                        ? "border-accent-500 text-accent-600 dark:text-accent-400"
                        : "border-border text-text-muted"
                  }`}
                >
                  {state === "complete" ? (
                    <svg
                      className="size-3.5"
                      fill="none"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2.5"
                      viewBox="0 0 24 24"
                    >
                      <path d="m5 13 4 4L19 7" />
                    </svg>
                  ) : (
                    number
                  )}
                </span>
                {/* The connector is decorative and only makes sense on the
                    horizontal layout; stacked on a phone it would be a stray
                    line between rows. */}
                {index < SIGNUP_STEPS.length - 1 ? (
                  <span
                    aria-hidden
                    className={`hidden h-px flex-1 sm:block ${
                      number < activeNumber ? "bg-accent-500" : "bg-border"
                    }`}
                  />
                ) : null}
              </span>
              <span className="sm:mt-2 sm:pr-6">
                <span
                  className={`block text-bodySmall font-semibold ${
                    state === "upcoming" ? "text-text-muted" : "text-text-primary"
                  }`}
                >
                  {step.label}
                </span>
                {/* Read out for assistive tech, which otherwise gets colour and
                    a tick glyph and nothing else. */}
                <span className="sr-only">
                  {state === "complete"
                    ? "Completed"
                    : state === "current"
                      ? `Current step, step ${number} of ${SIGNUP_STEPS.length}`
                      : "Not started"}
                </span>
                <span className="mt-0.5 hidden text-caption text-text-muted sm:block">
                  {step.description}
                </span>
              </span>
            </li>
          );
        })}
      </ol>
    </nav>
  );
}
