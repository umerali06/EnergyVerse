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

  it("maps the unified envelope, shows an error toast, and runs the 401 hook", async () => {
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
    expect(toast.error).toHaveBeenCalledWith("Token has expired");
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
