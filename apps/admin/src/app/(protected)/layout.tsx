"use client";

import { Suspense } from "react";

import { RequireAuth, SplashScreen } from "@/auth/route-guards";
import { SubscriptionProvider } from "@/billing/subscription-context";
import { AppShell } from "@/shell/app-shell";

/** `SubscriptionProvider` sits inside `RequireAuth` because only an
 * authenticated session can read a subscription, and outside `AppShell`
 * because the shell's nav is filtered by the company's plan (D-093). */
export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen />}>
      <RequireAuth>
        <SubscriptionProvider>
          <AppShell>{children}</AppShell>
        </SubscriptionProvider>
      </RequireAuth>
    </Suspense>
  );
}
