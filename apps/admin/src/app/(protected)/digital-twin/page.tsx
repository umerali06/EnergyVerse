import type { Metadata } from "next";

import { RequirePermission } from "@/auth/route-guards";
import { DigitalTwinPage } from "@/facilities/digital-twin-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("3D Digital Twin");

export default function Page() {
  return (
    <RequirePermission permission="facilities.read">
      <DigitalTwinPage />
    </RequirePermission>
  );
}
