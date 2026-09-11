import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { TrainingPage } from "./training-page";

vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: vi.fn(), replace: vi.fn() }),
}));

const session: AuthSession = {
  email: "trainee@acme.example.invalid",
  emailVerified: true,
  getIdToken: vi.fn(async () => "token"),
  uid: "trainee-1",
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

function locateModule() {
  return {
    id: "module-locate",
    title: "Locate critical equipment",
    kind: "equipment_location",
    facilityId: "fac-1",
    description: "Find each item of critical equipment by tag.",
    estimatedMinutes: 6,
    passThreshold: 75,
    steps: [
      {
        id: "step-1",
        order: 1,
        title: "Find P-101",
        instruction: "Locate Feed Pump 101 and select it.",
        action: "locate",
        targetAssetId: "asset-1",
        targetPosition: null,
        options: [],
        timeLimitSeconds: null,
      },
    ],
  };
}

function chooseModule() {
  return {
    ...locateModule(),
    id: "module-choose",
    title: "Lock-out / tag-out",
    kind: "safety_procedure",
    steps: [
      {
        id: "step-choose",
        order: 1,
        title: "First isolation action",
        instruction: "What is the first action?",
        action: "choose",
        targetAssetId: null,
        targetPosition: null,
        options: ["Notify the control room", "Close the suction valve"],
        timeLimitSeconds: null,
      },
    ],
  };
}

function scene() {
  return {
    facilityId: "fac-1",
    facilityName: "North Refinery",
    sceneType: "procedural_refinery",
    updatedAt: new Date("2026-09-01T00:00:00Z"),
    cameraPresets: [],
    hotspots: [
      {
        id: "hs-1",
        assetId: "asset-1",
        assetName: "Feed Pump 101",
        assetTag: "P-101",
        category: "Pump",
        currentStatus: "Healthy" as const,
        position: [4, 2, 6],
        radius: 1.5,
        label: null,
      },
    ],
  };
}

function progress() {
  return {
    id: "progress-1",
    moduleId: "module-locate",
    status: "in_progress",
    completedStepIds: [],
    correctCount: 0,
    scoredCount: 0,
    score: null,
    attempts: 1,
    startedAt: new Date(),
    completedAt: null,
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
      uid: "trainee-1",
      email: "trainee@acme.example.invalid",
      emailVerified: true,
      companyId: "acme",
      companyName: "Acme",
      roleKey: "field_inspector",
      permissions: new Set(["assets.read"]),
    })),
    listTrainingModules: vi.fn(async (..._args: unknown[]) => ({ items: [locateModule()] })),
    listTrainingProgress: vi.fn(async (..._args: unknown[]) => ({ items: [] })),
    getFacility3dScene: vi.fn(async (..._args: unknown[]) => scene()),
    startTrainingModule: vi.fn(async (..._args: unknown[]) => progress()),
    completeTrainingStep: vi.fn(async (..._args: unknown[]) => progress()),
    completeTrainingModule: vi.fn(async (..._args: unknown[]) => ({
      ...progress(),
      status: "completed",
      score: 100,
      completedAt: new Date(),
    })),
    ...overrides,
  };
  render(
    <ThemeProvider>
      <ToastProvider>
        <AuthProvider apiClient={apiClient} gateway={gateway}>
          <Ready>
            <TrainingPage />
          </Ready>
        </AuthProvider>
      </ToastProvider>
    </ThemeProvider>,
  );
  return apiClient;
}

describe("VR training page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("lists the tenant's training modules", async () => {
    renderPage();

    expect(await screen.findByText("Locate critical equipment")).toBeInTheDocument();
    expect(screen.getByText("Equipment location")).toBeInTheDocument();
  });

  it("shows a failure state, not an empty catalog, when loading fails", async () => {
    renderPage({
      listTrainingModules: vi.fn(async () => {
        throw new Error("upstream unavailable");
      }),
    });

    expect(await screen.findByText("Training modules could not be loaded")).toBeInTheDocument();
    // A failed request must never read as "this tenant has no training".
    expect(screen.queryByText("No training modules")).not.toBeInTheDocument();
  });

  it("loads the facility scene and starts an attempt on launch", async () => {
    const api = renderPage();

    await userEvent.click(await screen.findByRole("button", { name: "Start module" }));

    await waitFor(() => expect(api.getFacility3dScene).toHaveBeenCalledWith("fac-1"));
    expect(api.startTrainingModule).toHaveBeenCalledWith("module-locate");
    // Training runs inside the real facility scene, not a stand-in.
    expect(await screen.findByTestId("vr-trainer-canvas")).toBeInTheDocument();
  });

  it("does not open an attempt when the facility scene is unavailable", async () => {
    const api = renderPage({
      getFacility3dScene: vi.fn(async () => {
        throw new Error("no scene");
      }),
    });

    await userEvent.click(await screen.findByRole("button", { name: "Start module" }));

    expect(await screen.findByText(/could not be started/i)).toBeInTheDocument();
    // Otherwise the trainee would carry a phantom in-progress record.
    expect(api.startTrainingModule).not.toHaveBeenCalled();
  });

  it("reports the chosen option so the server can score it", async () => {
    const api = renderPage({
      listTrainingModules: vi.fn(async () => ({ items: [chooseModule()] })),
    });

    await userEvent.click(await screen.findByRole("button", { name: "Start module" }));
    await userEvent.click(await screen.findByRole("button", { name: "Notify the control room" }));

    // The correct answer never reaches the client, so the runner sends the
    // selection and the server decides.
    await waitFor(() =>
      expect(api.completeTrainingStep).toHaveBeenCalledWith(
        "module-choose",
        "step-choose",
        null,
        "Notify the control room",
      ),
    );
  });

  it("finalizes the attempt after the last step", async () => {
    const api = renderPage({
      listTrainingModules: vi.fn(async () => ({ items: [chooseModule()] })),
    });

    await userEvent.click(await screen.findByRole("button", { name: "Start module" }));
    await userEvent.click(await screen.findByRole("button", { name: "Notify the control room" }));

    await waitFor(() =>
      expect(api.completeTrainingModule).toHaveBeenCalledWith("module-choose"),
    );
    expect(await screen.findByText("Module complete")).toBeInTheDocument();
  });

  it("shows a prior result against the module", async () => {
    renderPage({
      listTrainingProgress: vi.fn(async () => ({
        items: [
          {
            id: "progress-1",
            moduleId: "module-locate",
            status: "completed",
            completedStepIds: ["step-1"],
            correctCount: 1,
            scoredCount: 1,
            score: 100,
            attempts: 1,
            startedAt: new Date(),
            completedAt: new Date(),
          },
        ],
      })),
    });

    const card = (await screen.findByText("Locate critical equipment")).closest("li");
    expect(card).not.toBeNull();
    expect(within(card as HTMLElement).getByText(/Completed · 100%/)).toBeInTheDocument();
    // A passed module offers a retake, since competency lapses.
    expect(within(card as HTMLElement).getByRole("button", { name: "Retake" })).toBeInTheDocument();
  });

  it("shows an honest empty state when no modules are configured", async () => {
    renderPage({ listTrainingModules: vi.fn(async () => ({ items: [] })) });

    expect(await screen.findByText("No training modules")).toBeInTheDocument();
  });
});
