import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it } from "vitest";

import { PermissionProvider } from "@/auth/permissions";

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
      <DashboardWidgetGrid subscriptionTier={subscriptionTier} />
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
