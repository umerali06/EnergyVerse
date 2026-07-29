import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Inspections");

import { RequirePermission } from "@/auth/route-guards";
import { InspectionsPage } from "@/inspections/inspections-page";

export default function InspectionsRoute() {
  return (
    <RequirePermission permission="inspections.read">
      <InspectionsPage />
    </RequirePermission>
  );
}
