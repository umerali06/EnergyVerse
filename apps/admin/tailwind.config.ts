import type { Config } from "tailwindcss";
import { designTokens } from "./src/design-system/tokens.generated";

const pixels = (values: Record<string, number>) =>
  Object.fromEntries(Object.entries(values).map(([key, value]) => [key, `${value}px`]));

const config: Config = {
  darkMode: "class",
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        primary: designTokens.color.primary,
        accent: designTokens.color.accent,
        status: designTokens.color.status,
        statusStrong: designTokens.color.statusStrong,
        statusSoft: designTokens.color.statusSoft,
        background: "var(--color-background)",
        surface: "var(--color-surface)",
        elevated: "var(--color-elevated)",
        border: "var(--color-border)",
        "text-primary": "var(--color-text-primary)",
        "text-secondary": "var(--color-text-secondary)",
        "text-muted": "var(--color-text-muted)",
      },
      spacing: pixels(designTokens.spacing),
      borderRadius: pixels(designTokens.radius),
      boxShadow: designTokens.shadow,
      zIndex: Object.fromEntries(
        Object.entries(designTokens.zIndex).map(([key, value]) => [key, String(value)]),
      ),
      fontFamily: {
        sans: ["var(--font-plex-sans)", designTokens.typography.fontFamily.sans, "sans-serif"],
        heading: [
          "var(--font-space-grotesk)",
          designTokens.typography.fontFamily.heading,
          "sans-serif",
        ],
        mono: ["var(--font-plex-mono)", designTokens.typography.fontFamily.mono, "monospace"],
      },
      fontSize: Object.fromEntries(
        Object.entries(designTokens.typography.fontSize).map(([key, value]) => [
          key,
          [`${value}px`, { lineHeight: key.startsWith("h") ? "1.25" : "1.5" }],
        ]),
      ),
      keyframes: {
        shimmer: {
          "0%": { backgroundPosition: "200% 0" },
          "100%": { backgroundPosition: "-200% 0" },
        },
      },
      animation: {
        shimmer: "shimmer 1.6s var(--ease-standard) infinite",
      },
    },
  },
  plugins: [],
};

export default config;
