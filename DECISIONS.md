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
