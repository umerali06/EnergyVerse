import { render, screen, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { InspectionDetailPage } from "./inspection-detail-page";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({
    back: vi.fn(),
    prefetch: vi.fn(),
    push: pushMock,
    replace: vi.fn(),
  }),
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

function inspectionDetail(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "inspection-1",
    assetId: "asset-1",
    facilityId: "facility-1",
    areaId: null,
    inspectorId: "demo-acme-field_inspector",
    status: "in_progress",
    inspectionType: "routine",
    title: "Q3 Routine Inspection",
    notes: "Started ahead of schedule.",
    checklistTemplateId: "template-1",
    checklistTemplateVersion: 1,
    checklistItemsSnapshot: [
      { id: "vibration_normal", label: "Vibration normal", itemType: "boolean", required: true },
    ],
    checklistResponses: [],
    startedAt: new Date("2026-01-02T00:00:00Z"),
    completedAt: null,
    revision: 2,
    gpsLat: null,
    gpsLng: null,
    clientCreatedAt: new Date("2026-01-01T00:00:00Z"),
    deviceId: null,
    origin: "mobile",
    media: [],
    annotations: [],
    voiceNotes: [],
    readings: {},
    arMeasurements: [],
    aiAnalysis: null,
    signature: null,
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-02T00:00:00Z"),
    ...overrides,
  };
}

function DashboardWithPermissions() {
  const auth = useAuth();
  if (auth.status !== "authenticated" || !auth.currentUser) return <p>restoring…</p>;
  return (
    <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>
      <InspectionDetailPage inspectionId="inspection-1" />
    </PermissionProvider>
  );
}

function mediaFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "media-1",
    localId: "local-1",
    url: "https://storage.example.invalid/media-1.jpg",
    kind: "photo",
    filename: "photo.jpg",
    contentType: "image/jpeg",
    size: 1000,
    gpsLat: 29.7604,
    gpsLng: -95.3698,
    capturedAt: new Date("2026-01-01T00:00:00Z"),
    checklistItemId: "vibration_normal",
    beforeAfterTag: "before",
    uploadedBy: "demo-acme-field_inspector",
    uploadedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function checklistTemplateDetail(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "template-1",
    name: "Pump Maintenance",
    version: 1,
    category: "pump",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    updatedAt: new Date("2026-01-01T00:00:00Z"),
    items: [],
    ...overrides,
  };
}

function renderDetail({
  permissions = ["inspections.read", "inspections.write"],
  getInspection = vi.fn(async () => inspectionDetail()),
  cancelInspection = vi.fn(async () => inspectionDetail({ status: "cancelled" })),
  deleteInspection = vi.fn(async () => ({ id: "inspection-1", deleted: true })),
  getChecklistTemplate = vi.fn(async () => checklistTemplateDetail()),
}: {
  permissions?: string[];
  getInspection?: ReturnType<typeof vi.fn>;
  cancelInspection?: ReturnType<typeof vi.fn>;
  deleteInspection?: ReturnType<typeof vi.fn>;
  getChecklistTemplate?: ReturnType<typeof vi.fn>;
} = {}) {
  const identity = {
    uid: "demo-acme-company_admin",
    email: "company_admin@acme.example.invalid",
    emailVerified: true,
    companyId: "acme-energy",
    companyName: "Acme Energy",
    roleKey: "company_admin",
    permissions: new Set(permissions),
  };
  const apiClient = {
    getCurrentUser: vi.fn(async () => identity),
    getInspection,
    cancelInspection,
    deleteInspection,
    getChecklistTemplate,
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

describe("inspection detail page", () => {
  it("renders the inspection summary and checklist snapshot", async () => {
    renderDetail();
    expect(await screen.findByText("Q3 Routine Inspection")).toBeInTheDocument();
    expect(screen.getByText("In progress")).toBeInTheDocument();
    expect(
      screen.getByText(
        (_, element) => element?.textContent === "Vibration normal (required)boolean",
      ),
    ).toBeInTheDocument();
    expect(screen.getByText("boolean")).toBeInTheDocument();
    expect(screen.getByText("Not answered")).toBeInTheDocument();
    expect(screen.getByText("Started ahead of schedule.")).toBeInTheDocument();
    expect(await screen.findByText("Checklist — Pump Maintenance (v1)")).toBeInTheDocument();
  });

  it("hides Cancel/Delete controls from a read-only user", async () => {
    renderDetail({ permissions: ["inspections.read"] });
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.queryByRole("button", { name: "Cancel inspection" })).not.toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Delete" })).not.toBeInTheDocument();
  });

  it("cancels the inspection when confirmed", async () => {
    const confirmSpy = vi.spyOn(window, "confirm").mockReturnValue(true);
    const cancelInspection = vi.fn(async () => inspectionDetail({ status: "cancelled" }));
    renderDetail({ cancelInspection });
    await screen.findByText("Q3 Routine Inspection");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Cancel inspection" }));
    expect(cancelInspection).toHaveBeenCalledWith("inspection-1");
    expect(await screen.findByText("Cancelled")).toBeInTheDocument();
    confirmSpy.mockRestore();
  });

  it("deletes the inspection and navigates back to the list", async () => {
    const confirmSpy = vi.spyOn(window, "confirm").mockReturnValue(true);
    const deleteInspection = vi.fn(async () => ({ id: "inspection-1", deleted: true }));
    renderDetail({ deleteInspection });
    await screen.findByText("Q3 Routine Inspection");
    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Delete" }));
    expect(deleteInspection).toHaveBeenCalledWith("inspection-1");
    expect(pushMock).toHaveBeenCalledWith("/inspections");
    confirmSpy.mockRestore();
  });

  it("shows an honest empty state when no media has been captured yet", async () => {
    renderDetail();
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.getByText("No media has been captured yet.")).toBeInTheDocument();
  });

  it("renders a media item with its before/after tag, GPS, timestamp, and linked checklist item", async () => {
    const getInspection = vi.fn(async () => inspectionDetail({ media: [mediaFixture()] }));
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const mediaSection = screen.getByText("Media (1)").closest("div")!;
    expect(within(mediaSection).getByText("before")).toBeInTheDocument();
    expect(within(mediaSection).getByText("29.7604, -95.3698")).toBeInTheDocument();
    expect(within(mediaSection).getByText("Vibration normal")).toBeInTheDocument();
    const image = within(mediaSection).getByAltText("photo.jpg") as HTMLImageElement;
    expect(image.src).toBe("https://storage.example.invalid/media-1.jpg");
    const link = image.closest("a");
    expect(link).toHaveAttribute("href", "https://storage.example.invalid/media-1.jpg");
    expect(link).toHaveAttribute("target", "_blank");
  });

  it("renders a video media item without an img tag", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({ media: [mediaFixture({ id: "media-2", kind: "video", filename: "clip.mp4" })] }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    expect(screen.getByText("Video")).toBeInTheDocument();
    expect(screen.queryByAltText("clip.mp4")).not.toBeInTheDocument();
  });
});
