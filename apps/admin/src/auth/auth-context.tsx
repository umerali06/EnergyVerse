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

export type AuthStatus =
  | "restoring"
  | "signedOut"
  | "signingIn"
  | "signingUp"
  | "sendingPasswordReset"
  | "verificationRequired"
  | "checkingVerification"
  | "authenticated";

export type RegistrationInput = {
  companyName: string;
  displayName: string;
  email: string;
  password: string;
};

/** Data-fetching hooks (dashboard and future modules) share the single
 * FevApiClient instance AuthProvider constructs, so token injection, 401
 * retry, and session-expiry all stay centralized in one place. */
export type DashboardApiClient = Pick<
  FevApiClient,
  "getDashboardActivity" | "getDashboardActivitySeries" | "getDashboardSummary"
>;

type AuthContextValue = {
  apiClient: DashboardApiClient;
  currentUser: CurrentUser | null;
  error: string | null;
  refreshSession: () => Promise<void>;
  refreshVerification: () => Promise<void>;
  register: (input: RegistrationInput) => Promise<void>;
  resendVerification: () => Promise<boolean>;
  sendPasswordReset: (email: string) => Promise<boolean>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  status: AuthStatus;
  verificationSentAt: number | null;
  passwordResetSentAt: number | null;
};

export const sessionExpiredMessage = "Your session has expired. Please sign in again";

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
    if (error.code === "email_already_in_use") {
      return "An account already exists for this email";
    }
    if (error.status === 403) return "Your account isn't active — contact your admin.";
    if (error.code === "network_error") {
      return "Network unavailable. Check your connection and try again";
    }
  }
  return "Unable to sign in. Please try again";
}

export function friendlyPasswordResetMessage(error: unknown): string {
  if (error instanceof ClientAuthError) {
    if (error.code === "auth/too-many-requests") {
      return "Too many reset attempts. Please wait and try again";
    }
    if (error.code === "auth/network-request-failed") {
      return "Network unavailable. Check your connection and try again";
    }
  }
  return "Unable to send the reset link. Please try again";
}

export function AuthProvider({
  apiClient,
  children,
  gateway,
}: {
  apiClient?: Pick<FevApiClient, "getCurrentUser" | "registerCompanyAdmin"> &
    Partial<DashboardApiClient>;
  children: ReactNode;
  gateway?: AuthGateway;
}) {
  const toast = useToast();
  const authGateway = useMemo(() => gateway ?? new FirebaseAuthGateway(), [gateway]);
  const expireRef = useRef<() => Promise<void>>(async () => undefined);
  const client = useMemo(
    () =>
      apiClient ??
      new FevApiClient({
        getIdToken: () => authGateway.getIdToken(),
        onUnauthorized: () => expireRef.current(),
        refreshIdToken: () => authGateway.getIdToken(true),
      }),
    [apiClient, authGateway],
  );
  const [currentUser, setCurrentUser] = useState<CurrentUser | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [status, setStatus] = useState<AuthStatus>("restoring");
  const [verificationSentAt, setVerificationSentAt] = useState<number | null>(null);
  const [passwordResetSentAt, setPasswordResetSentAt] = useState<number | null>(null);
  const resolution = useRef<Promise<void> | null>(null);
  const resolutionUid = useRef<string | null>(null);
  const expiring = useRef(false);

  const expireSession = useCallback(async () => {
    // The flag stays set until a fresh sign-in attempt: the API hook and the
    // resolve path both report the same dead session, but only once.
    if (expiring.current) return;
    expiring.current = true;
    try {
      await authGateway.signOut();
    } catch {
      // The local session is cleared regardless of the provider call outcome.
    } finally {
      setCurrentUser(null);
      setError(null);
      setStatus("signedOut");
      toast.error(sessionExpiredMessage);
    }
  }, [authGateway, toast]);
  useEffect(() => {
    expireRef.current = expireSession;
  }, [expireSession]);

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
          setStatus(identity.emailVerified ? "authenticated" : "verificationRequired");
        } catch (failure) {
          if (failure instanceof ApiClientError && failure.status === 401) {
            // Token refresh + retry already failed inside the client: the session
            // is dead. expireSession is idempotent, so the client's own
            // onUnauthorized hook and this path never double-toast.
            await expireSession();
            return;
          }
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
    [authGateway, client, expireSession, fail],
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
      expiring.current = false;
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

  const register = useCallback(
    async (input: RegistrationInput) => {
      if (status === "signingUp") return;
      expiring.current = false;
      setError(null);
      setStatus("signingUp");
      try {
        await client.registerCompanyAdmin(input);
        const session = await authGateway.signIn(input.email, input.password);
        await resolveSession(session);
        try {
          await authGateway.sendEmailVerification();
          setVerificationSentAt(Date.now());
          toast.success("Verification email sent");
        } catch (failure) {
          toast.error(friendlyAuthMessage(failure));
        }
      } catch (failure) {
        fail(failure);
      }
    },
    [authGateway, client, fail, resolveSession, status, toast],
  );

  const resendVerification = useCallback(async () => {
    try {
      await authGateway.sendEmailVerification();
      setVerificationSentAt(Date.now());
      toast.success("Verification email sent");
      return true;
    } catch (failure) {
      const message = friendlyAuthMessage(failure);
      setError(message);
      toast.error(message);
      return false;
    }
  }, [authGateway, toast]);

  const refreshVerification = useCallback(async () => {
    setError(null);
    setStatus("checkingVerification");
    try {
      const session = await authGateway.refreshSession();
      await resolveSession(session);
    } catch (failure) {
      const message = friendlyAuthMessage(failure);
      setError(message);
      setStatus("verificationRequired");
      toast.error(message);
    }
  }, [authGateway, resolveSession, toast]);

  const refreshSession = useCallback(async () => {
    try {
      const session = await authGateway.refreshSession();
      await resolveSession(session);
    } catch (failure) {
      if (
        failure instanceof ClientAuthError &&
        [
          "auth/no-current-user",
          "auth/user-token-expired",
          "auth/invalid-user-token",
          "auth/user-disabled",
        ].includes(failure.code)
      ) {
        await expireSession();
        return;
      }
      const message = friendlyAuthMessage(failure);
      setError(message);
      toast.error(message);
    }
  }, [authGateway, expireSession, resolveSession, toast]);

  const sendPasswordReset = useCallback(
    async (email: string) => {
      if (status === "sendingPasswordReset") return false;
      setError(null);
      setStatus("sendingPasswordReset");
      try {
        await authGateway.sendPasswordResetEmail(email);
      } catch (failure) {
        if (
          failure instanceof ClientAuthError &&
          ["auth/user-not-found", "auth/user-disabled"].includes(failure.code)
        ) {
          // Deliberately indistinguishable from success to prevent account enumeration.
        } else {
          const message = friendlyPasswordResetMessage(failure);
          setError(message);
          setStatus("signedOut");
          toast.error(message);
          return false;
        }
      }
      setPasswordResetSentAt(Date.now());
      setStatus("signedOut");
      return true;
    },
    [authGateway, status, toast],
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
    () => ({
      // Narrowed from the constructor's test-seam type: a test that renders
      // dashboard data without supplying these three methods gets an
      // immediate, easy-to-diagnose TypeError rather than a silent gap.
      apiClient: client as DashboardApiClient,
      currentUser,
      error,
      passwordResetSentAt,
      refreshSession,
      refreshVerification,
      register,
      resendVerification,
      sendPasswordReset,
      signIn,
      signOut: signOutCurrentUser,
      status,
      verificationSentAt,
    }),
    [
      client,
      currentUser,
      error,
      passwordResetSentAt,
      refreshSession,
      refreshVerification,
      register,
      resendVerification,
      sendPasswordReset,
      signIn,
      signOutCurrentUser,
      status,
      verificationSentAt,
    ],
  );
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) throw new Error("useAuth requires AuthProvider");
  return context;
}
