import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Users");

import { RequirePermission } from "@/auth/route-guards";
import { UsersPage } from "@/users/users-page";

export default function UsersRoute() {
  return (
    <RequirePermission permission="users.manage">
      <UsersPage />
    </RequirePermission>
  );
}
