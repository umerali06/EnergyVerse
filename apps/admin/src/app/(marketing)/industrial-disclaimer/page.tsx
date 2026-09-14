import type { Metadata } from "next";

import { LEGAL_DOCUMENTS } from "@/legal/legal-registry";
import { LegalPage } from "@/legal/legal-page";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage(
  "AI, AR/VR & Industrial Safety Disclaimer",
  "What Flacron Energy's AI analysis, AR measurement, reporting, 3D and VR training tools are, and what they do not replace.",
  "/industrial-disclaimer",
);

export default function Page() {
  return <LegalPage document={LEGAL_DOCUMENTS["industrial-disclaimer"]} />;
}
