"use client";

import type { DocumentListItem } from "@fev/api-client";
import { useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Button, Card, EmptyState, Input, Modal, MotionSection, Select, Skeleton, StatusPill, TableShell, useToast } from "@/design-system";

import { useDocumentsData } from "./documents-data";

const CATEGORIES = [
  { value: "sop", label: "SOPs" },
  { value: "manual", label: "Equipment Manuals" },
  { value: "safety_policy", label: "Safety Policies" },
  { value: "certificate", label: "Compliance Certificates" },
  { value: "drawing", label: "Engineering Drawings" },
  { value: "report", label: "Technical Reports" },
];

function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function categoryLabel(val: string): string {
  const found = CATEGORIES.find((c) => c.value === val);
  return found ? found.label : val.toUpperCase();
}

export function DocumentsPage() {
  const data = useDocumentsData();
  const { apiClient, currentUser } = useAuth();
  const toast = useToast();

  const [selectedDoc, setSelectedDoc] = useState<DocumentListItem | null>(null);
  const [isUploadOpen, setIsUploadOpen] = useState(false);
  const [newTitle, setNewTitle] = useState("");
  const [newCode, setNewCode] = useState("");
  const [newCategory, setNewCategory] = useState("sop");
  const [newDescription, setNewDescription] = useState("");
  const [newFilename, setNewFilename] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const canWrite = currentUser?.permissions.has("documents.write");

  async function handleCreateDocument(event: React.FormEvent) {
    event.preventDefault();
    if (!newTitle.trim() || !newCode.trim() || !newFilename.trim()) {
      toast.error("Please fill in document code, title, and filename");
      return;
    }
    setIsSubmitting(true);
    try {
      await apiClient.createDocument({
        id: `doc-${Date.now()}`,
        title: newTitle.trim(),
        documentCode: newCode.trim().toUpperCase(),
        category: newCategory as any,
        description: newDescription.trim() || undefined,
        filePath: `uploads/${newFilename.trim()}`,
        filename: newFilename.trim(),
        fileFormat: newFilename.endsWith(".docx") ? "docx" : "pdf",
        fileSizeBytes: 1048576,
        status: "active",
        tags: [newCategory.toUpperCase()],
      });
      toast.success("Document added successfully");
      setIsUploadOpen(false);
      setNewTitle("");
      setNewCode("");
      setNewDescription("");
      setNewFilename("");
      await data.refetch();
    } catch {
      toast.error("Failed to create document");
    } finally {
      setIsSubmitting(false);
    }
  }

  function downloadDocument(doc: DocumentListItem) {
    if (!doc.downloadUrl) {
      toast.error("Download URL unavailable");
      return;
    }
    window.open(doc.downloadUrl, "_blank", "noopener");
    toast.success(`Opening ${doc.filename}`);
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-7xl">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
              Enterprise Repository · Versioned
            </p>
            <h1 className="mt-2 text-h2 font-bold">Document Management</h1>
            <p className="mt-1 text-bodySmall text-text-secondary">
              Centralized repository for SOPs, equipment manuals, safety guidelines, and compliance certificates.
            </p>
          </div>
          {canWrite && (
            <Button onClick={() => setIsUploadOpen(true)}>+ Upload document</Button>
          )}
        </div>

        {/* Filters */}
        <Card className="mt-6 grid gap-4 sm:grid-cols-2">
          <Input
            label="Search documents"
            placeholder="Search by document code, title, or tags..."
            value={data.searchQuery}
            onChange={(e) => data.setSearch(e.target.value)}
          />
          <Select
            label="Category"
            value={data.categoryFilter ?? ""}
            onChange={(e) => data.setCategory(e.target.value || null)}
          >
            <option value="">All categories</option>
            {CATEGORIES.map((cat) => (
              <option key={cat.value} value={cat.value}>
                {cat.label}
              </option>
            ))}
          </Select>
        </Card>

        {/* Content Table / States */}
        {data.loading ? (
          <Card className="mt-6 space-y-3 p-6">
            <Skeleton className="h-8 w-full" />
            <Skeleton className="h-8 w-full" />
            <Skeleton className="h-8 w-full" />
          </Card>
        ) : data.error ? (
          <Card className="mt-6 p-6">
            <EmptyState
              title="Unable to load documents"
              description="Check connection and try again."
              action={<Button onClick={() => data.refetch()}>Retry</Button>}
            />
          </Card>
        ) : data.documents.length === 0 ? (
          <Card className="mt-6 p-6">
            <EmptyState
              title="No documents found"
              description="No documents match your filter or search criteria."
            />
          </Card>
        ) : (
          <div className="mt-6 overflow-hidden rounded-xl border border-border">
            <TableShell label="Documents">
              <thead>
                <tr className="border-b border-border bg-background text-left text-caption uppercase text-text-muted">
                  <th className="p-4 font-mono">Code</th>
                  <th className="p-4 font-mono">Title & Category</th>
                  <th className="p-4 font-mono">Format / Size</th>
                  <th className="p-4 font-mono">Status</th>
                  <th className="p-4 font-mono text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-surface-border">
                {data.documents.map((doc) => (
                  <tr
                    key={doc.id}
                    className="cursor-pointer transition-colors hover:bg-background/60"
                    onClick={() => setSelectedDoc(doc)}
                  >
                    <td className="p-4 font-mono text-bodySmall font-semibold text-primary-600 dark:text-primary-400">
                      {doc.documentCode}
                    </td>
                    <td className="p-4">
                      <p className="font-semibold text-text-primary">{doc.title}</p>
                      <p className="text-caption text-text-secondary">
                        {categoryLabel(doc.category)} · v{doc.version}
                      </p>
                    </td>
                    <td className="p-4 font-mono text-caption text-text-secondary">
                      {doc.fileFormat.toUpperCase()} · {formatBytes(doc.fileSizeBytes)}
                    </td>
                    <td className="p-4">
                      <StatusPill tone={doc.status === "active" ? "healthy" : "warning"}>
                        {doc.status.toUpperCase()}
                      </StatusPill>
                    </td>
                    <td className="p-4 text-right">
                      <Button
                        variant="ghost"
                        onClick={(e) => {
                          e.stopPropagation();
                          downloadDocument(doc);
                        }}
                      >
                        Download
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </TableShell>
          </div>
        )}

        {/* Document Detail Modal */}
        {selectedDoc && (
          <Modal
            title={selectedDoc.title}
            open={Boolean(selectedDoc)}
            onClose={() => setSelectedDoc(null)}
          >
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="font-mono text-bodySmall font-bold text-primary-600">
                  {selectedDoc.documentCode}
                </span>
                <StatusPill tone={selectedDoc.status === "active" ? "healthy" : "warning"}>
                  {selectedDoc.status.toUpperCase()}
                </StatusPill>
              </div>

              <div>
                <p className="text-caption text-text-muted">Category</p>
                <p className="font-semibold">{categoryLabel(selectedDoc.category)}</p>
              </div>

              <div>
                <p className="text-caption text-text-muted">File Format & Size</p>
                <p className="font-mono text-bodySmall">
                  {selectedDoc.fileFormat.toUpperCase()} · {formatBytes(selectedDoc.fileSizeBytes)} · v{selectedDoc.version}
                </p>
              </div>

              {selectedDoc.description && (
                <div>
                  <p className="text-caption text-text-muted">Description</p>
                  <p className="text-bodySmall text-text-secondary">{selectedDoc.description}</p>
                </div>
              )}

              {(selectedDoc.tags?.length ?? 0) > 0 && (
                <div>
                  <p className="text-caption text-text-muted">Tags</p>
                  <div className="mt-1 flex flex-wrap gap-1">
                    {(selectedDoc.tags ?? []).map((tag) => (
                      <span
                        key={tag}
                        className="rounded bg-background px-2 py-0.5 text-caption font-mono"
                      >
                        #{tag}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <div className="pt-4 flex justify-end gap-3">
                <Button variant="ghost" onClick={() => setSelectedDoc(null)}>
                  Close
                </Button>
                <Button onClick={() => downloadDocument(selectedDoc)}>Download document</Button>
              </div>
            </div>
          </Modal>
        )}

        {/* Upload Modal */}
        {isUploadOpen && (
          <Modal
            title="Upload Document Metadata"
            open={isUploadOpen}
            onClose={() => setIsUploadOpen(false)}
          >
            <form onSubmit={handleCreateDocument} className="space-y-4">
              <Input
                label="Document Code"
                placeholder="e.g. DOC-SOP-2026-001"
                value={newCode}
                onChange={(e) => setNewCode(e.target.value)}
                required
              />
              <Input
                label="Title"
                placeholder="e.g. Pump P-101 Emergency SOP"
                value={newTitle}
                onChange={(e) => setNewTitle(e.target.value)}
                required
              />
              <Select
                label="Category"
                value={newCategory}
                onChange={(e) => setNewCategory(e.target.value)}
              >
                {CATEGORIES.map((cat) => (
                  <option key={cat.value} value={cat.value}>
                    {cat.label}
                  </option>
                ))}
              </Select>
              <Input
                label="Filename"
                placeholder="e.g. DOC-SOP-001_pump_sop.pdf"
                value={newFilename}
                onChange={(e) => setNewFilename(e.target.value)}
                required
              />
              <div>
                <label className="text-caption font-medium text-text-secondary">Description</label>
                <textarea
                  className="mt-1 w-full rounded-lg border border-border bg-background p-3 text-bodySmall"
                  rows={3}
                  value={newDescription}
                  onChange={(e) => setNewDescription(e.target.value)}
                  placeholder="Enter detailed document description..."
                />
              </div>
              <div className="pt-4 flex justify-end gap-3">
                <Button variant="ghost" type="button" onClick={() => setIsUploadOpen(false)}>
                  Cancel
                </Button>
                <Button type="submit" loading={isSubmitting}>
                  Save Document
                </Button>
              </div>
            </form>
          </Modal>
        )}
      </MotionSection>
    </section>
  );
}
