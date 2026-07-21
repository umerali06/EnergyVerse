import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Dashboard");

import { DashboardPage } from "@/dashboard/dashboard-page";

export default function HomePage() {
  return <DashboardPage />;
}
