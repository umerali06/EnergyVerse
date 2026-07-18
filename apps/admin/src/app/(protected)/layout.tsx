"use client";

import { Suspense } from "react";

import { RequireAuth, SplashScreen } from "@/auth/route-guards";

export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen />}>
      <RequireAuth>{children}</RequireAuth>
    </Suspense>
  );
}
