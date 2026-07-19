"use client";

import { usePathname, useRouter } from "next/navigation";
import {
  type KeyboardEvent as ReactKeyboardEvent,
  type MouseEvent as ReactMouseEvent,
  type ReactNode,
  useCallback,
  useEffect,
  useRef,
  useState,
} from "react";

import { useAuth } from "@/auth/auth-context";
import { usePermissions } from "@/auth/permissions";
import { Badge, Button, cn, MotionSection, ThemeSwitch, Tooltip } from "@/design-system";
import {
  findNavItem,
  isRouteActive,
  visibleNavGroups,
  type NavGroup,
} from "@/navigation/nav-config";

export const sidebarPreferenceKey = "fev.admin.sidebar-collapsed";

export type Viewport = "desktop" | "tablet" | "mobile";

/** Three-breakpoint viewport model: ≥1024 desktop, ≥768 tablet, else mobile. */
export function useViewport(): Viewport {
  const [viewport, setViewport] = useState<Viewport>("desktop");
  useEffect(() => {
    const desktopQuery = window.matchMedia("(min-width: 1024px)");
    const tabletQuery = window.matchMedia("(min-width: 768px)");
    const update = () => {
      setViewport(desktopQuery.matches ? "desktop" : tabletQuery.matches ? "tablet" : "mobile");
    };
    update();
    desktopQuery.addEventListener("change", update);
    tabletQuery.addEventListener("change", update);
    return () => {
      desktopQuery.removeEventListener("change", update);
      tabletQuery.removeEventListener("change", update);
    };
  }, []);
  return viewport;
}

function initialsFor(email: string): string {
  const name = email.split("@")[0];
  const parts = name.split(/[._-]+/).filter(Boolean);
  const first = parts[0]?.[0] ?? "?";
  const second = parts[1]?.[0] ?? name[1] ?? "";
  return `${first}${second}`.toUpperCase();
}

function displayNameFor(email: string): string {
  return email
    .split("@")[0]
    .replace(/[._-]+/g, " ")
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function NavList({
  groups,
  collapsed,
  pathname,
  onNavigate,
}: {
  groups: NavGroup[];
  collapsed: boolean;
  pathname: string;
  onNavigate: (route: string) => void;
}) {
  return (
    <nav aria-label="Primary" className="flex-1 overflow-y-auto px-3 pb-6">
      {groups.map((group) => (
        <div key={group.label} className="mt-5 first:mt-2">
          {!collapsed && (
            <p className="px-3 pb-2 font-mono text-caption uppercase tracking-[0.18em] text-text-muted">
              {group.label}
            </p>
          )}
          <ul className="grid gap-1">
            {group.items.map((item) => {
              const active = isRouteActive(item.route, pathname);
              const link = (
                <a
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "flex items-center gap-3 rounded-lg px-3 py-2 text-bodySmall font-semibold outline-none transition-colors",
                    "focus-visible:ring-2 focus-visible:ring-primary-400",
                    active
                      ? "bg-primary-500/15 text-primary-300"
                      : "text-text-secondary hover:bg-elevated hover:text-text-primary",
                    collapsed && "justify-center px-2",
                  )}
                  href={item.route}
                  onClick={(event: ReactMouseEvent<HTMLAnchorElement>) => {
                    event.preventDefault();
                    onNavigate(item.route);
                  }}
                >
                  {item.icon}
                  {!collapsed && <span className="truncate">{item.label}</span>}
                </a>
              );
              return (
                <li key={item.route}>
                  {collapsed ? <Tooltip content={item.label}>{link}</Tooltip> : link}
                </li>
              );
            })}
          </ul>
        </div>
      ))}
    </nav>
  );
}

function SidebarBrand({ collapsed }: { collapsed: boolean }) {
  return (
    <div
      className={cn("flex items-center gap-3 px-4 pb-4 pt-5", collapsed && "justify-center px-2")}
    >
      <span className="grid size-10 shrink-0 place-items-center rounded-xl bg-primary-500 font-mono text-h6 font-black text-white shadow-glow">
        F
      </span>
      {!collapsed && (
        <div className="min-w-0">
          <p className="truncate text-body font-bold tracking-tight">Flacron EnergyVerse</p>
          <p className="truncate text-caption uppercase tracking-[0.18em] text-text-muted">
            Field operations
          </p>
        </div>
      )}
    </div>
  );
}

function CollapseIcon({ collapsed }: { collapsed: boolean }) {
  return (
    <svg
      aria-hidden
      className={cn("size-4 transition-transform", collapsed && "rotate-180")}
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="2"
      viewBox="0 0 24 24"
    >
      <path d="M15 18l-6-6 6-6" />
    </svg>
  );
}

function Sidebar({
  groups,
  collapsed,
  canToggle,
  onToggle,
  pathname,
  onNavigate,
}: {
  groups: NavGroup[];
  collapsed: boolean;
  canToggle: boolean;
  onToggle: () => void;
  pathname: string;
  onNavigate: (route: string) => void;
}) {
  return (
    <aside
      className={cn(
        "flex h-screen shrink-0 flex-col border-r border-border bg-surface/80 transition-[width] duration-200 motion-reduce:transition-none",
        collapsed ? "w-[76px]" : "w-64",
      )}
      data-collapsed={collapsed}
      data-testid="app-sidebar"
    >
      <SidebarBrand collapsed={collapsed} />
      <NavList collapsed={collapsed} groups={groups} onNavigate={onNavigate} pathname={pathname} />
      {canToggle && (
        <div className={cn("border-t border-border p-3", collapsed && "flex justify-center")}>
          <button
            aria-expanded={!collapsed}
            aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
            className="flex w-full items-center justify-center gap-2 rounded-lg px-3 py-2 text-bodySmall font-semibold text-text-secondary outline-none transition-colors hover:bg-elevated hover:text-text-primary focus-visible:ring-2 focus-visible:ring-primary-400"
            onClick={onToggle}
            type="button"
          >
            <CollapseIcon collapsed={collapsed} />
            {!collapsed && <span>Collapse</span>}
          </button>
        </div>
      )}
    </aside>
  );
}

const focusableSelector =
  'a[href], button:not([disabled]), input:not([disabled]), select, textarea, [tabindex]:not([tabindex="-1"])';

function MobileDrawer({
  open,
  onClose,
  groups,
  pathname,
  onNavigate,
}: {
  open: boolean;
  onClose: () => void;
  groups: NavGroup[];
  pathname: string;
  onNavigate: (route: string) => void;
}) {
  const panelRef = useRef<HTMLDivElement>(null);
  const restoreFocusRef = useRef<HTMLElement | null>(null);

  useEffect(() => {
    if (!open) return;
    restoreFocusRef.current = document.activeElement as HTMLElement | null;
    const panel = panelRef.current;
    const first = panel?.querySelector<HTMLElement>(focusableSelector);
    first?.focus();
    return () => restoreFocusRef.current?.focus();
  }, [open]);

  function trapKeys(event: ReactKeyboardEvent<HTMLDivElement>) {
    if (event.key === "Escape") {
      event.stopPropagation();
      onClose();
      return;
    }
    if (event.key !== "Tab") return;
    const panel = panelRef.current;
    if (!panel) return;
    const focusable = [...panel.querySelectorAll<HTMLElement>(focusableSelector)];
    if (focusable.length === 0) return;
    const firstElement = focusable[0];
    const lastElement = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === firstElement) {
      event.preventDefault();
      lastElement.focus();
    } else if (!event.shiftKey && document.activeElement === lastElement) {
      event.preventDefault();
      firstElement.focus();
    }
  }

  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50" data-testid="mobile-drawer">
      <div
        aria-hidden
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        data-testid="drawer-overlay"
        onClick={onClose}
      />
      <div
        aria-label="Navigation menu"
        aria-modal="true"
        className="absolute inset-y-0 left-0 flex w-72 max-w-[85vw] translate-x-0 animate-none flex-col border-r border-border bg-surface shadow-xl transition-transform duration-200 motion-reduce:transition-none"
        onKeyDown={trapKeys}
        ref={panelRef}
        role="dialog"
      >
        <div className="flex items-center justify-between pr-3">
          <SidebarBrand collapsed={false} />
          <button
            aria-label="Close navigation menu"
            className="rounded-lg p-2 text-text-secondary outline-none hover:bg-elevated hover:text-text-primary focus-visible:ring-2 focus-visible:ring-primary-400"
            onClick={onClose}
            type="button"
          >
            <svg
              aria-hidden
              className="size-5"
              fill="none"
              stroke="currentColor"
              strokeLinecap="round"
              strokeWidth="2"
              viewBox="0 0 24 24"
            >
              <path d="M18 6 6 18M6 6l12 12" />
            </svg>
          </button>
        </div>
        <NavList collapsed={false} groups={groups} onNavigate={onNavigate} pathname={pathname} />
      </div>
    </div>
  );
}

function UserMenu() {
  const auth = useAuth();
  const [open, setOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);
  const user = auth.currentUser;

  useEffect(() => {
    if (!open) return;
    const closeOnOutsideClick = (event: MouseEvent) => {
      if (!menuRef.current?.contains(event.target as Node)) setOpen(false);
    };
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") setOpen(false);
    };
    document.addEventListener("mousedown", closeOnOutsideClick);
    document.addEventListener("keydown", closeOnEscape);
    return () => {
      document.removeEventListener("mousedown", closeOnOutsideClick);
      document.removeEventListener("keydown", closeOnEscape);
    };
  }, [open]);

  if (!user) return null;
  return (
    <div className="relative" ref={menuRef}>
      <button
        aria-expanded={open}
        aria-haspopup="menu"
        aria-label="User menu"
        className="grid size-10 place-items-center rounded-full bg-primary-500/20 font-mono text-bodySmall font-bold text-primary-300 outline-none ring-1 ring-border transition hover:ring-primary-400 focus-visible:ring-2 focus-visible:ring-primary-400"
        onClick={() => setOpen((value) => !value)}
        type="button"
      >
        {initialsFor(user.email)}
      </button>
      {open && (
        <div
          aria-label="User menu"
          className="absolute right-0 top-12 z-50 w-72 rounded-xl border border-border bg-surface p-4 shadow-xl"
          role="menu"
        >
          <p className="text-body font-bold">{displayNameFor(user.email)}</p>
          <p className="truncate text-bodySmall text-text-muted">{user.email}</p>
          <div className="mt-3 flex flex-wrap items-center gap-2">
            <Badge>{user.roleKey}</Badge>
            <span className="text-bodySmall text-text-secondary">{user.companyName}</span>
          </div>
          <div className="mt-4 grid gap-2 border-t border-border pt-3">
            <button
              className="rounded-lg px-3 py-2 text-left text-bodySmall font-semibold text-text-secondary outline-none hover:bg-elevated hover:text-text-primary focus-visible:ring-2 focus-visible:ring-primary-400"
              onClick={() => void auth.refreshSession()}
              role="menuitem"
              type="button"
            >
              Refresh session
            </button>
            <button
              className="rounded-lg px-3 py-2 text-left text-bodySmall font-semibold text-status-critical outline-none hover:bg-status-critical/10 focus-visible:ring-2 focus-visible:ring-primary-400"
              onClick={() => void auth.signOut()}
              role="menuitem"
              type="button"
            >
              Sign out
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function Header({
  pathname,
  onOpenDrawer,
  showMenuButton,
}: {
  pathname: string;
  onOpenDrawer: () => void;
  showMenuButton: boolean;
}) {
  const located = findNavItem(pathname);
  const title = located?.item.label ?? (pathname === "/" ? "Dashboard" : "Not found");
  return (
    <header className="flex items-center gap-3 border-b border-border bg-surface/60 px-4 py-3 md:px-6">
      {showMenuButton && (
        <button
          aria-label="Open navigation menu"
          className="rounded-lg p-2 text-text-secondary outline-none hover:bg-elevated hover:text-text-primary focus-visible:ring-2 focus-visible:ring-primary-400"
          onClick={onOpenDrawer}
          type="button"
        >
          <svg
            aria-hidden
            className="size-5"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeWidth="2"
            viewBox="0 0 24 24"
          >
            <path d="M3 6h18M3 12h18M3 18h18" />
          </svg>
        </button>
      )}
      <div className="min-w-0 flex-1">
        <nav aria-label="Breadcrumb" className="hidden text-caption text-text-muted sm:block">
          <ol className="flex gap-1">
            <li>FEV</li>
            {located && located.item.route !== "/" && (
              <li className="before:mx-1 before:content-['/']">{located.group.label}</li>
            )}
            <li
              aria-current="page"
              className="before:mx-1 before:content-['/'] text-text-secondary"
            >
              {title}
            </li>
          </ol>
        </nav>
        <h1 className="truncate text-h5 font-bold">{title}</h1>
      </div>
      <div className="hidden items-center md:flex">
        <label className="sr-only" htmlFor="global-search">
          Global search (coming in Phase 16)
        </label>
        <input
          className="w-48 cursor-not-allowed rounded-lg border border-border bg-elevated/60 px-3 py-2 text-bodySmall text-text-muted lg:w-64"
          disabled
          id="global-search"
          placeholder="Search — coming soon"
          title="Global search arrives with Phase 16"
          type="search"
        />
      </div>
      <Tooltip content="Notifications — coming soon (Phase 15)">
        <button
          aria-disabled="true"
          aria-label="Notifications (coming soon)"
          className="cursor-not-allowed rounded-lg p-2 text-text-muted"
          disabled
          type="button"
        >
          <svg
            aria-hidden
            className="size-5"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="1.8"
            viewBox="0 0 24 24"
          >
            <path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 0 1-3.4 0" />
          </svg>
        </button>
      </Tooltip>
      <ThemeSwitch />
      <UserMenu />
    </header>
  );
}

export function AppShell({
  children,
  reducedMotionOverride,
}: {
  children: ReactNode;
  reducedMotionOverride?: boolean;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const { can } = usePermissions();
  const viewport = useViewport();
  const [collapsedPreference, setCollapsedPreference] = useState(false);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const groups = visibleNavGroups(can);

  useEffect(() => {
    setCollapsedPreference(window.localStorage.getItem(sidebarPreferenceKey) === "true");
  }, []);

  // Tablet always shows the icon-only rail; the persisted preference applies
  // on desktop only.
  const collapsed = viewport === "tablet" || collapsedPreference;

  const toggleCollapsed = useCallback(() => {
    setCollapsedPreference((value) => {
      window.localStorage.setItem(sidebarPreferenceKey, String(!value));
      return !value;
    });
  }, []);

  const navigate = useCallback(
    (route: string) => {
      setDrawerOpen(false);
      router.push(route);
    },
    [router],
  );

  useEffect(() => {
    // Whatever caused the route to change, the drawer never outlives it.
    setDrawerOpen(false);
  }, [pathname]);

  return (
    <div className="flex min-h-screen bg-background text-text-primary" data-viewport={viewport}>
      <a
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-[60] focus:rounded-lg focus:bg-primary-500 focus:px-4 focus:py-2 focus:text-white"
        href="#main-content"
      >
        Skip to content
      </a>
      {viewport !== "mobile" && (
        <Sidebar
          canToggle={viewport === "desktop"}
          collapsed={collapsed}
          groups={groups}
          onNavigate={navigate}
          onToggle={toggleCollapsed}
          pathname={pathname}
        />
      )}
      {viewport === "mobile" && (
        <MobileDrawer
          groups={groups}
          onClose={() => setDrawerOpen(false)}
          onNavigate={navigate}
          open={drawerOpen}
          pathname={pathname}
        />
      )}
      <div className="flex min-h-screen min-w-0 flex-1 flex-col">
        <Header
          onOpenDrawer={() => setDrawerOpen(true)}
          pathname={pathname}
          showMenuButton={viewport === "mobile"}
        />
        <main className="flex-1 overflow-y-auto" id="main-content">
          <MotionSection
            key={pathname}
            className="h-full"
            reducedMotionOverride={reducedMotionOverride}
          >
            {children}
          </MotionSection>
        </main>
      </div>
    </div>
  );
}

export function ComingSoonScreen({ moduleName }: { moduleName: string }) {
  const router = useRouter();
  return (
    <section className="grid min-h-[60vh] place-items-center p-6">
      <div className="w-full max-w-lg rounded-2xl border border-border bg-surface/80 p-8 text-center">
        <p className="mx-auto w-fit rounded-full bg-primary-500/15 px-4 py-1 font-mono text-caption uppercase tracking-[0.2em] text-primary-300">
          On the roadmap
        </p>
        <h2 className="mt-5 text-h3 font-bold">{moduleName} is coming soon</h2>
        <p className="mt-3 text-body text-text-secondary">
          This module is planned and will be built in an upcoming phase. Nothing here is functional
          yet — no data has been faked.
        </p>
        <div className="mt-7">
          <Button onClick={() => router.push("/")} variant="ghost">
            Back to Dashboard
          </Button>
        </div>
      </div>
    </section>
  );
}

export function NotFoundScreen() {
  const router = useRouter();
  return (
    <section className="grid min-h-[60vh] place-items-center p-6">
      <div className="w-full max-w-lg rounded-2xl border border-border bg-surface/80 p-8 text-center">
        <p className="mx-auto w-fit rounded-full bg-status-critical/15 px-4 py-1 font-mono text-caption uppercase tracking-[0.2em] text-status-critical">
          404 — Not found
        </p>
        <h2 className="mt-5 text-h3 font-bold">This page doesn&apos;t exist</h2>
        <p className="mt-3 text-body text-text-secondary">
          Check the address, or head back to the dashboard.
        </p>
        <div className="mt-7">
          <Button onClick={() => router.push("/")} variant="ghost">
            Back to Dashboard
          </Button>
        </div>
      </div>
    </section>
  );
}
