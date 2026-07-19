import { designTokens } from "@/design-system/tokens.generated";

/** Central site identity for metadata. Per-page titles/descriptions stay
 * colocated with each route; this file only defines shared defaults. */
export const site = {
  name: "Flacron EnergyVerse",
  shortName: "FEV",
  description:
    "Flacron EnergyVerse is the field operations intelligence platform for energy companies: assets, inspections, work orders, permits, and safety in one place.",
  baseUrl: process.env.NEXT_PUBLIC_SITE_URL ?? "https://app.flacronenergyverse.com",
  titleTemplate: "%s · FEV",
  themeColor: designTokens.color.theme.dark.background,
  lightThemeColor: designTokens.color.theme.light.background,
  ogImage: "/brand/og-image.png",
} as const;

export const publicRoutes = ["/login", "/signup", "/forgot-password"] as const;

/** Standard metadata for a protected in-shell route: descriptive tab title,
 * never indexed. Colocate a call to this in every protected page. */
export function protectedPage(title: string) {
  return {
    title,
    robots: { index: false, follow: false },
  };
}

/** Full-SEO metadata for a public route. */
export function publicPage(title: string, description: string, path: string) {
  return {
    title,
    description,
    alternates: { canonical: `${site.baseUrl}${path}` },
    robots: { index: true, follow: true },
    openGraph: {
      title: `${title} · FEV`,
      description,
      url: `${site.baseUrl}${path}`,
      siteName: site.name,
      images: [{ url: site.ogImage, width: 1200, height: 630 }],
      type: "website",
    },
    twitter: {
      card: "summary_large_image",
      title: `${title} · FEV`,
      description,
      images: [site.ogImage],
    },
  };
}
