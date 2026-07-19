import type { MetadataRoute } from "next";

import { site } from "@/seo/site";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: ["/login", "/signup", "/forgot-password"],
        // Everything inside the app shell is private.
        disallow: ["/"],
      },
    ],
    sitemap: `${site.baseUrl}/sitemap.xml`,
  };
}
