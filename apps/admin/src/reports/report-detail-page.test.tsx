import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { PermissionProvider } from "@/auth/permissions";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { ReportDetailPage } from "./report-detail-page";

const push = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ push }) }));

const session: AuthSession = { email: "manager@example.invalid", emailVerified: true, getIdToken: vi.fn(async () => "token"), uid: "manager-1" };
const gateway: AuthGateway = {
  getIdToken: async () => "token",
  observe: (listener) => { listener(session); return () => undefined; },
  refreshSession: async () => session,
  sendEmailVerification: async () => undefined,
  sendPasswordResetEmail: async () => undefined,
  signIn: async () => session,
  signOut: async () => undefined,
};

function detail(overrides: Record<string, unknown> = {}) {
  return {
    id: "report-1",
    reportType: "inspection" as const,
    sourceId: "inspection-1",
    sourceRevision: 3,
    title: "Separator inspection report",
    status: "draft" as const,
    revision: 2,
    createdBy: "manager-1",
    createdAt: new Date("2026-08-20T10:00:00Z"),
    updatedAt: new Date("2026-08-20T11:00:00Z"),
    finalizedBy: null,
    finalizedAt: null,
    sourceSnapshot: { inspection: { id: "inspection-1", status: "completed" }, reviewed_ai: true },
    narrative: { summary: "Original advisory summary", findings: ["Seal wear"], recommendations: ["Inspect seal"], riskScore: 62 },
    aiModel: "claude-enterprise-advisory",
    finalizationAttestation: false,
    ...overrides,
  };
}

function Ready({ children }: { children: React.ReactNode }) {
  const auth = useAuth();
  if (!auth.currentUser) return null;
  return <PermissionProvider initialPermissions={[...auth.currentUser.permissions]}>{children}</PermissionProvider>;
}

function setup(initial = detail()) {
  const apiClient = {
    getCurrentUser: vi.fn(async () => ({ uid: "manager-1", email: "manager@example.invalid", emailVerified: true, companyId: "acme", companyName: "Acme", roleKey: "operations_manager", permissions: new Set(["reports.read", "reports.generate"]) })),
    registerCompanyAdmin: vi.fn(),
    getGeneratedReport: vi.fn(async () => initial),
    updateGeneratedReport: vi.fn(async (_id, request) => detail({ title: request.title, narrative: { summary: request.summary, findings: request.findings, recommendations: request.recommendations, riskScore: request.riskScore }, revision: 3 })),
    regenerateGeneratedReport: vi.fn(async () => detail({ revision: 3, narrative: { summary: "Regenerated summary", findings: [], recommendations: [], riskScore: 40 } })),
    finalizeGeneratedReport: vi.fn(async () => detail({ status: "finalized", revision: 3, finalizedBy: "manager-1", finalizedAt: new Date("2026-08-20T12:00:00Z"), finalizationAttestation: true })),
    deleteGeneratedReport: vi.fn(async () => ({ id: "report-1", deleted: true })),
  };
  render(<ThemeProvider><ToastProvider><AuthProvider apiClient={apiClient} gateway={gateway}><Ready><ReportDetailPage reportId="report-1" /></Ready></AuthProvider></ToastProvider></ThemeProvider>);
  return apiClient;
}

beforeEach(() => push.mockReset());

describe("report detail page", () => {
  it("loads the frozen source and saves revision-safe human edits", async () => {
    const api = setup();
    expect(await screen.findByText("inspection.status")).toBeInTheDocument();
    await userEvent.clear(screen.getByLabelText("Executive summary"));
    await userEvent.type(screen.getByLabelText("Executive summary"), "Human reviewed summary");
    await userEvent.clear(screen.getByLabelText("Findings"));
    await userEvent.type(screen.getByLabelText("Findings"), "Finding one\nFinding two");
    await userEvent.click(screen.getByRole("button", { name: "Save human edits" }));
    await waitFor(() => expect(api.updateGeneratedReport).toHaveBeenCalledWith("report-1", expect.objectContaining({ expectedRevision: 2, summary: "Human reviewed summary", findings: ["Finding one", "Finding two"] })));
  });

  it("regenerates explicitly from the current authoritative source revision", async () => {
    const api = setup();
    await userEvent.click(await screen.findByRole("button", { name: "Regenerate from source" }));
    await userEvent.click(screen.getByRole("button", { name: "Regenerate" }));
    await waitFor(() => expect(api.regenerateGeneratedReport).toHaveBeenCalledWith("report-1", 2));
    expect(await screen.findByDisplayValue("Regenerated summary")).toBeInTheDocument();
  });

  it("requires human attestation before finalization and renders the immutable result", async () => {
    const api = setup();
    await userEvent.click(await screen.findByRole("button", { name: "Finalize report" }));
    const confirm = screen.getByRole("button", { name: "Finalize and lock" });
    expect(confirm).toBeDisabled();
    await userEvent.click(screen.getByLabelText(/I reviewed this report/));
    await userEvent.click(confirm);
    await waitFor(() => expect(api.finalizeGeneratedReport).toHaveBeenCalledWith("report-1", 2));
    expect(await screen.findByText(/Finalized report · immutable/)).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Save human edits" })).not.toBeInTheDocument();
  });

  it("deletes only through the explicit audited draft confirmation", async () => {
    const api = setup();
    await userEvent.click(await screen.findByRole("button", { name: "Delete draft" }));
    await userEvent.click(screen.getAllByRole("button", { name: "Delete draft" })[1]);
    await waitFor(() => expect(api.deleteGeneratedReport).toHaveBeenCalledWith("report-1"));
    expect(push).toHaveBeenCalledWith("/reports");
  });
});
