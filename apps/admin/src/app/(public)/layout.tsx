"use client";

import { Suspense } from "react";

import { PublicOnly, SplashScreen } from "@/auth/route-guards";

export default function PublicLayout({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={<SplashScreen />}>
      <PublicOnly>{children}</PublicOnly>
    </Suspense>
  );
}
