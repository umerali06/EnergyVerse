import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Permits");

import { PermitsPage } from "@/permits/permits-page";

export default function Page() {
  return <PermitsPage />;
}
