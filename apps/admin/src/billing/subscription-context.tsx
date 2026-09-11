"use client";

import {
  createContext,
  type ReactNode,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";

import { AuthContext } from "@/auth/auth-context";
import type { SubscriptionResponse } from "@fev/api-client";

/**
 * The company's plan, loaded once for the whole shell.
 *
 * `features` from the API is the authoritative list — the shell must never
 * derive entitlements from the tier name, because that would put the tier ->
 * feature mapping in two places and let a repricing silently disagree with the
 * server (D-093).
 *
 * The loading state matters for correctness, not just polish: rendering nav
 * before the plan is known would either flash modules a Starter tenant does not
 * have, or hide ones an Enterprise tenant does. `status` lets consumers wait.
 */

export type SubscriptionStatus = "loading" | "ready" | "error";

type SubscriptionContextValue = {
  status: SubscriptionStatus;
  subscription: SubscriptionResponse | null;
  /** Whether the company's plan includes a feature key. Answers `false` while
   * loading and on error — failing closed, matching the API's 402. */
  hasFeature: (feature: string | undefined) => boolean;
  refresh: () => Promise<void>;
};

const SubscriptionContext = createContext<SubscriptionContextValue | null>(null);

export function SubscriptionProvider({
  children,
  /** Injected by tests; production reads it from the API. */
  initialSubscription,
}: {
  children: ReactNode;
  initialSubscription?: SubscriptionResponse | null;
}) {
  // Read the auth context directly rather than through `useAuth`, which
  // throws: handed an `initialSubscription` this provider needs no auth at all,
  // and requiring one would force every widget test to mount a Firebase
  // gateway it does not otherwise use.
  const auth = useContext(AuthContext);
  const [subscription, setSubscription] = useState<SubscriptionResponse | null>(
    initialSubscription ?? null,
  );
  const [status, setStatus] = useState<SubscriptionStatus>(
    initialSubscription ? "ready" : "loading",
  );

  const load = useCallback(
    async (signal?: AbortSignal) => {
      if (!auth) return;
      try {
        const next = await auth.apiClient.getSubscription(signal);
        setSubscription(next);
        setStatus("ready");
      } catch {
        if (!signal?.aborted) setStatus("error");
      }
    },
    [auth],
  );

  useEffect(() => {
    if (initialSubscription) return;
    // Only an authenticated session can read a subscription; anything earlier
    // would 401 and set an error state the user cannot act on.
    if (auth?.status !== "authenticated") return;
    const controller = new AbortController();
    void load(controller.signal);
    return () => controller.abort();
  }, [auth?.status, initialSubscription, load]);

  const value = useMemo<SubscriptionContextValue>(() => {
    const granted = new Set(subscription?.features ?? []);
    return {
      status,
      subscription,
      hasFeature: (feature) => {
        // An ungated item is part of every plan.
        if (!feature) return true;
        if (status !== "ready" || subscription?.isEntitled !== true) return false;
        return granted.has(feature);
      },
      refresh: () => load(),
    };
  }, [load, status, subscription]);

  return <SubscriptionContext.Provider value={value}>{children}</SubscriptionContext.Provider>;
}

export function useSubscription(): SubscriptionContextValue {
  const context = useContext(SubscriptionContext);
  if (context === null) throw new Error("useSubscription requires SubscriptionProvider");
  return context;
}
