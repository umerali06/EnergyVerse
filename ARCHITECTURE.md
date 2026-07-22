# FEV Architecture

## Status

Phase 0 is complete and Phase 1 user-facing authentication is underway. FastAPI
publishes a committed OpenAPI contract, pinned generators produce typed TypeScript
and Dart clients, and both applications consume those clients through shared
token/error/feedback wrappers. Detailed feature architecture remains intentionally
incremental and is recorded after each tested micro-task. Locked platform decisions
are tracked in `DECISIONS.md`.

## Architecture Goals

- Strict multi-tenant isolation using `company_id`
- Permission-based RBAC enforced server-side and reflected in the UI
- Offline-first field workflows with durable local queues, background synchronization, and defined conflict resolution
- Safety-critical auditability and human confirmation of AI findings
- Modular boundaries that permit future IoT, telemetry, ERP, SCADA, and live digital-twin integrations without redesign
- Scalable cloud deployment and maintainable, reusable components

## System Context

The blocking backend, database, and authentication decisions are confirmed. System context continues to be defined slice by slice.

### Client Applications

- Flutter field/mobile and web application
- React / Next.js admin dashboard
- Three.js static 3D experience
- Unity for VR and AR cases that require it

### Backend and APIs

- Framework: FastAPI on Python 3.11+
- API style and versioning: FastAPI OpenAPI 3.1 with explicit operation IDs, direct
  typed resource responses, and `/api/v1` for versioned application routes
- Current infrastructure boundaries: `app/core/firebase.py` owns Admin SDK startup; `app/db/firestore.py` owns only the lazy asynchronous client; `app/db/repositories/` owns every Firestore operation. Routers and services consume repositories rather than raw clients.
- Future integration interfaces: _To be defined without implementing out-of-scope systems_

### Data and Storage

- Primary database: Firebase Firestore, accessed server-side only through FastAPI and the Admin SDK
- Tenant isolation strategy: top-level collections with `company_id` on every tenant-owned document. Tenant repository methods require a `CompanyScope`; direct reads verify stored scope and list queries always filter by scope. Cross-tenant Super Admin access is deferred until a verified auth context exists.
- Role/permission model: many-to-many and extensible for custom roles
- AI vector storage: no separate vector store for MVP; revisit only if embedding requirements justify it
- Offline device store: SQLite or Hive, final choice pending
- Object storage: Firebase Storage or AWS S3, final choice pending

#### Phase 0.4 Data Foundation

| Collection | Contract | Scope and mutation policy |
|---|---|---|
| `companies` | `GlobalDoc` timestamps plus nullable `created_by`; document `id` is the tenant identity | Tenant root; addressed through its required `CompanyScope`; no unscoped list API |
| `users` | `TenantDoc` plus Firebase UID, email, display name, role, and status | Strictly company-scoped CRUD |
| `roles` | `TenantDoc` plus key, name, description, and `is_system` | Strictly company-scoped CRUD |
| `permissions` | `GlobalDoc` plus key, group, and description | System-managed global catalog; intentional `company_id` exception |
| `role_permissions` | `TenantDoc` plus role and permission IDs | Strictly company-scoped CRUD; many-to-many RBAC mapping |
| `audit_logs` | `AppendOnlyDoc` plus `company_id`, action, target, and metadata | Strictly company-scoped append/read; no update or delete API |

`TenantDoc` contains `company_id`, `created_at`, `updated_at`, and `created_by`.
`GlobalDoc` contains `created_at` and `updated_at`. `AppendOnlyDoc` contains
`created_at` and `actor_uid`. Stamps are generated centrally. Effective permissions
resolve through user → role → role-permission → global permission and return
`frozenset[str]`. The seven default role templates and starter permission catalog
live in one constants module. Firestore Rules remain deny-all for clients.

### Identity and Access

- Authentication provider: Firebase Authentication. Phase 0.5 implements backend
  token verification, claims synchronization, provisioning/link services, and
  `/api/v1/auth/me`; client login/reset/verification screens remain deferred.
- Token verification is provider-neutral at the dependency boundary through the
  `TokenVerifier` protocol. `FirebaseTokenVerifier` is the current adapter and uses
  revoked-token checks plus the Admin SDK's bounded clock-skew tolerance.
- A verified token contributes `uid` and `company_id`; `get_current_user` then loads
  the scoped Firestore user and role and resolves effective permissions through the
  Phase 0.4 many-to-many repositories. Custom claims carry `company_id`, `role_id`,
  and `role_key`, while Firestore remains authoritative for status and permissions.
- `/api/v1/auth/me` is the only Phase 0.5 protected route. Permission-specific route
  dependencies and UI guards were added in Phase 0.6.
- `require_permission(*keys, mode="all"|"any")` consumes the Phase 0.5
  `CurrentUser` and checks the immutable permission set resolved from the Phase 0.4
  matrix. `require_role` exists only for exceptional role-specific gates. Missing
  or invalid identity remains HTTP 401; an authenticated caller lacking authority
  receives the exact HTTP 403 contract and an `access.denied` audit attempt.
- Super Admin remains tenant-scoped and passes gates only because its Phase 0.4
  role mapping holds all catalog keys. There is no cross-tenant bypass.
- Next.js exposes `can`, `hasAny`, `hasAll`, `useCan`, and `Can`; Flutter exposes
  the same permission predicates through a controller/provider and
  `PermissionGate`. Both load `/api/v1/auth/me` through injectable token seams.
  These guards improve UX only; FastAPI remains the security boundary.
- Enterprise SSO through SAML/OIDC is a future capability
- API authorization is authoritative; UI authorization supports user experience but is not a security boundary

### Shared Design System

- `packages/design-tokens/tokens.json` is the only editable source for brand color
  scales, semantic dark/light colors, typography, 4px spacing, radius, elevation,
  z-index, and motion values. Its generator emits committed TypeScript/CSS and Dart
  bindings so neither client needs generation during its build.
- Next.js maps the generated values into Tailwind and CSS custom properties. Its
  theme provider defaults to dark, persists the user's light/dark choice, and its
  Framer Motion helpers honor `prefers-reduced-motion`.
- Flutter builds dark-default and light `ThemeData` from generated Dart constants,
  persists the theme locally, and uses `MediaQuery.disableAnimations` to remove
  non-essential motion. Space Grotesk (headings), IBM Plex Sans (body), and IBM
  Plex Mono (all machine values: IDs, emails, role/permission keys, timestamps,
  readings) are bundled locally in both clients as Latin-subset files for
  deterministic/offline typography.
- Admin and mobile expose parity primitives for actions, fields, surfaces, status,
  overlays, feedback, tabs, loading, and empty states. Development-only showcases
  exercise those primitives without entering normal navigation.
- The 2.1b design language is locked for every future screen: layered dark
  surfaces (#0A0E1A → #111827 → #1A2234) with luminous 1px borders carry depth —
  no decorative drop shadows or gradients; glow shadows exist only for status
  emphasis. Blue is structural, the orange accent is reserved for the primary
  action or critical emphasis, and status colors carry information only.
  Enterprise density (13px body baseline, min-h-9 controls, tight rows), a
  monospace "instrumentation label" idiom for group headers and status pills,
  asymmetric primary-region/secondary-rail layouts, and 120–240ms motion on
  cubic-bezier(0.16, 1, 0.3, 1) apply everywhere.
- The 2.1c brand system derives every color from the official logo (sampled
  orange #FB4402 and navy #002865) as OKLCH 50–900 scales in tokens.json;
  theme-aware Logo components in both clients select light/dark assets from
  the active theme so call sites never reference files. Raw hex colors and
  font families outside the token layer fail CI (admin ESLint rule, Flutter
  guard test); allowed exceptions are the generated token bindings and the
  static Flutter web shell (documented). Admin metadata is declarative and
  colocated per route via `src/seo/site.ts` helpers: public routes are fully
  indexed with canonical/OG/Twitter tags, everything inside the shell is
  noindex with a unique tab title, and robots/sitemap/manifest/theme-color
  are generated from the same config and tokens. Motion policy: Framer
  Motion only (GSAP, if ever needed, route-dynamic), transform+opacity only,
  token durations ≤240ms, reduced-motion respected; a CI bundle budget
  (430 KB over the 342 KB baseline) and recorded Lighthouse baselines guard
  regressions.
- **Rule:** every future screen must compose these primitives and shared tokens.
  Feature modules may extend the system centrally but may not introduce parallel
  color, spacing, typography, elevation, or motion constants.

### API Contract and Cross-Client Errors

- FastAPI owns the source contract. Every current operation has an explicit stable
  `operation_id`, tag, typed success model, and typed error responses. The
  reproducible export script writes `packages/contracts/openapi.json`.
- Pinned OpenAPI Generator 7.10.0 templates emit `typescript-fetch` for admin and
  `dart-dio` for mobile. The generated outputs are committed; CI repeats export and
  generation with pinned runtimes and fails on any diff.
- Single-resource success responses are returned directly. Future list responses
  use `{items, next_cursor}`; `next_cursor` is opaque and nullable, `null` means no
  more pages, and totals are omitted unless a future use case explicitly requires
  their Firestore cost.
- Every failure is `{error, message, details?, request_id}`. Request middleware
  accepts a valid caller UUID or creates one, echoes `X-Request-ID`, and handlers
  map validation/auth/forbidden/not-found/conflict/unhandled failures without
  leaking stack traces. RBAC `required`, `missing`, and `mode` values live under
  `details`.
- Admin wraps the generated Fetch client and mobile wraps the generated Dio client.
  These layers inject Firebase ID tokens, translate envelopes to typed errors, run
  the Phase 0.5 401 seam, log request IDs in development, and route user feedback
  through the Phase 0.7 toast/snackbar infrastructure. Application code does not
  issue feature-level direct `fetch`, `http`, or raw Dio calls.

### Phase 1.1 Client Login and Identity State

- Next.js initializes the Firebase Web SDK lazily from public environment
  configuration. Flutter initializes `firebase_core` from compile-time Dart defines;
  native Android/iOS Firebase files remain a documented follow-up because this slice
  targets web. Neither client contains committed Firebase configuration or secrets.
- A single client auth provider owns `restoring`, `signedOut`, `signingIn`, and
  `authenticated` state. Firebase persists the underlying session; its auth-state
  observer silently resolves `/api/v1/auth/me` after reload. The provider stores the
  returned `CurrentUser`, making uid, email, company, role, and effective permissions
  the client-side identity source of truth.
- The runtime chain is Firebase email/password sign-in → Firebase ID token → Phase
  0.8 generated-client wrapper → FastAPI `/api/v1/auth/me` → Phase 0.5 token verifier
  and Phase 0.4 scoped repositories → `CurrentUser` → authenticated Home placeholder.
  Phase 0.6 permission helpers consume this resolved permission set; FastAPI remains
  authoritative for every protected operation.
- Both login screens compose Phase 0.7 fields, buttons, cards, status primitives,
  toast/snackbar feedback, shared tokens, and reduced-motion-aware entrance motion.
  Firebase errors are mapped to non-enumerating friendly messages. A `/me` 403 signs
  Firebase out and reports an inactive account; network failures remain recoverable.
- Sign-out clears Firebase and provider state and returns to login. Comprehensive
  token refresh, route guards, and session hardening remain deferred to Phase 1.4.
  Signup/verification and forgot/reset links remain disabled until Phases 1.2/1.3.

### Phase 1.2 Organization Signup and Email Verification

- Self-service registration always creates a new tenant with an opaque `cmp_...`
  identifier; company names are display labels and may duplicate. FastAPI creates
  the company, idempotently installs the Phase 0.4 seven-role matrix, provisions
  the first Firebase/Firestore user as `company_admin`, synchronizes claims, and
  writes company/user audit events. No path joins an existing tenant.
- The contract chain is signup form → Phase 0.8 generated registration client →
  `POST /api/v1/auth/register` → scoped company/role/user repositories → Firebase
  client sign-in → Firebase `sendEmailVerification`. Firebase performs delivery;
  the Phase 0.5 Admin link generator remains reserved for later notification flows.
- `CurrentUser` now carries `email_verified`. `/api/v1/auth/me` deliberately returns
  identity with HTTP 200 for verified and unverified callers, allowing both clients
  to restore context and render verification state. `require_verified_email` wraps
  application permission/role gates and returns `403 email_unverified` before any
  protected work. Firestore role data remains authoritative for permissions.
- Next.js and Flutter auth providers add signing-up, verification-required, and
  checking-verification states. Their signup and verification views reuse Phase
  0.7 primitives/motion and Phase 0.8 errors/toasts, enforce matching validation,
  provide a 60-second resend cooldown, reload Firebase before continuing, and route
  verified users to the existing Home placeholder. Invite onboarding remains a
  later admin-portal concern; reset and full session hardening remain Phase 1.3/1.4.

### Phase 1.3 Forgot / Reset Password

- The Phase 1.1 login screens' "Forgot password?" links now open a forgot-password
  view on both clients, composed from Phase 0.7 primitives with entrance motion and
  reduced-motion parity. The flow mirrors Phase 1.2's client-send pattern: each
  Firebase client SDK sends the email via `sendPasswordResetEmail`, honoring the
  optional `AUTH_ACTION_URL` continue URL (`NEXT_PUBLIC_AUTH_ACTION_URL` in Next.js)
  and otherwise Firebase's default; Firebase's hosted action page completes the
  actual password change. No backend endpoint or transactional email was added —
  delivery remains reserved for the notifications phase.
- Responses never disclose account existence: `user-not-found`/`user-disabled`
  resolve to the identical neutral "If an account exists for that email, a reset
  link has been sent" confirmation, while only genuine rate-limit and network
  failures surface through the Phase 0.8 error/toast mapping. A 60-second resend
  cooldown and a back-to-login path complete the flow. Session, token refresh, and
  route guards remain deferred to Phase 1.4.

### Phase 1.4 Session Management and Route Guards

- Session lifecycle: on load each client restores the Firebase session behind a
  branded splash — `onIdTokenChanged` (Next.js) / `idTokenChanges` (Flutter) feed
  one auth provider, which resolves `/api/v1/auth/me` before any screen renders,
  so an authenticated user never sees a login flash and an anonymous one never
  sees protected content. The Firebase SDK keeps ID tokens fresh; the Phase 0.8
  typed API layer additionally retries a real 401 exactly once after a forced
  token refresh. A still-dead session is expired cleanly: Firebase sign-out,
  cleared identity/permission context, a session-expired toast, and a guard-driven
  login redirect. `refreshSession()` force-refreshes the token and re-resolves
  `/me`, so server-side role changes (0.5 claims sync) surface on the next refresh.
- Route guards tie 0.6 RBAC to 1.1–1.3's screens: protected routes sit behind
  RequireAuth (login redirect preserving the intended destination via an
  internal-only `?next` / `pendingRoute`), verify-email gating for unverified
  identities, PublicOnly redirects away from login/signup/forgot when already
  authenticated, and a RequirePermission wrapper over the 0.6 `can()` helpers —
  seeded from the authoritative `/me` permissions — that renders a branded 403
  page (demo: `/rbac-demo` requires `assets.write`). Mobile guard redirects
  replace the navigation stack so back-navigation cannot reveal protected
  content. Next.js middleware was rejected: under D-011 the Firebase session
  exists only in the browser, so guarding is a client-layout concern. Client
  guards remain UX; FastAPI's `require_permission` + `require_verified_email`
  stay authoritative for every protected operation.

### Phase 2.1 Application Shell

- Every protected route on both clients now renders inside one persistent
  shell mounted directly under the Phase 1.4 guards: Next.js wraps the
  `(protected)` layout as RequireAuth → AppShell → page, and Flutter's route
  table builds RequireAuthGuard → AppShellScaffold → screen. Public auth
  screens (login/signup/forgot/verify) stay outside. Future screens are pages
  dropped into this composition — they inherit navigation, header, guards,
  and permission context without new wiring.
- Navigation is data, not markup: a single declarative config per client
  (`apps/admin/src/navigation/nav-config.tsx`,
  `apps/mobile/lib/navigation/nav_config.dart` — a documented mirrored
  contract, D-015) declares label/icon/route/`requiredPermission` per module
  and is filtered at render time through the Phase 0.6 `can()` helpers over
  the authoritative `/me` permissions, seeded by the 1.4 session context.
  Admin renders it as a grouped collapsible sidebar (persisted preference,
  icon-only tablet rail, focus-trapped mobile drawer); mobile renders the
  primary set as bottom navigation (Home / Assets / Work / More) with a
  permission-filtered "More" sheet. Client visibility remains UX only —
  FastAPI's require_permission stays authoritative.
- The shell header carries breadcrumbs/title derived from the nav config, the
  0.7 theme toggle, a user menu built from `/me` (initials, display name,
  role badge, company name — `company_name` was added to `/me` for this, the
  only backend change — plus the 1.4 refresh-session and sign-out actions),
  and visibly disabled placeholders for global search (Phase 16) and
  notifications (Phase 15). Unbuilt roadmap modules route to a branded
  "Coming soon" page inside the shell; unknown paths hit a branded 404 and
  the 1.4 branded 403 renders in the shell content area, so no protected
  navigation ever dead-ends outside the frame.

### Phase 2.2 Dashboard and Chart Infrastructure

- **Data flow.** Three read-only, `reports.read`-gated FastAPI routes under
  `/api/v1/dashboard` are the dashboard's only data source:
  `GET /summary` (real user/role/audit counts for a 7/30/90-day window plus
  company profile), `GET /activity` (cursor-paginated, actor-enriched audit
  events, optional action-type filter), and `GET /activity-series`
  (zero-filled per-day event counts for the same window, for charting).
  Every field traces to the Phase 0.4 `companies`/`users`/`roles`/
  `audit_logs` collections — the phase's hard rule is that nothing here may
  render a fabricated number; where a future module has no data yet, the
  UI shows an explicit empty state instead (see Reserved-KPI contract
  below). `reports.read` is held by every system role in the 0.4 matrix, so
  the dashboard route itself carries no `requiredPermission` in the nav
  config; individual stat cards are gated client-side by finer permissions
  (`users.manage`, `roles.manage`).
- **Read-cost policy (D-019).** `AuditLogRepository.list_since` is the only
  query path into `audit_logs` for aggregation: one Firestore query
  filtered by `company_id` and `created_at >=` the window start (max 90
  days), hard-capped at 5000 documents in memory as a backstop. This
  compound equality+range query requires a Firestore composite index,
  provisioned as IaC at `infra/firebase/firestore.indexes.json` (apply via
  `firebase deploy --only firestore:indexes`) rather than left to ad hoc
  console creation.
- **Chart infrastructure** is this phase's reusable surface for every future
  module: `apps/admin/src/design-system/chart.tsx` (Recharts) and
  `apps/mobile/lib/design_system/chart.dart` (fl_chart) both expose a
  `TimeSeriesChart` (plus bar/donut variants on admin) that resolves colors
  live from design tokens (CSS custom properties on admin, `DsColors` on
  mobile) — never a literal hex at a call site — and share one
  loading/error/empty/ready state contract. Entry animation is capped at
  the 2.1c motion-token durations and skipped entirely under
  `prefers-reduced-motion`.
- **Dashboard composition** replaces the Phase 1.1 placeholder Home on both
  clients: a greeting/role/company header, permission-gated stat cards, the
  activity chart with a 7/30/90 window switcher, a paginated human-readable
  activity feed, permission-filtered quick actions, and the reserved-KPI
  region below. `AuthProvider`/`AuthController` now expose the single
  already-wired API client instance (token injection, 401 retry, unified
  envelope feedback all in one place per the 1.4 session hardening) so
  dashboard data-fetching is just another consumer of it, not a new client.
- **Reserved-KPI contract (the visual contract 2.3 makes pluggable).** Each
  not-yet-built module (Assets, Work Orders, Permits, Safety) gets one tile
  gated by that module's own future `requiredPermission`, rendering a fixed
  honest copy ("`<Module>` metrics appear once the `<Module>` module is
  enabled.") — never a placeholder number or fake chart. Phase 2.3 replaces
  this static region with a pluggable widget framework; the tile shape and
  gating rule established here is the contract it must preserve.

### Phase 3.1 Company-Scoped User Management

- **Data flow.** Five `users.manage`-gated FastAPI routes under
  `/api/v1/users` (`GET` list, `GET /{id}`, `POST /invite`,
  `PATCH /{id}`, `PATCH /{id}/status`) plus a sixth, read-only
  `GET /api/v1/roles`, are the only server surface for this module. All
  five mutation-adjacent routes share one service,
  `app/users/service.py::UserManagementService`, which is the single
  place the four safety rules below are enforced — the FastAPI route
  handlers stay thin request/response wiring, matching the
  `CompanyRegistrationService`/`UserProvisioningService` pattern from
  0.5/1.2. List/search/filter/sort all happen in Python over
  `UserRepository.list(scope)` (never a new Firestore query shape),
  consistent with the "list the tenant, filter in memory" pattern every
  existing repository already uses — this tenant's dataset is small
  enough that this stays cheap, and it avoids adding new composite
  indexes for a feature this size. Pagination reuses the 2.2 opaque
  base64url cursor idiom, but encodes only the cursor row's document ID
  (index-lookup into the already-sorted, already-filtered in-memory
  list) rather than a sort-value tuple, since sort key type varies
  (string for name, datetime for created_at).
- **Invite delivery (D-021).** `POST /invite` calls the existing 0.5
  `UserProvisioningService.provision_user` with `password=None` — Firebase
  Auth assigns a random password the invitee never sees. The admin
  client then calls the Firebase client SDK's `sendPasswordResetEmail`
  (the same call 1.3's forgot-password flow already uses) so the
  invitee receives a "set your password" email and can sign in the
  moment they do. No transactional-email service was added; see D-021 in
  DECISIONS.md for why this reuse is exact, not approximate.
- **Safety rules** live entirely in `UserManagementService`, not the
  route layer or the client: a user can never deactivate or demote
  themselves out of an admin role; the last active `company_admin` in a
  tenant can't be deactivated or demoted (even though every company also
  has a seeded `super_admin` role document per 0.4's seven-role
  template, this UI never offers it — `role.key == "super_admin"` is
  rejected on both invite and role-change); a Company Admin can only
  assign a role that already belongs to their own company (enforced
  implicitly by `RoleRepository.get(scope, role_id)`'s tenant scoping);
  and re-inviting an email already backing a Firebase Auth account
  anywhere returns a clean 409 rather than a duplicate. See D-022.
- **Role change and claims.** `PATCH /{id}` reuses the 1.4
  `ClaimsService.sync_claims_from_role` after any `role_id` change, so
  the new permission set takes effect on the user's next token refresh —
  the same mechanism 1.4's session hardening already established, not a
  new claims path.
- **Admin UI** (`apps/admin/src/users/`) follows the 2.2 dashboard's
  hook-plus-page shape: `users-data.ts` (`useUsersData`) owns list/roles
  fetch state, filters, and the five mutation calls; `users-page.tsx`
  composes the toolbar, `TableShell`-based table, and pagination;
  `user-modals.tsx` holds the invite form and the detail/edit/status-
  confirm modal. The route (`/users`) is gated by `RequirePermission`
  the same way `/rbac-demo` already is, and the nav entry
  (`nav-config.tsx`) is the first "Administration" item besides the
  still-stubbed "Admin & Settings".
- **Mobile (D-023)** ships list + detail only
  (`apps/mobile/lib/users/`) — no invite/edit UI. The `/users` route and
  bottom-nav "Users" destination are gated by `users.manage` exactly
  like the admin web nav item.

### Phase 3.2 Role and Permission Management

- **Data flow.** Six `roles.manage`-gated FastAPI routes extend the 3.1
  surface: `GET /api/v1/roles` (extended with `permission_count` and
  `assigned_user_count`, and now accepting either `roles.manage` or
  `users.manage` — see D-024), `GET /api/v1/roles/{id}` (full
  `permission_keys`), `POST /api/v1/roles`, `PATCH /api/v1/roles/{id}`,
  `DELETE /api/v1/roles/{id}`, and a new `GET /api/v1/permissions`
  (the global catalog grouped by category). All five mutation-adjacent
  and read routes share `app/roles/service.py::RoleManagementService`,
  matching `UserManagementService`'s thin-route/fat-service shape. No
  schema change was needed — the 0.4 `Role`/`Permission`/`RolePermission`
  collections already modeled the many-to-many mapping; a custom role's
  permission set is a diff against `RolePermissionRepository`, computed
  the same way `rbac/seeding.py::_ensure_role_permissions` already
  diffed system-role mappings (expected IDs vs. existing, batch
  create/delete via `asyncio.gather`). Custom role IDs are
  `role_{uuid4().hex}`, distinct from system roles' deterministic
  `{company_id}__{role_key}` scheme.
- **System roles are permanently read-only (D-024).** `is_system=True`
  roles can never be renamed, re-permissioned, or deleted — enforced in
  `RoleManagementService` before any mutation, independent of and in
  addition to the fact that `seed_system_roles`/`run_seed` actively
  reconcile the seven system roles' name/description/permission set back
  to `SYSTEM_ROLE_TEMPLATES` on every seed run. Only `is_system=False`
  custom roles are ever created, edited, or deleted by this module. The
  `super_admin` role stays invisible to every 3.2 endpoint exactly like
  3.1's role picker, since granting or viewing it is out of scope until
  3.5.
- **`platform.admin` can never be granted by a Company Admin.** Both
  `POST /api/v1/roles` and `PATCH /api/v1/roles/{id}` reject a
  `permission_keys` payload containing `platform.admin` with 403 before
  any Firestore write; the admin UI's permission matrix omits the entire
  `platform` catalog group from every company-scoped screen so there is
  nothing to check in the first place.
- **Permission-based last-holder guard.** Deleting a role is already
  blocked whenever it has any assigned users (409 `role_has_assigned_users`
  with the count), so a deleted role can never be the one that drops the
  tenant to zero holders of `users.manage`. Editing a role's permission
  set is the one path that can: before persisting a change that would
  remove `users.manage` from a role, `RoleManagementService` computes,
  for every active user in the tenant, whether their role (after the
  proposed edit is applied) would still include `users.manage`, and
  rejects with 409 `last_holder_of_users_manage` if the count would drop
  to zero. This generalizes 3.1's `_active_admin_count` (which was keyed
  on the hard-coded `company_admin` role key) to an arbitrary
  permission across arbitrary roles, since a custom role can now also
  carry `users.manage`.
- **Claims sync on permission edit.** After a role's permission set
  changes, `RoleManagementService` calls the 0.5/3.1
  `ClaimsService.sync_claims_from_role` for every user currently holding
  that role, batched with `asyncio.gather(..., return_exceptions=True)`;
  a failed sync for one user is logged and does not fail the request for
  the others, since the role edit itself already succeeded in Firestore.
  Unlike a 3.1 role *change* (which alters a user's `role_id`/`role_key`
  claims), a role *permission* edit leaves `role_id`/`role_key` claims
  unchanged — `/api/v1/auth/me` always resolves a user's effective
  permissions live from Firestore via the 0.5 `PermissionResolver`, on
  every request, so enforcement reflects a permission edit immediately,
  not on next token refresh. The claims sync exists to keep the
  `role_id`/`role_key` custom claims internally consistent with 3.1's
  established pattern, and because the admin/mobile clients cache the
  permission set they got from `/me` at session start — that client-side
  view still only refreshes on the user's next login or session refresh,
  consistent with the 1.4 ADR's phrasing. See D-025.
- **Before/after audit diff.** Every `role.updated`/`role_permission.*`
  mutation already gets a before/after audit entry for free from
  `TenantRepository._create`/`_update`/`delete` (0.4). A permission edit
  additionally writes one consolidated `role.permissions_updated` audit
  event with `before`/`after`/`added`/`removed` permission-key lists, so
  the effective change is readable in one entry rather than reconstructed
  from N individual mapping create/delete records.
- **Admin UI** (`apps/admin/src/roles/`) follows the same hook-plus-page
  shape as 3.1's `apps/admin/src/users/`: `roles-data.ts`
  (`useRolesData`) owns the role list and permission catalog fetch state
  plus the four mutation calls; `roles-page.tsx` composes the toolbar and
  table; `role-modals.tsx` holds the create/clone form and the
  detail/edit/delete modal, including the impact-warning + added/removed
  diff card shown before saving a permission change to a role with
  assigned users (mirrors `UserDetailModal`'s `confirmingStatus` pattern).
  `permission-matrix.tsx` is a new reusable component: permissions
  grouped by category with per-permission and group-level "select all"
  checkboxes and a live selected-count summary, built on a new `Checkbox`
  design-system primitive (`packages/design-tokens`-driven, added
  alongside the existing primitives rather than as a one-off). The route
  (`/roles`) is gated by `RequirePermission permission="roles.manage"`
  and the nav entry sits beside "Users" in the "Administration" group.
- **Mobile** ships list + detail only (`apps/mobile/lib/roles/`) — no
  create/edit/delete UI, extending the 3.1/D-023 read-only-on-mobile
  precedent (see D-026). The `/roles` route and bottom-nav "Roles"
  destination are gated by `roles.manage` exactly like the admin web nav
  item.

### Offline Synchronization

- Durable on-device operation queue
- Background sync worker
- Conflict detection and resolution policy: _To be defined before inspection implementation_
- Retry, idempotency, and failure recovery: _To be defined_

### AI Safety Boundary

- Claude API and computer-vision models provide advisory analysis
- Every finding requires inspector confirmation or override
- Reports cannot be finalized from unreviewed AI output
- Inputs, outputs, confirmations, and overrides require appropriate audit history

### Audit and Observability

- Critical actions must be recorded in comprehensive audit logs
- Audit event schema, retention, integrity controls, monitoring, and operational telemetry: _To be defined_

### Deployment and Security

- Cloud topology: _To be defined_
- Secrets, encryption, backups, disaster recovery, tenant isolation testing, and security controls: _To be defined_

## Slice Integration Record

After each micro-task is tested and marked Done, record here how its frontend, backend, and database pieces connect to existing slices.

| Micro-task | Connections and contracts | Date |
|---|---|---|
| Phase 0.1 — context setup | Establishes persistent project constraints and decision gates; no application components created. | 2026-07-11 |
| Phase 0.2 — monorepo scaffold | Establishes independently runnable `apps/api` (FastAPI), `apps/admin` (Next.js), and `apps/mobile` (Flutter with web runner). `packages/contracts` reserves the future generated API-contract boundary. `infra/ci` points to the root GitHub Actions workflow, whose API, admin, and mobile jobs validate each application independently. `infra/firebase` reserves Firebase configuration for Phase 0.3. No feature, authentication, or data behavior is introduced. | 2026-07-15 |
| Phase 0.3 — Firebase health connection | FastAPI initializes one Firebase Admin app at process startup from either a local service-account path or base64 JSON. A lazy async client in `app/db/firestore.py` performs the only Firestore call: a retry-disabled, deadline-bounded read of `_health/ping`. `GET /health` converts missing credentials, connectivity, timeouts, and failures into the stable HTTP 200 contract consumed directly by the Next.js and Flutter scaffold screens. Local CORS origins connect both clients to the API. Firestore rules deny every direct client read/write, preserving FastAPI as the database boundary. No collections, tenant data, auth flows, or seed data are introduced. | 2026-07-15 |
| Phase 0.4 — tenant data foundation | Adds only `companies`, `users`, `roles`, `permissions`, `role_permissions`, and `audit_logs` as top-level collections. Pydantic base contracts feed typed repositories; tenant repositories require `CompanyScope`, central stamps protect provenance, mutations can emit append-only audit records, and permission resolution returns immutable keys. The idempotent seed uses deterministic IDs to reconcile the exact catalog, Acme’s seven system roles/users, and a second isolated tenant/user. The existing health read was moved behind an infrastructure repository so all Firestore operations now share the repository boundary. No HTTP routes, auth flows, UI, or feature collections were added. | 2026-07-15 |
| Phase 0.5 — backend auth foundation | Adds a provider-neutral `TokenVerifier` seam with a Firebase Admin adapter, explicit 401 translation, and the sole protected route `/api/v1/auth/me`. Verified `uid` + `company_id` claims enter the Phase 0.4 `CompanyScope`; repositories load the active user/role and the existing resolver returns exact immutable permission keys for typed `CurrentUser`. Claims services synchronize `company_id`, `role_id`, and `role_key`; provisioning links Firebase Auth creation to scoped Firestore creation and audit records; verification/reset link wrappers optionally consume `AUTH_ACTION_URL`. The auth seed mode reconciles only its declared demo emails, re-keys placeholder documents to real Firebase UIDs while preserving timestamps, audits migrations, and handles interrupted reruns without duplicates. Firestore rules remain deny-all and no login UI or permission-specific guard was added. | 2026-07-16 |
| Phase 0.6 — RBAC enforcement | Connects the Phase 0.5 token → `CurrentUser` chain and Phase 0.4 immutable role matrix to `require_permission` (`all`/`any`) and the narrowly reserved `require_role`. Three temporary `/api/v1/_rbac-demo` routes prove single/all/any gates; permission/role denials attempt a scoped append-only `access.denied` audit without allowing audit failure to weaken or crash the gate. Phase 0.8 now carries 401/403 through the unified envelope with RBAC context under `details`. Super Admin receives no bypass or cross-tenant path. The Next.js permission context and Flutter permission provider consume `/me` once through future-auth token seams and expose matching predicates/wrappers on existing scaffold screens; these client guards are explicitly advisory. CI executes admin and mobile guard tests. | 2026-07-16 |
| Phase 0.7 — shared design system | Establishes `packages/design-tokens/tokens.json` as the single framework-neutral source and generates committed bindings into Next.js Tailwind/CSS and Flutter `ThemeData`. Both clients default to dark, persist light/dark choice, bundle Inter/JetBrains Mono, share equivalent reusable primitives, and implement the same fast/standard/slow motion feel with reduced-animation paths. Development-only showcases render every primitive and motion behavior without adding feature or auth screens. All future screens must reuse this foundation. | 2026-07-16 |
| Phase 0.8 — API contract and generated clients | Connects the Phase 0.5 token/current-user chain and Phase 0.6 RBAC routes to a typed OpenAPI 3.1 contract with one request-ID error envelope. Pinned generation commits a TypeScript Fetch client for Next.js and Dart Dio client for Flutter; CI re-exports/regenerates and rejects drift. Client wrappers inject tokens, normalize network/API failures, invoke the 401 seam, and surface Phase 0.7 toast/snackbar feedback. Existing health and `/me` consumers now use these wrappers. No feature screen/module or Phase 1 implementation was added. | 2026-07-16 |
| Phase 1.1 — client login | Both clients initialize the Firebase client SDK from uncommitted environment configuration, sign in with email/password, inject the Firebase ID token through the Phase 0.8 typed wrapper, and resolve the Phase 0.5 `/me` identity backed by Phase 0.4 tenant/RBAC repositories. One auth provider restores persisted Firebase sessions and owns `CurrentUser`; the authenticated Home placeholder renders role and exact effective permissions for Phase 0.6 guard consumers. Login/Home compose Phase 0.7 primitives, motion, and feedback. Minimal sign-out closes the loop; signup, reset, and full session/route hardening remain deferred. | 2026-07-17 |
| Phase 1.2 — organization signup and verification | The typed registration operation creates an opaque-ID tenant, installs the shared seven-role matrix, provisions/audits its first `company_admin`, and returns the Firebase identity seam. Both clients sign in, use Firebase built-in verification delivery, and keep unverified identity resolvable through `/me`; server `require_verified_email` gates all application RBAC dependencies until a refreshed token reports verification. Signup/verify UI reuses the design system, generated clients, auth provider, and unified feedback. | 2026-07-17 |
| Phase 3.2 — role and permission management | Extends the 3.1 `RoleRepository`/`RolePermissionRepository` (0.4) with a create/update/delete surface and a new global permission-catalog route, gated by `roles.manage` (0.6) and sharing 3.1's `UserRepository` for the last-holder guard and claims batch sync (0.5's `ClaimsService`). No Firestore schema change. Admin gains a new `apps/admin/src/roles/` module plus a `Checkbox` design-system primitive (0.7); mobile gains a read-only `apps/mobile/lib/roles/` mirror. Contracts regenerated for `RoleDetail`/`CreateRoleRequest`/`UpdateRoleRequest`/`PermissionCatalog`/`RoleDeleted`. | 2026-07-22 |
