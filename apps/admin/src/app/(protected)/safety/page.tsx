import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Safety");

import { SafetyPage } from "@/safety/safety-page";

export default function Page() {
  return <SafetyPage />;
}
