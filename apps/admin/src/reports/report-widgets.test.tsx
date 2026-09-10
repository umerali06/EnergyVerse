import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { SubscriptionProvider } from "@/billing/subscription-context";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { DashboardWidgetGrid } from "@/dashboard/widget-registry";

import "./report-widgets";

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

const mockPush = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: () => undefined, push: mockPush, replace: vi.fn() }),
}));

const session: AuthSession = {
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-company_admin",
};

class FakeGateway implements AuthGateway {
  async getIdToken() {
    return "id-token";
  }
  observe(listener: (value: AuthSession | null) => void) {
    listener(session);
    return () => undefined;
  }
  async refreshSession() {
    return session;
  }
  async sendEmailVerification() {}
  async sendPasswordResetEmail() {}
  async signIn() {
    return session;
  }
  async signOut() {}
}

function renderReportWidgets(getDashboardReportsSummary: ReturnType<typeof vi.fn>) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(["reports.read"]),
  };
  const apiClient = {
    registerCompanyAdmin: vi.fn(),
    getCurrentUser: vi.fn(async () => identity),
    getDashboardReportsSummary,
  };
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={new FakeGateway()}>
          <PermissionProvider initialPermissions={["reports.read"]}>
            <SubscriptionProvider initialSubscription={allFeatures}><DashboardWidgetGrid /></SubscriptionProvider>
          </PermissionProvider>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

beforeEach(() => {
  mockPush.mockClear();
});

describe("report dashboard widgets", () => {
  it("renders the real report count", async () => {
    renderReportWidgets(
      vi.fn(async () => ({
        total: 7,
        drafts: 2,
        finalized: 5,
      })),
    );
    await waitFor(() => expect(screen.getByText("7")).toBeInTheDocument());
    expect(screen.getByText("Reports generated")).toBeInTheDocument();
  });

  it("navigates to reports list when clicked", async () => {
    renderReportWidgets(
      vi.fn(async () => ({
        total: 7,
        drafts: 2,
        finalized: 5,
      })),
    );
    await waitFor(() => expect(screen.getByText("7")).toBeInTheDocument());
    await userEvent.setup().click(screen.getByText("Reports generated").closest("section")!);
    expect(mockPush).toHaveBeenCalledWith("/reports");
  });
});
