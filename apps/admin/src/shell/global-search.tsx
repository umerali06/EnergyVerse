"use client";

import { usePathname, useRouter } from "next/navigation";
import { type KeyboardEvent, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Badge, cn, StatusPill, type StatusTone } from "@/design-system";

export type SearchResultCategory =
  | "assets"
  | "work-orders"
  | "permits"
  | "inspections"
  | "safety"
  | "reports"
  | "users"
  | "facilities"
  | "qr";

export interface SearchResultItem {
  id: string;
  category: SearchResultCategory;
  title: string;
  subtitle: string;
  route: string;
  badge?: string;
  statusTone?: StatusTone;
  statusLabel?: string;
}

function CategoryIcon({ category }: { category: SearchResultCategory }) {
  switch (category) {
    case "assets":
      return (
        <svg className="size-4 shrink-0 text-primary-400" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16zM3.3 7.3 12 12.3l8.7-5M12 22V12" />
        </svg>
      );
    case "work-orders":
      return (
        <svg className="size-4 shrink-0 text-status-warning" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M14.7 6.3a4 4 0 0 0-5.4 5.4L3 18v3h3l6.3-6.3a4 4 0 0 0 5.4-5.4l-2.8 2.8-2.1-2.1 2.9-2.7z" />
        </svg>
      );
    case "permits":
      return (
        <svg className="size-4 shrink-0 text-accent-400" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M9 12h6M9 16h6M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9l-7-7zM13 2v7h7" />
        </svg>
      );
    case "inspections":
      return (
        <svg className="size-4 shrink-0 text-status-success" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M9 11l3 3 8-8M21 12v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h11" />
        </svg>
      );
    case "safety":
      return (
        <svg className="size-4 shrink-0 text-status-critical" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10zM9 12l2 2 4-4" />
        </svg>
      );
    case "reports":
      return (
        <svg className="size-4 shrink-0 text-primary-300" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M3 3v18h18M8 17v-6m4 6V7m4 10v-4" />
        </svg>
      );
    case "users":
      return (
        <svg className="size-4 shrink-0 text-status-info" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M17 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      );
    case "facilities":
      return (
        <svg className="size-4 shrink-0 text-primary-500" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M12 2 2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
        </svg>
      );
    case "qr":
      return (
        <svg className="size-4 shrink-0 text-accent-500" fill="none" stroke="currentColor" strokeWidth="1.8" viewBox="0 0 24 24">
          <path d="M3 3h7v7H3zM14 3h7v7h-7zM3 14h7v7H3zM14 14h3v3h-3zM18 18h3v3h-3z" />
        </svg>
      );
  }
}

export function GlobalSearch() {
  const router = useRouter();
  const pathname = usePathname();
  const { apiClient } = useAuth();

  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [loading, setLoading] = useState(false);
  const [results, setResults] = useState<SearchResultItem[]>([]);
  const [selectedIndex, setSelectedIndex] = useState(0);

  const inputRef = useRef<HTMLInputElement>(null);

  // Keyboard shortcut (Ctrl+K or Cmd+K or '/')
  useEffect(() => {
    const handleKeyDown = (e: globalThis.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setOpen((prev) => !prev);
      } else if (e.key === "Escape" && open) {
        setOpen(false);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [open]);

  // Focus input when modal opens
  useEffect(() => {
    if (open) {
      setTimeout(() => inputRef.current?.focus(), 50);
    } else {
      setQuery("");
      setResults([]);
    }
  }, [open]);

  // Auto-close on route change
  useEffect(() => {
    setOpen(false);
  }, [pathname]);

  // Perform search across tenant modules
  useEffect(() => {
    if (!query.trim()) {
      // Default quick navigation links when query is empty
      setResults([
        {
          id: "quick-assets",
          category: "assets",
          title: "Asset Inventory",
          subtitle: "Browse facility assets, critical status & QR tags",
          route: "/assets",
          badge: "Module",
        },
        {
          id: "quick-3d-twin",
          category: "facilities",
          title: "3D Digital Twin View",
          subtitle: "Interactive 3D spatial visualization & facility hotspots",
          route: "/digital-twin",
          badge: "3D View",
        },
        {
          id: "quick-work-orders",
          category: "work-orders",
          title: "Work Orders",
          subtitle: "Maintenance tasks, assigned technicians & reviews",
          route: "/work-orders",
          badge: "Module",
        },
        {
          id: "quick-permits",
          category: "permits",
          title: "Permit-to-Work (PTW)",
          subtitle: "Hazardous work permits, risk matrix & approvals",
          route: "/permits",
          badge: "Module",
        },
        {
          id: "quick-inspections",
          category: "inspections",
          title: "Field Inspections",
          subtitle: "Checklist runs, inspector findings & compliance",
          route: "/inspections",
          badge: "Module",
        },
        {
          id: "quick-safety",
          category: "safety",
          title: "Safety & Incident Log",
          subtitle: "Near-miss events, environmental hazards & HSE actions",
          route: "/safety",
          badge: "Module",
        },
        {
          id: "quick-reports",
          category: "reports",
          title: "AI Advisory Reports",
          subtitle: "Generated inspection reports, PDF/Word/Excel exports",
          route: "/reports",
          badge: "AI Reports",
        },
        {
          id: "quick-users",
          category: "users",
          title: "Users & Team Directory",
          subtitle: "Manage company members, roles & permissions",
          route: "/users",
          badge: "Admin",
        },
      ]);
      setSelectedIndex(0);
      return;
    }

    let active = true;
    const term = query.trim().toLowerCase();

    async function executeSearch() {
      setLoading(true);
      try {
        const found: SearchResultItem[] = [];

        // 1. Search Assets. A QR code is not a record of its own -- it is a
        // label printed for an asset -- so scanning or typing one resolves to
        // that asset, surfaced as its own hit so the searcher sees why it
        // matched. `search` covers name/tag; the QR pass below covers codes,
        // which the server-side search does not index.
        try {
          const [res, byCode] = await Promise.all([
            apiClient.listAssets({ search: term, limit: 10 }),
            apiClient.listAssets({ limit: 100 }).catch(() => ({ items: [] })),
          ]);

          for (const item of byCode.items) {
            if (!item.qrCodeId || !item.qrCodeId.toLowerCase().includes(term)) continue;
            found.push({
              id: `qr-${item.id}`,
              category: "qr",
              title: `QR ${item.qrCodeId}`,
              subtitle: `Resolves to ${item.name} (${item.assetTag})`,
              route: `/assets/${item.id}`,
              badge: "QR label",
            });
          }

          for (const item of res.items) {
            const tone: StatusTone =
              item.currentStatus === "Critical"
                ? "critical"
                : item.currentStatus === "Warning"
                  ? "warning"
                  : "healthy";
            found.push({
              id: `asset-${item.id}`,
              category: "assets",
              title: item.name,
              // Open the asset itself rather than a filtered list -- the
              // searcher already told us which one they meant.
              route: `/assets/${item.id}`,
              subtitle: `Tag: ${item.assetTag} · Category: ${item.category}`,
              statusTone: tone,
              statusLabel: item.currentStatus,
            });
          }
        } catch {
          // Ignore API error in partial search
        }

        // 2. Search Work Orders
        try {
          const res = await apiClient.listWorkOrders({ limit: 10 });
          for (const item of res.items) {
            if (
              item.title.toLowerCase().includes(term) ||
              item.id.toLowerCase().includes(term) ||
              item.status.toLowerCase().includes(term)
            ) {
              const tone: StatusTone =
                item.status === "in_progress"
                  ? "warning"
                  : item.status === "closed"
                    ? "healthy"
                    : "info";
              found.push({
                id: `wo-${item.id}`,
                category: "work-orders",
                title: item.title,
                subtitle: `Work Order · Status: ${item.status}`,
                route: `/work-orders/${item.id}`,
                statusTone: tone,
                statusLabel: item.status,
              });
            }
          }
        } catch {
          // Ignore
        }

        // 3. Search Permits
        try {
          const res = await apiClient.listPermits({ limit: 10 });
          for (const item of res.items) {
            if (
              item.permitType.toLowerCase().includes(term) ||
              item.id.toLowerCase().includes(term) ||
              item.status.toLowerCase().includes(term)
            ) {
              found.push({
                id: `permit-${item.id}`,
                category: "permits",
                title: `${item.permitType.toUpperCase()} Permit`,
                subtitle: `Permit ID: ${item.id} · Status: ${item.status}`,
                route: `/permits/${item.id}`,
                badge: item.status,
              });
            }
          }
        } catch {
          // Ignore
        }

        // 4. Search Users
        try {
          const res = await apiClient.listUsers({ search: term, limit: 10 });
          for (const item of res.items) {
            found.push({
              id: `user-${item.id}`,
              category: "users",
              title: item.displayName || item.email,
              subtitle: `Role: ${item.roleKey} · ${item.email}`,
              route: `/users`,
              badge: item.roleKey,
            });
          }
        } catch {
          // Ignore
        }

        // 5. Search Inspections
        try {
          const res = await apiClient.listInspections({ limit: 10 });
          for (const item of res.items) {
            const haystack = `${item.title ?? ""} ${item.id} ${item.status}`.toLowerCase();
            if (!haystack.includes(term)) continue;
            found.push({
              id: `inspection-${item.id}`,
              category: "inspections",
              title: item.title ?? "Inspection",
              subtitle: `Inspection · Status: ${item.status}`,
              route: `/inspections/${item.id}`,
              badge: item.inspectionType,
            });
          }
        } catch {
          // Ignore
        }

        // 6. Search Safety Reports
        try {
          const res = await apiClient.listSafetyReports({ limit: 10 });
          for (const item of res.items) {
            const haystack = `${item.title} ${item.id} ${item.category} ${item.status}`.toLowerCase();
            if (!haystack.includes(term)) continue;
            const tone: StatusTone =
              item.severity === "critical"
                ? "critical"
                : item.severity === "high"
                  ? "warning"
                  : "info";
            found.push({
              id: `safety-${item.id}`,
              category: "safety",
              title: item.title,
              subtitle: `Safety · ${item.category.replace(/_/g, " ")}`,
              // The safety page has no route of its own per report, so the id
              // travels as a parameter the page opens on arrival.
              route: `/safety?reportId=${encodeURIComponent(item.id)}`,
              statusTone: tone,
              statusLabel: item.severity,
            });
          }
        } catch {
          // Ignore
        }

        // 7. Search Reports
        try {
          const res = await apiClient.listGeneratedReports({ limit: 10 });
          for (const item of res.items) {
            const haystack = `${item.title} ${item.id} ${item.reportType} ${item.status}`.toLowerCase();
            if (!haystack.includes(term)) continue;
            found.push({
              id: `report-${item.id}`,
              category: "reports",
              title: item.title,
              subtitle: `Report · ${item.reportType.replace(/_/g, " ")}`,
              route: `/reports/${item.id}`,
              badge: item.status,
            });
          }
        } catch {
          // Ignore
        }

        // 8. Search Facilities
        try {
          const res = await apiClient.listFacilities({ search: term, limit: 5 });
          for (const item of res.items) {
            found.push({
              id: `facility-${item.id}`,
              category: "facilities",
              title: item.name,
              subtitle: `Facility · Status: ${item.status}`,
              route: `/digital-twin`,
              badge: "3D Facility",
            });
          }
        } catch {
          // Ignore
        }

        if (active) {
          setResults(found);
          setSelectedIndex(0);
        }
      } finally {
        if (active) setLoading(false);
      }
    }

    const timer = setTimeout(executeSearch, 150);
    return () => {
      active = false;
      clearTimeout(timer);
    };
  }, [query, apiClient]);

  function handleSelect(item: SearchResultItem) {
    setOpen(false);
    router.push(item.route);
  }

  function handleKeyDown(e: KeyboardEvent<HTMLDivElement>) {
    if (e.key === "ArrowDown") {
      e.preventDefault();
      setSelectedIndex((prev) => (prev + 1) % Math.max(1, results.length));
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      setSelectedIndex((prev) => (prev - 1 + results.length) % Math.max(1, results.length));
    } else if (e.key === "Enter" && results[selectedIndex]) {
      e.preventDefault();
      handleSelect(results[selectedIndex]);
    }
  }

  return (
    <>
      {/* Header Search Button Bar */}
      <div className="relative flex items-center">
        <button
          aria-label="Open global search (Ctrl+K)"
          className="flex w-48 items-center justify-between rounded-lg border border-border bg-elevated/70 px-3 py-1.5 text-bodySmall text-text-muted transition hover:border-primary-400/60 hover:bg-elevated hover:text-text-primary lg:w-64"
          onClick={() => setOpen(true)}
          type="button"
        >
          <span className="flex items-center gap-2">
            <svg className="size-4 text-text-muted" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
              <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <span className="truncate font-sans">Search system…</span>
          </span>
          <kbd className="hidden rounded border border-border bg-surface px-1.5 py-0.5 font-mono text-[10px] font-semibold tracking-wider text-text-muted sm:inline-block">
            ⌘K
          </kbd>
        </button>
      </div>

      {/* Global Command Palette Overlay Modal */}
      {open && (
        <div className="fixed inset-0 z-50 flex items-start justify-center bg-black/60 p-4 pt-16 backdrop-blur-sm md:pt-24" data-testid="global-search-modal">
          <div
            aria-hidden
            className="fixed inset-0"
            onClick={() => setOpen(false)}
          />
          <div
            aria-label="Global search command palette"
            aria-modal="true"
            className="relative z-10 w-full max-w-2xl overflow-hidden rounded-2xl border border-border bg-surface shadow-2xl backdrop-blur-xl"
            onKeyDown={handleKeyDown}
            role="dialog"
          >
            {/* Search Input Bar */}
            <div className="flex items-center gap-3 border-b border-border px-4 py-3">
              <svg className="size-5 shrink-0 text-primary-400" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
                <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
              <input
                aria-label="Search"
                className="w-full bg-transparent font-sans text-body text-text-primary placeholder:text-text-muted focus:outline-none"
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search assets, inspections, work orders, permits, safety, reports, users, QR..."
                ref={inputRef}
                type="search"
                value={query}
              />
              {loading ? (
                <span className="size-4 animate-spin rounded-full border-2 border-primary-400 border-r-transparent" />
              ) : query ? (
                <button
                  aria-label="Clear query"
                  className="rounded p-1 text-text-muted hover:text-text-primary"
                  onClick={() => setQuery("")}
                  type="button"
                >
                  ✕
                </button>
              ) : (
                <kbd className="rounded border border-border bg-elevated px-2 py-0.5 font-mono text-micro font-semibold text-text-muted">
                  ESC
                </kbd>
              )}
            </div>

            {/* Results List */}
            <div className="max-h-[60vh] overflow-y-auto p-2 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
              {results.length === 0 && !loading && (
                <div className="p-8 text-center text-text-muted">
                  <p className="text-body font-semibold">No matching records found</p>
                  <p className="mt-1 text-bodySmall">Try searching by tag, name, title, or permit type.</p>
                </div>
              )}

              {results.map((item, index) => {
                const selected = index === selectedIndex;
                return (
                  <button
                    key={item.id}
                    className={cn(
                      "flex w-full items-center justify-between gap-4 rounded-xl px-3.5 py-2.5 text-left transition-colors",
                      selected
                        ? "bg-primary-500/15 text-text-primary"
                        : "hover:bg-elevated/70 text-text-secondary hover:text-text-primary",
                    )}
                    onClick={() => handleSelect(item)}
                    onMouseEnter={() => setSelectedIndex(index)}
                    type="button"
                  >
                    <div className="flex items-center gap-3 min-w-0 flex-1">
                      <div className="grid size-8 shrink-0 place-items-center rounded-lg border border-border/80 bg-elevated/80">
                        <CategoryIcon category={item.category} />
                      </div>
                      <div className="min-w-0 flex-1">
                        <p className="truncate text-bodySmall font-semibold text-text-primary">
                          {item.title}
                        </p>
                        <p className="truncate text-caption text-text-muted">
                          {item.subtitle}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 shrink-0">
                      {item.statusTone && item.statusLabel && (
                        <StatusPill tone={item.statusTone}>{item.statusLabel}</StatusPill>
                      )}
                      {item.badge && <Badge>{item.badge}</Badge>}
                      <span className="font-mono text-micro text-text-muted">↵</span>
                    </div>
                  </button>
                );
              })}
            </div>

            {/* Modal Footer */}
            <div className="flex items-center justify-between border-t border-border bg-elevated/40 px-4 py-2 font-mono text-micro text-text-muted">
              <span>
                Use <kbd className="rounded border border-border bg-surface px-1">↑</kbd> <kbd className="rounded border border-border bg-surface px-1">↓</kbd> to navigate
              </span>
              <span>
                Press <kbd className="rounded border border-border bg-surface px-1">Enter ↵</kbd> to open
              </span>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
