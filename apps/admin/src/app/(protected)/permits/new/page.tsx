import type { Metadata } from "next";

import { PermitCreatePage } from "@/permits/permit-create-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Create Permit");

export default function Page() {
  return <PermitCreatePage />;
}
