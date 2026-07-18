import { describe, expect, it, vi } from "vitest";

import { FevApiClient } from "./client";

const identity = {
  uid: "firebase-uid",
  email: "operator@example.invalid",
  company_id: "acme-energy",
  role_key: "operations_manager",
  permissions: ["assets.read", "assets.write"],
};

describe("FevApiClient", () => {
  it("injects the ID token and returns typed generated /me data", async () => {
    const fetchApi = vi.fn(async (_input: RequestInfo | URL, init?: RequestInit) => {
      expect(new Headers(init?.headers).get("Authorization")).toBe("Bearer real-id-token");
      return new Response(JSON.stringify(identity), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      });
    });
    const client = new FevApiClient({
      baseUrl: "http://api.test",
      fetchApi,
      getIdToken: async () => "real-id-token",
    });

    const currentUser = await client.getCurrentUser();

    expect(currentUser.uid).toBe("firebase-uid");
    expect(currentUser.companyId).toBe("acme-energy");
    expect(currentUser.permissions).toEqual(new Set(["assets.read", "assets.write"]));
    expect(fetchApi).toHaveBeenCalledOnce();
  });

  it("maps the unified envelope and runs the 401 hook without a generic toast", async () => {
    const toast = { error: vi.fn() };
    const onUnauthorized = vi.fn();
    const fetchApi = vi.fn(
      async () =>
        new Response(
          JSON.stringify({
            error: "token_expired",
            message: "Token has expired",
            request_id: "bd7deca2-45d0-40ff-81db-758b22c90eaa",
          }),
          { status: 401, headers: { "Content-Type": "application/json" } },
        ),
    );
    const client = new FevApiClient({ fetchApi, onUnauthorized, toast });

    await expect(client.getCurrentUser()).rejects.toMatchObject({
      code: "token_expired",
      message: "Token has expired",
      requestId: "bd7deca2-45d0-40ff-81db-758b22c90eaa",
      status: 401,
    });
    // Session-expired messaging belongs to the onUnauthorized hook, not a toast.
    expect(toast.error).not.toHaveBeenCalled();
    expect(onUnauthorized).toHaveBeenCalledOnce();
  });

  it("retries a 401 once after a forced token refresh and succeeds", async () => {
    const onUnauthorized = vi.fn();
    const refreshIdToken = vi.fn(async () => "fresh-token");
    const fetchApi = vi
      .fn<typeof fetch>()
      .mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            error: "token_expired",
            message: "Token has expired",
            request_id: "11111111-45d0-40ff-81db-758b22c90eaa",
          }),
          { status: 401, headers: { "Content-Type": "application/json" } },
        ),
      )
      .mockResolvedValueOnce(
        new Response(JSON.stringify(identity), {
          status: 200,
          headers: { "Content-Type": "application/json" },
        }),
      );
    const client = new FevApiClient({
      fetchApi,
      getIdToken: async () => "stale-token",
      onUnauthorized,
      refreshIdToken,
    });

    const currentUser = await client.getCurrentUser();

    expect(currentUser.uid).toBe("firebase-uid");
    expect(refreshIdToken).toHaveBeenCalledOnce();
    expect(fetchApi).toHaveBeenCalledTimes(2);
    expect(onUnauthorized).not.toHaveBeenCalled();
  });

  it("signs the session out when the post-refresh retry still returns 401", async () => {
    const onUnauthorized = vi.fn();
    const refreshIdToken = vi.fn(async () => "fresh-token");
    const fetchApi = vi.fn(
      async () =>
        new Response(
          JSON.stringify({
            error: "token_revoked",
            message: "Token has been revoked",
            request_id: "22222222-45d0-40ff-81db-758b22c90eaa",
          }),
          { status: 401, headers: { "Content-Type": "application/json" } },
        ),
    );
    const client = new FevApiClient({ fetchApi, onUnauthorized, refreshIdToken });

    await expect(client.getCurrentUser()).rejects.toMatchObject({
      code: "token_revoked",
      status: 401,
    });
    expect(refreshIdToken).toHaveBeenCalledOnce();
    expect(fetchApi).toHaveBeenCalledTimes(2);
    expect(onUnauthorized).toHaveBeenCalledOnce();
  });

  it("skips the retry and signs out when the token refresh itself fails", async () => {
    const onUnauthorized = vi.fn();
    const refreshIdToken = vi.fn(async () => {
      throw new Error("refresh failed");
    });
    const fetchApi = vi.fn(
      async () =>
        new Response(
          JSON.stringify({
            error: "token_expired",
            message: "Token has expired",
            request_id: "33333333-45d0-40ff-81db-758b22c90eaa",
          }),
          { status: 401, headers: { "Content-Type": "application/json" } },
        ),
    );
    const client = new FevApiClient({ fetchApi, onUnauthorized, refreshIdToken });

    await expect(client.getCurrentUser()).rejects.toMatchObject({ status: 401 });
    expect(fetchApi).toHaveBeenCalledOnce();
    expect(onUnauthorized).toHaveBeenCalledOnce();
  });

  it("turns network failures into a graceful typed error and toast", async () => {
    const toast = { error: vi.fn() };
    const client = new FevApiClient({
      fetchApi: vi.fn(async () => {
        throw new TypeError("offline");
      }),
      toast,
    });

    await expect(client.getHealth()).rejects.toMatchObject({
      code: "network_error",
      message: "Unable to reach the API",
    });
    expect(toast.error).toHaveBeenCalledWith("Unable to reach the API");
  });
});
