import type { Metadata } from "next";

import { LEGAL_DOCUMENTS } from "@/legal/legal-registry";
import { LegalPage } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Privacy Policy",
  "How Flacron Energy collects, uses, discloses, stores, and protects personal, operational, and industrial information.",
  "/privacy",
);

export default function Page() {
  return <LegalPage document={LEGAL_DOCUMENTS["privacy"]} />;
}
