"use client";

import { FirebaseError } from "firebase/app";
import {
  onAuthStateChanged,
  sendEmailVerification,
  sendPasswordResetEmail,
  signInWithEmailAndPassword,
  signOut,
  type User,
} from "firebase/auth";

import { getFirebaseClientAuth } from "@/firebase/client";

export type AuthSession = {
  email: string | null;
  emailVerified: boolean;
  getIdToken: () => Promise<string>;
  uid: string;
};

export class ClientAuthError extends Error {
  constructor(
    public readonly code: string,
    message: string,
  ) {
    super(message);
    this.name = "ClientAuthError";
  }
}

export interface AuthGateway {
  getIdToken(): Promise<string | undefined>;
  observe(listener: (session: AuthSession | null) => void): () => void;
  refreshSession(): Promise<AuthSession>;
  sendEmailVerification(): Promise<void>;
  sendPasswordResetEmail(email: string): Promise<void>;
  signIn(email: string, password: string): Promise<AuthSession>;
  signOut(): Promise<void>;
}

const toSession = (user: User): AuthSession => ({
  email: user.email,
  emailVerified: user.emailVerified,
  getIdToken: () => user.getIdToken(),
  uid: user.uid,
});

function translate(error: unknown): ClientAuthError {
  if (error instanceof FirebaseError) return new ClientAuthError(error.code, error.message);
  if (error instanceof Error) return new ClientAuthError("auth/client-error", error.message);
  return new ClientAuthError("auth/client-error", "Firebase authentication failed");
}

export class FirebaseAuthGateway implements AuthGateway {
  async getIdToken(): Promise<string | undefined> {
    return getFirebaseClientAuth().currentUser?.getIdToken();
  }

  observe(listener: (session: AuthSession | null) => void): () => void {
    try {
      return onAuthStateChanged(getFirebaseClientAuth(), (user) =>
        listener(user && toSession(user)),
      );
    } catch (error) {
      throw translate(error);
    }
  }

  async signIn(email: string, password: string): Promise<AuthSession> {
    try {
      const credential = await signInWithEmailAndPassword(getFirebaseClientAuth(), email, password);
      return toSession(credential.user);
    } catch (error) {
      throw translate(error);
    }
  }

  async refreshSession(): Promise<AuthSession> {
    try {
      const user = getFirebaseClientAuth().currentUser;
      if (!user) throw new ClientAuthError("auth/no-current-user", "No Firebase session");
      await user.reload();
      await user.getIdToken(true);
      return toSession(user);
    } catch (error) {
      if (error instanceof ClientAuthError) throw error;
      throw translate(error);
    }
  }

  async sendEmailVerification(): Promise<void> {
    try {
      const user = getFirebaseClientAuth().currentUser;
      if (!user) throw new ClientAuthError("auth/no-current-user", "No Firebase session");
      await sendEmailVerification(user);
    } catch (error) {
      if (error instanceof ClientAuthError) throw error;
      throw translate(error);
    }
  }

  async sendPasswordResetEmail(email: string): Promise<void> {
    try {
      const actionUrl = process.env.NEXT_PUBLIC_AUTH_ACTION_URL?.trim();
      await sendPasswordResetEmail(
        getFirebaseClientAuth(),
        email,
        actionUrl ? { handleCodeInApp: false, url: actionUrl } : undefined,
      );
    } catch (error) {
      throw translate(error);
    }
  }

  async signOut(): Promise<void> {
    try {
      await signOut(getFirebaseClientAuth());
    } catch (error) {
      throw translate(error);
    }
  }
}
