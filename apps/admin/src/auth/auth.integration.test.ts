import { afterEach, describe, expect, it } from "vitest";

import { FevApiClient } from "@/api";

import { ClientAuthError, FirebaseAuthGateway } from "./firebase-gateway";

const requiredEnvironment = [
  "REAL_API_BASE_URL",
  "SEED_DEMO_EMAIL",
  "SEED_DEMO_PASSWORD",
  "NEXT_PUBLIC_FIREBASE_API_KEY",
  "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN",
  "NEXT_PUBLIC_FIREBASE_PROJECT_ID",
  "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET",
  "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID",
  "NEXT_PUBLIC_FIREBASE_APP_ID",
] as const;

const hasRealCredentials = requiredEnvironment.every((key) => Boolean(process.env[key]));
const describeReal = hasRealCredentials ? describe : describe.skip;

describeReal("Firebase login against the real development project", () => {
  const gateway = new FirebaseAuthGateway();

  async function signInWithTransientNetworkRetry() {
    let lastError: unknown;
    for (let attempt = 0; attempt < 3; attempt += 1) {
      try {
        return await gateway.signIn(
          process.env.SEED_DEMO_EMAIL!,
          process.env.SEED_DEMO_PASSWORD!,
        );
      } catch (error) {
        lastError = error;
        if (!(error instanceof ClientAuthError) || error.code !== "auth/network-request-failed") {
          throw error;
        }
        await new Promise((resolve) => setTimeout(resolve, 1_000 * (attempt + 1)));
      }
    }
    throw lastError;
  }

  afterEach(async () => {
    await gateway.signOut();
  });

  it("signs in and resolves the seeded Field Inspector through /me", async () => {
    const session = await signInWithTransientNetworkRetry();
    const api = new FevApiClient({
      baseUrl: process.env.REAL_API_BASE_URL,
      getIdToken: () => session.getIdToken(),
    });

    const currentUser = await api.getCurrentUser();

    expect(currentUser.email).toBe(process.env.SEED_DEMO_EMAIL);
    expect(currentUser.roleKey).toBe("field_inspector");
    expect([...currentUser.permissions].sort()).toEqual([
      "assets.read",
      "inspections.read",
      "inspections.write",
      "permits.read",
      "reports.generate",
      "reports.read",
      "safety.read",
      "safety.write",
      "work_orders.read",
    ]);
  }, 45_000);
});
