import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Admin & Settings");

import { ComingSoonScreen } from "@/shell/app-shell";

export default function Page() {
  return <ComingSoonScreen moduleName="Admin & Settings" />;
}
