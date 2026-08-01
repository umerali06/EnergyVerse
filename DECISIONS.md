# FEV Decision Log

## Resolved Decisions

| ID | Decision | Chosen Option | Status | Date |
|---|---|---|---|---|
| D-001 | Backend framework | **FastAPI (Python 3.11+)** | **RESOLVED — LOCKED** | 2026-07-15 |
| D-002 | Primary database and AI vector storage | **Firebase Firestore** (server-side only via FastAPI + Admin SDK) | **RESOLVED — LOCKED** | 2026-07-15 |
| D-003 | Authentication provider | **Firebase Authentication** (email/password + verification + reset) | **RESOLVED — LOCKED** | 2026-07-15 |
| D-004 | Firestore tenancy pattern | **Top-level collections with required backend `CompanyScope`** | **RESOLVED — LOCKED** | 2026-07-15 |
| D-005 | Document metadata contracts | **Explicit `TenantDoc`, `GlobalDoc`, and `AppendOnlyDoc` bases** | **RESOLVED — LOCKED** | 2026-07-15 |
| D-006 | Super Admin cross-tenant repository access | **Deferred until verified post-auth trusted context exists** | **RESOLVED — LOCKED** | 2026-07-15 |
| D-007 | Backend token verification boundary | **Provider-neutral `TokenVerifier` protocol with Firebase adapter** | **RESOLVED — LOCKED** | 2026-07-16 |
| D-008 | RBAC denial contract and enforcement authority | **401 for authentication; 403 for authorization; server authoritative, UI advisory** | **RESOLVED — LOCKED** | 2026-07-16 |
| D-009 | Cross-client design language and motion | **Industrial blue/orange brand with one generated token source and reduced-motion-aware client implementations** | **RESOLVED — LOCKED** | 2026-07-16 |
| D-010 | API contract, generated clients, and error strategy | **OpenAPI 3.1 → pinned TypeScript Fetch/Dart Dio clients; unified request-ID error envelope; CI drift rejection** | **RESOLVED — LOCKED** | 2026-07-16 |
| D-011 | Client authentication state | **Firebase client SDK + one auth provider resolving authoritative `/me` identity** | **RESOLVED — LOCKED** | 2026-07-17 |
| D-012 | Self-serve tenants and verified-email enforcement | **Public signup creates a new generated-ID tenant; application gates require a verified Firebase email** | **RESOLVED — LOCKED** | 2026-07-17 |
| D-013 | Password reset flow and account privacy | **Client-SDK reset send with Firebase hosted completion; responses never disclose account existence** | **RESOLVED — LOCKED** | 2026-07-18 |
| D-014 | Session lifecycle and route-guard strategy | **Client-layout guards over one auth provider; 401 → one forced refresh + retry, then clean expiry; server gates stay authoritative** | **RESOLVED — LOCKED** | 2026-07-18 |
| D-015 | Shell navigation and unbuilt-module policy | **One declarative nav config per client (documented mirror contract); permission-filtered via 0.6 helpers; unbuilt modules show branded "Coming soon"; unfinished platform features render visibly disabled** | **RESOLVED — LOCKED** | 2026-07-19 |
| D-016 | Design language direction | **Industrial instrumentation identity: Space Grotesk / IBM Plex Sans / IBM Plex Mono (machine values), layered dark surfaces with luminous 1px borders instead of drop shadows, rare orange accent, enterprise density, 120–240ms motion on cubic-bezier(0.16, 1, 0.3, 1) — all via tokens.json only** | **RESOLVED — LOCKED** | 2026-07-19 |
| D-017 | Brand palette and logo assets | **All brand color derives from the official logo — sampled orange #FB4402 and navy #002865 as OKLCH 50–900 scales; navy-hue dark surfaces; theme-specific action lightness; crimson #C1123F critical distinct from brand orange; statusStrong/statusSoft per-theme text sets; logo variants derived mechanically from the supplied master, consumed only through theme-aware Logo components** | **RESOLVED — LOCKED** | 2026-07-19 |
| D-018 | SEO, theming enforcement, and motion/performance policy | **Public routes fully indexed with colocated declarative metadata, in-shell routes noindex with unique titles; raw hex/font-family outside the token layer fails CI in both clients; Framer Motion only (GSAP route-dynamic if ever needed), transform+opacity, token durations; 430 KB bundle budget and Lighthouse baselines recorded** | **RESOLVED — LOCKED** | 2026-07-19 |
| D-019 | Dashboard read-cost and no-invented-data policy | **Every dashboard number/chart/feed row comes from real companies/users/roles/audit_logs — no placeholder counts or sample charts, ever; audit aggregation is bounded to one composite-indexed query per request (company_id ==, created_at >=, ≤90-day window, 5000-doc in-memory cap); unbuilt-module KPIs render a fixed honest empty-state tile, gated by that module's own future permission** | **RESOLVED — LOCKED** | 2026-07-21 |
| D-020 | Reusable chart infrastructure | **One themed chart wrapper per client (Recharts on admin, fl_chart on mobile) is the only way any screen renders a chart — token colors only, shared loading/error/empty/ready states, reduced-motion-capped entry animation; future modules extend it rather than hand-rolling chart theming** | **RESOLVED — LOCKED** | 2026-07-21 |
| D-021 | Invite delivery mechanism | **Invited users never receive a backend-generated password; `provision_user` creates the Firebase Auth account with `password=None` and the admin client sends the same `sendPasswordResetEmail` the 1.3 forgot-password flow already uses — no transactional-email service is built for this** | **RESOLVED — LOCKED** | 2026-07-21 |
| D-022 | Last-admin and self-action protection | **A user can never deactivate or demote themselves out of an admin role; the last active `company_admin` in a tenant can't be deactivated or demoted by anyone; Super Admin is never an assignable role from the user-management UI even though every tenant has a seeded `super_admin` role document** | **RESOLVED — LOCKED** | 2026-07-21 |
| D-023 | Mobile read-only user management scope | **Mobile ships list + detail only for Phase 3.1; invite, edit, and status changes are admin-web-only — a deliberate scope choice, not an omission, since field users rarely administer accounts from a phone** | **RESOLVED — LOCKED** | 2026-07-21 |
| D-024 | System-role immutability and visibility | **`is_system=true` roles can never be renamed, re-permissioned, or deleted through any 3.2 endpoint — only custom roles are mutable; `super_admin` stays invisible to every company-scoped roles endpoint, same as the 3.1 role picker** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-025 | `platform.admin` grant restriction and claims-sync timing | **`platform.admin` can never be included in a Company Admin's create/update payload (403, not silently dropped); a role-permission edit still triggers a batched `sync_claims_from_role` for every current holder for claims consistency, even though `/me` already resolves permissions live from Firestore on every request, so enforcement is immediate — only the client's cached permission view waits for the next login/session refresh** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-026 | Mobile read-only role management scope | **Mobile ships list + detail only for Phase 3.2, mirroring D-023 — creating, editing, and deleting roles remain admin-web-only** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-027 | Firebase Storage security model and path convention | **Storage is server-mediated only, mirroring D-002's Firestore precedent — `storage.rules` denies all client read/write unconditionally; every upload/delete goes through the Admin SDK and every read is a fresh request-time V4 signed URL, never a public object or a persisted URL; every object lives under a fixed `companies/{company_id}/{feature}/...` path (3.3's logo at `companies/{company_id}/branding/logo`, always overwritten in place) that later phases (assets, inspections) must reuse rather than inventing their own convention** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-028 | Company settings scope policy | **Only settings with a real, working consumer today ship in 3.3 (industry, timezone/locale threaded into existing date displays, contact info, logo); `subscription_tier` stays read-only with tier-limit enforcement explicitly deferred to a later phase, and no placeholder settings for unbuilt modules (e.g. AI thresholds, IoT config) are added ahead of their own phases** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-029 | Audit viewer role mapping, query shape, and export policy | **`audit.read` added to the catalog and granted to `company_admin`/`super_admin` (automatic), `hse_manager`, and `executive`, not field/technician roles; the viewer's date range is the real Firestore query bound (reusing the single existing `company_id + created_at` index, zero new indexes) with actor/action/target/text filters applied in-memory over that bounded read; CSV export streams the same bounded/filtered set directly (no Storage round trip), capped at 25,000 rows; reading the audit log is itself never audited** | **RESOLVED — LOCKED** | 2026-07-22 |
| D-030 | Super-Admin cross-tenant trust model (resolves D-006) | **A new `AdminScope`, constructible only from a verified `platform.admin` permission, is the sole path to `/api/v1/platform/*`; every existing company-scoped route stays untouched; cross-tenant mutations dual-write to the target tenant's own audit trail and a reserved `"__platform__"` pseudo-tenant trail; a suspended company blocks its users at `get_current_user` itself (stricter than unverified-email); `subscription_tier` becomes a locked 4-value enum; platform administration is web-only** | **RESOLVED — LOCKED** | 2026-07-23 |
| D-031 | Asset hierarchy depth and self-nesting | **Locked three-level hierarchy `Facility → Area → Asset`, plus an optional `parent_asset_id` self-reference on `Asset` for component/sub-asset nesting instead of a separate rigid component collection** | **RESOLVED — LOCKED** | 2026-07-23 |
| D-032 | Asset category extensibility | **`category` is a validated `str` against a code-level catalog (`ASSET_CATEGORIES` + `Other`), not a schema-level enum — adding a category is a one-line constant change, never a migration** | **RESOLVED — LOCKED** | 2026-07-23 |
| D-033 | Asset history-by-reference and soft-delete cascade | **No inspection/maintenance history is embedded on `Asset`; `GET /assets/{id}/history` returns a real, always-empty, correctly-shaped page that later modules fill by querying their own collections. Facilities/areas/assets get the codebase's first soft delete (`deleted_at` stamped, never physically removed); deleting a facility/area with any non-deleted child returns 409, mirroring the existing `role_has_assigned_users` precedent; an asset's soft-delete is never blocked by child sub-assets, since the parent row still resolves afterward** | **RESOLVED — LOCKED** | 2026-07-23 |
| D-034 | Mobile asset detail presentation | **Pushed named route (`Navigator.pushNamed` + arguments), not a bottom sheet** — first departure from the Users/Audit/Roles `showAppModal` convention | **RESOLVED — LOCKED** | 2026-07-26 |
| D-035 | Asset GPS location display depth (Phase 4.2) | **Coordinates readout + external "view on map" link only; no embedded Google Maps Platform integration** | **RESOLVED — LOCKED** | 2026-07-26 |
| D-036 | Asset identity and private-media contract | **`asset_tag` is case-insensitively unique within a company (duplicate creates/updates return 409); media is private under `companies/{company_id}/assets/{asset_id}/{kind}/{uuid}_{filename}` with one-hour signed URLs. Caps: photos 10 MiB, documents 25 MiB, manuals 50 MiB. Photos accept JPEG/PNG/WEBP/HEIC; documents accept PDF/DOC/DOCX/JPEG/PNG/WEBP; manuals accept PDF/DOC/DOCX. Atomic Firestore array transforms prevent concurrent uploads from overwriting each other.** | **RESOLVED — LOCKED** | 2026-07-27 |
| D-037 | Permanent native application identity | **Android `applicationId` and namespace plus iOS `PRODUCT_BUNDLE_IDENTIFIER` are permanently `com.flacronenterprises.energyverse`; the user-visible native app name is `EnergyVerse`. This identity is tied to signing, Firebase native app registrations, deep links, and store listings and must not be renamed casually.** | **RESOLVED — LOCKED** | 2026-07-27 |
| D-038 | Pluggable dashboard KPI widget framework (resolves 2.3 deferral) | **A widget is `{id, title, requiredPermission, minTier?, render/builder}`; modules call `registerWidget`/`registerDashboardWidget` once, `DashboardWidgetGrid` filters by permission + tier and renders each in its own failure boundary. Replaces 2.2's hardcoded `ReservedKpiRegion` array with the same visual contract, now data-driven.** | **RESOLVED — LOCKED** | 2026-07-28 |
| D-039 | Asset KPI aggregation via Firestore `count()` | **Every asset KPI number (total/status/category/facility counts) comes from a Firestore `count()` aggregation query — never a bounded full-document read — scoped by `company_id` + `deleted_at == None` plus at most one more equality filter, run concurrently via `asyncio.gather`. Chosen over maintained counters (too invasive for the current need) and over the D-019-style bounded-read-then-count pattern (would download every asset document just to produce integers).** | **RESOLVED — LOCKED** | 2026-07-28 |
| D-040 | Phase evidence policy — no screenshot capture | **Every future phase's completion evidence is limited to automated test suites (unit/integration/widget), lint/type-check output, and contract-drift proof, plus real-creds backend verification when credentials are available in-session. Browser/simulator screenshot capture is no longer part of the contract at all — not attempted, not deferred, not apologized for. Visual/UX correctness is verified by the human manually.** | **RESOLVED — LOCKED** | 2026-07-28 |
| D-043 | Inspection sync contract — client-generated id + monotonic revision | **`inspections` documents use a client-generated UUID as the document id; `POST /inspections` is an idempotent upsert-by-id (byte-identical resubmit is a no-op, a conflicting resubmit is `409`) and returns a fixed `200`, never `201`. A monotonic integer `revision` (not a timestamp) is the conflict-resolution primitive — chosen specifically to be immune to cross-device clock skew, a real bug already hit in this dev environment. `PATCH` accepts `expected_revision`; a mismatch is `409 revision_conflict`. 7.2's offline engine implements last-writer-wins-by-revision against this contract; only the API/model support ships in 7.1.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-044 | Checklist template light versioning + inspection-time snapshot | **`checklist_templates` has no separate version-history collection — a lightweight `version: int` bumps by 1 on every accepted edit. Assigning a template to an inspection snapshots its `items[]` and current `version` onto the inspection (`checklist_items_snapshot`/`checklist_template_version`), so a later template edit never corrupts a past inspection's answered checklist.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-045 | Inspection lifecycle, checklist-response API surface, and real "Start Inspection" | **Lifecycle is `draft → in_progress → completed`, plus `cancelled` (reachable from `draft`/`in_progress`, added beyond the brief's three states so an abandoned draft can be closed out); `completed`/`cancelled` are terminal. `complete` validates every required snapshot item has a response (422 `checklist_incomplete` otherwise) but succeeds cleanly when no template was ever assigned. `checklist_responses[]` is accepted and validated by the backend API in 7.1 (unknown/duplicate `item_id`, type-mismatched value all 422) even though no admin/mobile screen lets a human fill one in yet — required to make the brief's own "complete blocks on missing required items" test possible; the interactive capture UI is 7.3's job. Mobile's "Start Inspection" (QR scan result) now creates a real `draft` via the API (client UUID, `ad_hoc` type, no device/GPS metadata — no such package exists yet) and lands on the real read-only inspection detail screen, replacing the prior `ComingSoonScreen` stub. `operations_manager`/`field_inspector`/other roles' existing `inspections.read`/`.write` grants are left untouched; only new `checklist_templates.read`/`.write` permissions are added (operations_manager gets both, read-only roles get `.read`) — the client spec's "Ops Manager assigns" capability is deferred until 7.11's admin review UI actually needs it.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-041 | Opaque QR token generation | **`qr_code_id` is `secrets.token_urlsafe(16)` (~128 bits), generated at asset-creation time and by a one-time cross-tenant backfill script for pre-existing assets — never derived from or equal to the asset's own id/UUID, so a printed/scanned code can't be used to enumerate a tenant's assets. Collision-checked against `AssetRepository.get_by_qr_code` before acceptance (defense in depth over entropy alone).** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-042 | QR deep-link payload and cross-tenant resolve policy | **The QR image encodes `{APP_BASE_URL}/qr/{code}` (new `Settings.app_base_url`, defaults to the admin app's own dev origin) — the admin's own `/qr/{code}` page resolves it directly today; it becomes a real Universal/App Link with zero payload change once production domain-association infrastructure exists (not built this phase). Mobile's camera scan never depends on OS link registration — it decodes the scanned text in-app. `GET /api/v1/qr/{code}/resolve` is gated by `assets.read`; a code belonging to another tenant returns the identical `404 qr_code_not_found` as a genuinely unknown code (never 403), so a scan can't be used to probe whether a code exists outside the caller's tenant. Every resolve is audited.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-046 | Offline local database: Drift, not Isar | **`LocalInspections`/`Outbox` are built on Drift (SQLite FFI) — the existing mobile CI job has no native-binary-fetch step Isar would have needed. Generated `*.g.dart` is gitignored, not committed, unlike `packages/contracts`.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-047 | Offline sync/conflict policy: sequential outbox, revision-based conflict surfacing | **The sync engine replays the outbox strictly one row at a time through 7.1's per-item endpoints — no batch-sync endpoint. Conflict detection is last-writer-wins by revision end to end, with a minimal two-button ("keep mine"/"use server's") resolution UI, no field-by-field merge view.** | **RESOLVED — LOCKED** | 2026-07-29 |
| D-048 | Checklist-template auto-selection at inspection start | **Auto-selection matches the asset's category among locally-cached templates; if more than one is active for that category, the most-recently-updated one wins; falls back to the most-recently-updated `Generic` template if no category match; leaves the inspection untemplated (an already-supported state) if neither is cached. Runs entirely from a local cache refreshed best-effort after sign-in — no network call sits in the inspection-start path.** | **RESOLVED — LOCKED** | 2026-07-30 |
| D-049 | Checklist-response merge is upsert-by-`item_id`, not whole-array replace | **A real bug, not a design choice: both `LocalInspectionsRepository.updateInspection` and `InspectionService.update_inspection` replaced the entire `checklist_responses` array with whatever a request contained. Harmless under 7.2 (never exercised with a partial update); would have silently erased prior answers under 7.3's per-item autosave. Fixed as an upsert-by-`item_id` on both the mobile repository and the backend service.** | **RESOLVED — LOCKED** | 2026-07-30 |
| D-050 | Inspection-start GPS capture is best-effort and non-blocking | **`captureCurrentPosition()` (new `geolocator` dependency) checks/requests permission and reads a position with an 8s limit, wrapped in its own outer 10s timeout so a hung or unmocked platform channel can never block starting an inspection. A denied, unavailable, or timed-out reading resolves to `(null, null)` — GPS is optional server-side, so this never blocks the field workflow.** | **RESOLVED — LOCKED** | 2026-07-30 |

## Decision Details

### D-001 — Backend Framework → FastAPI (Python 3.11+)

- **Decision owner:** Product owner
- **Chosen option:** FastAPI (Python 3.11+)
- **Context and rationale:** FastAPI is the ONLY tier that touches the database, via the Firebase Admin SDK. No direct client access to Firestore.
- **Alternatives considered:** NestJS (Node.js)
- **Consequences:** All backend development in Python; Poetry for dependency management; ruff + mypy for linting/type-checking.

### D-002 — Database → Firebase Firestore

- **Decision owner:** Product owner
- **Chosen option:** Firebase Firestore, accessed server-side only through FastAPI
- **Context and rationale:** Firestore Security Rules locked to server-only. No separate vector store for MVP (revisit only if AI embeddings need it later). No direct client access.
- **Alternatives considered:** PostgreSQL (explicitly ruled out per source brief)
- **Consequences:** Data modeling uses Firestore collections/documents; tenant isolation via `company_id` on every record; offline sync handled at the app layer with server reconciliation.

### D-003 — Authentication → Firebase Authentication

- **Decision owner:** Product owner
- **Chosen option:** Firebase Authentication (email/password + verification + reset)
- **Context and rationale:** `role` + `company_id` stored in custom claims. FastAPI verifies the Firebase ID token via the Admin SDK. Provider-agnostic seam preserved so enterprise SSO/SAML/OIDC slots in later.
- **Alternatives considered:** Custom authentication
- **Consequences:** Token verification in FastAPI middleware; custom claims for RBAC; abstraction layer for future SSO integration.

### D-004 — Firestore Tenancy → Top-Level Collections + Required Company Scope

- **Decision owner:** Product owner
- **Chosen option:** Top-level collections; every tenant-owned document carries `company_id`, and every tenant repository method requires a `CompanyScope`.
- **Context and rationale:** Tenantless backend calls must be impossible by construction. Scoped list operations filter in Firestore, while direct document reads also verify the stored `company_id` before returning data.
- **Intentional exceptions:** `companies` is the tenant-root collection whose document ID is the tenant identity. `permissions` is a system-managed global catalog. Neither exposes a general cross-tenant tenant-data query.
- **Consequences:** Future tenant-owned repositories must inherit the same scoped pattern. Firestore client rules remain deny-all; the backend is authoritative.

### D-005 — Base Contracts → TenantDoc, GlobalDoc, AppendOnlyDoc

- **Decision owner:** Product owner
- **Chosen option:** Per-collection contracts take precedence over the earlier default-field shorthand.
- **Contracts:** `TenantDoc` = `company_id`, `created_at`, `updated_at`, `created_by`; `GlobalDoc` = `created_at`, `updated_at`; `AppendOnlyDoc` = `created_at`, `actor_uid`.
- **Assignments:** Users, roles, and role-permissions use `TenantDoc`; companies and permissions use `GlobalDoc` (companies additionally allow nullable `created_by`); audit logs use `AppendOnlyDoc` plus `company_id` and expose no update/delete operation.
- **Consequences:** Central stamp helpers create metadata consistently, and tests assert exact field sets and exceptions.

### D-006 — Super Admin Cross-Tenant Access → Deferred

- **Decision owner:** Product owner
- **Chosen option:** No cross-tenant repository API in Phase 0.4.
- **Context and rationale:** Before Firebase token verification and trusted custom claims exist, a cross-tenant method would be an unguarded backdoor.
- **Consequences:** Even the `super_admin` template remains company-scoped in repositories. A future post-auth phase may introduce an explicit trusted context only after verifying Firebase claims including `role=super_admin`.

### D-007 — Token Verification → Provider-Neutral Protocol

- **Decision owner:** Product owner
- **Chosen option:** FastAPI auth dependencies consume a `TokenVerifier` protocol;
  `FirebaseTokenVerifier` is the current implementation.
- **Context and rationale:** This reaffirms D-003's enterprise SSO seam. Firebase
  verifies issuance, expiry, revocation, and signature today without coupling route
  dependencies or `CurrentUser` resolution to the provider SDK.
- **Trust boundary:** Verified `uid` and `company_id` select a required
  `CompanyScope`; Firestore user status, role membership, and effective permissions
  are reloaded through Phase 0.4 repositories and remain authoritative.
- **Consequences:** A later SAML/OIDC adapter can implement the same protocol.
  Permission-specific dependencies are intentionally deferred to Phase 0.6.

### D-008 — RBAC Enforcement → Server-Authoritative 401/403 Contract

- **Decision owner:** Product owner
- **Chosen option:** HTTP 401 answers “who are you?” for missing/invalid identity;
  HTTP 403 answers “you cannot do this” after authentication. Authentication and
  authorization retain distinct machine codes/statuses inside the Phase 0.8
  unified error envelope; authorization context is nested under `details`.
- **Authority:** FastAPI permission dependencies are the security boundary. Next.js
  and Flutter guards mirror effective permissions only for user experience and can
  never authorize an API operation.
- **Denial trace:** Permission/role gates attempt a company-scoped
  `access.denied` audit containing route, required keys, missing keys, and mode.
  Audit failure is logged but does not change the 403 result.
- **Super Admin:** No cross-tenant bypass exists. A scoped Super Admin passes only
  through its full Phase 0.4 permission mapping, preserving D-006.
- **Consequences:** Feature routes added later must prefer permission gates;
  `require_role` is reserved for the few policies that are inherently role-based.

### D-009 — Design System → Shared Tokens, Industrial Brand, and Motion Spec

- **Decision owner:** Product owner
- **Brand:** Electric blue `#2563EB` is primary, energy orange `#F97316` is
  accent, and the dark industrial layers are `#0A0E1A`, `#111827`, and
  `#1A2234`. Dark is the default; an accessible light theme is supported and the
  user's choice persists locally.
- **Typography:** Inter is the technical sans family and JetBrains Mono is used
  for identifiers/codes. Both are bundled under the OFL so rendering does not
  depend on a network font request.
- **Single source:** Framework-neutral `packages/design-tokens/tokens.json` owns
  visual and motion values. A deterministic generator emits committed admin
  TypeScript/CSS and mobile Dart bindings; generated files are not edited by hand.
- **Motion:** Fast/standard/slow durations, shared easing curves, and stagger
  timing define hover/press, fade-slide, list, modal, and shimmer behavior.
  Next.js uses Framer Motion and Flutter uses framework animations. Both honor the
  platform reduced-animation setting.
- **Consequences:** All future screens reuse the shared primitives and tokens.
  New visual values or reusable components are added centrally, never copied into
  a feature. The showcases remain development-only and are not product screens.

### D-010 — API Contract → Generated Clients and Unified Errors

- **Decision owner:** Product owner
- **Source of truth:** FastAPI emits OpenAPI 3.1 and a reproducible script commits
  `packages/contracts/openapi.json`. Every route owns a stable operation ID, tag,
  typed success response, and error response metadata.
- **Generators:** OpenAPI Generator 7.10.0 uses `typescript-fetch` for admin and
  `dart-dio` for mobile. The CLI wrapper is pinned at 2.15.3; CI pins Python 3.11,
  Poetry 2.4.1, Node 22.22.0, pnpm 9.15.9, Temurin Java 17.0.16+8, and Flutter
  3.44.6. Generated outputs and dependency locks are committed.
- **Drift rule:** API change → export spec → regenerate both clients. CI repeats
  that exact sequence and fails if `packages/contracts` differs.
- **Success contract:** Single resources are their typed shape. Future lists are
  `{items, next_cursor}` with an opaque nullable cursor; `null` means no further
  page. Total counts are excluded by default because Firestore counts have a cost.
- **Failure contract:** All failures are
  `{error, message, details?, request_id}` and echo `X-Request-ID`. HTTP status
  retains meaning; 401 and 403 preserve D-008, with RBAC context under `details`.
  Unhandled errors never expose stack traces.
- **Client boundary:** Next.js and Flutter use wrappers over generated clients for
  token injection, typed error translation, 401 callbacks, request-ID diagnostics,
  network handling, and Phase 0.7 toast/snackbar feedback. Direct feature-level
  transport calls are prohibited.

### D-011 — Client Authentication → Firebase SDK + One Auth Provider

- **Decision owner:** Product owner
- **Chosen option:** Use the Firebase client SDK in each client and keep one
  lightweight auth provider as the source of resolved application identity.
- **Configuration:** Next.js reads the six public `NEXT_PUBLIC_FIREBASE_*` values;
  Flutter receives the same public values through `--dart-define`. Firebase owns
  default web session persistence. Native Firebase configuration files are deferred
  until Android/iOS builds enter scope.
- **Identity chain:** Email/password credentials go only to Firebase. After sign-in,
  the Phase 0.8 wrapper injects the Firebase ID token into `/api/v1/auth/me`; the
  returned Phase 0.5 `CurrentUser` supplies tenant, role, and effective permissions.
  Raw tokens and passwords are never stored in application state or logged.
- **Failure policy:** Invalid credentials never reveal whether the email exists.
  Disabled, rate-limited, network, and inactive/missing-Firestore-user cases receive
  dedicated friendly feedback through Phase 0.7 toast/snackbar infrastructure. A
  `/me` 403 immediately signs the Firebase session out.
- **Consequences:** Session restoration and minimal sign-out are available now.
  Signup/verification, reset, comprehensive refresh, and route-guard hardening stay
  in their scheduled Phase 1 slices; client identity never replaces API enforcement.

### D-012 — Self-Serve Tenants and Verified-Email Enforcement

- **Decision owner:** Product owner
- **Tenant creation:** Public signup creates a new company only. Its ID is an
  opaque generated value; company display names are not unique. The first user is
  provisioned as `company_admin`, and the Phase 0.4 seven-role templates are
  installed for the tenant. Joining an existing company requires a later invite
  flow and is not inferred from an email domain or company name.
- **Email delivery:** Clients call Firebase `sendEmailVerification` after backend
  provisioning and sign-in. Firebase built-in delivery is used now; the Admin SDK
  link wrapper remains available for the later notifications system. Optional
  `AUTH_ACTION_URL` behavior from D-007 is unchanged.
- **Unverified identity:** `/api/v1/auth/me` returns HTTP 200 and an explicit
  `email_verified` flag so clients can restore identity, resend, and refresh. A
  separate server dependency, `require_verified_email`, returns the unified
  `403 email_unverified` envelope on application permission/role gates. Client
  routing is advisory and cannot replace this check.
- **Consequences:** Unverified users retain resolvable tenant/role context but
  cannot perform protected application work. Duplicate organization names coexist
  safely, no company-discovery side channel is introduced, and invite onboarding,
  password reset, and comprehensive session guards remain in their scheduled slices.

### D-013 — Password Reset via Client SDK and No-Account-Enumeration Policy

- **Decision owner:** Product owner
- **Reset delivery:** Both clients call Firebase `sendPasswordResetEmail` directly,
  mirroring the D-012 verification client-send pattern. Firebase's built-in delivery
  and hosted action page perform the email and the actual password change; no custom
  in-app reset-code handler exists in this slice, and backend transactional email
  remains reserved for the notifications system. The optional `AUTH_ACTION_URL`
  continue URL from D-007 (exposed to Next.js as `NEXT_PUBLIC_AUTH_ACTION_URL`)
  is honored when set; unset keeps Firebase's default hosted flow.
- **Account privacy:** The forgot-password flow always renders the same neutral
  confirmation — "If an account exists for that email, a reset link has been sent."
  `user-not-found` and `user-disabled` are deliberately indistinguishable from
  success; only genuine `too-many-requests` and `network-request-failed` errors
  surface. This extends the D-011 non-enumerating login-message policy to recovery.
- **Abuse posture:** A 60-second client resend cooldown complements Firebase's
  server-side rate limiting; rate-limit errors are reported honestly without
  revealing account state.
- **Consequences:** Password recovery works end-to-end with zero new backend
  surface, and the UI cannot be used to probe registered emails. A custom-branded
  reset page and notification-service delivery remain scheduled later; session,
  token refresh, and route-guard hardening remain Phase 1.4.

### D-014 — Session Lifecycle and Client-Layout Route Guards

- **Decision owner:** Product owner
- **Guard placement:** Route protection is a client-layout concern composed from
  guard components/widgets over the single D-011 auth provider. Next.js
  middleware was explicitly rejected: the Firebase session lives only in the
  browser SDK, so no cookie or header exists for server middleware to inspect,
  and introducing a session-cookie layer is out of scope for this slice. Client
  guards are UX only; FastAPI's `require_permission` and
  `require_verified_email` remain the enforcement authority (D-008, D-012).
- **Redirect contract:** Unauthenticated visits to protected routes redirect to
  login and remember the intended destination — admin as an internal-path-only
  `?next=` parameter (never an absolute or protocol-relative URL, preventing
  open redirects), mobile as a controller-held `pendingRoute` consumed once.
  Authenticated users are redirected away from login/signup/forgot; unverified
  identities are held at the verify screen; missing permissions render a branded
  403 page in place via the 0.6 `can()` helpers seeded from `/me`. Mobile guard
  redirects replace the whole navigation stack so back-navigation cannot reveal
  protected content.
- **Token lifecycle:** Token-refresh events (`onIdTokenChanged` /
  `idTokenChanges`) drive the provider. The typed API layer retries a real 401
  exactly once after a forced token refresh; a second 401 expires the session —
  Firebase sign-out, cleared context, one session-expired toast (idempotent
  until the next sign-in attempt), and a guard-driven login redirect. A public
  `refreshSession()` re-resolves `/me` after a forced refresh; role changes take
  effect on the next refresh, not mid-token.
- **Consequences:** Long-lived sessions no longer 401 mid-use, restore never
  flashes the wrong surface, deep links survive the login round-trip, and every
  client gate has an authoritative server twin. A server-session/cookie layer,
  SSR-aware guards, and richer 403 telemetry remain future concerns.

### D-015 — Shell Navigation Config and Unbuilt-Module Policy

- **Decision owner:** Product owner
- **Nav config strategy:** Each client owns one declarative navigation config —
  `apps/admin/src/navigation/nav-config.tsx` and
  `apps/mobile/lib/navigation/nav_config.dart` — as its single source of truth.
  Every item declares `label`, `icon`, `route`, and an optional
  `requiredPermission` drawn from the locked Phase 0.4 catalog, and is filtered
  through the Phase 0.6 `can()` helpers over the authoritative `/me`
  permissions. The two files mirror one another item-for-item and both carry a
  header comment naming the counterpart; table-driven tests in both apps pin
  the same role → visible-items expectations, so drift fails tests on either
  side. Dashboard and Documents carry no permission (no `documents.*` key
  exists in the 0.4 catalog and inventing one is out of scope);
  Admin & Settings gates on `company.settings`. Grouping (Overview /
  Operations / Safety & Insights / Administration) and the mobile primary set
  (Home / Assets / Work / More) are presentational defaults, adjustable in the
  config without touching shell code.
- **"Coming soon" convention:** Roadmap modules whose screens are not built
  yet stay visible in the nav (the roadmap is not hidden) and route to a
  branded in-shell placeholder that states the module is planned and fakes no
  functionality. Placeholder routes flip to real screens by changing only the
  route's page content — the nav entry is already final.
- **Disabled-placeholder policy:** Cross-cutting platform affordances that
  belong to later phases render in their final header position but visibly
  disabled with the owning phase named — global search (Phase 16) and
  notifications (Phase 15). No fake results, no dead dropdowns.
- **Consequences:** Every future screen mounts inside the shell and inherits
  role-aware navigation for free; per-role UX is testable without new wiring;
  unbuilt scope is honest in both clients. `/me` gained `company_name` so the
  user menu shows the tenant without a new endpoint. Custom roles that hold
  `users.manage`/`roles.manage` but not `company.settings` do not see
  Admin & Settings until a finer split is scheduled.

### D-016 — Design Language Direction (Phase 2.1b)

- **Decision owner:** Product owner (direction locked in the phase brief)
- **Decision:** The product reads as a deliberately designed enterprise
  industrial monitoring tool. Typography is a three-role system — Space
  Grotesk for headings, IBM Plex Sans for body/UI, and IBM Plex Mono for
  every machine value (asset IDs, work-order numbers, timestamps,
  coordinates, readings, emails, role and permission keys) — self-hosted as
  Latin-subset files in both clients; no CDN fonts. Depth comes from layered
  dark surfaces (#0A0E1A → #111827 → #1A2234) with luminous 1px borders;
  decorative drop shadows and gradients are banned, and glow shadows exist
  only for status emphasis. Blue is structural; the orange accent is rare and
  meaningful (primary action / critical); status colors carry information,
  never decoration. Density is enterprise-grade: a 13px body baseline on a
  tightened type scale with real hierarchy, compact controls, and asymmetric
  primary-region/secondary-rail layouts rather than uniform card grids.
  Motion runs 120–240ms on cubic-bezier(0.16, 1, 0.3, 1), purposeful only
  (entrance, state change, feedback), with reduced-motion respected.
- **Mechanics:** All values live in `packages/design-tokens/tokens.json` and
  flow through the generator into Tailwind/CSS and Flutter `ThemeData`; raw
  values in components remain prohibited. The recurring monospace
  "instrumentation label" idiom (micro uppercase mono eyebrows on group
  headers, status pills, and section rules) is the signature element; the
  0.7 component APIs were restyled, not rewritten.
- **Verification:** Both clients' full suites pass unchanged; 14 foreground/
  background pairs checked for WCAG AA in dark and light; two screenshot-led
  refinement rounds recorded under `docs/evidence/phase-2.1b/`.
- **Consequences:** Every future screen inherits this language automatically
  by composing the shell and primitives. Deviations require editing
  tokens.json (a reviewable, cross-client change), not local overrides.

### D-017 — Brand Palette and Logo Assets (Phase 2.1c)

- **Decision owner:** Product owner (logo supplied as the source of truth)
- **Sampled brand values (authoritative, from the logo file):** brand orange
  `#FB4402` (OKLCH L 0.653, C 0.226, H 35.3°) and brand navy `#002865`
  (OKLCH L 0.296, C 0.116, H 259.3°). The brief's approximations (#F4470E /
  #1A2A6C) were measurably off and are not used anywhere.
- **Decision:** Primary and accent are perceptually even OKLCH 50–900 scales
  at the sampled hues, with the sampled values pinned at their natural
  positions (navy = primary-800, orange = accent-500). Light theme uses deep
  navy (700–900) for text/structure/actions, matching the logo; dark theme
  uses lightened tints of the same hue (400–500) for interactive elements,
  while surfaces re-tint the 2.1b lightness ladder toward the navy hue.
  Orange stays rare (single primary CTA / critical emphasis) with a
  token-defined navy ink (`accent.ink`, 4.77:1) for its labels. Critical
  moved to crimson `#C1123F` so a safety alert can never be confused with a
  CTA. Because no single status hex passes AA on both white and near-black,
  `statusStrong` (light-theme text) and `statusSoft` (dark-theme text) token
  sets exist alongside the status fills.
- **Logo assets:** The owner supplied one raster master (full lockup, white
  background). Variants were derived mechanically — white un-matte with an
  alpha floor, band-cropping into mark/wordmark/full, and the permitted
  navy→light recolor for dark themes (orange unchanged) — never redrawn.
  Favicon, apple-touch-icon, PWA icons, and the og-image are generated from
  those masters. Both clients consume assets only through theme-aware Logo
  components (`Logo` / `BrandLogo`); call sites never reference file paths.
  Vector originals can replace the derived PNGs file-for-file later.

### D-018 — SEO, Theming Enforcement, and Motion/Performance Policy (Phase 2.1c)

- **Decision owner:** Product owner
- **Indexing policy:** This is a private enterprise app. Public routes
  (login, signup, forgot-password) carry full SEO — canonical, OpenGraph,
  Twitter cards, JSON-LD, `index, follow`. Every route inside the shell is
  `noindex, nofollow` but keeps a unique descriptive title for tabs,
  history, and bookmarks. robots.txt disallows the app, sitemap.xml lists
  only public routes, and the PWA manifest and theme-color come from tokens.
  Metadata is declarative and colocated with each route through the
  `publicPage`/`protectedPage` helpers in `src/seo/site.ts` — future screens
  set their own title without touching a central file. `<html lang="en">`.
- **Theming enforcement:** Nothing outside `packages/design-tokens` may
  declare a raw hex color or font family. Admin enforces this with an ESLint
  `no-restricted-syntax` rule (a planted violation fails lint — proven);
  Flutter with a source-scanning guard test. Allowed exceptions, documented:
  the generated token bindings and the static Flutter web shell
  (`web/index.html`, `web/manifest.json`), which cannot import Dart tokens.
  Tokens flow to CSS custom properties per theme, so a runtime theme change
  needs no rebuild; a token-propagation proof (brand token → both clients)
  is part of the phase evidence.
- **Motion & performance policy (every future screen):** Framer Motion is
  the only admin animation library; GSAP may only ever arrive dynamically
  imported on a route that proves it needs timeline/scroll sequencing —
  never in the global bundle. Flutter uses its native system. Animate
  transform and opacity only; durations come from motion tokens (≤240ms,
  hard ceiling ~300ms); `will-change` sparingly; virtualize long lists and
  never animate hundreds of rows; no infinite/decorative loops; no animation
  on scroll-heavy data tables; `prefers-reduced-motion` always respected.
  The shared admin bundle is budgeted in CI at 430 KB (baseline 342 KB,
  ~25% headroom); raising the budget requires a documented decision.
  Lighthouse login baselines (locally throttled): Performance 56,
  Accessibility 100, Best Practices 100, SEO 100.

### D-019 — Dashboard Read-Cost and No-Invented-Data Policy (Phase 2.2)

- **Decision owner:** Product owner
- **No-invented-data rule:** As of this phase, real data exists only for
  `companies`, `users`, `roles`, `permissions`, `role_permissions`, and
  `audit_logs` — assets, work orders, permits, and incidents don't exist
  yet (Phases 4/10/11). The dashboard may only ever render real values
  from those collections; anywhere a future module's KPI would go, the UI
  shows the reserved-KPI empty-state tile (see ARCHITECTURE, Phase 2.2)
  instead of a placeholder number or sample chart. This rule binds every
  future addition to the dashboard, not just this phase's scope.
- **Read-cost policy:** `AuditLogRepository.list_since` is the single entry
  point for audit aggregation across summary, activity, and
  activity-series. Every call is one Firestore query scoped to
  `company_id ==` and `created_at >=` the window start, with the window
  capped at 90 days and results hard-capped at 5000 documents in memory as
  a backstop against unbounded tenants. This compound query requires a
  Firestore composite index; it's committed as IaC
  (`infra/firebase/firestore.indexes.json`, referenced from
  `firebase.json`) rather than created ad hoc per environment, exactly the
  gap that surfaced during this phase's real-creds evidence-gathering (the
  local service account also lacks index-admin IAM, so the index needs one
  `firebase deploy --only firestore:indexes` — or the console's
  auto-create link — before real-Firestore runs work end-to-end).
- **Consequences:** Every future module that adds dashboard content must
  reuse `list_since`-style bounded queries rather than unbounded
  collection scans, and must extend the reserved-KPI pattern (permission
  gate + honest empty copy) until it has real data to show.

### D-020 — Reusable Chart Infrastructure (Phase 2.2)

- **Decision owner:** Product owner
- **Decision:** Charts are never hand-rolled per screen. Admin's
  `src/design-system/chart.tsx` (Recharts) and mobile's
  `lib/design_system/chart.dart` (fl_chart) are the only sanctioned way to
  render a chart in either client, matching the 2.1c theming-enforcement
  policy: colors resolve live from design tokens (CSS custom properties on
  admin, `DsColors` on mobile), never a literal hex at the call site.
  Both wrappers share one contract across loading/error/empty/ready states
  and cap entry animation at the 2.1c motion-token durations, skipped
  entirely under `prefers-reduced-motion` — an entry animation is exactly
  the kind of decorative motion the phase 2.1c ADR asks charts to avoid.
  Admin additionally ships bar and donut variants against the same
  contract for modules that need them.
- **Consequences:** A brand or motion-token change repaints every chart
  automatically; a future module adds a chart by supplying data to an
  existing wrapper, not by importing a charting library directly.

### D-021 — Invite Delivery Mechanism (Phase 3.1)

- **Decision owner:** Product owner
- **Decision:** Inviting a user never routes a password through the
  backend. `POST /api/v1/users/invite` calls the existing
  `UserProvisioningService.provision_user` with `password=None`, so
  Firebase Auth assigns a random password the invitee never sees and
  never needs to. The admin client then calls the Firebase client SDK's
  `sendPasswordResetEmail(invitedEmail)` — the exact same call the 1.3
  forgot-password screen already makes — which sends Firebase's own
  "set your password" email. The invited user clicks the link, sets a
  password through Firebase's hosted flow, and can sign in immediately
  with whatever role was assigned. No transactional-email service,
  template, or queue was built for this phase; that infrastructure is
  reserved for the dedicated Notifications phase.
- **Consequences:** Every future "add a person to the system" flow
  (invite, re-invite, bulk import) should reuse this exact
  provision-with-no-password-then-send-reset-email sequence rather than
  inventing a new delivery path; a real transactional-email system, when
  built, should absorb this call site rather than bypass it.

### D-022 — Last-Admin and Self-Action Protection (Phase 3.1)

- **Decision owner:** Product owner
- **Decision:** `UserManagementService` enforces four safety rules
  server-side, never only in the UI: (1) a user can never deactivate or
  demote themselves out of an admin role (`company_admin`/`super_admin`);
  (2) the last active `company_admin` in a tenant can't be deactivated or
  demoted by anyone, including a `super_admin` acting on their behalf —
  the check counts active `company_admin` holders before allowing either
  action; (3) `role.key == "super_admin"` is rejected on both invite and
  role-change even though every tenant's seven seeded system roles
  (0.4/0.6) include a `super_admin` role document — tenant scoping alone
  would otherwise let a Company Admin grant it; (4) re-inviting an email
  that already backs a Firebase Auth account (in this tenant or any
  other, since Firebase Auth email uniqueness is global) returns a clean
  409 rather than a duplicate or a confusing 500.
- **Consequences:** Any future endpoint that can change a user's role or
  status must reuse these same checks (via `UserManagementService`, not
  reimplement them) — a tenant can never be left with zero active admins,
  and no UI path can hand out platform-level access.

### D-023 — Mobile Read-Only User Management Scope (Phase 3.1)

- **Decision owner:** Product owner
- **Decision:** The Flutter app ships `users_screen.dart` as list +
  detail only — no invite form, no edit, no status toggle. This mirrors
  the read-only-by-design precedent already set for other admin-heavy
  surfaces and reflects that inviting/editing teammates is an
  occasional desk task, not a field task. The same `users.manage`
  permission gates the route and bottom-nav destination on both
  clients, so a role that can't manage users on web can't see the
  screen on mobile either — this is a client capability choice, not a
  server permission difference.
- **Consequences:** If a future need for mobile invite/edit emerges
  (e.g. a site supervisor onboarding a new hire on-site), it should be
  scoped as its own explicit phase rather than silently added; today,
  Phase 3.1 is done when mobile shows the same real people and roles
  admin web does, without the mutation surface.

### D-024 — System-Role Immutability and Visibility (Phase 3.2)

- **Decision owner:** Product owner
- **Decision:** `is_system=true` roles (the seven 0.4/0.6 templates) are
  permanently read-only through every 3.2 endpoint — they cannot be
  renamed, have their permission set changed, or be deleted; attempting
  any of the three returns 409 `system_role_locked`. This resolves the
  conflict between "let admins edit roles" and the fact that
  `seed_system_roles`/`run_seed` actively reconcile every system role's
  name/description/permission mapping back to `SYSTEM_ROLE_TEMPLATES` on
  every run — a manual edit to a system role would simply be reverted the
  next time seeding runs. Only custom (`is_system=false`) roles, created
  through `POST /api/v1/roles`, are ever mutable. Separately, the
  `super_admin` role stays invisible to every company-scoped 3.2 route
  (list, detail, create/clone-source, update, delete) exactly as it
  already was for 3.1's role picker, since granting or managing
  platform-level access is out of scope until 3.5's Super-Admin
  cross-tenant work.
- **Consequences:** No future phase should introduce a path for editing
  a system role's permissions in place; a company that needs a variant
  of a system role's permission set should clone it into a new custom
  role instead (`POST /api/v1/roles` with `clone_from_role_id`). Seeding
  logic and 3.2's mutation logic never need to coordinate, because their
  targets (system vs. custom roles) never overlap.

### D-025 — `platform.admin` Grant Restriction and Claims-Sync Timing (Phase 3.2)

- **Decision owner:** Product owner
- **Decision:** Neither `POST /api/v1/roles` nor
  `PATCH /api/v1/roles/{id}` will ever let a Company Admin's permission
  payload include `platform.admin` — it is rejected outright with 403
  `platform_admin_not_grantable` rather than silently dropped, and the
  admin UI's permission matrix omits the entire `platform` catalog group
  so there is nothing to select in the first place. Separately: when a
  role's permission set changes, `RoleManagementService` still calls the
  0.5/3.1 `ClaimsService.sync_claims_from_role` for every user currently
  holding that role (batched, best-effort — a failed sync for one user is
  logged, not fatal to the request), even though `role_id`/`role_key`
  claims don't change on a permission-only edit. This is deliberate: 0.5's
  `get_current_user` resolves a user's effective permissions live from
  Firestore via `PermissionResolver` on every request (both for route
  gating and for `/me`), so a permission edit is authoritative and
  immediate at the API layer regardless of claims sync. The sync exists
  to keep custom claims internally consistent with the 3.1 pattern; what
  actually lags is the client's *cached* permission set from its one
  `/me` call at session start (admin's `PermissionProvider`, mobile's
  `PermissionController`), which only refreshes on that user's next
  login or session refresh — consistent with the 1.4 ADR's "next token
  refresh" framing, even though the underlying mechanism (live
  server-side resolution vs. client cache staleness) is more nuanced than
  that phrase alone suggests.
- **Consequences:** Any future endpoint that can assign permissions to a
  role must reuse this same `platform.admin` rejection rather than
  reimplementing it; any future client screen that displays "your
  permissions" should treat it as a session-start snapshot, not a live
  subscription, and prompt a refresh/relogin if staleness matters for
  that screen.

### D-026 — Mobile Read-Only Role Management Scope (Phase 3.2)

- **Decision owner:** Product owner
- **Decision:** The Flutter app ships `roles_screen.dart` as list +
  detail only (role name, system/custom badge, permission count,
  assigned-user count, and the full permission-key set on detail) — no
  create, edit, or delete UI. This mirrors D-023's mobile-read-only
  precedent for the same reason: managing the permission model is an
  occasional desk task. The `roles.manage` permission gates the route
  and bottom-nav destination identically on both clients.
- **Consequences:** Same as D-023 — a future mobile-authoring need for
  roles should be scoped as its own explicit phase, not silently added.

### D-027 — Firebase Storage Security Model and Path Convention (Phase 3.3)

- **Decision owner:** Product owner
- **Decision:** Company logo upload (the first feature to touch Firebase
  Storage) is entirely server-mediated, mirroring D-002's "Firestore is
  server-side only via the Admin SDK" precedent. `infra/firebase/storage.rules`
  denies all client read/write unconditionally — no client anywhere in
  this codebase ever calls the Storage SDK directly. Uploads go through
  `POST /api/v1/company/logo`; reads never expose a public object or a
  persisted URL — `GET /api/v1/company` generates a fresh 1-hour V4
  signed URL on every response instead. Every object lives under a
  fixed, company-scoped path (`companies/{company_id}/{feature}/...`;
  3.3's logo is always `companies/{company_id}/branding/logo`, one path
  per company, overwritten in place on replace).
- **Consequences:** Assets/inspections/any future feature that stores
  files in Storage must reuse this exact convention (fixed company-scoped
  path, server-mediated upload, signed-URL read) rather than adding
  public buckets, client-side Storage SDK usage, or a divergent path
  scheme. `FIREBASE_STORAGE_BUCKET` must be set explicitly per
  environment if the project's bucket doesn't match the
  `<project-id>.appspot.com` fallback guess (confirmed wrong for
  `thinking-case-469504-c0`, which uses the newer
  `<project-id>.firebasestorage.app` domain).

### D-028 — Company Settings Scope Policy (Phase 3.3)

- **Decision owner:** Product owner
- **Decision:** 3.3 ships exactly the company settings that have a real,
  working consumer today: name, industry, contact email/phone, a logo,
  and timezone/locale (which now actually drive the date formatting
  already shown on the dashboard and this settings page — not stored
  inertly). `subscription_tier` is displayed read-only; enforcing tier
  limits is explicitly deferred to a later phase rather than faked with
  client-side gating. No settings were invented for modules that don't
  exist yet (no "AI inspection thresholds", no "IoT config").
- **Consequences:** A future phase that needs a new tenant-wide setting
  must show it has a real consumer (a place that setting actually
  changes behavior) before adding it here — settings-as-a-junk-drawer is
  explicitly rejected.

### D-029 — Audit Viewer Role Mapping, Query Shape, and Export Policy (Phase 3.4)

- **Decision owner:** Product owner
- **Decision:** `audit.read` is added to the Phase 0.4 permission catalog.
  `company_admin`/`super_admin` receive it automatically (both derive from
  `ALL_PERMISSION_KEYS`); `hse_manager` and `executive` are granted it
  explicitly as compliance-facing roles; `operations_manager`,
  `field_inspector`, and `maintenance_technician` are not granted it.
  Already-registered tenants outside the two demo companies need one
  explicit `reconcile_roles.py --company-id <id>` run to pick up the new
  grant (re-running `seed_system_roles` for that tenant) — there is no
  automatic backfill across all real tenants. The viewer's date range is
  the real, caller-controlled Firestore query bound — reusing the single
  existing `company_id + created_at` composite index from D-019 as both
  floor and ceiling — so **no new Firestore index was needed for this
  phase**. Actor/action/target-type filters and free-text search
  (Firestore has no native full-text search) run in-memory over that
  date-bounded read, capped at `AUDIT_QUERY_CAP = 25,000` events; a
  `truncated` flag on the response tells the UI when the cap was hit
  rather than silently dropping data. CSV export reuses the exact same
  bounded/filtered query and streams the result directly as the HTTP
  response body — no Firebase Storage round trip — rejecting (413) rather
  than truncating a filtered set that exceeds the same cap. Reading the
  audit log is itself never written to the audit log, to avoid
  self-referential noise.
- **Consequences:** A tenant with audit volume that regularly exceeds the
  cap within its selected range will see `truncated`/413 responses
  prompting a narrower range, rather than a "complete" but silently
  partial view — this is an explicit, documented trade-off, not a bug.
  Any future phase adding audit filters must keep reusing the
  date-range-as-index-bound + in-memory-filter shape rather than adding
  per-filter composite indexes, per D-019's precedent. Real, already-
  registered tenants require the operator to run `reconcile_roles.py`
  once to backfill `audit.read` onto existing `hse_manager`/`executive`
  role assignments.

### D-030 — Super-Admin Cross-Tenant Trust Model (Phase 3.5, resolves D-006)

- **Decision owner:** Product owner
- **Decision:** D-006 deferred all cross-tenant repository access until "a
  verified post-auth trusted context exists." That context is a Firebase ID
  token whose `get_current_user`-resolved permission set includes
  `platform.admin` — held only by `super_admin` per the 0.4 matrix, and
  already walled off from every company-scoped grant path since 3.2/3.1
  (`roles/service.py`'s `platform_admin_not_grantable`,
  `users/service.py`'s rejection of the `super_admin` role key). 3.5 builds
  the one legitimate cross-tenant path on top of that seam:
  - **`AdminScope`** (`app/models/base.py`) is a new model carrying only
    `acting_uid`/`acting_company_id`. It is constructed by exactly one
    function, `app/admin/dependencies.py::get_admin_scope`, which itself
    depends on `require_permission("platform.admin")` — so an `AdminScope`
    cannot exist without an already-verified platform-admin token, and is
    never built from a client-supplied field. Every `/api/v1/platform/*`
    route depends on `AdminScope`, never a raw `CurrentUser`.
  - **Existing company-scoped routes are provably untouched.** A new test,
    `test_super_admin_home_company_route_stays_tenant_scoped`, proves a
    super-admin's elevated permission does not widen `GET /api/v1/company`
    or `GET /api/v1/users` — both still resolve `CompanyScope` from
    `current_user.company_id` exactly as before, so the only cross-tenant
    read/write path in the codebase is `/api/v1/platform/*`.
  - **Dual audit write.** Every cross-tenant mutation writes two entries:
    one into the target tenant's own `audit_logs` (`action="company.<verb>"`,
    `metadata.cross_tenant=true`, `metadata.acting_company_id=<admin's home
    tenant>`) so that tenant's own compliance trail shows the external
    action, and one into a reserved pseudo-tenant scope,
    `CompanyScope(company_id="__platform__")`
    (`action="platform.company.<verb>"`), reusing `AuditLogRepository`'s
    existing methods with zero new code — `AuditLogRepository.append` never
    dereferences `companies`, so a `company_id` with no matching document is
    safe. No platform-audit *viewer* route was built in this phase; the
    scope is queryable later with the same existing methods if needed.
  - **Suspension is enforced in `get_current_user` itself**, immediately
    after the home-company load and before permission resolution — stricter
    than D-012's unverified-email case (which resolves identity with HTTP
    200): a suspended tenant's `/me` (and therefore every protected route)
    returns 403 `company_suspended` right away.
  - **`subscription_tier` is now a locked 4-value enum** (`demo`, `starter`,
    `professional`, `enterprise`) enforced at the new
    `UpdatePlatformCompanyRequest`/`UpdateCompanyStatusRequest` boundary; the
    `Company`/`CompanyUpdate` entities stay bare `str` (no migration). The
    platform-level `PATCH /api/v1/platform/companies/{id}` edits
    `subscription_tier` only — name/industry/contact/logo remain exclusively
    owned by the tenant's own `company_admin` via the existing
    `/api/v1/company` route, so no field ever has two competing write paths.
  - **Scope is deliberately narrow — platform administration only.** The
    five endpoints (list/detail/status/tier/stats) never expose tenant
    business data (inspections, assets, permits) — no god-mode data browser
    was built, per the brief's explicit instruction.
  - **Mobile is out of scope**, extending the D-023/D-026 mobile-read-only
    precedent to a whole module rather than a subset of actions: platform
    administration is a desk task, not a field task.
- **Consequences:** Any future phase that needs a new cross-tenant read/write
  must extend `AdminScope`/`app/admin/` rather than adding a second
  `platform.admin`-gated seam; a future platform-audit viewer can reuse the
  `"__platform__"` scope directly. `CompanyRepository.list_all()` (new,
  unscoped, modeled on `PermissionRepository.list()`) is now the only
  unscoped read of the `companies` collection and should be reused, not
  reimplemented, by any future platform-wide company query.

### D-031 — Asset Hierarchy Depth and Self-Nesting (Phase 4.1)

- **Decision owner:** Product owner (locked in the Phase 4.1 brief)
- **Decision:** The hierarchy is exactly three levels —
  `Facility → Area → Asset` — plus an optional `parent_asset_id`
  self-reference on `Asset` for component/sub-asset nesting (e.g. a motor
  inside a pump). Most assets have a null parent; there is no separate
  rigid "component" collection.
- **Consequences:** Any future need for deeper nesting (e.g. a component
  with its own sub-components) is already covered by the existing
  self-reference and needs no schema change; a genuinely new hierarchy
  level (e.g. above Facility) would need its own ADR.

### D-032 — Asset Category Extensibility (Phase 4.1)

- **Decision owner:** Product owner (locked in the Phase 4.1 brief)
- **Decision:** `Asset.category` is a plain `str` validated in the service
  layer against `app/assets/constants.py::ASSET_CATEGORIES` (the ten spec
  categories plus `Other`), not a Pydantic `Literal`/schema enum — mirroring
  3.3's `INDUSTRY_CHOICES`/`is_valid_industry` pattern exactly.
  `category == "Other"` requires a non-empty `category_other` free-text
  subtype.
- **Consequences:** Adding a category later is a one-line constant change
  reviewed like any code change, never a Firestore migration or a breaking
  contract change.

### D-033 — Asset History-by-Reference and Soft-Delete Cascade (Phase 4.1)

- **Decision owner:** Product owner (locked in the Phase 4.1 brief)
- **Decision:** `Asset` embeds no inspection/maintenance history arrays.
  `GET /api/v1/assets/{id}/history` returns a real, always-empty,
  correctly-shaped `AssetHistoryPage` today; future inspection/work-order
  modules fill it by querying their own collections `WHERE asset_id == ...`,
  never by writing into this response. Separately, facilities/areas/assets
  get this codebase's first soft delete: `TenantRepository._soft_delete()`
  stamps `deleted_at` and writes a `.deleted` audit action instead of
  physically removing the document; every service treats
  `deleted_at is not None` as "not found." Deleting a facility/area with
  any non-deleted child row returns `409` (`facility_has_children`/
  `area_has_children`), mirroring the existing `409 role_has_assigned_users`
  (D-024) precedent — the simpler of the two cascade choices the brief
  allowed. An asset's own soft-delete is never blocked by child sub-assets,
  since the parent row still resolves by id afterward.
- **Consequences:** Any future module that needs an asset's history must
  query by `asset_id` against its own collection rather than expecting
  embedded arrays; any future collection that needs soft delete should
  reuse `_soft_delete()` rather than reimplementing the pattern.

### D-034 — Mobile Asset Detail Presentation (Phase 4.2)

- **Decision owner:** Established by implementation, following the existing
  "extract/depart from convention on genuine need" precedent (e.g. `Checkbox`
  in 3.2, `FilterChip` in 3.4) rather than a product-owner brief item.
- **Decision:** Asset detail on mobile is reached via
  `Navigator.of(context).pushNamed(AppRoutes.assetDetail, arguments: assetId)`
  — a real pushed route — instead of the `showAppModal` bottom sheet every
  prior mobile detail view (Users, Audit, Roles) uses. The asset id is read
  back via `ModalRoute.of(context)!.settings.arguments`, since
  `AppRoutes.onGenerateRoute` switches on exact route names and this app has
  no dynamic-segment routing.
- **Consequences:** Any future mobile detail view with more than a
  handful of fields (i.e. anything that would need tabs or scroll past a
  sheet's comfortable height) should default to a pushed route, not force
  another sheet. Existing sheet-based details (Users/Audit/Roles) are
  unaffected and remain sheets — this is a per-feature choice, not a
  retroactive pattern change.

### D-035 — Asset GPS Location Display Depth (Phase 4.2)

- **Decision owner:** Product owner (confirmed via direct question this
  session, since the phase brief explicitly flagged map-integration depth as
  an item to check rather than assume).
- **Decision:** Both clients render an asset's GPS coordinates as a plain
  `lat, lng` readout with an external link to
  `https://www.google.com/maps?q={lat},{lng}` — no embedded interactive map,
  no Google Maps Platform API key, no new `@react-google-maps/api`/
  `google_maps_flutter` dependency. Chosen because no Maps Platform
  key/package existed anywhere in the repo before this phase, and
  provisioning one (a Google Cloud project, billing, key restrictions) is a
  real infrastructure task outside a UI-only phase's scope.
- **Consequences:** A future phase that wants an embedded interactive map
  (e.g. the static 3D facility view, or a richer asset-location UI) starts
  from zero Maps Platform setup and should treat key provisioning as its own
  prerequisite step, not assume it already exists.

### D-038 — Pluggable Dashboard KPI Widget Framework (Phase 4.4, resolves 2.3)

- **Decision owner:** Established by implementation per the 2.2/2.3 ADRs'
  own instruction — 2.3 was deliberately deferred until a real module KPI
  existed to drive the right shape (assets, built in 4.1–4.3), rather than
  building an abstraction speculatively.
- **Decision:** A dashboard widget is a plain data structure —
  `{ id, title, requiredPermission, minTier?, render/builder }` — registered
  once via `registerWidget` (admin) / `registerDashboardWidget` (mobile).
  `DashboardWidgetGrid` reads the registry, filters by the viewer's
  permissions (0.6) and subscription tier (`minTier`, a real hook today even
  though nothing sets it yet — enforcement lands with billing), and renders
  each widget inside its own failure boundary (a React error boundary on
  admin, a build-time try/catch on mobile) so one widget's crash never
  blanks the rest of the dashboard. This is the exact tile shape and gating
  rule 2.2's `ReservedKpiRegion` established, now expressed as data-driven
  registrations instead of a hardcoded array.
- **Consequences:** Every future module (Work Orders/7, Permits, Safety/
  Inspections) plugs a widget into this same registry — no dashboard-page or
  grid code changes are needed, only a new file registering the module's
  widget and deleting its entry from `reserved-widgets.tsx`/
  `reserved_widgets.dart`. Phase 2.3 is retroactively resolved by this
  implementation rather than needing its own separate phase.

### D-039 — Asset KPI Aggregation via Firestore `count()` (Phase 4.4)

- **Decision owner:** Established by implementation — the phase brief
  explicitly flagged Firestore cost discipline as a decision point to make
  and document, not assume.
- **Decision:** `AssetRepository.count()` issues a Firestore `count()`
  aggregation query (billed per ~1000 matched docs, minimum 1 — never
  downloads a document) filtered by `company_id == ` + `deleted_at == None`
  plus at most one more equality filter (`current_status`/`category`/
  `facility_id`). `AssetManagementService.get_dashboard_summary()` fires the
  4 status/total counts, one count per `ASSET_CATEGORIES` entry, and one
  count per tenant facility, all concurrently via `asyncio.gather`. Every
  filter used is a plain equality filter, so this needs zero new composite
  indexes (Firestore only requires one when a range/inequality filter
  combines with another filter or an `order_by`) —
  `infra/firebase/firestore.indexes.json` is untouched by this phase.
- **Rejected alternatives:** Maintained counters (transactional updates on
  every asset create/update-status-change/soft-delete, plus a backfill for
  already-seeded tenants) were rejected as too invasive for a need this
  cheaply servable another way. The existing D-019 bounded-read-then-count
  pattern (used for `users_total`/`roles_total`/`audit_events`) was
  rejected here specifically because it would download every asset
  document — including embedded `photos`/`documents`/`manuals` arrays —
  just to produce a handful of integers, exactly the "full scan" the phase
  brief asked to avoid.
- **Consequences:** Any future KPI needing a count over a bounded, known
  set of equality-filterable values (status/category/facility-shaped) should
  reuse this `count()` pattern rather than a full list-and-count. A KPI
  needing an arbitrary/unbounded group-by (not a small fixed catalog) would
  need a different approach — this phase does not attempt to generalize
  that case.

### D-040 — Phase Evidence Policy: No Screenshot Capture

- **Decision owner:** Product owner (explicit instruction, Phase 4.4
  session, applies retroactively as guidance and prospectively to every
  future phase).
- **Decision:** Phase completion evidence is limited to automated test
  suites (unit/integration/widget), lint/type-check output, and
  contract-drift proof, plus real-credentials backend verification when
  credentials are available in the working session. Browser/simulator
  screenshot capture is removed from the evidence contract entirely — not
  attempted, not recorded as deferred, not treated as an open follow-up.
  Visual/UX correctness is the product owner's responsibility, verified
  manually.
- **Consequences:** Every phase prompt's "When done" section drops any
  screenshot line going forward. `TESTING.md` evidence rows for 4.4 onward
  cite only test/lint/build/contract-drift results and real-backend checks —
  prior phases' rows (4.2/4.3) that recorded deferred screenshot evidence
  due to environment limitations stay as historical record and are not
  retroactively rewritten.

### D-041 — Opaque QR Token Generation

- **Decision owner:** Backend implementation (Phase 4.5), following the
  spec's explicit "opaque, unguessable token — NOT the asset UUID"
  requirement.
- **Decision:** `qr_code_id = secrets.token_urlsafe(16)` (~128 bits of
  entropy), generated by `AssetManagementService.create_asset()` for every
  new asset and, for assets that predate this phase, by the one-time
  `scripts/backfill_qr_codes.py`. Before accepting a candidate, both call
  sites check `AssetRepository.get_by_qr_code()` for a collision and retry
  (up to 5 attempts) rather than trusting the entropy alone.
- **Consequences:** A printed or scanned QR label reveals nothing about
  the asset's own `id` (a UUID-derived string), so a bad actor with a
  photo of one tenant's label can't guess another asset's code. The
  collision check adds one extra Firestore read per asset creation/backfill
  — negligible next to the write itself, and it's the only way to make the
  "unique" requirement provable rather than merely probabilistic.

### D-042 — QR Deep-Link Payload and Cross-Tenant Resolve Policy

- **Decision owner:** Product owner, resolving the phase brief's explicit
  "STOP and ask" ambiguity on the QR payload URL scheme (also covered:
  scanner plugin choice → `mobile_scanner`; print/download format →
  browser-printable HTML view, no PDF dependency).
- **Decision:** The QR image encodes an HTTPS deep-link URL,
  `{APP_BASE_URL}/qr/{code}`, using a new `Settings.app_base_url` (defaults
  to `http://localhost:3000`, the admin app's own dev origin). No
  Universal Links/App Links domain-association infrastructure (a real
  production domain, `apple-app-site-association`, Android
  `assetlinks.json`) exists in this repo yet — deliberately out of scope
  for this phase, since the admin's own `/qr/{code}` page already resolves
  the URL directly and mobile's camera scan decodes the scanned text
  in-app without relying on OS-level link registration. `GET
  /api/v1/qr/{code}/resolve` requires `assets.read` (`require_permission`,
  same as every other asset-read route — enforces the unauthenticated-401
  case for free) and does a cross-tenant lookup
  (`AssetRepository.get_by_qr_code`, which bypasses `CompanyScope` since
  the scanning user's company isn't known from the code alone); the
  service layer then rejects a match belonging to a different
  `company_id`, or a soft-deleted asset, with the exact same `404
  qr_code_not_found` used for a code that doesn't exist at all — never a
  distinguishing 403, so a scan can't be used to probe for a code's
  existence across tenants. Every successful resolve is audited
  (`asset.qr_scanned`).
- **Consequences:** Adopting a real production domain later requires only
  setting `APP_BASE_URL` and standing up the two domain-association files
  — no change to the QR payload already printed on existing labels, no
  re-issuing of codes. The reserved scan-surface counts
  (`inspections_total`/`maintenance_total`/`work_orders_total`) are
  hard-zeroed today, matching the 4.1 `AssetHistoryPage` precedent, until
  Phase 7/11 populate them for real.

### D-043 — Inspection Sync Contract: Client-Generated ID + Monotonic Revision

- **Decision owner:** Product owner, resolving the phase brief's explicit
  "STOP and ask" ambiguity on revision-vs-timestamp for the 7.2 offline
  engine's conflict contract.
- **Decision:** Every inspection's Firestore document id is a
  client-generated UUID (validated server-side via `uuid.UUID(value)`),
  never a server-assigned id — a draft created offline never has to wait
  for round-trip server assignment before it "exists." `POST
  /api/v1/inspections` is therefore an **idempotent upsert keyed by that
  id**: a byte-identical resubmit (same `asset_id`, `inspection_type`,
  `title`, `notes`, GPS, `client_created_at`, `device_id`, `origin`)
  returns the existing record unchanged (no revision bump, no audit
  entry — a true no-op); a resubmit with different data conflicts (`409
  inspection_id_conflict`). The route returns a fixed `200`, never `201`
  — a deliberate departure from every other create route in this
  codebase, since the route can't statically know whether a given call
  created a new record or replayed one. Conflict resolution itself uses a
  monotonic integer `revision` (starts at 1, bumps by exactly 1 on every
  accepted mutation, never on a true no-op) rather than a timestamp —
  chosen because this dev environment has already hit a real cross-device
  clock-skew bug (see `[[fev-dev-machine-clock-drift]]`-style incidents
  in prior phases), and a client's local clock cannot be trusted to order
  events reliably. `PATCH /inspections/{id}` accepts an optional
  `expected_revision`; a mismatch returns `409 revision_conflict` with
  both `expected_revision` and the server's `current_revision` so a
  caller can re-fetch and reapply.
- **Consequences:** 7.2's offline sync engine (not built in this phase)
  is expected to implement last-writer-wins by comparing revisions:
  queue a local edit with the revision it was based on, and on a `409`,
  re-fetch the current record and either reapply the local change on top
  or surface a conflict to the user — the exact reconciliation UX is
  7.2's own decision to make, not locked here. Every future upsert-style
  endpoint that needs the same idempotent-replay property should copy
  this `200`-not-`201` pattern rather than inventing a new one.

### D-044 — Checklist Template Light Versioning and Inspection-Time Snapshot

- **Decision owner:** Product owner, resolving the phase brief's "STOP
  and ask" ambiguity on template versioning depth.
- **Decision:** `checklist_templates` gets no separate version-history
  collection. Instead, a lightweight `version: int` field starts at 1 and
  is bumped by exactly 1 on every accepted template update
  (`ChecklistTemplateRepository.update`, unconditionally — unlike
  inspections' revision, there is no idempotency concern here since
  templates are server-authored, not client-id-upserted). When a
  template is assigned to an inspection
  (`POST /inspections/{id}/checklist-template`), the inspection stores
  the template's id **and a full snapshot of its `items[]` plus the
  template's `version` at that exact moment**
  (`checklist_items_snapshot`/`checklist_template_version`) — the
  inspection never re-reads the live template again. Category matching
  (`"Generic"` or the asset's own category) is enforced at assignment
  time only.
- **Consequences:** Editing a checklist template after inspections have
  already been answered against it never corrupts those past answers —
  the snapshot is immutable once taken. `checklist_template_version` on
  the inspection gives diagnostic provenance ("this was answered against
  v3; the template is now v7") without the storage/complexity cost of a
  real version-history collection. If a future phase needs to browse a
  template's full edit history, that is a new, separate feature — this
  decision explicitly does not provide it.

### D-045 — Inspection Lifecycle, Checklist-Response API Surface, and Real "Start Inspection"

- **Decision owner:** Product owner, resolving three related "STOP and
  ask" points: the lifecycle status enum, whether `checklist_responses[]`
  (a brief-reserved container) can be written via the API before 7.3's
  capture UI exists, and whether completing an inspection with zero
  checklist template assigned should be allowed.
- **Decision:** Lifecycle is `draft → in_progress → completed`, plus a
  fourth state `cancelled` (reachable from `draft` or `in_progress`) not
  in the brief's original three-state list, added so an abandoned or
  wrong-asset draft has somewhere to go besides lingering forever or
  being hard-deleted. `completed` and `cancelled` are terminal — any
  further `PATCH` or checklist-template assignment attempt is `409
  inspection_locked`. `complete` validates every **required** item in
  `checklist_items_snapshot` has a non-empty response in
  `checklist_responses` (422 `checklist_incomplete` with
  `missing_item_ids` otherwise); an inspection that never had a template
  assigned has nothing to validate and completes cleanly — this matches
  the ad-hoc "Start Inspection" flow, which never picks a template.
  Although the brief lists `checklist_responses[]` among the containers
  7.1 must not build **capture** for, the backend API accepts and
  validates it via `PATCH` now (unknown `item_id`, duplicate `item_id`,
  or a value not matching the item's `item_type` all 422 as
  `checklist_response_invalid`; accepted values are stamped server-side
  with `answered_by`/`answered_at`, never client-trusted) — this is the
  only way to make the brief's own required test ("complete blocks when
  required items are unanswered") possible, and "capture" is read here as
  an interactive UI concept, not an API concept: no admin or mobile
  screen lets a human tap through a checklist in 7.1. Mobile's "Start
  Inspection" button (QR scan-result screen) creates a real `draft` via
  `POST /inspections` (a fresh client UUID, `inspection_type: ad_hoc`
  hardcoded with no picker yet, `device_id`/`gps_lat`/`gps_lng` left
  `null` since no device-info/geolocation package exists in the mobile
  app yet) and pushes the real read-only `InspectionDetailScreen` on
  success, replacing the previous `ComingSoonScreen` stub entirely.
  RBAC: new `checklist_templates.read`/`.write` join the already-existing
  (previously unused) `inspections.read`/`.write` placeholders from 0.4;
  `operations_manager` gains both new keys (template management is an
  ops responsibility per the client spec), read-only roles gain `.read`
  only. Existing `inspections.*` grants are **not** changed — the client
  spec's "Ops Manager assigns" language is real, but no assignment
  feature exists until 7.11's admin review UI is built to need it.
- **Consequences:** `inspector_id` is always the creating actor's own uid
  in 7.1 — there is no dispatch/assignment capability, consistent with
  the RBAC choice above. A future phase (7.11) that adds real assignment
  will need to decide then whether `operations_manager` needs
  `inspections.write` at that point, and whether `inspector_id` becomes
  mutable. Mobile's `inspection_type: ad_hoc` hardcoding and null
  device/GPS metadata are explicit, documented gaps — not oversights —
  to be revisited once a type picker and a device-info/geolocation
  package are actually needed.

### D-046 — Offline Local Database: Drift, Not Isar

- **Decision owner:** Product owner, resolving the 7.2 phase brief's
  explicit "STOP and ask" ambiguity on local DB choice.
- **Decision:** The mobile offline cache (`LocalInspections`, `Outbox`
  tables) is built on **Drift** (SQLite via `sqlite3`/`sqlite3_flutter_libs`
  FFI), not Isar. The deciding factor was this repo's existing mobile CI
  job (`.github/workflows/ci.yml`): a plain `ubuntu-latest` runner doing
  `pub get` → `analyze` → `test`, with no native-binary-download step.
  Drift's FFI backend resolves against the OS's own SQLite (or the bundled
  `sqlite3_flutter_libs` binary) with zero new CI infrastructure; Isar
  would have needed a new step to fetch its native binary before tests can
  run. Drift needs `build_runner` codegen (`dart run build_runner build
  --delete-conflicting-outputs`), so the mobile CI job gained that as a new
  step before `flutter analyze`. Generated `*.g.dart` files are
  **gitignored, not committed** — unlike `packages/contracts`' generated
  API client, which is a cross-consumer contract artifact with its own CI
  drift check; Drift's generated code is internal to this one app, so the
  ordinary Flutter/Drift convention (regenerate, don't commit) applies
  instead. `connectivity_plus` (new dependency) drives the sync engine's
  online/offline signal.
- **Consequences:** Any future mobile phase adding local persistence
  should default to Drift for consistency, unless a concrete Isar-specific
  need arises that's worth adding the CI native-binary step for. Widget/unit
  tests always construct `AppDatabase(NativeDatabase.memory())` explicitly
  (`FevApp` gained an injectable `database` param for this) rather than
  letting the default file-backed constructor run under `flutter test`.

### D-047 — Offline Sync/Conflict Policy: Sequential Outbox, Revision-Based Conflict Surfacing

- **Decision owner:** Product owner, resolving the 7.2 phase brief's
  "STOP and ask" ambiguities on conflict UX depth and whether to add a
  batch-sync endpoint.
- **Decision:** The sync engine replays queued mutations **strictly
  sequentially, one row at a time**, through 7.1's existing per-item
  endpoints — no batch-sync endpoint was added; D-043's idempotent-upsert
  contract already makes single-item replay safe to retry. Conflict
  detection is last-writer-wins **by revision** end to end: `update` and
  (as of this phase) `assign_checklist_template` both carry an
  `expected_revision`; a mismatch never overwrites silently. On a 409
  `revision_conflict`/`invalid_transition`, the engine re-fetches the
  current server record and checks whether it already matches exactly what
  the queued mutation was trying to set — if so, an earlier attempt
  actually landed before the app died mid-request, and the replay is
  treated as success, not a conflict. A genuine mismatch surfaces a
  **minimal** conflict UI: a badge plus exactly two actions, "Keep my
  version" (requeue the local edit against the now-current revision) or
  "Discard mine, use server's" (adopt the server's fields) — no
  field-by-field merge view. A transient failure (`network_error`/
  `request_cancelled`) backs off exponentially (30s, 60s, 2m, 4m, ...
  capped at 30min) and **stops draining the rest of that pass** (a dropped
  connection fails every subsequent row identically); any other error
  (validation, 404) is treated as permanent and pauses that one row for
  manual retry/discard without blocking others. A discarded row that was
  the last one queued for its inspection flips that inspection to `error`
  state, since the local edit it represented is now permanently lost — an
  explicit, user-initiated exception to "never lose data silently," not a
  violation of it. Local data survives a normal same-user sign-out/
  sign-in/app-restart; only a genuinely different uid signing in on the
  same device wipes the local cache (`LocalInspectionsRepository
  .reconcileSessionOwner`, checked at every successful auth resolution via
  a `shared_preferences`-persisted owner uid — not literally hooked to
  `signOut()`/`expireSession()` as first sketched, since sign-out alone
  doesn't know who's signing in next).
- **Consequences:** Every future mutation type added to the outbox
  (7.4's media upload, 7.7's readings, etc.) should carry the same
  `expected_revision` discipline if it can conflict with a concurrent edit;
  omitting it reopens exactly the silent-overwrite gap D-043 and this
  decision close. The two-button conflict UX is intentionally minimal —
  a richer merge UI is a future UX decision, not implied by this one.

### D-048 — Checklist-Template Auto-Selection at Inspection Start

- **Decision owner:** Product owner, resolving the 7.3 phase brief's
  "STOP and ask" ambiguity on the tie-break rule when more than one
  active checklist template shares an asset's category.
- **Decision:** Auto-selection, run when a `draft` inspection's detail
  screen first loads, tries the asset's exact `category` among the
  local checklist-template cache; if more than one active template
  matches, the **most-recently-updated one wins**. If no category match
  exists, it falls back to the most-recently-updated `Generic` template.
  If neither exists locally, the inspection is left untemplated — an
  already-supported, honest state (7.1's `complete_inspection` already
  succeeds cleanly with no template assigned), not a broken one. The
  whole lookup is local/synchronous: `LocalInspectionsRepository` gained
  a `LocalChecklistTemplates` cache table refreshed best-effort right
  after sign-in (`refreshChecklistTemplatesFromNetwork`, mirroring 7.2's
  `refreshFromNetwork` pattern), so no network call sits in the
  inspection-start critical path — the whole point of an offline-first
  workflow.
- **Consequences:** A company with genuinely ambiguous template setup
  (two active templates for the same category, neither more authoritative
  than the other) gets a silent pick rather than an error surfaced to the
  field inspector; if that turns out to cause real confusion, the next
  option is an explicit `is_default` flag on `ChecklistTemplate` (a
  backend model change + admin UI toggle), deliberately not built now
  since it's more scope than the ambiguity currently warrants.

### D-049 — Checklist-Response Merge Is Upsert-by-`item_id`, Not Whole-Array Replace

- **Decision owner:** Discovered during 7.3 implementation, not a
  brief-driven ambiguity — a real bug, found while building continuous
  autosave and confirmed by a failing test before any fix landed.
- **Decision:** Both `LocalInspectionsRepository.updateInspection` and
  `InspectionService.update_inspection` (7.1) replaced the entire
  `checklist_responses` array with exactly what a given `PATCH`/call
  contained, rather than merging by `item_id`. This was invisible under
  7.2 since nothing ever called `updateInspection` with a checklist
  subset — but is exactly what 7.3's per-item autosave does every time an
  inspector answers one more item. Fixed on both layers as an
  upsert-by-`item_id`: the mobile repository merges the incoming
  response(s) into the currently-stored array before writing locally
  *and* before building the outbox payload (both paths could otherwise
  diverge); `InspectionService.update_inspection` merges the newly
  validated responses into the current stored array before persisting.
  A closely related bug surfaced by the same round-trip test:
  `LocalInspectionsRepository._upsertFromServer` stored
  `detail.status.name`/`detail.inspectionType.name` — built_value's
  Dart-identifier enum name (`inProgress`) — instead of the wire value
  (`in_progress`) every local write path and 7.3's new status-string
  comparisons (`editable`, auto-start gating) use. Invisible before now
  because `draft`/`completed`/`cancelled`/`ad_hoc` happen to be spelled
  identically either way; only `in_progress` differs. Fixed with a new
  `dartEnumNameToWire` helper (the inverse of the existing
  `wireToDartEnumName`) applied at that one call site.
- **Consequences:** Any future code comparing a `LocalInspectionRecord`'s
  `status`/`inspectionType` against a literal wire-style string can now
  trust it's always wire-form, regardless of whether the row was written
  locally or synced from the server. Any future endpoint/repository
  method accepting a partial list-typed field should default to
  merge-by-key semantics unless a genuine whole-array-replace use case is
  identified — silent data loss is the wrong default.

### D-050 — Inspection-Start GPS Capture Is Best-Effort and Non-Blocking

- **Decision owner:** Implied directly by the 7.3 phase brief ("Capture
  start GPS + timestamp"); the *how* (blocking vs. best-effort) was a
  judgment call made consistent with the server's own optional-GPS
  validation.
- **Decision:** `captureCurrentPosition()` (new `geolocator` dependency;
  Android `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION` and iOS
  `NSLocationWhenInUseUsageDescription` permission entries) checks/requests
  permission, then reads a position bounded by an 8-second
  `LocationSettings.timeLimit` — wrapped in its own outer 10-second
  `.timeout`, since the permission-check calls ahead of the position read
  have no bound of their own and can hang (rather than throw) with no
  platform channel registered, exactly the situation a plain
  `flutter test` widget test is in. Any denial, unavailability, or timeout
  resolves to `(null, null)` and never blocks starting an inspection —
  consistent with `InspectionService._validate_gps` only validating a
  value that's actually provided.
- **Consequences:** A field inspector working inside a steel-walled
  facility with no GPS fix, or who denies the permission prompt, still
  gets a fully working inspection with no location recorded — an honest
  gap, not a stalled workflow. Every widget test that can reach this code
  path relies on `test/flutter_test_config.dart` swapping in a
  `GeolocatorPlatform` double that resolves `isLocationServiceEnabled()`
  to `false` immediately, so no test depends on real platform-channel
  behavior.

## Locked Principles

These principles are reaffirmed alongside the resolved decisions and apply to all phases:

1. **Multi-tenancy:** Every record scoped by `company_id`. No cross-tenant data leakage.
2. **RBAC:** Many-to-many role→permission mapping enforced in BOTH FastAPI and UI. No hardcoded role enums.
3. **AI is advisory:** Inspector must confirm/override before any report finalizes. AI never takes autonomous action on safety-critical data.
4. **Offline-first field flows:** Durable local queues with background sync and conflict resolution.
5. **Audit-log every critical action:** All mutations to safety-critical data are logged with actor, timestamp, and before/after state.

## Session Review

- **2026-07-15 — Phase 0.3:** D-001 through D-003 remain locked. The Firebase Admin SDK/Firestore health implementation conforms to those decisions; no new product decision was introduced.
- **2026-07-15 — Phase 0.4:** Added and locked D-004 through D-006. Effective permission resolution is represented as `frozenset[str]`; the exact starter catalog and seven role templates remain a single source of truth in code.
- **2026-07-16 — Phase 0.5:** Added D-007, reaffirming D-003's provider-neutral
  verifier seam. Firebase custom claims carry tenant/role hints while scoped
  Firestore repositories remain authoritative for active identity and permissions.
- **2026-07-16 — Phase 0.6:** Added D-008. Server-side dependencies now enforce
  the Phase 0.4 matrix on the Phase 0.5 identity chain; client guards remain
  explicitly advisory and no cross-tenant exception was introduced.
- **2026-07-16 — Phase 0.7:** Added D-009. Admin and mobile now derive their
  themes, primitives, and motion feel from one generated token source, with dark
  default, persisted light mode, bundled fonts, and reduced-motion parity.
- **2026-07-16 — Phase 0.8:** Added D-010. FastAPI is the OpenAPI source of truth;
  pinned TypeScript Fetch and Dart Dio clients feed typed application wrappers,
  all errors share a request-ID envelope, and CI rejects contract drift.
- **2026-07-17 — Phase 1.1:** Added D-011. Both clients now use Firebase's client
  SDK and one auth provider to turn a persisted Firebase session into the scoped,
  permission-bearing `/me` identity; API authorization remains authoritative.
- **2026-07-17 — Phase 1.2:** Added D-012. Self-signup always creates a generated-ID
  tenant and its first company administrator; `/me` remains available to unverified
  identities while server application gates require a verified Firebase email.
- **2026-07-18 — Phase 1.3:** Added D-013. Both clients send Firebase password-reset
  emails directly and always answer with the same neutral confirmation, so account
  existence is never disclosed; Firebase's hosted action page performs the actual
  password change until a custom reset surface is scheduled.
- **2026-07-18 — Phase 1.4:** Added D-014, completing Phase 1. Client-layout
  guards (middleware rejected under D-011's browser-only session) enforce
  login/verify/permission routing with safe return-to destinations, and the API
  layer's single refresh-and-retry policy turns dead sessions into one clean
  sign-out. Server dependencies remain the authority on every protected call.
- **2026-07-19 — Phase 2.1:** Added D-015. Both clients render every protected
  screen inside one persistent shell whose navigation comes from a single
  declarative, permission-filtered config per client (mirrored contract);
  unbuilt modules show a branded "Coming soon" page and future platform
  affordances render visibly disabled rather than faked.
- **2026-07-22 — Phase 3.2:** Added D-024 through D-026. System roles stay
  permanently read-only and `super_admin` stays invisible to every 3.2 route;
  `platform.admin` can never be granted by a Company Admin; permission edits
  are enforced immediately server-side (live resolution, not claims-dependent)
  while claims sync and mobile stay read-only/consistency-only, mirroring the
  3.1 pattern.
- **2026-07-22 — Phase 3.3:** Added D-027 and D-028. Firebase Storage (its
  first use in this codebase) is fully server-mediated exactly like D-002's
  Firestore precedent — deny-all `storage.rules`, signed URLs generated
  per-request, one fixed company-scoped path convention for logo assets that
  later Storage features must reuse; only settings with a real, working
  consumer today shipped, with tier-limit enforcement explicitly deferred. A
  real bug was found and fixed during real-creds testing: `CompanyRepository.update`
  filtered `null` the same as "not provided," so clearing an optional field
  (industry, contact info) via PATCH silently did nothing — fixed by switching
  to Pydantic's `exclude_unset` semantics, which distinguish the two.
- **2026-07-22 — Phase 3.4:** Added D-029. The audit log viewer reuses D-019's
  single-index read-cost precedent (date range is the real query bound,
  everything else filters in-memory) instead of adding per-filter composite
  indexes, so this phase needed zero new Firestore index deploys. `audit.read`
  was added to the catalog and granted to `company_admin`/`super_admin`
  (automatic), `hse_manager`, and `executive`; existing non-demo tenants need
  one `reconcile_roles.py` run to backfill it. CSV export streams the same
  bounded/filtered query directly, capped and rejecting rather than truncating
  past the cap.
- **2026-07-23 — Phase 3.5:** Added D-030, resolving D-006 and completing
  Phase 3. Prerequisite closed first: `reconcile_roles.py` was run against
  the one real non-demo tenant on `thinking-case-469504-c0`
  (`cmp_feee017b83914cdd8323745e6359cc32`), backfilling `audit.read` per
  D-029. The new `AdminScope` seam is constructible only from a verified
  `platform.admin` token; a new reverse-guard test proves existing
  company-scoped routes stay tenant-scoped even for a super-admin caller;
  cross-tenant mutations dual-write to the target tenant's own trail and a
  reserved `"__platform__"` platform trail; a suspended company is blocked at
  `get_current_user` itself; `subscription_tier` is now a locked 4-value
  enum. Real-creds proof against the live project: seeded the real
  `super_admin` Firebase Auth user (`scripts.seed --with-auth-users`,
  previously never provisioned for this role), listed all 3 real tenants,
  assigned a real tier and suspended/reactivated the real non-demo tenant,
  confirmed its admin users were blocked then restored, verified the dual
  audit entries landed, and restored the tenant to its exact original state
  (including its pre-3.5 legacy `"unassigned"` tier value, which the new
  enum-enforcing endpoint can't itself reproduce, so that one restoration
  step went directly through the repository layer, matching every prior
  phase's "leave the tenant exactly as found" convention).
- **2026-07-23 — Phase 4.1:** Added D-031 through D-033, opening Phase 4.
  Three new tenant collections (`facilities` → `areas` → `assets`, plus
  optional asset self-nesting) give `assets.read`/`assets.write` — unused
  catalog placeholders since 0.4 — their first real backend. Introduces
  this codebase's first soft delete (`TenantRepository._soft_delete()`) and
  first Firestore-level filtered+ordered query (`AssetRepository.query()`,
  backed by four new composite indexes) — every other list route still
  reads-then-filters-in-Python. New `facilities.read/write`/`areas.read/write`
  permissions mirror each role's existing `assets.*` grants exactly, so no
  role's effective access shape changed apart from the new keys themselves.
  No UI, photo upload, KPI widgets, or QR were built — those are 4.2–4.5.
- **2026-07-26 — Phase 4.2:** Added D-034 and D-035. First read-only browse
  UI over the 4.1 hierarchy on both clients — a dense filterable asset list
  and a 5-tab detail view (Overview real; Inspections/Work Orders/History/
  Media honest-empty seams for Phases 7, 11, and 4.3). Mobile asset detail
  departs from the Users/Audit/Roles bottom-sheet convention with a pushed
  route (D-034), since 5 tabs of real content don't fit a sheet; GPS location
  stays a coordinates-plus-external-link readout rather than an embedded map
  (D-035), since no Google Maps Platform key/package existed in the repo and
  provisioning one is out of scope for a UI-only phase. No backend, schema,
  or permission changes.
- **2026-07-27 — Phase 4.3 complete:** Added D-036. Asset tags are
  tenant-unique, and asset photos/documents/manuals reuse D-027's private,
  server-mediated Storage model with explicit caps, asset-scoped paths,
  atomic Firestore array updates, and fresh signed URLs. Focused/full client
  verification, live Storage/audit proof, deterministic contract generation,
  and GitHub Actions run 30252741780 completed successfully.
- **2026-07-27 — Phase 4.3 native runners:** Added D-037 after product-owner
  confirmation. Android and iOS now share the permanent reverse-domain
  identity `com.flacronenterprises.energyverse` and display name
  `EnergyVerse`; the default Flutter `com.example` identity is prohibited.
- **2026-07-28 — Phase 4.4 complete (resolves 2.3):** Added D-038 and D-039.
  Assets became the first real registered consumer of a genuine pluggable
  dashboard widget framework, replacing 2.2's hardcoded `ReservedKpiRegion`
  with a permission-and-tier-filtered registry that isolates each widget's
  own failures. Total/Critical/Asset-Condition widgets ship on both clients,
  each linking/navigating to the 4.2 asset list pre-filtered; mobile adds a
  role-based task-focused subset for field_inspector/maintenance_technician.
  Every asset KPI number comes from a Firestore `count()` aggregation query
  (D-039), never a full-document read, needing zero new composite indexes.
  Backend/admin/mobile automated suites all green (full pytest, vitest, and
  flutter test runs); OpenAPI export and both pinned clients regenerated
  with a clean, minimal diff limited to the new endpoint and its 3 models.
- **2026-07-28 — Phase evidence policy:** Added D-040 per explicit
  product-owner instruction. Screenshot/browser evidence is no longer part
  of any future phase's completion contract; automated tests plus
  real-creds backend checks are sufficient, with visual QA owned by the
  human.
- **2026-07-29 — Phase 4.5 complete (Phase 4 now COMPLETE):** Added D-041
  and D-042 after the product owner resolved the phase brief's three
  explicit "stop and ask" ambiguities (QR payload URL scheme, scanner
  plugin, print/download format). Every asset now auto-receives an opaque
  `qr_code_id` on creation; a one-time cross-tenant backfill script covers
  pre-existing assets (verified live against `thinking-case-469504-c0`:
  11 Acme assets backfilled). `GET /api/v1/qr/{code}/resolve` is the
  company-scoped, audited scan surface (identical 404 for unknown vs.
  cross-tenant codes, proven against the live project with a real probe
  asset created/resolved/cross-tenant-rejected/cleaned up). Admin gained a
  QR display + Print/Download tab on the asset detail page and a
  `/qr/[code]` resolve-and-redirect route; mobile gained the primary
  camera scan surface (`mobile_scanner`, injectable scanner slot so widget
  tests never mount the real camera plugin) with a manual-entry fallback,
  a full scan-result screen (honest empty Inspections/Maintenance/
  Work-Orders sections), and a "Start Inspection" stub routing to the
  existing `ComingSoonScreen`. Backend (225 tests), admin (171 tests), and
  mobile (119 tests) suites all green; OpenAPI export and both pinned
  clients regenerated twice with an identical file set both times
  (deterministic, drift-clean).
- **2026-07-29 — Phase 7.1 (inspection data model, backend CRUD, and
  lifecycle):** Added D-043 through D-045. Inspections use a
  client-generated UUID id with an idempotent-upsert `POST` (D-043) so a
  7.2 offline client never has to wait for server-assigned ids, plus a
  monotonic `revision` (not a timestamp) for conflict detection, chosen
  specifically because this dev environment already hit a real
  cross-device clock-skew bug. Checklist templates got lightweight
  `version` integers with a full items-snapshot taken at
  assignment-time (D-044), never re-reading the live template afterward.
  Lifecycle is `draft → in_progress → completed/cancelled` with
  `checklist_responses[]` accepted and validated via the API now even
  though no capture UI exists yet (D-045) — "capture" was read as an
  interactive UI concept, not an API one, since the brief's own required
  test ("complete blocks on unanswered required items") is otherwise
  impossible to build. Mobile's QR scan-result screen gained a real "Start
  Inspection" action creating a genuine `draft` via the API. Backend (268
  tests, 3 credential-only skips), admin, and mobile (125 tests) suites
  all green; real-creds proof against `thinking-case-469504-c0` covered
  idempotent resubmit, checklist assignment/answer/lifecycle, and D-033's
  asset-history resolution, with two early orphaned-probe cleanups from a
  not-yet-ready composite index.
- **2026-07-29 — Phase 7.2 (offline engine: local store + sync queue +
  conflict resolution):** Added D-046 and D-047. Chose Drift over Isar for
  the local cache specifically because the existing mobile CI job has no
  native-binary-fetch step Isar would have needed; `LocalInspections`/
  `Outbox` Drift tables plus a `LocalInspectionsRepository` facade give
  every inspection write path (create/edit/start/complete/cancel/assign-
  template) an instant local-first write plus a queued outbox mutation,
  never waiting on the network. `SyncEngine` replays the outbox
  sequentially through 7.1's existing endpoints (no batch-sync endpoint),
  using D-043's revision contract for last-writer-wins conflict detection
  with a minimal two-button ("keep mine" / "use server's") resolution UI,
  exponential backoff for transient failures, and a distinct paused state
  for permanent ones. A real correctness gap from 7.1 was found and fixed
  as a companion change: `assign_checklist_template` had no
  `expected_revision` guard at all (unlike `update`), so a replayed
  offline reassignment could have silently overwritten another device's
  concurrent checklist responses — now closed with the same
  `RevisionConflictError` → 409 pattern `update` already used. Local data
  persists across app restarts and normal same-user sign-out/sign-in;
  only a genuinely different uid signing in on the same device wipes it
  (`reconcileSessionOwner`, checked at every auth resolution rather than
  hooked to sign-out itself, since sign-out alone can't know who's signing
  in next). Backend (271 tests total, 2 new), and mobile (161 tests: 125
  existing + 11 new `LocalInspectionsRepository` tests + 10 new
  `SyncEngine` tests covering create/coalesced-edit/complete sync,
  transient-retry-without-duplication, both conflict branches (genuine and
  already-applied), permanent-error pausing, the single-flight drain
  guard, and an app-restart persistence scenario against a real on-disk
  Drift file) all green; real-creds proof against
  `thinking-case-469504-c0` confirmed the idempotent-upsert replay
  contract and forced genuine `revision_conflict` 409s on both `update`
  and the newly-guarded `assign_checklist_template`, then hard-deleted the
  probe inspection. Regenerating the Dart/TypeScript clients for the new
  `expected_revision` field hit a persistent Windows file-lock on the dev
  machine itself; since the equivalent CI job's Linux runner has no such
  lock, its own from-source regeneration was applied directly to the repo
  instead (see TESTING.md) — the mobile client's `assignChecklistTemplate`
  call now threads `expected_revision` through like every other mutation
  type.
- **2026-07-30 — Phase 7.3 (inspection start flow and checklist
  filling):** Added D-048 through D-050. Checklist-template auto-selection
  (D-048) picks the matching category's most-recently-updated active
  template, falls back to `Generic`, or leaves the inspection untemplated —
  entirely from a local cache refreshed after sign-in, so no network call
  sits in the start path. Two real bugs were found and fixed, not designed
  around (D-049): `updateInspection`'s checklist-response handling (both
  mobile and backend) was a whole-array replace, not an upsert-by-`item_id`,
  which 7.2 never exercised but 7.3's per-item autosave would have hit on
  every second answer; and `_upsertFromServer` stored the Dart-identifier
  enum name instead of the wire value for `status`/`inspectionType`,
  invisible until this phase's status-string comparisons needed
  `in_progress` specifically. GPS capture (D-050) is best-effort and
  non-blocking, with an outer timeout guarding against a platform channel
  that hangs instead of throwing. `InspectionDetailScreen` (read-only since
  7.2) is now interactive for `draft`/`in_progress` with continuous
  autosave, a progress header, and a Complete button gated on a shared
  required-items helper; a new "Start Inspection" entry point was added to
  the asset detail screen (previously QR-only). No route/schema changes,
  so no contracts regeneration was needed. Backend (272 tests total, 1 new
  partial-upsert test; 269 passed, 3 credential-only skips) and mobile
  (154 tests total, all passing — new/updated coverage for the merge fix,
  template auto-selection/tie-break/fallback, the interactive fill screen,
  and the auto-start-on-open flow) all green; `flutter analyze`/ruff/mypy
  clean; `git diff --exit-code -- packages/contracts` confirmed no drift.
