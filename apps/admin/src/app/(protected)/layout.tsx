"use client";

import { Suspense } from "react";

import { RequireAuth, RequireSubscription, SplashScreen } from "@/auth/route-guards";
import { SubscriptionProvider } from "@/billing/subscription-context";
import { AppShell } from "@/shell/app-shell";

/** `SubscriptionProvider` sits inside `RequireAuth` because only an
 * authenticated session can read a subscription, and outside `AppShell`
 * because the shell's nav is filtered by the company's plan (D-093).
 *
 * `RequireSubscription` then stands between the two: an admin who never
 * finished checkout is sent back to the plan step instead of being shown a
 * shell whose nav is empty and whose every request answers 402 (D-103). */
export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen />}>
      <RequireAuth>
        <SubscriptionProvider>
          <RequireSubscription>
            <AppShell>{children}</AppShell>
          </RequireSubscription>
        </SubscriptionProvider>
      </RequireAuth>
    </Suspense>
  );
}
