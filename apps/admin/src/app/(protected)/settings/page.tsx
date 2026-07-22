import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Admin & Settings");

import { RequirePermission } from "@/auth/route-guards";
import { CompanySettingsPage } from "@/settings/company-settings-page";

export default function SettingsRoute() {
  return (
    <RequirePermission permission="company.settings">
      <CompanySettingsPage />
    </RequirePermission>
  );
}
