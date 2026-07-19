import type { Metadata } from "next";

import { LoginScreen } from "@/auth/auth-experience";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage("Sign in", "Sign in to Flacron EnergyVerse to manage assets, inspections, work orders, permits, and safety operations.", "/login");

export default function Page() {
  return <LoginScreen />;
}
