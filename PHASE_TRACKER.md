# FEV Phase Tracker

## Status Definitions

- **Not started:** implementation has not begun.
- **In progress:** the current micro-task is actively being built or documented.
- **Testing:** implementation is complete and its focused verification is underway.
- **Done:** the focused result has been shown, accepted as tested, and its architecture connection has been recorded.

Only one micro-task may be active at a time.

| Phase | Scope | Status |
|---|---|---|
| 0 | Foundation and project definition | **COMPLETE** |
| 0.1 | Project bootstrap and persistent context setup | Done |
| 0.2 | Monorepo scaffold — apps/api (FastAPI), apps/admin (Next.js), apps/mobile (Flutter), packages/contracts placeholder, infra/ci (GitHub Actions), infra/firebase placeholder, root config | Done |
| 0.3 | FastAPI ↔ Firebase Admin SDK, Firestore-aware `/health`, and client connectivity indicators | Done |
| 0.4 | Firestore data foundation — tenancy, companies, users, roles, permissions, role mappings, and audit logs | Done |
| 0.5 | Backend auth foundation — Firebase token verification, typed current user, claims, provisioning/link services, auth-user seed migration, and protected `/api/v1/auth/me` | Done |
| 0.6 | RBAC enforcement — permission/role dependencies, demo route gates, denial audits, and admin/mobile guard helpers | Done |
| 0.7 | Shared design system — framework-neutral tokens, dark/light theming, reusable admin/mobile primitives, and reduced-motion-aware animation | Done |
| 0.8 | API contract, generated TypeScript/Dart clients, unified errors/request IDs, typed client wrappers, and toast infrastructure | Done |
| 1 | User-facing authentication and application flows | **COMPLETE** |
| 1.1 | Login screen | Done |
| 1.2 | Signup and email verification | Done |
| 1.3 | Forgot password and password reset | Done |
| 1.4 | Session, token refresh, and route guards | Done |
| 2 | Application shell and dashboard foundation | **COMPLETE** |
| 2.1 | App shell — persistent navigation frame on both clients | Done |
| 2.1b | Design language elevation — industrial art-direction pass | Done |
| 2.1c | Brand identity, SEO/metadata, dynamic theming enforcement, motion policy | Done |
| 2.2 | Dashboard content — real-data dashboard + chart infrastructure | Done |
| 2.3 | Pluggable KPI widget framework | Done |
| 3 | Administration — user, role/permission, company settings, audit, and Super-Admin cross-tenant management | **COMPLETE** |
| 3.1 | Company-scoped user management (Admin Portal) — invite, edit, deactivate/activate | Done |
| 3.2 | Role and permission editing | Done |
| 3.3 | Company settings | Done |
| 3.4 | Audit viewer | Done |
| 3.5 | Super-Admin cross-tenant management | Done |
| 4 | Asset management — data model/hierarchy, UI, create/edit/photo, KPI widgets, QR | **COMPLETE** |
| 4.1 | Asset data model, facility/area hierarchy, and backend CRUD | Done |
| 4.2 | Asset management UI | Done |
| 4.3 | Asset create/edit and media upload | Done |
| 4.4 | Asset KPI widgets (built on the 2.3 pluggable framework) | Done |
| 4.5 | QR code asset scanning | Done |
| 5 | Safety Reports — incident data, evidence, corrective actions, assignment, review, closure, and dashboard metrics (source brief §§4.1, 10) | **COMPLETE** |
| 5.1 | Safety-report data model and backend CRUD/lifecycle — tenant isolation, RBAC, audit trail, pagination/filtering, and generated contracts | Done |
| 5.2 | Safety-report evidence and corrective-action workflow | Done |
| 5.3 | Safety-report mobile + admin UI | Done |
| 5.3a | Admin HSE safety-report list, create, detail, evidence, corrective actions, and lifecycle controls | Done |
| 5.3b | Offline-capable mobile safety reporting, evidence capture, assigned actions, and conflict handling | Done |
| 5.3b.1 | Mobile safety API boundary, schema-v11 durable cache/outbox, offline create repository, retry/backoff sync engine, and tenant-user cache isolation | Done |
| 5.3b.2 | Mobile safety list/detail/report screens and navigation | Done |
| 5.3b.3 | Durable evidence capture/upload queue, assigned corrective-action controls, and conflict UX | Done |
| 5.4 | Safety dashboard integration — real incident total and incidents-by-type chart, tenant/RBAC isolation, typed clients, and full regression verification | Done |
| 6 | Permit-to-Work — risk assessment, checklist, worker assignment, approvals, signatures, activation, and closure (source brief §11) | **COMPLETE** |
| 6.1 | Permit policy and domain contract — confirm risk matrix, checklist ownership, worker acknowledgement, approval/signature chain, validity, and exceptional lifecycle rules before schema work | Done |
| 6.2 | Permit backend foundation — tenant-scoped model, CRUD, risk assessment, checklist snapshot, worker assignment, RBAC, audit, filtering/pagination, and generated contracts | Done |
| 6.2a | Versioned tenant permit templates — permit-type checklist items, ordered approval-step configuration, CRUD, RBAC/audit, and generated contracts | Done |
| 6.2b | Permit record foundation — draft CRUD, 5×5 risk assessment, template snapshot, worker assignment, tenant isolation, filtering/pagination, and generated contracts | Done |
| 6.3 | Permit authorization lifecycle — approvals, digital signatures, activation, expiry/suspension/revocation/closure rules, and concurrency handling | Done |
| 6.3a | Controlled submission and sequential approval/rejection — checklist confirmation, issuer attestation, residual-risk gate, role-matched approval signatures, RBAC/audit, and revision conflicts | Done |
| 6.3b | Worker acknowledgement/signature and activation — idempotent offline-capable acknowledgement contract, all-worker gate, online activation, and validity enforcement | Done |
| 6.3c | Automatic expiry plus suspend/revoke/close lifecycle controls and complete concurrency regression | Done |
| 6.4 | Permit admin + offline-capable mobile workflow — issuer/approver control center and field worker acknowledgement/signature flow | Done |
| 6.4a | Admin permit-template management — real CRUD, ordered checklist/approval builder, tenant roles, RBAC/error states, responsive polished UI, and focused tests | Done |
| 6.4b | Admin permit control center — list/create/detail, risk and checklist preparation, approvals, activation, and exceptional lifecycle actions | Done |
| 6.4b.1 | Admin permit register and draft creation — filters/pagination plus real facility/template/worker selection, validity, 5×5 risk inputs, RBAC/error states, and tests | Done |
| 6.4b.2 | Admin permit detail and lifecycle controls — checklist submission, ordered approvals, signatures/activation status, suspend/resume/revoke/close, conflicts, and tests | Done |
| 6.4c | Mobile offline permit workflow — durable local records/outbox, assigned-worker acknowledgement/signature, replay/rebase conflict UX, and sync tests | Done |
| 6.4c.1 | Mobile permit persistence and synchronization — tenant-session cache, dedicated FIFO acknowledgement outbox, idempotent replay, retry/backoff, explicit conflict rebase/discard, and focused tests | Done |
| 6.4c.2 | Mobile assigned-permit experience — cached list/detail, signature attestation, pending/error/conflict states, manual sync/rebase UX, navigation/RBAC, and tests | Done |
| 6.5 | Active Permits dashboard KPI and focused end-to-end/full-regression verification | Done |
| 7 | Inspections — flagship field-inspection module (data model, offline sync, capture, checklist, readings, signature, AR, AI analysis, admin review) | **COMPLETE** |
| 7.1 | Inspection data model, checklist templates, and backend CRUD/lifecycle | Done |
| 7.2 | Offline engine — local store, sync queue, and conflict resolution | Done |
| 7.3 | Inspection start flow — checklist-template auto-selection, GPS capture, interactive offline-first checklist filling with continuous autosave, and completion gating | Done |
| 7.4 | Camera capture — photos and videos with GPS/timestamp tagging, before/after comparison, a separate offline media-upload queue/worker, and admin media review | Done |
| 7.5 | Damage annotation — draw/label shapes on inspection photos, offline-first via the record outbox, admin review overlay | Done |
| 7.6 | Voice notes — record + attach to inspection, offline-capable, reusing the 7.4 media upload queue/worker | Done |
| 7.7 | Manual status readings — condition/temperature/pressure/noise/vibration/leak/operational-status/comments/recommendations/priority logged on the inspection record; on completion, rolls up onto the asset's 3-state health, driving the 4.4 dashboard KPI (resolves the §9 deferral from Phase 4.1) | Done |
| 7.8 | Digital signature — inspector sign-off drawn on-device at inspection completion, offline-capable, server-derived signer identity, revision-bound with pre-completion revision-conflict rejection (re-sign), and admin review display | Done |
| 7.9 | AR/manual dimension measurement — AR plane-tap distance capture with screenshot evidence (`ar_flutter_plugin_2`, unvalidated on physical hardware per D-063), manual numeric-entry fallback, offline-first via the record outbox, admin review display | Done |
| 7.10 | AI photo analysis — on-demand Claude vision analysis of inspection photos surfaces advisory `Annotation(source="ai", confidence)` findings the inspector must confirm or override, plus an analysis-level summary/recommendations/risk-level record with an explicit reviewed flag; real Claude API call unverified pending a live `ANTHROPIC_API_KEY` (CI-safe logic fully tested against a fake vision client) | Done |
| 8 | Work orders — maintenance work order lifecycle raised against an asset (spec §12), assignment, technician self-accept/self-submit, and supervisor review/close | **COMPLETE** |
| 8.1 | Work order data model and backend CRUD/lifecycle — `open → assigned → in_progress → pending_review → closed`, plus terminal `cancelled`; closing gated by a dedicated `work_orders.close` permission distinct from `work_orders.write` so the assigned technician cannot self-close (D-066) | Done |
| 8.2 | Work order mobile + admin UI — offline-first technician flow (My Work Orders, Accept Task, Submit for Review via a dedicated `WorkOrderOutbox`/`WorkOrderSyncEngine`) and the admin supervisor flow (create, assign, review, close, cancel) | Done |
| 9 | AI report generation — tenant-scoped report snapshots, advisory AI narrative, human finalization, private PDF/Word/Excel exports, client workflow, and dashboard metric (source brief §13) | **COMPLETE** |
| 9.1 | Report policy and domain contract — source types, snapshot/finalization semantics, AI-review boundary, export privacy, authorization, and implementation decomposition | Done |
| 9.2 | Report backend foundation — tenant-scoped model, source snapshot assembly, advisory narrative generation, draft CRUD/finalization, RBAC/audit, pagination, and generated contracts | Done |
| 9.3 | Private export rendering and storage — PDF, Word, and Excel artifacts generated from immutable finalized snapshots with fresh signed downloads | Done |
| 9.4 | Admin + mobile report workflow — create/review/edit/finalize, report library, and private export downloads | Done |
| 9.4a | Admin report library and private finalized-export downloads | Done |
| 9.4b | Admin report create/review/edit/regenerate/finalize workflow | Done |
| 9.4b.1 | Admin source-aware advisory report creation | Done |
| 9.4b.2 | Admin report detail, human edit/regeneration, attested finalization, and draft deletion | Done |
| 9.4c | Mobile report library, review/finalization, and private downloads | Done |
| 9.4c.1 | Mobile tenant report library, filters/pagination, and finalized private downloads | Done |
| 9.4c.2 | Mobile source-aware creation and report review/finalization workflow | Done |
| 9.5 | Reports Generated dashboard KPI and Phase 9 regression verification | Done |
| 10 | Static Digital Twin / 3D Facility View (source brief §14) | **COMPLETE** |
| 10.1 | 3D Scene & Hotspot Data Contract and Backend Foundation | Done |
| 10.2 | Admin Portal Three.js Web 3D Viewport & Facility Page | Done |
| 10.3 | Mobile Client 3D Digital Twin Experience & Route | Done |
| 10.4 | Dashboard Integration & Full System Regression | Done |
| 11 | Document Management System — SOPs, technical manuals, safety policies, drawings, compliance certificates, mobile/admin UI, and seed data | **COMPLETE** |
| 12 | Public marketing site — a real front door on the app domain instead of a login wall, so self-service signup is discoverable and the existing SEO metadata has something to index | **In progress** |
| 12.1 | Marketing route group (`/`, `/pricing`, `/about`) with a public auth-aware header/footer; the signed-in dashboard relocated from `/` to `/dashboard`; robots/sitemap/manifest realigned around a public landing page (D-087) | Done |
| 12.2 | Marketing visual pass — brand-orange CTAs with sheen/lift micro-interactions, scroll-reveal sections, header reading-progress bar, ambient hero treatment, and `color-mix` token utilities replacing Tailwind opacity modifiers that never compiled against CSS-variable tokens (D-088) | Done |
| 12.3 | Marketing navigation fix and header layout — scroll-reveal observer rescoped to rerun per route (the `(marketing)` layout persists across in-group navigation, so `/pricing` and `/about` rendered blank at `opacity: 0`), plus centred site nav and an icon-only theme toggle | Done |
| 12.4 | Landing page rebuilt around the product rather than a template — animated hero depiction of an offline inspection syncing to the supervisor panel, the asset record chain from failed check to attested report, a bento module grid, and the published role/permission matrix (D-089) | Done |
| 13 | Subscriptions & plan-gated access — Stripe billing, two-step signup, and entitlement enforcement so a tenant only ever sees what it has paid for | **In progress** |
| 13.1 | Plan catalog, subscription state, and entitlement enforcement — the four published tiers with their real prices/quotas/features, `require_feature` as a 402 gate stacked beside `require_permission`, and quota guards (D-090) | Done |
| 13.2 | Published pricing corrected to the requirements document — real tiers, seat/usage add-ons, and services replacing the placeholder commercials; trial CTAs now carry the chosen plan into signup | Done |
| 13.3 | Stripe gateway, Price sync, Checkout session, and webhook reconciliation — lookup-key addressing, live-read reconciliation, signature-gated webhook (D-091) | Done |
| 13.4 | Two-step signup — details form, then a catalog-driven plan picker and Stripe checkout; the billing step is reachable before email verification and the completion page polls until the webhook lands (D-092) | Done |
| 13.5 | Plan-aware admin shell and dashboard — nav filtered by plan as well as permission, subscription context as the single client-side source, and a real plan card with billing status, trial countdown and usage against each quota (D-093) | Done |
| 13.6 | Plan-aware mobile app — `SubscriptionController`/`SessionSubscriptionScope` mirroring the portal's provider, bottom-bar and More-sheet destinations filtered by plan as well as permission, and `getSubscription` on the mobile API contract (D-093) | Done |
| 13.7 | Entitlement gate actually applied — `require_feature` on every module router, seeded companies given real plans, and a shared test default so the gate is enforced rather than merely defined (D-094) | Done |
| 13.8 | Fix browser signup: strip the generator's `additionalProperties` spread so strict request models stop sending camelCase duplicates and `POST /auth/register` no longer 422s (D-095) | Done |
| 13.9 | Plan-aware dashboard widgets, sidebar plan/usage footer, and a subscription management page with live usage; shared icon theme toggle and a styled main scrollbar (D-096) | Done |
| 13.10 | Fix documents never loading (`listDocuments` absent from the API client), correct the documents page's component props, move the sidebar collapse to an edge handle, and add a branded `PageLoader` (D-096) | Done |
| 13.11 | Branded `PageLoader` applied to every whole-screen wait in the admin, and the loader's invisible progress track fixed | Done |
| 13.12 | Stop the sidebar nav growing as the plan resolves (skeleton until known), and port the admin `LogoLoader` to match the Flutter loader layer for layer | Done |
| 12.5 | Header action cluster restyled to the owner's reference — pill-shaped primary, bare text secondary, borderless icon theme toggle, and an opt-out arrow so the header stays compact while body CTAs keep theirs | Done |
| 13 | To be defined | Not started |
| 14 | To be defined | Not started |
| 15 | To be defined | Not started |
| 16 | To be defined | Not started |
| 17 | To be defined | Not started |
| 18 | To be defined | Not started |
| 19 | To be defined | Not started |
| 20 | To be defined | Not started |

Detailed scopes after Phase 1.2 have not been fully supplied and must not be invented.

Audit note (updated 2026-08-22): repository structure, the source brief,
completion records, and current branch were reconciled. Every defined slice
through Phase 10 is complete. Phase 10 (Static Digital Twin / 3D Facility View) is COMPLETE across
all 4 subphases: Data Contract & Backend (10.1), Admin Three.js Viewport (10.2), Mobile 3D Experience (10.3),
and Dashboard Integration & Full Regression (10.4).

Maintenance note (2026-08-26): fixed the mobile Assets directory returning an
empty page while its dashboard KPI reported real assets. The backend now treats
blank nullable asset-list query parameters emitted by the generated Dart/Dio
client as unset. The shared mobile API transport now also removes generated
empty optional query values before dispatch, fixing the asset-detail Inspections
tab's `from_date=`/`to_date=` HTTP 422. Focused asset API regression: 29 passed;
focused mobile API and inspection-detail regression: 29 passed.
Asset detail navigation now persists the asset ID in the query string, survives
browser refresh/direct loading, and renders the branded not-found state instead
of throwing when an ID is absent. Focused Assets screen regression: 9 passed.
Flutter web now self-hosts its Firebase App/Auth/Storage ESM modules instead of
requiring `gstatic.com` during startup. All three localhost assets returned HTTP
200 and the debug web build completed successfully. The vendored modules were
then aligned exactly to FlutterFire's supported SDK version 12.15.0; their local
module graph loaded successfully and reported App 12.15.0 plus functional Auth
and Storage exports.
The asset-detail Work Orders HTTP 500 was fixed by adding the four missing
tenant/filter/order composite indexes and a bounded locally sorted repository
fallback while indexes build. Focused Work Order API: 30 passed; Assets/detail
widget regression: 10 passed.
Asset Media now separates real camera capture from Gallery selection: Camera
opens the `camera` plugin preview and uploads only after the shutter is pressed,
while Gallery retains file selection. Focused camera plus Assets/detail tests:
17 passed; Flutter analysis clean.
Camera initialization failures no longer leave a permanent spinner: browser
permission denial, missing/busy cameras, and unsupported constraints render
actionable messages plus in-place retry. Focused camera tests: 8 passed.

Client feedback round (2026-09-10): the six defects raised in the video
assessment were fixed (safety failure-vs-empty state, Untitled inspections,
inspector identifiers, 3D panel losing the selected asset, stale tier-management
copy, dashboard/3D readability), and the admin production build was repaired --
`next build` had been failing outright on 17 lint errors with 62 TypeScript
errors behind them. The 3D digital twin was found to be rendering three
hard-coded sample assets to every tenant, because the page fetched its scene
through an unauthenticated relative URL that could never succeed; it now uses
the authenticated client and reports failure instead of inventing data.

Then the remaining unbuilt scope from that assessment: AI video analysis
(D-096), notifications across in-app/email/push (D-097), and VR training as
WebXR over the existing 3D scene (D-098). `scripts.backfill_inspection_titles`
names inspections created before titles were derived.

The Claude vision path was then verified against the live Anthropic API for the
first time (`scripts.verify_ai_vision_live`), closing the Phase 7.10 open item.
Both the photo and video paths returned well-formed findings, and the video run
confirmed D-096's premise empirically: a defect recurring across four sampled
frames was reported once, not four times.

Still open and explicitly not delivered: AR measurement remains unvalidated on
physical hardware (D-063). That needs a device with ARCore/ARKit, not code.

Second client-feedback pass (2026-09-11): the remaining items from the
assessment that were incomplete rather than unbuilt.

Global search declared eight categories but only ever fetched five —
inspections, safety reports and generated reports returned nothing — and its
hits dropped the record they found, opening bare list pages exactly as the 3D
panel's buttons did. All eight now search, QR codes resolve to the asset they
label, and every hit opens its record (D-100).

Asset condition now carries the requirements' own Excellent/Good/Fair/Poor/
Critical vocabulary onto the asset itself; it was recorded on every inspection
since Phase 7.7 but collapsed to the three-state rollup and discarded, which is
why the screens showed different words from the document (D-099).

Permits are seeded for the first time — two templates and three permits across
active, pending-approval and draft — so the register no longer renders empty on
a fresh tenant (D-101).

Email delivery was verified end to end through real AWS SES
(`scripts.verify_notification_email_live`); SES accepted a branded notification
to the account's own verified sender.

Repository consolidation and secret remediation (2026-09-11): all work merged
to `main` and pushed to both remotes (umerali06/EnergyVerse and
Flacron-Enterprises-llc/Flacron-Energy-Verse). PR #40 (Phase 8.2) merged;
the `backup/pre-4.5-wip-20260729` PR was closed rather than merged, and its one
unmerged feature — the branded SES verification email — ported onto main as
`POST /api/v1/auth/verification-email`. The Firebase web API key was removed
from source after GitHub secret scanning flagged it (D-102); it still needs
rotating or restricting in the Google Cloud console.
