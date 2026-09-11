import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ApiCacheProvider } from "@/cache/cache-context";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { DigitalTwinPage } from "./digital-twin-page";

vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: vi.fn(), replace: vi.fn() }),
}));

const session: AuthSession = {
  email: "manager@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "manager-1",
};

const gateway: AuthGateway = {
  getIdToken: async () => "token",
  observe: (listener) => {
    listener(session);
    return () => undefined;
  },
  refreshSession: async () => session,
  sendEmailVerification: async () => undefined,
  sendPasswordResetEmail: async () => undefined,
  signIn: async () => session,
  signOut: async () => undefined,
};

function scenePayload() {
  return {
    facilityId: "fac-real-1",
    facilityName: "Tenant Refinery One",
    sceneType: "procedural_refinery",
    updatedAt: new Date("2026-09-01T00:00:00Z"),
    cameraPresets: [
      { id: "cam", name: "Overview", position: [0, 30, 40], target: [0, 0, 0] },
    ],
    hotspots: [
      {
        id: "hs-real",
        assetId: "asset-real-1",
        assetName: "Tenant Booster Pump",
        assetTag: "TBP-900",
        category: "Pump",
        currentStatus: "Warning" as const,
        position: [1, 2, 3],
        radius: 1.5,
        label: null,
      },
    ],
  };
}

function Ready({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  if (!auth.currentUser) return null;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      {children}
    </PermissionProvider>
  );
}

function renderPage(overrides: Record<string, unknown> = {}) {
  const apiClient = {
    registerCompanyAdmin: vi.fn(),
    getCurrentUser: vi.fn(async () => ({
      uid: "manager-1",
      email: "manager@acme.example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "operations_manager",
      permissions: new Set(["facilities.read", "assets.read"]),
    })),
    listFacilities: vi.fn(async (..._args: unknown[]) => ({
      items: [
        {
          id: "fac-real-1",
          name: "Tenant Refinery One",
          status: "active" as const,
          timezone: "UTC",
          createdAt: new Date("2026-01-01T00:00:00Z"),
          updatedAt: new Date("2026-01-01T00:00:00Z"),
        },
      ],
      nextCursor: null,
    })),
    getFacility3dScene: vi.fn(async (..._args: unknown[]) => scenePayload()),
    ...overrides,
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <ApiCacheProvider>
          <AuthProvider apiClient={apiClient} gateway={gateway}>
            <Ready>
              <DigitalTwinPage />
            </Ready>
          </AuthProvider>
        </ApiCacheProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

describe("digital twin page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders the tenant's real scene from the authenticated API", async () => {
    const api = renderPage();

    expect(await screen.findByText(/Tenant Refinery One/)).toBeInTheDocument();
    await waitFor(() => expect(api.getFacility3dScene).toHaveBeenCalledWith("fac-real-1"));
    expect(await screen.findByText("Tenant Booster Pump")).toBeInTheDocument();
  });

  it("never renders the hard-coded sample assets it used to fabricate", async () => {
    renderPage();

    await screen.findByText("Tenant Booster Pump");
    // These three were previously synthesized client-side whenever the scene
    // request failed, so every tenant saw the same invented equipment.
    expect(screen.queryByText("Main Crude Charge Pump")).not.toBeInTheDocument();
    expect(screen.queryByText("Hydrocracker Inlet Valve")).not.toBeInTheDocument();
    expect(screen.queryByText("High Pressure Gas Separator")).not.toBeInTheDocument();
  });

  it("shows a failure state, not an empty one, when the scene request fails", async () => {
    renderPage({
      getFacility3dScene: vi.fn(async () => {
        throw new Error("scene unavailable");
      }),
    });

    expect(await screen.findByText("3D View Unavailable")).toBeInTheDocument();
    expect(screen.queryByText("No Facility Selected")).not.toBeInTheDocument();
  });

  it("retries the scene request from the failure state", async () => {
    const getFacility3dScene = vi
      .fn()
      .mockRejectedValueOnce(new Error("scene unavailable"))
      .mockResolvedValue(scenePayload());
    renderPage({ getFacility3dScene });

    await userEvent.click(await screen.findByRole("button", { name: "Retry Loading Scene" }));

    expect(await screen.findByText("Tenant Booster Pump")).toBeInTheDocument();
  });
});
