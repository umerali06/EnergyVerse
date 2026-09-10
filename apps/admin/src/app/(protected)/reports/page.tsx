import type { Metadata } from "next";

import { RequirePermission } from "@/auth/route-guards";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Reports");

import { ReportsPage } from "@/reports/reports-page";

export default function Page() {
  return <RequirePermission permission="reports.read"><ReportsPage /></RequirePermission>;
}
