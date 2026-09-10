import { describe, expect, it, vi } from "vitest";

import { FevApiClient } from "@/api";

/**
 * Guards the two client methods the documents page depends on.
 *
 * They were missing entirely: the page and its data hook shipped in Phase 11,
 * but `FevApiClient` never gained `listDocuments`/`createDocument`, so
 * `apiClient.listDocuments` was `undefined`, the call threw, and the list
 * rendered "Unable to load documents" on every load regardless of plan or
 * permissions.
 */
describe("documents transport", () => {
  it("requests the tenant document list with its filters", async () => {
    const fetchApi = vi.fn(async (..._args: unknown[]) =>
      new Response(JSON.stringify({ items: [], next_cursor: null }), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }),
    );
    const client = new FevApiClient({ fetchApi, getIdToken: async () => "token" });

    const page = await client.listDocuments({ category: "certificate", limit: 20 });

    expect(page.items).toEqual([]);
    const url = String(fetchApi.mock.calls[0]?.[0]);
    expect(url).toContain("/api/v1/documents");
    expect(url).toContain("category=certificate");
    expect(url).toContain("limit=20");
  });

  it("posts a create as the request body the API declares", async () => {
    const fetchApi = vi.fn(async (..._args: unknown[]) =>
      new Response(JSON.stringify({ id: "doc-1", title: "SOP" }), {
        status: 201,
        headers: { "Content-Type": "application/json" },
      }),
    );
    const client = new FevApiClient({ fetchApi, getIdToken: async () => "token" });

    await client.createDocument({
      id: "doc-1",
      title: "SOP",
      documentCode: "DOC-1",
      category: "sop",
      filePath: "uploads/sop.pdf",
      filename: "sop.pdf",
      fileFormat: "pdf",
      fileSizeBytes: 1024,
      status: "active",
    } as Parameters<FevApiClient["createDocument"]>[0]);

    const init = fetchApi.mock.calls[0]?.[1] as RequestInit;
    expect(init.method).toBe("POST");
    // Wire names, and no camelCase leak (the strict-model trap from D-095).
    const body = JSON.parse(String(init.body));
    expect(body.document_code).toBe("DOC-1");
    expect(body).not.toHaveProperty("documentCode");
  });
});
