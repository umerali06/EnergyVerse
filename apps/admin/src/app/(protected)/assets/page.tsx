import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Assets");

import { RequirePermission } from "@/auth/route-guards";
import { AssetsPage } from "@/assets/assets-page";

export default function AssetsRoute() {
  return (
    <RequirePermission permission="assets.read">
      <AssetsPage />
    </RequirePermission>
  );
}
