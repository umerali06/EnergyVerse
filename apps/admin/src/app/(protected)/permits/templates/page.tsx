import type { Metadata } from "next";

import { PermitTemplatesPage } from "@/permits/permit-templates-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Permit Templates");

export default function Page() {
  return <PermitTemplatesPage />;
}
