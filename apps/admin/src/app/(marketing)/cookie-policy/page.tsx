import type { Metadata } from "next";

import { LEGAL_DOCUMENTS } from "@/legal/legal-registry";
import { LegalPage } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "Cookie Policy",
  "The cookies and similar technologies Flacron Energy may use, and how to change your choices at any time.",
  "/cookie-policy",
);

export default function Page() {
  return <LegalPage document={LEGAL_DOCUMENTS["cookie-policy"]} />;
}
