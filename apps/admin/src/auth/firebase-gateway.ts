"use client";

import { FirebaseError } from "firebase/app";
import { onAuthStateChanged, signInWithEmailAndPassword, signOut, type User } from "firebase/auth";

import { getFirebaseClientAuth } from "@/firebase/client";

export type AuthSession = {
  email: string | null;
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
  signIn(email: string, password: string): Promise<AuthSession>;
  signOut(): Promise<void>;
}

const toSession = (user: User): AuthSession => ({
  email: user.email,
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

  async signOut(): Promise<void> {
    try {
      await signOut(getFirebaseClientAuth());
    } catch (error) {
      throw translate(error);
    }
  }
}
