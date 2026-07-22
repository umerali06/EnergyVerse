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
