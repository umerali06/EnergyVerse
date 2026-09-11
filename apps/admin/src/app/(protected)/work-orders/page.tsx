import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Work Orders");

import { RequirePermission } from "@/auth/route-guards";
import { WorkOrdersPage } from "@/work-orders/work-orders-page";

export default function WorkOrdersRoute() {
  return (
    <RequirePermission permission="work_orders.read">
      <WorkOrdersPage />
    </RequirePermission>
  );
}
