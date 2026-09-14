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
  | "getDashboardActivity"
  | "getDashboardActivitySeries"
  | "getDashboardAssetsSummary"
  | "getDashboardSafetySummary"
  | "getDashboardPermitsSummary"
  | "getDashboardReportsSummary"
  | "getDashboardSummary"
>;

export type TrainingApiClient = Pick<
  FevApiClient,
  | "listTrainingModules"
  | "getTrainingModule"
  | "listTrainingProgress"
  | "startTrainingModule"
  | "completeTrainingStep"
  | "completeTrainingModule"
>;

export type NotificationsApiClient = Pick<
  FevApiClient,
  | "listNotifications"
  | "markNotificationRead"
  | "markAllNotificationsRead"
  | "registerNotificationDevice"
  | "unregisterNotificationDevice"
>;

export type UsersApiClient = Pick<
  FevApiClient,
  "getUser" | "inviteUser" | "listRoles" | "listUsers" | "setUserStatus" | "updateUser"
>;

export type RolesApiClient = Pick<
  FevApiClient,
  "createRole" | "deleteRole" | "getRole" | "listPermissionCatalog" | "listRoles" | "updateRole"
>;

export type CompanyApiClient = Pick<
  FevApiClient,
  "getCompany" | "removeCompanyLogo" | "updateCompany" | "uploadCompanyLogo"
>;

export type AuditApiClient = Pick<
  FevApiClient,
  "exportAuditLogs" | "getAuditLogFacets" | "listAuditLogs"
>;

export type PlatformApiClient = Pick<
  FevApiClient,
  | "getPlatformCompany"
  | "getPlatformStats"
  | "listPlatformCompanies"
  | "updatePlatformCompany"
  | "updatePlatformCompanyStatus"
>;

export type AssetsApiClient = Pick<
  FevApiClient,
  | "getArea"
  | "getAsset"
  | "getAssetHistory"
  | "getAssetQrLabel"
  | "createAsset"
  | "deleteAssetMedia"
  | "getFacility"
  | "getFacility3dScene"
  | "listAreas"
  | "listAssets"
  | "listFacilities"
  | "resolveQrCode"
  | "updateAsset"
  | "uploadAssetMedia"
>;

export type InspectionsApiClient = Pick<
  FevApiClient,
  | "assignInspectionChecklistTemplate"
  | "cancelInspection"
  | "completeInspection"
  | "createInspection"
  | "deleteInspection"
  | "getInspection"
  | "listInspections"
  | "startInspection"
  | "updateInspection"
>;

export type ChecklistTemplatesApiClient = Pick<
  FevApiClient,
  | "createChecklistTemplate"
  | "deleteChecklistTemplate"
  | "getChecklistTemplate"
  | "listChecklistTemplates"
  | "updateChecklistTemplate"
>;

export type PermitTemplatesApiClient = Pick<
  FevApiClient,
  | "createPermitTemplate"
  | "deletePermitTemplate"
  | "getPermitTemplate"
  | "listPermitTemplates"
  | "updatePermitTemplate"
>;

export type PermitsApiClient = Pick<
  FevApiClient,
  | "activatePermit"
  | "closePermit"
  | "createPermit"
  | "decidePermitApproval"
  | "getPermit"
  | "listPermits"
  | "resumePermit"
  | "revokePermit"
  | "submitPermit"
  | "suspendPermit"
>;

export type WorkOrdersApiClient = Pick<
  FevApiClient,
  | "assignWorkOrder"
  | "cancelWorkOrder"
  | "closeWorkOrder"
  | "createWorkOrder"
  | "deleteWorkOrder"
  | "getWorkOrder"
  | "listWorkOrders"
>;

export type SafetyReportsApiClient = Pick<
  FevApiClient,
  | "listSafetyReports"
  | "getSafetyReport"
  | "createSafetyReport"
  | "assignSafetyReport"
  | "transitionSafetyReport"
  | "closeSafetyReport"
  | "uploadSafetyEvidence"
  | "deleteSafetyEvidence"
  | "createCorrectiveAction"
  | "updateCorrectiveAction"
  | "cancelCorrectiveAction"
>;

export type GeneratedReportsApiClient = Pick<
  FevApiClient,
  | "deleteGeneratedReport"
  | "exportGeneratedReport"
  | "finalizeGeneratedReport"
  | "generateReport"
  | "getGeneratedReport"
  | "listGeneratedReports"
  | "regenerateGeneratedReport"
  | "updateGeneratedReport"
>;

/** Phase 13 billing. Reading the catalog and the company's own subscription is
 * available to every signed-in user; the API decides whether checkout is
 * allowed. */
export type DocumentsApiClient = Pick<FevApiClient, "createDocument" | "listDocuments">;

export type BillingApiClient = Pick<
  FevApiClient,
  | "confirmCheckoutSession"
  | "createCheckoutSession"
  | "getBillingCatalog"
  | "getSubscription"
>;

export type AuthContextValue = {
  apiClient: BillingApiClient &
    NotificationsApiClient &
    TrainingApiClient &
    DocumentsApiClient &
    DashboardApiClient &
    UsersApiClient &
    RolesApiClient &
    CompanyApiClient &
    AuditApiClient &
    PlatformApiClient &
    AssetsApiClient &
    InspectionsApiClient &
    ChecklistTemplatesApiClient &
    PermitTemplatesApiClient &
    PermitsApiClient &
    WorkOrdersApiClient &
    SafetyReportsApiClient &
    GeneratedReportsApiClient;
  currentUser: CurrentUser | null;
  error: string | null;
  /** Quietly re-checks whether the address has been verified, for the poll
   * behind the verify screen. Unlike `refreshVerification` it changes no status
   * and raises no toast unless the answer has actually changed. */
  pollVerification: () => Promise<void>;
  refreshSession: () => Promise<void>;
  refreshVerification: () => Promise<void>;
  register: (input: RegistrationInput) => Promise<void>;
  resendVerification: () => Promise<boolean>;
  sendPasswordReset: (email: string) => Promise<boolean>;
  /** Sends the same "set your password" reset email 1.3 sends, on behalf of
   * a just-invited user (Phase 3.1) -- unlike sendPasswordReset, this never
   * touches the acting admin's own auth status. */
  sendUserInviteEmail: (email: string) => Promise<boolean>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  status: AuthStatus;
  verificationSentAt: number | null;
  passwordResetSentAt: number | null;
};

export const sessionExpiredMessage = "Your session has expired. Please sign in again";

export const AuthContext = createContext<AuthContextValue | null>(null);

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
    Partial<Pick<FevApiClient, "sendVerificationEmail">> &
    Partial<BillingApiClient> &
    Partial<NotificationsApiClient> &
    Partial<TrainingApiClient> &
    Partial<DocumentsApiClient> &
    Partial<DashboardApiClient> &
    Partial<UsersApiClient> &
    Partial<RolesApiClient> &
    Partial<CompanyApiClient> &
    Partial<AuditApiClient> &
    Partial<PlatformApiClient> &
    Partial<AssetsApiClient> &
    Partial<InspectionsApiClient> &
    Partial<ChecklistTemplatesApiClient> &
    Partial<PermitTemplatesApiClient> &
    Partial<PermitsApiClient> &
    Partial<WorkOrdersApiClient> &
    Partial<SafetyReportsApiClient> &
    Partial<GeneratedReportsApiClient>;
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

  /**
   * Sends the verification email through the API, which renders the branded
   * template and delivers it over SES.
   *
   * Firebase's own `sendEmailVerification` is the fallback, not the default.
   * The default is what shipped, and its unbranded mail from a firebaseapp.com
   * sender is what people reported never receiving — it lands in spam often
   * enough that "verify your email" looked broken rather than pending. The
   * fallback still matters: on a deployment without SES configured the API
   * answers 503, and an unbranded link in spam beats no link at all.
   */
  const deliverVerificationEmail = useCallback(async () => {
    const sendViaApi = client.sendVerificationEmail?.bind(client);
    if (sendViaApi) {
      try {
        await sendViaApi();
        return;
      } catch {
        // Fall through to the provider's own sender.
      }
    }
    await authGateway.sendEmailVerification();
  }, [authGateway, client]);

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
          await deliverVerificationEmail();
          setVerificationSentAt(Date.now());
          toast.success("Verification email sent");
        } catch (failure) {
          toast.error(friendlyAuthMessage(failure));
        }
      } catch (failure) {
        fail(failure);
      }
    },
    [authGateway, client, deliverVerificationEmail, fail, resolveSession, status, toast],
  );

  const resendVerification = useCallback(async () => {
    try {
      await deliverVerificationEmail();
      setVerificationSentAt(Date.now());
      toast.success("Verification email sent");
      return true;
    } catch (failure) {
      const message = friendlyAuthMessage(failure);
      setError(message);
      toast.error(message);
      return false;
    }
  }, [deliverVerificationEmail, toast]);

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

  const pollVerification = useCallback(async () => {
    try {
      const session = await authGateway.refreshSession();
      // Only re-resolve the identity once the provider agrees the address is
      // verified: otherwise this ticks every few seconds against `/me` for no
      // change, and a failed tick would surface an error the person cannot act
      // on while they are waiting for an email.
      if (!session.emailVerified) return;
      await resolveSession(session);
    } catch {
      // Silent by design — the manual "I've verified" button reports failures.
    }
  }, [authGateway, resolveSession]);

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

  const sendUserInviteEmail = useCallback(
    async (email: string) => {
      try {
        await authGateway.sendPasswordResetEmail(email);
        return true;
      } catch (failure) {
        toast.error(friendlyPasswordResetMessage(failure));
        return false;
      }
    },
    [authGateway, toast],
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
      // dashboard or users data without supplying these methods gets an
      // immediate, easy-to-diagnose TypeError rather than a silent gap.
      apiClient: client as BillingApiClient &
        NotificationsApiClient &
        TrainingApiClient &
        DocumentsApiClient &
        DashboardApiClient &
        UsersApiClient &
        RolesApiClient &
        CompanyApiClient &
        AuditApiClient &
        PlatformApiClient &
        AssetsApiClient &
        InspectionsApiClient &
        ChecklistTemplatesApiClient &
        PermitTemplatesApiClient &
        PermitsApiClient &
        WorkOrdersApiClient &
        SafetyReportsApiClient &
        GeneratedReportsApiClient,
      currentUser,
      error,
      passwordResetSentAt,
      pollVerification,
      refreshSession,
      refreshVerification,
      register,
      resendVerification,
      sendPasswordReset,
      sendUserInviteEmail,
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
      pollVerification,
      refreshSession,
      refreshVerification,
      register,
      resendVerification,
      sendPasswordReset,
      sendUserInviteEmail,
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
