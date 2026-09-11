import type { Metadata } from "next";

import { RequirePermission } from "@/auth/route-guards";
import { PermitDetailPage } from "@/permits/permit-detail-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Permit Detail");

export default async function PermitDetailRoute({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <RequirePermission permission="permits.read"><PermitDetailPage permitId={id} /></RequirePermission>;
}
