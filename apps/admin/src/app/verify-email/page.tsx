"use client";

import { Suspense } from "react";

import { VerifyEmailScreen } from "@/auth/auth-experience";
import { SplashScreen, VerifyEmailGate } from "@/auth/route-guards";

export default function VerifyEmailPage() {
  return (
    <Suspense fallback={<SplashScreen />}>
      <VerifyEmailGate>
        <VerifyEmailScreen />
      </VerifyEmailGate>
    </Suspense>
  );
}
