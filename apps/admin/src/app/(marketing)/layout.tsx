import { MarketingFooter, MarketingHeader } from "@/marketing/marketing-chrome";
import { RevealOnScroll } from "@/marketing/marketing-motion";

/**
 * Public marketing shell. Unlike `(protected)` and `(public)` this group has no
 * auth guard at all: the landing, pricing, and about pages must render for
 * anonymous visitors and crawlers. The header reads the auth context only to
 * choose its call to action.
 *
 * `RevealOnScroll` is the one observer driving every `[data-reveal]` element on
 * the page, so the sections themselves stay server components.
 */
export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen flex-col bg-background text-text-primary">
      <MarketingHeader />
      <main className="flex-1">{children}</main>
      <MarketingFooter />
      <RevealOnScroll />
    </div>
  );
}
