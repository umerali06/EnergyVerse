import type { Metadata } from "next";

import { RequirePermission } from "@/auth/route-guards";
import { ReportCreatePage } from "@/reports/report-create-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Generate report");

export default function Page() {
  return <RequirePermission permission="reports.generate"><ReportCreatePage /></RequirePermission>;
}
