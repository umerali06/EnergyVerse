import type { Metadata } from "next";

import { SignupCompleteScreen } from "@/billing/signup-billing";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Activating your subscription");

export default function Page() {
  return <SignupCompleteScreen />;
}
