/**
 * The record chain: one real sequence of events on one asset, from the
 * inspection that found the problem to the report that closes it out.
 *
 * This replaces the three-column "your tools are scattered" card set that every
 * B2B site has. It is specific to what this platform actually does — each step
 * names the module, the permission that gates it, and a plausible record id
 * from the demo tenant — so a reader in the industry can check it against how
 * their own site runs.
 *
 * Server-safe. The connector draws itself when the parent `[data-reveal]`
 * container becomes visible (`.mk-chain-line`, CSS only).
 */

export type ChainStep = {
  id: string;
  module: string;
  title: string;
  body: string;
  actor: string;
  gate: string;
};

export const chainSteps: readonly ChainStep[] = [
  {
    id: "INS-2291",
    module: "Inspections",
    title: "Seat leak fails on PSV-114",
    body: "A monthly PSV round is completed offline at Tank Farm A. The failed step captures two photos, an 11.9 bar reading, and the inspector's signature.",
    actor: "Field Inspector",
    gate: "inspections.write",
  },
  {
    id: "WO-1042",
    module: "Work orders",
    title: "The finding becomes assigned work",
    body: "Operations raises a work order against the same asset and assigns it. The technician accepts, progresses it, and submits it for review — but cannot close it.",
    actor: "Operations Manager",
    gate: "work_orders.write",
  },
  {
    id: "PTW-118",
    module: "Permits",
    title: "Hot work is authorised in writing",
    body: "The valve replacement needs isolation and hot work, so a permit is raised from a template and approved before anyone lifts a spanner.",
    actor: "HSE Manager",
    gate: "permits.approve",
  },
  {
    id: "WO-1042",
    module: "Work orders",
    title: "Someone other than the doer signs it off",
    body: "Closure is a separate permission from doing the work. The person who turned the bolts is not the person who accepts the job as finished.",
    actor: "Operations Manager",
    gate: "work_orders.close",
  },
  {
    id: "RPT-0043",
    module: "Reports",
    title: "The whole chain exports as one artifact",
    body: "A report is generated from the actual records — not retyped — reviewed by a human, attested, and frozen as a PDF, Word, or Excel file.",
    actor: "HSE Manager",
    gate: "reports.generate",
  },
];

export function RecordChain() {
  return (
    <ol className="relative grid gap-4 lg:grid-cols-5 lg:gap-3">
      {/* Horizontal rail on wide screens; the cards carry their own order
          on narrow ones, where a rail would just be noise. */}
      <div
        aria-hidden
        className="mk-chain-line absolute inset-x-0 top-[38px] hidden h-px bg-gradient-to-r from-accent-500 via-primary-400 to-transparent lg:block"
      />
      {chainSteps.map((step, index) => (
        <li className="relative flex flex-col" key={`${step.id}-${index}`}>
          <div className="flex items-center gap-3 lg:flex-col lg:items-start">
            <span className="grid size-9 shrink-0 place-items-center rounded-full border border-border bg-surface font-mono text-caption font-semibold text-accent-500">
              {index + 1}
            </span>
            <p className="font-mono text-micro uppercase tracking-[0.16em] text-text-muted lg:mt-4">
              {step.module}
            </p>
          </div>
          <div className="mt-3 flex-1 rounded-xl border border-border bg-surface p-5">
            <p className="font-mono text-micro text-text-muted">{step.id}</p>
            <h3 className="mt-2 font-heading text-h5 font-semibold leading-snug text-text-primary">
              {step.title}
            </h3>
            <p className="mt-2.5 text-bodySmall leading-relaxed text-text-secondary">{step.body}</p>
            <dl className="mt-4 grid gap-1.5 border-t border-border pt-3.5">
              <div className="flex items-baseline gap-2">
                <dt className="font-mono text-micro uppercase tracking-wider text-text-muted">
                  who
                </dt>
                <dd className="text-caption text-text-secondary">{step.actor}</dd>
              </div>
              <div className="flex items-baseline gap-2">
                <dt className="font-mono text-micro uppercase tracking-wider text-text-muted">
                  gate
                </dt>
                <dd className="font-mono text-micro text-accent-600 dark:text-accent-400">
                  {step.gate}
                </dd>
              </div>
            </dl>
          </div>
        </li>
      ))}
    </ol>
  );
}
