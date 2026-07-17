"use client";

import type { CurrentUser } from "@fev/api-client";
import {
  createContext,
  type ReactNode,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";

import { ApiClientError, FevApiClient } from "@/api";
import { useToast } from "@/design-system";

import {
  ClientAuthError,
  FirebaseAuthGateway,
  type AuthGateway,
  type AuthSession,
} from "./firebase-gateway";

export type AuthStatus = "restoring" | "signedOut" | "signingIn" | "authenticated";

type AuthContextValue = {
  currentUser: CurrentUser | null;
  error: string | null;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  status: AuthStatus;
};

const AuthContext = createContext<AuthContextValue | null>(null);

const invalidCredentialCodes = new Set([
  "auth/invalid-credential",
  "auth/invalid-login-credentials",
  "auth/user-not-found",
  "auth/wrong-password",
]);

export function friendlyAuthMessage(error: unknown): string {
  if (error instanceof ClientAuthError) {
    if (invalidCredentialCodes.has(error.code)) return "Invalid email or password";
    if (error.code === "auth/user-disabled") return "This account has been disabled";
    if (error.code === "auth/too-many-requests") {
      return "Too many login attempts. Please wait and try again";
    }
    if (error.code === "auth/network-request-failed") {
      return "Network unavailable. Check your connection and try again";
    }
  }
  if (error instanceof ApiClientError) {
    if (error.status === 403) return "Your account isn't active — contact your admin.";
    if (error.code === "network_error") {
      return "Network unavailable. Check your connection and try again";
    }
  }
  return "Unable to sign in. Please try again";
}

export function AuthProvider({
  apiClient,
  children,
  gateway,
}: {
  apiClient?: Pick<FevApiClient, "getCurrentUser">;
  children: ReactNode;
  gateway?: AuthGateway;
}) {
  const toast = useToast();
  const authGateway = useMemo(() => gateway ?? new FirebaseAuthGateway(), [gateway]);
  const client = useMemo(
    () => apiClient ?? new FevApiClient({ getIdToken: () => authGateway.getIdToken() }),
    [apiClient, authGateway],
  );
  const [currentUser, setCurrentUser] = useState<CurrentUser | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [status, setStatus] = useState<AuthStatus>("restoring");
  const resolution = useRef<Promise<void> | null>(null);
  const resolutionUid = useRef<string | null>(null);

  const fail = useCallback(
    (failure: unknown) => {
      const message = friendlyAuthMessage(failure);
      setCurrentUser(null);
      setError(message);
      setStatus("signedOut");
      toast.error(message);
    },
    [toast],
  );

  const resolveSession = useCallback(
    async (session: AuthSession) => {
      if (resolution.current && resolutionUid.current === session.uid) {
        await resolution.current;
        return;
      }
      resolutionUid.current = session.uid;
      resolution.current = (async () => {
        try {
          const identity = await client.getCurrentUser();
          setCurrentUser(identity);
          setError(null);
          setStatus("authenticated");
        } catch (failure) {
          if (failure instanceof ApiClientError && failure.status === 403) {
            await authGateway.signOut();
          }
          fail(failure);
        } finally {
          resolution.current = null;
          resolutionUid.current = null;
        }
      })();
      await resolution.current;
    },
    [authGateway, client, fail],
  );

  useEffect(() => {
    try {
      return authGateway.observe((session) => {
        if (session) {
          void resolveSession(session);
        } else {
          setCurrentUser(null);
          setStatus((current) => (current === "signingIn" ? current : "signedOut"));
        }
      });
    } catch (failure) {
      fail(failure);
      return undefined;
    }
  }, [authGateway, fail, resolveSession]);

  const signIn = useCallback(
    async (email: string, password: string) => {
      if (status === "signingIn") return;
      setError(null);
      setStatus("signingIn");
      try {
        const session = await authGateway.signIn(email, password);
        await resolveSession(session);
      } catch (failure) {
        fail(failure);
      }
    },
    [authGateway, fail, resolveSession, status],
  );

  const signOutCurrentUser = useCallback(async () => {
    try {
      await authGateway.signOut();
    } finally {
      setCurrentUser(null);
      setError(null);
      setStatus("signedOut");
    }
  }, [authGateway]);

  const value = useMemo<AuthContextValue>(
    () => ({ currentUser, error, signIn, signOut: signOutCurrentUser, status }),
    [currentUser, error, signIn, signOutCurrentUser, status],
  );
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) throw new Error("useAuth requires AuthProvider");
  return context;
}
