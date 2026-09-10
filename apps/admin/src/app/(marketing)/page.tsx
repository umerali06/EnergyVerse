import type { Metadata } from "next";

import { HeroShowcase } from "@/marketing/hero-showcase";
import {
  Ambient,
  CheckItem,
  CtaBand,
  CtaLink,
  Eyebrow,
  Panel,
  Section,
  SectionHeading,
} from "@/marketing/marketing-ui";
import { RecordChain } from "@/marketing/record-chain";
import { RoleMatrix } from "@/marketing/role-matrix";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Field operations intelligence for energy companies",
  "Flacron EnergyVerse keeps one auditable record per asset: inspections run offline, findings become work orders, permits are approved in writing, and reports export from the real data.",
  "/",
);

/** Bento tiles. The two wide ones carry their own small depiction, so the grid
 * reads as a system rather than six identical feature boxes. */
const tiles = [
  {
    id: "assets",
    span: "lg:col-span-2",
    module: "Assets · Facilities · Digital twin",
    title: "The asset is the spine of everything",
    body: "Facilities, areas, and equipment in one hierarchy. Scan the QR label on a pump and you get its inspection history, open work orders, live permits, and drawings — before you touch it.",
    footer: ["North Refinery", "Compressor Station 2", "Tank Farm A", "Process Unit 1"],
  },
  {
    id: "inspections",
    span: "",
    module: "Inspections",
    title: "Checklists that survive the field",
    body: "Build a template once, then run it with photos, meter readings, on-photo annotations, AR measurements, and a captured signature.",
    footer: null,
  },
  {
    id: "permits",
    span: "",
    module: "Permits to work",
    title: "Isolation and hot work in writing",
    body: "Template-driven permits with a real approval step, so authorisation is a record instead of a conversation nobody can produce later.",
    footer: null,
  },
  {
    id: "safety",
    span: "",
    module: "Safety",
    title: "Near-misses that get logged",
    body: "Raise an incident or observation from the phone in your hand, then triage and close it with the accountability trail intact.",
    footer: null,
  },
  {
    id: "documents",
    span: "lg:col-span-2",
    module: "Documents · Reports",
    title: "The paperwork an audit actually asks for",
    body: "SOPs, technical manuals, safety policies, drawings, and compliance certificates in one controlled library — and reports generated from real records, attested by a human, then frozen as PDF, Word, or Excel.",
    footer: ["SOP", "Manual", "Policy", "Drawing", "Certificate"],
  },
] as const;

export default function LandingPage() {
  return (
    <>
      {/* ---------------------------------------------------------------- hero */}
      <section className="relative overflow-hidden px-5 pb-24 pt-14 md:px-8 md:pb-32 md:pt-20">
        <Ambient />
        <div className="relative mx-auto grid w-full max-w-6xl items-center gap-16 lg:grid-cols-[1.05fr_0.95fr]">
          <div data-reveal="up">
            <Eyebrow>Energy field operations</Eyebrow>
            <h1 className="mt-6 font-heading text-display font-bold leading-[1.04] tracking-[-0.025em] text-text-primary">
              One record per asset.
              <span className="mk-gradient-text"> From the valve to the audit.</span>
            </h1>
            <p className="mt-6 max-w-xl text-bodyLarge leading-relaxed text-text-secondary">
              A failed seat leak test on a relief valve should not need three systems and a phone
              call to become finished, signed-off work. Flacron EnergyVerse carries it end to end —
              and the crew who found it were offline the whole time.
            </p>
            <div className="mt-9 flex flex-wrap gap-3">
              <CtaLink href="/signup">Start free trial</CtaLink>
              <CtaLink href="/pricing" variant="ghost">
                See pricing
              </CtaLink>
            </div>
            <p className="mt-6 flex items-center gap-2 text-bodySmall text-text-muted">
              <span aria-hidden className="size-1.5 rounded-full bg-status-success" />
              No credit card. Your organization and its seven roles exist in about a minute.
            </p>
          </div>

          <div className="lg:pl-6" data-reveal="scale">
            <HeroShowcase />
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------- record chain */}
      <Section tone="surface">
        <SectionHeading
          eyebrow="One asset, one chain"
          highlight="closed-out work"
          lede="Not a feature list — the actual sequence the platform carries, with the role that acts at each step and the permission the API checks before letting them."
          title="How a failed check becomes"
        />
        <div className="mt-16">
          <RecordChain />
        </div>
      </Section>

      {/* --------------------------------------------------------- offline */}
      <Section>
        <div className="grid items-center gap-14 lg:grid-cols-[0.95fr_1.05fr]">
          <div data-reveal="left">
            <Panel interactive={false}>
              <p className="font-mono text-micro uppercase tracking-[0.16em] text-text-muted">
                What offline-first actually means here
              </p>
              <div className="mt-5 grid gap-4">
                {[
                  {
                    head: "Local database, not a cached page",
                    body: "Inspections, readings, media, and work-order updates are written to a real on-device store first. The app does not wait for the network to accept your work.",
                  },
                  {
                    head: "A queue you can see",
                    body: "Pending changes sit in an outbox with their own state. Nothing is silently dropped, and nobody has to guess whether it saved.",
                  },
                  {
                    head: "Sync that reconciles",
                    body: "When coverage returns the engine resolves against the server record instead of overwriting it, so a supervisor's edit is not lost to a stale device.",
                  },
                ].map((item) => (
                  <div className="border-t border-border pt-4 first:border-t-0 first:pt-0" key={item.head}>
                    <h3 className="text-bodySmall font-semibold text-text-primary">{item.head}</h3>
                    <p className="mt-1.5 text-bodySmall leading-relaxed text-text-secondary">
                      {item.body}
                    </p>
                  </div>
                ))}
              </div>
            </Panel>
          </div>
          <div data-reveal="up">
            <SectionHeading
              eyebrow="Built for no coverage"
              highlight="a compressor station"
              lede="Tank farms, process units, and remote stations do not have reliable signal. A tool that needs a connection gets filled in from memory hours later — which is how inspection records stop being worth anything."
              title="Tested against the inside of"
            />
            <ul className="mt-9 grid gap-4">
              <CheckItem>Start and finish a full round with the radio off</CheckItem>
              <CheckItem>
                Photos and voice notes queue on the device and upload when signal returns
              </CheckItem>
              <CheckItem>
                Android, iOS, and the browser from one codebase — the same screens, not a cut-down
                mobile version
              </CheckItem>
              <CheckItem>
                The web portal and the app share a generated API contract, so they cannot drift apart
              </CheckItem>
            </ul>
          </div>
        </div>
      </Section>

      {/* ---------------------------------------------------------- modules */}
      <Section tone="surface">
        <SectionHeading
          eyebrow="Modules"
          highlight="not eight products"
          lede="Each module is useful alone, but they share one asset hierarchy, one permission model, and one audit trail. That is the difference between a platform and a folder of tools."
          title="Eight modules,"
        />
        <div className="mt-16 grid gap-5 md:grid-cols-2 lg:grid-cols-3">
          {tiles.map((tile, index) => (
            <div
              className={tile.span}
              data-reveal="up"
              key={tile.id}
              style={{ "--reveal-delay": `${(index % 3) * 90}ms` } as React.CSSProperties}
            >
              <Panel className="flex h-full flex-col">
                <p className="font-mono text-micro uppercase tracking-[0.16em] text-accent-500">
                  {tile.module}
                </p>
                <h3 className="mt-3 font-heading text-h4 font-semibold leading-snug text-text-primary">
                  {tile.title}
                </h3>
                <p className="mt-2.5 flex-1 text-body leading-relaxed text-text-secondary">
                  {tile.body}
                </p>
                {tile.footer ? (
                  <div className="mt-5 flex flex-wrap gap-1.5 border-t border-border pt-4">
                    {tile.footer.map((chip) => (
                      <span
                        className="rounded-full border border-border px-2.5 py-0.5 font-mono text-micro text-text-muted"
                        key={chip}
                      >
                        {chip}
                      </span>
                    ))}
                  </div>
                ) : null}
              </Panel>
            </div>
          ))}
        </div>
      </Section>

      {/* ------------------------------------------------------ role matrix */}
      <Section>
        <SectionHeading
          eyebrow="Access model"
          highlight="before the demo call"
          lede="Most platforms make you sit through a call to find out who can approve what. Here is the whole thing: seven roles, their real permission-key counts, and the separation of duties the API enforces."
          title="The access model,"
        />
        <div className="mt-14" data-reveal="up">
          <RoleMatrix />
        </div>
        <div className="mt-8 grid gap-5 md:grid-cols-3">
          {[
            {
              head: "Enforced at the API",
              body: "Every route and action sits behind a permission key. Hiding a control in the interface is a convenience, never the boundary.",
            },
            {
              head: "Scoped to your company",
              body: "Records are tenant-scoped and a verified email is required before any access. Another customer's data is not one query away.",
            },
            {
              head: "Attributed, then kept",
              body: "Creates, updates, and status transitions are written to an audit log with the actor and the record — readable by your admins, not just by us.",
            },
          ].map((item, index) => (
            <div
              data-reveal="up"
              key={item.head}
              style={{ "--reveal-delay": `${index * 90}ms` } as React.CSSProperties}
            >
              <Panel className="h-full">
                <h3 className="font-heading text-h5 font-semibold text-text-primary">
                  {item.head}
                </h3>
                <p className="mt-2 text-bodySmall leading-relaxed text-text-secondary">
                  {item.body}
                </p>
              </Panel>
            </div>
          ))}
        </div>
      </Section>

      <CtaBand
        body="Create your organization, add a facility, and run a real inspection against a real asset. That is a truer answer than any demo we could give you."
        primaryHref="/signup"
        primaryLabel="Start free trial"
        secondaryHref="/pricing"
        secondaryLabel="Compare plans"
        title="Put one asset on it this week"
      />
    </>
  );
}
