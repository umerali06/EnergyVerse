"use client";

import type { NotificationResponse } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { formatRelativeTime } from "@/dashboard/format";
import { Button, cn } from "@/design-system";

/** How often the bell re-checks for new notifications while the tab is open. */
const POLL_INTERVAL_MS = 60_000;

/** Where each notification target lives in the admin route table. The server
 * deliberately emits a target type and id rather than a URL, so each client
 * keeps its own routing. */
const ROUTES: Record<string, (id: string) => string> = {
  work_order: (id) => `/work-orders/${id}`,
  safety_report: (id) => `/safety?reportId=${id}`,
  permit: (id) => `/permits/${id}`,
  inspection: (id) => `/inspections/${id}`,
  report: (id) => `/reports/${id}`,
};

function BellIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden
      className={className}
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="1.8"
      viewBox="0 0 24 24"
    >
      <path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 0 1-3.4 0" />
    </svg>
  );
}

export function NotificationBell() {
  const { apiClient } = useAuth();
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [items, setItems] = useState<NotificationResponse[]>([]);
  const [unread, setUnread] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const page = await apiClient.listNotifications();
      setItems(page.items ?? []);
      setUnread(page.unreadCount ?? 0);
    } catch {
      // A failed poll must not blank an already-rendered list, so items are
      // left alone and only the error surfaces.
      setError("Notifications could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, [apiClient]);

  useEffect(() => {
    void load();
    const timer = window.setInterval(() => void load(), POLL_INTERVAL_MS);
    return () => window.clearInterval(timer);
  }, [load]);

  // Close on an outside click or Escape, the same affordances the rest of the
  // shell's popovers use.
  useEffect(() => {
    if (!open) return;
    function onPointerDown(event: MouseEvent) {
      if (!containerRef.current?.contains(event.target as Node)) setOpen(false);
    }
    function onKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onPointerDown);
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("mousedown", onPointerDown);
      document.removeEventListener("keydown", onKeyDown);
    };
  }, [open]);

  async function openNotification(notification: NotificationResponse) {
    setOpen(false);
    if (!notification.readAt) {
      // Optimistic: the badge should drop immediately, and a failed mark-read
      // is corrected by the next poll rather than blocking navigation.
      setItems((current) =>
        current.map((item) =>
          item.id === notification.id ? { ...item, readAt: new Date() } : item,
        ),
      );
      setUnread((count) => Math.max(0, count - 1));
      void apiClient.markNotificationRead(notification.id).catch(() => undefined);
    }
    const route = ROUTES[notification.targetType]?.(notification.targetId);
    if (route) router.push(route);
  }

  async function markAllRead() {
    setUnread(0);
    setItems((current) => current.map((item) => ({ ...item, readAt: item.readAt ?? new Date() })));
    try {
      await apiClient.markAllNotificationsRead();
    } catch {
      // Restore the true state rather than leaving a wrong badge.
      void load();
    }
  }

  return (
    <div className="relative" ref={containerRef}>
      <button
        aria-expanded={open}
        aria-haspopup="dialog"
        aria-label={unread > 0 ? `Notifications (${unread} unread)` : "Notifications"}
        className="relative rounded-lg p-2 text-text-secondary transition-colors hover:bg-elevated hover:text-text-primary"
        onClick={() => setOpen((value) => !value)}
        type="button"
      >
        <BellIcon className="size-5" />
        {unread > 0 && (
          <span
            aria-hidden
            className="absolute right-0.5 top-0.5 grid min-w-4 place-items-center rounded-full bg-accent-500 px-1 font-mono text-micro font-bold text-white"
          >
            {unread > 99 ? "99+" : unread}
          </span>
        )}
      </button>

      {open && (
        <div
          aria-label="Notifications"
          className="absolute right-0 z-dropdown mt-2 w-80 overflow-hidden rounded-xl border border-border bg-surface shadow-lg"
          role="dialog"
        >
          <div className="flex items-center justify-between border-b border-border px-4 py-3">
            <h2 className="text-bodySmall font-bold">Notifications</h2>
            {unread > 0 && (
              <button
                className="text-caption font-semibold text-primary-600 hover:underline dark:text-primary-400"
                onClick={() => void markAllRead()}
                type="button"
              >
                Mark all read
              </button>
            )}
          </div>

          <div className="max-h-96 overflow-y-auto">
            {error ? (
              <div className="p-4 text-center">
                <p className="text-bodySmall text-critical">{error}</p>
                <Button className="mt-3" onClick={() => void load()} variant="ghost">
                  Retry
                </Button>
              </div>
            ) : loading && items.length === 0 ? (
              <p className="p-4 text-center text-bodySmall text-text-muted">Loading…</p>
            ) : items.length === 0 ? (
              <p className="p-4 text-center text-bodySmall text-text-muted">
                You have no notifications.
              </p>
            ) : (
              <ul className="divide-y divide-border">
                {items.map((notification) => (
                  <li key={notification.id}>
                    <button
                      className={cn(
                        "w-full px-4 py-3 text-left transition-colors hover:bg-elevated",
                        !notification.readAt && "bg-elevated",
                      )}
                      onClick={() => void openNotification(notification)}
                      type="button"
                    >
                      <span className="flex items-start gap-2">
                        {!notification.readAt && (
                          <span
                            aria-label="Unread"
                            className="mt-1.5 size-2 shrink-0 rounded-full bg-accent-500"
                          />
                        )}
                        <span className="min-w-0">
                          <span className="block truncate text-bodySmall font-semibold">
                            {notification.title}
                          </span>
                          <span className="mt-0.5 block text-caption text-text-secondary">
                            {notification.body}
                          </span>
                          <span className="mt-1 block font-mono text-caption text-text-muted">
                            {formatRelativeTime(notification.createdAt)}
                          </span>
                        </span>
                      </span>
                    </button>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
