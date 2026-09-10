import { fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";

import { AuthProvider, useAuth } from "@/auth/auth-context";
import type { AuthGateway, AuthSession } from "@/auth/firebase-gateway";
import { ThemeProvider, ToastProvider } from "@/design-system";

import { PermitCreatePage } from "./permit-create-page";
import { PermitsPage } from "./permits-page";

const pushMock = vi.fn();
vi.mock("next/navigation", () => ({ useRouter: () => ({ back: vi.fn(), prefetch: vi.fn(), push: pushMock, replace: vi.fn() }) }));

const session: AuthSession = { email: "admin@acme.test", emailVerified: true, getIdToken: vi.fn(async (..._args: unknown[]) => "token"), uid: "admin" };
const gateway: AuthGateway = {
  async getIdToken() { return "token"; },
  observe(listener) { listener(session); return () => undefined; },
  async refreshSession() { return session; },
  async sendEmailVerification() {}, async sendPasswordResetEmail() {},
  async signIn() { return session; }, async signOut() {},
};

function Harness({ apiClient, permissions, children }: { apiClient: Record<string, unknown>; permissions: string[]; children: React.ReactNode }) {
  const identity = { uid: "admin", email: "admin@acme.test", emailVerified: true, companyId: "acme", companyName: "Acme", roleKey: "company_admin", permissions: new Set(permissions) };
  return <ThemeProvider><ToastProvider><AuthProvider gateway={gateway} apiClient={{ registerCompanyAdmin: vi.fn(), getCurrentUser: vi.fn(async (..._args: unknown[]) => identity), ...apiClient }}><Ready>{children}</Ready></AuthProvider></ToastProvider></ThemeProvider>;
}

function Ready({ children }: { children: React.ReactNode }) {
  return useAuth().status === "authenticated" ? children : <p>restoring</p>;
}

const facility = { id: "facility-1", name: "North Process Plant" };
const permit = {
  id: "permit-1", permitNumber: "PTW-2026-0042", title: "Replace relief valve", permitType: "hot_work" as const,
  facilityId: facility.id, status: "draft" as const, highestResidualRisk: "medium" as const, workerCount: 1, revision: 1,
  validFrom: new Date("2026-08-20T08:00:00Z"), validUntil: new Date("2026-08-20T16:00:00Z"),
  createdAt: new Date("2026-08-19T00:00:00Z"), updatedAt: new Date("2026-08-19T00:00:00Z"),
};

function createSetup(overrides: Record<string, unknown> = {}) {
  return {
    listFacilities: vi.fn(async (..._args: unknown[]) => ({ items: [facility], nextCursor: null })),
    listUsers: vi.fn(async (..._args: unknown[]) => ({ items: [{ id: "worker-1", displayName: "Aisha Khan", email: "aisha@acme.test" }], nextCursor: null })),
    listPermitTemplates: vi.fn(async (..._args: unknown[]) => ({ items: [{ id: "template-1", name: "Hot work standard" }], nextCursor: null })),
    listAreas: vi.fn(async (..._args: unknown[]) => ({ items: [{ id: "area-1", name: "Compressor deck" }], nextCursor: null })),
    listAssets: vi.fn(async (..._args: unknown[]) => ({ items: [{ id: "asset-1", name: "Relief valve RV-22", areaId: "area-1" }], nextCursor: null })),
    ...overrides,
  };
}

describe("permit register and draft creation", () => {
  it("renders real permit records with resolved facility names", async () => {
    render(<Harness permissions={["permits.read"]} apiClient={{ listPermits: vi.fn(async (..._args: unknown[]) => ({ items: [permit], nextCursor: null })), listFacilities: vi.fn(async (..._args: unknown[]) => ({ items: [facility], nextCursor: null })) }}><PermitsPage /></Harness>);
    expect(await screen.findByText("PTW-2026-0042")).toBeInTheDocument();
    expect(screen.getByText("Replace relief valve")).toBeInTheDocument();
    expect(within(screen.getByRole("table", { name: "Permit register" })).getByText("North Process Plant")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Create permit" })).not.toBeInTheDocument();
  });

  it("sends permit type and facility filters to the API", async () => {
    const listPermits = vi.fn(async (..._args: unknown[]) => ({ items: [permit], nextCursor: null }));
    render(<Harness permissions={["permits.read"]} apiClient={{ listPermits, listFacilities: vi.fn(async (..._args: unknown[]) => ({ items: [facility], nextCursor: null })) }}><PermitsPage /></Harness>);
    await screen.findByText("PTW-2026-0042");
    const user = userEvent.setup();
    await user.selectOptions(screen.getByLabelText("Permit type"), "hot_work");
    await user.selectOptions(screen.getByLabelText("Facility"), "facility-1");
    await waitFor(() => expect(listPermits.mock.calls.at(-1)?.[0]).toMatchObject({ permitType: "hot_work", facilityId: "facility-1" }));
  });

  it("loads tenant facilities, workers, templates, areas, and assets", async () => {
    const api = createSetup();
    render(<Harness permissions={["permits.write"]} apiClient={api}><PermitCreatePage /></Harness>);
    expect(await screen.findByRole("heading", { name: "Create permit draft" })).toBeInTheDocument();
    expect(screen.getByRole("option", { name: "North Process Plant" })).toBeInTheDocument();
    expect(screen.getByRole("option", { name: /Aisha Khan/ })).toBeInTheDocument();
    expect(screen.getByRole("option", { name: "Hot work standard" })).toBeInTheDocument();
    await userEvent.setup().selectOptions(screen.getByLabelText("Facility"), "facility-1");
    expect(await screen.findByRole("option", { name: "Compressor deck" })).toBeInTheDocument();
    expect(screen.getByRole("option", { name: "Relief valve RV-22" })).toBeInTheDocument();
  });

  it("creates a validated draft with real selections and risk inputs", async () => {
    const createPermit = vi.fn(async (..._args: unknown[]) => ({ ...permit, permitNumber: "PTW-2026-0043" }));
    const api = createSetup({ createPermit });
    render(<Harness permissions={["permits.write"]} apiClient={api}><PermitCreatePage /></Harness>);
    await screen.findByRole("heading", { name: "Create permit draft" });
    const user = userEvent.setup();
    fireEvent.change(screen.getByLabelText("Title"), { target: { value: "Replace relief valve" } });
    fireEvent.change(screen.getByLabelText("Work description"), { target: { value: "Remove and replace the damaged relief valve." } });
    await user.selectOptions(screen.getByLabelText("Facility"), "facility-1");
    await user.selectOptions(screen.getByLabelText("Permit template"), "template-1");
    await user.selectOptions(screen.getByLabelText("Assigned workers"), "worker-1");
    fireEvent.change(screen.getByLabelText("Valid from"), { target: { value: "2026-08-20T08:00" } });
    fireEvent.change(screen.getByLabelText("Valid until"), { target: { value: "2026-08-20T16:00" } });
    fireEvent.change(screen.getByLabelText("Hazard 1"), { target: { value: "Ignition source" } });
    fireEvent.change(screen.getByLabelText("Persons at risk"), { target: { value: "Maintenance crew" } });
    fireEvent.change(screen.getByLabelText("Control measures"), { target: { value: "Gas test and fire watch" } });
    await user.click(screen.getByRole("button", { name: "Create draft" }));
    await waitFor(() => expect(createPermit).toHaveBeenCalledOnce());
    expect(createPermit).toHaveBeenCalledWith(expect.objectContaining({
      facilityId: "facility-1", templateId: "template-1", workerIds: ["worker-1"],
      validFrom: expect.any(Date), validUntil: expect.any(Date),
      riskAssessment: [expect.objectContaining({ hazard: "Ignition source", controls: "Gas test and fire watch" })],
    }));
    expect(pushMock).toHaveBeenCalledWith("/permits/permit-1");
  });

  it("blocks a residual risk score above the initial score", async () => {
    const createPermit = vi.fn();
    const api = createSetup({ createPermit });
    render(<Harness permissions={["permits.write"]} apiClient={api}><PermitCreatePage /></Harness>);
    await screen.findByRole("heading", { name: "Create permit draft" });
    await userEvent.setup().selectOptions(screen.getByLabelText("Residual likelihood"), "5");
    await userEvent.setup().selectOptions(screen.getByLabelText("Residual severity"), "5");
    await userEvent.setup().click(screen.getByRole("button", { name: "Create draft" }));
    expect(await screen.findByText("Residual risk cannot exceed initial risk")).toBeInTheDocument();
    expect(createPermit).not.toHaveBeenCalled();
  });

  it("does not load protected creation resources without permits.write", async () => {
    const listFacilities = vi.fn();
    render(<Harness permissions={["permits.read"]} apiClient={{ listFacilities }}><PermitCreatePage /></Harness>);
    expect(await screen.findByText("No access")).toBeInTheDocument();
    expect(listFacilities).not.toHaveBeenCalled();
  });
});
