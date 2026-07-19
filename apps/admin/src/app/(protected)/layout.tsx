"use client";

import { Suspense } from "react";

import { RequireAuth, SplashScreen } from "@/auth/route-guards";
import { AppShell } from "@/shell/app-shell";

export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen />}>
      <RequireAuth>
        <AppShell>{children}</AppShell>
      </RequireAuth>
    </Suspense>
  );
}
