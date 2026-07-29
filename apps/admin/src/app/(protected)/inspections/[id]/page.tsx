import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Inspection Detail");

import { RequirePermission } from "@/auth/route-guards";
import { InspectionDetailPage } from "@/inspections/inspection-detail-page";

export default async function InspectionDetailRoute({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  return (
    <RequirePermission permission="inspections.read">
      <InspectionDetailPage inspectionId={id} />
    </RequirePermission>
  );
}
