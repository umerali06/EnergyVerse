import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Audit Log");

import { RequirePermission } from "@/auth/route-guards";
import { AuditLogPage } from "@/audit/audit-page";

export default function AuditRoute() {
  return (
    <RequirePermission permission="audit.read">
      <AuditLogPage />
    </RequirePermission>
  );
}
