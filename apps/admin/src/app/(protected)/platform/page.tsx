import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Platform Administration");

import { RequirePermission } from "@/auth/route-guards";
import { PlatformPage } from "@/platform/platform-page";

export default function PlatformRoute() {
  return (
    <RequirePermission permission="platform.admin">
      <PlatformPage />
    </RequirePermission>
  );
}
