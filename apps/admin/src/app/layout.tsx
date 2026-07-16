import type { Metadata } from "next";
import localFont from "next/font/local";
import { ApiProvider } from "@/api";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";
import "./globals.css";

const inter = localFont({
  src: "../assets/fonts/Inter-Variable.ttf",
  variable: "--font-inter",
  weight: "100 900",
});
const jetbrainsMono = localFont({
  src: "../assets/fonts/JetBrainsMono-Variable.ttf",
  variable: "--font-jetbrains-mono",
  weight: "100 800",
});

export const metadata: Metadata = {
  title: "FEV Admin",
  description: "Flacron EnergyVerse Admin Dashboard",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      className={`dark ${inter.variable} ${jetbrainsMono.variable}`}
      data-theme="dark"
      lang="en"
      suppressHydrationWarning
    >
      <body>
        <ThemeProvider>
          <ToastProvider>
            <ApiProvider>
              <PermissionProvider>{children}</PermissionProvider>
            </ApiProvider>
          </ToastProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
