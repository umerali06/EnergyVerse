import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Work Order Detail");

import { RequirePermission } from "@/auth/route-guards";
import { WorkOrderDetailPage } from "@/work-orders/work-order-detail-page";

export default async function WorkOrderDetailRoute({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  return (
    <RequirePermission permission="work_orders.read">
      <WorkOrderDetailPage workOrderId={id} />
    </RequirePermission>
  );
}
