import type { Metadata } from "next";

import { SubscriptionPage } from "@/billing/subscription-page";
import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Subscription");

export default function Page() {
  return <SubscriptionPage />;
}
