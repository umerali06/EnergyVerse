"use client";

import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { createContext, type ReactNode, useCallback, useContext, useMemo, useState } from "react";

import { motionSpec } from "./motion";
import type { StatusTone } from "./primitives";

type ToastItem = { id: number; message: string; tone: StatusTone };
export type ToastApi = {
  showToast: (message: string, tone?: StatusTone) => void;
  success: (message: string) => void;
  error: (message: string) => void;
  warning: (message: string) => void;
  info: (message: string) => void;
};

const ToastContext = createContext<ToastApi | null>(null);

export function ToastProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<ToastItem[]>([]);
  const reduced = useReducedMotion();
  const showToast = useCallback((message: string, tone: StatusTone = "info") => {
    const id = Date.now() + Math.random();
    setItems((current) => [...current, { id, message, tone }]);
    window.setTimeout(() => setItems((current) => current.filter((item) => item.id !== id)), 3200);
  }, []);
  const value = useMemo<ToastApi>(
    () => ({
      showToast,
      success: (message) => showToast(message, "healthy"),
      error: (message) => showToast(message, "critical"),
      warning: (message) => showToast(message, "warning"),
      info: (message) => showToast(message, "info"),
    }),
    [showToast],
  );

  return (
    <ToastContext.Provider value={value}>
      {children}
      <div
        aria-live="polite"
        className="fixed bottom-4 right-4 z-toast grid w-[min(24rem,calc(100vw-2rem))] gap-2"
      >
        <AnimatePresence>
          {items.map((item) => (
            <motion.div
              animate={{ opacity: 1, x: 0 }}
              className="rounded-xl border border-border bg-elevated p-4 text-body text-text-primary shadow-lg"
              exit={{ opacity: 0, x: reduced ? 0 : 12 }}
              initial={reduced ? false : { opacity: 0, x: 20 }}
              key={item.id}
              role="status"
              transition={{ duration: reduced ? 0 : motionSpec.normal }}
            >
              <span className="font-semibold capitalize">{item.tone}</span> · {item.message}
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastApi {
  const context = useContext(ToastContext);
  if (context === null) throw new Error("useToast requires ToastProvider");
  return context;
}
