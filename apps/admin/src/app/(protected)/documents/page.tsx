import type { Metadata } from "next";

import { protectedPage } from "@/seo/site";

export const metadata: Metadata = protectedPage("Documents");

import { DocumentsPage } from "@/documents/documents-page";

export default function Page() {
  return <DocumentsPage />;
}
