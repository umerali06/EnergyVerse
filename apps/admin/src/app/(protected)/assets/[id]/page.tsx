import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Asset Detail");

import { RequirePermission } from "@/auth/route-guards";
import { AssetDetailPage } from "@/assets/asset-detail-page";

export default async function AssetDetailRoute({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <RequirePermission permission="assets.read">
      <AssetDetailPage assetId={id} />
    </RequirePermission>
  );
}
