import type { MetadataRoute } from "next";

import { privateRoutePrefixes } from "@/navigation/routes";
import { publicRoutes, site } from "@/seo/site";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        // The marketing pages and the auth entry points are the public site.
        allow: [...publicRoutes],
        // Everything behind the app shell is private. Listed as explicit
        // prefixes rather than a blanket "/" now that "/" is the landing page.
        disallow: [...privateRoutePrefixes],
      },
    ],
    sitemap: `${site.baseUrl}/sitemap.xml`,
  };
}
