import { RequirePermission } from "@/auth/route-guards";
import { AssetFormPage } from "@/assets/asset-form-page";

export default function NewAssetRoute() {
  return <RequirePermission permission="assets.write"><AssetFormPage /></RequirePermission>;
}
