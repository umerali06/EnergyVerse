import type { Metadata } from "next";

import { SignupPlanScreen } from "@/billing/signup-billing";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Choose your plan");

export default function Page() {
  return <SignupPlanScreen />;
}
