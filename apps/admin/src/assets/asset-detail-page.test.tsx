import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { AssetDetailPage } from "./asset-detail-page";

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

function assetDetail(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "asset-1",
    assetTag: "PMP-001",
    name: "Feed Pump",
    category: "Pump",
    currentStatus: "Healthy",
    facilityId: "facility-1",
    areaId: "area-1",
    manufacturer: "Acme Co",
    model: "X200",
    serialNumber: "SN-42",
    installationDate: null,
    description: "Primary feed pump for Unit 12.",
    gpsLat: 29.7604,
    gpsLng: -95.3698,
    parentAssetId: null,
    photos: [],
    documents: [],
    manuals: [],
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-05T00:00:00Z"),
    ...overrides,
  };
}

function DashboardWithPermissions() {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <AssetDetailPage assetId="asset-1" />
    </PermissionProvider>
  );
}

function renderDetail({
  getAsset = vi.fn(async () => assetDetail()),
  getAssetHistory = vi.fn(async () => ({ items: [], nextCursor: null })),
  listAssets = vi.fn(async () => ({ items: [], nextCursor: null })),
  listFacilities = vi.fn(async () => ({
    items: [{ id: "facility-1", name: "Acme Refinery", status: "active", timezone: "UTC", createdAt: new Date(), updatedAt: new Date() }],
    nextCursor: null,
  })),
  listAreas = vi.fn(async () => ({
    items: [{ id: "area-1", facilityId: "facility-1", name: "Unit 12", createdAt: new Date(), updatedAt: new Date() }],
    nextCursor: null,
  })),
}: {
  getAsset?: ReturnType<typeof vi.fn>;
  getAssetHistory?: ReturnType<typeof vi.fn>;
  listAssets?: ReturnType<typeof vi.fn>;
  listFacilities?: ReturnType<typeof vi.fn>;
  listAreas?: ReturnType<typeof vi.fn>;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(["assets.read", "facilities.read", "areas.read"]),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    getAsset,
    getAssetHistory,
    listAssets,
    listFacilities,
    listAreas,
  };
  return render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={makeGateway()}>
          <DashboardWithPermissions />
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
}

describe("asset detail page", () => {
  it("renders the overview tab with all descriptive fields", async () => {
    renderDetail();
    expect(await screen.findByText("Feed Pump")).toBeInTheDocument();
    expect(screen.getByText("PMP-001")).toBeInTheDocument();
    expect(screen.getByText("Acme Co")).toBeInTheDocument();
    expect(screen.getByText("X200")).toBeInTheDocument();
    expect(screen.getByText("SN-42")).toBeInTheDocument();
    expect(screen.getByText("Primary feed pump for Unit 12.")).toBeInTheDocument();
    expect(screen.getByText("29.760400, -95.369800")).toBeInTheDocument();
    expect(screen.getByRole("link", { name: "View on map" })).toHaveAttribute(
      "href",
      "https://www.google.com/maps?q=29.7604,-95.3698",
    );
    expect(await screen.findByText("No sub-assets.")).toBeInTheDocument();
  });

  it("shows a coordinates-not-recorded message when the asset has no GPS data", async () => {
    renderDetail({ getAsset: vi.fn(async () => assetDetail({ gpsLat: null, gpsLng: null })) });
    expect(await screen.findByText("No location recorded.")).toBeInTheDocument();
  });

  it("links to sub-assets when child assets exist", async () => {
    const listAssets = vi.fn(async () => ({
      items: [{ id: "asset-2", assetTag: "PMP-002", name: "Booster Pump" }],
      nextCursor: null,
    }));
    renderDetail({ listAssets });
    await screen.findByText("Feed Pump");
    expect(await screen.findByRole("link", { name: /Booster Pump/ })).toHaveAttribute(
      "href",
      "/assets/asset-2",
    );
    expect(listAssets).toHaveBeenCalledWith({ parentAssetId: "asset-1", limit: 100 });
  });

  it("shows the honest empty state for each reserved tab", async () => {
    renderDetail();
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();

    await user.click(screen.getByRole("tab", { name: "Inspections" }));
    expect(await screen.findByText("No inspections yet")).toBeInTheDocument();

    await user.click(screen.getByRole("tab", { name: "Work Orders" }));
    expect(await screen.findByText("No work orders yet")).toBeInTheDocument();

    await user.click(screen.getByRole("tab", { name: "Media" }));
    expect(await screen.findByText("No photos or documents yet")).toBeInTheDocument();
  });

  it("calls the history endpoint and renders the empty timeline", async () => {
    const getAssetHistory = vi.fn(async () => ({ items: [], nextCursor: null }));
    renderDetail({ getAssetHistory });
    await screen.findByText("Feed Pump");
    const user = userEvent.setup();
    await user.click(screen.getByRole("tab", { name: "History" }));
    expect(await screen.findByText("No history has been recorded for this asset yet.")).toBeInTheDocument();
    expect(getAssetHistory).toHaveBeenCalledWith("asset-1");
  });

  it("hides asset write controls from a read-only user", async () => {
    renderDetail();
    await screen.findByText("Feed Pump");
    expect(screen.queryByRole("button", { name: "Edit" })).not.toBeInTheDocument();
  });
});
