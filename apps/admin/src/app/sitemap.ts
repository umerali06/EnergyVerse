import type { MetadataRoute } from "next";

import { marketingRoutes } from "@/navigation/routes";
import { publicRoutes, site } from "@/seo/site";

/** Priority by intent: the landing page first, then the rest of the marketing
 * site, then the auth entry points, which exist to be reachable rather than
 * ranked. */
function priorityFor(route: string): number {
  if (route === "/") return 1;
  if ((marketingRoutes as readonly string[]).includes(route)) return 0.8;
  return 0.5;
}

export default function sitemap(): MetadataRoute.Sitemap {
  return publicRoutes.map((route) => ({
    // "/" would append a trailing slash the page's own canonical tag omits;
    // emitting the bare origin keeps the two forms identical.
    url: route === "/" ? site.baseUrl : `${site.baseUrl}${route}`,
    changeFrequency: "monthly",
    priority: priorityFor(route),
  }));
}
