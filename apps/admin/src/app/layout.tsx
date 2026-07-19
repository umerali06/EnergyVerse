import type { Metadata, Viewport } from "next";
import localFont from "next/font/local";
import { AuthProvider } from "@/auth/auth-context";
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

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      className={`dark ${plexSans.variable} ${spaceGrotesk.variable} ${plexMono.variable}`}
      data-theme="dark"
      lang="en"
      suppressHydrationWarning
    >
      <body>
        <script
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
          type="application/ld+json"
        />
        <ThemeProvider>
          <ToastProvider>
            <AuthProvider>{children}</AuthProvider>
          </ToastProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
