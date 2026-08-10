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
| D-051 | Media queue is separate from inspection-record sync, and uploads direct-to-Storage | **A second, independent Drift table + worker (`MediaQueue`/`MediaUploadWorker`) drains against Firebase Storage, never sharing a drain loop/transaction with 7.2's `Outbox`/`SyncEngine` — heavy media bytes must never stall the lightweight checklist-autosave path. Media uploads directly from the mobile client to Storage (not proxied through the backend like 4.3's asset media) via a new `storage.rules` carve-out scoped to the caller's `company_id` claim; only a small metadata reference then rides the *existing* inspection outbox as a new `attach_media`/`edit_media`/`detach_media` mutation type. All three are idempotent (by `local_id`/`media_id`) and deliberately carry no `expected_revision` — media traffic must never collide with the checklist-revision protocol.** | **RESOLVED — LOCKED** | 2026-08-02 |
| D-052 | Field video capture caps: 3 minutes, ~1080p | **`kMaxVideoDuration` = 3 minutes, `ResolutionPreset.veryHigh` (~1080p) — the recording auto-stops at the cap rather than trusting the inspector to notice. Matches the backend's `INSPECTION_MEDIA_RULES` video size ceiling (500MB), which a gallery-picked video is checked against locally before enqueueing, to reject an oversized file before a doomed upload attempt.** | **RESOLVED — LOCKED** | 2026-08-02 |
| D-053 | Before/after model: independent tags, not linked pairs | **`InspectionMedia.before_after_tag` is a plain optional `before`/`after` value on each item, not a `pair_id` linking two specific items. Simpler to maintain (removing one photo never orphans a pair reference) and the comparison view lets the inspector pick any tagged before + any tagged after photo, not just one designated pair — a hand-rolled drag-to-reveal slider, no third-party comparison package.** | **RESOLVED — LOCKED** | 2026-08-02 |
| D-054 | Damage annotation data model: normalized vector, one `points[]` shape for all five tools, AI-reusable | **`Inspection.annotations[]` (top-level, not nested under `media[]`), each carrying `media_local_id` + `shape` + normalized (0-1) `points[]` + `color`/`damage_type`/`note` + `source` (`manual`\|`ai`, default `manual`) + nullable `confidence`. One `points[]` field covers point/rectangle/circle/arrow/freehand instead of a shape-specific schema, so Phase 7.10's AI-detected regions render on the exact same overlay model without a schema change.** | **RESOLVED — LOCKED** | 2026-08-05 |
| D-055 | Annotation mutation protocol mirrors 7.4 media, not checklist-autosave revision | **Three new `inspections` routes (create/update/delete annotation), idempotent by client-generated annotation `id`, deliberately carrying no `expected_revision` — annotation traffic must never collide with 7.3's checklist-autosave revision bump, same rationale as D-051's media decision. Mobile rides the existing 7.2 record outbox (three new `OutboxMutationType` values), never a separate queue, but writes to the local cache optimistically (unlike media) since there's no secondary upload step between "drawn" and "visible offline."** | **RESOLVED — LOCKED** | 2026-08-05 |
| D-056 | Voice-note recording caps: 10 minutes, AAC/M4A, pulsing level meter | **`kMaxVoiceNoteDuration` = 10 minutes (mirrors D-052's video-cap rationale: long enough for a detailed narrated walkthrough, short enough that a forgotten recording doesn't produce an outsized upload over field connectivity), encoded as AAC in an M4A container (`AudioEncoder.aacLc` — compact for a given recording length, hardware-encoded on both iOS/Android, ~9.6MB worst case at the cap). The live recording indicator is a single pulsing level meter reacting to input amplitude, not a scrolling waveform history — chosen for the same gloves-on-field-friendly reason the brief called for "simple": one glanceable indicator, no additional UI surface to build/test beyond it.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-057 | Voice notes reuse the 7.4 media pipeline end to end, under their own Storage namespace | **A voice note's bytes go through the exact same `MediaQueue`/`MediaUploadWorker` a photo/video does (`kind == 'audio'`, a new nullable `durationMs` column) rather than a new queue/worker — the drain loop, backoff, progress tracking, and cancel-on-remove are 100% shared code; only the storage subfolder (`voice/` vs `media/`, via a new `voice_object_path()`/`inspectionVoiceNoteStoragePath()` pair mirroring the existing `object_path()`) and the outbox mutation type (`attach_voice_note`/`edit_voice_note`/`detach_voice_note` vs `attach_media`/`edit_media`/`detach_media`) differ. Backend mutation protocol mirrors D-051/D-055 exactly: idempotent by `local_id`/`voice_note_id`, no `expected_revision`. `Inspection.voice_notes[]` (7.1's untyped placeholder) becomes a real `VoiceNote` entity, still its own top-level array, not nested under `media[]`.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-058 | Manual status readings: fixed documented units, no per-reading unit field | **`Readings.temperature_c`/`pressure_bar`/`noise_level_db` are always Celsius/bar/decibels — unit-suffixed field names, not a per-reading unit selector — so the unit is unambiguous from the identifier itself in code and on the wire. `operational_status` is `running`\|`stopped`\|`degraded`, matching the phase brief's own example exactly.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-059 | Readings mutation protocol rides the existing checklist-autosave revision path, not the 7.4/7.5/7.6 append pattern | **`Inspection.readings` is a single nullable `Readings` object (not an array of independent records), so it's mutated through the pre-existing `update_inspection`/`expected_revision`-aware PATCH the 7.3 checklist already uses — a new `readings` field on `UpdateInspectionRequest`, no new repository method, no new `OutboxMutationType`, no `expected_revision` bypass. This is the opposite of D-051/D-055/D-057's shared rationale (media/annotations/voice-notes are independent-record arrays that must never collide with the checklist-autosave revision bump); readings is form-like single-object data, the same shape as `title`/`notes`/`checklist_responses`, so it correctly reuses that exact protocol. On `complete_inspection` only, the condition maps onto the asset's 4.1 `current_status` via a new `AssetRepository.roll_up_status_from_inspection` (own `asset.status_rolled_up` audit action, distinct from the generic `asset.updated`), which the existing 4.4 dashboard `count()` aggregation reflects with no caching.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-060 | Digital signature integrity: vector storage, server-derived identity, revision-binding | **`Signature.strokes` is normalized (0-1) vector data (`list[SignatureStroke]`, each `{points: list[AnnotationPoint]}` — a named single-level-nesting wrapper, not a raw `list[list[...]]`, to avoid a real Dart-generator builder-factory gap hit mid-phase), never a raster image. Signer identity/timestamp are always server-derived (`current_user` + a `UserRepository` lookup for `display_name`) — `CompleteInspectionRequest` has no signer field at all. `signature.inspection_revision` is stamped as the inspection's own post-completion revision, guaranteed to match the request's `expected_revision`.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-061 | Completion requires signature: atomic, no reopen | **`POST /inspections/{id}/complete` now requires a body (`strokes` + `expected_revision`) — signing is the mandatory final step, no separate sign-then-complete call, no way to complete unsigned. A completed inspection stays fully immutable (no reopen/re-edit capability added); "edited after signing" is realized narrowly as the pre-completion offline race, rejected via the existing `revision_conflict` 409 (checked before the checklist-completeness check) and resolved by the existing `SyncEngine` conflict sheet, fixed this phase to correctly revert a stale `complete` mutation's optimistic status flip.** | **RESOLVED — LOCKED** | 2026-08-06 |
| D-063 | Waiving D-062's physical-device validation gate before Phase 7.9 Step 2 | **Product owner explicitly chose to proceed straight to the full AR measurement feature (data model, offline sync, manual fallback, screenshot capture) without a human confirming `ar_flutter_plugin_2` plane detection/measurement on a real ARCore/ARKit device first. The D-062 spike code, permission/manifest changes, and dependency stay exactly as built. Risk accepted: if the plugin proves inadequate on real hardware later, the AR capture path (not the manual-entry path, the data model, or the sync protocol) is what gets swapped for native platform channels — everything else in Step 2 is written to be plugin-agnostic for exactly this reason.** | **RESOLVED — LOCKED** | 2026-08-10 |
| D-064 | AR/manual measurement data model, screenshot evidence, and mutation protocol (Phase 7.9 Step 2) | **`Inspection.ar_measurements[]` (replacing the 7.1 `list[dict]` placeholder) holds one `ArMeasurement` per capture: `id`, `method` (`ar`\|`manual`), `distance_meters` (always meters, fixed-unit convention per D-058), optional `label`/`note`/`checklist_item_id`, optional `media_local_id` (an existing `InspectionMedia` item as visual evidence), and `points: list[AnnotationPoint]` reusing D-054's normalized-point shape but left genuinely optional — `ar_flutter_plugin_2` exposes no 2D screen-tap coordinate alongside its 3D hit-test result, so exact overlay markers are not fabricated; the screenshot alone is the AR method's evidence requirement (`media_local_id` mandatory, `points` not). Mutation protocol mirrors D-054/D-055's annotations exactly: three routes (create/update/delete), idempotent by client-generated `id`, no `expected_revision` (measurement traffic must never collide with checklist-autosave). Update is deliberately narrow — only `label`/`note`/`checklist_item_id` are mutable; method/distance/screenshot/points are immutable once created (delete-and-recreate fixes a mistake, same posture as media's checklist-link-only update). An AR screenshot is a plain `InspectionMedia` photo through the *existing* 7.4 pipeline (no new storage subfolder, no new `MediaKind`, no `MediaQueue` schema change) — a measurement simply references its `local_id`, exactly how an annotation references the photo it's drawn on, decoupling the measurement record from the screenshot's own upload completion. Mobile captures the screenshot via `ARSessionManager.snapshot()` (extracting bytes from the plugin's own `MemoryImage` return) and reuses `LocalMediaRepository.enqueueCapture` unmodified.** | **RESOLVED — LOCKED** | 2026-08-10 |
| D-065 | AI photo analysis data model, Claude vision integration, and mutation protocol (Phase 7.10) | **`Inspection.ai_analysis[]` (replacing the 7.1 `dict \| None` placeholder) holds one `AiAnalysis` per run: `id`, `media_local_id`, `model`, `summary`, optional `recommendations`/`risk_level`, `annotation_ids` (the findings it produced), `reviewed`/`reviewed_by`/`reviewed_at`, `created_by`, `created_at`. Every detected finding is persisted as its own `Annotation(source="ai", confidence=...)` — the exact mechanism D-054 reserved `source`/`confidence` for; no new overlay model, no new review UI primitive. `app/ai/vision_client.py`'s `ClaudeVisionClient` is the first third-party HTTP/SDK call in this backend (every prior integration is Firebase) — a forced tool-use call (`report_photo_analysis`) constrains the model to return `summary` + `findings[]` (`shape`, 1-2 normalized points, optional `damage_type` from the same enum `Annotation` uses, `confidence`, optional `note`); a `VisionAnalysisClient` protocol is what `InspectionService` depends on so tests inject a `FakeAiClient`, no real API key required for CI. Two new routes deliberately don't mirror create/update/delete or attach/detach: `POST .../media/{media_id}/analyze` (triggers a fresh run, identified by the media item's server id like `update_inspection_media`) and `POST .../ai-analysis/{analysis_id}/review` (marks reviewed — the "confirm" half of D-008; "override" is simply editing/deleting the resulting annotations through the existing endpoints, no separate action). `InspectionRepository.append_ai_analysis` writes the new annotations and the analysis record in one atomic Firestore update. Mobile/admin: `analyzeMedia`/`reviewAiAnalysis` are direct, immediate, ONLINE-ONLY calls, never queued through the offline outbox like every other mutation — there is no honest optimistic echo for an AI response that doesn't exist yet, and the action requires live connectivity to a paid third-party API regardless.** | **RESOLVED — LOCKED** | 2026-08-10 |

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

### D-051 — Media Queue Is Separate From Inspection-Record Sync, and Uploads Direct-to-Storage

- **Decision owner:** Implied by the 7.4 phase brief's own locked
  "Media offline architecture" section ("Media is HEAVY and must NOT
  block the lightweight inspection-record sync"); the *how* (a second
  Drift table/worker, and direct-to-Storage vs. backend-proxied upload)
  was a judgment call, the latter explicitly confirmed with the product
  owner given the tension with 4.3's established server-mediated pattern.
- **Decision:** `MediaQueue` (new Drift table) and `MediaUploadWorker`
  (new class) are entirely independent of 7.2's `Outbox`/`SyncEngine` —
  no shared drain loop, transaction, or Timer. Media bytes upload directly
  from the mobile client to Firebase Storage via `firebase_storage`'s
  `putFile` (not proxied through the backend like 4.3's `AssetMediaStorage`
  asset photos/documents), since proxying a 150–270MB video would double
  the network hop and risk stalling the very sync path this design exists
  to protect. A new `storage.rules` carve-out (the first departure from
  "everything is server-mediated" since 3.3) allows a `create`-only write
  to `companies/{company_id}/inspections/{inspection_id}/media/{file}`
  when the caller's `company_id` custom claim matches and the object is
  under 500MB; it cannot check `inspections.write` or that the inspection
  is real (neither is in the token), so an unreferenced write is an inert
  orphan — never readable (`allow read: if false`) and never live in
  `inspection.media[]` until the backend's attach endpoint registers it.
  That backend endpoint (and its update/detach siblings) never receive
  bytes, only verify+read back what's already in Storage, and are
  idempotent by `local_id`/`media_id` with no `expected_revision` — media
  traffic must never collide with the checklist-revision protocol
  (D-047's own warning to future mutation types, acted on here).
- **Consequences:** An inspection can sync to `completed` while its media
  is still uploading in the background — the gallery's live "N of M
  uploaded" count is what keeps that state honest rather than looking
  finished when bytes are still pending. The Storage security model now
  has two shapes (server-mediated for everything else, client-direct for
  inspection media specifically) instead of one uniform rule; any future
  media-bearing feature should default to asking which shape fits rather
  than assuming the 4.3 pattern is universal.

### D-052 — Field Video Capture Caps: 3 Minutes, ~1080p

- **Decision owner:** Product owner, resolving the 7.4 phase brief's own
  flagged ambiguity ("video length/resolution caps... STOP and ask").
- **Decision:** `kMaxVideoDuration` is 3 minutes; capture resolution is
  `ResolutionPreset.veryHigh` (the `camera` plugin's ~1080p tier). The
  `_CameraCaptureView` auto-stops recording the instant the cap is
  reached rather than trusting the inspector to notice and stop manually.
  A gallery-picked video is checked against the backend's own
  `INSPECTION_MEDIA_RULES` video size ceiling (500MB) locally before
  enqueueing, rejecting an oversized file before a doomed upload attempt
  and round trip.
- **Consequences:** A 3-minute/1080p clip can still be very large
  (~150–270MB depending on bitrate) over poor field connectivity — this
  is exactly why D-051's separate media queue/worker and direct-to-
  Storage upload exist, so a single large file's upload time never blocks
  anything else. If field feedback later calls for longer clips, the cap
  is a single constant to change; the queue/worker architecture doesn't
  need to change with it.

### D-053 — Before/After Model: Independent Tags, Not Linked Pairs

- **Decision owner:** Product owner, resolving the 7.4 phase brief's own
  flagged ambiguity ("before/after model... STOP and ask").
- **Decision:** `InspectionMedia.before_after_tag` is a plain optional
  `before`/`after` value on each media item, not a `pair_id` linking two
  specific items together. The comparison view
  (`_MediaComparisonScreen`, a hand-rolled drag-to-reveal slider — no
  third-party comparison package) lets the inspector pick *any*
  before-tagged photo and *any* after-tagged photo to compare, not just
  one designated pair.
- **Consequences:** Simpler to maintain than an explicit-pair model —
  removing one photo never leaves an orphaned pair reference to clean up,
  and re-tagging is a single-field edit rather than a two-sided
  relationship update. The tradeoff: nothing stops an inspector from
  tagging three "before" photos with no clear single intended
  counterpart; the UI doesn't enforce a 1:1 relationship, by design, since
  the brief only asked for a comparison view, not pairing semantics as a
  data-integrity guarantee.

### D-054 — Damage Annotation Data Model: Normalized Vector, One `points[]` Shape, AI-Reusable

- **Decision owner:** Engineering, resolving the 7.5 phase brief's own
  design constraint ("design the annotation layer so 7.10's AI-detected
  regions can later render on the SAME layer... but only BUILD manual
  drawing now").
- **Decision:** `Inspection.annotations[]` stays top-level (the 7.1-era
  placeholder field's location), not nested under `media[]` — each
  `Annotation` carries its own `media_local_id` so it's still queryable
  per-photo by filtering the flat list, without needing a second index or
  a nested-array-in-Firestore update path. Coordinates are normalized
  (0–1, relative to the photo's own rendered box, never raw pixels), and
  a single `points: list[{x, y}]` field represents every one of the five
  shapes (`point`: 1 point; `rectangle`/`circle`/`arrow`: 2 points as
  corners/bounding-box/tail-head; `freehand`: 2+ points as a polyline)
  instead of a shape-specific schema (e.g. a separate `radius` for circle,
  `x`/`y`/`width`/`height` for rectangle). `source` (`manual`\|`ai`,
  default `manual`) and `confidence` (nullable) exist in the schema now,
  populated only as `manual`/`null` until Phase 7.10 adds AI-detected
  regions.
- **Consequences:** Phase 7.10 can add an AI-detected region as a plain
  `Annotation` with `source="ai"` and a real `confidence`, rendered by the
  exact same overlay painters (mobile `AnnotationOverlayPainter`, admin
  `AnnotationOverlay`) with zero schema or rendering-code change — the
  cost paid now is a slightly more abstract `points[]` representation
  (callers must know how many points a given `shape` expects) instead of
  named fields per shape, and every renderer must switch on `shape` to
  interpret `points[]` correctly rather than reading self-describing
  fields.

### D-055 — Annotation Mutation Protocol Mirrors 7.4 Media, Not Checklist-Autosave Revision

- **Decision owner:** Engineering, extending D-051's (7.4 media) own
  documented warning that future mutation types touching a small array
  field should not collide with the checklist-autosave revision protocol.
- **Decision:** The three new annotation routes (`POST .../annotations`,
  `PATCH .../annotations/{id}`, `DELETE .../annotations/{id}`) are
  idempotent by the client-generated annotation `id` and carry no
  `expected_revision`, exactly mirroring `attach_media`/`update_media`/
  `detach_media`'s posture rather than `update_inspection`'s revision-
  checked one. `InspectionRepository` gained `append_annotation`/
  `update_annotation`/`remove_annotation` using the same `ArrayUnion`/
  `ArrayRemove`/full-array-rewrite mechanics as the media repository
  methods. On mobile, the three new `OutboxMutationType` values
  (`create_annotation`/`update_annotation`/`delete_annotation`) ride the
  existing 7.2 `Outbox`/`SyncEngine` — the same outbox media's mutations
  use — rather than a new queue, since annotations are small vector data
  with nothing resembling media's heavy-byte upload problem. Unlike
  media, though, annotation writes land in the local `LocalInspections.
  annotations` cache **optimistically** (immediately, before the matching
  outbox row even attempts to send) rather than waiting for
  `MediaQueue`-style secondary-table visibility, since there's no
  equivalent secondary queue for annotations to be visible through in the
  interim.
- **Consequences:** Annotation traffic can never trigger a
  `revision_conflict` against a concurrent checklist edit, matching
  media's own guarantee. The cost is the same one D-051 already accepted
  for media: no annotation mutation participates in the inspection's
  optimistic-concurrency story at all, so two inspectors editing the
  *same* annotation concurrently (rare in practice — annotations are
  effectively single-writer, drawn by whoever is holding the phone) would
  have last-write-wins semantics with no conflict surfaced, unlike a
  concurrent checklist edit.

### D-056 — Voice-Note Recording Caps: 10 Minutes, AAC/M4A, Pulsing Level Meter

- **Decision owner:** Product owner, confirmed explicitly when this phase's
  brief flagged audio format/length caps and waveform depth as genuine
  ambiguities not to assume.
- **Decision:** A single voice-note recording is capped at 10 minutes,
  encoded as AAC in an M4A container, auto-stopping at the cap the same way
  7.4's video recording auto-stops at its own 3-minute cap. The live
  recording indicator is a single pulsing level meter (a circle that grows/
  brightens with input amplitude) rather than a scrolling waveform-history
  view.
- **Consequences:** A worst-case recording is ~9.6MB (10 minutes at a
  generous 128kbps AAC bitrate), comfortably under the server's 20MB
  `INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES` ceiling with headroom for encoder
  variance — an inspector never hits the size cap before the duration cap
  does. The level-meter choice trades a more polished voice-memo-app look
  for less new UI surface to build and widget-test; if a future phase needs
  a richer visualization (e.g. a transcription-time waveform scrubber),
  it's a new component, not a rework of this one, since nothing about the
  recording pipeline itself depends on how the live meter is rendered.

### D-057 — Voice Notes Reuse the 7.4 Media Pipeline End to End, Under Their Own Storage Namespace

- **Decision owner:** Engineering, per the phase brief's explicit instruction
  to reuse 7.1's `voice_notes[]` container, 7.2's offline engine, and 7.4's
  media upload worker/queue rather than building parallel infrastructure.
- **Decision:** `MediaQueue`/`MediaUploadWorker` (Phase 7.4) gain a third
  `kind` value, `'audio'`, plus a nullable `durationMs` column — no new
  Drift table, no new worker class. `LocalMediaRepository.enqueueCapture`
  and `MediaUploadWorker._registerReference` each add one `kind`-based
  branch; every other line of the drain loop, backoff formula, progress
  stream, and cancel-on-remove logic is unmodified, shared code. On the
  backend, `attach_voice_note`/`update_voice_note`/`detach_voice_note`
  mirror `attach_media`/`update_media`/`detach_media` field-for-field
  (idempotent by `local_id`/`voice_note_id`, no `expected_revision`, same
  rationale as D-051/D-055), and `InspectionMediaStorage` gains a sibling
  `voice_object_path()` alongside `object_path()` so voice bytes land under
  `.../inspections/{id}/voice/` rather than `.../media/` — a distinct
  namespace even though the direct-upload mechanics are identical.
  `Inspection.voice_notes[]` (untyped since 7.1) becomes a typed `VoiceNote`
  entity, staying a top-level array rather than nesting under `media[]`,
  matching D-054's `annotations[]` precedent for a phase-specific sub-
  resource of an inspection.
- **Consequences:** Zero new offline-sync infrastructure to maintain or
  test independently — every bug class the 7.4 media tests already cover
  (backoff, retry, cancel-in-flight, restart persistence, progress
  tracking) is structurally guaranteed to apply to voice notes too, proven
  by one new worker test asserting an audio item drains through the exact
  same `syncNow()` path and registers `attach_voice_note` instead of
  `attach_media`. The cost: any future change to `MediaQueue`'s shared
  columns/worker logic now has three kinds to reason about, not two, and a
  consumer of the shared stream (`InspectionMediaSection`'s photo/video
  gallery) must actively filter out kinds it doesn't own — a real gap this
  phase's own tests caught (see the Phase 7.6 architecture section) after
  the gallery was found rendering queued audio rows as broken tiles.

### D-058 — Manual Status Readings: Fixed Documented Units, No Per-Reading Unit Field

- **Decision owner:** Product owner (asked directly at phase start; the
  brief flagged units strategy and `operational_status`'s enum values as
  points to confirm rather than assume).
- **Decision:** Temperature, pressure, and noise readings always store in
  Celsius, bar, and decibels respectively — no per-reading unit field, no
  unit picker in either client. Field names are unit-suffixed
  (`temperature_c`, `pressure_bar`, `noise_level_db`) so the unit reads
  directly off the identifier in code, on the wire, and in Firestore, with
  no conversion step anywhere in this phase. `operational_status` takes
  the phase brief's own example values verbatim: `running`\|`stopped`\|
  `degraded`.
- **Alternatives considered:** A per-reading unit selector (e.g. °C or °F,
  psi or bar), rejected as the non-default option — it would add a unit
  field + validation to each of the three numeric readings and complicate
  any future cross-inspection comparison/charting, which would first have
  to normalize mixed units before aggregating.
- **Consequences:** A company-level display-unit preference (e.g.
  Fahrenheit for a US-based field team) can be layered on top later purely
  as a display-time conversion, since the stored value and unit never
  change — no data migration would be needed. Any future phase adding a
  new numeric reading type should keep the same unit-suffixed-field-name
  convention rather than introducing a per-value unit field.

### D-059 — Readings Mutation Protocol Mirrors Checklist Autosave, Not the 7.4/7.5/7.6 Append Pattern

- **Decision owner:** Engineering, driven by the readings data shape
  itself — a single object per inspection, not an array of independent
  records.
- **Decision:** `Inspection.readings` is `Readings | None`, replacing the
  7.1-era untyped `dict` placeholder. `UpdateInspectionRequest`/
  `InspectionUpdate` gain a `readings: ReadingsInput | None` field
  alongside the pre-existing `checklist_responses`; the server stamps
  `recorded_at`/`recorded_by` (mirroring `ChecklistResponse.answered_at`/
  `answered_by`) and the existing `InspectionRepository.update`'s
  whole-field-replace-by-key merge persists it — no new repository method,
  no new `OutboxMutationType` on the mobile outbox, and `expected_revision`
  applies exactly as it already does to every other field on this same
  PATCH. This is a deliberate departure from D-051 (media)/D-055
  (annotations)/D-057 (voice notes), all three of which avoid the
  revision protocol on purpose because they're independent-record arrays
  mutated out of band from checklist autosave — readings has no such
  concern, since it's one form with one editor, the same shape as
  `title`/`notes`/`checklist_responses` which already ride this exact
  path.
- **Asset health rollup (the phase's core connection):** On
  `complete_inspection` only (never on a draft/in-progress PATCH, so
  mid-inspection edits can't flip the asset's displayed health),
  `READINGS_CONDITION_TO_ASSET_STATUS` maps the condition
  (`Excellent`/`Good` → `Healthy`, `Fair`/`Poor` → `Warning`, `Critical` →
  `Critical`) onto the asset's 4.1 `current_status` via a new
  `AssetRepository.roll_up_status_from_inspection` — mirrors
  `backfill_qr_code`'s narrow-update-plus-explicit-audit shape with its
  own `asset.status_rolled_up` action (metadata: `from`/`to`/
  `inspection_id`), distinct from the generic `asset.updated` audit a
  human edit through 4.2/4.3 would produce. No new caching/materialization
  is introduced — 4.4's existing `AssetRepository.count()` live Firestore
  aggregation (D-039) reflects the change on its very next read, proven
  end to end against the real Firebase project.
- **Alternatives considered:** Mirroring the 7.4/7.5/7.6 append/idempotent-
  by-id pattern (a dedicated `save_readings` mutation type bypassing
  `expected_revision`), rejected as unnecessary complexity for data that
  has exactly one writer and no independent-record identity to dedupe by.
  A manual (inspector-set) asset-health override instead of the derived
  mapping was also considered per the phase brief's own prompt, but the
  derived mapping was kept as specified since no product need for a
  manual override surfaced.
- **Consequences:** Any future single-object (not array) inspection field
  should extend `UpdateInspectionRequest` the same way rather than
  inventing a new mutation type; any future phase that needs to derive an
  asset-level rollup from an inspection outcome should extend
  `AssetRepository` with its own narrowly-named method + distinct audit
  action, following `roll_up_status_from_inspection`'s shape, rather than
  routing through the generic `update_asset`.

### D-060 — Digital Signature Integrity: Vector Storage, Server-Derived Identity, Revision-Binding

- **Decision owner:** Product owner (asked directly at phase start; the
  brief flagged storage format and completion-gating as points to confirm
  rather than assume), with one engineering-driven addition (the
  stroke-object shape) discovered mid-implementation.
- **Decision:** `Signature.strokes` is vector data — normalized (0–1)
  points, identical in shape to `Annotation.points` (D-054) — not a
  raster image; no Storage upload or signed-URL round trip. Signer
  identity (`signer_uid`/`signer_name`/`signer_role`) and `signed_at` are
  always derived server-side from the authenticated caller
  (`current_user.uid`/`role_key` plus a `UserRepository.get()` lookup for
  `display_name`); `CompleteInspectionRequest` has no signer field at all,
  so a client cannot supply one even by accident. `signature.
  inspection_revision` is stamped as the inspection's OWN revision after
  the completion write (`current.revision + 1`), which
  `complete_inspection` guarantees matches the request's
  `expected_revision` before proceeding — so the persisted signature is
  always bound to exactly the revision it attests to.
- **Stroke shape correction (mid-phase):** `strokes` is
  `list[SignatureStroke]` (each `{points: list[AnnotationPoint]}`), not a
  raw `list[list[AnnotationPoint]]` as first implemented. The doubly-
  nested list shape hit a real bug: the pinned Dart openapi-generator
  emits a builder factory for the outer `ListBuilder<BuiltList<X>>` but
  not the inner single-level `BuiltList<X>` construction built_value's
  serializer also needs, throwing `StateError: No builder factory for
  BuiltList<SignaturePointInput>` at runtime the first time a mobile
  widget test actually serialized a `CompleteInspectionRequest`. A named
  stroke object sidesteps the generator gap entirely (single level of
  list-of-object nesting, the same shape `Annotation.points` already
  proves works) and leaves room for future per-stroke metadata (color,
  width) without another schema change.
- **Alternatives considered:** Raster image via the 7.4 media pipeline
  (upload to Storage under an inspection-scoped path, register a
  reference like a photo), rejected as the non-default option — heavier
  (upload round trip, Storage path, signed URL) for what's ultimately a
  small line drawing, with no AI/report-rendering need for pixel data
  specifically.
- **Consequences:** Any future phase rendering the signature (e.g. a
  generated PDF report) draws the vector strokes directly rather than
  fetching an image. Any future doubly-nested-list field in the OpenAPI
  schema should default to a named single-level-nesting wrapper object
  (this pattern) rather than `list[list[X]]`, to avoid re-hitting the
  same generator gap.

### D-061 — Completion Requires Signature: Atomic, No Reopen

- **Decision owner:** Product owner (asked directly — the brief's own
  default was confirmed rather than assumed) for the completion-gating
  question; engineering for the reopen-scope question once it surfaced.
- **Decision:** Signing is the mandatory final step of completion — `POST
  /inspections/{id}/complete` now requires a body (`strokes` +
  `expected_revision`); there is no separate sign-then-complete endpoint
  and no way to complete an inspection unsigned. A completed inspection
  remains fully immutable (`update_inspection`/`assign_checklist_template`
  still 409 on `TERMINAL_STATUSES`, unchanged since 7.1) — no reopen/
  re-edit capability was added for this phase. "Edited after signing"
  (the phase brief's own invalidation-flow language) is realized narrowly
  as the pre-completion offline race: a signature drawn against a
  revision the server has since moved past is rejected via the existing
  `revision_conflict` 409 (checked BEFORE the checklist-completeness
  check, so a stale attempt never reaches that far), forcing a refresh +
  re-sign. `SyncEngine`'s existing conflict machinery
  (`markConflict`/the generic "keep mine"/"use server's" sheet) already
  covers this once fixed to re-sync `status`/`completedAt` from the
  server snapshot on any conflict (a genuine bug this phase's work
  surfaced and fixed: without it, a stale `complete` mutation's
  optimistic local `status: 'completed'` flip would never revert, leaving
  the UI showing a false "completed" state that never landed server-side).
- **Alternatives considered:** A dedicated reopen (`completed` →
  `in_progress`) transition, so a signed-and-completed inspection could
  genuinely be edited and re-signed afterward — explicitly rejected as
  out of this phase's scope: it would be new lifecycle scope beyond
  "capture a signature," with its own unresolved questions (who can
  reopen, whether the 7.7 asset-status rollup gets undone), and no prior
  phase (7.1–7.7) has ever allowed editing a completed inspection.
  Deferred to a future phase if the product ever needs it.
- **Consequences:** A signature, once persisted, can be trusted as
  permanently valid for the inspection it's attached to (no supersede
  state to display) — admin review's "valid at revision N" indicator is
  therefore always "valid" today, though the check itself is real logic,
  not a hardcoded label, so it activates correctly if reopen is ever
  added later. Any future phase that wants to allow editing a completed
  inspection must design the reopen/re-sign flow explicitly rather than
  assuming this phase already built it.

### D-063 — Waiving the D-062 Device-Validation Gate

- **Decision owner:** Product owner, asked directly via `AskUserQuestion`
  once the Step-1 spike and its gate were surfaced at the start of this
  session.
- **Decision:** Proceed directly to Step 2 (the full measurement feature)
  without the human physical-device confirmation D-062 called for. The two
  alternatives offered — writing a test guide and waiting for a real-device
  run, or dropping AR entirely for a manual-only fallback — were both
  declined in favor of building the complete feature now.
- **Consequences:** The data model, offline sync protocol, and admin review
  surface built in Step 2 are the authoritative, permanent shape of Phase
  7.9 — not spike code. Only the AR *capture* code path
  (`ArMeasurementSpikeScreen`'s successor) carries residual risk from an
  unvalidated plugin; the manual-entry fallback is a first-class, equally
  supported way to record a measurement precisely so that risk never blocks
  field use. If `ar_flutter_plugin_2` later proves inadequate on real
  hardware, only that capture screen is replaced (native ARCore/ARKit
  platform channels per D-062's own escape hatch) — the model, sync, and
  review code are unaffected.

### D-062 — AR Plugin Choice for the Phase 7.9 Spike: `ar_flutter_plugin_2`, Provisionally

- **Decision owner:** Engineering, with the human validating the resulting
  spike on a physical device before Step 2 (the full feature) begins — see
  the phase brief's explicit device-validation gate and the D-040 exception
  below.
- **Decision:** For the Step-1 spike, adopted `ar_flutter_plugin_2` (a
  community fork of the original `ar_flutter_plugin`, which has not been
  updated since ~2022) as the one Dart API covering both ARCore (Android)
  and ARKit (iOS). As of this phase (2026-08), no cross-platform Flutter AR
  plugin is genuinely mature: `ar_flutter_plugin` itself is stale,
  `ar_flutter_plugin_engine` is a 2-year-stale unverified fork, and
  `ar_flutter_plugin_2` is version `0.0.3` whose own README states its
  Android layer (migrated from the archived Sceneform to `sceneview_android`)
  was AI-assisted and "may [need] refinement." The genuinely
  actively-maintained alternative, `arkit_plugin`, is iOS-only. This is
  explicitly a **provisional** pick for spike validation, not a locked
  production dependency — the phase brief's own escape hatch (native
  platform channels, Unity, or manual-only) applies if physical-device
  testing shows it's inadequate.
- **Gotcha found during setup:** `ar_flutter_plugin_2`'s own
  `AndroidManifest.xml` declares
  `<uses-feature android:name="android.hardware.camera.ar" android:required="true"/>`.
  Left as-is, the Android manifest merger would carry that into the app,
  which makes the Play Store hide the app entirely on any device without
  ARCore hardware — directly breaking the phase brief's mandatory manual
  fallback. The app manifest now overrides it to `required="false"` via
  `tools:replace="android:required"`, plus a `com.google.ar.core` /
  `optional` meta-data hint for Play Services. `minSdk` is floored at 28
  (the plugin's own requirement) via `maxOf(flutter.minSdkVersion, 28)`
  rather than a hardcoded literal, so it still tracks Flutter's own default
  if that ever rises above 28.
- **Dependency conflict resolved:** `ar_flutter_plugin_2` pins
  `geolocator ^12.0.0`; the app has been on `^13.0.2` since Phase 7.3. Forced
  via `dependency_overrides` rather than downgrading the app's own
  geolocator — the plugin's only geolocator usage (`ARLocationManager`) is
  limited to stable, version-independent calls, verified by a clean `flutter
  pub get` + `flutter analyze`.
- **D-040 exception (device validation is not automatable):** Per D-040, phase
  evidence is normally automated tests + lint/type-check + real-creds backend
  checks only, with no screenshot/manual-visual step. AR plane detection,
  point placement, and real-world measurement accuracy cannot be exercised
  in CI or this sandbox at all — there is no physical ARCore/ARKit device
  here. This phase carries an explicit, narrow exception: the AR-specific
  behavior (and only that behavior) is validated by the human on a physical
  device, per a written test guide, instead of an automated test. Every
  other part of the feature (measurement math, data model, offline sync,
  manual fallback, unsupported-device routing) still follows D-040
  unchanged.
- **Consequences:** Nothing beyond the Step-1 spike is built until the human
  confirms on a real device that plane detection and point placement work
  and produce a roughly-accurate distance. If it doesn't, the next attempt
  moves to native ARCore/ARKit platform channels (option (b)) rather than
  another cross-platform fork, given how thin every fork in this space
  currently is.

### D-064 — AR/Manual Measurement Data Model, Screenshot Evidence, and Mutation Protocol (Phase 7.9 Step 2)

- **Decision owner:** Engineering, following D-063's waiver of physical-device
  validation.
- **Data model:** `ArMeasurement` (`app/models/entities.py`) — `id`, `method`
  (`ar`\|`manual`), `distance_meters` (`gt=0, le=100000`, always meters — same
  fixed-unit rationale as `Readings`/D-058, so the value is unambiguous in
  storage regardless of the unit the device displayed at capture),
  `label`/`note`/`checklist_item_id` (all optional), `media_local_id`
  (optional — the evidence screenshot, an existing `InspectionMedia.local_id`),
  `points: list[AnnotationPoint]` (optional, default empty), `created_by`,
  `created_at`. Replaces the 7.1 `ar_measurements: list[dict[str, Any]]`
  placeholder on `Inspection`/`InspectionDetail`.
- **Points are optional even for `method="ar"`, by design, not oversight:**
  `ar_flutter_plugin_2`'s hit-test callback (`ARHitTestResult`) returns only a
  `worldTransform`/`distance`/`type` — no 2D screen-space coordinate for
  where the user actually tapped. Fabricating normalized overlay points from
  data the plugin doesn't provide would be dishonest data; the screenshot
  itself (evidence that a measurement was taken, in context) is what's
  required for `method="ar"` (422 `ar_measurement_missing_screenshot` if
  `media_local_id` is absent). `points` stays in the schema — reusing D-054's
  `AnnotationPoint` shape — so a future capture path that CAN supply exact
  tap coordinates (a native ARCore/ARKit platform-channel rewrite, or a
  plugin update) fills it in with zero schema change.
- **Mutation protocol mirrors D-054/D-055 exactly:** three new routes,
  `POST/PATCH/DELETE /inspections/{id}/ar-measurements[/{measurement_id}]`,
  idempotent by client-generated `id` (identical resubmit is a no-op 200;
  conflicting resubmit under the same id is `409 ar_measurement_conflict`),
  no `expected_revision` — measurement traffic must never collide with the
  checklist-autosave revision protocol, same rationale as annotations/
  voice-notes/media. `UpdateArMeasurementRequest` only accepts
  `label`/`note`/`checklist_item_id` — the captured method/distance/
  screenshot/points are immutable once created; fixing a wrong value means
  delete-and-recreate, mirroring `UpdateInspectionMediaRequest`'s own
  checklist-link-only update. Repository methods
  (`append_ar_measurement`/`update_ar_measurement`/`remove_ar_measurement`)
  are a field-for-field copy of the annotation repository pattern.
- **The AR screenshot is a plain photo, not a new media kind:** it rides the
  *existing* Phase 7.4 `InspectionMedia`/`MediaQueue`/`MediaUploadWorker`
  pipeline unmodified — no new storage subfolder (unlike D-057's voice notes,
  which needed `voice/` because they're a genuinely separate array), no new
  `MediaKind`, no `MediaQueue` schema change. A measurement references the
  screenshot by `media_local_id` exactly the way an annotation references the
  photo it's drawn on (D-054) — decoupled from whether that upload has
  actually finished, so a measurement can be created offline immediately
  after capture regardless of upload state.
- **Mobile capture mechanics:** `ARSessionManager.snapshot()` (a real,
  documented method on the adopted plugin) returns a `MemoryImage`; its
  public `bytes` field is extracted, written to a temp file via
  `path_provider`, and handed to the *unmodified*
  `LocalMediaRepository.enqueueCapture(kind: 'photo', ...)`. Screenshot
  capture is wrapped in its own try/catch — a failure there (e.g. an
  unimplemented platform channel) must never block recording the distance
  itself; the measurement still saves without a screenshot, with an honest
  in-UI note that capture failed. `ArMeasurementScreen` keeps "Enter manually
  instead" reachable from every state (not gated behind an error), matching
  D-062's "mandatory fallback" framing literally rather than treating manual
  entry as an error-path afterthought.
- **Consequences:** Any future measurement-adjacent capability (e.g. a
  richer AI-assisted measurement in a later phase) that needs real overlay
  points must either extend the capture UI to supply them or build a native
  platform-channel replacement — `points` staying optional here is not a
  promise that AI/analytics can rely on it being populated today.

### D-065 — AI Photo Analysis Data Model, Claude Vision Integration, and Mutation Protocol (Phase 7.10)

- **Decision owner:** Product owner (confirmed scope/backend/trigger via
  `AskUserQuestion` at phase start: build 7.10 now; Claude vision API only,
  no separate CV model; on-demand "Analyze" action, never automatic).
- **Data model:** `AiAnalysis` (`app/models/entities.py`) — `id`,
  `media_local_id`, `model`, `summary`, optional `recommendations`/
  `risk_level` (`low`\|`medium`\|`high`\|`critical`), `annotation_ids`,
  `reviewed`/`reviewed_by`/`reviewed_at`, `created_by`, `created_at`.
  Replaces the 7.1 `ai_analysis: dict[str, Any] | None` placeholder on
  `Inspection`/`InspectionDetail`.
- **Findings reuse D-054's reserved fields exactly as planned, not a
  parallel structure.** Every detected finding is its own
  `Annotation(source="ai", confidence=...)` — the exact reuse Phase 7.5's
  docstring named this phase for two months earlier. `AiAnalysis` is the
  run-level record (what model, what it concluded, whether it's been
  reviewed); it is not a duplicate list of findings.
- **First third-party HTTP/SDK integration in this backend.** Every prior
  outbound call is Firebase (Auth/Firestore/Storage via `firebase-admin`).
  `app/ai/vision_client.py`'s `ClaudeVisionClient` wraps the `anthropic`
  SDK; a forced tool-use call (`tool_choice: {"type": "tool", "name":
  "report_photo_analysis"}`) constrains the model to return structured
  JSON (`summary`, optional `recommendations`/`risk_level`, `findings[]`)
  instead of parsing free-form text. New `Settings.anthropic_api_key`
  (`None` by default — an unset key fails closed with 502
  `ai_analysis_failed`, never a silent no-op) and
  `Settings.ai_vision_model` (default `claude-sonnet-5`).
- **A `VisionAnalysisClient` `Protocol`, not a concrete-class dependency,
  is what `InspectionService` actually depends on** — mirrors
  `InspectionMediaStorage` accepting a `FakeBucket`. Tests inject
  `tests/fakes/ai.py`'s `FakeAiClient`, so every route/service behavior
  (success, no-findings, unknown media, video rejected, upstream failure,
  cross-tenant, never-bumps-revision) is fully covered without a real
  Anthropic API key. The actual live Claude call is unverified this phase
  — no key was available in-session; real-creds verification
  (`apps/api/scripts/verify_ai_analysis_roundtrip.py`, mirroring the 7.9
  precedent) is an open follow-up once one is configured.
- **Points are genuinely attempted here, unlike 7.9's AR capture.**
  D-064's AR measurement forces `points` empty because the plugin has no
  2D tap coordinate at all. Claude vision CAN be asked for real bounding
  boxes, so the tool schema requests them — but nothing requires the
  model to report a finding: a photo with no visible damage returns an
  empty `findings[]` and a plain "no issues" summary, never a fabricated
  region.
- **New `InspectionMediaStorage.download_bytes()`** breaks the class's own
  "bytes never pass through this backend" precedent (Phase 7.4) on
  purpose — a vision API needs the actual image, not a signed URL a
  browser can follow. This is the one and only place in the codebase that
  reads media bytes back into the API process.
- **Two new routes match neither the create/update/delete pattern
  (annotations/measurements) nor the attach/edit/detach pattern (media/
  voice notes), because "analyze" is neither a CRUD create nor a
  reference-registration — it's a computation trigger.**
  `POST /inspections/{id}/media/{media_id}/analyze` addresses media by
  its server id (matching `update_inspection_media`'s own path
  parameter), runs a fresh analysis every call (never idempotent-by-id —
  each invocation is a genuinely new AI computation, not a replay of a
  client-known mutation), and returns the full `InspectionDetail`.
  `POST /inspections/{id}/ai-analysis/{analysis_id}/review` takes no body,
  stamps `reviewed`/`reviewed_by`/`reviewed_at` server-side, and is
  idempotent-on-missing/idempotent-on-replay like every other review-style
  action in this codebase. `InspectionRepository.append_ai_analysis`
  writes the new annotations and the analysis record in **one** atomic
  Firestore update — never two separate writes, so a client can never
  observe one without the other. A real bug was found and fixed while
  testing the no-findings path: `ArrayUnion` rejects an empty list, so a
  photo with zero detected findings (a legitimate, common outcome) must
  conditionally omit the `annotations` field from that update rather than
  always including it.
- **Mobile/admin: `analyzeMedia`/`reviewAiAnalysis` are direct, immediate,
  ONLINE-ONLY calls — the first mutations in `LocalInspectionsRepository`
  that deliberately bypass the offline outbox entirely.** Every other
  mutation in this repository queues through `Outbox`/`SyncEngine` for
  offline-first replay; these two cannot, because there is no honest
  optimistic value to echo before a live AI call actually completes, and
  the action requires real connectivity to a paid third-party API
  regardless of any queueing. `AnnotationCanvasScreen` gained an "Analyze
  with AI" app-bar action (only offered once a photo has synced) and a
  new `InspectionAiAnalysisSection` lists each run with a "Mark reviewed"
  button. Admin gets the same section, read-only — matching every other
  Phase-7 sub-resource's admin surface (capture/trigger stays mobile-only;
  admin reviews).
- **Schema migration gap found and fixed retroactively, not new to this
  phase.** `LocalInspections.schemaVersion` had stayed at `7` even after
  Phase 7.9 added its `arMeasurements` column — no `onUpgrade` branch
  existed for it, meaning an already-installed app would never receive
  that column on update. Bumped to `9` (`8` for the retroactive
  `arMeasurements` fix, `9` for this phase's new `aiAnalysis` column) with
  both `onUpgrade` branches added.
- **Consequences:** Any future AI-assisted capability in this codebase
  (video analysis, a different provider, batch/automatic triggering)
  should extend this same pattern — findings as advisory annotations,
  server-side-only API keys, protocol-typed client for testability — 
  rather than inventing a parallel review mechanism. Video analysis is
  explicitly out of scope for this phase (`ai_analysis_unsupported_media_kind`
  422) since no frame-extraction pipeline exists.

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
- **2026-08-02 — Phase 7.4 (camera capture — photos + videos, GPS/
  timestamp, before/after):** Added D-051 through D-053. Media gets its
  own Drift queue/worker (`MediaQueue`/`MediaUploadWorker`), entirely
  independent of 7.2's `Outbox`/`SyncEngine`, and uploads bytes directly
  from the mobile client to Firebase Storage rather than proxying through
  the backend like 4.3's asset media — a new `storage.rules` carve-out
  scoped by the caller's `company_id` claim, with the backend only ever
  registering a small metadata reference (D-051). Video is capped at 3
  minutes/~1080p (D-052); before/after is an independent per-item tag, not
  a linked pair (D-053). Three real bugs were found and fixed, not
  designed around: (1) `_uploadOne` originally shared one try/catch across
  the Storage upload *and* the follow-up local-DB reference-enqueue step,
  so a failure in the second (a pure local write) incorrectly reverted an
  already-successful upload back to `failed`, forcing a pointless
  re-upload — fixed by splitting the two steps and having `dueForUpload()`
  also reconsider `uploaded` rows for reference-only retry; (2)
  `FirebaseMediaUploader` (the real implementation behind a new
  `MediaUploader`/`MediaUpload` seam, `media_uploader.dart` — introduced
  because `firebase_storage`'s concrete `Reference`/`UploadTask` have
  private constructors too deep in the plugin's wrapper to fake directly)
  originally resolved `FirebaseStorage.instance` eagerly at construction,
  which throws without a real `Firebase.initializeApp()` call — since
  `FevApp` constructs `MediaUploadWorker` (and its default
  `FirebaseMediaUploader`) unconditionally, that broke every widget test
  mounting the app shell, not just media ones, until resolved lazily;
  (3) Drift's `DateTimeColumn`
  round-trips a stored UTC instant back as a local-flagged `DateTime` (same
  instant, wrong flag), which `built_value`'s serializer rejects — hit
  building `AttachInspectionMediaRequest.capturedAt` from a `MediaQueue`
  row, fixed with a `.toUtc()` re-flag at that one call site. Backend (280
  tests, up from 269 — 11 new for media attach/update/detach: idempotency,
  cross-tenant, size/type validation), mobile (180 tests, up from 154 —
  new coverage across `local_media_repository_test.dart`,
  `media_upload_worker_test.dart`, `media_capture_screen_test.dart`, new
  media-mutation cases in `sync_engine_test.dart`, and new media-gallery
  cases in `inspection_detail_screen_test.dart`), and admin (196 passed +
  6 credential-only skips, up from 193 — 3 new for the read-only media
  gallery: empty state, a synced item's tag/GPS/checklist link, a video
  item) all green; `flutter analyze`/ruff/mypy/ESLint clean; contracts
  regenerated (3 new models, 3 new operations) with a clean drift check.
- **2026-08-05 — Phase 7.5 (damage annotation — draw on inspection
  photos):** Added D-054 and D-055. `Inspection.annotations[]` (the
  7.1-era untyped placeholder) is now a real `Annotation` model: one
  normalized (0-1) `points[]` field covers all five shapes so Phase
  7.10's AI-detected regions can render on the exact same overlay model
  later (D-054). The three new annotation routes copy D-051's media
  precedent — idempotent by client-generated `id`, no `expected_revision`
  — rather than the checklist-autosave revision protocol (D-055); mobile
  annotations ride the existing 7.2 outbox (three new
  `OutboxMutationType` values) but, unlike media, write to the local
  cache optimistically since there's no secondary upload queue standing
  between "drawn" and "visible offline." One real test-fixture gotcha
  surfaced while building `sync_engine_test.dart`'s coverage (not a
  production bug): a fake API stub that echoes back an empty
  `annotations: []` on a mutation response silently wipes the local
  optimistic write on the very next `applyMutationSuccess`, since that
  method overwrites the entire local row from whatever the server
  returned — fixed by making the fakes echo a realistic response, the
  same way the real backend already does. One real mobile robustness
  gap the new widget test caught and fixed in production code: the
  annotation canvas's `Image` had no `errorBuilder`, so a broken/expired
  signed photo URL crashed as an uncaught `NetworkImageLoadException`
  instead of degrading gracefully like the gallery's own
  `_networkImage`. Backend (291 tests, up from 280 — 11 new for
  create/update/delete annotation: idempotency, cross-tenant,
  media-not-found, revision-isolation from checklist autosave), mobile
  (193 tests, up from 180 — new `annotations`/`annotation sync` groups
  in `local_inspections_repository_test.dart`/`sync_engine_test.dart`,
  new overlay/canvas-navigation cases in
  `inspection_detail_screen_test.dart`), and admin (200 passed + 6
  credential-only skips, up from 196 — 4 new for the read-only SVG
  overlay: absent/present toggle, correct shape+tooltip, per-photo
  scoping) all green; `flutter analyze`/ruff/mypy/ESLint clean; `next
  build` + bundle-budget clean; contracts regenerated (5 new models, 3
  new operations) with a clean drift check; real-creds round-trip
  verified end to end against the live Firebase project.
- **2026-08-06 — Phase 7.6 (voice notes — record + attach to
  inspection):** Added D-056 and D-057. Recording caps at 10 minutes of
  AAC/M4A with a pulsing level meter, not a scrolling waveform (D-056,
  resolved with the product owner after the phase brief flagged both as
  genuine ambiguities). Voice notes reuse the 7.4 `MediaQueue`/
  `MediaUploadWorker` end to end — a new `kind: 'audio'` value plus a
  `durationMs` column, no new queue or worker class — under their own
  Storage namespace (`voice/`, via a new `voice_object_path()`/
  `inspectionVoiceNoteStoragePath()` pair) and their own outbox mutation
  types (`attach_voice_note`/`edit_voice_note`/`detach_voice_note`),
  mirroring D-051/D-055's media/annotation mutation-protocol precedent
  (D-057). `Inspection.voice_notes[]` (the 7.1-era untyped placeholder) is
  now a real `VoiceNote` model. One real bug this phase's own tests caught
  before merge (not a production incident, since it never shipped): the
  7.4 photo/video gallery read the shared `MediaQueue` stream without
  filtering out `kind == 'audio'`, so a queued voice recording would have
  rendered as a broken tile in the wrong grid — fixed by filtering both
  sections to their own kind. Backend (303 tests, up from 291 — 12 new for
  attach/update/detach voice note: content-type/size/duration validation,
  idempotency, cross-tenant, revision-isolation from checklist autosave),
  mobile (214 tests, up from 193 — a new `voice_recording_screen_test.dart`
  plus new audio cases across `local_media_repository_test.dart`/
  `media_upload_worker_test.dart`/`sync_engine_test.dart`/
  `inspection_detail_screen_test.dart`), and admin (202 passed + 6
  credential-only skips, up from 200 — 2 new for the read-only voice-notes
  section: empty state, playback/duration/checklist-link rendering) all
  green; `flutter analyze`/ruff/mypy/ESLint clean; `next build` clean;
  contracts regenerated (3 new models, 3 new operations) with a clean
  drift check; real-creds round-trip verified end to end against the live
  Firebase project, including an actual HTTP fetch of the signed URL
  confirming it serves back the exact uploaded bytes.
- **2026-08-06 — Phase 7.7 (manual status readings, resolves the deferred
  §9 manual-status log):** Added D-058 and D-059. Fixed documented units
  (Celsius/bar/decibels, unit-suffixed field names, no per-reading unit
  picker) and `operational_status`'s `running`\|`stopped`\|`degraded`
  values were confirmed with the product owner up front rather than
  assumed, per the phase brief's own explicit flag. `Inspection.readings`
  (typed since 7.1's untyped `dict` placeholder) is a single nullable
  object, deliberately riding the *existing* checklist-autosave revision
  path (`update_inspection`, a new `readings` field on
  `UpdateInspectionRequest`) rather than the D-051/D-055/D-057
  append-idempotent-by-id/no-revision pattern those three all share — the
  first inspection sub-resource this phase set didn't need that pattern,
  since it's one form with one editor rather than an array of independent
  records. On `complete_inspection` only, the condition rolls up onto the
  asset's 4.1 `current_status` through a new
  `AssetRepository.roll_up_status_from_inspection` (own
  `asset.status_rolled_up` audit action), which the existing 4.4 dashboard
  `count()` aggregation reflects with zero caching — verified end to end
  against the real Firebase project (a Critical inspection moved the
  Critical-Assets count by exactly 1, then a Healthy-mapped inspection
  restored both the asset's status and the count). Backend (317 tests, up
  from 303 — 14 new: server-stamped `recorded_at`/`recorded_by`, condition
  required, whole-object replace, locked-once-completed, survives an
  unrelated PATCH, all 5 condition→status mappings parametrized, no
  rollup without readings, draft edits don't roll up, the rollup is
  audited, and the dashboard KPI cross-check), mobile (221 tests, up from
  214 — a new `readings (Phase 7.7)` group in
  `local_inspections_repository_test.dart` covering the local-cache/outbox
  contract including an app-restart persistence case, a matching group in
  `sync_engine_test.dart` proving the fake-echo-full-state trap D-051's
  gotcha already warned about also applies here, and a new interactive
  widget test alongside an extended read-only-rendering assertion in
  `inspection_detail_screen_test.dart`), and admin (205 passed + 6
  credential-only skips, up from 202 — 3 new for the read-only readings
  section: empty state, full populated render with units/priority/leak
  badge, and priority/leak badges correctly omitted when unset) all green;
  `flutter analyze`/ruff/mypy/ESLint clean; `next build` clean; contracts
  regenerated (2 new models, `InspectionDetail`/`UpdateInspectionRequest`
  updated) with a clean drift check.
- **2026-08-06 — Phase 7.8:** Added and locked D-060 and D-061. Signing is
  now the mandatory final step of `complete_inspection` — signer identity
  is always server-derived, and the persisted signature is bound to
  exactly the revision the inspection completed at. A completed
  inspection stays fully immutable; the "edited after signing" case from
  the phase brief is realized narrowly as the pre-completion offline
  revision-conflict race, reusing the existing `revision_conflict` 409
  and `SyncEngine` conflict machinery rather than adding a reopen
  capability. A real generator-compatibility bug was found and fixed
  mid-phase: `Signature.strokes`/`CompleteInspectionRequest.strokes`
  switched from a raw `list[list[AnnotationPoint]]` to a named
  `SignatureStroke{points: [...]}` wrapper after the doubly-nested list
  shape threw a missing-builder-factory `StateError` at Dart runtime — see
  D-060 for the detail and the general lesson for future schema design.
  Backend (328 tests, 8 new — server-derived signer identity ignoring a
  spoofed client value, revision-binding, the revision check running
  before the checklist-completeness check, and no way to complete
  unsigned), mobile (224 tests, up from 221 — 3 new covering offline
  sign→sync/restart-persistence and the signature-pad Clear/dismiss
  interaction, plus extended assertions on existing completion and
  read-only-render tests), and admin (214 tests, up from 211 — 3 new for
  the read-only signature section: unsigned empty state, full signed
  render, and the superseded-once-revision-moves indicator) all green;
  `flutter analyze`/ruff/mypy/ESLint clean; contracts regenerated (6 new
  models) with a clean drift check. Real-creds proof
  (`verify_signature_completion.py`) against the live Firebase project:
  signed a real inspection and confirmed the persisted signer name/role
  matched the real seeded account exactly (ignoring a deliberately
  spoofed signer in the same request), then reproduced the stale-revision
  race end to end and confirmed both the 409 rejection and a subsequent
  successful re-sign.

- **2026-08-10 — Phase 7.9 (AR/manual dimension measurement):** Opened on
  `phase/7.9-ar-measurement` with a Step-1 `ar_flutter_plugin_2` spike
  already uncommitted from a prior session (D-062). Per D-062's own gate,
  Step 2 (the full feature) was blocked on a human confirming AR plane
  detection/measurement on a physical device first; asked the product
  owner directly, who chose to waive that gate and proceed straight to the
  full feature (D-063) rather than write a device test guide or drop AR
  for manual-only. Added and locked D-064: `ArMeasurement` data model
  (method/distance/label/note/optional screenshot reference/optional
  overlay points), mutation protocol mirroring D-054/D-055's annotations
  exactly (idempotent create/update/delete, no `expected_revision`), and
  the AR screenshot riding the *existing* Phase 7.4 media pipeline
  unmodified rather than a new storage namespace. A genuine design
  correction made mid-phase, not a late-discovered bug: `points` was
  initially specced as required (exactly two) for `method="ar"`, then
  relaxed to fully optional once it became clear `ar_flutter_plugin_2`'s
  hit-test callback carries no 2D screen-tap coordinate to populate them
  honestly — the screenshot alone is the AR method's evidence requirement.
  Backend (338 tests, up from ~325 before this phase — new coverage for
  create/update/delete, manual vs. AR method validation, the missing-
  screenshot 422, unknown-media 404, idempotent replay, conflicting-replay
  409, cross-tenant 404, and the never-bumps-revision guarantee), mobile
  (236 tests, up from 224 — repository CRUD + restart-persistence,
  `SyncEngine` dispatch for all three mutation types, and detail-screen
  empty-state/rendered/completed-hides-actions widget tests), and admin
  (211 tests passing plus the pre-existing, unrelated
  `company-settings-page.test.tsx` full-suite teardown flake noted in
  [[fev-admin-vitest-full-suite-flake]] — 4 new tests for the read-only
  measurements section: empty state, manual measurement render, and the
  under-1-meter cm formatting threshold) all green; `flutter analyze`/
  ruff/mypy/ESLint/`next lint` clean; contracts regenerated (`ArMeasurement`
  request/response models across both generated clients) with a clean
  operation-id drift check. Per D-062's own D-040 exception, real
  ARCore/ARKit plane-detection/measurement accuracy remains unverified on
  physical hardware — explicitly accepted risk per D-063, confined to the
  AR *capture* screen only.

- **2026-08-10 — Phase 7.10 (AI photo analysis):** Continued in the same
  session as 7.9 once the user confirmed scope directly (`AskUserQuestion`:
  build 7.10 now; Claude vision API only, no separate CV model; on-demand
  "Analyze" action, never automatic on upload). Added and locked D-065:
  `AiAnalysis` run records plus `Annotation(source="ai", confidence)`
  findings — exactly the reuse Phase 7.5's own docstring named this phase
  for. First third-party HTTP/SDK call in this backend
  (`app/ai/vision_client.py`'s `ClaudeVisionClient`, forced tool-use for
  structured output) behind a `VisionAnalysisClient` protocol so tests
  never need a real API key. Two real bugs found and fixed mid-phase, not
  late-discovered: `ArrayUnion` rejects an empty list, so a photo with zero
  AI findings needed the `annotations` field made conditional in
  `append_ai_analysis`; and a genuine pre-existing gap from Phase 7.9 was
  caught while adding this phase's own Drift column — `arMeasurements` had
  been added without ever bumping `schemaVersion`/adding its `onUpgrade`
  branch, silently meaning an already-installed app would never receive
  it; fixed retroactively (v7→v9 in one migration). `analyzeMedia`/
  `reviewAiAnalysis` are this repository's first mutations that
  deliberately bypass the offline outbox — direct, online-only calls, no
  optimistic echo for an AI response that doesn't exist yet. Backend (347
  tests, up from 338 before this phase — 12 new: success with/without
  findings, unsupported media kind rejected, unknown media 404, upstream
  failure 502, cross-tenant 404, review marks/idempotent-on-missing, never
  bumps revision, survives an unrelated checklist PATCH), mobile (246
  tests, up from 236 — 3 repository tests for the direct online-only calls
  plus 4 widget tests for the new `InspectionAiAnalysisSection`'s empty/
  rendered/reviewed states), and admin (214 tests all green, no flake this
  run — 4 new for the read-only AI analysis section) all green; `flutter
  analyze`/ruff/mypy/ESLint/`next lint` clean; `next build` compiled all 29
  routes with the bundle budget unchanged (342.8 KB); contracts
  regenerated for `AiAnalysisResponse` and the two new operations with a
  clean drift check. The real Claude API call is unverified this phase —
  no `ANTHROPIC_API_KEY` was available in-session (user chose to proceed
  without one rather than block on adding it); all logic is fully covered
  against a `FakeAiClient`, and a real-creds proof is an open follow-up.
  Phase 7 (data model, offline sync, capture, checklist, readings,
  signature, AR, AI analysis, admin review) is now **COMPLETE** per its
  own Phase 7 row description in `PHASE_TRACKER.md`.
