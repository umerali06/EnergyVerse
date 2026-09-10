import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { AuthContext, type AuthContextValue } from "@/auth/auth-context";
import { ToastProvider } from "@/design-system";
import { DocumentsPage } from "./documents-page";

const mockDocument = {
  id: "doc-1",
  title: "High Pressure Feed Pump SOP",
  documentCode: "DOC-SOP-001",
  category: "sop" as const,
  description: "Standard operating procedure",
  filePath: "sops/sop.pdf",
  filename: "sop.pdf",
  fileFormat: "pdf" as const,
  fileSizeBytes: 2048000,
  version: 1,
  status: "active" as const,
  tags: ["SOP"],
  downloadUrl: "https://example.com/sop.pdf",
  createdBy: "demo-user",
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString(),
};

function renderPage() {
  const authValue: AuthContextValue = {
    apiClient: {
      listDocuments: vi.fn().mockResolvedValue({ items: [mockDocument], nextCursor: null }),
      createDocument: vi.fn().mockResolvedValue(mockDocument),
    } as any,
    currentUser: {
      uid: "user-1",
      email: "admin@example.com",
      emailVerified: true,
      companyId: "acme-energy",
      companyName: "Acme Energy",
      companyTimezone: "UTC",
      companyLocale: "en-US",
      roleKey: "company_admin",
      permissions: new Set(["documents.read", "documents.write"]),
    },
    error: null,
    status: "authenticated",
    refreshSession: vi.fn(),
    refreshVerification: vi.fn(),
    register: vi.fn(),
    resendVerification: vi.fn(),
    sendPasswordReset: vi.fn(),
    sendUserInviteEmail: vi.fn(),
    signIn: vi.fn(),
    signOut: vi.fn(),
    verificationSentAt: null,
    passwordResetSentAt: null,
  };

  return render(
    <AuthContext.Provider value={authValue}>
      <ToastProvider>
        <DocumentsPage />
      </ToastProvider>
    </AuthContext.Provider>,
  );
}

describe("DocumentsPage", () => {
  it("renders document management header and list table", async () => {
    renderPage();
    expect(screen.getByText("Document Management")).toBeInTheDocument();
    expect(await screen.findByText("DOC-SOP-001")).toBeInTheDocument();
    expect(screen.getByText("High Pressure Feed Pump SOP")).toBeInTheDocument();
  });
});
