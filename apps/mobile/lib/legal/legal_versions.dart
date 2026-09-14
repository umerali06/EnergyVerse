/// The published version of the legal document set.
///
/// Mirrors `LEGAL_VERSION` in `apps/admin/src/legal/legal-content.ts` and
/// `CURRENT_LEGAL_VERSION` in `apps/api/app/legal/versions.py`. All three are
/// bumped together when a material change is published: the client records the
/// version it displayed, and the server compares against its own to decide
/// whether an earlier acceptance still covers the current documents.
const String kLegalVersion = '2026-09-14';

/// Where the published policies live, for the links on the acknowledgment.
const String kLegalBaseUrl = 'https://www.flacronenergy.com';
