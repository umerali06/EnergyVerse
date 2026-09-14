"""The published version of the legal document set.

Mirrors `LEGAL_VERSION` in `apps/admin/src/legal/legal-content.ts`. Both are
bumped together when a material change is published: the client records the
version it displayed, and the server compares against this to decide whether an
earlier acceptance still covers the current documents.
"""

CURRENT_LEGAL_VERSION = "2026-09-14"
