import type { Metadata } from "next";

import { RequirePermission } from "@/auth/route-guards";
import { ReportDetailPage } from "@/reports/report-detail-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Report detail");

export default async function ReportDetailRoute({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <RequirePermission permission="reports.read"><ReportDetailPage reportId={id} /></RequirePermission>;
}
