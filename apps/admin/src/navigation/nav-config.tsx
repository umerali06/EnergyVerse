import type { ReactNode } from "react";

/**
 * Single source of truth for the application shell navigation.
 *
 * The mobile app mirrors this contract in
 * apps/mobile/lib/navigation/nav_config.dart — same items, same routes, same
 * `requiredPermission` keys from the Phase 0.4 catalog. Change them together.
 * Exception (Phase 3.5, D-030): the "Platform" group/item is admin-web-only,
 * deliberately not mirrored on mobile — platform administration is a desk
 * task, same reasoning as the 3.1/3.2 (D-023/D-026) mobile-read-only-scope
 * precedent, just extended to a whole module rather than a subset of actions.
 *
 * `requiredPermission` is filtered through the Phase 0.6 `can()` helper with
 * the authoritative permissions from `/api/v1/auth/me`. Items without a
 * permission (Dashboard, Documents — no `documents.*` key exists in the 0.4
 * catalog) are visible to every authenticated user. Visibility is UX only:
 * FastAPI's require_permission stays the security boundary.
 */
export type NavItem = {
  label: string;
  icon: ReactNode;
  route: string;
  requiredPermission?: string;
  /** Module exists on the roadmap but its screen is not built yet. */
  comingSoon?: boolean;
};

export type NavGroup = {
  label: string;
  items: NavItem[];
};

function GlyphIcon({ path }: { path: string }) {
  return (
    <svg
      aria-hidden
      className="size-5 shrink-0"
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="1.7"
      viewBox="0 0 24 24"
    >
      <path d={path} />
    </svg>
  );
}

export const navIcons = {
  dashboard: <GlyphIcon path="M3 13h8V3H3v10zm10 8h8V11h-8v10zM3 21h8v-6H3v6zm10-12h8V3h-8v6z" />,
  assets: (
    <GlyphIcon path="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16zM3.3 7.3 12 12.3l8.7-5M12 22V12" />
  ),
  inspections: (
    <GlyphIcon path="M9 11l3 3 8-8M21 12v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h11" />
  ),
  workOrders: (
    <GlyphIcon path="M14.7 6.3a4 4 0 0 0-5.4 5.4L3 18v3h3l6.3-6.3a4 4 0 0 0 5.4-5.4l-2.8 2.8-2.1-2.1 2.9-2.7z" />
  ),
  permits: (
    <GlyphIcon path="M9 12h6M9 16h6M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9l-7-7zM13 2v7h7" />
  ),
  safety: <GlyphIcon path="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10zM9 12l2 2 4-4" />,
  reports: <GlyphIcon path="M3 3v18h18M8 17v-6m4 6V7m4 10v-4" />,
  documents: (
    <GlyphIcon path="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zM14 2v6h6M8 13h8M8 17h5" />
  ),
  settings: (
    <GlyphIcon path="M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM19.4 15a1.7 1.7 0 0 0 .34 1.87l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.7 1.7 0 0 0-1.87-.34 1.7 1.7 0 0 0-1 1.55V21a2 2 0 1 1-4 0v-.09a1.7 1.7 0 0 0-1-1.55 1.7 1.7 0 0 0-1.87.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.7 1.7 0 0 0 .34-1.87 1.7 1.7 0 0 0-1.55-1H3a2 2 0 1 1 0-4h.09a1.7 1.7 0 0 0 1.55-1 1.7 1.7 0 0 0-.34-1.87l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.7 1.7 0 0 0 1.87.34h0a1.7 1.7 0 0 0 1-1.55V3a2 2 0 1 1 4 0v.09a1.7 1.7 0 0 0 1 1.55h0a1.7 1.7 0 0 0 1.87-.34l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.7 1.7 0 0 0-.34 1.87v0a1.7 1.7 0 0 0 1.55 1H21a2 2 0 1 1 0 4h-.09a1.7 1.7 0 0 0-1.55 1z" />
  ),
  users: (
    <GlyphIcon path="M17 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
  ),
  roles: (
    <GlyphIcon path="M12 2 3 6v6c0 5 3.8 8.4 9 10 5.2-1.6 9-5 9-10V6l-9-4zM9 12l2 2 4-4" />
  ),
  audit: (
    <GlyphIcon path="M9 3h6a1 1 0 0 1 1 1v1h1a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h1V4a1 1 0 0 1 1-1zM8 12h8M8 16h5M9 9h6" />
  ),
  platform: (
    <GlyphIcon path="M12 2 2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
  ),
} as const;

export const navGroups: readonly NavGroup[] = [
  {
    label: "Overview",
    items: [{ label: "Dashboard", icon: navIcons.dashboard, route: "/" }],
  },
  {
    label: "Operations",
    items: [
      {
        label: "Assets",
        icon: navIcons.assets,
        route: "/assets",
        requiredPermission: "assets.read",
        comingSoon: true,
      },
      {
        label: "Inspections",
        icon: navIcons.inspections,
        route: "/inspections",
        requiredPermission: "inspections.read",
        comingSoon: true,
      },
      {
        label: "Work Orders",
        icon: navIcons.workOrders,
        route: "/work-orders",
        requiredPermission: "work_orders.read",
        comingSoon: true,
      },
      {
        label: "Permits",
        icon: navIcons.permits,
        route: "/permits",
        requiredPermission: "permits.read",
        comingSoon: true,
      },
    ],
  },
  {
    label: "Safety & Insights",
    items: [
      {
        label: "Safety",
        icon: navIcons.safety,
        route: "/safety",
        requiredPermission: "safety.read",
        comingSoon: true,
      },
      {
        label: "Reports",
        icon: navIcons.reports,
        route: "/reports",
        requiredPermission: "reports.read",
        comingSoon: true,
      },
      {
        label: "Documents",
        icon: navIcons.documents,
        route: "/documents",
        comingSoon: true,
      },
    ],
  },
  {
    label: "Administration",
    items: [
      {
        label: "Users",
        icon: navIcons.users,
        route: "/users",
        requiredPermission: "users.manage",
      },
      {
        label: "Roles",
        icon: navIcons.roles,
        route: "/roles",
        requiredPermission: "roles.manage",
      },
      {
        label: "Admin & Settings",
        icon: navIcons.settings,
        route: "/settings",
        requiredPermission: "company.settings",
      },
      {
        label: "Audit Log",
        icon: navIcons.audit,
        route: "/audit",
        requiredPermission: "audit.read",
      },
    ],
  },
  {
    // A separate group (not folded into Administration) so a super_admin
    // always sees the platform/tenant boundary visually, even before the
    // page itself renders its own "Platform" badge (D-030).
    label: "Platform",
    items: [
      {
        label: "Platform Admin",
        icon: navIcons.platform,
        route: "/platform",
        requiredPermission: "platform.admin",
      },
    ],
  },
];

/** Filters the nav to what the current permission set may see; empty groups drop. */
export function visibleNavGroups(can: (permission: string) => boolean): NavGroup[] {
  return navGroups
    .map((group) => ({
      ...group,
      items: group.items.filter((item) => !item.requiredPermission || can(item.requiredPermission)),
    }))
    .filter((group) => group.items.length > 0);
}

export function findNavItem(pathname: string): { group: NavGroup; item: NavItem } | null {
  for (const group of navGroups) {
    for (const item of group.items) {
      if (item.route === pathname) return { group, item };
    }
  }
  return null;
}

export function isRouteActive(itemRoute: string, pathname: string): boolean {
  if (itemRoute === "/") return pathname === "/";
  return pathname === itemRoute || pathname.startsWith(`${itemRoute}/`);
}
