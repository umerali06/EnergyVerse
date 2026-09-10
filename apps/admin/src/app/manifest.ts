import type { MetadataRoute } from "next";

import { APP_HOME } from "@/navigation/routes";
import { site } from "@/seo/site";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: site.name,
    short_name: site.shortName,
    description: site.description,
    // Installed as an app, it should open the dashboard, not the marketing page.
    start_url: APP_HOME,
    display: "standalone",
    // Light is the default theme (D-009 revision), so the install splash
    // should match it rather than flashing the dark surface.
    background_color: site.lightThemeColor,
    theme_color: site.lightThemeColor,
    icons: [
      { src: "/brand/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/brand/icon-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
    ],
  };
}
