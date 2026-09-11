import { describe, expect, it } from "vitest";

import {
  CompanyRegistrationRequestToJSON,
  CreateAssetRequestToJSON,
} from "@fev/api-client";

/**
 * Guards the wire shape of request bodies against a generator regression.
 *
 * openapi-generator emits a `...value` spread in `*ToJSON` for any schema
 * declaring `additionalProperties: false` — it reads the keyword as "this model
 * carries extra properties" and passes the source object through verbatim. The
 * body then holds both the wire name and the camelCase original:
 *
 *     { companyName: "x", company_name: "x", ... }
 *
 * That keyword comes from the API's `StrictModel` (`extra="forbid"`), so the
 * server rejected those duplicates with a 422 and `POST /api/v1/auth/register`
 * could never succeed from a browser. Exactly the three strictest models were
 * the only ones whose clients could not talk to them.
 *
 * `packages/contracts/scripts/gen-clients.mjs` strips the spread after
 * generation. These cases fail if that step is ever lost, since the clients are
 * regenerated and a hand-fix would not survive.
 */
describe("generated request serialization", () => {
  it("sends registration as exactly the four declared wire fields", () => {
    const body = CompanyRegistrationRequestToJSON({
      companyName: "Proof Company",
      displayName: "Proof Admin",
      email: "proof@example.invalid",
      password: "Ali&7676",
    });

    expect(Object.keys(body).sort()).toEqual([
      "company_name",
      "display_name",
      "email",
      "password",
    ]);
    // The camelCase originals are what a strict model rejects.
    expect(body).not.toHaveProperty("companyName");
    expect(body).not.toHaveProperty("displayName");
    expect(body.company_name).toBe("Proof Company");
    expect(body.password).toBe("Ali&7676");
  });

  it("never emits a camelCase key on a snake_case model", () => {
    // A model without `additionalProperties: false` was always serialized
    // correctly; asserting it too keeps the contrast explicit.
    const body = CreateAssetRequestToJSON({
      areaId: "area-1",
      assetTag: "PSV-114",
      category: "valve",
      name: "Relief valve",
    } as Parameters<typeof CreateAssetRequestToJSON>[0]);

    for (const key of Object.keys(body)) {
      expect(key).not.toMatch(/[A-Z]/);
    }
    expect(body).toHaveProperty("area_id", "area-1");
    expect(body).toHaveProperty("asset_tag", "PSV-114");
  });
});
