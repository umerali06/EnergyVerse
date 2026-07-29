import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Checklist Templates");

import { RequirePermission } from "@/auth/route-guards";
import { ChecklistTemplatesPage } from "@/checklist-templates/checklist-templates-page";

export default function ChecklistTemplatesRoute() {
  return (
    <RequirePermission permission="checklist_templates.read">
      <ChecklistTemplatesPage />
    </RequirePermission>
  );
}
