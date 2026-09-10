import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { PermitDetailPage } from "./permit-detail-page";

const session: AuthSession = { email: "admin@acme.test", emailVerified: true, getIdToken: vi.fn(async () => "token"), uid: "admin" };
const gateway: AuthGateway = {
  async getIdToken() { return "token"; }, observe(listener) { listener(session); return () => undefined; },
  async refreshSession() { return session; }, async sendEmailVerification() {}, async sendPasswordResetEmail() {},
  async signIn() { return session; }, async signOut() {},
};

function Harness({ apiClient, permissions, children }: { apiClient: Record<string, unknown>; permissions: string[]; children: React.ReactNode }) {
  const identity = { uid: "admin", email: "admin@acme.test", emailVerified: true, companyId: "acme", companyName: "Acme", roleKey: "hse_manager", permissions: new Set(permissions) };
  return <ThemeProvider><ToastProvider><AuthProvider gateway={gateway} apiClient={{ getCurrentUser: vi.fn(async () => identity), ...apiClient }}><Ready>{children}</Ready></AuthProvider></ToastProvider></ThemeProvider>;
}

function Ready({ children }: { children: React.ReactNode }) {
  return useAuth().status === "authenticated" ? children : <p>restoring</p>;
}

const basePermit = {
  id: "permit-1", permitNumber: "PTW-20260819-ABCD1234", title: "Replace relief valve", description: "Controlled valve replacement",
  permitType: "hot_work" as const, facilityId: "facility-1", templateId: "template-1", templateName: "Hot work standard", templateVersion: 3,
  status: "draft" as const, revision: 4, highestResidualRisk: "medium" as const,
  validFrom: new Date("2026-08-20T08:00:00Z"), validUntil: new Date("2026-08-20T16:00:00Z"),
  workerIds: ["worker-1"], workerCount: 1, workerAcknowledgements: [],
  checklistSnapshot: [{ id: "check-1", templateItemId: "item-1", label: "Gas test complete", helpText: "Record before ignition", required: true, completed: false }],
  approvalSnapshot: [{ id: "approval-1", templateStepId: "step-1", label: "HSE approval", approverRoleId: "role-hse", required: true, status: "pending" as const }],
  riskAssessment: [{ id: "risk-1", hazard: "Ignition", personsAtRisk: "Crew", controls: "Gas test", initialLikelihood: 3, initialSeverity: 4, initialScore: 12, initialBand: "high" as const, residualLikelihood: 1, residualSeverity: 4, residualScore: 4, residualBand: "low" as const }],
  createdAt: new Date("2026-08-19T00:00:00Z"), updatedAt: new Date("2026-08-19T00:00:00Z"),
};

function renderPermit(permit: typeof basePermit | Record<string, unknown>, permissions: string[], overrides: Record<string, unknown> = {}) {
  const getPermit = vi.fn(async () => permit);
  const api = { getPermit, ...overrides };
  render(<Harness permissions={permissions} apiClient={api}><PermitDetailPage permitId="permit-1" /></Harness>);
  return { api, getPermit };
}

async function attestAndConfirm(label: string) {
  const user = userEvent.setup();
  await user.click(screen.getByLabelText(/I attest that this controlled action/));
  await user.click(screen.getByRole("button", { name: label }));
}

describe("permit detail lifecycle", () => {
  it("renders the immutable safety, risk, approval, and acknowledgement state", async () => {
    renderPermit(basePermit, ["permits.read"]);
    expect(await screen.findByText("PTW-20260819-ABCD1234 · revision 4")).toBeInTheDocument();
    expect(screen.getByText(/Hot work standard/)).toBeInTheDocument();
    expect(screen.getByText("Gas test complete")).toBeInTheDocument();
    expect(screen.getByText("1. HSE approval")).toBeInTheDocument();
    expect(screen.getByText("Initial", { exact: false })).toBeInTheDocument();
    expect(screen.getByText("0 / 1 acknowledged")).toBeInTheDocument();
  });

  it("submits selected checklist IDs with the loaded revision and issuer attestation", async () => {
    const submitted = { ...basePermit, status: "pending_approval" as const, revision: 5 };
    const submitPermit = vi.fn(async () => submitted);
    renderPermit(basePermit, ["permits.read", "permits.write"], { submitPermit });
    const user = userEvent.setup();
    await screen.findByText("Gas test complete");
    await user.click(screen.getByLabelText(/Gas test complete/));
    await user.click(screen.getByRole("button", { name: "Prepare submission" }));
    await attestAndConfirm("Confirm submission");
    expect(submitPermit).toHaveBeenCalledWith("permit-1", { completedChecklistItemIds: ["check-1"], expectedRevision: 4, issuerAttestation: true });
    expect(await screen.findByText("Pending Approval")).toBeInTheDocument();
  });

  it("records an approval decision with a server-signature attestation", async () => {
    const pending = { ...basePermit, status: "pending_approval" as const };
    const approved = { ...pending, status: "pending_signatures" as const, revision: 5, approvalSnapshot: [{ ...basePermit.approvalSnapshot[0], status: "approved" as const, signedAt: new Date() }] };
    const decidePermitApproval = vi.fn(async () => approved);
    renderPermit(pending, ["permits.read", "permits.approve"], { decidePermitApproval });
    await screen.findByRole("button", { name: "Approve HSE approval" });
    await userEvent.setup().click(screen.getByRole("button", { name: "Approve HSE approval" }));
    await attestAndConfirm("Confirm approve");
    expect(decidePermitApproval).toHaveBeenCalledWith("permit-1", { decision: "approve", digitalSignatureAttestation: true, expectedRevision: 4, rejectionReason: undefined });
  });

  it("requires a rejection reason before sending the decision", async () => {
    const pending = { ...basePermit, status: "pending_approval" as const };
    const decidePermitApproval = vi.fn();
    renderPermit(pending, ["permits.read", "permits.approve"], { decidePermitApproval });
    await screen.findByRole("button", { name: "Reject" });
    await userEvent.setup().click(screen.getByRole("button", { name: "Reject" }));
    await userEvent.setup().click(screen.getByLabelText(/I attest that this controlled action/));
    expect(screen.getByRole("button", { name: "Confirm reject" })).toBeDisabled();
    expect(decidePermitApproval).not.toHaveBeenCalled();
  });

  it("enables online activation only after every assigned worker acknowledges", async () => {
    const pending = { ...basePermit, status: "pending_signatures" as const };
    const { unmount } = render(<Harness permissions={["permits.read", "permits.write"]} apiClient={{ getPermit: vi.fn(async () => pending) }}><PermitDetailPage permitId="permit-1" /></Harness>);
    expect(await screen.findByRole("button", { name: "Activate permit" })).toBeDisabled();
    unmount();
    const acknowledged = { ...pending, workerAcknowledgements: [{ workerId: "worker-1", clientMutationId: "mutation-1", clientSignedAt: new Date(), meaning: "Acknowledged", receivedAt: new Date(), signedAt: new Date() }] };
    renderPermit(acknowledged, ["permits.read", "permits.write"]);
    expect(await screen.findByRole("button", { name: "Activate permit" })).toBeEnabled();
  });

  it("sends reasoned exceptional actions and reloads authoritative state after failure", async () => {
    const active = { ...basePermit, status: "active" as const };
    const suspended = { ...active, status: "suspended" as const, revision: 5, suspensionReason: "Gas alarm" };
    const getPermit = vi.fn().mockResolvedValueOnce(active).mockResolvedValueOnce(suspended);
    const suspendPermit = vi.fn(async () => { throw new Error("revision conflict"); });
    render(<Harness permissions={["permits.read", "permits.approve"]} apiClient={{ getPermit, suspendPermit }}><PermitDetailPage permitId="permit-1" /></Harness>);
    await screen.findByRole("button", { name: "Suspend" });
    await userEvent.setup().click(screen.getByRole("button", { name: "Suspend" }));
    await userEvent.setup().type(screen.getByLabelText("Reason"), "Gas alarm");
    await attestAndConfirm("Confirm suspend");
    expect(suspendPermit).toHaveBeenCalledWith("permit-1", { expectedRevision: 4, reason: "Gas alarm" });
    await waitFor(() => expect(getPermit).toHaveBeenCalledTimes(2));
    expect(await screen.findByText("Suspended")).toBeInTheDocument();
  });
});
