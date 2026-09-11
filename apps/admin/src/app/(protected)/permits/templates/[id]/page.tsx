import type { Metadata } from "next";

import { PermitTemplateFormPage } from "@/permits/permit-template-form-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Edit Permit Template");

export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <PermitTemplateFormPage templateId={id} />;
}
