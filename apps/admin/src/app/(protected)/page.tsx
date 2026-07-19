import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Dashboard");

import { AuthenticatedHome } from "@/auth/auth-experience";

export default function HomePage() {
  return <AuthenticatedHome />;
}
