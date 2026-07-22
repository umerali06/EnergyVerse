import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Roles");

import { RequirePermission } from "@/auth/route-guards";
import { RolesPage } from "@/roles/roles-page";

export default function RolesRoute() {
  return (
    <RequirePermission permission="roles.manage">
      <RolesPage />
    </RequirePermission>
  );
}
