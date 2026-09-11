import type { Metadata } from "next";

import { PermitTemplateFormPage } from "@/permits/permit-template-form-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Create Permit Template");

export default function Page() {
  return <PermitTemplateFormPage />;
}
