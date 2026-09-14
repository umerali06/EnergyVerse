import type { Metadata } from "next";

import { LEGAL_DOCUMENTS } from "@/legal/legal-registry";
import { LegalPage } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Terms of Service",
  "The agreement governing access to and use of Flacron Energy, its applications, workflows, subscriptions, and enterprise services.",
  "/terms",
);

export default function Page() {
  return <LegalPage document={LEGAL_DOCUMENTS["terms"]} />;
}
