import type { Metadata } from "next";
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

export const metadata: Metadata = {
  title: "FEV Admin",
  description: "Flacron EnergyVerse Admin Dashboard",
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
        <ThemeProvider>
          <ToastProvider>
            <AuthProvider>{children}</AuthProvider>
          </ToastProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
