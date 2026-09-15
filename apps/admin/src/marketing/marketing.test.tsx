import { act, render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import AboutPage from "@/app/(marketing)/about/page";
import MarketingLayout from "@/app/(marketing)/layout";
import LandingPage from "@/app/(marketing)/page";
import PricingPage from "@/app/(marketing)/pricing/page";
import { AuthProvider } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";
import { APP_HOME } from "@/navigation/routes";

import {
  ANNUAL_MONTHS_CHARGED,
  BASE_MODULES,
  TRIAL_DAYS,
  allowanceLine,
  plans,
} from "./pricing-plans";
import { chainSteps } from "./record-chain";
import { roleRows } from "./role-matrix";

const pathControl = vi.hoisted(() => {
  let path = "/";
  const listeners = new Set<() => void>();
  return {
    get current() {
      return path;
    },
    set(next: string) {
      path = next;
      listeners.forEach((listener) => listener());
    },
    subscribe(listener: () => void) {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
  };
});

vi.mock("next/navigation", async () => {
  const { useSyncExternalStore } = await import("react");
  return {
    usePathname: () => useSyncExternalStore(pathControl.subscribe, () => pathControl.current),
    useSearchParams: () => new URLSearchParams(),
    useRouter: () => ({
      back: () => undefined,
      prefetch: () => undefined,
      push: () => undefined,
      replace: () => undefined,
    }),
  };
});

const session: AuthSession = {
  uid: "firebase-uid",
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: async () => "id-token",
};

const identity = {
  uid: "firebase-uid",
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  companyId: "acme-energy",
  companyName: "Acme Energy",
  roleKey: "company_admin",
  permissions: new Set(["assets.read"]),
};

/** Only `observe` matters here: the marketing header reads auth status and
 * nothing else. A never-resolving observer models the restoring state. */
function gatewayFor(initial: AuthSession | null, settle = true): AuthGateway {
  return {
    getIdToken: async () => "id-token",
    observe: (listener) => {
      if (settle) listener(initial);
      return () => undefined;
    },
    refreshSession: async () => initial,
    sendEmailVerification: async () => undefined,
    sendPasswordResetEmail: async () => undefined,
    signIn: async () => session,
    signOut: async () => undefined,
  } as AuthGateway;
}

let currentGateway: AuthGateway = gatewayFor(null);

/** The provider tree is rebuilt with the same gateway instance so a rerender
 * models a client navigation — layout stays mounted, only the page swaps. */
function marketingTree(page: React.ReactNode) {
  return (
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider
          apiClient={{
            getCurrentUser: vi.fn(async () => identity),
            registerCompanyAdmin: vi.fn(),
          }}
          gateway={currentGateway}
        >
          <MarketingLayout>{page}</MarketingLayout>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>
  );
}

function renderMarketing(
  page: React.ReactNode,
  { signedIn = false, settle = true }: { signedIn?: boolean; settle?: boolean } = {},
) {
  currentGateway = gatewayFor(signedIn ? session : null, settle);
  return render(marketingTree(page));
}

describe("public marketing site", () => {
  it("renders the landing page for an anonymous visitor with both entry points", async () => {
    renderMarketing(<LandingPage />);

    expect(
      screen.getByRole("heading", {
        level: 1,
        name: /One record per asset/,
      }),
    ).toBeInTheDocument();

    // The signup CTA is what makes self-service registration reachable at all.
    const trialLinks = await screen.findAllByRole("link", { name: "Start free trial" });
    expect(trialLinks.length).toBeGreaterThan(0);
    for (const link of trialLinks) expect(link).toHaveAttribute("href", "/signup");
    expect(screen.getAllByRole("link", { name: "Log in" })[0]).toHaveAttribute("href", "/login");
  });

  it("offers the app instead of signup once the visitor is authenticated", async () => {
    renderMarketing(<LandingPage />, { signedIn: true });

    const header = screen.getByRole("banner");
    expect(await within(header).findByRole("link", { name: "Go to dashboard" })).toHaveAttribute(
      "href",
      APP_HOME,
    );
    expect(within(header).queryByRole("link", { name: "Start free trial" })).not.toBeInTheDocument();
  });

  it("shows no header call to action while the session is still restoring", () => {
    renderMarketing(<LandingPage />, { settle: false });

    const header = screen.getByRole("banner");
    expect(within(header).queryByRole("link", { name: "Start free trial" })).not.toBeInTheDocument();
    expect(within(header).queryByRole("link", { name: "Go to dashboard" })).not.toBeInTheDocument();
    // The nav itself still renders, so the page is never blank behind a splash.
    expect(within(header).getAllByRole("link", { name: "Pricing" }).length).toBeGreaterThan(0);
  });

  it("marks the active page in the site nav", () => {
    pathControl.set("/pricing");
    renderMarketing(<PricingPage />);

    const current = screen
      .getAllByRole("link", { name: "Pricing" })
      .filter((link) => link.getAttribute("aria-current") === "page");
    expect(current.length).toBeGreaterThan(0);
    pathControl.set("/");
  });

  it("renders every published tier with its allowance and the right CTA", () => {
    renderMarketing(<PricingPage />);

    expect(plans.map((plan) => plan.tier)).toEqual([
      "pilot",
      "starter",
      "field",
      "operations",
      "enterprise",
    ]);
    for (const plan of plans) {
      expect(screen.getByRole("heading", { level: 2, name: plan.name })).toBeInTheDocument();
      expect(screen.getByText(allowanceLine(plan))).toBeInTheDocument();
    }
    // Every trial CTA must carry the chosen plan into signup, or step two has
    // no idea which Stripe Price to open. Enterprise has no trial CTA at all.
    const selfServe = plans.filter((plan) => !plan.customQuoted);
    const trialLinks = screen.getAllByRole("link", { name: `Start ${TRIAL_DAYS}-day trial` });
    expect(trialLinks.length).toBe(selfServe.length + 1);
    for (const plan of selfServe) {
      expect(
        trialLinks.some(
          (link) => link.getAttribute("href") === `/signup?plan=${plan.tier}&interval=annual`,
        ),
      ).toBe(true);
    }
    expect(
      trialLinks.some((link) => link.getAttribute("href")?.includes("plan=enterprise")),
    ).toBe(false);
  });

  it("routes Enterprise to sales instead of to a card", () => {
    renderMarketing(<PricingPage />);

    // There is no Stripe Price for a custom-quoted tier, so a buy button here
    // would open a checkout against a price that does not exist.
    expect(screen.getByRole("link", { name: "Request a quote" })).toHaveAttribute(
      "href",
      "/contact?topic=enterprise",
    );
    expect(screen.getByText("Custom Pricing")).toBeInTheDocument();
    expect(screen.getByText(/Starting around \$9,999\/month/)).toBeInTheDocument();
    // The figure the product owner asked us to stop publishing.
    expect(screen.queryByText(/29,997/)).not.toBeInTheDocument();
  });

  it("publishes the launch prices and quotas", () => {
    renderMarketing(<PricingPage />);

    // These are charged through Stripe, so a typo is a commercial defect. The
    // backend catalog (apps/api/app/billing/plans.py) holds the same figures
    // and its own suite pins them; this guards the published half.
    const byTier = Object.fromEntries(plans.map((plan) => [plan.tier, plan]));
    expect(byTier.pilot.monthlyCents).toBe(49_900);
    expect(byTier.starter.monthlyCents).toBe(99_900);
    expect(byTier.field.monthlyCents).toBe(199_900);
    expect(byTier.operations.monthlyCents).toBe(499_900);
    // Custom-quoted means no list price at all, only a floor to quote from.
    expect(byTier.enterprise.monthlyCents).toBeNull();
    expect(byTier.enterprise.annualTotalCents).toBeNull();
    expect(byTier.enterprise.startingMonthlyCents).toBe(999_900);

    for (const plan of plans.filter((entry) => !entry.customQuoted)) {
      // Twelve months of service for ten months of money, and never the other
      // way round -- an "incentive" that costs more is a penalty.
      expect(plan.annualTotalCents).toBe(plan.monthlyCents! * ANNUAL_MONTHS_CHARGED);
      expect(plan.annualTotalCents!).toBeLessThan(plan.monthlyCents! * 12);
    }

    expect(byTier.pilot.quotas).toEqual({ facilities: 1, assets: 100, seats: 5 });
    expect(byTier.starter.quotas).toEqual({ facilities: 1, assets: 250, seats: 10 });
    expect(byTier.field.quotas).toEqual({ facilities: 2, assets: 750, seats: 25 });
    expect(byTier.operations.quotas).toEqual({ facilities: 5, assets: 2_500, seats: 75 });
    expect(byTier.enterprise.quotas).toEqual({
      facilities: null,
      assets: null,
      seats: null,
    });

    // Both prices on the card, so a buyer picking monthly is not quoted a
    // number they can only reach by committing to a year.
    // Scoped to the plan card: "$999" also appears in the add-on table, and an
    // ambiguous match would pass for the wrong reason.
    const starterCard = screen
      .getByRole("heading", { level: 2, name: "Starter" })
      .closest(".mk-panel");
    expect(starterCard?.textContent).toContain("$999");
    expect(starterCard?.textContent).toContain("$9,990/yr billed annually");
    expect(starterCard?.textContent).toContain("2 months free");
  });

  it("puts the core product on every tier, including Pilot", () => {
    renderMarketing(<PricingPage />);

    // The commercial line that shapes the whole product UI: a customer proves
    // the platform on Pilot and upgrades for capacity, never for the basics.
    const core = BASE_MODULES.join(" ");
    expect(core).toMatch(/AI photo and video analysis/);
    expect(core).toMatch(/AR inspection/);
    expect(core).toMatch(/Work orders/);

    const byTier = Object.fromEntries(plans.map((plan) => [plan.tier, plan]));
    expect(byTier.pilot.adds).toEqual([]);
    expect(byTier.operations.adds.join(" ")).toMatch(/Permit-to-work/);
    expect(byTier.enterprise.adds.join(" ")).toMatch(/VR training/);
  });

  it("presents the hero product depiction as one described image, not a text wall", () => {
    renderMarketing(<LandingPage />);

    // role="img" + a label means assistive tech gets one honest description of
    // the illustration instead of walking a decorative widget tree, and the
    // description says what is depicted rather than claiming to be a capture.
    const showcase = screen.getByRole("img", { name: /Illustration of the product/i });
    expect(showcase).toBeInTheDocument();
    expect(showcase.getAttribute("aria-label")).toMatch(/Tank Farm A/);
  });

  it("renders the whole record chain with the permission gating each step", () => {
    renderMarketing(<LandingPage />);

    expect(chainSteps.length).toBeGreaterThan(0);
    for (const step of chainSteps) {
      expect(screen.getByRole("heading", { level: 3, name: step.title })).toBeInTheDocument();
      expect(screen.getAllByText(step.gate).length).toBeGreaterThan(0);
    }
    // The separation-of-duties claim is the point of the chain: doing the work
    // and signing it off are different keys.
    expect(screen.getAllByText("work_orders.write").length).toBeGreaterThan(0);
    expect(screen.getAllByText("work_orders.close").length).toBeGreaterThan(0);
  });

  it("publishes every built-in role with its permission count", () => {
    renderMarketing(<LandingPage />);

    const matrix = screen.getByRole("table", { name: /seven built-in roles/i });
    expect(roleRows).toHaveLength(7);
    for (const role of roleRows) {
      const row = within(matrix).getByRole("rowheader", { name: new RegExp(role.key) });
      expect(row).toBeInTheDocument();
      expect(within(matrix).getByText(role.scope)).toBeInTheDocument();
    }
    // The two counts a reader is most likely to check against the docs.
    expect(within(matrix).getByRole("rowheader", { name: /super_admin/ })).toBeInTheDocument();
    expect(roleRows.find((role) => role.key === "field_inspector")?.permissions).toBe(14);
  });

  it("never leaves revealed content invisible when IntersectionObserver is absent", async () => {
    // jsdom ships no IntersectionObserver, which is also the real no-support
    // path. The fallback must show everything rather than stranding the page at
    // opacity 0 — the reason the hidden state is CSS-gated on `js-anim`.
    expect(globalThis.IntersectionObserver).toBeUndefined();
    const { container } = renderMarketing(<LandingPage />);

    const revealed = Array.from(container.querySelectorAll("[data-reveal]"));
    expect(revealed.length).toBeGreaterThan(0);
    await waitFor(() => {
      for (const node of revealed) expect(node).toHaveClass("is-visible");
    });
  });

  it("drives the header progress bar from scroll position", async () => {
    const { container } = renderMarketing(<LandingPage />);
    const bar = container.querySelector<HTMLElement>(".mk-progress");
    expect(bar).not.toBeNull();

    // Unscrollable document: no progress.
    await waitFor(() => expect(bar).toHaveStyle({ transform: "scaleX(0)" }));

    Object.defineProperty(document.documentElement, "scrollHeight", {
      configurable: true,
      value: 3000,
    });
    Object.defineProperty(window, "innerHeight", { configurable: true, value: 1000 });
    Object.defineProperty(window, "scrollY", { configurable: true, value: 1000 });

    await act(async () => {
      window.dispatchEvent(new Event("scroll"));
      await new Promise((resolve) => requestAnimationFrame(() => resolve(null)));
    });

    // 1000 scrolled of 2000 scrollable.
    expect(bar).toHaveStyle({ transform: "scaleX(0.5)" });
  });

  it("reveals the next page's content after an in-group navigation", async () => {
    // The regression this guards: `(marketing)/layout` stays mounted when
    // Next navigates between `/`, `/pricing`, and `/about`, so a mount-only
    // observer revealed the landing page and left every later page at
    // opacity 0 — a blank screen under a working header.
    const { container, rerender } = renderMarketing(<LandingPage />);
    await waitFor(() =>
      expect(container.querySelector("[data-reveal]")).toHaveClass("is-visible"),
    );

    pathControl.set("/pricing");
    rerender(marketingTree(<PricingPage />));

    await waitFor(() => {
      const revealed = Array.from(container.querySelectorAll("[data-reveal]"));
      expect(revealed.length).toBeGreaterThan(0);
      for (const node of revealed) expect(node).toHaveClass("is-visible");
    });
    expect(screen.getByRole("heading", { level: 1, name: /Licensed per/ })).toBeInTheDocument();

    // ...and back again, where the landing page's nodes are freshly created.
    pathControl.set("/");
    rerender(marketingTree(<LandingPage />));
    await waitFor(() => {
      for (const node of Array.from(container.querySelectorAll("[data-reveal]"))) {
        expect(node).toHaveClass("is-visible");
      }
    });
    expect(
      screen.getByRole("heading", { level: 1, name: /One record per asset/ }),
    ).toBeInTheDocument();
  });

  it("observes and reveals the next page under a real IntersectionObserver", async () => {
    // The jsdom default has no IntersectionObserver, so the test above only
    // covers the fallback. This installs one — plus off-screen rects, since
    // jsdom reports every element at top: 0 and the fold check would otherwise
    // reveal everything without ever observing — to exercise the browser path
    // that actually broke.
    const observed = new Set<Element>();
    let fire: (() => void) | null = null;
    class FakeIntersectionObserver {
      constructor(private readonly callback: IntersectionObserverCallback) {
        fire = () => {
          const entries = Array.from(observed, (target) => ({
            isIntersecting: true,
            target,
          })) as unknown as IntersectionObserverEntry[];
          this.callback(entries, this as unknown as IntersectionObserver);
        };
      }
      observe(target: Element) {
        observed.add(target);
      }
      unobserve(target: Element) {
        observed.delete(target);
      }
      disconnect() {
        observed.clear();
      }
      takeRecords() {
        return [];
      }
    }
    vi.stubGlobal("IntersectionObserver", FakeIntersectionObserver);
    const rectSpy = vi
      .spyOn(Element.prototype, "getBoundingClientRect")
      .mockReturnValue({ top: 5000, bottom: 5400, height: 400 } as DOMRect);

    try {
      const { container, rerender } = renderMarketing(<LandingPage />);
      await waitFor(() => expect(observed.size).toBeGreaterThan(0));

      pathControl.set("/about");
      rerender(marketingTree(<AboutPage />));

      // A fresh observer must have picked up the new page's elements...
      const aboutNodes = Array.from(container.querySelectorAll("[data-reveal]"));
      expect(aboutNodes.length).toBeGreaterThan(0);
      await waitFor(() => {
        for (const node of aboutNodes) expect(observed.has(node)).toBe(true);
      });

      // ...and revealed them once they intersect.
      act(() => fire?.());
      for (const node of aboutNodes) expect(node).toHaveClass("is-visible");
    } finally {
      rectSpy.mockRestore();
      vi.unstubAllGlobals();
      pathControl.set("/");
    }
  });

  it("keeps the header action cluster light and the body CTAs affordant", () => {
    const { container } = renderMarketing(<LandingPage />);
    const header = screen.getByRole("banner");

    // Header primary: a pill with no trailing arrow, so three controls in a row
    // do not read as a toolbar.
    const headerCta = within(header).getByRole("link", { name: "Start free trial" });
    expect(headerCta).toHaveClass("rounded-full");
    expect(headerCta.querySelector("svg")).toBeNull();

    // Header secondaries are bare text actions — no border, no fill. Both the
    // desktop link and the compact-strip one on small screens.
    const headerLogins = within(header).getAllByRole("link", { name: "Log in" });
    expect(headerLogins.length).toBeGreaterThan(0);
    for (const login of headerLogins) {
      expect(login.className).not.toMatch(/border/);
    }

    // Body primaries keep the arrow, where it helps scanning.
    const bodyCta = Array.from(
      container.querySelectorAll<HTMLAnchorElement>('a[href="/signup"]'),
    ).filter((link) => !header.contains(link));
    expect(bodyCta.length).toBeGreaterThan(0);
    expect(bodyCta.some((link) => link.querySelector("svg") !== null)).toBe(true);
  });

  it("exposes the theme toggle as an icon button naming the theme it switches to", async () => {
    renderMarketing(<LandingPage />);
    const header = screen.getByRole("banner");

    const toggle = within(header).getByRole("button", { name: "Switch to dark theme" });
    // Icon only, and bare: no visible text label and no resting border/fill
    // competing with the primary action beside it.
    expect(toggle.textContent).toBe("");
    expect(toggle.className).not.toMatch(/border/);

    await userEvent.click(toggle);
    expect(
      within(header).getByRole("button", { name: "Switch to light theme" }),
    ).toBeInTheDocument();
  });

  it("renders the about page and keeps the footer reachable from every page", () => {
    renderMarketing(<AboutPage />);

    expect(
      screen.getByRole("heading", { level: 1, name: /Software for the crews/ }),
    ).toBeInTheDocument();
    const footer = screen.getByRole("contentinfo");
    expect(within(footer).getByRole("link", { name: "Create an organization" })).toHaveAttribute(
      "href",
      "/signup",
    );
  });
});
