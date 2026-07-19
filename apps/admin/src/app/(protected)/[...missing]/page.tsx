import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Not found");

import { NotFoundScreen } from "@/shell/app-shell";

export default function MissingPage() {
  return <NotFoundScreen />;
}
