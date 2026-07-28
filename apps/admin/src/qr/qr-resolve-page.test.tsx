import { render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { ApiClientError } from "@/api/client";
import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { QrResolvePage } from "./qr-resolve-page";

const mockReplace = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: () => undefined, push: vi.fn(), replace: mockReplace }),
}));

const session: AuthSession = {
  email: "company_admin@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "id-token"),
  uid: "demo-acme-company_admin",
};

function makeGateway(): AuthGateway {
  return {
    async getIdToken() {
      return "id-token";
    },
    observe(listener: (value: AuthSession | null) => void) {
      listener(session);
      return () => undefined;
    },
    async refreshSession() {
      return session;
    },
    async sendEmailVerification() {},
    async sendPasswordResetEmail() {},
    async signIn() {
      return session;
    },
    async signOut() {},
  };
}

function Restored() {
  const auth = useAuth();
  if (auth.status !== "authenticated") return <p>restoring…</p>;
  return <QrResolvePage code="qr-code-1" reducedMotionOverride />;
}

function renderResolve(resolveQrCode: ReturnType<typeof vi.fn>) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(["assets.read"]),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    resolveQrCode,
  };
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <Restored />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

describe("qr resolve page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("redirects to the asset detail page on a successful resolve", async () => {
    const resolveQrCode = vi.fn(async () => ({
      asset: { id: "asset-1" },
      inspectionsTotal: 0,
      maintenanceTotal: 0,
      workOrdersTotal: 0,
    }));
    renderResolve(resolveQrCode);

    await vi.waitFor(() => expect(mockReplace).toHaveBeenCalledWith("/assets/asset-1"));
    expect(resolveQrCode).toHaveBeenCalledWith("qr-code-1");
  });

  it("shows a not-found state for an unrecognized or cross-tenant code", async () => {
    const resolveQrCode = vi.fn(async () => {
      throw new ApiClientError("qr_code_not_found", "QR code was not found", 404);
    });
    renderResolve(resolveQrCode);

    expect(await screen.findByText("QR code not found")).toBeInTheDocument();
    expect(mockReplace).not.toHaveBeenCalled();
  });

  it("shows a generic error state for a network failure", async () => {
    const resolveQrCode = vi.fn(async () => {
      throw new ApiClientError("network_error", "Unable to reach the API");
    });
    renderResolve(resolveQrCode);

    expect(await screen.findByText("Something went wrong")).toBeInTheDocument();
  });
});
