import type { Metadata, Viewport } from "next";
import localFont from "next/font/local";
import { AuthProvider } from "@/auth/auth-context";
import { ApiCacheProvider } from "@/cache/cache-context";
import { ThemeProvider, ToastProvider } from "@/design-system";
import "./globals.css";

const plexSans = localFont({
  src: "../assets/fonts/IBMPlexSans-Variable.ttf",
  variable: "--font-plex-sans",
  weight: "100 700",
});
const spaceGrotesk = localFont({
  src: "../assets/fonts/SpaceGrotesk-Variable.ttf",
  variable: "--font-space-grotesk",
  weight: "300 700",
});
const plexMono = localFont({
  src: [
    { path: "../assets/fonts/IBMPlexMono-Regular.ttf", weight: "400" },
    { path: "../assets/fonts/IBMPlexMono-Medium.ttf", weight: "500" },
    { path: "../assets/fonts/IBMPlexMono-SemiBold.ttf", weight: "600" },
  ],
  variable: "--font-plex-mono",
});

import { site } from "@/seo/site";

export const metadata: Metadata = {
  metadataBase: new URL(site.baseUrl),
  title: { default: site.name, template: site.titleTemplate },
  description: site.description,
  applicationName: site.name,
  appleWebApp: { title: site.shortName },
  icons: {
    icon: "/favicon.ico",
    apple: "/brand/apple-touch-icon.png",
  },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: dark)", color: site.themeColor },
    { media: "(prefers-color-scheme: light)", color: site.lightThemeColor },
  ],
};

const jsonLd = {
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      name: "Flacron Enterprises",
      url: site.baseUrl,
      logo: `${site.baseUrl}/brand/logo-mark-light.png`,
    },
    {
      "@type": "SoftwareApplication",
      name: site.name,
      applicationCategory: "BusinessApplication",
      operatingSystem: "Web, Android, iOS",
      description: site.description,
    },
  ],
};

// Runs before first paint. Restores the stored theme so a visitor who chose
// dark never sees a light flash, and marks the document as JS-capable so the
// marketing site's scroll reveals may start hidden — without JS the class is
// absent and that content renders visible instead of stuck at opacity 0.
const themeBootstrap = `(function(){var d=document.documentElement;d.classList.add("js-anim");try{var t=localStorage.getItem("fev-theme");if(t==="dark"){d.dataset.theme="dark";d.classList.add("dark");}}catch(e){}})();`;

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      className={`${plexSans.variable} ${spaceGrotesk.variable} ${plexMono.variable}`}
      data-theme="light"
      lang="en"
      suppressHydrationWarning
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeBootstrap }} />
      </head>
      {/* Browser extensions (password managers, color pickers) inject
          attributes onto <body> before React hydrates, which React reports as
          a mismatch it cannot patch. The server and client trees are identical
          here, so the warning is suppressed at this node only. */}
      <body suppressHydrationWarning>
        <script
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
          type="application/ld+json"
        />
        <ThemeProvider>
          <ToastProvider>
            <AuthProvider>
              <ApiCacheProvider>{children}</ApiCacheProvider>
            </AuthProvider>
          </ToastProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
