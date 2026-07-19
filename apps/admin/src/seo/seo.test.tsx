import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import manifest from "@/app/manifest";
import robots from "@/app/robots";
import sitemap from "@/app/sitemap";
import { Logo, ThemeProvider } from "@/design-system";
import { designTokens } from "@/design-system/tokens.generated";

import { protectedPage, publicPage, publicRoutes, site } from "./site";

// Colocated route metadata (server page files export it declaratively).
import { metadata as forgotMeta } from "@/app/(public)/forgot-password/page";
import { metadata as loginMeta } from "@/app/(public)/login/page";
import { metadata as signupMeta } from "@/app/(public)/signup/page";
import { metadata as missingMeta } from "@/app/(protected)/[...missing]/page";
import { metadata as assetsMeta } from "@/app/(protected)/assets/page";
import { metadata as documentsMeta } from "@/app/(protected)/documents/page";
import { metadata as dashboardMeta } from "@/app/(protected)/page";
import { metadata as rbacMeta } from "@/app/(protected)/rbac-demo/page";
import { metadata as reportsMeta } from "@/app/(protected)/reports/page";
import { metadata as settingsMeta } from "@/app/(protected)/settings/page";
import { metadata as verifyMeta } from "@/app/verify-email/page";

const publicMetas = { loginMeta, signupMeta, forgotMeta };
const protectedMetas = {
  dashboardMeta,
  assetsMeta,
  documentsMeta,
  reportsMeta,
  settingsMeta,
  rbacMeta,
  verifyMeta,
  missingMeta,
};

describe("seo metadata", () => {
  it("gives public routes full SEO with canonical, OG, and index directives", () => {
    for (const meta of Object.values(publicMetas)) {
      expect(meta.title).toBeTruthy();
      expect(meta.description).toBeTruthy();
      expect(meta.robots).toMatchObject({ index: true, follow: true });
      expect(String(meta.alternates?.canonical)).toContain(site.baseUrl);
      expect(meta.openGraph?.images).toBeTruthy();
      expect(meta.twitter).toMatchObject({ card: "summary_large_image" });
    }
  });

  it("keeps protected routes out of indexes but titled for tabs and history", () => {
    for (const meta of Object.values(protectedMetas)) {
      expect(meta.title).toBeTruthy();
      expect(meta.robots).toMatchObject({ index: false, follow: false });
    }
  });

  it("uses a unique non-empty title on every route", () => {
    const titles = [...Object.values(publicMetas), ...Object.values(protectedMetas)].map(
      (meta) => String(meta.title),
    );
    expect(new Set(titles).size).toBe(titles.length);
    for (const title of titles) expect(title.length).toBeGreaterThan(2);
  });

  it("disallows the app in robots.txt while allowing public routes and the sitemap", () => {
    const rules = robots().rules;
    const rule = Array.isArray(rules) ? rules[0] : rules;
    expect(rule?.disallow).toContain("/");
    for (const route of publicRoutes) expect(rule?.allow).toContain(route);
    expect(robots().sitemap).toBe(`${site.baseUrl}/sitemap.xml`);
  });

  it("lists exactly the public routes in the sitemap", () => {
    const urls = sitemap().map((entry) => entry.url);
    expect(urls).toEqual(publicRoutes.map((route) => `${site.baseUrl}${route}`));
  });

  it("builds the PWA manifest from brand tokens", () => {
    const m = manifest();
    expect(m.name).toBe(site.name);
    expect(m.short_name).toBe("FEV");
    expect(m.theme_color).toBe(designTokens.color.theme.dark.background);
    expect(m.icons?.map((icon) => icon.src)).toEqual([
      "/brand/icon-192.png",
      "/brand/icon-512.png",
    ]);
  });

  it("derives helper metadata consistently", () => {
    expect(protectedPage("X").robots).toEqual({ index: false, follow: false });
    expect(publicPage("T", "D", "/login").openGraph?.url).toBe(`${site.baseUrl}/login`);
  });
});

describe("brand logo component", () => {
  it.each(["mark", "wordmark", "full"] as const)(
    "renders the themed %s asset with an accessible name",
    (variant) => {
      window.localStorage.setItem("fev-theme", "dark");
      render(
        <ThemeProvider>
          <Logo variant={variant} />
        </ThemeProvider>,
      );
      const img = screen.getByRole("img", { name: "Flacron EnergyVerse" });
      expect(img).toHaveAttribute("src", `/brand/logo-${variant}-dark.png`);
    },
  );

  it("switches assets with the active theme", () => {
    window.localStorage.setItem("fev-theme", "light");
    render(
      <ThemeProvider>
        <Logo />
      </ThemeProvider>,
    );
    expect(screen.getByRole("img", { name: "Flacron EnergyVerse" })).toHaveAttribute(
      "src",
      "/brand/logo-wordmark-light.png",
    );
  });

  it("hides decorative instances from the accessibility tree", () => {
    window.localStorage.setItem("fev-theme", "dark");
    const { container } = render(
      <ThemeProvider>
        <Logo decorative variant="mark" />
      </ThemeProvider>,
    );
    expect(screen.queryByRole("img")).not.toBeInTheDocument();
    expect(container.querySelector("img")).toHaveAttribute("aria-hidden", "true");
  });
});
