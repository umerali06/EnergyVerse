import { describe, expect, it, vi } from "vitest";

import { ApiClientError, FevApiClient } from "./client";

const apiBaseUrl = process.env.REAL_API_BASE_URL;
const firebaseWebApiKey = process.env.FIREBASE_WEB_API_KEY;
const demoPassword = process.env.SEED_DEMO_PASSWORD;
const realAuthConfigured = Boolean(apiBaseUrl && firebaseWebApiKey && demoPassword);

const fieldInspectorPermissions = [
  "assets.read",
  "inspections.read",
  "inspections.write",
  "permits.read",
  "reports.generate",
  "reports.read",
  "safety.read",
  "safety.write",
  "work_orders.read",
];

describe.skipIf(!realAuthConfigured)("FevApiClient real Firebase chain", () => {
  it("signs in and resolves typed /me through the generated client", async () => {
    const signIn = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${firebaseWebApiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email: "field_inspector@acme.example.invalid",
          password: demoPassword,
          returnSecureToken: true,
        }),
      },
    );
    expect(signIn.status).toBe(200);
    const { idToken } = (await signIn.json()) as { idToken: string };

    const client = new FevApiClient({
      baseUrl: apiBaseUrl,
      getIdToken: () => idToken,
    });
    const identity = await client.getCurrentUser();

    expect(identity.email).toBe("field_inspector@acme.example.invalid");
    expect(identity.companyId).toBe("acme-energy");
    expect(identity.roleKey).toBe("field_inspector");
    expect([...identity.permissions].sort()).toEqual(fieldInspectorPermissions);
  }, 120_000);

  it("maps a real 401 envelope to a toast and preserves request_id", async () => {
    const toast = { error: vi.fn() };
    const onUnauthorized = vi.fn();
    const client = new FevApiClient({
      baseUrl: apiBaseUrl,
      getIdToken: () => "definitely-not-a-token",
      onUnauthorized,
      toast,
    });

    let failure: ApiClientError | undefined;
    try {
      await client.getCurrentUser();
    } catch (error) {
      failure = error as ApiClientError;
    }

    expect(failure).toMatchObject({
      code: "invalid_token",
      status: 401,
    });
    expect(failure?.requestId).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/,
    );
    expect(toast.error).toHaveBeenCalledWith(failure?.message);
    expect(onUnauthorized).toHaveBeenCalledOnce();
  });
});
