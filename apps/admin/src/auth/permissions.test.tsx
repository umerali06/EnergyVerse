import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";

import { Can, createPermissionAccess, PermissionProvider } from "./permissions";

describe("permission access", () => {
  it("evaluates can, hasAny, and hasAll against an immutable sample", () => {
    const access = createPermissionAccess(["assets.read", "assets.write", "reports.read"]);

    expect(access.can("assets.write")).toBe(true);
    expect(access.can("users.manage")).toBe(false);
    expect(access.hasAny(["users.manage", "reports.read"])).toBe(true);
    expect(access.hasAny(["users.manage", "roles.manage"])).toBe(false);
    expect(access.hasAll(["assets.read", "assets.write"])).toBe(true);
    expect(access.hasAll(["assets.read", "users.manage"])).toBe(false);
  });

  it("renders the protected block for a role with permission", () => {
    const markup = renderToStaticMarkup(
      <PermissionProvider initialPermissions={["assets.write"]}>
        <Can permission="assets.write" fallback={<span>No access</span>}>
          <span>Protected asset action</span>
        </Can>
      </PermissionProvider>,
    );
    expect(markup).toContain("Protected asset action");
    expect(markup).not.toContain("No access");
  });

  it("renders the no-access state for a role without permission", () => {
    const markup = renderToStaticMarkup(
      <PermissionProvider initialPermissions={["assets.read"]}>
        <Can permission="assets.write" fallback={<span>No access</span>}>
          <span>Protected asset action</span>
        </Can>
      </PermissionProvider>,
    );
    expect(markup).toContain("No access");
    expect(markup).not.toContain("Protected asset action");
  });
});
