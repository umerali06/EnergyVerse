import { RequirePermission } from "@/auth/route-guards";
import { AssetFormPage } from "@/assets/asset-form-page";

export default async function EditAssetRoute({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <RequirePermission permission="assets.write"><AssetFormPage assetId={id} /></RequirePermission>;
}
