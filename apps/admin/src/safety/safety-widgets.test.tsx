import type { SafetyDashboardSummary } from "@fev/api-client";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { SubscriptionProvider } from "@/billing/subscription-context";
import { DashboardWidgetGrid } from "@/dashboard/widget-registry";
import { ThemeProvider, ToastProvider } from "@/design-system";

import "./safety-widgets";

/** Fully-entitled plan: these cases are about the widget, not billing.
 * `useSubscription` fails closed without a provider (D-093). */
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

const push = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ push }) }));

class ResizeObserverStub {
  observe() {}
  unobserve() {}
  disconnect() {}
}
vi.stubGlobal("ResizeObserver", ResizeObserverStub);
Object.defineProperty(HTMLElement.prototype, "getBoundingClientRect", {
  configurable: true,
  value: () => ({ width: 400, height: 280, top: 0, left: 0, bottom: 280, right: 400, x: 0, y: 0, toJSON() {} }),
});

const session: AuthSession = {
  email: "hse@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "hse",
};

class Gateway implements AuthGateway {
  async getIdToken() { return "token"; }
  observe(listener: (value: AuthSession | null) => void) { listener(session); return () => undefined; }
  async refreshSession() { return session; }
  async sendEmailVerification() {}
  async sendPasswordResetEmail() {}
  async signIn() { return session; }
  async signOut() {}
}

function renderWidgets(summary: SafetyDashboardSummary) {
  const identity = {
    uid: "hse", email: session.email ?? "hse@acme.example.invalid", emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy", roleKey: "hse_manager", permissions: new Set(["safety.read"]),
  };
  return render(
    <ThemeProvider><ToastProvider>
      <AuthProvider apiClient={{ registerCompanyAdmin: vi.fn(), getCurrentUser: vi.fn(async () => identity), getDashboardSafetySummary: vi.fn(async () => summary) }} gateway={new Gateway()}>
        <PermissionProvider initialPermissions={["safety.read"]}><SubscriptionProvider initialSubscription={allFeatures}><DashboardWidgetGrid /></SubscriptionProvider></PermissionProvider>
      </AuthProvider>
    </ToastProvider></ThemeProvider>,
  );
}

beforeEach(() => push.mockClear());

describe("safety dashboard widgets", () => {
  it("renders the real total and category chart", async () => {
    renderWidgets({ total: 3, byCategory: [{ category: "gas_leak", count: 2 }, { category: "injury", count: 1 }] });
    await waitFor(() => expect(screen.getByText("3")).toBeInTheDocument());
    expect(screen.getByText("Safety incidents by type")).toBeInTheDocument();
  });

  it("shows an honest empty chart for a zero-report tenant", async () => {
    renderWidgets({ total: 0, byCategory: [] });
    expect(await screen.findByText("No safety incidents to chart")).toBeInTheDocument();
  });

  it("opens the safety report list from the KPI", async () => {
    renderWidgets({ total: 7, byCategory: [] });
    await userEvent.setup().click(await screen.findByText("7"));
    expect(push).toHaveBeenCalledWith("/safety");
  });
});
