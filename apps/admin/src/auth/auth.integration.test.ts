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

const resetEnvironment = [
  "RESET_DEMO_EMAIL",
  "NEXT_PUBLIC_FIREBASE_API_KEY",
  "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN",
  "NEXT_PUBLIC_FIREBASE_PROJECT_ID",
  "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET",
  "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID",
  "NEXT_PUBLIC_FIREBASE_APP_ID",
] as const;

const hasResetCredentials = resetEnvironment.every((key) => Boolean(process.env[key]));
const describeReset = hasResetCredentials ? describe : describe.skip;

describeReset("Firebase password reset against the real development project", () => {
  const gateway = new FirebaseAuthGateway();

  it("sends a real reset email to the demo mailbox", async () => {
    await expect(
      gateway.sendPasswordResetEmail(process.env.RESET_DEMO_EMAIL!),
    ).resolves.toBeUndefined();
  }, 30_000);

  it("keeps unknown emails indistinguishable from success (no enumeration)", async () => {
    // With Firebase email-enumeration protection enabled the SDK resolves for
    // unknown mailboxes; without it, it throws auth/user-not-found, which the
    // client maps to the same neutral confirmation. Either outcome is the
    // documented non-enumerating behavior — anything else fails the test.
    try {
      await gateway.sendPasswordResetEmail("fev-reset-probe-no-such-user-a7c91@gmail.com");
    } catch (error) {
      expect(error).toBeInstanceOf(ClientAuthError);
      expect((error as ClientAuthError).code).toBe("auth/user-not-found");
    }
  }, 30_000);
});

describeReal("Firebase login against the real development project", () => {
  const gateway = new FirebaseAuthGateway();

  async function signInWithTransientNetworkRetry() {
    let lastError: unknown;
    for (let attempt = 0; attempt < 3; attempt += 1) {
      try {
        return await gateway.signIn(process.env.SEED_DEMO_EMAIL!, process.env.SEED_DEMO_PASSWORD!);
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

  it("keeps a session valid across a forced token refresh and hits the authoritative 403", async () => {
    await signInWithTransientNetworkRetry();
    const api = new FevApiClient({
      baseUrl: process.env.REAL_API_BASE_URL,
      getIdToken: () => gateway.getIdToken(),
      refreshIdToken: () => gateway.getIdToken(true),
    });

    const before = await api.getCurrentUser();
    expect(before.roleKey).toBe("field_inspector");

    // Simulate a long-lived session: force a token refresh, then call again.
    await gateway.getIdToken(true);
    const after = await api.getCurrentUser();
    expect(after.uid).toBe(before.uid);

    // The seeded Field Inspector lacks assets.write, so the server-side
    // require_permission gate must reject the RBAC demo route.
    await expect(api.getRbacDemoSingle()).rejects.toMatchObject({ status: 403 });
  }, 60_000);

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
