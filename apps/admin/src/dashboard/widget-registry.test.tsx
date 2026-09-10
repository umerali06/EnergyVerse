import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it } from "vitest";

import { PermissionProvider } from "@/auth/permissions";
import { SubscriptionProvider } from "@/billing/subscription-context";

/** Fully-entitled plan: these cases are about permissions and rendering, not
 * billing. `useSubscription` fails closed without a provider (D-093). */
const allFeatures = {
  tier: "enterprise",
  planName: "Enterprise",
  status: "active",
  isEntitled: true,
  features: ["assets", "inspections", "reports", "safety_reports", "permits", "work_orders"],
  trialEndsAt: null,
  trialDaysRemaining: null,
  currentPeriodEnd: null,
  quotas: { facilities: null, assets: null, seats: null },
};

import {
  __resetWidgetRegistryForTests,
  DashboardWidgetGrid,
  registerWidget,
} from "./widget-registry";

function ThrowingWidget(): never {
  throw new Error("widget blew up");
}

beforeEach(() => {
  __resetWidgetRegistryForTests();
});

function renderGrid(subscriptionTier?: string, permissions: string[] = ["assets.read"]) {
  return render(
    <PermissionProvider initialPermissions={permissions}>
      <SubscriptionProvider initialSubscription={allFeatures}>
        <DashboardWidgetGrid subscriptionTier={subscriptionTier} />
      </SubscriptionProvider>
    </PermissionProvider>,
  );
}

describe("dashboard widget registry", () => {
  it("filters registered widgets by the viewer's permission, table-driven across roles", () => {
    registerWidget({
      id: "test.assets",
      title: "Assets widget",
      requiredPermission: "assets.read",
      size: "sm",
      render: () => <p>assets widget content</p>,
    });
    registerWidget({
      id: "test.work-orders",
      title: "Work orders widget",
      requiredPermission: "work_orders.read",
      size: "sm",
      render: () => <p>work orders widget content</p>,
    });

    const cases: Array<{ permissions: string[]; visible: string[]; hidden: string[] }> = [
      {
        permissions: ["assets.read"],
        visible: ["assets widget content"],
        hidden: ["work orders widget content"],
      },
      {
        permissions: ["work_orders.read"],
        visible: ["work orders widget content"],
        hidden: ["assets widget content"],
      },
      { permissions: [], visible: [], hidden: ["assets widget content", "work orders widget content"] },
    ];

    for (const testCase of cases) {
      const { unmount } = renderGrid(undefined, testCase.permissions);
      for (const text of testCase.visible) {
        expect(screen.getByText(text)).toBeInTheDocument();
      }
      for (const text of testCase.hidden) {
        expect(screen.queryByText(text)).not.toBeInTheDocument();
      }
      unmount();
    }
  });

  it("renders nothing when no registered widget is permitted", () => {
    registerWidget({
      id: "test.gated",
      title: "Gated widget",
      requiredPermission: "work_orders.read",
      size: "sm",
      render: () => <p>gated content</p>,
    });
    const { container } = renderGrid(undefined, ["assets.read"]);
    expect(container.querySelector('[data-testid="dashboard-widget-grid"]')).not.toBeInTheDocument();
  });

  it("hides a widget whose module the plan omits, even with the permission", () => {
    // The bug this guards: the work-order widget calls the gated
    // /api/v1/work-orders route, so on a plan without that module it rendered
    // and then failed with a 402 toast on the dashboard. Permission alone must
    // not be enough (D-093).
    registerWidget({
      id: "gated-work-orders",
      title: "Assigned work",
      requiredPermission: "work_orders.read",
      requiredFeature: "work_orders",
      size: "half",
      render: () => <p>work order widget</p>,
    });
    registerWidget({
      id: "ungated-assets",
      title: "Assets",
      requiredPermission: "assets.read",
      requiredFeature: "assets",
      size: "half",
      render: () => <p>asset widget</p>,
    });

    render(
      <PermissionProvider initialPermissions={["work_orders.read", "assets.read"]}>
        <SubscriptionProvider
          initialSubscription={{ ...allFeatures, features: ["assets"] }}
        >
          <DashboardWidgetGrid />
        </SubscriptionProvider>
      </PermissionProvider>,
    );

    expect(screen.queryByText("work order widget")).not.toBeInTheDocument();
    expect(screen.getByText("asset widget")).toBeInTheDocument();
  });

  it("renders no gated widget until the plan is known", () => {
    registerWidget({
      id: "pending-assets",
      title: "Assets",
      requiredPermission: "assets.read",
      requiredFeature: "assets",
      size: "half",
      render: () => <p>asset widget</p>,
    });

    render(
      <PermissionProvider initialPermissions={["assets.read"]}>
        <SubscriptionProvider initialSubscription={null}>
          <DashboardWidgetGrid />
        </SubscriptionProvider>
      </PermissionProvider>,
    );

    // Fails closed while loading rather than flashing a module the tenant may
    // not have.
    expect(screen.queryByText("asset widget")).not.toBeInTheDocument();
  });

  it("gates a widget by minimum subscription tier", () => {
    registerWidget({
      id: "test.enterprise-only",
      title: "Enterprise widget",
      requiredPermission: "assets.read",
      minTier: "enterprise",
      size: "sm",
      render: () => <p>enterprise-only content</p>,
    });

    const { unmount } = renderGrid("starter");
    expect(screen.queryByText("enterprise-only content")).not.toBeInTheDocument();
    unmount();

    renderGrid("enterprise");
    expect(screen.getByText("enterprise-only content")).toBeInTheDocument();
  });

  it("isolates a widget that throws during render, without breaking its siblings", () => {
    registerWidget({
      id: "test.throwing",
      title: "Broken widget",
      requiredPermission: "assets.read",
      size: "sm",
      render: () => <ThrowingWidget />,
    });
    registerWidget({
      id: "test.healthy",
      title: "Healthy widget",
      requiredPermission: "assets.read",
      size: "sm",
      render: () => <p>healthy widget content</p>,
    });

    renderGrid();
    expect(screen.getByText("Couldn't load this widget.")).toBeInTheDocument();
    expect(screen.getByText("healthy widget content")).toBeInTheDocument();
  });
});
