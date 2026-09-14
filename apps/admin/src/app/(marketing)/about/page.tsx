import type { Metadata } from "next";

import {
  Ambient,
  CheckItem,
  CtaBand,
  Panel,
  Section,
  SectionHeading,
} from "@/marketing/marketing-ui";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "About",
  "Flacron Energy is built by Flacron Enterprises for energy field operations — one auditable record for assets, inspections, work orders, permits, and safety.",
  "/about",
);

const principles = [
  {
    title: "The field comes first",
    body: "Every decision is checked against a technician standing at a valve with no signal and gloves on. If it does not work there, it does not ship.",
  },
  {
    title: "The server is the authority",
    body: "Hiding a button is not access control. Permissions, tenant scoping, and email verification are enforced by the API, so the interface can never be the security boundary.",
  },
  {
    title: "Nothing is faked",
    body: "Screens show real records or an honest empty state. There is no seeded filler dressed up as data, because a demo that lies costs you trust on day one.",
  },
  {
    title: "Every change is attributable",
    body: "Creates, updates, and status transitions are written to an audit log with the actor and the record. That is what makes a compliance conversation short.",
  },
] as const;

export default function AboutPage() {
  return (
    <>
      <section className="relative overflow-hidden px-5 pb-20 pt-16 md:px-8 md:pb-28 md:pt-24">
        <Ambient />
        <div className="relative mx-auto w-full max-w-6xl" data-reveal="up">
        <SectionHeading
          eyebrow="About"
          highlight="keep the plant running"
          lede="Flacron Energy is a field operations platform built by Flacron Enterprises for the people who inspect, maintain, and sign off on energy infrastructure."
          level={1}
          title="Software for the crews who"
        />
        <div className="mt-10 grid max-w-3xl gap-5 text-bodyLarge leading-relaxed text-text-secondary">
          <p>
            Energy operations run on records: what was inspected, what is broken, who was allowed
            to work on it, and who signed it off. In most organisations those records are spread
            across paper checklists, a spreadsheet, a shared drive, and a group chat — which means
            the operation cannot answer basic questions quickly, and an audit turns into weeks of
            reconstruction.
          </p>
          <p>
            We built one system for that record. Assets, inspections, work orders, permits, safety
            reports, generated reports, and controlled documents live in a single tenant-isolated
            platform with one permission model and one audit trail. Supervisors work on the web;
            crews work on a mobile app that keeps functioning when the site has no coverage.
          </p>
        </div>
        </div>
      </section>

      <Section tone="surface">
        <SectionHeading
          eyebrow="How we build"
          lede="Four rules that decide the arguments, written down so they survive contact with a deadline."
          title="What we refuse to compromise on"
        />
        <div className="mt-14 grid gap-5 md:grid-cols-2">
          {principles.map((principle, index) => (
            <Panel
              data-reveal="up"
              key={principle.title}
              style={{ "--reveal-delay": `${(index % 2) * 90}ms` } as React.CSSProperties}
            >
              <h3 className="font-heading text-h4 font-semibold text-text-primary">
                {principle.title}
              </h3>
              <p className="mt-2.5 text-body text-text-secondary">{principle.body}</p>
            </Panel>
          ))}
        </div>
      </Section>

      <Section>
        <div className="grid items-start gap-12 lg:grid-cols-2">
          <div data-reveal="up">
            <SectionHeading
              eyebrow="The platform"
              highlight="put together"
              lede="One backend, two clients, one contract between them."
              title="How it is"
            />
            <ul className="mt-9 grid gap-4">
              <CheckItem>
                A Python API that owns every business rule, permission check, and audit write
              </CheckItem>
              <CheckItem>
                A web admin portal for supervisors, planners, HSE, and company administrators
              </CheckItem>
              <CheckItem>
                A Flutter app for Android, iOS, and the browser, built local-first with its own sync
                engine
              </CheckItem>
              <CheckItem>
                A generated API contract shared by both clients, so the two never drift apart
              </CheckItem>
              <CheckItem>
                One design token source driving both interfaces, in light and dark themes
              </CheckItem>
            </ul>
          </div>
          <div data-reveal="up" style={{ "--reveal-delay": "120ms" } as React.CSSProperties}>
            <SectionHeading
              eyebrow="Where it is going"
              highlight="phase by phase"
              lede="The platform ships in phases, each one a working slice rather than a partial rewrite."
              title="Built in the open,"
            />
            <ul className="mt-9 grid gap-4">
              <CheckItem>Assets, inspections, and checklist templates — shipped</CheckItem>
              <CheckItem>Work orders, permits, and safety reporting — shipped</CheckItem>
              <CheckItem>
                Generated reports with locked PDF, Word, and Excel exports — shipped
              </CheckItem>
              <CheckItem>3D digital twin facility view — shipped</CheckItem>
              <CheckItem>Controlled document library — shipped</CheckItem>
            </ul>
            <Panel className="mt-8">
              <p className="font-mono text-caption uppercase tracking-[0.18em] text-text-muted">
                Get in touch
              </p>
              <p className="mt-3 text-body text-text-secondary">
                Questions about a rollout, security review, or migrating your existing inspection
                forms?{" "}
                <a
                  className="font-semibold text-text-primary underline decoration-border underline-offset-4"
                  href="mailto:sales@flacronenterprises.com?subject=Flacron%20Energy"
                >
                  sales@flacronenterprises.com
                </a>
              </p>
            </Panel>
          </div>
        </div>
      </Section>

      <CtaBand
        body="Create your organization and run a real inspection on a real asset. That is the fastest way to judge whether this fits how your crews work."
        primaryHref="/signup"
        primaryLabel="Start free trial"
        secondaryHref="/pricing"
        secondaryLabel="See pricing"
        title="See it against your own site"
      />
    </>
  );
}
