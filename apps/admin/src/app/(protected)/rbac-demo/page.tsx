import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Assets demo");

import { RbacDemoScreen } from "@/auth/auth-experience";
import { RequirePermission } from "@/auth/route-guards";

export default function RbacDemoPage() {
  return (
    <RequirePermission permission="assets.write">
      <RbacDemoScreen />
    </RequirePermission>
  );
}
