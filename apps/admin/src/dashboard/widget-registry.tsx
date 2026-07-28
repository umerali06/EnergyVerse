"use client";

import { Component, type ReactNode } from "react";

import { usePermissions } from "@/auth/permissions";
import { Card } from "@/design-system";

/**
 * The pluggable dashboard KPI widget framework (Phase 4.4, resolving the 2.3
 * deferral). A module registers a widget once via `registerWidget` -- the
 * dashboard grid below discovers it, gates it by permission (and tier, once
 * a future widget sets `minTier`), and isolates its failures so one bad
 * widget never blanks the rest of the dashboard. See ARCHITECTURE.md's
 * Phase 4.4 section for the "how to add a widget" contract.
 */

export type WidgetSize = "sm" | "md" | "lg";

// Mirrors `SUBSCRIPTION_TIERS` in apps/api/app/models/api.py -- kept as a
// small local constant rather than a generated type since no widget sets
// `minTier` yet; this is the hook, real enforcement lands in the billing
// phase.
export const SUBSCRIPTION_TIERS = ["demo", "starter", "professional", "enterprise"] as const;
export type SubscriptionTier = (typeof SUBSCRIPTION_TIERS)[number];

function tierMeetsMinimum(
  currentTier: string | undefined,
  minTier: SubscriptionTier | undefined,
): boolean {
  if (!minTier) return true;
  if (!currentTier) return false;
  const currentIndex = SUBSCRIPTION_TIERS.indexOf(currentTier as SubscriptionTier);
  const minIndex = SUBSCRIPTION_TIERS.indexOf(minTier);
  return currentIndex !== -1 && currentIndex >= minIndex;
}

export type DashboardWidget = {
  id: string;
  title: string;
  requiredPermission: string;
  /** Omitted = available at every subscription tier (true for every asset
   * widget today). */
  minTier?: SubscriptionTier;
  size: WidgetSize;
  render: () => ReactNode;
};

const registry: DashboardWidget[] = [];

/** Modules call this once at import time to register a widget. Registering
 * the same id twice is a no-op (keeps hot-reload / repeated imports safe). */
export function registerWidget(widget: DashboardWidget): void {
  if (registry.some((existing) => existing.id === widget.id)) return;
  registry.push(widget);
}

/** Test-only: clears the registry so each test file starts from a known
 * state instead of accumulating widgets registered by other test files'
 * side-effect imports. */
export function __resetWidgetRegistryForTests(): void {
  registry.length = 0;
}

export function getRegisteredWidgets(): readonly DashboardWidget[] {
  return registry;
}

type BoundaryState = { failed: boolean };

/** One widget throwing during render must not blank the rest of the
 * dashboard -- each widget gets its own boundary. */
class WidgetErrorBoundary extends Component<{ title: string; children: ReactNode }, BoundaryState> {
  state: BoundaryState = { failed: false };

  static getDerivedStateFromError(): BoundaryState {
    return { failed: true };
  }

  render(): ReactNode {
    if (this.state.failed) {
      return (
        <Card className="p-4" data-testid="widget-error">
          <p className="font-mono text-caption uppercase tracking-[0.16em] text-text-muted">
            {this.props.title}
          </p>
          <p className="mt-3 text-bodySmall font-semibold text-statusStrong-critical dark:text-statusSoft-critical">
            Couldn&apos;t load this widget.
          </p>
        </Card>
      );
    }
    return this.props.children;
  }
}

export function DashboardWidgetGrid({ subscriptionTier }: { subscriptionTier?: string }) {
  const { can } = usePermissions();
  const widgets = getRegisteredWidgets().filter(
    (widget) => can(widget.requiredPermission) && tierMeetsMinimum(subscriptionTier, widget.minTier),
  );
  if (widgets.length === 0) return null;
  return (
    <div className="grid gap-4" data-testid="dashboard-widget-grid">
      {widgets.map((widget) => (
        <WidgetErrorBoundary key={widget.id} title={widget.title}>
          {widget.render()}
        </WidgetErrorBoundary>
      ))}
    </div>
  );
}
