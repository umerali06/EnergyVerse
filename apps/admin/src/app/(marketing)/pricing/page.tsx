import type { Metadata } from "next";

import {
  Ambient,
  CheckItem,
  CtaBand,
  CtaLink,
  Panel,
  Section,
  SectionHeading,
} from "@/marketing/marketing-ui";
import {
  BASE_MODULES,
  TRIAL_DAYS,
  allowanceLine,
  formatPrice,
  plans,
  pricingFaqs,
  seatAddOns,
  services,
  usageAddOns,
} from "@/marketing/pricing-plans";
import { PricingLegalNote } from "@/legal/commercial-notices";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Pricing",
  "Per-site licensing with role-based seats for oil, gas, and energy operations. Starter through Enterprise, each with a 7-day trial on the plan's full feature set.",
  "/pricing",
);

/** Carries the chosen plan into step one of signup, so the checkout in step two
 * already knows which Price to open. */
function signupHref(tier: string): string {
  return `/signup?plan=${tier}&interval=annual`;
}

export default function PricingPage() {
  return (
    <>
      <section className="relative overflow-hidden px-5 pb-20 pt-16 md:px-8 md:pb-28 md:pt-24">
        <Ambient />
        <div className="relative mx-auto w-full max-w-6xl" data-reveal="up">
          <SectionHeading
            align="center"
            eyebrow="Pricing"
            highlight="the site, not the software"
            lede={`Priced against what a facility is worth, not against generic field-service tools. Every tier starts with a ${TRIAL_DAYS}-day trial on its full feature set, billed annually — monthly billing is available at a premium.`}
            level={1}
            title="Licensed per"
          />

          <div className="mt-16 grid gap-6 lg:grid-cols-2 xl:grid-cols-4">
            {plans.map((plan, index) => (
              <div
                className={`mk-panel relative flex flex-col overflow-hidden rounded-xl border bg-surface p-7 ${
                  plan.featured ? "border-accent-500 xl:-mt-4 xl:pb-11" : "border-border"
                }`}
                data-reveal="up"
                key={plan.tier}
                style={{ "--reveal-delay": `${index * 90}ms` } as React.CSSProperties}
              >
                <div className="flex items-center gap-3">
                  <h2 className="font-heading text-h3 font-bold text-text-primary">{plan.name}</h2>
                  {plan.featured ? (
                    <span className="rounded-full bg-accent-500 px-2.5 py-0.5 font-mono text-micro uppercase tracking-[0.16em] text-accent-ink">
                      Most chosen
                    </span>
                  ) : null}
                </div>
                <p className="mt-2 text-bodySmall leading-relaxed text-text-secondary">
                  {plan.audience}
                </p>

                <p
                  className={`mt-8 font-heading text-h1 font-bold leading-none tracking-[-0.02em] ${
                    plan.featured ? "mk-gradient-text" : "text-text-primary"
                  }`}
                >
                  {plan.customQuoted ? "From " : null}
                  {formatPrice(plan.listMonthlyCents)}
                </p>
                <p className="mt-2 text-bodySmall text-text-muted">
                  per month, billed annually ({formatPrice(plan.annualTotalCents)}/yr)
                </p>
                <p className="mt-1 font-mono text-micro text-text-muted">
                  or {formatPrice(plan.monthlyCents)}/mo billed monthly
                </p>

                <p className="mt-5 rounded-lg border border-border px-3 py-2 font-mono text-micro leading-relaxed text-text-secondary">
                  {allowanceLine(plan)}
                </p>

                <div className="mt-6">
                  <CtaLink
                    className="w-full"
                    href={signupHref(plan.tier)}
                    variant={plan.featured ? "accent" : "ghost"}
                  >
                    Start {TRIAL_DAYS}-day trial
                  </CtaLink>
                </div>
                {plan.customQuoted ? (
                  <p className="mt-3 text-center text-caption text-text-muted">
                    Quoted against sites, assets, and integration scope.{" "}
                    <a
                      className="font-semibold text-text-secondary underline decoration-border underline-offset-4 hover:text-text-primary"
                      href="mailto:sales@flacronenterprises.com?subject=Flacron%20Energy%20Enterprise"
                    >
                      Contact sales
                    </a>
                  </p>
                ) : null}

                {plan.adds.length > 0 ? (
                  <>
                    <p className="mt-7 font-mono text-micro uppercase tracking-[0.16em] text-accent-500">
                      Adds
                    </p>
                    <ul className="mt-3 grid gap-2.5">
                      {plan.adds.map((item) => (
                        <CheckItem key={item}>{item}</CheckItem>
                      ))}
                    </ul>
                  </>
                ) : (
                  <p className="mt-7 text-caption leading-relaxed text-text-muted">
                    Includes the full base platform below. AR inspection, permit-to-work, and work
                    orders start at Operations.
                  </p>
                )}

                <p className="mt-auto pt-7 font-mono text-micro text-text-muted">{plan.support}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ---------------------------------------------------- base platform */}
      <Section tone="surface">
        <SectionHeading
          eyebrow="Every tier"
          highlight="not add-ons"
          lede="These are the platform, not a bundle you assemble. The tiers differ on capacity and on three modules, never on whether your records are auditable."
          title="The base platform,"
        />
        <div className="mt-14 grid gap-3 md:grid-cols-2">
          {BASE_MODULES.map((module, index) => (
            <div
              data-reveal="up"
              key={module}
              style={{ "--reveal-delay": `${(index % 2) * 70}ms` } as React.CSSProperties}
            >
              <ul>
                <CheckItem>{module}</CheckItem>
              </ul>
            </div>
          ))}
        </div>
      </Section>

      {/* ------------------------------------------------------- add-ons */}
      <Section>
        <SectionHeading
          eyebrow="Beyond the allotment"
          lede="Seats, assets, and sites are additive — you are never forced up a whole tier to add one inspector."
          title="Add-on pricing"
        />
        <div className="mt-14 grid gap-6 lg:grid-cols-2">
          <Panel data-reveal="up">
            <h3 className="font-heading text-h4 font-semibold text-text-primary">
              Per seat, per month
            </h3>
            <p className="mt-2 text-bodySmall text-text-secondary">
              Beyond each tier&apos;s included seats. Executive read-only, Super Admin, and Company
              Admin seats are free on every tier.
            </p>
            <dl className="mt-5 grid gap-0">
              {seatAddOns.map((seat) => (
                <div
                  className="flex items-baseline justify-between gap-4 border-t border-border py-3 first:border-t-0"
                  key={seat.role}
                >
                  <dt className="text-bodySmall text-text-secondary">
                    {seat.role}
                    {"note" in seat && seat.note ? (
                      <span className="mt-0.5 block text-caption text-text-muted">{seat.note}</span>
                    ) : null}
                  </dt>
                  <dd className="whitespace-nowrap font-mono text-bodySmall font-semibold text-text-primary">
                    {formatPrice(seat.cents)}
                  </dd>
                </div>
              ))}
            </dl>
          </Panel>
          <Panel data-reveal="up" style={{ "--reveal-delay": "90ms" } as React.CSSProperties}>
            <h3 className="font-heading text-h4 font-semibold text-text-primary">
              Capacity and modules
            </h3>
            <p className="mt-2 text-bodySmall text-text-secondary">
              Monthly, on top of the base licence. Custom 3D facility model builds are quoted
              per facility.
            </p>
            <dl className="mt-5 grid gap-0">
              {usageAddOns.map((item) => (
                <div
                  className="flex items-baseline justify-between gap-4 border-t border-border py-3 first:border-t-0"
                  key={item.label}
                >
                  <dt className="text-bodySmall text-text-secondary">{item.label}</dt>
                  <dd className="whitespace-nowrap font-mono text-bodySmall font-semibold text-text-primary">
                    {formatPrice(item.cents)}
                  </dd>
                </div>
              ))}
            </dl>
          </Panel>
        </div>
      </Section>

      {/* ---------------------------------------------------- services */}
      <Section tone="surface">
        <SectionHeading
          eyebrow="Implementation"
          lede="An asset platform is only as good as the data in it, so onboarding is a real engagement rather than a login link."
          title="Onboarding and support"
        />
        <div className="mt-14 grid gap-5 md:grid-cols-2">
          {services.map((service, index) => (
            <Panel
              data-reveal="up"
              key={service.label}
              style={{ "--reveal-delay": `${(index % 2) * 90}ms` } as React.CSSProperties}
            >
              <p className="font-mono text-micro uppercase tracking-[0.16em] text-text-muted">
                {service.tiers}
              </p>
              <h3 className="mt-3 text-bodySmall font-semibold leading-relaxed text-text-primary">
                {service.label}
              </h3>
              <p className="mt-3 font-mono text-caption text-accent-600 dark:text-accent-400">
                {service.price}
              </p>
            </Panel>
          ))}
        </div>
      </Section>

      {/* --------------------------------------------------------- faqs */}
      <Section>
        <SectionHeading eyebrow="Questions" highlight="a trial" title="Before you start" />
        <dl className="mt-14 grid gap-5 md:grid-cols-2">
          {pricingFaqs.map((faq, index) => (
            <Panel
              data-reveal="up"
              key={faq.question}
              style={{ "--reveal-delay": `${(index % 2) * 90}ms` } as React.CSSProperties}
            >
              <dt className="font-heading text-h5 font-semibold text-text-primary">
                {faq.question}
              </dt>
              <dd className="mt-2.5 text-body leading-relaxed text-text-secondary">{faq.answer}</dd>
            </Panel>
          ))}
        </dl>
      </Section>

      <section className="px-5 pb-4 md:px-8">
        <div className="mx-auto w-full max-w-6xl border-t border-border pt-8">
          <PricingLegalNote />
        </div>
      </section>

      <CtaBand
        body={`Pick a plan, enter a card, and run a real inspection on a real asset. Nothing is charged for ${TRIAL_DAYS} days.`}
        primaryHref={signupHref("operations")}
        primaryLabel={`Start ${TRIAL_DAYS}-day trial`}
        secondaryHref="/about"
        secondaryLabel="About the platform"
        title="Try it on one site this week"
      />
    </>
  );
}
