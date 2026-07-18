"use client";

import { RbacDemoScreen } from "@/auth/auth-experience";
import { RequirePermission } from "@/auth/route-guards";

export default function RbacDemoPage() {
  return (
    <RequirePermission permission="assets.write">
      <RbacDemoScreen />
    </RequirePermission>
  );
}
