"use client";

import { createContext, type ReactNode, useContext, useEffect, useMemo, useState } from "react";

export type AppTheme = "dark" | "light";

type ThemeContextValue = {
  theme: AppTheme;
  setTheme: (theme: AppTheme) => void;
  toggleTheme: () => void;
};

const STORAGE_KEY = "fev-theme";
const ThemeContext = createContext<ThemeContextValue | null>(null);

function applyTheme(theme: AppTheme) {
  document.documentElement.dataset.theme = theme;
  document.documentElement.classList.toggle("dark", theme === "dark");
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<AppTheme>("light");

  useEffect(() => {
    const saved = window.localStorage.getItem(STORAGE_KEY);
    const initial = saved === "light" || saved === "dark" ? saved : "light";
    setThemeState(initial);
    applyTheme(initial);
  }, []);

  const value = useMemo<ThemeContextValue>(() => {
    const setTheme = (next: AppTheme) => {
      setThemeState(next);
      window.localStorage.setItem(STORAGE_KEY, next);
      applyTheme(next);
    };
    return {
      theme,
      setTheme,
      toggleTheme: () => setTheme(theme === "dark" ? "light" : "dark"),
    };
  }, [theme]);

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

export function useTheme(): ThemeContextValue {
  const context = useContext(ThemeContext);
  if (context === null) throw new Error("useTheme requires ThemeProvider");
  return context;
}

export function ThemeSwitch() {
  const { theme, toggleTheme } = useTheme();
  return (
    <button
      aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} theme`}
      className="min-h-10 rounded-full border bg-surface px-4 text-bodySmall font-semibold text-text-secondary transition-colors hover:border-primary-400 hover:text-text-primary"
      onClick={toggleTheme}
      type="button"
    >
      {theme === "dark" ? "Light mode" : "Dark mode"}
    </button>
  );
}

/**
 * Bare icon theme toggle — glyph only, with a hover halo for affordance and no
 * resting border or fill. The design-system `ThemeSwitch` is a labelled pill,
 * right for a settings surface but far too heavy beside a header's real
 * actions: three boxed controls in a row read as a toolbar. Used by both the
 * app shell's top bar and the public site. The accessible name says what the
 * control does; the icon shows the theme it switches *to*.
 */
export function ThemeToggleIcon() {
  const { theme, toggleTheme } = useTheme();
  const goingDark = theme === "light";
  return (
    <button
      aria-label={`Switch to ${goingDark ? "dark" : "light"} theme`}
      className="grid size-9 shrink-0 place-items-center rounded-full text-text-secondary transition-colors hover:bg-elevated hover:text-text-primary"
      onClick={toggleTheme}
      title={`Switch to ${goingDark ? "dark" : "light"} theme`}
      type="button"
    >
      {goingDark ? (
        <svg
          aria-hidden
          className="size-4"
          fill="none"
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="1.9"
          viewBox="0 0 24 24"
        >
          <path d="M21 12.8A8.5 8.5 0 1 1 11.2 3a6.6 6.6 0 0 0 9.8 9.8z" />
        </svg>
      ) : (
        <svg
          aria-hidden
          className="size-4"
          fill="none"
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="1.9"
          viewBox="0 0 24 24"
        >
          <circle cx="12" cy="12" r="4.2" />
          <path d="M12 2v2.4M12 19.6V22M2 12h2.4M19.6 12H22M4.9 4.9l1.7 1.7M17.4 17.4l1.7 1.7M19.1 4.9l-1.7 1.7M6.6 17.4l-1.7 1.7" />
        </svg>
      )}
    </button>
  );
}
