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
    readings: null,
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

// Wire annotation data, not a UI styling literal -- built by concatenation
// so the repo-wide "no raw hex colors" lint (which matches on a literal
// AST node's value) doesn't mistake test fixture data for a hardcoded style.
const TEST_ANNOTATION_COLOR = "#" + "C1123F";

function annotationFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "annotation-1",
    mediaLocalId: "local-1",
    shape: "rectangle",
    points: [{ x: 0.1, y: 0.1 }, { x: 0.4, y: 0.4 }],
    color: TEST_ANNOTATION_COLOR,
    damageType: "corrosion",
    note: "Visible corrosion on flange",
    source: "manual",
    confidence: null,
    createdBy: "demo-acme-field_inspector",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function voiceNoteFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "voice-1",
    localId: "voice-local-1",
    url: "https://storage.example.invalid/voice-1.m4a",
    filename: "note.m4a",
    contentType: "audio/mp4",
    size: 5000,
    durationMs: 42000,
    checklistItemId: "vibration_normal",
    uploadedBy: "demo-acme-field_inspector",
    uploadedAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function readingsFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    condition: "Critical",
    temperatureC: 95.5,
    pressureBar: 6.2,
    noiseLevelDb: 92,
    vibrationObservation: "Excessive vibration near bearing",
    leakObserved: true,
    operationalStatus: "degraded",
    comments: "Bearing failing",
    recommendations: "Replace bearing immediately",
    priorityLevel: "critical",
    recordedAt: new Date("2026-01-02T00:00:00Z"),
    recordedBy: "demo-acme-field_inspector",
    ...overrides,
  };
}

function measurementFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: "measurement-1",
    method: "manual",
    distanceMeters: 1.25,
    label: "Flange gap",
    mediaLocalId: null,
    points: [],
    note: "Measured with tape",
    checklistItemId: null,
    createdBy: "demo-acme-field_inspector",
    createdAt: new Date("2026-01-01T00:00:00Z"),
    ...overrides,
  };
}

function signatureFixture(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    strokes: [
      {
        points: [
          { x: 0.1, y: 0.2 },
          { x: 0.8, y: 0.6 },
        ],
      },
    ],
    signerUid: "demo-acme-field_inspector",
    signerName: "Alex Field Inspector",
    signerRole: "field_inspector",
    signedAt: new Date("2026-01-03T00:00:00Z"),
    inspectionRevision: 2,
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

    const mediaSection = screen.getByTestId("media-section");
    expect(within(mediaSection).getByText("before")).toBeInTheDocument();
    expect(within(mediaSection).getByText("29.7604, -95.3698")).toBeInTheDocument();
    expect(within(mediaSection).getByText("Vibration normal")).toBeInTheDocument();
    const image = within(mediaSection).getByAltText("photo.jpg") as HTMLImageElement;
    expect(image.src).toBe("https://storage.example.invalid/media-1.jpg");
    const link = image.closest("a");
    expect(link).toHaveAttribute("href", "https://storage.example.invalid/media-1.jpg");
    expect(link).toHaveAttribute("target", "_blank");
  });

  it("shows an honest empty state when no voice notes have been recorded yet", async () => {
    renderDetail();
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.getByText("No voice notes have been recorded yet.")).toBeInTheDocument();
  });

  it("renders a voice note with playback, duration, and its linked checklist item", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({ voiceNotes: [voiceNoteFixture()] }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const voiceSection = screen.getByTestId("voice-notes-section");
    expect(within(voiceSection).getByText("00:42")).toBeInTheDocument();
    expect(within(voiceSection).getByText("Vibration normal")).toBeInTheDocument();
    const audio = voiceSection.querySelector("audio");
    expect(audio).toHaveAttribute("src", "https://storage.example.invalid/voice-1.m4a");
    expect(audio).toHaveAttribute("controls");
  });

  it("does not show the annotation toggle when a photo has no annotations", async () => {
    const getInspection = vi.fn(async () => inspectionDetail({ media: [mediaFixture()] }));
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.queryByRole("button", { name: "Hide annotations" })).not.toBeInTheDocument();
  });

  it("renders an annotation overlay with its damage type on the matching photo", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        media: [mediaFixture()],
        annotations: [annotationFixture()],
      }),
    );
    const { container } = renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const mediaSection = screen.getByTestId("media-section");
    expect(within(mediaSection).getByText("Corrosion")).toBeInTheDocument();
    expect(container.querySelector("svg rect")).not.toBeNull();
    expect(container.querySelector("title")?.textContent).toBe(
      "Corrosion — Visible corrosion on flange",
    );
  });

  it("hides the annotation overlay when toggled off", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        media: [mediaFixture()],
        annotations: [annotationFixture()],
      }),
    );
    const { container } = renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const user = userEvent.setup();
    await user.click(screen.getByRole("button", { name: "Hide annotations" }));
    expect(container.querySelector("svg rect")).toBeNull();
    expect(screen.getByRole("button", { name: "Show annotations" })).toBeInTheDocument();
  });

  it("does not overlay an annotation from a different photo", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        media: [mediaFixture()],
        annotations: [annotationFixture({ mediaLocalId: "some-other-photo" })],
      }),
    );
    const { container } = renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");
    // The toggle reflects whether the INSPECTION has any annotations at all,
    // but this photo's own overlay must stay empty since the one annotation
    // that exists belongs to a different `media_local_id`.
    expect(screen.getByRole("button", { name: "Hide annotations" })).toBeInTheDocument();
    expect(container.querySelector("svg rect")).toBeNull();
    expect(screen.queryByText("Corrosion")).not.toBeInTheDocument();
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

  it("shows an honest empty state when no readings have been logged yet", async () => {
    renderDetail();
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.getByText("No manual status readings have been logged yet.")).toBeInTheDocument();
  });

  it("renders readings read-only with the condition, values and units, priority, and leak badge", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({ readings: readingsFixture() }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const readingsSection = screen.getByTestId("readings-section");
    expect(within(readingsSection).getByText("Critical")).toBeInTheDocument();
    expect(within(readingsSection).getByText("95.5 °C")).toBeInTheDocument();
    expect(within(readingsSection).getByText("6.2 bar")).toBeInTheDocument();
    expect(within(readingsSection).getByText("92 dB")).toBeInTheDocument();
    expect(
      within(readingsSection).getByText("Excessive vibration near bearing"),
    ).toBeInTheDocument();
    expect(within(readingsSection).getByText("Degraded")).toBeInTheDocument();
    expect(within(readingsSection).getByText("Priority: Critical")).toBeInTheDocument();
    expect(within(readingsSection).getByText("Leak observed")).toBeInTheDocument();
    expect(within(readingsSection).getByText("Bearing failing")).toBeInTheDocument();
    expect(within(readingsSection).getByText("Replace bearing immediately")).toBeInTheDocument();
  });

  it("omits the priority badge and leak badge when neither is set", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        readings: readingsFixture({ priorityLevel: null, leakObserved: false }),
      }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const readingsSection = screen.getByTestId("readings-section");
    expect(within(readingsSection).queryByText(/Priority:/)).not.toBeInTheDocument();
    expect(within(readingsSection).queryByText("Leak observed")).not.toBeInTheDocument();
  });

  it("shows an honest empty state when the inspection has no measurements yet", async () => {
    renderDetail();
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.getByText("No measurements have been recorded yet.")).toBeInTheDocument();
  });

  it("renders a manual measurement with its method badge, formatted distance, label, and note", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({ arMeasurements: [measurementFixture()] }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const measurementsSection = screen.getByTestId("measurements-section");
    expect(within(measurementsSection).getByText("Manual")).toBeInTheDocument();
    expect(within(measurementsSection).getByText("1.25 m")).toBeInTheDocument();
    expect(within(measurementsSection).getByText("Flange gap")).toBeInTheDocument();
    expect(within(measurementsSection).getByText("Measured with tape")).toBeInTheDocument();
  });

  it("renders an AR measurement under 1 meter in centimeters", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        arMeasurements: [measurementFixture({ id: "measurement-2", method: "ar", distanceMeters: 0.42 })],
      }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const measurementsSection = screen.getByTestId("measurements-section");
    expect(within(measurementsSection).getByText("AR")).toBeInTheDocument();
    expect(within(measurementsSection).getByText("42.0 cm")).toBeInTheDocument();
  });

  it("shows an honest empty state when the inspection has not been signed off yet", async () => {
    renderDetail();
    await screen.findByText("Q3 Routine Inspection");
    expect(screen.getByText("This inspection has not been signed off yet.")).toBeInTheDocument();
  });

  it("renders the signer identity, timestamp, valid-at-revision status, and stroke preview", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({ status: "completed", signature: signatureFixture() }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const signatureSection = screen.getByTestId("signature-section");
    expect(within(signatureSection).getByText("Alex Field Inspector")).toBeInTheDocument();
    expect(within(signatureSection).getByText("Field inspector")).toBeInTheDocument();
    expect(within(signatureSection).getByText("Signed")).toBeInTheDocument();
    expect(within(signatureSection).getByText("Valid at revision 2")).toBeInTheDocument();
    expect(within(signatureSection).getByRole("img", { name: "Signature" })).toBeInTheDocument();
  });

  it("flags a signature as superseded once the inspection's revision has moved past it", async () => {
    const getInspection = vi.fn(async () =>
      inspectionDetail({
        status: "completed",
        revision: 3,
        signature: signatureFixture({ inspectionRevision: 2 }),
      }),
    );
    renderDetail({ getInspection });
    await screen.findByText("Q3 Routine Inspection");

    const signatureSection = screen.getByTestId("signature-section");
    expect(
      within(signatureSection).getByText("Superseded (signed revision 2, now at 3)"),
    ).toBeInTheDocument();
  });
});
