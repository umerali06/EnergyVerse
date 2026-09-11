import { act, render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { SignupCompleteScreen, SignupPlanScreen } from "./signup-billing";

const routerControl = vi.hoisted(() => {
  const replaced: string[] = [];
  return {
    replaced,
    reset() {
      replaced.length = 0;
    },
  };
});

let search = "";

vi.mock("next/navigation", () => ({
  usePathname: () => "/signup/plan",
  useSearchParams: () => new URLSearchParams(search),
  useRouter: () => ({
    back: () => undefined,
    prefetch: () => undefined,
    push: (url: string) => routerControl.replaced.push(url),
    replace: (url: string) => routerControl.replaced.push(url),
  }),
}));

const session: AuthSession = {
  uid: "firebase-uid",
  email: "admin@acme.example.invalid",
  emailVerified: false,
  getIdToken: async () => "id-token",
};

const identity = {
  uid: "firebase-uid",
  email: "admin@acme.example.invalid",
  emailVerified: false,
  companyId: "cmp_acme",
  companyName: "Acme Energy",
  roleKey: "company_admin",
  permissions: new Set(["company.settings"]),
};

const catalog = {
  trialDays: 7,
  plans: [
    {
      tier: "starter",
      name: "Starter",
      audience: "Single well site",
      listMonthlyCents: 99_799,
      annualTotalCents: 1_197_588,
      monthlyCents: 114_799,
      quotas: { facilities: 1, assets: 150, seats: 5 },
      features: ["assets", "inspections"],
      digitalTwinScope: "single",
      support: "Email support",
      customQuoted: false,
    },
    {
      tier: "operations",
      name: "Operations",
      audience: "Multi-site operator",
      listMonthlyCents: 999_799,
      annualTotalCents: 11_997_588,
      monthlyCents: 1_149_799,
      quotas: { facilities: 5, assets: 2_500, seats: 75 },
      features: ["assets", "work_orders", "permits", "ar_inspection"],
      digitalTwinScope: "all",
      support: "Priority support",
      customQuoted: false,
    },
    {
      tier: "enterprise",
      name: "Enterprise",
      audience: "Integrated oil major",
      listMonthlyCents: 2_999_799,
      annualTotalCents: 35_997_588,
      monthlyCents: 3_449_799,
      quotas: { facilities: null, assets: null, seats: null },
      features: ["vr_training"],
      digitalTwinScope: "all",
      support: "Premium support",
      customQuoted: true,
    },
  ],
};

const unentitled = {
  tier: "unassigned",
  planName: null,
  status: "incomplete",
  isEntitled: false,
  features: [],
  trialEndsAt: null,
  trialDaysRemaining: null,
  currentPeriodEnd: null,
  quotas: { facilities: 0, assets: 0, seats: 0 },
};

const entitled = {
  ...unentitled,
  tier: "operations",
  planName: "Operations",
  status: "trialing",
  isEntitled: true,
  features: ["assets", "work_orders"],
  trialDaysRemaining: 7,
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

type Client = {
  getBillingCatalog: ReturnType<typeof vi.fn>;
  getSubscription: ReturnType<typeof vi.fn>;
  createCheckoutSession: ReturnType<typeof vi.fn>;
};

function renderScreen(screenNode: React.ReactNode, client: Partial<Client>) {
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider
          apiClient={{
            getCurrentUser: vi.fn(async () => identity),
            registerCompanyAdmin: vi.fn(),
            getBillingCatalog: vi.fn(async () => catalog),
            getSubscription: vi.fn(async () => unentitled),
            createCheckoutSession: vi.fn(),
            ...client,
          }}
          gateway={gateway()}
        >
          {screenNode}
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

beforeEach(() => {
  routerControl.reset();
  search = "";
});

describe("signup step 2: choose a plan", () => {
  it("renders every catalogued plan with the trial length from the server", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    expect(
      await screen.findByRole("button", { name: /Start 7-day trial on Starter/ }),
    ).toBeInTheDocument();
    // Both the plan cards and the interval toggle are aria-pressed buttons, so
    // the cards are identified by their tier attribute instead.
    const cards = Array.from(document.querySelectorAll("[data-plan-tier]"));
    expect(cards).toHaveLength(catalog.plans.length);
    for (const plan of catalog.plans) {
      const card = cards.find((node) => node.getAttribute("data-plan-tier") === plan.tier);
      expect(card?.textContent).toContain(plan.name);
    }
    // Annual is the default, and prices come from the catalog's cents values.
    expect(screen.getByText("$11,975.88")).toBeInTheDocument();
    expect(screen.getByText("$119,975.88")).toBeInTheDocument();
  });

  it("preselects the plan carried over from the pricing page", async () => {
    // The pricing CTA sends ?plan=operations through registration into step 2.
    Object.defineProperty(window, "location", {
      configurable: true,
      value: { ...window.location, search: "?plan=operations", assign: vi.fn() },
    });
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    expect(
      await screen.findByRole("button", { name: /Start 7-day trial on Operations/ }),
    ).toBeInTheDocument();
  });

  it("switches the displayed price when the interval changes", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});
    await screen.findByText("$11,975.88");

    await userEvent.click(screen.getByRole("button", { name: "monthly" }));

    expect(screen.getByText("$1,147.99")).toBeInTheDocument();
    expect(screen.queryByText("$11,975.88")).not.toBeInTheDocument();
  });

  it("sends the chosen tier and interval to checkout and leaves for Stripe", async () => {
    const assign = vi.fn();
    Object.defineProperty(window, "location", {
      configurable: true,
      value: { ...window.location, search: "", assign },
    });
    const createCheckoutSession = vi.fn(async () => ({
      sessionId: "cs_test_1",
      checkoutUrl: "https://checkout.stripe.com/c/cs_test_1",
    }));
    renderScreen(<SignupPlanScreen reducedMotionOverride />, { createCheckoutSession });

    await screen.findByRole("button", { name: /Start 7-day trial on Starter/ });
    await userEvent.click(screen.getByRole("button", { name: /Operations/ }));
    await userEvent.click(screen.getByRole("button", { name: /Start 7-day trial on Operations/ }));

    await waitFor(() =>
      expect(createCheckoutSession).toHaveBeenCalledWith({
        tier: "operations",
        interval: "annual",
      }),
    );
    // A full navigation, not a router push: the destination is Stripe.
    expect(assign).toHaveBeenCalledWith("https://checkout.stripe.com/c/cs_test_1");
    expect(routerControl.replaced).not.toContain("https://checkout.stripe.com/c/cs_test_1");
  });

  it("says nothing was charged when the session cannot be opened", async () => {
    const createCheckoutSession = vi.fn(async () => {
      throw new Error("stripe down");
    });
    renderScreen(<SignupPlanScreen reducedMotionOverride />, { createCheckoutSession });

    await screen.findByRole("button", { name: /Start 7-day trial on Starter/ });
    await userEvent.click(screen.getByRole("button", { name: /Start 7-day trial on Starter/ }));

    expect(await screen.findByRole("alert")).toHaveTextContent(/Nothing was charged/);
  });

  it("skips the step when the company already has a subscription", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {
      getSubscription: vi.fn(async () => entitled),
    });

    // Unverified admin, so the next stop is email verification, not the app.
    await waitFor(() => expect(routerControl.replaced).toContain("/verify-email"));
  });

  it("offers a retry rather than an empty picker when the catalog fails", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {
      getBillingCatalog: vi.fn(async () => {
        throw new Error("offline");
      }),
    });

    expect(await screen.findByRole("alert")).toHaveTextContent(/could not load the plans/i);
    expect(screen.getByRole("button", { name: "Retry" })).toBeInTheDocument();
  });
});

describe("signup completion", () => {
  it("polls until the webhook has landed, because the redirect is not the confirmation", async () => {
    const getSubscription = vi
      .fn()
      .mockResolvedValueOnce(unentitled)
      .mockResolvedValueOnce(unentitled)
      .mockResolvedValue(entitled);

    renderScreen(
      <SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />,
      { getSubscription },
    );

    expect(await screen.findByText(/Confirming your payment/)).toBeInTheDocument();
    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
    expect(getSubscription.mock.calls.length).toBeGreaterThanOrEqual(3);
    expect(screen.getByText(/another 7 days/)).toBeInTheDocument();
  });

  it("sends an unverified admin to verification and a verified one to the app", async () => {
    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      getSubscription: vi.fn(async () => entitled),
    });

    const action = await screen.findByRole("button", { name: "Verify your email" });
    await userEvent.click(action);
    expect(routerControl.replaced).toContain("/verify-email");
  });

  it("does not strand the visitor when the webhook never arrives", async () => {
    renderScreen(
      <SignupCompleteScreen maxAttempts={2} pollIntervalMs={1} reducedMotionOverride />,
      { getSubscription: vi.fn(async () => unentitled) },
    );

    expect(await screen.findByText(/payment is being confirmed/i)).toBeInTheDocument();
    // Both a way to re-check and a way out; nothing is lost either way.
    expect(screen.getByRole("button", { name: "Check again" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Continue anyway" })).toBeInTheDocument();
  });

  it("keeps polling through a transient API failure", async () => {
    const getSubscription = vi
      .fn()
      .mockRejectedValueOnce(new Error("network"))
      .mockResolvedValue(entitled);

    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      getSubscription,
    });

    // A failed poll is not a failed payment.
    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
  });
});

describe("the outstanding email verification", () => {
  it("is named on the plan step, before the person reaches the verify screen", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    // Registration already sent the link; nothing used to say so, and the
    // requirement first appeared on the verify screen.
    expect(
      await screen.findByText(/We have emailed a verification link/),
    ).toBeInTheDocument();
    expect(screen.getByText(/admin@acme.example.invalid/)).toBeInTheDocument();
  });

  it("is the stated next step once the subscription is active", async () => {
    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      getSubscription: vi.fn(async () => entitled),
    });

    expect(await screen.findByText("One thing left")).toBeInTheDocument();
    expect(screen.getByText(/confirms the address/)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Verify your email" })).toBeInTheDocument();
  });

  it("is still named when the webhook never arrives", async () => {
    // The timeout branch can be a person's last step too, so it cannot be the
    // one place the requirement goes unmentioned.
    renderScreen(
      <SignupCompleteScreen maxAttempts={2} pollIntervalMs={1} reducedMotionOverride />,
      { getSubscription: vi.fn(async () => unentitled) },
    );

    expect(await screen.findByText(/payment is being confirmed/i)).toBeInTheDocument();
    expect(screen.getByText("One thing left")).toBeInTheDocument();
  });
});
