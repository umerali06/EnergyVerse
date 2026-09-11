"use client";

import { Suspense } from "react";

import { RequireAccount, SplashScreen } from "@/auth/route-guards";

/**
 * The steps between registering and having a usable workspace.
 *
 * Its own group rather than `(public)`: `PublicOnly` would bounce these pages
 * away the moment registration signs the new admin in, and `(protected)`'s
 * `RequireAuth` would demand a verified email the new admin does not have yet.
 * `RequireAccount` admits anyone whose account exists (D-092).
 */
export default function BillingSetupLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen label="Preparing your workspace" />}>
      <RequireAccount>{children}</RequireAccount>
    </Suspense>
  );
}
