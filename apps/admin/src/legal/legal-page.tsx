import Link from "next/link";

import { Logo } from "@/design-system";

import {
  LEGAL_LAST_UPDATED,
  LEGAL_ROUTES,
  LEGAL_VERSION,
  OPERATOR,
  type LegalBlock,
  type LegalDocument,
} from "./legal-content";

/**
 * The one renderer every legal page uses.
 *
 * The package's design requirements are structural, not decorative, so they are
 * enforced here rather than left to each page: the logo is rendered whole
 * (never cropped), body text stays at reading size instead of the small print
 * legal pages usually get, the column is capped at ~65 characters, a desktop
 * table of contents is generated from the real section headings, and both the
 * "Last Updated" date and a Back to Top control are always present.
 *
 * Light and dark are handled by the design tokens the rest of the product uses,
 * so these pages inherit the same navy and orange accents and stay readable in
 * either theme without a second palette.
 */

function NoticeCallout({
  title,
  text,
  tone = "info",
}: {
  title: string;
  text: string;
  tone?: "info" | "warning";
}) {
  return (
    <aside
      className={`my-6 rounded-lg border-l-4 bg-elevated p-5 ${
        tone === "warning" ? "border-l-accent-500" : "border-l-primary-500"
      }`}
      role="note"
    >
      <p className="font-heading text-bodySmall font-bold text-text-primary">{title}</p>
      <p className="mt-2 text-body leading-relaxed text-text-secondary">{text}</p>
    </aside>
  );
}

/** The operator identity table the package repeats at the foot of each policy. */
export function OperatorTable() {
  const rows = [
    ["Product", OPERATOR.product],
    ["Operator", OPERATOR.operator],
    ["Address", OPERATOR.address],
    ["Phone", OPERATOR.phone],
    ["Primary Contact", OPERATOR.email],
    ["Platform Type", OPERATOR.platformType],
    ["Branding", OPERATOR.branding],
  ] as const;
  return (
    <div className="my-8 overflow-x-auto">
      <table className="w-full border-collapse text-left text-bodySmall">
        <caption className="sr-only">Flacron Energy operator and contact details</caption>
        <tbody>
          {rows.map(([label, value]) => (
            <tr className="border-b border-border align-top" key={label}>
              <th
                className="w-44 shrink-0 py-3 pr-4 font-semibold text-text-primary"
                scope="row"
              >
                {label}
              </th>
              <td className="py-3 text-text-secondary">{value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function Block({ block }: { block: LegalBlock }) {
  switch (block.kind) {
    case "p":
      return <p className="mt-4 text-body leading-relaxed text-text-secondary">{block.text}</p>;
    case "list":
      return (
        <ul className="mt-4 grid gap-2">
          {block.items.map((item) => (
            <li
              className="relative pl-6 text-body leading-relaxed text-text-secondary before:absolute before:left-1 before:top-[0.7em] before:size-1.5 before:rounded-full before:bg-accent-500"
              key={item}
            >
              {item}
            </li>
          ))}
        </ul>
      );
    case "notice":
      return <NoticeCallout text={block.text} title={block.title} tone={block.tone} />;
    case "contact":
      return <OperatorTable />;
    case "table":
      return (
        <div className="my-6 overflow-x-auto">
          <table className="w-full min-w-[42rem] border-collapse text-left text-bodySmall">
            <thead>
              <tr className="bg-primary-800 text-white dark:bg-primary-400 dark:text-primary-900">
                {block.head.map((cell) => (
                  <th className="px-4 py-3 font-semibold" key={cell} scope="col">
                    {cell}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {block.rows.map((row) => (
                <tr className="border-b border-border align-top" key={row[0]}>
                  {row.map((cell, index) => (
                    <td
                      className={`px-4 py-3 ${
                        index === 0 ? "font-semibold text-text-primary" : "text-text-secondary"
                      }`}
                      key={cell}
                    >
                      {cell}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      );
  }
}

export function LegalPage({ document }: { document: LegalDocument }) {
  return (
    <div className="px-5 py-14 md:px-8 md:py-20">
      {/* ~900-1000px of legal content, with the table of contents outside it so
          the reading column keeps its measure on a wide screen. */}
      <div className="mx-auto grid w-full max-w-6xl gap-12 lg:grid-cols-[minmax(0,1fr)_16rem]">
        <article className="min-w-0 max-w-[62rem]">
          <Logo height={34} priority variant="wordmark" />

          <h1 className="mt-8 font-heading text-h1 font-bold leading-tight text-text-primary">
            {document.title}
          </h1>
          <p className="mt-3 max-w-2xl text-body leading-relaxed text-text-secondary">
            {document.lede}
          </p>
          <p className="mt-5 flex flex-wrap items-center gap-x-3 gap-y-1 font-mono text-caption uppercase tracking-[0.14em] text-text-muted">
            <span>Last Updated: {LEGAL_LAST_UPDATED}</span>
            <span aria-hidden>·</span>
            <span>Version {LEGAL_VERSION}</span>
          </p>

          {document.intro?.map((block, index) => <Block block={block} key={index} />)}

          {document.sections.map((section) => (
            <section className="mt-12 scroll-mt-24" id={section.id} key={section.id}>
              <h2 className="font-heading text-h2 font-bold leading-snug text-text-primary">
                {section.title}
              </h2>
              {section.blocks.map((block, index) => (
                <Block block={block} key={index} />
              ))}
            </section>
          ))}

          <div className="mt-14 border-t border-border pt-6">
            <p className="text-bodySmall text-text-secondary">
              Questions about this document? Contact{" "}
              <a
                className="font-semibold text-accent-600 underline underline-offset-2 dark:text-accent-400"
                href={`mailto:${OPERATOR.email}`}
              >
                {OPERATOR.email}
              </a>
              .
            </p>
            <a
              className="mt-5 inline-flex items-center gap-2 rounded-md border border-border px-4 py-2 text-bodySmall font-semibold text-text-secondary transition-colors hover:border-accent-500 hover:text-text-primary"
              href="#top"
            >
              <svg
                aria-hidden
                className="size-4"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                viewBox="0 0 24 24"
              >
                <path d="M12 19V5M5 12l7-7 7 7" />
              </svg>
              Back to top
            </a>
          </div>
        </article>

        {/* Desktop table of contents. Hidden rather than reflowed on mobile:
            a 20-item link list above the document would bury the document. */}
        <nav
          aria-label="On this page"
          className="hidden lg:sticky lg:top-24 lg:block lg:self-start"
        >
          <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            On this page
          </p>
          <ul className="mt-4 grid gap-2 border-l border-border pl-4">
            {document.sections.map((section) => (
              <li key={section.id}>
                <a
                  className="block text-caption leading-snug text-text-secondary transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                  href={`#${section.id}`}
                >
                  {section.title}
                </a>
              </li>
            ))}
          </ul>
          <p className="mt-8 font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            Other policies
          </p>
          <ul className="mt-4 grid gap-2 border-l border-border pl-4">
            {LEGAL_ROUTES.filter((route) => !route.href.endsWith(document.slug)).map((route) => (
              <li key={route.href}>
                <Link
                  className="block text-caption leading-snug text-text-secondary transition-colors hover:text-accent-600 dark:hover:text-accent-400"
                  href={route.href}
                >
                  {route.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </div>
  );
}
