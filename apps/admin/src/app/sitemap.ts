import type { MetadataRoute } from "next";

import { publicRoutes, site } from "@/seo/site";

export default function sitemap(): MetadataRoute.Sitemap {
  return publicRoutes.map((route) => ({
    url: `${site.baseUrl}${route}`,
    changeFrequency: "monthly",
    priority: route === "/login" ? 1 : 0.6,
  }));
}
