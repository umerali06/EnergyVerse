import type { Metadata } from "next";

import { LEGAL_DOCUMENTS } from "@/legal/legal-registry";
import { LegalPage } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Refund & Cancellation Policy",
  "How Flacron Energy subscription charges, cancellation, non-renewal, and refund requests are handled.",
  "/refund-policy",
);

export default function Page() {
  return <LegalPage document={LEGAL_DOCUMENTS["refund-policy"]} />;
}
