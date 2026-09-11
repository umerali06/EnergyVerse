import type { ReactNode } from "react";

/**
 * The hero's product depiction: a field device part-way through an inspection
 * with no connection, the outbox draining, and the supervisor panel receiving
 * the same record. It states the platform's core claim in one picture rather
 * than in another bulleted card.
 *
 * A stylised rendering of the real interface, not a screenshot — and labelled
 * as such in the markup's accessible description. Every value shown matches the
 * demo tenant the seed creates (North Refinery, Tank Farm A, PSV checks), so
 * nothing here implies a customer or a number the product cannot produce.
 *
 * Server-safe: all motion is CSS keyframes from globals.css, so the hero keeps
 * its static rendering. `role="img"` with an `aria-label` means assistive tech
 * gets one honest description instead of walking a decorative widget tree.
 */

function StatusDot({ tone }: { tone: "success" | "warning" | "muted" }) {
  const color =
    tone === "success"
      ? "bg-status-success"
      : tone === "warning"
        ? "bg-status-warning"
        : "bg-text-muted";
  return <span aria-hidden className={`size-1.5 shrink-0 rounded-full ${color}`} />;
}

function ChecklistRow({
  label,
  state,
}: {
  label: string;
  state: "pass" | "fail" | "todo";
}) {
  return (
    <div className="flex items-center gap-2.5 border-t border-border px-3.5 py-2 first:border-t-0">
      {state === "todo" ? (
        <span aria-hidden className="size-3.5 shrink-0 rounded-[3px] border border-border" />
      ) : (
        <span
          aria-hidden
          className={`grid size-3.5 shrink-0 place-items-center rounded-[3px] ${
            state === "pass" ? "bg-status-success" : "bg-status-critical"
          } text-white`}
        >
          <svg
            className="size-2.5"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="3.5"
            viewBox="0 0 24 24"
          >
            {state === "pass" ? <path d="M20 6 9 17l-5-5" /> : <path d="M18 6 6 18M6 6l12 12" />}
          </svg>
        </span>
      )}
      <span
        className={`flex-1 truncate text-caption ${
          state === "todo" ? "text-text-muted" : "text-text-primary"
        }`}
      >
        {label}
      </span>
      {state === "fail" ? (
        <span className="font-mono text-micro uppercase tracking-wider text-status-critical">
          finding
        </span>
      ) : null}
    </div>
  );
}

function Frame({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <div
      className={`overflow-hidden rounded-xl border border-border bg-surface ${className ?? ""}`}
    >
      {children}
    </div>
  );
}

export function HeroShowcase() {
  return (
    <div
      aria-label="Illustration of the product: a field device completing a pressure-relief-valve inspection at Tank Farm A with no connection, its three queued changes syncing, and the supervisor panel receiving the resulting work order for review."
      className="relative w-full select-none"
      role="img"
    >
      {/* The wire the synced record travels along. Sits behind both frames. */}
      <svg
        aria-hidden
        className="absolute inset-0 size-full"
        fill="none"
        preserveAspectRatio="none"
        viewBox="0 0 400 380"
      >
        <path
          className="mk-wire"
          d="M120 250 C 120 170, 250 190, 268 120"
          stroke="var(--color-border)"
          strokeLinecap="round"
          strokeWidth="1.5"
        />
        <circle className="mk-packet" fill="var(--color-accent-500)" r="3.5">
          <animateMotion
            dur="9s"
            keyPoints="0;0;1;1"
            keyTimes="0;0.33;0.66;1"
            path="M120 250 C 120 170, 250 190, 268 120"
            repeatCount="indefinite"
          />
        </circle>
      </svg>

      {/* ---------------------------------------- supervisor panel (received) */}
      <Frame className="mk-received relative ml-auto w-[86%] max-w-[340px]">
        <div className="flex items-center gap-2 border-b border-border px-3.5 py-2.5">
          <StatusDot tone="warning" />
          <p className="flex-1 truncate text-caption font-semibold text-text-primary">
            Work order review
          </p>
          <p className="font-mono text-micro text-text-muted">WO-1042</p>
        </div>
        <div className="px-3.5 py-3">
          <p className="text-caption text-text-secondary">
            PSV-114 seat leak · <span className="font-mono">Tank Farm A</span>
          </p>
          <div className="mt-3 flex flex-wrap items-center gap-1.5">
            {["open", "assigned", "in progress"].map((step) => (
              <span
                className="rounded-full border border-border px-2 py-0.5 font-mono text-micro text-text-muted"
                key={step}
              >
                {step}
              </span>
            ))}
            <span className="rounded-full bg-status-warning px-2 py-0.5 font-mono text-micro font-semibold text-accent-ink">
              pending review
            </span>
          </div>
          <p className="mt-3 flex items-center gap-1.5 font-mono text-micro text-text-muted">
            <StatusDot tone="muted" />
            close requires work_orders.close
          </p>
        </div>
      </Frame>

      {/* --------------------------------------------- field device (offline) */}
      <div className="mk-device relative -mt-10 w-[74%] max-w-[286px]">
        <Frame>
          <div className="flex items-center gap-2 border-b border-border px-3.5 py-2.5">
            {/* Three stacked states, one visible at a time. */}
            <div className="mk-conn relative grid flex-1 items-center">
              <p className="col-start-1 row-start-1 flex items-center gap-2 text-caption font-semibold text-text-primary">
                <span aria-hidden className="size-1.5 shrink-0 rounded-full bg-text-muted" />
                No connection
              </p>
              <p className="col-start-1 row-start-1 flex items-center gap-2 text-caption font-semibold text-text-primary">
                <span aria-hidden className="size-1.5 shrink-0 rounded-full bg-accent-500" />
                Syncing 3 changes
              </p>
              <p className="col-start-1 row-start-1 flex items-center gap-2 text-caption font-semibold text-text-primary">
                <StatusDot tone="success" />
                All changes synced
              </p>
            </div>
            <p className="font-mono text-micro text-text-muted">INS-2291</p>
          </div>

          <div className="border-b border-border px-3.5 py-2.5">
            <p className="font-mono text-micro uppercase tracking-[0.16em] text-text-muted">
              North Refinery · Tank Farm A
            </p>
            <p className="mt-1 text-bodySmall font-semibold text-text-primary">
              Monthly PSV inspection
            </p>
          </div>

          <div>
            <ChecklistRow label="Body & bonnet condition" state="pass" />
            <ChecklistRow label="Set pressure verified" state="pass" />
            <ChecklistRow label="Seat leak test" state="fail" />
            <ChecklistRow label="Nameplate legible" state="todo" />
          </div>

          {/* Outbox: the queue that drains once coverage returns. */}
          <div className="border-t border-border bg-elevated px-3.5 py-2.5">
            <p className="font-mono text-micro uppercase tracking-[0.16em] text-text-muted">
              Outbox
            </p>
            <div className="mt-2 grid gap-1.5">
              {[
                { label: "2 photos · 1.4 MB", id: "media" },
                { label: "PSV-114 reading 11.9 bar", id: "reading" },
                { label: "Finding → work order", id: "finding" },
              ].map((item) => (
                <p
                  className="mk-queue-row flex items-center gap-2 font-mono text-micro"
                  key={item.id}
                >
                  <span aria-hidden className="mk-queue-dot size-1.5 shrink-0 rounded-full" />
                  {item.label}
                </p>
              ))}
            </div>
          </div>
        </Frame>
      </div>
    </div>
  );
}
