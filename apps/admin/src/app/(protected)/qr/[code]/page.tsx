import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("QR Code");

import { RequirePermission } from "@/auth/route-guards";
import { QrResolvePage } from "@/qr/qr-resolve-page";

export default async function QrResolveRoute({ params }: { params: Promise<{ code: string }> }) {
  const { code } = await params;
  return (
    <RequirePermission permission="assets.read">
      <QrResolvePage code={code} />
    </RequirePermission>
  );
}
