import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { ThemeProvider } from "@/design-system";

import { CookieConsent, CookiePreferencesButton, hasConsent } from "./cookie-consent";
import { ContactForm, CONTACT_CATEGORIES } from "./contact-form";
import { LEGAL_ROUTES, LEGAL_VERSION, OPERATOR } from "./legal-content";
import { LegalPage } from "./legal-page";
import { LEGAL_DOCUMENT_LIST, LEGAL_DOCUMENTS } from "./legal-registry";
import { SafetyNotice } from "./safety-notices";

vi.mock("next/navigation", () => ({
  usePathname: () => "/privacy",
  useSearchParams: () => new URLSearchParams(""),
  useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: vi.fn(), replace: vi.fn() }),
}));

beforeEach(() => {
  window.localStorage.clear();
});

describe("the published legal documents", () => {
  it("publishes one document per required route", () => {
    // The package names six routes; five are documents and /contact is a page.
    const slugs = LEGAL_DOCUMENT_LIST.map((document) => `/${document.slug}`).sort();
    expect(slugs).toEqual(LEGAL_ROUTES.map((route) => route.href).sort());
  });

  it("gives every section a unique anchor, so the contents links resolve", () => {
    for (const document of LEGAL_DOCUMENT_LIST) {
      const ids = document.sections.map((section) => section.id);
      expect(new Set(ids).size, `${document.slug} has duplicate section ids`).toBe(ids.length);
      expect(ids.length).toBeGreaterThan(0);
    }
  });

  it("names the operator and the contact address in every document", () => {
    // Required on each policy, not only the first one a reader happens to open.
    for (const document of LEGAL_DOCUMENT_LIST) {
      const hasOperatorTable = [...(document.intro ?? []), ...document.sections.flatMap((s) => s.blocks)].some(
        (block) => block.kind === "contact",
      );
      expect(hasOperatorTable, `${document.slug} omits the operator block`).toBe(true);
    }
  });
});

describe("a rendered legal page", () => {
  it("shows the logo, the last-updated date, the version, and a way back to top", () => {
    render(
      <ThemeProvider>
        <LegalPage document={LEGAL_DOCUMENTS.privacy} />
      </ThemeProvider>,
    );

    expect(screen.getByRole("heading", { level: 1, name: "Privacy Policy" })).toBeInTheDocument();
    expect(screen.getByRole("img", { name: "Flacron Energy" })).toBeInTheDocument();
    expect(screen.getByText(/Last Updated: September 14, 2026/)).toBeInTheDocument();
    expect(screen.getByText(new RegExp(`Version ${LEGAL_VERSION}`))).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /Back to top/ })).toHaveAttribute("href", "#top");
  });

  it("builds the table of contents from the real headings", () => {
    render(
      <ThemeProvider>
        <LegalPage document={LEGAL_DOCUMENTS.terms} />
      </ThemeProvider>,
    );

    const contents = screen.getByRole("navigation", { name: "On this page" });
    for (const section of LEGAL_DOCUMENTS.terms.sections) {
      expect(
        within(contents).getByRole("link", { name: section.title }),
        `${section.title} missing from contents`,
      ).toHaveAttribute("href", `#${section.id}`);
      // And the anchor it points at actually exists on the page.
      expect(document.getElementById(section.id)).not.toBeNull();
    }
  });

  it("carries the operator identity, including the address and phone", () => {
    render(
      <ThemeProvider>
        <LegalPage document={LEGAL_DOCUMENTS["refund-policy"]} />
      </ThemeProvider>,
    );

    expect(screen.getAllByText(OPERATOR.operator).length).toBeGreaterThan(0);
    expect(screen.getAllByText(OPERATOR.address).length).toBeGreaterThan(0);
    expect(screen.getAllByText(OPERATOR.phone).length).toBeGreaterThan(0);
  });

  it("renders the human-in-the-loop notice as a callout, not buried prose", () => {
    render(
      <ThemeProvider>
        <LegalPage document={LEGAL_DOCUMENTS["industrial-disclaimer"]} />
      </ThemeProvider>,
    );

    const notices = screen.getAllByRole("note");
    expect(notices.length).toBeGreaterThan(0);
    expect(
      notices.some((notice) => notice.textContent?.includes("does not replace qualified engineers")),
    ).toBe(true);
  });

  it("prints the published price table on the terms", () => {
    render(
      <ThemeProvider>
        <LegalPage document={LEGAL_DOCUMENTS.terms} />
      </ThemeProvider>,
    );

    expect(screen.getByText("$999/mo ($9,990/yr)")).toBeInTheDocument();
    expect(screen.getByText("$499/mo ($4,990/yr)")).toBeInTheDocument();
    // Enterprise publishes a floor, never a buyable figure — and never the old
    // $29,997.99, which the product owner asked us to stop showing.
    expect(screen.getByText("Custom pricing, starting around $9,999/mo")).toBeInTheDocument();
    expect(screen.queryByText(/29,997/)).not.toBeInTheDocument();
  });
});

describe("cookie consent", () => {
  it("offers rejection with the same prominence as acceptance", async () => {
    // The package forbids hiding or obscuring the rejection option; both sit on
    // the banner itself rather than rejection being behind "Manage".
    render(<CookieConsent />);

    expect(await screen.findByRole("button", { name: "Accept all" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Reject non-essential" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Manage preferences" })).toBeInTheDocument();
  });

  it("stores a decision and then stays out of the way", async () => {
    render(<CookieConsent />);
    const user = userEvent.setup();

    await user.click(await screen.findByRole("button", { name: "Reject non-essential" }));

    await waitFor(() =>
      expect(screen.queryByRole("button", { name: "Accept all" })).not.toBeInTheDocument(),
    );
    expect(hasConsent("analytics")).toBe(false);
    expect(hasConsent("marketing")).toBe(false);
    // Strictly necessary is never a choice, so it is always granted.
    expect(hasConsent("necessary")).toBe(true);
  });

  it("grants the optional categories only when accepted", async () => {
    render(<CookieConsent />);
    const user = userEvent.setup();

    await user.click(await screen.findByRole("button", { name: "Accept all" }));

    expect(hasConsent("analytics")).toBe(true);
    expect(hasConsent("marketing")).toBe(true);
    expect(hasConsent("preferences")).toBe(true);
  });

  it("treats a decision recorded against an older policy as no decision", async () => {
    window.localStorage.setItem(
      "fev.cookie-consent",
      JSON.stringify({
        necessary: true,
        preferences: true,
        analytics: true,
        marketing: true,
        version: "2020-01-01",
        decidedAt: new Date().toISOString(),
      }),
    );
    render(<CookieConsent />);

    // A materially changed policy re-asks rather than inheriting the old answer.
    expect(await screen.findByRole("button", { name: "Accept all" })).toBeInTheDocument();
    expect(hasConsent("analytics")).toBe(false);
  });

  it("can be reopened from the footer after a decision", async () => {
    render(
      <>
        <CookieConsent />
        <CookiePreferencesButton />
      </>,
    );
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Accept all" }));
    await waitFor(() =>
      expect(screen.queryByRole("button", { name: "Manage preferences" })).not.toBeInTheDocument(),
    );

    await user.click(screen.getByRole("button", { name: "Cookie Preferences" }));

    expect(await screen.findByRole("dialog")).toBeInTheDocument();
    expect(screen.getByText("Strictly necessary")).toBeInTheDocument();
    expect(screen.getByText("Always active")).toBeInTheDocument();
  });

  it("saves a partial choice from the preference centre", async () => {
    render(<CookieConsent />);
    const user = userEvent.setup();
    await user.click(await screen.findByRole("button", { name: "Manage preferences" }));

    await user.click(screen.getByRole("checkbox", { name: "Analytics" }));
    await user.click(screen.getByRole("button", { name: "Save preferences" }));

    expect(hasConsent("analytics")).toBe(true);
    expect(hasConsent("marketing")).toBe(false);
  });
});

describe("in-product safety notices", () => {
  it("states the AI review requirement and links the full disclaimer", () => {
    render(<SafetyNotice kind="ai-analysis" />);

    expect(screen.getByRole("note")).toHaveTextContent(/advisory/);
    expect(screen.getByRole("link", { name: /Read the full disclaimer/ })).toHaveAttribute(
      "href",
      "/industrial-disclaimer",
    );
  });

  it("says the platform is not an emergency-response system on safety screens", () => {
    render(<SafetyNotice kind="safety-report" />);
    expect(screen.getByRole("note")).toHaveTextContent(/not an emergency-response or life-safety/);
  });

  it("says a digital permit approval does not confirm the area is safe", () => {
    render(<SafetyNotice kind="permit-to-work" />);
    expect(screen.getByRole("note")).toHaveTextContent(/does not by itself confirm/);
  });
});

describe("the contact form", () => {
  it("offers every published category", async () => {
    render(<ContactForm client={{ submitContactMessage: vi.fn() }} />);
    const options = within(screen.getByLabelText("Category")).getAllByRole("option");
    expect(options.map((option) => option.textContent)).toEqual([...CONTACT_CATEGORIES]);
  });

  it("opens on the category a topic link asked for", () => {
    // The pricing page's "Request a quote" sends ?topic=enterprise. Landing on
    // "General Question" would make an Enterprise lead look like support mail.
    render(<ContactForm client={{ submitContactMessage: vi.fn() }} topic="enterprise" />);

    expect(screen.getByLabelText("Category")).toHaveValue("Enterprise / SSO");
  });

  it("ignores a topic it does not publish a category for", () => {
    // A stale or hand-edited link must not put an unoffered value in the
    // select, which the API would refuse after the message had been typed.
    render(<ContactForm client={{ submitContactMessage: vi.fn() }} topic="not-a-topic" />);

    expect(screen.getByLabelText("Category")).toHaveValue(CONTACT_CATEGORIES[0]);
  });

  it("warns against sending credentials or card numbers", () => {
    render(<ContactForm client={{ submitContactMessage: vi.fn() }} />);
    expect(
      screen.getByText(/Never include passwords, access tokens, complete payment-card/),
    ).toBeInTheDocument();
  });

  it("validates before sending anything", async () => {
    const submitContactMessage = vi.fn();
    render(<ContactForm client={{ submitContactMessage }} />);
    const user = userEvent.setup();

    await user.click(screen.getByRole("button", { name: "Send message" }));

    expect(screen.getByText("Your name is required")).toBeInTheDocument();
    expect(screen.getByText("Email is required")).toBeInTheDocument();
    expect(submitContactMessage).not.toHaveBeenCalled();
  });

  it("confirms receipt in the wording the package specifies", async () => {
    const submitContactMessage = vi.fn(async () => ({ received: true }));
    render(<ContactForm client={{ submitContactMessage }} />);
    const user = userEvent.setup();

    await user.type(screen.getByLabelText("Your name"), "Dana Okafor");
    await user.type(screen.getByLabelText("Email"), "dana@operator.example");
    await user.type(screen.getByLabelText("Subject"), "Access question");
    await user.type(screen.getByLabelText("Message"), "How do I add a seat?");
    await user.click(screen.getByRole("button", { name: "Send message" }));

    expect(await screen.findByText("Message received")).toBeInTheDocument();
    expect(screen.getByText(/our team will review your request/i)).toBeInTheDocument();
    expect(submitContactMessage).toHaveBeenCalledWith(
      expect.objectContaining({ category: "General Question", name: "Dana Okafor" }),
    );
  });

  it("falls back to a direct address when sending fails", async () => {
    const submitContactMessage = vi.fn(async () => {
      throw new Error("offline");
    });
    render(<ContactForm client={{ submitContactMessage }} />);
    const user = userEvent.setup();

    await user.type(screen.getByLabelText("Your name"), "Dana");
    await user.type(screen.getByLabelText("Email"), "dana@operator.example");
    await user.type(screen.getByLabelText("Subject"), "Hi");
    await user.type(screen.getByLabelText("Message"), "Hello");
    await user.click(screen.getByRole("button", { name: "Send message" }));

    // A failed form must not swallow the message with no way to reach anyone.
    expect(await screen.findByRole("alert")).toHaveTextContent(OPERATOR.email);
  });
});
