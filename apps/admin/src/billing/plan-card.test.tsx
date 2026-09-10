import { render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { visibleNavGroups } from "@/navigation/nav-config";

import { PlanCard } from "./plan-card";
import { SubscriptionProvider, useSubscription } from "./subscription-context";

vi.mock("next/navigation", () => ({
  usePathname: () => "/dashboard",
  useSearchParams: () => new URLSearchParams(),
  useRouter: () => ({
    back: () => undefined,
    prefetch: () => undefined,
    push: () => undefined,
    replace: () => undefined,
  }),
}));

const session: AuthSession = {
  uid: "firebase-uid",
  email: "admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: async () => "id-token",
};

const identity = {
  uid: "firebase-uid",
  email: "admin@acme.example.invalid",
  emailVerified: true,
  companyId: "cmp_acme",
  companyName: "Acme Energy",
  roleKey: "company_admin",
  permissions: new Set(["company.settings"]),
};

/** Typed explicitly so cases can override a field with null — inference from
 * the literal would otherwise fix `trialDaysRemaining` to `number` and the
 * quotas to non-null. */
type SubscriptionFixture = {
  tier: string;
  planName: string | null;
  status: string;
  isEntitled: boolean;
  features: string[];
  trialEndsAt: Date | null;
  trialDaysRemaining: number | null;
  currentPeriodEnd: Date | null;
  quotas: {
    facilities: number | null;
    assets: number | null;
    seats: number | null;
  };
};

const operations: SubscriptionFixture = {
  tier: "operations",
  planName: "Operations",
  status: "trialing",
  isEntitled: true,
  features: ["assets", "inspections", "work_orders", "permits"],
  trialEndsAt: null,
  trialDaysRemaining: 7,
  currentPeriodEnd: null,
  quotas: { facilities: 5, assets: 2_500, seats: 75 },
};

function gateway(): AuthGateway {
  return {
    getIdToken: async () => "id-token",
    observe: (listener) => {
      listener(session);
      return () => undefined;
    },
    refreshSession: async () => session,
    sendEmailVerification: async () => undefined,
    sendPasswordResetEmail: async () => undefined,
    signIn: async () => session,
    signOut: async () => undefined,
  } as AuthGateway;
}

function renderWith(
  node: React.ReactNode,
  {
    subscription,
    getSubscription,
  }: {
    subscription?: SubscriptionFixture | null;
    getSubscription?: ReturnType<typeof vi.fn>;
  } = {},
) {
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider
          apiClient={{
            getCurrentUser: vi.fn(async () => identity),
            registerCompanyAdmin: vi.fn(),
            getSubscription: getSubscription ?? vi.fn(async () => operations),
            getBillingCatalog: vi.fn(),
            createCheckoutSession: vi.fn(),
          }}
          gateway={gateway()}
        >
          <SubscriptionProvider
            initialSubscription={subscription === undefined ? operations : subscription}
          >
            {node}
          </SubscriptionProvider>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

/** Surfaces the context so the gate can be asserted directly. */
function FeatureProbe({ feature }: { feature: string | undefined }) {
  const { hasFeature, status } = useSubscription();
  return <span data-status={status}>{String(hasFeature(feature))}</span>;
}

describe("plan card", () => {
  it("names the plan, its status, and the trial time left", () => {
    renderWith(<PlanCard seatsUsed={12} />);

    expect(screen.getByText("Operations")).toBeInTheDocument();
    expect(screen.getByText("Trial")).toBeInTheDocument();
    expect(screen.getByText("7 days left on your trial.")).toBeInTheDocument();
  });

  it("shows usage against each quota, and says unlimited rather than showing an empty bar", () => {
    renderWith(<PlanCard assetsUsed={1_250} facilitiesUsed={2} seatsUsed={12} />);

    // Halfway through the asset allowance.
    const assets = screen.getByRole("progressbar", { name: "Assets usage" });
    expect(assets).toHaveAttribute("aria-valuenow", "50");
    expect(screen.getByText("2,500", { exact: false })).toBeInTheDocument();
    expect(screen.getByRole("progressbar", { name: "Facilities usage" })).toHaveAttribute(
      "aria-valuenow",
      "40",
    );
  });

  it("renders an unlimited quota as text with no progress bar", () => {
    renderWith(<PlanCard assetsUsed={40_000} seatsUsed={900} />, {
      subscription: {
        ...operations,
        planName: "Enterprise",
        quotas: { facilities: null, assets: null, seats: null },
      },
    });

    expect(screen.getAllByText("/ unlimited").length).toBeGreaterThan(0);
    expect(screen.queryByRole("progressbar", { name: "Assets usage" })).not.toBeInTheDocument();
  });

  it("shows a dash rather than inventing a zero when a count is unknown", () => {
    renderWith(<PlanCard />);

    expect(screen.getAllByText("—").length).toBe(3);
    expect(screen.queryByRole("progressbar")).not.toBeInTheDocument();
  });

  it("warns without locking out when a payment has failed", () => {
    renderWith(<PlanCard seatsUsed={3} />, {
      subscription: { ...operations, status: "past_due", trialDaysRemaining: null },
    });

    expect(screen.getByText("Payment overdue")).toBeInTheDocument();
    // Access continues while Stripe retries — the copy must not imply lockout.
    expect(screen.getByText(/Your access continues while Stripe retries/)).toBeInTheDocument();
  });

  it("says plainly when the company has no active subscription", () => {
    renderWith(<PlanCard />, {
      subscription: {
        ...operations,
        tier: "unassigned",
        planName: null,
        status: "incomplete",
        isEntitled: false,
        features: [],
        trialDaysRemaining: null,
        quotas: { facilities: 0, assets: 0, seats: 0 },
      },
    });

    expect(screen.getByText("No plan")).toBeInTheDocument();
    expect(screen.getByText(/no active subscription/)).toBeInTheDocument();
  });

  it("does not claim a plan while the subscription is still loading", () => {
    renderWith(<PlanCard />, {
      subscription: null,
      // Never resolves, so the card stays in its loading state.
      getSubscription: vi.fn(() => new Promise(() => undefined)),
    });

    // The spinner's accessible label and the visible copy say the same thing.
    expect(screen.getAllByText("Loading your plan").length).toBeGreaterThan(0);
    expect(screen.queryByText("Operations")).not.toBeInTheDocument();
  });

  it("keeps access language honest when the plan cannot be loaded", async () => {
    renderWith(<PlanCard />, {
      subscription: null,
      getSubscription: vi.fn(async () => {
        throw new Error("offline");
      }),
    });

    expect(
      await screen.findByText(/could not load your plan just now. Your access is unaffected/i),
    ).toBeInTheDocument();
  });
});

describe("the entitlement gate", () => {
  it("grants only what the plan's feature list contains", () => {
    renderWith(<FeatureProbe feature="work_orders" />);
    expect(screen.getByText("true")).toBeInTheDocument();
  });

  it("refuses a feature the plan omits", () => {
    renderWith(<FeatureProbe feature="vr_training" />);
    expect(screen.getByText("false")).toBeInTheDocument();
  });

  it("treats an ungated item as part of every plan", () => {
    renderWith(<FeatureProbe feature={undefined} />);
    expect(screen.getByText("true")).toBeInTheDocument();
  });

  it("fails closed while loading and on error, matching the API's 402", async () => {
    renderWith(<FeatureProbe feature="assets" />, {
      subscription: null,
      getSubscription: vi.fn(async () => {
        throw new Error("offline");
      }),
    });

    // Never optimistically true: a client that guessed would show modules the
    // server will refuse.
    expect(screen.getByText("false")).toBeInTheDocument();
    await waitFor(() =>
      expect(screen.getByText("false")).toHaveAttribute("data-status", "error"),
    );
    expect(screen.getByText("false")).toBeInTheDocument();
  });

  it("refuses everything when the subscription is not entitled, whatever it lists", () => {
    renderWith(<FeatureProbe feature="assets" />, {
      subscription: { ...operations, isEntitled: false },
    });
    expect(screen.getByText("false")).toBeInTheDocument();
  });
});

describe("nav filtering", () => {
  it("requires both the permission and the plan feature", () => {
    const allPermissions = () => true;
    const basePlan = (feature: string | undefined) =>
      !feature || ["assets", "inspections", "reports", "safety_reports", "documents", "digital_twin"].includes(feature);

    const labels = visibleNavGroups(allPermissions, basePlan)
      .flatMap((group) => group.items)
      .map((item) => item.label);

    // Permission alone is not enough: work orders and permits are
    // Operations-and-above modules.
    expect(labels).not.toContain("Work Orders");
    expect(labels).not.toContain("Permits");
    expect(labels).toContain("Assets");
    expect(labels).toContain("Dashboard");
  });

  it("keeps the permission gate independent of the plan", () => {
    const noPermissions = () => false;
    const everyFeature = () => true;

    const labels = visibleNavGroups(noPermissions, everyFeature)
      .flatMap((group) => group.items)
      .map((item) => item.label);

    // Dashboard and Documents carry no requiredPermission by design (there is
    // no documents.* key in the 0.4 catalog); nothing else survives.
    expect(labels).toEqual(["Dashboard", "Documents"]);
  });
});
