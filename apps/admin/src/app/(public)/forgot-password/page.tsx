import type { Metadata } from "next";

import { ForgotPasswordScreen } from "@/auth/auth-experience";
import { publicPage } from "@/seo/site";

export const metadata: Metadata = publicPage("Reset your password", "Request a secure password reset link for your Flacron EnergyVerse account.", "/forgot-password");

export default function Page() {
  return <ForgotPasswordScreen />;
}
