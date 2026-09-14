import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { ApiClientError } from "@/api";
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

/** Both billing screens are reached only after verification (D-103), so the
 * fixtures say so — `RequireAccount` admits nobody else. */
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

/** Replaces `window.location` so the screens can read the query string the way
 * the browser hands it to them, and so leaving for Stripe is observable. */
function setLocationSearch(value: string) {
  const assign = vi.fn();
  Object.defineProperty(window, "location", {
    configurable: true,
    value: { ...window.location, search: value, assign },
  });
  return assign;
}

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
  getCurrentUser: ReturnType<typeof vi.fn>;
  getBillingCatalog: ReturnType<typeof vi.fn>;
  getSubscription: ReturnType<typeof vi.fn>;
  createCheckoutSession: ReturnType<typeof vi.fn>;
  confirmCheckoutSession: ReturnType<typeof vi.fn>;
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
            confirmCheckoutSession: vi.fn(async () => ({
              outcome: "reconciled",
              subscription: entitled,
            })),
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
  setLocationSearch("");
  window.localStorage.clear();
});

describe("signup step 3: choose a plan", () => {
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

  it("names its place in the sequence and that it is the last step", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    expect(await screen.findByText("Step 3 of 3")).toBeInTheDocument();
    expect(screen.getByText(/This is the last step/)).toBeInTheDocument();
    // The step before it is done, not pending.
    const verify = screen.getByRole("navigation", { name: "Signup progress" });
    expect(verify.textContent).toContain("Verify email");
  });

  it("no longer asks for an email confirmation it has already had", async () => {
    // Verification now happens two steps earlier, so repeating "we emailed you
    // a link" here would describe something already done.
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    await screen.findByRole("button", { name: /Start 7-day trial on Starter/ });
    expect(screen.queryByText(/We have emailed a verification link/)).not.toBeInTheDocument();
  });

  it("preselects the plan and interval carried over from the pricing page", async () => {
    // The pricing CTA sends ?plan=operations&interval=monthly, which registration
    // parks in storage because the picker is now two screens away.
    window.localStorage.setItem("fev.signup.plan", "operations");
    window.localStorage.setItem("fev.signup.interval", "monthly");
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    expect(
      await screen.findByRole("button", { name: /Start 7-day trial on Operations/ }),
    ).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "monthly" })).toHaveAttribute(
      "aria-pressed",
      "true",
    );
  });

  it("lets a plan link on the current URL override a parked one", async () => {
    window.localStorage.setItem("fev.signup.plan", "starter");
    setLocationSearch("?plan=enterprise");
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {});

    expect(
      await screen.findByRole("button", { name: /Start 7-day trial on Enterprise/ }),
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
    const assign = setLocationSearch("");
    window.localStorage.setItem("fev.signup.plan", "starter");
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
    // The parked choice has been acted on and must not resurface later.
    expect(window.localStorage.getItem("fev.signup.plan")).toBeNull();
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

  it("skips the step and opens the app when the company already subscribed", async () => {
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {
      getSubscription: vi.fn(async () => entitled),
    });

    // The email is verified by the time anyone reaches this screen, so an
    // entitled company has nothing left to do.
    await waitFor(() => expect(routerControl.replaced).toContain("/dashboard"));
  });

  it("tells a non-admin to fetch their Company Admin rather than a 403 button", async () => {
    // An invited inspector whose company never finished checkout is sent here
    // by RequireSubscription, and cannot act: only a Company Admin may attach
    // billing. A picker whose button answers 403 would be a second dead end.
    renderScreen(<SignupPlanScreen reducedMotionOverride />, {
      getCurrentUser: vi.fn(async () => ({
        ...identity,
        roleKey: "field_inspector",
        permissions: new Set(["assets.read"]),
      })),
    });

    expect(await screen.findByRole("alert")).toHaveTextContent(/only a Company Admin/);
    expect(document.querySelectorAll("[data-plan-tier]")).toHaveLength(0);
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
  it("confirms the exact session Stripe returned, without waiting for a webhook", async () => {
    setLocationSearch("?session_id=cs_test_1");
    const confirmCheckoutSession = vi.fn(async () => ({
      outcome: "reconciled",
      subscription: entitled,
    }));
    const getSubscription = vi.fn(async () => unentitled);

    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      confirmCheckoutSession,
      getSubscription,
    });

    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
    expect(confirmCheckoutSession).toHaveBeenCalledWith("cs_test_1", expect.anything());
    // The read model is not consulted at all: the session id is authoritative.
    expect(getSubscription).not.toHaveBeenCalled();
    expect(screen.getByText(/another 7 days/)).toBeInTheDocument();
  });

  it("keeps confirming while Stripe has not attached the subscription yet", async () => {
    setLocationSearch("?session_id=cs_test_1");
    const confirmCheckoutSession = vi
      .fn()
      .mockResolvedValueOnce({ outcome: "pending", subscription: unentitled })
      .mockResolvedValue({ outcome: "reconciled", subscription: entitled });

    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      confirmCheckoutSession,
    });

    // `pending` is a reason to try again, not a failure.
    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
    expect(confirmCheckoutSession.mock.calls.length).toBeGreaterThanOrEqual(2);
  });

  it("opens the workspace by itself once the subscription is live", async () => {
    setLocationSearch("?session_id=cs_test_1");
    renderScreen(
      <SignupCompleteScreen pollIntervalMs={1} redirectDelayMs={1} reducedMotionOverride />,
      {},
    );

    // Nothing is left to ask for: the email was verified two steps ago.
    await screen.findByText(/You are on Operations/);
    await waitFor(() => expect(routerControl.replaced).toContain("/dashboard"));
  });

  it("falls back to the read model when the return URL carried no session id", async () => {
    const getSubscription = vi
      .fn()
      .mockResolvedValueOnce(unentitled)
      .mockResolvedValue(entitled);
    const confirmCheckoutSession = vi.fn();

    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      confirmCheckoutSession,
      getSubscription,
    });

    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
    expect(confirmCheckoutSession).not.toHaveBeenCalled();
  });

  it("keeps trying through a transient failure", async () => {
    setLocationSearch("?session_id=cs_test_1");
    const confirmCheckoutSession = vi
      .fn()
      .mockRejectedValueOnce(new Error("network"))
      .mockResolvedValue({ outcome: "reconciled", subscription: entitled });

    renderScreen(<SignupCompleteScreen pollIntervalMs={1} reducedMotionOverride />, {
      confirmCheckoutSession,
    });

    // A failed confirmation call is not a failed payment.
    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
  });

  it("never offers a way into the app without a plan", async () => {
    setLocationSearch("?session_id=cs_test_1");
    renderScreen(
      <SignupCompleteScreen maxAttempts={2} pollIntervalMs={1} reducedMotionOverride />,
      {
        confirmCheckoutSession: vi.fn(async () => ({
          outcome: "pending",
          subscription: unentitled,
        })),
      },
    );

    expect(await screen.findByText(/could not confirm your subscription/i)).toBeInTheDocument();
    // "Continue anyway" used to be here, and it landed people in a shell whose
    // nav was empty and whose every request answered 402.
    expect(screen.queryByRole("button", { name: "Continue anyway" })).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Check again" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Back to plans" })).toBeInTheDocument();
    expect(routerControl.replaced).not.toContain("/dashboard");
  });

  it("stops immediately on a session the server has ruled out", async () => {
    // `session_mismatch` and `session_expired` are considered answers, not
    // transient ones; retrying them twenty times only delays the message that
    // actually helps.
    setLocationSearch("?session_id=cs_someone_elses");
    const confirmCheckoutSession = vi.fn(async () => {
      throw new ApiClientError("session_mismatch", "Not your session", 400);
    });
    renderScreen(
      <SignupCompleteScreen maxAttempts={20} pollIntervalMs={5_000} reducedMotionOverride />,
      { confirmCheckoutSession },
    );

    expect(await screen.findByText(/could not confirm your subscription/i)).toBeInTheDocument();
    expect(confirmCheckoutSession).toHaveBeenCalledOnce();
  });

  it("quotes the checkout reference so support can finish it by hand", async () => {
    setLocationSearch("?session_id=cs_test_stuck");
    renderScreen(
      <SignupCompleteScreen maxAttempts={2} pollIntervalMs={1} reducedMotionOverride />,
      {
        confirmCheckoutSession: vi.fn(async () => {
          throw new Error("stripe down");
        }),
      },
    );

    expect(await screen.findByText(/could not confirm your subscription/i)).toBeInTheDocument();
    expect(screen.getByText("cs_test_stuck")).toBeInTheDocument();
  });

  it("re-checks on demand after giving up", async () => {
    setLocationSearch("?session_id=cs_test_1");
    const confirmCheckoutSession = vi
      .fn()
      .mockResolvedValueOnce({ outcome: "pending", subscription: unentitled })
      .mockResolvedValueOnce({ outcome: "pending", subscription: unentitled })
      .mockResolvedValue({ outcome: "reconciled", subscription: entitled });

    renderScreen(
      <SignupCompleteScreen maxAttempts={2} pollIntervalMs={1} reducedMotionOverride />,
      { confirmCheckoutSession },
    );

    await screen.findByText(/could not confirm your subscription/i);
    await userEvent.click(screen.getByRole("button", { name: "Check again" }));

    expect(await screen.findByText(/You are on Operations/)).toBeInTheDocument();
  });
});
