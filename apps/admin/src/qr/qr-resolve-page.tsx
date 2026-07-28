"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { ApiClientError } from "@/api/client";
import { useAuth } from "@/auth/auth-context";
import { EmptyState, MotionSection, Spinner } from "@/design-system";

type ResolveStatus = "resolving" | "not-found" | "error";

export function QrResolvePage({
  code,
  reducedMotionOverride,
}: {
  code: string;
  reducedMotionOverride?: boolean;
}) {
  const { apiClient } = useAuth();
  const router = useRouter();
  const [status, setStatus] = useState<ResolveStatus>("resolving");

  useEffect(() => {
    let active = true;
    setStatus("resolving");
    apiClient
      .resolveQrCode(code)
      .then((result) => {
        if (active) router.replace(`/assets/${result.asset.id}`);
      })
      .catch((error: unknown) => {
        if (!active) return;
        const notFound = error instanceof ApiClientError && error.status === 404;
        setStatus(notFound ? "not-found" : "error");
      });
    return () => {
      active = false;
    };
  }, [apiClient, code, router]);

  if (status === "resolving") {
    return (
      <section className="grid min-h-[60vh] place-items-center p-6" data-testid="qr-resolving">
        <Spinner label="Resolving QR code" />
      </section>
    );
  }

  return (
    <section className="grid min-h-[60vh] place-items-center p-6">
      <MotionSection
        className="w-full max-w-md"
        reducedMotionOverride={reducedMotionOverride}
      >
        <EmptyState
          description={
            status === "not-found"
              ? "This code isn't recognized, or belongs to a different company."
              : "Couldn't resolve this QR code. Check your connection and try again."
          }
          title={status === "not-found" ? "QR code not found" : "Something went wrong"}
        />
      </MotionSection>
    </section>
  );
}
