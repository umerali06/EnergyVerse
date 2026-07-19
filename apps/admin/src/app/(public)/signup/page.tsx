import type { Metadata } from "next";

import { SignupScreen } from "@/auth/auth-experience";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage("Create your organization", "Start a Flacron EnergyVerse workspace for your energy company and become its first Company Admin.", "/signup");

export default function Page() {
  return <SignupScreen />;
}
