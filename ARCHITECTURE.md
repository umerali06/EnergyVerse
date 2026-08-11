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

### Phase 3.3 Company Profile & Settings

- **Data flow.** Four `company.settings`-gated FastAPI routes —
  `GET`/`PATCH /api/v1/company`, `POST`/`DELETE /api/v1/company/logo` —
  are the only server surface, all backed by
  `app/company/service.py::CompanyProfileService`, matching the thin-
  route/fat-service shape 3.1/3.2 already established. `Company` (0.4)
  gains six new fields, all optional or defaulted
  (`industry`, `timezone: str = "UTC"`, `locale: str = "en-US"`,
  `contact_email`, `contact_phone`, `logo_path`), so every existing
  Firestore company document (seeded Acme, real tenants) validates
  unchanged via `model_validate` — no migration was needed. `industry`
  is checked against a small constant tuple next to
  `rbac/constants.py`'s catalogs; `timezone` is validated for real via
  Python's stdlib `zoneinfo.available_timezones()` (the `tzdata` package
  was added as an explicit dependency since Windows has no system IANA
  database for `zoneinfo` to read); `locale` is checked against a
  permissive BCP-47 shape regex rather than a fixed enum, since
  `Intl`/browsers already handle arbitrary valid tags.
- **Partial-update semantics fixed a real bug found in real-creds
  testing.** `CompanyRepository.update` originally filtered the PATCH
  payload with `without_none()` (dropping any field explicitly sent as
  `null`), which meant a client could never clear `industry` or contact
  info once set — "Not set" in the admin Industry select silently did
  nothing. The repository now merges `payload.model_dump(exclude_unset=True)`
  instead: a field absent from the request body stays untouched, while a
  field explicitly sent as `null` clears it, using Pydantic v2's
  `model_fields_set` to distinguish the two. `CompanyProfileService`
  additionally rejects an explicit `null` for `name`/`timezone`/`locale`
  (422 `invalid_{field}`) since those are never optional on the entity.
- **`CurrentUser` timezone/locale enrichment reuses the `company_name`
  precedent exactly.** `company_timezone`/`company_locale` (both
  defaulted) were added to `CurrentUser` and populated in
  `get_current_user` alongside the existing `company_name=company.name`
  line, making them available to every authenticated user via
  `/api/v1/auth/me` regardless of `company.settings` — necessary because
  the real timezone/locale consumer (dashboard date formatting) is
  visible to every role, while the full profile endpoints stay
  `company.settings`-gated. This is the same reason `company_name`
  already worked this way before 3.3 existed.
- **Storage wiring (first use of Firebase Storage in this codebase).**
  `app/storage/service.py::CompanyLogoStorage` wraps the Admin SDK
  bucket behind three operations (`upload`, `delete`, `signed_url_for`),
  all keyed by one fixed, company-scoped path convention —
  `companies/{company_id}/branding/logo`, always overwritten in place so
  there is never an orphaned blob to clean up. `app/core/settings.py`
  adds `firebase_storage_bucket` (env `FIREBASE_STORAGE_BUCKET`),
  resolved with a `.appspot.com`-suffix fallback when unset; real-creds
  testing against `thinking-case-469504-c0` found that fallback guess
  wrong for this project (Firebase provisioned it as the newer
  `<project>.firebasestorage.app` domain instead), so this project's
  `.env` sets the variable explicitly. Reads never persist a public URL —
  `CompanyProfileService` calls `signed_url_for` fresh on every
  `GET`/mutation response (a 1-hour V4 signed URL), so `Company.logo_path`
  stores only the internal object key, never a URL that could expire
  while cached. **Security posture mirrors D-002's Firestore precedent
  exactly**: `infra/firebase/storage.rules` denies all client read/write
  unconditionally — every byte in and out of Storage is server-mediated
  through the Admin SDK, with no public objects and no client-side
  Storage SDK usage anywhere in this codebase. This path convention and
  security posture is the one assets/inspections should reuse for their
  own Storage objects in later phases.
- **Admin UI** (`apps/admin/src/settings/`) replaces the `/settings`
  route's `ComingSoonScreen` with `CompanySettingsPage`, following the
  3.2 `RoleDetailModal` dirty-state/save/discard/toast pattern directly
  on the page (no modal, since there is exactly one record to edit, not
  a list). `logo-upload.tsx` is a net-new drag-drop + file-input
  component — no prior upload pattern existed anywhere in the admin app.
  The Industry/Locale `<select>` options are small curated lists (kept
  in sync with the backend's `INDUSTRY_CHOICES` and BCP-47 examples by
  comment reference); the Timezone `<select>` populates itself at
  runtime from the browser's own `Intl.supportedValuesOf("timeZone")`
  with `"UTC"` unioned in explicitly — real-browser testing (Chrome)
  showed `"UTC"` is not a member of that list, which silently mismatched
  a fresh tenant's bound `<select>` value against its displayed option
  before this fix.
- **Date formatting now honors company timezone/locale.**
  `apps/admin/src/dashboard/format.ts`'s `formatCompanyDate` and
  `formatChartDay` (previously hardcoded to `toLocaleDateString(undefined, ...)`,
  i.e. the browser's own locale/timezone) gained an optional
  `{ locale, timeZone }` parameter, threaded from `CurrentUser.companyLocale`/
  `companyTimezone` at their two existing call sites (the dashboard's
  "Company since" line and activity chart ticks) plus the new Company
  Settings "Company since" line. `formatRelativeTime` was deliberately
  left unchanged — it's a pure elapsed-seconds calculation with no
  calendar dependency, so threading timezone/locale into it would be a
  no-op. Mobile mirrors this in `apps/mobile/lib/dashboard/format.dart`
  via the new `timezone` package dependency (Dart's core `DateTime` has
  no IANA conversion of its own); locale-aware month names were
  deliberately not added to mobile (English month names only) since that
  would require the much larger `intl` package's full CLDR data for a
  phase whose mobile scope is a read-only profile view.
- **Mobile** ships a read-only `apps/mobile/lib/company/` profile screen
  only — no edit or logo-upload UI, extending the 3.1/3.2 (D-023/D-026)
  read-only-on-mobile precedent. The `/settings` route and "Admin &
  Settings" destination are gated by `company.settings` exactly like the
  admin web nav item.

### Phase 3.4 Audit Log Viewer

- **The complete, filterable, exportable compliance trail** over the same
  `audit_logs` collection 2.2's dashboard widget already reads from a fixed
  90-day/5000-doc window — this phase makes the read caller-controlled
  (arbitrary date range, actor/action/target-type/text filters, CSV export)
  rather than a fixed recent slice.
- **Query shape reuses D-019 exactly, with the date range promoted from a
  fixed window to the real query bound.** `AuditLogRepository.list_range`
  adds a `created_at <= end` filter alongside the existing
  `company_id ==` / `created_at >= start` pair used by `list_since` — since
  both bounds are on the same already-indexed field, **no new Firestore
  index was needed**. `app/audit/query_service.py::AuditQueryService`
  applies actor/action/target-type equality and free-text substring
  matching (case-insensitive, over action/target/stringified metadata —
  Firestore has no native full-text search) in-memory over that bounded
  read, then cursor-paginates. `AUDIT_QUERY_CAP = 25,000` bounds the raw
  Firestore pull; a `truncated` flag on `AuditLogPage` tells the UI when
  the cap was hit rather than silently hiding older events. `GET
  /api/v1/audit-logs/actions` returns the distinct actions/target-types
  actually seen in the selected range, powering the filter dropdowns from
  real data instead of a hardcoded enum.
- **Export streams directly, no Storage round trip.** `GET
  /api/v1/audit-logs/export` re-runs the identical bounded/filtered query
  and writes CSV via stdlib `csv`/`io.StringIO` into a `StreamingResponse`
  (`text/csv`, `Content-Disposition: attachment`) — the first
  file-streaming route in this codebase. A filtered set that would exceed
  the same 25,000-row cap gets a 413 asking the caller to narrow the
  range/filters, rather than a silently truncated compliance export.
- **`audit.read` permission.** Added to the Phase 0.4 catalog;
  `company_admin`/`super_admin` inherit it automatically
  (`ALL_PERMISSION_KEYS`-derived), `hse_manager`/`executive` gained it
  explicitly, `operations_manager`/`field_inspector`/
  `maintenance_technician` did not. `apps/api/scripts/reconcile_roles.py
  --company-id <id>` re-runs the existing idempotent `seed_system_roles`
  diff for one already-registered tenant — the backfill path for any real
  company outside the two demo tenants (which pick up the grant for free
  the next time `scripts.seed` runs).
- **Reading the audit log is itself not audited** — the route/service
  layer never calls `AuditService.audit`, exactly like the 2.2 dashboard's
  read routes, to avoid self-referential noise in a collection that's
  supposed to represent real mutations.
- **Admin UI** (`apps/admin/src/audit/`) is a new list+filter+paginate page
  structurally cloned from 3.1's `users-page.tsx` (not 3.3's single-record
  settings page): a filter-bar `Card` (date range, actor/action/target-type
  selects sourced from the facets endpoint, text search) with dismissible
  `FilterChip`s (the one new reusable primitive this phase adds — nothing
  dismissible existed before), a dense table with an expandable row
  revealing the raw `metadata` (before/after panels when present), and an
  "Export CSV" button that calls the generated client's `exportAuditLogs`
  directly (its `TextApiResponse` fallback already returns the raw CSV
  string for a non-JSON content type, so no bypass of the generated client
  was needed) and triggers a browser download via a `Blob`/object URL.
  Absolute timestamps use the 3.3 `companyTimezone`/`companyLocale` fields
  already on `CurrentUser` — not a fresh `getCompany()` call, since
  `company.settings` and `audit.read` are different, non-overlapping
  permissions and most `audit.read` holders (`hse_manager`, `executive`)
  don't hold `company.settings`.
- **Mobile** (`apps/mobile/lib/audit/`) ships list + filters + detail only,
  read-only, extending the exact D-023/D-026 "deliberate mobile scope, not
  omission" precedent — CSV export stays admin-web-only, since a
  downloadable compliance file is a desktop workflow.

### Phase 3.5 Super-Admin Cross-Tenant Platform Administration

- **Resolves D-006.** Phase 0.4 deferred all cross-tenant repository access
  until a verified post-auth trusted context existed. That context is a
  Firebase ID token whose `get_current_user`-resolved permission set
  includes `platform.admin` (held only by `super_admin`, per the 0.4
  matrix). This is the FINAL Phase 3 task and the first legitimate
  cross-tenant path in the codebase — see D-030 for the full trust model.
- **`AdminScope` (`app/models/base.py`)** carries only `acting_uid`/
  `acting_company_id` and is constructed by exactly one dependency,
  `app/admin/dependencies.py::get_admin_scope`, which itself depends on
  `require_permission("platform.admin")`. Every `/api/v1/platform/*` route
  (`app/api/v1/platform.py`, thin-route/fat-service like `app/audit/`/
  `app/company/`) depends on `AdminScope` alone — never a raw `CurrentUser`,
  never a client-supplied `company_id`/`role` field. `app/admin/service.py`'s
  `AdminCompanyService` is the sole business-logic home:
  `GET /companies` (cursor-paginated, page-bounded N+1 user-count fan-out —
  not a full-collection scan, per D-019's cost precedent), `GET
  /companies/{id}` (platform-level detail: profile + counts + status, never
  business records), `PATCH /companies/{id}/status` (suspend/reactivate),
  `PATCH /companies/{id}` (subscription tier only), and `GET /stats`
  (platform-wide totals, an unavoidable full N+1 today given the small real
  tenant count — flagged, not solved, for when that stops being true).
- **`CompanyRepository.list_all()`** (new) is the only unscoped read of the
  `companies` collection, modeled directly on `PermissionRepository.list()`
  — the codebase's only other "whole collection, no tenant filter" read.
- **The reverse-guard test.** `test_super_admin_home_company_route_stays_tenant_scoped`
  proves a super-admin's elevated `platform.admin` permission never widens
  any *existing* company-scoped route: `GET /api/v1/company` and `GET
  /api/v1/users` still resolve `CompanyScope(company_id=current_user.company_id)`
  exactly as before. The only cross-tenant path in the entire system is
  `/api/v1/platform/*`.
- **Suspend/reactivate blocks at `get_current_user` itself** — immediately
  after the home-company load, before permission resolution, returning 403
  `company_suspended`. This is deliberately stricter than the D-012
  unverified-email case (which resolves identity with HTTP 200): a
  suspended tenant's `/me` and every protected route are blocked outright.
- **Dual audit write.** `AdminCompanyService` writes two entries per
  cross-tenant mutation: one into the target tenant's own `audit_logs`
  (`action="company.suspended"`/`"company.reactivated"`/
  `"company.subscription_tier_changed"`, `metadata.cross_tenant=true`,
  `metadata.acting_company_id`) so that tenant's own compliance trail shows
  the external action, and one into a reserved pseudo-tenant scope
  (`CompanyScope(company_id="__platform__")`, `action="platform.<verb>"`),
  reusing the existing `AuditLogRepository` methods with zero new query
  code — confirmed safe because `AuditLogRepository.append` never
  dereferences the `companies` collection. No platform-audit *viewer* route
  was built this phase; a future one can query `"__platform__"` directly.
- **`subscription_tier`** becomes a locked `Literal["demo", "starter",
  "professional", "enterprise"]` at the new
  `UpdatePlatformCompanyRequest`/`UpdateCompanyStatusRequest` request-model
  boundary; `Company`/`CompanyUpdate` stay bare `str` (no schema migration).
  The platform-level `PATCH /api/v1/platform/companies/{id}` edits
  `subscription_tier` only — name/industry/contact/logo remain exclusively
  owned by the tenant's own `company_admin` via the existing 3.3
  `/api/v1/company` route, so no field ever has two competing write paths.
  This is the real lever behind 3.3's read-only tier display.
- **Scope is deliberately narrow.** The five endpoints never expose tenant
  business data (inspections, assets, permits) — no god-mode data browser,
  per the brief's explicit instruction. `roles/service.py`'s
  `platform_admin_not_grantable` guard and `users/service.py`'s rejection of
  the `super_admin` role key (both already in place since 3.1/3.2) remain
  the only ways to prevent `platform.admin` from leaking into normal
  company-scoped role/user management — 3.5 adds no new grant path there.
- **Admin UI** (`apps/admin/src/platform/`) mirrors the 3.4 `apps/admin/src/audit/`
  hook-plus-page shape: `platform-data.ts` (`usePlatformCompaniesData`) owns
  list/stats fetch state and the three mutation calls; `platform-page.tsx`
  composes stat tiles, a `DonutChart` (D-020) active/suspended breakdown,
  and a `TableShell` companies list; `platform-company-modal.tsx` holds the
  detail view, tier edit, and suspend/reactivate action. A new shared
  `ConfirmDialog` primitive (`design-system/primitives.tsx`) is this phase's
  extracted-on-second-consumer addition (mirroring Checkbox in 3.2,
  FilterChip in 3.4) — 3.1's inline `confirmingStatus` pattern was the only
  prior "strong confirm" precedent, and this action (suspending a whole
  tenant) is consequential enough to earn its own component; 3.1's own code
  was left untouched. The route (`/platform`) is gated by
  `RequirePermission permission="platform.admin"`; `nav-config.tsx` gains
  its own "Platform" group (not folded into Administration) so the
  tenant/platform boundary is visually distinct before the page's own
  "Platform" badge ever renders — visible only to `super_admin`.
- **Mobile is explicitly out of scope**, extending the 3.1/3.2 (D-023/D-026)
  mobile-read-only precedent to an entire module rather than a subset of
  actions: platform administration is a desk task, not a field task.

### Phase 4.1 Asset Data Model, Facility/Area Hierarchy, and Backend CRUD

- **Hierarchy (locked).** `facilities` (`TenantDoc`: name, sector, gps_lat/gps_lng,
  address, timezone defaulted from the company's own timezone at creation,
  status) → `areas` (`TenantDoc`: facility_id, name, code, description) →
  `assets` (`TenantDoc`: the core record). Assets additionally carry an
  optional `parent_asset_id` self-reference for component/sub-asset nesting
  (e.g. a motor inside a pump) instead of a separate rigid component
  collection — most assets have a null parent. This is the first real
  implementation of the `assets.read`/`assets.write` permission keys, which
  existed as unused catalog placeholders since Phase 0.4.
- **Asset record.** Identity (`facility_id`, nullable `area_id`, nullable
  `parent_asset_id`, `asset_tag`, reserved nullable `qr_code_id` for 4.5),
  descriptive fields (`name`, `category`, `manufacturer`, `model`,
  `serial_number`, `installation_date`, `description`), location
  (`gps_lat`/`gps_lng`, nullable — the UI falls back to the parent facility's
  coordinates), the `current_status` rollup (`Healthy | Warning | Critical`,
  defaults `Healthy` — the value the future "Critical Assets" dashboard KPI
  reads), and reserved-empty media/reference arrays (`photos`, `documents`,
  `manuals`, `model_3d_url`) populated by later phases (4.3 photos, 13 the
  digital twin).
- **`current_status` vs. the future manual-status-log (explicit
  separation).** The client spec's Excellent/Good/Fair/Poor/Critical +
  temperature/pressure/noise/vibration/leak manual readings are a
  time-series, deliberately NOT built in 4.1 and NOT embedded on the asset
  record — they belong to a future `asset_status_logs` collection. `assets`
  carries only the simple 3-state rollup. **Resolved in Phase 7.7:** the
  manual-status log ended up living on the *inspection* record
  (`Inspection.readings`, spec section 9), not a separate
  `asset_status_logs` collection — the phase brief redirected it there
  since readings are logged as part of an inspection, not on their own
  timeline. `assets.current_status` still carries only the simple 3-state
  rollup, now derived from `readings.condition` on inspection completion;
  see "Phase 7.7 Manual Status Readings" below.
- **Category is an extensible catalog, not a fixed schema enum.**
  `app/assets/constants.py`'s `ASSET_CATEGORIES` tuple (the ten spec
  categories plus `Other`) is checked in the service layer
  (`is_valid_asset_category`), mirroring 3.3's `INDUSTRY_CHOICES`/
  `is_valid_industry` pattern exactly — adding a category later is a
  one-line constant change, never a migration. `category == "Other"`
  requires a non-empty `category_other` free-text subtype.
- **History is resolved by reference, never embedded.** No
  `inspection_history`/`maintenance_history` arrays exist on `Asset`.
  `GET /api/v1/assets/{id}/history` (`app/api/v1/assets.py`) returns a
  real, correctly-shaped, always-empty `AssetHistoryPage` today — the
  contract future inspection/work-order modules fill by querying their own
  collections `WHERE asset_id == ...`, not by writing into this response.
- **Soft delete (new pattern in this codebase).** Every prior
  `TenantRepository.delete()` (Users' status toggle aside) is a hard delete.
  Facilities/areas/assets instead get a new `TenantRepository._soft_delete()`
  base helper (`app/db/repositories/base.py`) that stamps `deleted_at`
  and writes a `.deleted` audit action identical in shape to a hard delete's
  — the row stays queryable by id (so a stale reference still resolves) but
  every service treats `deleted_at is not None` as "not found." Deleting a
  facility/area that still has any non-deleted child rows returns a `409`
  (`facility_has_children`/`area_has_children` with the child count),
  mirroring the existing `409 role_has_assigned_users` (D-024) precedent —
  the simpler of the two choices the brief allowed. Soft-deleting an asset is
  never blocked by child sub-assets (`parent_asset_id` pointing at it): the
  parent row still resolves after soft-delete, so no reference actually
  breaks — a deliberate, documented choice, not an oversight.
- **`GET /assets` query strategy (the one new query pattern this phase
  adds).** Every prior list route (Users/Roles/Audit) reads the full
  company-scoped collection in one query and filters/sorts/paginates in
  Python (D-019's "small tenant dataset" reasoning). Assets can be far
  larger per tenant, so `AssetRepository.query()` pushes **one** equality
  filter to Firestore — priority `facility_id` → `category` → `current_status`
  — combined with `company_id ==` and `order_by(created_at, DESC)`; the
  three composite indexes this needs, plus a plain `company_id+created_at`
  baseline, are committed in `infra/firebase/firestore.indexes.json`. Any
  *other* simultaneously-requested filter (`area_id`, `parent_asset_id`, a
  second equality dimension, free-text search over
  name/asset_tag/serial_number, and any sort other than the default) is
  applied in-memory over that already-bounded read
  (`ASSET_QUERY_CAP = 5000`, matching the D-019/D-029 backstop-cap
  convention), then paginated with the existing base64 id-cursor idiom from
  `UserManagementService`. Facilities and Areas stay on the plain
  full-list-then-filter-in-Python pattern — their per-tenant cardinality is
  headcount-sized, not asset-sized.
- **Referential integrity lives in the service layer, not the
  repository**, exactly like every prior module: creating an area/asset
  requires its `facility_id` to resolve in the same tenant and not be
  soft-deleted; an asset's `area_id`, if set, must belong to that same
  facility; a `parent_asset_id` must resolve in the same tenant and can
  never equal the asset's own id. Cross-tenant references are impossible by
  construction — every lookup goes through the same `CompanyScope`-gated
  `get()` every other repository already uses.
- **Permissions.** `facilities.read`/`facilities.write`/`areas.read`/
  `areas.write` were added to the Phase 0.4 catalog alongside the
  already-existing `assets.read`/`assets.write`. `company_admin`/
  `super_admin` inherit them automatically (both derive from
  `ALL_PERMISSION_KEYS`); `operations_manager` gained all four (mirroring
  its existing `assets.read`/`assets.write`); `field_inspector`,
  `maintenance_technician`, `hse_manager`, and `executive` gained the two
  `.read` keys only (mirroring their existing `assets.read`) — no role's
  `assets.*` grants changed. As with every previous permission addition,
  already-registered real tenants need one `reconcile_roles.py` run to pick
  up the new grants; the two demo tenants get them for free on the next
  seed run.
- **Backend surface** (`app/facilities/`, `app/areas/`, `app/assets/`, each
  with a thin-route/fat-service split identical to `app/company/`/
  `app/roles/`): full CRUD + soft-delete for facilities and areas; full
  CRUD + soft-delete + the history stub for assets. Seed
  (`apps/api/scripts/seed.py`) idempotently creates 2 demo facilities, 4
  demo areas, and 11 demo assets spanning every category (including one
  `Other` with a subtype) and all three `current_status` values for the
  Acme demo tenant only, using deterministic ids so re-running reconciles
  rather than duplicates — one asset (`M-501`) is deliberately seeded as a
  sub-asset of another (`P-101`) to exercise the self-nesting seam.

### Phase 4.2 Asset List + Detail UI (Admin + Mobile)

- **First read-only browse UI over the 4.1 hierarchy.** Both clients gained
  an Asset Overview experience: a dense filterable/searchable asset list and
  a rich, tabbed asset detail view, driven entirely by the real 4.1
  endpoints and seed data. No create/edit/photo upload (4.3), KPI widgets
  (4.4), or QR scanning (4.5) — this phase is strictly browse.
- **Admin surface** (`apps/admin/src/assets/`, mirroring the 3.1/3.4
  hook-plus-page shape): `assets-data.ts` (`useAssetsData`) fetches the
  paginated/filtered asset list plus a one-shot, unpaginated facility/area
  directory (limit 100) used both as filter-dropdown options and as an
  `id → name` lookup — the asset list/detail payloads only ever carry
  `facilityId`/`areaId`, never names. `assets-page.tsx` is the dense table
  (asset_tag mono, name, category badge, facility→area breadcrumb,
  `StatusPill` mapped 1:1 from `Healthy|Warning|Critical`, manufacturer/model,
  relative last-updated) with a cascading facility→area filter (area options
  are client-filtered from the same one-shot fetch, no new endpoint) and the
  existing filter-chip/"Clear all" pattern from 3.4. `asset-detail-page.tsx`
  is the **first dynamic-segment route in the admin app**
  (`apps/admin/src/app/(protected)/assets/[id]/page.tsx`, Next.js 15 async
  `params`), rendering 5 tabs: Overview (all descriptive fields, GPS as a
  coordinates readout + external Google Maps link — see D-035 — parent/child
  asset links via `listAssets({parentAssetId})`, since `AssetDetail` carries
  no `childAssetIds` field), Inspections/Work Orders (static honest empty
  states naming the future phase), History (calls
  `GET /assets/{id}/history`, renders its always-empty 4.1 stub), and Media
  (gallery shell + empty state, reads the real `photos`/`documents`/`manuals`
  arrays so it stops being empty automatically once 4.3 ships uploads). The
  Edit button is present but disabled with a "coming in 4.3" tooltip, never a
  dead link. `AuthContextValue`/`AuthProvider` (`apps/admin/src/auth/
  auth-context.tsx`) gained a new `AssetsApiClient` type
  (`listAssets`/`getAsset`/`getAssetHistory`/`listFacilities`/`getFacility`/
  `listAreas`/`getArea`) alongside the existing per-module API-client types,
  and `apps/admin/src/api/client.ts` wires the generated `AssetsApi`/
  `FacilitiesApi`/`AreasApi` into `FevApiClient` the same way every prior
  module did.
- **`nav-config.tsx`'s `findNavItem` now prefix-matches** (reusing the same
  rule `isRouteActive` already used for sidebar highlighting) instead of
  requiring an exact string match — a real, if minor, defect this phase
  exposed: the shell header/breadcrumb fell back to "Not found" on any
  dynamic child route (`/assets/{id}`) because the nav config only declares
  the parent `/assets` route. This is the first nested route under a nav
  item in this app, so no earlier phase hit the gap.
- **Mobile surface** (`apps/mobile/lib/assets/`): `assets_controller.dart`
  mirrors `UsersController`/`AuditController` exactly (filters, `LoadStatus`,
  `_requestId` race guard, `loadMore()`), plus the same one-shot facility/area
  directory fetch. `assets_screen.dart` mirrors `UsersScreen`'s search +
  `AppSelect` filter row + skeleton/empty/error + "Load more" shape, with the
  facility→area cascade.
- **New pattern: pushed-route asset detail, not a bottom sheet (D-034).**
  Every prior mobile "detail" (Users, Audit, Roles) is a `showAppModal`
  bottom sheet — fine for a handful of fields, but Asset detail's 5 tabs of
  real content don't fit one. `asset_detail_screen.dart` is reached via
  `Navigator.pushNamed(AppRoutes.assetDetail, arguments: assetId)` (a new
  `AppRoutes.assetDetail = '/assets/detail'` case in `app_routes.dart`,
  reading the id back via `ModalRoute.of(context)!.settings.arguments`, since
  `onGenerateRoute` switches on exact route names with no dynamic segments)
  instead of `showAppModal`. Its tabs are built directly with
  `TabBar`/`Expanded(child: TabBarView(...))` rather than the existing
  `AppTabs` primitive, whose `TabBarView` is a fixed 120px `SizedBox` too
  small for this content — `AppTabs` remains correct for its existing
  showcase-only use.
- **`ApiContract`/`ApiService`** (`apps/mobile/lib/api/api_service.dart`)
  gained the mirrored `getAssets`/`getAsset`/`getAssetHistory`/
  `getFacilities`/`getFacility`/`getAreas`/`getArea` methods, following the
  identical try/`DioException`/`_typedError` shape every existing method
  uses. Every test file's hand-rolled `FakeApi`/`_IdentityApi`/`_UnusedApi`
  implementing `ApiContract` needed the 7 new methods stubbed
  (`UnimplementedError()` where unused) to keep compiling — this touched 8
  pre-existing test files with no behavior change.
- **Reserved-tab contract (the seam Phases 7/11/4.3 fill).** Both clients'
  Inspections/Work Orders/History/Media tabs render real, honest empty
  states today — never fabricated data. Phase 7 (inspections) and Phase 11
  (work orders) fill their tabs by querying their own future collections
  `WHERE asset_id == ...`, exactly like 4.1's History-by-reference decision
  (D-033); Phase 4.3 fills Media by populating the already-read
  `photos`/`documents`/`manuals` arrays. No UI code changes are anticipated
  for those tabs to stop being empty — only real data starting to exist.
- **No Google Maps Platform integration was added** (D-035) — GPS renders as
  a `lat, lng` mono readout plus a plain external link to
  `https://www.google.com/maps?q={lat},{lng}` on both clients.

### Phase 4.3 Asset Writes and Media

- Admin and mobile reuse one asset form contract for create/edit, with
  facility-scoped area choices, server-authoritative `assets.write`, and
  tenant/category/parent validation in `AssetManagementService`.
- Asset media extends D-027's private Storage boundary. Binary objects use
  `companies/{company_id}/assets/{asset_id}/{kind}/{uuid}_{filename}`;
  Firestore stores metadata only. Reads materialize fresh one-hour signed
  URLs, while upload/delete stay behind FastAPI and are audited.
- `photos`, `documents`, and `manuals` are structured metadata arrays.
  Repository writes use Firestore `ArrayUnion`/`ArrayRemove`, preventing
  concurrent uploads from replacing the entire array.
- Native field runners now exist for Android and iOS so camera capture is a
  deployable mobile capability, not a web-only facade. Both use the permanent
  store/Firebase identity `com.flacronenterprises.energyverse`; Android uses
  it for `namespace` and `applicationId`, iOS for
  `PRODUCT_BUNDLE_IDENTIFIER`, and both display `EnergyVerse`. iOS declares
  camera and photo-library usage strings for asset reference media.

- Durable on-device operation queue
- Background sync worker
- Conflict detection and resolution policy: **locked in Phase 7.1** — see
  "Phase 7.1 Inspection Data Model, Backend CRUD, and Lifecycle" above.
  Client-generated UUID + idempotent upsert-by-id + a monotonic `revision`
  int (not a timestamp, to be immune to cross-device clock skew);
  `PATCH`'s `expected_revision` gives a stale-write `409
  revision_conflict`; last-writer-wins-by-revision is the contract 7.2's
  engine implements against — not built here, only the API/model support.
- Retry, idempotency, and failure recovery: _To be defined_ (7.2)

### Phase 4.4 Dashboard KPI Widgets and Pluggable Widget Framework (resolves 2.3)

- **The widget contract.** Every dashboard widget is
  `{ id, title, requiredPermission, minTier?, render/builder }` (admin:
  `DashboardWidget` in `apps/admin/src/dashboard/widget-registry.tsx`;
  mobile: `DashboardWidgetSpec` in `apps/mobile/lib/dashboard/widget_registry.dart`).
  A module registers a widget once via `registerWidget`/`registerDashboardWidget`
  — registration is a no-op on a duplicate `id`, so re-importing/re-registering
  (hot reload, repeated `didChangeDependencies` calls) is always safe.
- **The registry + grid.** `getRegisteredWidgets()`/`registeredDashboardWidgets()`
  expose the module-level list; `DashboardWidgetGrid` filters it by the
  viewer's permissions (0.6 `can()`/`PermissionAccess.can()`) and by
  subscription tier (`minTier`, compared against a small local
  `SUBSCRIPTION_TIERS`/`subscriptionTiers` ordering mirroring
  `apps/api/app/models/api.py`'s `SUBSCRIPTION_TIERS` — the hook is real and
  wired today even though no widget sets `minTier` yet; enforcement becomes
  meaningful once a billing phase exists) then renders each widget in its
  own failure boundary — a React error boundary (`WidgetErrorBoundary`) on
  admin, a build-time try/catch (`_WidgetBoundary`) on mobile — so one
  widget crashing renders only its own "Couldn't load this widget." tile,
  never blanks the rest of the dashboard. This replaces 2.2's hardcoded
  `ReservedKpiRegion`/`_ReservedKpiRegion` array with the same visual
  contract, now data-driven.
- **How to add a widget (future modules — 7/10/11).** Call
  `registerWidget`/`registerDashboardWidget` from the new module's own file
  with its real `requiredPermission`, import that file once (admin: a
  side-effect `import` in `dashboard-page.tsx`; mobile: call the module's
  `register...Widgets()` function from `_DashboardScreenState.didChangeDependencies`),
  and delete that module's entry from `reserved-widgets.tsx`/
  `reserved_widgets.dart`. No dashboard-page/grid code changes are needed.
- **Asset widgets are the first real registered consumers**
  (`apps/admin/src/assets/asset-widgets.tsx`,
  `apps/mobile/lib/assets/asset_widgets.dart`), each independently fetching
  the new `GET /api/v1/dashboard/assets-summary` endpoint (own
  loading/error/empty state per widget, by design — a pluggable widget is
  self-contained): **Total Assets** and **Critical Assets** (crimson/
  `statusStrong-critical` emphasis, tapping either navigates to the 4.2
  asset list pre-filtered — admin via `/assets?status=Critical` query param,
  read once on mount by `assets-page.tsx`/`useAssetsData`; mobile via
  `Navigator.pushNamedAndRemoveUntil(AppRoutes.assets, ..., arguments: 'Critical')`,
  read by `AssetsScreen.initialStatus` → `AssetsController`'s constructor),
  and **Asset Condition**, a Healthy/Warning/Critical breakdown using the
  existing chart wrapper (`DonutChart` on admin per D-020; mobile's
  `chart.dart` gained its own `DonutChart`/`DonutSlice` to reach the same
  reusable-chart contract mobile previously lacked).
- **Backend aggregation (D-039).** `AssetRepository.count()` issues a
  Firestore `count()` aggregation query (never downloads a document) scoped
  by `company_id` + `deleted_at == None` plus at most one more equality
  filter (`current_status`/`category`/`facility_id`). `AssetManagementService
  .get_dashboard_summary()` fires 4 status/total counts plus one count per
  `ASSET_CATEGORIES` entry and one per tenant facility, concurrently
  (`asyncio.gather`). `GET /api/v1/dashboard/assets-summary` is gated by its
  own `assets.read` dependency (not `reports.read` — the whole-dashboard
  gate from 2.2), matching the framework's per-widget permission model.
- **Mobile role-based KPI subset (mobile-only layout choice).**
  `field_inspector`/`maintenance_technician` see a task-focused subset
  (Total + Critical only, no condition chart); every other role holding
  `assets.read` (`operations_manager`, `hse_manager`, `executive`,
  `company_admin`, `super_admin`) sees the full set. Implemented as a
  `filter` callback passed to `DashboardWidgetGrid` in
  `dashboard_screen.dart` (`_widgetVisibleForRole`), layered on top of — not
  instead of — the permission gate. Admin has no equivalent subset (every
  `assets.read` holder sees the full set) since the spec's task-focused/
  full-set split was explicitly a mobile field-role concern.
- **Not-yet-built modules** (Work Orders, Permits, Safety & Incidents)
  render through the same registry via `reserved-widgets.tsx`/
  `reserved_widgets.dart` — each an honest "`<Module>` metrics appear once
  the `<Module>` module is enabled" tile, gated by that module's own future
  permission, never a placeholder number (continuing D-019's no-invented-
  data rule).

### Phase 4.5 QR Code Generation and Scanning

- **`qr_code_id` generation (D-041).** Every asset gets an opaque,
  unguessable `qr_code_id` (`secrets.token_urlsafe(16)`, ~128 bits of
  entropy) — never the asset's own UUID, so a scanned/printed label can't
  be used to enumerate a tenant's asset ids. `AssetManagementService
  .create_asset()` generates one via `generate_unique_qr_code_id()`
  (`app/assets/qr.py`), which re-checks `AssetRepository.get_by_qr_code()`
  for a collision before accepting a candidate (defense in depth over the
  entropy alone, mirroring the codebase's existing "verify, don't just
  trust randomness" convention). `scripts/seed.py` calls the same helper
  for every demo asset, so freshly seeded tenants never carry a null code.
- **Backfill (`scripts/backfill_qr_codes.py`).** A one-time, idempotent,
  cross-tenant script: `AssetRepository.list_missing_qr_codes()` finds
  every active asset (any company) with `qr_code_id == null`, assigns one
  via the same generator, and persists it through
  `AssetRepository.backfill_qr_code()` (which also writes an
  `asset.qr_backfilled` audit entry). Re-running finds nothing left to do.
  Verified against the real `thinking-case-469504-c0` project — backfilled
  11 pre-existing Acme assets in one run.
- **The deep-link payload (D-042).** The QR image encodes
  `{APP_BASE_URL}/qr/{code}` (a new `Settings.app_base_url`, defaulting to
  the admin app's own `http://localhost:3000` dev origin — set to the real
  deployed origin in production). This one URL serves three consumers
  without a payload change: the admin's own `/qr/[code]` page resolves and
  redirects directly; a generic phone camera outside the app opens that
  same admin page; and once a real production domain + Universal
  Links/App Links domain-association files exist (not part of this
  phase — no such infrastructure exists in the repo yet), the identical
  URL becomes a deep link into the native app with zero backend change.
  Mobile's own camera scan never depends on OS-level link registration: it
  decodes the raw scanned text in-app and extracts the trailing path
  segment as the code (`extractQrCode()`,
  `apps/mobile/lib/qr/qr_scan_controller.dart`), so a bare manually-typed
  code and a full scanned URL both resolve identically.
- **Resolve endpoint and the scan surface (D-042).**
  `GET /api/v1/qr/{code}/resolve` (`app/api/v1/qr.py`) is gated by the
  same `assets.read` dependency as every other asset-read route.
  `AssetManagementService.resolve_qr_code()` looks the code up
  cross-tenant (`AssetRepository.get_by_qr_code`, which deliberately
  bypasses `CompanyScope`, since the scanning user's company isn't known
  from the code alone) and rejects — with the identical `404
  qr_code_not_found` used for a genuinely unknown code — any match whose
  `company_id` doesn't equal the caller's own, or that's soft-deleted.
  Never a 403: a distinguishable cross-tenant response would let a scan
  probe for a code's existence outside the caller's tenant. Every
  successful resolve is audited (`asset.qr_scanned`,
  `AssetRepository.record_scan`). The response (`QrScanResult`) nests the
  full `AssetDetail` (info, status, photos/documents/manuals) plus
  `inspections_total`/`maintenance_total`/`work_orders_total`, all
  hard-zeroed today — an honest empty scan surface, matching the 4.1
  `AssetHistoryPage` precedent, until Phase 7/11 populate those counts for
  real. There is no `safety_instructions` field on `Asset` yet, so the
  scan surface has nothing to render there rather than inventing one
  ahead of its own phase.
- **Printable label (`GET /api/v1/assets/{id}/qr`, gated by
  `assets.read`).** Returns `{qr_code_id, url, asset_tag, name}` as plain
  JSON — no backend image-rendering dependency. The admin asset detail
  page's new "QR Code" tab (`apps/admin/src/assets/qr-label-tab.tsx`)
  renders the actual QR bitmap client-side from `url` via `react-qr-code`
  (a small SVG-only library, no canvas), with **Print** (a scoped
  `window.print()` — `[data-print-area]` CSS in `globals.css` hides every
  other page element so only the label prints) and **Download** (serializes
  the rendered `<svg>` directly to a `.svg` file — chosen over rasterizing
  to PNG specifically to avoid a canvas dependency and the jsdom
  canvas-mocking cost in tests, and an SVG prints at any size without
  pixelation, which a fixed-resolution PNG wouldn't).
- **Admin `/qr/[code]` route** (`apps/admin/src/app/(protected)/qr/[code]/`,
  feature component `apps/admin/src/qr/qr-resolve-page.tsx`): calls
  `resolveQrCode`, redirects to `/assets/{id}` on success, and renders a
  branded not-found/error state otherwise — reachable by any authenticated
  `assets.read` holder (`RequirePermission`), same as every other admin
  route.
- **Mobile scan surface (`apps/mobile/lib/qr/`) — the primary scan
  surface per spec.** `QrScanScreen` wraps `mobile_scanner`'s
  `MobileScanner` camera widget behind an injectable `scannerBuilder` slot
  (defaults to the real camera view) so widget tests never have to mount
  a real camera plugin — live scanning itself is verified on a physical
  device by hand, per D-040's evidence policy; the pure `cameraErrorMessage()`
  function is unit-tested directly for the permission-denied/unsupported/
  generic camera failure copy. A manual code-entry fallback shares the
  exact same `QrScanController.resolve()` path as a camera detection.
  On a successful resolve, `QrScanResultScreen` renders the same scan
  surface fields as admin (info/status/media, reserved honest-empty
  Inspections/Maintenance/Work-Orders sections) plus a **Start
  Inspection** button that is a clearly-labeled stub: it pushes the
  existing `ComingSoonScreen(moduleName: 'Inspections')` (the same "on the
  roadmap" component every other unbuilt nav module already uses), not a
  fake inspection flow. A "Scan QR code" quick action on the dashboard
  (gated by `assets.read`, alongside the existing Users/Assets-demo
  actions) is the discoverable entry point.
- **Camera permission (Android/iOS).** `CAMERA` added to
  `AndroidManifest.xml` (`<uses-feature android:required="false"/>` so a
  camera-less device can still install); iOS's existing 4.3
  `NSCameraUsageDescription` (added for asset photo capture) was extended
  to also mention QR scanning rather than adding a second usage string.

### Phase 7.1 Inspection Data Model, Backend CRUD, and Lifecycle

- **Sync-ready by design (the seam 7.2's offline engine builds on).**
  `inspections` documents use a **client-generated UUID** as the Firestore
  document id (validated server-side via `uuid.UUID(value)`) so a draft
  created on-device offline never waits for a server id — the create route
  is an **idempotent upsert keyed by that id**
  (`InspectionRepository.upsert_draft`): a byte-identical resubmit is a
  true no-op (same record, same `revision`, no audit entry); a resubmit
  with different identity fields (`asset_id`, `inspection_type`, `title`,
  `notes`, GPS, `client_created_at`, `device_id`, `origin`) conflicts with
  `409 inspection_id_conflict`. Every inspection also carries
  `client_created_at` (client-stamped) alongside the usual
  `created_at`/`updated_at` (server-stamped), plus `device_id`/`origin`
  for conflict diagnostics.
- **The conflict-resolution contract (D-0xx, locked here for 7.2 to
  implement).** A monotonic integer `revision` (not a timestamp) is the
  source of truth — chosen specifically because this dev environment has
  already hit a real cross-device clock-skew bug, and a client clock can't
  be trusted for ordering. `revision` starts at 1 on create and increments
  by exactly 1 on every accepted mutation (update, checklist-template
  assignment, lifecycle transition, soft delete); a true no-op change
  never bumps it. `PATCH /inspections/{id}` accepts an optional
  `expected_revision`: a mismatch returns `409 revision_conflict` with
  `{expected_revision, current_revision}` so the caller can re-fetch and
  reapply. 7.2's offline engine is expected to implement last-writer-wins
  by comparing revisions, retrying a conflicted local edit against the
  freshly fetched current revision — not built here, only the contract.
  `POST /inspections` (the upsert-create) deliberately returns a fixed
  `200`, never `201` — a new pattern versus every other create route in
  this codebase (which return `201`), since this route can't statically
  know whether a given call created a new record or replayed an existing
  one.
- **Lifecycle.** `status`: `draft → in_progress → completed`, plus
  `cancelled` (reachable from `draft`/`in_progress`, not part of the
  brief's three states but added so an abandoned/wrong-asset draft can be
  closed out instead of lingering forever and polluting reports). `start`
  sets `started_at`; `complete` validates every **required** item in
  `checklist_items_snapshot` has a non-empty response in
  `checklist_responses` (422 `checklist_incomplete` with
  `missing_item_ids` otherwise) and sets `completed_at` — an inspection
  with no checklist template ever assigned has nothing to validate and
  completes cleanly (matches the ad-hoc "Start Inspection" flow below,
  which never picks a template). `completed`/`cancelled` are terminal:
  any further `PATCH`/checklist-assignment attempt is `409
  inspection_locked`. `inspector_id` is always the creating actor's uid in
  7.1 — there is no assignment/dispatch capability yet (deferred to
  7.11's admin review UI, matching the operations_manager RBAC note
  below).
- **Checklist templates: light versioning + inspection-time snapshot.**
  New `checklist_templates` collection (`app/checklists/`,
  `ChecklistTemplateRepository`/`ChecklistTemplateService`, thin-route/fat-
  service like every prior module), each with a `category` (`"Generic"` or
  one of `app.assets.constants.ASSET_CATEGORIES`), an `items[]` array
  (`id, label, item_type: boolean|numeric|text|select, required, options,
  help_text`), and a lightweight `version: int` that the repository bumps
  by exactly 1 on **every** accepted update (no separate version-history
  collection). When a template is assigned to an inspection
  (`POST /inspections/{id}/checklist-template`), the inspection stores the
  template id **and a snapshot of its items at that moment**
  (`checklist_items_snapshot`) plus the template's current `version` — so
  editing a template later never corrupts a past inspection's answered
  checklist, and the snapshot's `checklist_template_version` gives
  diagnostic provenance ("answered against v3, template is now v7").
  Assignment is rejected with `422
  checklist_template_category_mismatch` unless the template's category is
  `"Generic"` or matches the asset's own category.
- **Checklist responses are accepted by the API now, tested directly —
  no capture UI yet.** The brief reserves `checklist_responses[]` as a
  "fill it in 7.3" container, but `complete`'s own required-item
  validation needs responses to exist somewhere to be testable at all.
  Resolution: `PATCH /inspections/{id}` validates and accepts
  `checklist_responses[]` directly against the API (unknown `item_id`,
  duplicate `item_id`, or a value that doesn't match the item's
  `item_type` all 422 as `checklist_response_invalid`; accepted responses
  are stamped server-side with `answered_by`/`answered_at`, never
  client-trusted) — proven by API-level tests, not a screen. Neither
  admin nor mobile ships a checklist-filling screen in 7.1; that
  interactive capture UI is 7.3's job.
- **Asset history is now real (resolves D-033's placeholder).**
  `AssetManagementService.get_asset_history` no longer returns a
  hard-coded empty page — it queries `InspectionRepository.query(scope,
  asset_id=...)`, filters to `status == "completed"`, sorts by
  `completed_at` desc, and paginates with the existing cursor idiom. No
  history is embedded on `Asset` itself; this is exactly the
  query-by-reference seam D-033 reserved. `GET /assets/{id}/history`
  gained `cursor`/`limit` query params to support this.
- **Query pattern mirrors 4.1's assets exactly.**
  `InspectionRepository.query()` pushes **one** equality filter to
  Firestore (priority `asset_id` → `facility_id` → `status`) plus
  `company_id ==` and `order_by(created_at, DESC)`; the four composite
  indexes this needs (a plain `company_id+created_at` baseline plus one
  each for `asset_id`/`facility_id`/`status`) are committed in
  `infra/firebase/firestore.indexes.json`. Any other filter
  (`inspector_id`, a date range) is applied in-memory over that bounded
  read, then paginated with the same base64 id-cursor idiom every prior
  list route uses. `checklist_templates` needs no new index — per-tenant
  cardinality is small, so it stays on the plain full-list-then-filter
  pattern like Facilities/Areas.
- **Permissions.** New `checklist_templates.read`/`checklist_templates
  .write` join the already-existing (previously unused) `inspections
  .read`/`inspections.write` placeholders from 0.4. `company_admin`/
  `super_admin` inherit both automatically; `operations_manager` gains
  both (template management is an ops responsibility per the client
  spec's §2 role table); `field_inspector`, `maintenance_technician`,
  `hse_manager`, and `executive` gain `checklist_templates.read` only,
  mirroring their existing `inspections.read`-only pattern. **Existing
  `inspections.*` grants are deliberately untouched** — the client spec's
  "Ops Manager assigns" language is real, but no assignment feature
  exists until 7.11's admin review UI actually needs it; granting
  `inspections.write` to `operations_manager` now would be permission
  creep ahead of the feature it's for. As with every prior permission
  addition, the one real non-demo tenant needs a `reconcile_roles.py` run
  to pick up the new grants; the demo tenants get them for free on the
  next seed run.
- **Seed** (`apps/api/scripts/seed.py`): 3 checklist templates (Generic,
  Pump, Tank) with deterministic `uuid.uuid5`-derived ids (so seed data
  satisfies the same UUID validation the API enforces on inspection ids
  too), and 3 demo inspections walked through their real lifecycle via
  direct repository calls — one **completed** Pump inspection with every
  required item answered (so 4.1's asset-history seam has real data to
  render), one **in_progress** Tank inspection with a partial response
  set, and one templateless **draft** Compressor inspection mirroring
  exactly what mobile's "Start Inspection" flow below produces. Seeded
  last, after facilities/areas/assets/templates all exist.
- **Mobile "Start Inspection" is a real draft-creation flow now**
  (`apps/mobile/lib/qr/qr_scan_result_screen.dart`), no longer a stub
  pushing `ComingSoonScreen`. Tapping it generates a client UUID (new
  `uuid` pub dependency), calls `createInspection` with
  `inspection_type: ad_hoc` (hardcoded — no picker yet) and
  `device_id`/`gps_lat`/`gps_lng` left `null` (no device-info/geolocation
  package exists in this app yet — explicitly deferred, not an
  oversight), then pushes the real, read-only
  `InspectionDetailScreen` on success or surfaces a snack-bar error and
  stays put on failure. `QrScanResultScreen` takes an optional injectable
  `api` constructor param as a testing seam (mirrors `qr_scan_screen
  .dart`'s injectable `scannerBuilder` precedent for the same reason:
  widget tests need to drive a real API call without a full auth/app
  context).
- **Minimal UI, both clients — list + read-only detail only.** Admin
  gains `apps/admin/src/inspections/` (list page with a status filter;
  a read-only detail page showing lifecycle, checklist snapshot +
  responses, with Cancel/Delete gated by `inspections.write` — no
  Start/Complete buttons yet, since there's no checklist-filling UI to
  pair them with) and `apps/admin/src/checklist-templates/` (list +
  full-page create/edit form, gated by the new permission), replacing the
  `ComingSoonScreen` stub at `/inspections` and adding a new nav entry for
  Checklist Templates. Mobile mirrors this with
  `apps/mobile/lib/inspections/` (list + read-only detail, reached via
  the same pushed-route pattern D-034 established for asset detail) — no
  mobile checklist-template screens at all, since `field_inspector` only
  ever gets `checklist_templates.read`. Both clients' asset-detail
  Inspections tab now renders real data (`listInspections`/`getInspections`
  filtered by `assetId`) instead of the static "Phase 7" empty state.
- **Contracts.** New `InspectionsApi`/`ChecklistTemplatesApi` in both
  generated clients; admin's `client.ts` gained matching wrapper methods
  plus `InspectionsApiClient`/`ChecklistTemplatesApiClient` `Pick<>` types
  folded into the `apiClient` intersection; mobile's `ApiContract` gained
  `getInspections`/`getInspection`/`createInspection` as real interface
  methods (not an untestable extension-with-runtime-cast like
  `AssetWriteContract` — this write path needed to be fake-able for the
  "Start Inspection" widget tests, so it went directly on the interface),
  which meant every existing hand-rolled `FakeApi` test double across the
  mobile test suite needed the three new methods stubbed
  (`UnimplementedError()` where unused) to keep compiling.

### Phase 7.2 Offline Persistence and Sync Engine

- **Local store: Drift (SQLite), not Isar** (D-046) — the deciding factor
  was the existing mobile CI job having no native-binary-fetch step, which
  Drift's `sqlite3`/`sqlite3_flutter_libs` FFI backend doesn't need.
  `apps/mobile/lib/db/tables.dart` defines two tables:
  - `LocalInspections` mirrors `InspectionDetail`'s fields (checklist
    items/responses stored as JSON-blob TEXT columns via
    `standardSerializers`, not normalized child tables — the server never
    queries them relationally either) plus five **local-only** columns:
    `syncState` (`local_only|pending_sync|synced|conflict|error`),
    `baseRevision` (the last confirmed server revision, used as the next
    mutation's `expected_revision`), `errorMessage`, `lastAttemptAt`,
    `conflictServerSnapshot` (the full server `InspectionDetail` JSON
    fetched at conflict time).
  - `Outbox` is the pending-mutation queue: `sequence` (autoincrement,
    the FIFO replay order) — not `id` — is the table's actual primary key,
    since replay is strictly one row at a time in enqueue order across
    every inspection, not per-inspection. `mutationType` is one of
    `create|update|start|complete|cancel|assign_template`; `payload` is
    the serialized request object; `nextAttemptAt` doubles as both the
    backoff schedule and a "paused" marker (a sentinel far-future date)
    for a permanently-failed row, so the drain query and the
    manual-"sync now" bypass share one column instead of needing a
    separate paused flag.
  - Generated `*.g.dart` code is gitignored, not committed (unlike
    `packages/contracts`); the mobile CI job gained a
    `dart run build_runner build --delete-conflicting-outputs` step before
    `flutter analyze`.
- **`LocalInspectionsRepository`** (`apps/mobile/lib/inspections/
  local_inspections_repository.dart`) is the single facade every mobile
  read/write path for inspections goes through now — `InspectionsController`,
  `InspectionDetailScreen`, and `QrScanResultScreen` no longer call
  `ApiContract` directly for inspections at all (every other screen is
  unaffected; `FakeApi implements ApiContract` stays valid for those).
  - Reads: `watchInspections`/`watchInspection` are reactive Drift
    `.watch()` streams (no pagination against the local cache — that's a
    server-list-only concept); `refreshFromNetwork`/
    `refreshDetailFromNetwork` are best-effort background upserts that
    explicitly skip any row currently `pending_sync`/`conflict`/`error` so
    a background refresh never clobbers an in-flight local edit.
  - Writes always land locally first and enqueue a matching `Outbox` row
    in the same transaction, returning immediately — no network round
    trip in the critical path. `updateInspection` **coalesces** repeated
    edits into the same not-yet-attempted outbox row (merging field
    values) rather than stacking duplicates; a row already `attempts > 0`
    gets a fresh row appended instead, since it's already in flight.
    `completeInspection` re-validates every required checklist item
    locally first (mirroring `InspectionService.complete_inspection`'s
    check exactly) so a doomed completion never reaches the outbox at
    all.
  - `resolveConflict(id, keepLocal:)` implements the two-button
    resolution (D-047): `keepLocal: true` requeues the local edit as a
    fresh `update` against the conflict snapshot's revision; `false`
    overwrites the local row from the snapshot and drops every queued
    mutation for that inspection.
  - `reconcileSessionOwner(uid)` compares `uid` to whichever uid last
    owned this device's cache (persisted via `shared_preferences`,
    independent of Firebase's own session storage) and wipes local
    inspections+outbox on a mismatch — called from `main.dart` on every
    `AuthController` change where `currentUser` becomes non-null, not
    hooked to sign-out (sign-out alone can't know who signs in next).
  - Extends `ChangeNotifier` purely so `SyncEngine` can recompute a plain
    one-shot outbox count after every write without holding its own
    long-lived `watchOutbox()` subscription open — a `ChangeNotifier`'s
    listener list is plain callbacks, unlike a Drift query stream, whose
    cancellation defers real cleanup to an internal zero-duration `Timer`
    that (harmlessly, in production) doesn't run until the next event-loop
    turn. Under `flutter_test`'s fake-clock test binding, though, that
    deferred timer was still "pending" at test teardown for any widget
    that ever held a live outbox subscription open — which the app shell's
    offline banner does on every authenticated route. Recomputing a count
    via `repository.addListener(...)` instead of `watchOutbox()` avoids the
    Drift-stream-cancel path entirely for that cross-cutting signal; the
    genuinely reactive list/detail screens still use real watch streams
    and are fine, since only one full app-shell-wide subscription (not one
    per screen mount) needed to disappear.
- **`SyncEngine`** (`apps/mobile/lib/sync/sync_engine.dart`,
  `ChangeNotifier` + `InheritedNotifier` shape mirroring `AuthController`)
  drives the outbox drain loop:
  - Triggers: `connectivity_plus`'s connectivity stream (500ms debounced),
    app-resume (`WidgetsBindingObserver` in `main.dart`), a 2-minute
    periodic fallback, and manual "Sync now". A single `_draining` flag
    plus `_rerunKick`/`_rerunSyncNow` flags make the drain loop
    single-flight: a trigger that arrives mid-drain sets a flag consumed
    by the current loop's next iteration rather than spawning a second
    concurrent drain.
  - Per row: dispatch to the matching `ApiContract` method (this phase
    added `updateInspection`/`startInspection`/`completeInspection`/
    `cancelInspection`/`assignChecklistTemplate`, alongside 7.1's
    `createInspection`, as real interface methods per the 7.1
    `AssignChecklistTemplateRequest`-vs-`AssetWriteContract` precedent —
    every unrelated `FakeApi` test double across the suite needed the five
    new methods stubbed to keep compiling). On success, upsert the
    returned detail and mark `synced` (or stay `pending_sync` if more
    mutations remain queued for that id).
  - `network_error`/`request_cancelled` → transient: exponential backoff
    (30s → 60s → 2m → 4m → ... capped at 30min) via
    `markTransientFailure`, and **stop draining the rest of this pass**
    (a dropped connection fails every subsequent row identically).
  - `revision_conflict`/`invalid_transition` → re-fetch the current
    server record; if it already matches exactly what the queued mutation
    was trying to set, treat as success (a replay of an attempt that
    landed before the app died mid-request), not a conflict. Otherwise
    `markConflict`: drop every other queued mutation for that inspection
    (they were all computed against the same now-stale base) and surface
    the two-button resolution sheet.
  - Any other error (validation, 404) → `markPermanentError`: pauses that
    one row (via the `Outbox.nextAttemptAt` sentinel) for manual
    retry/discard, without blocking other inspections' rows.
- **Minimal UX**, all built on existing design-system primitives (no new
  ones): an app-wide offline/pending `StatusPill` in `AppShellScaffold`
  (hidden when online with an empty outbox); a per-inspection sync-state
  badge (`inspections_screen.dart`'s `syncStateBadge`, tappable when
  `conflict` to reopen the resolution sheet); the resolution sheet itself
  (`AppModal`, two buttons, no diff view); and a new
  `SyncQueueScreen` (`/inspections/sync-queue`, reachable from
  `InspectionsScreen`'s app-bar-area pending-count link) listing every
  outbox row with its mutation type/attempts/last error plus "Sync now"
  and per-item Retry/Discard.
- **Backend companion fix**: `assign_checklist_template` gained the same
  optional `expected_revision` guard `update` already had (D-047's
  "close the `assign` conflict gap" consequence) — `AssignChecklistTemplateRequest`
  gained the field, `InspectionRepository.assign_checklist_template` checks
  it against the current row exactly like `update` does, and the service
  raises the same `RevisionConflictError` → 409 `revision_conflict`. The
  generated Dart/TypeScript clients were regenerated to match (a local
  Windows file-lock blocked regenerating them on the dev machine itself;
  the equivalent CI job's Linux runner has no such lock, so its from-source
  regeneration was applied directly instead — see TESTING.md) and
  `LocalInspectionsRepository.assignChecklistTemplate` threads
  `baseRevision` through as `expected_revision`, same as `updateInspection`.

### Phase 7.3 Inspection Start Flow and Checklist Filling

- **Checklist-template auto-selection runs entirely offline** (D-048).
  `LocalInspectionsRepository` gains a `LocalChecklistTemplates` cache
  table (`id, category, name, version, itemsJson, updatedAt` — same
  JSON-blob-for-items convention as `LocalInspections.checklistItemsSnapshot`)
  and `refreshChecklistTemplatesFromNetwork()`, a best-effort background
  refresh (list + per-template detail fetch) triggered from `main.dart`
  right after sign-in resolves, alongside 7.2's `reconcileSessionOwner`.
  `selectChecklistTemplateForCategory(category)` then reads that cache
  synchronously: exact category match, most-recently-updated wins if more
  than one is active (the resolved tie-break question); falls back to the
  most-recently-updated `Generic` template if no category match exists;
  returns `null` (no template, an already-supported completable state) if
  neither is cached. No network call sits in the inspection-start path at
  all — the only network dependency is having refreshed the cache at some
  earlier point while online, which the sign-in hook makes the common case.
- **The asset's category now travels with the local draft.** A new
  local-only `LocalInspections.assetCategory` column (this repository's
  first schema migration, v1 → v2, `MigrationStrategy.onUpgrade` adding the
  column and creating `LocalChecklistTemplates`) is populated by
  `createDraft`'s caller — both entry points already have the asset object
  in hand — so the detail screen can select a template without an asset
  network fetch either.
- **The detail screen is interactive now** (`InspectionDetailScreen`,
  explicitly read-only since 7.2 — its own doc comment deferred this here).
  On load, a `draft` inspection auto-assigns its matching template (if
  none is set yet) and transitions to `in_progress` in one place — this
  covers both a genuinely fresh start and resuming a stale local draft
  from before this phase shipped, without two separate code paths. The
  checklist section renders per-item interactive input by `item.itemType`:
  `boolean` → Pass/Fail, `numeric` → a numeric field, `text` → a multiline
  field, `select` → options as a dropdown. (The model's real, already-locked
  types from 7.1/D-044 — not the phase brief's illustrative
  `pass_fail`/`rating` naming; `select` covers rating-style fixed scales
  via its `options` list, so no new wire type was needed.) Boolean/select
  save immediately; text/numeric debounce 500ms — every save is a single-item
  `updateInspection(id, checklistResponses: [thatOneItem])` call. A progress
  header ("answered / total · N required remaining") and a Complete button
  gated on a shared `missingRequiredItemIds` helper (extracted so the
  offline-authoritative check in `completeInspection` and the UI gate never
  drift apart) round out the screen. Reserved, visibly-disabled rows for
  photos/voice/readings/signature communicate the 7.4+ capture steps'
  eventual shape without faking them. There is no section grouping — the
  template model has no sections field, so snapshot array order is display
  order, exactly as the brief's own conditional ("if the template has it")
  anticipated.
- **New "Start Inspection" entry point:** the asset detail screen
  (`apps/mobile/lib/assets/asset_detail_screen.dart`) gains its own
  `inspections.write`-gated button beside "Edit", calling the same
  local-first `createDraft` + GPS-capture path the QR scan-result screen
  already used — previously QR scanning was the only way in.
- **Best-effort GPS capture** (`apps/mobile/lib/inspections/gps_capture.dart`,
  new `geolocator` dependency, Android `ACCESS_FINE_LOCATION`/
  `ACCESS_COARSE_LOCATION` and iOS `NSLocationWhenInUseUsageDescription`
  permission entries): checks/requests permission, reads a position with an
  8-second `LocationSettings.timeLimit`, and is wrapped in its own outer
  10-second `.timeout` — the permission-check calls ahead of the position
  read have no bound of their own and can hang rather than throw with no
  platform channel registered (which is exactly what a plain widget test
  looks like). GPS is optional server-side (`_validate_gps` only validates
  a value that's actually provided), so a denied/unavailable/timed-out
  reading never blocks starting an inspection.
- **Partial-response merge fix, not a design choice — a real bug found
  while building this phase's autosave.** `LocalInspectionsRepository
  .updateInspection` and `InspectionService.update_inspection` both
  replaced the entire `checklist_responses` array with whatever the
  request contained, rather than merging by `item_id`. That was harmless
  under 7.2 (nothing ever called `updateInspection` with a checklist
  subset), but is exactly what continuous per-item autosave does — every
  answer would have silently erased every other already-answered item.
  Fixed on both layers as an upsert-by-`item_id` (D-048): the mobile
  repository merges before writing locally and before building the outbox
  payload; the backend service merges the validated incoming responses
  into the current stored array. A second, related fix surfaced while
  testing the merge round-trip: `_upsertFromServer` stored
  `detail.status.name`/`detail.inspectionType.name` — built_value's
  camelCase *Dart identifier* (`inProgress`) — instead of the wire value
  (`in_progress`) every local write path and this phase's new
  status-string comparisons use; invisible before now because `draft`,
  `completed`, and `cancelled` happen to be spelled identically either
  way. A new `dartEnumNameToWire` helper (the inverse of the existing
  `wireToDartEnumName`) fixes the one call site.
- **No contracts regeneration was needed this phase** — no route or
  schema changed; `ChecklistTemplatesApi`'s list/get methods already
  existed in the generated Dart client since 7.1, just never wired into
  the app-level `ApiContract`/`ApiService` facade until now. No new audit
  action was needed either — the existing `update()`/`_write_audit` path
  (Phase 0.4/3.4) already covers answer autosave; there is no separate
  "answered a checklist item" audit event.
- **Admin's read-only checklist rendering** (7.1) gains the assigned
  template's name/version in the section header and each item's type
  inline, plus an explicit "Filled in the field — read-only here" note —
  D-045's mobile-only-filling decision made visible in the UI itself, not
  only in the docs. No write affordance was added; filling stays a field
  activity by design.

### Phase 7.4 Camera Capture (Photos + Videos), GPS/Timestamp, and Before/After

- **A second, entirely separate offline queue — the phase's central design
  point.** `MediaQueue` (new Drift table) and `MediaUploadWorker` (new
  class, mirroring `SyncEngine`'s connectivity/app-resume/periodic/manual
  trigger shape and backoff formula almost line-for-line) never share a
  drain loop, a transaction, or even a Timer with 7.2's `Outbox`/
  `SyncEngine`. A multi-minute 1080p video uploading in the background can
  never stall a lightweight checklist-answer autosave, and vice versa — an
  inspection can (and does, see below) sync to `completed` while its media
  is still uploading.
- **Direct-to-Storage upload from the mobile client, not proxied through
  the backend (D-0xx) — a deliberate departure from 4.3's asset-media
  pattern.** 4.3's `AssetMediaStorage` is server-mediated in both
  directions: the client sends multipart bytes to a FastAPI route, which
  uploads to Storage itself. Proxying a 150–270MB video that way would
  double the network hop and hold the whole file in the backend's memory —
  working directly against this phase's own "large videos must not stall
  sync" requirement. Instead: `firebase_storage`'s `putFile` uploads
  straight from the device to
  `companies/{company_id}/inspections/{inspection_id}/media/{local_id}_{filename}`
  (a Dart port of the same path formula, `inspectionMediaStoragePath()`,
  mirrors the backend's `InspectionMediaStorage.object_path()` field-for-
  field so client and server never disagree on where a file lives). New
  `storage.rules` carve-out (the first ever, since 3.3's `CompanyLogoStorage`
  doc comment establishes "server-mediated for everything"): a `create`-only
  rule checks the caller's `company_id` custom claim matches the path
  segment and caps `request.resource.size` at 500MB; it cannot check the
  finer-grained `inspections.write` permission or that `inspectionId` is
  real (those aren't in the token) — an unreferenced write under this rule
  is an inert orphan object, never readable (`allow read: if false`; every
  read stays signed-URL-only via the backend) and never live in
  `inspection.media[]` until the backend's attach endpoint registers it.
- **The backend never receives media bytes at all — `InspectionMediaStorage`
  (new, alongside `AssetMediaStorage`) only verifies and reads back what
  the client already uploaded** (`verify_uploaded()`: `blob.exists()` +
  `blob.reload()` for size/content-type) and issues signed URLs for
  display. `InspectionMedia` (new entity, mirroring `AssetMedia`) adds
  `local_id` (the idempotency key), `kind` (`photo`/`video`), GPS,
  `captured_at`, `checklist_item_id`, and `before_after_tag` to the
  familiar path/filename/content_type/size/uploaded_by/uploaded_at shape.
  Three new routes on the existing `inspections` router —
  `POST .../media` (attach), `PATCH .../media/{id}` (edit tag/link),
  `DELETE .../media/{id}` (detach) — all gated by the existing
  `inspections.write`, all **idempotent by `local_id`/`media_id` and
  deliberately carrying no `expected_revision`**: media traffic must never
  collide with the checklist-autosave revision protocol (D-047's own
  warning to future mutation types, now acted on). A byte-identical
  re-attach (same `local_id` + identical fields) is a true no-op; a
  conflicting re-attach 409s; a detach/edit on an already-detached/missing
  `media_id` returns the record unchanged rather than 404ing — the mobile
  outbox replays every mutation type at-least-once, and media's replay
  story has to be at least as forgiving as 7.2's own.
- **Mobile capture** (`apps/mobile/lib/media/media_capture_screen.dart`):
  new `camera`/`video_player`/`video_thumbnail`/`firebase_storage`
  dependencies. Photo/video capture mirrors 4.5's `QrScanScreen` injectable-
  builder seam exactly (`captureBuilder`, defaulting to a real
  `_CameraCaptureView`) so widget tests never mount the real `camera`
  plugin; a gallery-pick fallback via `image_picker` covers both kinds.
  Video is capped at 3 minutes / `ResolutionPreset.veryHigh` (~1080p) —
  auto-stops recording at the cap rather than trusting the inspector to
  notice. `LocalMediaRepository.enqueueCapture()` computes the Storage path
  and inserts a `queued` `MediaQueue` row; nothing touches the network yet.
- **`MediaUploadWorker`** drains `MediaQueue` one file at a time via an
  injected `MediaUploader` seam (not `firebase_storage`'s concrete
  `Reference`/`UploadTask` directly — those have private constructors deep
  in the plugin's app-facing wrapper, unlike `image_picker`'s directly-
  fakeable `ImagePicker`, so a thin uploader interface is the actual
  testing seam; production wires the real `FirebaseStorage.instance`
  lazily — see the bug below). On success: marks the row `uploaded`, then
  separately (not in the same try/catch — see below) calls
  `LocalInspectionsRepository.enqueueAttachMedia()`, which rides the
  *existing* 7.2 `Outbox`/`SyncEngine` machinery as a small `attach_media`
  reference mutation. Once that mutation round-trips, `SyncEngine` calls
  `LocalMediaRepository.markReferenced()`, deleting the now-fully-redundant
  `MediaQueue` row — `inspection.media[]` (freshly synced from the server
  response) is the durable source of truth from that point on. A Storage
  error is classified transient (`retry-limit-exceeded`, generic/unknown,
  `cancelled` → exponential backoff, same formula as `SyncEngine`) or
  permanent (`unauthorized`, `unauthenticated`, etc. → paused via the same
  `pausedSentinel` convention 7.2 established, requiring an explicit
  manual retry).
- **Two real bugs found while building this phase, not designed
  around:**
  1. **`_registerReference` failure was reverting an already-successful
     upload back to `failed`.** The first draft's `_uploadOne` wrapped
     both the Storage upload *and* the follow-up local-DB enqueue in one
     try/catch — a failure in the second (a local write, not a network
     call) incorrectly re-triggered `_handleUploadError`, forcing a
     pointless full re-upload of bytes that were already sitting in
     Storage. Fixed by splitting the two steps: `_uploadOne` skips the
     upload entirely for a row already in `uploaded` state and only
     retries the reference step, and `dueForUpload()` now reconsiders
     `uploaded` rows (previously only `queued`/`failed`) for exactly this
     retry path.
  2. **`FirebaseStorage.instance` was being resolved eagerly at construction
     time**, which throws (`[core/no-app] No Firebase App '[DEFAULT]' has
     been created`) without a real `Firebase.initializeApp()` call — and
     since `_FevAppState.initState()` constructs a `MediaUploadWorker`
     unconditionally (which in turn constructs its default `FirebaseMedia
     Uploader`), this broke every single widget test that mounts `FevApp`,
     not just media ones. Fixed by resolving it lazily (a getter on
     `FirebaseMediaUploader`, evaluated only when `upload()`/`delete()`
     actually run, which no unrelated widget test ever reaches since they
     queue zero media). This is also why `MediaUploadWorker` depends on a
     new `MediaUploader`/`MediaUpload` interface (`media_uploader.dart`)
     rather than `firebase_storage`'s concrete `Reference`/`UploadTask`
     directly — those have private constructors reachable only through a
     real `Reference.putFile()` call, so faking them for
     `media_upload_worker_test.dart` would otherwise require standing up a
     three-layer `FirebaseStoragePlatform` fake; `FirebaseMediaUploader` is
     the real implementation, `FakeMediaUploader` the test double.
  3. **(Mobile ↔ backend, not mobile-only.)** Drift's `DateTimeColumn`
     round-trips a stored UTC instant back as a **local-flagged** `DateTime`
     (same real instant, `isUtc: false`) — `built_value`'s JSON serializer
     requires a strictly UTC-flagged value, so building
     `AttachInspectionMediaRequest.capturedAt` straight from a `MediaQueue`
     row threw `Invalid argument (dateTime): Must be in utc for
     serialization`. Fixed with `.toUtc()` at that one call site (a
     re-flag, not a re-conversion, since the instant was already correct).
- **Before/after model: independent tags, not linked pairs (D-053,
  resolved ambiguity).** `InspectionMedia.before_after_tag` is a plain
  optional `before`/`after` enum on each item, not a `pair_id` linking two
  specific items — chosen over an explicit-pair model because it's simpler
  to maintain (no orphaned-pair bookkeeping when one photo is removed) and
  the comparison view can let the inspector pick *any* tagged before +
  *any* tagged after photo, not just one designated pair.
  `InspectionMediaSection`'s "Compare before/after" button opens a
  hand-rolled drag-to-reveal slider (`_MediaComparisonScreen`, no
  third-party package) with two `AppSelect` pickers, one per tag.
- **Gallery** (`InspectionMediaSection`, wired into
  `InspectionDetailScreen` between the checklist and the still-reserved
  voice/readings/signature rows — visible regardless of `editable`, since
  a completed inspection's media should still render, just without
  capture/remove/tag actions): unifies server-synced
  `InspectionMediaResponse` and not-yet-synced `MediaQueueRecord` behind
  one `_GalleryItem` shape, showing a live "N of M uploaded" count (M
  includes queued/uploading/uploaded-not-yet-referenced items) — the
  "media pending" honesty the brief specifically asked for. A new local-
  only `LocalInspections.media` JSON-blob column (same convention as
  `checklistItemsSnapshot`) caches the server's synced `media[]` so the
  gallery's metadata (not the actual image bytes, which still need
  connectivity) renders fully offline. Local video thumbnails use
  `video_thumbnail`; a synced (network-URL) video renders a static
  placeholder instead, since the package's remote-URL thumbnail support
  is less certain than its local-file path. `Image.network` calls carry an
  `errorBuilder` so an expired/unreachable signed URL degrades to a broken-
  image icon instead of surfacing as an uncaught framework error.
- **Admin gains a read-only mirror** in the existing
  `InspectionDetailPage` (no new route): a media grid showing each item's
  thumbnail (photo) or a "Video" placeholder, before/after tag, GPS,
  captured timestamp, and its linked checklist item's label (looked up
  from the same `checklistItemsSnapshot` the checklist section already
  renders) — no upload/edit/remove affordance, matching every other
  admin-side capture surface's read-only convention.
- **Contracts regenerated** for `AttachInspectionMediaRequest`,
  `UpdateInspectionMediaRequest`, `InspectionMediaResponse`, and the three
  new `InspectionsApi` operations, on both generated clients.

### Phase 7.5 Damage Annotation (Draw on Inspection Photos)

- **Annotation data model, designed for 7.10 reuse (D-054).** A new
  `Annotation` entity (`apps/api/app/models/entities.py`) sits in
  `Inspection.annotations[]` (top-level, not nested under `media[]` —
  each annotation carries its own `media_local_id` so it's still queryable
  per-photo by filtering, and the field already existed as an untyped
  `list[dict]` placeholder since 7.1). Coordinates are **normalized (0–1)
  relative to the photo's own rendered box**, never pixels, so a shape
  drawn on one device's screen renders in the same place on any other.
  One `points: list[{x, y}]` field covers all five shapes — `point` (1
  point), `rectangle`/`circle`/`arrow` (2 points: corners/bounding-box/
  tail-head), `freehand` (2+ points, a polyline) — rather than a shape-
  specific schema, so a future AI-detected bounding box or polygon (7.10)
  slots into the exact same field. `source` (`manual`/`ai`, default
  `manual`) and `confidence` (nullable) exist now but are only ever
  `manual`/`null` until 7.10 populates the other branch — the phase brief's
  explicit ask to "design for reuse, only build manual now."
- **Backend mutation protocol copies 7.4's media pattern exactly, not the
  checklist-autosave revision protocol.** Three new routes on the existing
  `inspections` router — `POST .../annotations` (create), `PATCH
  .../annotations/{id}` (update), `DELETE .../annotations/{id}` (delete) —
  gated by the existing `inspections.write`, all idempotent by the
  client-generated annotation `id` and **deliberately carrying no
  `expected_revision`**: annotation traffic (like media) must never
  collide with 7.3's checklist-autosave revision bump. `InspectionRepository`
  gained `append_annotation`/`update_annotation`/`remove_annotation`,
  mirroring `append_media`/`update_media`/`remove_media`'s `ArrayUnion`/
  `ArrayRemove`/full-array-rewrite shapes field-for-field. A create whose
  `id` already exists is a no-op if the payload is byte-identical (mirrors
  `attach_media`'s dedup) or a 409 `annotation_conflict` if not; an update/
  delete on a missing `id` returns the record unchanged rather than
  404ing, since the mobile outbox replays every mutation at-least-once.
  `create_annotation` additionally 404s (`media_not_found`) if
  `media_local_id` doesn't match any media item already on the inspection.
- **Mobile: annotations ride the SAME record outbox as checklist/media
  metadata, never `MediaQueue` — but unlike media, they're written to the
  local cache optimistically.** `LocalInspections` gained an `annotations`
  JSON-blob column (schema v3→v4, same convention as `media`) and three
  new `OutboxMutationType` values (`create_annotation`/`update_annotation`/
  `delete_annotation`). Media's `attach_media` deliberately does **not**
  write into `LocalInspections.media` until the mutation syncs (the
  gallery instead merges in not-yet-uploaded items from the separate
  `MediaQueue` table for the "is this visible offline" story) — but an
  annotation has no equivalent secondary queue, so `createAnnotation`/
  `updateAnnotation`/`deleteAnnotation` write the local blob directly and
  immediately, before the matching outbox row even attempts to send. This
  is what makes "annotate a photo in airplane mode, see it rendered
  instantly" true without inventing an `AnnotationQueue` table.
- **A real gotcha surfaced while wiring `SyncEngine`, worth flagging for
  any future phase that adds another small-array inspection field:**
  every mutation's success handler (`applyMutationSuccess` →
  `_upsertFromServer`) overwrites the **entire** local row from whatever
  `InspectionDetail` the server returned for *that specific call* —
  including `annotations[]`. This is safe in production only because the
  real backend's `_to_detail()` always returns the inspection's full
  current state (every annotation, not just the one just mutated); a test
  fake that echoes back an empty `annotations: []` would silently wipe an
  optimistically-written, not-yet-synced annotation the moment an
  unrelated queued mutation (e.g. a checklist answer) drains first. Caught
  by `sync_engine_test.dart`'s new annotation group; fixed by making the
  fake stub build its response the same way the real service does
  (`_annotationFrom(request)`), not by changing production code — the
  design itself is correct, self-healing under the outbox's strict global
  FIFO drain order (the annotation's own mutation always drains and
  restores it within one pass).
- **Annotation canvas** (`apps/mobile/lib/annotations/
  annotation_canvas_screen.dart`, opened by tapping any photo tile in
  `InspectionMediaSection`): a `CustomPaint` surface wrapped in an
  `AspectRatio` sized to the image's own intrinsic dimensions (via an
  `ImageStreamListener`), so the canvas box and the image's rendered box
  are always identical and normalized coordinates never drift regardless
  of screen size. Tools: freehand/rectangle/circle/arrow/point (drawing)
  plus a select mode (tap to inspect/label, drag to move, delete); a
  color palette drawn from `DsColors` tokens (never a hardcoded hex);
  undo/redo as an in-session stack of this-screen's own created-then-
  possibly-undone annotation ids (not a persisted history) — undo deletes
  the most recent, redo re-creates it with a fresh id. Every draw/move/
  delete calls straight through to the repository and re-renders from
  its returned authoritative list; the canvas never hand-constructs an
  `AnnotationResponse` itself. A broken/expired signed photo URL degrades
  to a plain message instead of an uncaught `NetworkImage` exception
  (same posture as the gallery's own `_networkImage` fallback).
- **Overlay rendering, three surfaces, one toggle each:** the gallery grid
  tile (a lightweight `AnnotationOverlayPainter`, an at-a-glance preview —
  slightly misaligned for a non-square photo since the tile crops via
  `BoxFit.cover` while the overlay stretches to the full tile box, an
  accepted simplification since the canvas itself is the precise view),
  the canvas's own live overlay, and a new **admin** read-only SVG overlay
  (`apps/admin/src/inspections/annotation-overlay.tsx`, `viewBox="0 0 100
  100"` + `preserveAspectRatio="none"` so 0–1 coordinates map straight onto
  the tile box) in the existing `InspectionDetailPage` media grid, with a
  per-shape `<title>` tooltip and a below-tile damage-type summary caption.
  Each surface has its own show/hide toggle (mobile: an eye icon in the
  MEDIA section header and the canvas app bar; admin: a text toggle next
  to the Media label) — annotations are opt-out-visible by default.
- **Contracts regenerated** for `AnnotationResponse`/`AnnotationPointResponse`/
  `CreateAnnotationRequest`/`AnnotationPointInput`/`UpdateAnnotationRequest`
  and the three new `InspectionsApi` operations, on both generated clients.

### Phase 7.6 Voice Notes (Record + Attach to Inspection)

- **New `VoiceNote` entity, same direct-upload design as 7.4 media, its own
  Storage namespace.** `Inspection.voice_notes[]` (`apps/api/app/models/
  entities.py`) replaces the untyped `list[dict]` placeholder reserved since
  7.1 with a real `VoiceNote` (`id`/`local_id`/`path`/`filename`/
  `content_type`/`size`/`duration_ms`/`checklist_item_id`/`uploaded_by`/
  `uploaded_at`) — no GPS, no `kind`, no before/after tag, since none of
  those apply to an audio recording. `InspectionMediaStorage` gained a
  sibling `voice_object_path()` (`companies/{cid}/inspections/{iid}/voice/
  {local_id}_{filename}`) alongside the existing `object_path()` — a
  distinct subfolder from `media/`, even though both are the exact same
  server-mediated verify-after-client-upload pattern (the mobile client
  uploads bytes directly to Storage; the backend only verifies and
  registers a reference, never touching audio bytes itself).
- **Backend mutation protocol copies 7.4/7.5's established shape exactly
  (D-057).** Three new routes on the existing `inspections` router — `POST
  .../voice-notes` (attach), `PATCH .../voice-notes/{id}` (link/relink to a
  checklist item), `DELETE .../voice-notes/{id}` (detach) — gated by the
  existing `inspections.write`, idempotent by `local_id`/`voice_note_id`,
  and deliberately carrying no `expected_revision` for the same reason
  media/annotation traffic doesn't: it must never collide with 7.3's
  checklist-autosave revision bump. `INSPECTION_VOICE_NOTE_ALLOWED_TYPES`
  (`audio/mp4`/`audio/m4a`/`audio/x-m4a`/`audio/aac` — the content-type
  strings different recorder plugins/OSes report for AAC-in-M4A),
  `INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES` (20MB), and
  `INSPECTION_VOICE_NOTE_MAX_DURATION_MS` (10 minutes) mirror
  `INSPECTION_MEDIA_RULES`'s per-kind validation, enforced server-side in
  `attach_voice_note` in addition to the mobile client's own pre-upload cap.
  `InspectionRepository` gained `append_voice_note`/`update_voice_note`/
  `remove_voice_note`, mirroring `append_media`/`update_media`/
  `remove_media`'s `ArrayUnion`/`ArrayRemove`/full-array-rewrite shapes
  field-for-field.
- **Mobile: voice notes reuse the exact 7.4 `MediaQueue`/
  `MediaUploadWorker` — no new queue or worker (D-057).** `MediaQueue.kind`
  gains a third value, `'audio'` (alongside `'photo'`/`'video'`), plus a
  new nullable `durationMs` column (schema v4→v5) set only for audio rows.
  `LocalMediaRepository.enqueueCapture` now branches on `kind` to compute
  either the existing `inspectionMediaStoragePath()` or a new
  `inspectionVoiceNoteStoragePath()` (the Dart mirror of the backend's
  `voice_object_path()`). `MediaUploadWorker._registerReference` branches
  the same way: an `audio` row builds an `AttachVoiceNoteRequest` (with
  `duration_ms`) and calls a new `enqueueAttachVoiceNote` instead of
  `enqueueAttachMedia` — everything upstream of that one branch (the drain
  loop, backoff, progress tracking, cancel-on-remove) is 100% shared,
  untouched code. Three new `OutboxMutationType` values
  (`attach_voice_note`/`edit_voice_note`/`detach_voice_note`) ride the
  *existing* 7.2 record outbox for their small metadata reference, exactly
  like media's own three mutation types; `LocalInspections` gained a
  `voiceNotes` JSON-blob column (same v4→v5 migration), cached only from a
  synced server response (never written optimistically — a voice note has
  the same "bytes upload first, then a small reference syncs" shape as
  media, unlike an annotation).
- **A real bug this phase's own tests caught: the 7.4 photo/video gallery
  was reading the shared `MediaQueue` table without filtering out `kind ==
  'audio'`.** `InspectionMediaSection`'s `watchMediaForInspection` stream
  covers every `MediaQueue` row regardless of kind — before this phase that
  was safe because only `'photo'`/`'video'` rows ever existed; a queued
  voice recording would otherwise render as a broken tile in the photo/
  video grid (and, as a `GridView` even with one item, introduced a second
  on-screen `Scrollable` that broke a widget test's `scrollUntilVisible`
  call ambiguously). Fixed by filtering `queued` to `row.kind != 'audio'`
  in the gallery and `row.kind == 'audio'` in the new voice-notes section —
  the two sections now partition the one shared queue cleanly by kind.
- **Recording screen** (`apps/mobile/lib/media/voice_recording_screen.dart`)
  mirrors `MediaCaptureScreen`'s injectable-builder seam
  (`recorderBuilder`, defaulting to a real `record`-plugin view) so widget
  tests never mount the real plugin; live recording is verified on a
  physical device. A `record`/`AudioRecorder` records AAC/M4A
  (`AudioEncoder.aacLc`) to a temp file, auto-stopping at
  `kMaxVoiceNoteDuration` (10 minutes, D-056) the same way
  `MediaCaptureScreen`'s video recording auto-stops at its own cap; a
  pulsing level meter (`_LevelMeter`, D-056) reacts to
  `onAmplitudeChanged`'s live dBFS reading, normalized to 0–1 via
  `normalizeVoiceAmplitude` (a -45dB..0dB window tuned as a glanceable
  meter, not a measurement instrument) and reduced-motion-aware via the
  shared `motionDuration()` helper. After stopping, `audioplayers` previews
  the recording in place (play/pause/re-record/save) before the result
  ever reaches the media queue — mirroring the same "preview before commit"
  shape the camera screen doesn't need (a photo/video is already committed
  the instant the shutter/stop button is pressed) but a voice note
  benefits from, since re-recording a bad take is common in the field. A
  denied microphone permission (RECORD_AUDIO/NSMicrophoneUsageDescription
  were already declared for 7.4's video-with-audio capture) surfaces as a
  graceful message via the same injected `onError` seam, never a crash.
- **Voice notes section**
  (`apps/mobile/lib/media/inspection_voice_notes_section.dart`), inserted
  into the inspection detail screen right after the MEDIA section and
  replacing its own "Voice notes — Coming soon" reserved row: a list (not a
  grid, since duration/checklist-link/upload-state read better as rows than
  square tiles) unifying synced `VoiceNoteResponse`s and not-yet-synced
  `MediaQueue` rows behind one `_VoiceItem` shape (mirrors `_GalleryItem`),
  with per-item play/pause (a single shared `AudioPlayer`, one item playing
  at a time), duration, an "N of M uploaded" progress count, a checklist-
  item link menu (same "can only re-link, never clear back to unlinked on
  an already-synced item" limitation `UpdateInspectionMediaRequest`
  already has, for the same reason: `UpdateVoiceNoteRequest`'s
  `checklist_item_id` treats `null` as "leave unchanged"), and remove
  (routes through `removeBeforeSync`/`enqueueDetachVoiceNote` depending on
  sync state, exactly like the media section's own remove).
- **Admin: read-only voice-notes review** in the existing
  `InspectionDetailPage`, a new section below Media listing each voice
  note's native `<audio controls>` element (a signed URL, playable
  directly), formatted duration, and its linked checklist item's label —
  no waveform/scrubber beyond what the browser's native audio element
  already provides, matching the phase brief's "list voice notes with
  playback, duration, and which checklist item" scope (the full inspection
  review surface with any richer audio UI is 7.11's job).
- **Contracts regenerated** for `VoiceNoteResponse`/`AttachVoiceNoteRequest`/
  `UpdateVoiceNoteRequest` and the three new `InspectionsApi` operations, on
  both generated clients.

### Phase 7.7 Manual Status Readings (Resolves the Deferred §9 Manual-Status Log)

- **New `Readings` entity replaces the untyped placeholder, single nullable
  object rather than an array.** `Inspection.readings` (`apps/api/app/
  models/entities.py`) was `dict[str, Any] = {}` reserved since 7.1; it's
  now `Readings | None = None` — `condition` (`Excellent`/`Good`/`Fair`/
  `Poor`/`Critical`, the only required field), `temperature_c`/
  `pressure_bar`/`noise_level_db` (all `float | None`),
  `vibration_observation` (free text), `leak_observed` (`bool | None`),
  `operational_status` (`running`/`stopped`/`degraded`, D-058),
  `comments`/`recommendations` (free text), `priority_level` (`low`/
  `medium`/`high`/`critical`), and server-stamped `recorded_at`/
  `recorded_by`. Unlike `annotations[]`/`voice_notes[]`/`media[]`, this is
  one object, not an array of independent records — a field inspector fills
  in one readings form per inspection, not several — so it's modeled and
  mutated that way rather than forcing an array shape onto single-object
  data. A `field_validator(mode="before")` normalizes the legacy `{}`
  placeholder to `None` on load, so every inspection created before this
  phase keeps deserializing cleanly.
- **Mutation protocol deliberately rides the EXISTING generic update/
  revision path, not the 7.4/7.5/7.6 append-idempotent-by-id pattern
  (D-059).** `UpdateInspectionRequest`/`InspectionUpdate` gained a
  `readings: ReadingsInput | None` field alongside the pre-existing
  `checklist_responses`; `InspectionService.update_inspection` stamps
  `recorded_at`/`recorded_by` server-side (mirroring how
  `answered_at`/`answered_by` are stamped on `ChecklistResponse`) and lets
  `InspectionRepository.update`'s existing whole-field-replace-by-key merge
  handle persistence — no new repository method, no new `expected_revision`
  bypass, no new `OutboxMutationType`. This is the opposite mutation shape
  from media/voice-notes/annotations (which all avoid the revision
  protocol on purpose, per D-051/D-055/D-057, because they're
  independent-record arrays mutated out of band) — readings is a single
  form-like object edited from one screen, the same shape as
  `checklist_responses`/`title`/`notes`, so it correctly rides the same
  protocol those already use rather than inventing a fourth pattern.
- **Asset health rollup on completion only (the phase's core connection).**
  `InspectionService.complete_inspection`, after the lifecycle transition
  succeeds, maps `readings.condition` through
  `READINGS_CONDITION_TO_ASSET_STATUS` (`Excellent`/`Good` → `Healthy`,
  `Fair`/`Poor` → `Warning`, `Critical` → `Critical`) and calls a new
  `AssetRepository.roll_up_status_from_inspection`, which mirrors
  `backfill_qr_code`'s narrow single-field-update-plus-explicit-audit
  shape rather than the generic `AssetRepository.update()` — a distinct
  `asset.status_rolled_up` audit action (metadata: `from`/`to`/
  `inspection_id`) keeps this automatic derivation traceable separately
  from a human editing the asset directly through 4.2/4.3. Runs only when
  `updated.readings is not None` (an inspection can complete with no
  readings at all — readings are optional, not a completion gate) and
  only on the `complete` transition itself, never on a draft/in-progress
  PATCH, so mid-inspection edits can never flip the asset's displayed
  health. `AssetRepository.count(scope, current_status="Critical")` (4.4's
  existing live Firestore `count()` aggregation, no cache/materialized
  rollup) picks up the change on its very next read — proven end to end
  against the real Firebase project in
  `apps/api/scripts/verify_readings_rollup.py`.
- **Fixed documented units, no per-reading unit field (D-058).**
  Temperature is always Celsius, pressure always bar, noise always
  decibels — field names are unit-suffixed (`temperature_c`,
  `pressure_bar`, `noise_level_db`) so the unit is unambiguous from the
  identifier itself, both on the wire and in code, with no conversion step
  and no unit picker in either client's form. A company-level display-unit
  preference (e.g. Fahrenheit) can layer on top later without a data
  migration, since the stored value/unit never changes — only a future
  display-time conversion would.
- **Mobile: one form, one editor, autosaved like the 7.3 checklist, not
  queued like 7.4/7.6 media.** `InspectionReadingsSection`
  (`apps/mobile/lib/inspections/inspection_readings_section.dart`)
  replaces the 7.3 "Readings — Coming soon" reserved row: condition select
  (prominent `StatusPill`, colored by the same 3-state health severity the
  asset itself will show), numeric fields with unit-labeled inputs and
  numeric keypads, a leak yes/no button pair (mirrors the checklist's
  boolean Pass/Fail idiom — no `Switch`/`Checkbox` precedent exists
  elsewhere in this app), operational-status/priority selects, and
  comments/recommendations text areas. Autosave calls the existing
  `LocalInspectionsRepository.updateInspection(..., readings:)` — a new
  optional parameter, not a new method — debounced for text fields,
  immediate for selects/buttons; nothing is persisted until `condition` is
  chosen, mirroring the backend's own required-field validation. A new
  nullable `readings` JSON-blob column on `LocalInspections` (schema
  v5→v6) caches the value in the server's `ReadingsResponse` shape whether
  it came from a synced response or an optimistic local edit (conversion
  helpers `_readingsInputToLocalResponse`/`_readingsResponseToInput`
  translate between the built_value `ReadingsInput`/`ReadingsResponse`
  enum types, which don't unify despite sharing wire values). Every
  `updateInspection` call resends the whole current readings object
  (decoded from the local cache when this particular call didn't touch
  it) exactly like it already does for `title`/`notes`/
  `checklist_responses`, so an unrelated field edit never drops a
  not-yet-synced readings edit.
- **Admin: read-only readings review** in the existing
  `InspectionDetailPage`, a new section below Voice notes showing the
  condition prominently via the same `StatusPill`/tone mapping the
  inspections list already uses for lifecycle status, every populated
  value with its unit, a leak-observed badge, and priority — matching the
  established read-only-review pattern from 7.4/7.5/7.6's own sections.
- **Contracts regenerated** for the new `ReadingsInput`/`ReadingsResponse`
  models and the updated `InspectionDetail`/`UpdateInspectionRequest`, on
  both generated clients.

### Phase 7.8 Digital Signature (Inspector Sign-Off)

- **New `Signature`/`SignatureStroke` entities replace the untyped
  placeholder.** `Inspection.signature` (`apps/api/app/models/entities.py`)
  was `dict[str, Any] | None = None` reserved since 7.1; it's now
  `Signature | None = None` — `strokes` (`list[SignatureStroke]`, each a
  `points: list[AnnotationPoint]`, min length 1), server-derived
  `signer_uid`/`signer_name`/`signer_role`, `signed_at`, and
  `inspection_revision`. **Strokes are a list of stroke *objects*, not a
  raw `list[list[AnnotationPoint]]`** — a doubly-nested list needs a
  builder factory the pinned Dart openapi-generator doesn't reliably emit
  (`ListBuilder<BuiltList<X>>` for the inner level was missing at runtime,
  a real bug hit and fixed during this phase); a named `SignatureStroke`
  with one level of nesting sidesteps the generator gap entirely and
  leaves room for future per-stroke metadata (color, width).
- **Vector, not raster (mirrors D-054's annotation precedent).** The
  signature pad's drawn strokes are normalized (0–1) points, identical in
  shape to `Annotation.points` — no Storage upload, no signed-URL round
  trip, renders correctly at any canvas size. This was a genuine
  either/or decision at phase start (raster via the 7.4 media pipeline
  was the other option); vector won on payload size and precedent.
- **Signing is the mandatory final step of completion, not a separate
  endpoint.** `POST /inspections/{id}/complete` now requires a body
  (`CompleteInspectionRequest`: `strokes` + `expected_revision`) — there
  is no way to complete an inspection without signing, and no separate
  sign-then-complete call. `InspectionService.complete_inspection` checks
  `expected_revision` against the live revision BEFORE the
  checklist-incomplete check (so a stale-revision attempt gets
  `revision_conflict`, not a confusing `checklist_incomplete`), looks up
  the signer's `display_name` via a new `UserRepository` dependency on
  `InspectionService` (identity is always server-derived from
  `current_user.uid`/`role_key` — any client-supplied signer field in the
  request body is simply ignored, `CompleteInspectionRequest` has no such
  field at all), and stamps `signature.inspection_revision` as the
  inspection's revision AFTER the lifecycle transition (`current.revision
  + 1`) — exactly the completed inspection's own final revision.
- **Revision-binding + the "edited after signing" question, resolved
  narrowly (D-0xx).** A completed inspection is immutable
  (`update_inspection`/`assign_checklist_template` both 409 on
  `TERMINAL_STATUSES`, unchanged since 7.1) — so a *persisted* signature
  can never actually go stale after the fact; there is no reopen/re-edit
  capability, and none was added. "Edited after signing" instead means
  the offline PRE-completion race: the signature pad captures strokes
  bound to the revision it saw; if the sign+complete call reaches the
  server after that revision moved (e.g. a queued offline edit synced
  first), the existing `revision_conflict` 409 machinery rejects it
  outright, forcing a refresh + re-sign — no new backend capability
  needed, this reuses the same protocol `update_inspection` already has.
- **Mobile: signature pad opens as a modal at "Complete Inspection", not
  inline on the form.** New `SignaturePad`/`SignaturePadController`
  (`apps/mobile/lib/inspections/signature_pad.dart`) — a `CustomPaint`
  freehand canvas, no tool palette (unlike 7.5's annotation canvas, since
  a signature is always one color/one gesture), normalized at draw time
  identically to 7.5's own `_clampNormalized`. Tapping "Complete
  Inspection" opens `_SignatureCaptureSheet` (shows the authenticated
  user's email — never editable — since `CurrentUser` has no
  `display_name` field and fetching one solely for this optimistic
  local echo wasn't worth a new lookup); "Sign & Complete" stays disabled
  until something's drawn. `LocalInspectionsRepository.completeInspection`
  gained a required `strokes` parameter, computes `expectedRevision` from
  `baseRevision` exactly like `updateInspection` already does, and writes
  a new local-only `pendingSignatureStrokes` column optimistically (the
  raw drawing, visible immediately and across an app restart) — kept
  separate from the new `signature` column (only ever written from a
  synced server response, since signer identity/timestamp are
  server-derived and there's nothing honest to echo locally before sync
  confirms them). Schema v6→v7 adds both columns.
- **`markConflict` correctness fix, general not signature-specific.** Any
  outbox conflict now re-syncs `status`/`startedAt`/`completedAt` from
  the fresh server snapshot (previously left untouched) and clears
  `pendingSignatureStrokes` — needed because a stale `complete` mutation's
  optimistic `status: 'completed'` flip must revert to the server's true
  status once the conflict is detected, or the local UI would show a
  false "completed" state that never actually landed. This is what makes
  the existing generic conflict sheet ("keep mine"/"use server's") double
  as the re-sign flow: after either resolution, status is genuinely back
  to `in_progress`, and the inspector taps Complete again to re-sign.
- **Admin: read-only signature review** in the existing
  `InspectionDetailPage`, a new section showing signer name/role/
  timestamp, a "Valid at revision N" / "Superseded (signed revision X,
  now at Y)" indicator (computed client-side by comparing
  `signature.inspectionRevision` to the live `revision` — always "Valid"
  today given the no-reopen decision above, but the indicator is real
  logic, not a hardcoded label, so it's correct if that decision is ever
  revisited), and a new `SignaturePreview` SVG component (mirrors
  `AnnotationOverlay`'s normalized-`viewBox` convention) rendering the
  stroke data directly rather than an `<img>`.
- **Contracts regenerated** for `Signature`/`SignatureStroke` request and
  response models (`SignaturePointInput`/`SignaturePointResponse`/
  `SignatureStrokeInput`/`SignatureStrokeResponse`/`SignatureResponse`/
  `CompleteInspectionRequest`) and the updated `InspectionDetail`, on both
  generated clients.

### Phase 7.9 AR/Manual Dimension Measurement

- **New `ArMeasurement` entity replaces the untyped placeholder.**
  `Inspection.ar_measurements` (`apps/api/app/models/entities.py`) was
  `list[dict[str, Any]]` reserved since 7.1; it's now
  `list[ArMeasurement] = Field(default_factory=list)` — `id`, `method`
  (`ar`\|`manual`), `distance_meters` (always meters, D-058's fixed-unit
  convention), optional `label`/`note`/`checklist_item_id`, optional
  `media_local_id` (an existing `InspectionMedia.local_id` as visual
  evidence), and `points: list[AnnotationPoint]` reusing D-054's
  normalized-point shape. Session brief opened on an existing Step-1
  Flutter spike (D-062) already gated behind physical-device validation;
  the product owner explicitly waived that gate (D-063) so this phase
  built the full feature directly (D-064).
- **Points are optional even for AR captures, by design.**
  `ar_flutter_plugin_2`'s hit-test callback carries no 2D screen-tap
  coordinate — only a 3D `worldTransform`. Rather than fabricate overlay
  markers from data the plugin doesn't supply, `method="ar"` requires only
  `media_local_id` (422 `ar_measurement_missing_screenshot` otherwise);
  `points` stays in the schema for a future capture path that can supply
  real coordinates.
- **Mutation protocol mirrors 7.5's annotations exactly, not 7.4/7.6's
  attach-reference verbs.** Three new routes,
  `POST/PATCH/DELETE /inspections/{id}/ar-measurements[/{measurement_id}]`,
  idempotent by client-generated `id` (identical resubmit is a no-op 200;
  conflicting resubmit is `409 ar_measurement_conflict`), never carrying
  `expected_revision` — measurement traffic must never collide with the
  checklist-autosave revision protocol. `UpdateArMeasurementRequest` only
  accepts `label`/`note`/`checklist_item_id`; the captured method/
  distance/screenshot/points are immutable (delete-and-recreate fixes a
  mistake). `InspectionRepository.append_ar_measurement`/
  `update_ar_measurement`/`remove_ar_measurement` are a field-for-field
  copy of the annotation repository methods.
- **The AR screenshot is a plain photo through the existing 7.4 pipeline
  — no new storage namespace, no new media kind.** A measurement
  references its evidence screenshot by `media_local_id`, exactly how a
  7.5 annotation references the photo it's drawn on, decoupled from
  whether that upload has finished. Contrast with 7.6's voice notes,
  which needed a new `voice/` subfolder because they're a genuinely
  separate array; a measurement's screenshot is just `media[]`.
- **Mobile: production AR + manual capture screens replace the spike.**
  `ArMeasurementScreen` (`apps/mobile/lib/ar/ar_measurement_screen.dart`)
  detects a plane, places two tapped anchors, reads
  `ARSessionManager.getDistanceBetweenAnchors`, and captures a screenshot
  via `ARSessionManager.snapshot()` — its `MemoryImage` return's public
  `bytes` field is extracted, written to a temp file
  (`path_provider`), and handed to the *unmodified*
  `LocalMediaRepository.enqueueCapture(kind: 'photo', ...)`. Screenshot
  capture is wrapped in its own try/catch so a failure there never blocks
  recording the distance itself. `ManualMeasurementScreen`
  (`manual_measurement_screen.dart`) is the mandatory fallback — reachable
  from every state of the AR screen via an always-visible "Enter manually"
  action, not gated behind an error, per D-062's "mandatory fallback"
  framing. Both hand back a shared `MeasurementCaptureResult` to the new
  `InspectionMeasurementsSection`
  (`apps/mobile/lib/inspections/inspection_measurements_section.dart`),
  which enqueues the screenshot (if any) then calls
  `LocalInspectionsRepository.createMeasurement`.
- **Offline sync: three new `OutboxMutationType` values
  (`create_measurement`/`update_measurement`/`delete_measurement`),
  written to the local `ar_measurements` blob optimistically** (same
  posture as 7.5's annotations — small vector/metadata with no separate
  upload step for the record itself) via a new `LocalInspections.
  arMeasurements` column (schema v7→v8). `SyncEngine._dispatch` gained the
  three matching cases; `_alreadyApplied`'s exhaustive switch treats them
  identically to the annotation cases (structurally unreachable —
  `expected_revision` is never sent — but required to satisfy Dart's
  exhaustiveness check).
- **Admin: read-only measurements review** in the existing
  `InspectionDetailPage`, a new section listing each measurement's method
  badge (AR/Manual), formatted distance (`formatMeasurementDistance` —
  centimeters under 1m, meters otherwise, mirrored field-for-field on
  mobile), label, and note.
- **Contracts regenerated** for `ArMeasurementResponse`/
  `CreateArMeasurementRequest`/`UpdateArMeasurementRequest` and the
  updated `InspectionDetail`, on both generated clients.
- **Residual risk, explicitly accepted (D-063):** `ar_flutter_plugin_2`'s
  plane detection and measurement accuracy remain unverified on physical
  ARCore/ARKit hardware. If it proves inadequate, only the AR *capture*
  screen is replaced (native platform channels per D-062's own escape
  hatch) — the data model, sync protocol, and admin review surface built
  this phase are unaffected.

### Phase 7.10 AI Photo Analysis

- **New `AiAnalysis` entity replaces the untyped placeholder.**
  `Inspection.ai_analysis` (`apps/api/app/models/entities.py`) was
  `dict[str, Any] | None = None` reserved since 7.1; it's now
  `list[AiAnalysis] = Field(default_factory=list)` — `id`, `media_local_id`,
  `model`, `summary`, optional `recommendations`/`risk_level`,
  `annotation_ids` (the findings this run produced), `reviewed`/
  `reviewed_by`/`reviewed_at`, `created_by`, `created_at`. First backend
  code in this repository to call a third-party HTTP/SDK API — every prior
  integration is Firebase.
- **Findings are advisory annotations, not a parallel data structure.**
  Each detected finding becomes its own `Annotation(source="ai",
  confidence=...)` — the exact mechanism `source`/`confidence` were
  reserved for back in Phase 7.5 (D-054). No new overlay model, no new
  review UI primitive: the existing annotation canvas (mobile) and
  `AnnotationOverlay` (admin) already branch on `source == "ai"` and
  render an "AI" badge. `AiAnalysis` itself is the run-level record
  (summary/recommendations/risk level/reviewed state), not a duplicate
  findings list.
- **New `app/ai/vision_client.py`: `ClaudeVisionClient` calls the
  Anthropic API with forced tool-use for reliable structured output** —
  a `report_photo_analysis` tool schema constrains the model to return
  `summary`, optional `recommendations`/`risk_level`, and a `findings[]`
  array (`shape`, 1-2 normalized points, optional `damage_type` from the
  same enum `Annotation` uses, `confidence`, optional `note`). A new
  `VisionAnalysisClient` protocol is what `InspectionService` actually
  depends on, so tests inject a `FakeAiClient` (mirrors `FakeBucket`)
  without a real API key. New `Settings.anthropic_api_key`/
  `ai_vision_model` (default `claude-sonnet-5`); an unset key fails
  closed with 502 `ai_analysis_failed`, never a silent no-op.
- **Points are not required to be exactly right, but a screenshot/photo
  reference always is.** Unlike 7.9's AR capture (which can't supply 2D
  tap coordinates at all), Claude vision CAN attempt real bounding boxes,
  so `points` isn't forced empty here — but validation only requires the
  model to return a `summary`; a photo with no visible damage returns an
  empty `findings[]` and a plain "no issues" summary, never a fabricated
  finding.
- **New `InspectionMediaStorage.download_bytes()`** — the one place this
  class breaks its own "bytes never pass through this backend" precedent
  (Phase 7.4's direct-upload design): a vision API needs the actual image
  bytes, not a signed URL a browser can follow.
- **Two new routes, deliberately not matching 7.4/7.5/7.9's create/
  update/delete shape.** `POST /inspections/{id}/media/{media_id}/analyze`
  (triggers a fresh Claude vision run on an already-synced photo,
  identified by its server `media_id` like `update_inspection_media`) and
  `POST /inspections/{id}/ai-analysis/{analysis_id}/review` (marks a run
  reviewed — the "confirm" half of D-008's "confirm or override"; "override"
  is simply editing/deleting the AI-sourced annotations through the
  existing annotation endpoints, no separate action needed). A new
  `InspectionRepository.append_ai_analysis` writes the new annotations
  and the analysis record in one atomic Firestore update — a real
  ArrayUnion-rejects-empty-list bug was found and fixed here (a photo
  with zero findings must still persist its `AiAnalysis` record without
  attempting an empty annotations array-union).
- **Mobile/admin: analysis is triggered from the field, reviewed from
  anywhere — but never queued through the offline outbox.** Unlike
  every other mutation in `LocalInspectionsRepository`, `analyzeMedia`/
  `reviewAiAnalysis` are direct, immediate, online-only calls: there is
  no sensible optimistic local echo for an AI response that doesn't
  exist yet, and the call requires real connectivity to a paid API
  regardless. A new "Analyze with AI" action lives on
  `AnnotationCanvasScreen`'s app bar (only offered once a photo has
  synced), and a new `InspectionAiAnalysisSection` lists each run's
  summary/risk level/reviewed state with a "Mark reviewed" button. Admin
  gets the same review section, read-only, matching every other
  sub-resource's admin surface in this phase — no capture/trigger action
  on admin. A new `LocalInspections.aiAnalysis` column caches synced runs
  (schema v8→v9); this same migration also retroactively fixed a real gap
  from Phase 7.9, whose `arMeasurements` column was added without ever
  bumping `schemaVersion` or its own `onUpgrade` branch, meaning an
  existing installed app would never have received that column.
- **Contracts regenerated** for `AiAnalysisResponse` and the updated
  `InspectionDetail`, plus the two new `InspectionsApi` operations, on
  both generated clients.
- **Real Claude API call unverified this phase** — no `ANTHROPIC_API_KEY`
  was available in-session. All logic (route validation, media-kind
  gating, error translation, annotation/analysis persistence, review
  marking) is fully tested against a `FakeAiClient`; the actual vision
  call against the live Anthropic API is an open follow-up once a real
  key is configured.

### Phase 8.1 Work Order Data Model

- **New `WorkOrder` entity (`app/models/entities.py`), the first module
  after Phase 7 that isn't Inspection sub-resource.** `id`, `asset_id`,
  `facility_id`, `title`, optional `description`, `priority`, `status`,
  optional `source_inspection_id`, `technician_id`/`assigned_by`/
  `assigned_at`/`due_date`, `accepted_at`, `labor_hours`/
  `materials_used`/`completion_notes`/`submitted_at`, `closed_by`/
  `closed_at`, `cancelled_at`, `revision`, `deleted_at`, and a reserved
  always-empty `media: list[dict]` (the same "reserve now, build later"
  pattern Phase 7.1 used for `ar_measurements`/`ai_analysis`).
- **Lifecycle mirrors `Inspection`'s draft/in_progress/completed +
  cancelled shape (D-045), adapted for the spec's explicit Assign/
  Accept/Supervisor-Review steps:** `open → assigned → in_progress →
  pending_review → closed`, plus terminal `cancelled` reachable from any
  non-terminal state. `WorkOrderRepository._apply_lifecycle` is a direct
  structural copy of `InspectionRepository.apply_lifecycle` — same
  `RevisionConflictError`/`InvalidTransitionError` pair, same
  `{**current, **extra_fields, status, revision+1, updated_at}` write
  shape, same one-audit-write-per-transition contract.
- **New `work_orders.close` permission is the load-bearing authorization
  decision of this phase (D-066).** Distinct from the pre-existing
  `work_orders.write`, granted only to `operations_manager` and (via
  `ALL_PERMISSION_KEYS`) `company_admin`/`super_admin` — never to
  `maintenance_technician`. Enforced with a third `require_permission`
  dependency on the router (`_work_orders_close_access`), gating only
  `POST /work-orders/{id}/close`; every other route uses the existing
  `.read`/`.write` pair. The real, already-registered non-demo tenant
  needed one `reconcile_roles.py` run to backfill the grant onto its
  `operations_manager` role, same precedent as every prior permission
  addition since D-029.
- **`accept`/`submit-for-review` are self-only, enforced in
  `WorkOrderService`, not the route layer.** Both check
  `current.technician_id == actor_uid` before delegating to the
  repository, raising 403 `not_assigned_technician` otherwise — even a
  `company_admin`/`operations_manager` holding `work_orders.write`
  cannot accept or submit on the technician's behalf. This is a
  per-record check a static permission key can't express, which is why
  it lives in the service rather than as a fourth permission.
- **Nine routes on `apps/api/app/api/v1/work_orders.py`**
  (`GET/POST /work-orders`, `GET /work-orders/{id}`, `PATCH .../assign`,
  `POST .../accept`, `PATCH .../submit-for-review`, `POST .../close`,
  `POST .../cancel`, `DELETE /work-orders/{id}`), all thin wrappers over
  `WorkOrderService`. `assign`/`submit-for-review` accept an optional
  `expected_revision` (real request bodies); `accept`/`close`/`cancel`
  are bodyless with no revision check — the same body-vs-bodyless split
  `Inspection.apply_lifecycle`'s `start`/`cancel` vs `complete`
  established.
- **Seed data:** five `DemoWorkOrderSeed` fixtures spanning every
  non-cancelled lifecycle state (`open`, `assigned`, `in_progress`,
  `pending_review`, `closed`) across the existing Phase 4.1 demo assets,
  walked through their real `create`/`assign`/`accept`/
  `submit_for_review`/`close` repository calls by a new
  `_ensure_work_order()` — a structural mirror of `_ensure_inspection()`,
  seeded sequentially (not `asyncio.gather`'d) for the same
  same-document-race reason.
- **Backend-only for 8.1**, mirroring Phase 7.1's Inspection-foundation-
  before-capture-UI precedent. Mobile assignment/accept/repair/submit
  screens and an admin supervisor-review/close UI are deferred to future
  sub-phases (8.2, 8.3, ...), not yet scoped or confirmed with the
  product owner.
- **Contracts regenerated** for `WorkOrderListItem`/`WorkOrderDetail`/
  `CreateWorkOrderRequest`/`AssignWorkOrderRequest`/
  `SubmitWorkOrderForReviewRequest`/`WorkOrderDeleted` and the nine new
  `WorkOrdersApi` operations, on both generated clients.
- **Real-creds verified** (`verify_work_order_roundtrip.py`) against the
  live Firebase project: create → assign → (supervisor-accept correctly
  rejected) → technician-accept → submit-for-review → close, plus an
  independent create → cancel path, all against real Firestore data.
  The `work_orders.close` permission split itself is an HTTP-route-
  dependency concern, verified instead by `test_work_orders.py` against
  a real `TestClient` request (not something a service-layer real-creds
  script can exercise).

### Phase 8.2 Work Order Mobile + Admin UI

- **Mobile is offline-first via a SEPARATE local cache/outbox/sync-engine
  triple, not a reuse of the inspections one.** `LocalWorkOrders`
  (Drift, schema v9→v10) mirrors `WorkOrderDetail`'s fields; unlike
  `LocalInspections`, every row originates from a server fetch (a work
  order is only ever created by admin, always online), so `syncState`
  never starts `local_only`. `WorkOrderOutbox` (its own table, not a
  reuse of `Outbox`) carries only two mutation types — `accept` and
  `submit_for_review`, the only two technician-performed field actions —
  since assign/close/cancel/create/delete are supervisor actions taken
  from the always-online admin app and never need to queue offline.
  `WorkOrderSyncEngine` is a structural clone of `SyncEngine` (same
  connectivity-listening/backoff/drain-loop shape) rather than a
  genericization of it — deliberately, to avoid an invasive refactor of
  the working, well-tested inspections engine for a domain with a much
  smaller mutation set.
- **`accept`'s already-applied check needed more than a status
  comparison, unlike inspections' `start`.** An inspection's inspector is
  fixed at creation, so `SyncEngine._alreadyApplied`'s `start` case only
  checks `status == inProgress`. A work order's technician can change
  out from under a queued `accept` via reassignment, so
  `WorkOrderSyncEngine._alreadyApplied` additionally compares the fresh
  server `technicianId` against this device's own (still-unmutated —
  `accept`'s optimistic write only touches `status`/`acceptedAt`) local
  row's `technicianId`, distinguishing "my own accept actually landed"
  from "someone else was reassigned and accepted while I was offline" —
  the latter must surface as a real conflict, not be silently swallowed
  as success.
- **`markConflict` only overwrites status-machinery fields
  (`status`/`technicianId`/`acceptedAt`), never
  `completionNotes`/`laborHours`/`materialsUsed`** — mirroring how
  inspections' own conflict handling syncs status/timestamps but leaves
  title/notes/checklist responses alone. The technician's own submitted
  content must survive a conflict so `resolveConflict(keepLocal: true)`
  has real content to re-submit; the server's conflicting version of
  those same fields lives only in `conflictServerSnapshot`, read by the
  `!keepLocal` ("discard mine") path instead.
- **Mobile UI**: `WorkOrdersScreen` defaults to "assigned to me" (a
  `technicianId` filter seeded from the signed-in uid, toggleable off) —
  the field technician's primary use of this screen — with a status
  filter and a pending-outbox indicator mirroring inspections'
  `_PendingQueueLink`. `WorkOrderDetailScreen` offers "Accept task" only
  when `status == assigned` and the signed-in uid matches
  `technicianId`, and "Submit for review" only when `status ==
  in_progress` under the same self-check — every other action
  (assign/close/cancel) is deliberately not offered here at all, since
  those are supervisor actions taken from admin. A conflict surfaces the
  same two-button "keep mine"/"use server's" sheet as
  `InspectionDetailScreen`.
- **Admin UI**: `work-orders-page.tsx` (list, filters, create modal) and
  `work-order-detail-page.tsx` (assign modal, completion-details review
  section, close/cancel actions) mirror the Assets/Users page and modal
  conventions exactly. The "Close" action is gated by `work_orders.close`
  specifically — distinct from the "Assign"/"Cancel" actions' gating on
  `work_orders.write` — the UI-layer mirror of D-066's route-level
  permission split. Admin never calls `accept`/`submitWorkOrderForReview`
  at all (technician-only, self-only actions enforced server-side); its
  `FevApiClient` wrapper only wires the 7 supervisor-relevant endpoints.
- **Nav**: both apps' Work Orders placeholder (`comingSoon: true`) is
  replaced by the real screens; the mobile bottom-nav slot and admin's
  Operations nav group entry are otherwise unchanged.
- No contract regeneration was needed this phase — the backend and its
  generated clients already shipped complete in Phase 8.1; 8.2 is purely
  new client-side code consuming the existing `WorkOrdersApi`.

### AI Safety Boundary

- Claude API and computer-vision models provide advisory analysis
- Every finding requires inspector confirmation or override
- Reports cannot be finalized from unreviewed AI output
- Inputs, outputs, confirmations, and overrides require appropriate audit history

### Audit and Observability

- **Schema (locked, Phase 0.4/3.4):** `audit_logs` is append-only
  (`AppendOnlyDoc`: `created_at`, `actor_uid`, no update/delete API) —
  `company_id`, `action` (`"{target_type}.{verb}"`), `target_type`,
  `target_id`, and a free-form `metadata` dict conventionally holding
  `before`/`after` (or `added`/`removed` for consolidated multi-mapping
  edits). Every `TenantRepository` subclass's create/update/delete writes
  one entry automatically (`app/db/repositories/base.py::_write_audit`) —
  there is no ad hoc per-route audit call to forget.
- **Read path (Phase 3.4):** the full compliance trail is queryable and
  exportable per D-029/D-019 — see Phase 3.4 above for the exact
  caller-controlled-date-range + in-memory-filter shape and its read-cost
  bound.
- **Retention:** no automatic deletion/archival policy exists yet — audit
  history accumulates indefinitely in Firestore. Defining a retention
  policy (and whether it differs from Firestore's own storage limits) is
  still _To be defined_.
- **Integrity controls:** append-only at the API layer (no update/delete
  route) is the only integrity guarantee today; there is no
  cryptographic tamper-evidence (hash chaining, WORM storage) — _to be
  defined_ if a stronger compliance guarantee is ever required.
- **Monitoring and operational telemetry** (error rates, latency,
  uptime dashboards outside of `audit_logs` itself): _To be defined_.

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
| Phase 3.3 — company profile and settings | Extends the 0.4 `Company` entity with six optional/defaulted fields and a new `app/company/service.py::CompanyProfileService` behind four `company.settings`-gated routes, sharing 3.1's `UserRepository`/`RoleRepository` for the Overview counts. First use of Firebase Storage in this codebase: a new `app/storage/` package wraps the Admin SDK bucket behind a fixed company-scoped path, server-mediated in both directions (deny-all `storage.rules`, request-time V4 signed URLs, never a public object) — the pattern assets/inspections will reuse. `CurrentUser` (0.5) gains `company_timezone`/`company_locale`, mirroring how `company_name` already reaches every authenticated user regardless of permission. Admin gains `apps/admin/src/settings/` (profile edit, drag-drop logo upload, read-only overview) and threads locale/timezone through the existing `apps/admin/src/dashboard/format.ts` date helpers; mobile gains a read-only `apps/mobile/lib/company/` mirror and the same threading via a new `timezone` package dependency. Contracts regenerated for `CompanyProfile`/`UpdateCompanyRequest` and the new `CompanyApi`. | 2026-07-22 |
| Phase 3.5 — Super-Admin cross-tenant platform administration | Resolves D-006. Adds a new `app/admin/` package (`AdminScope`, `AdminCompanyService`) behind five `platform.admin`-gated routes at `/api/v1/platform/*`, plus `CompanyRepository.list_all()` (new unscoped read, modeled on `PermissionRepository.list()`) and a suspension check inside `get_current_user` itself (stricter than 1.2's unverified-email 200). Every cross-tenant mutation dual-writes to the target tenant's own `audit_logs` and a reserved `"__platform__"` pseudo-tenant scope, reusing `AuditLogRepository`'s existing methods with zero new query code. A new reverse-guard test proves existing company-scoped routes (`/api/v1/company`, `/api/v1/users`) stay tenant-scoped even for a super-admin caller — the only cross-tenant path in the system is `/api/v1/platform/*`. Admin gains `apps/admin/src/platform/` (mirroring 3.4's hook-plus-page shape) and a new shared `ConfirmDialog` design-system primitive; `nav-config.tsx` gains its own "Platform" group, visible only to `super_admin`. Mobile is explicitly out of scope, extending D-023/D-026 to a whole module. Contracts regenerated for `PlatformApi`/`PlatformCompanySummary`/`PlatformCompanyDetail`/`PlatformCompanyPage`/`PlatformStats`/`UpdateCompanyStatusRequest`/`UpdatePlatformCompanyRequest`. Phase 3 is now **COMPLETE**. | 2026-07-23 |
| Phase 4.1 — asset data model, facility/area hierarchy, and backend CRUD | Adds three new tenant collections (`facilities` → `areas` → `assets`, plus optional asset self-nesting via `parent_asset_id`) and their first real backend surface — `assets.read`/`assets.write` had existed as unused catalog placeholders since 0.4. New `app/facilities/`, `app/areas/`, `app/assets/` packages (thin-route/fat-service, matching `app/company/`/`app/roles/`) sit behind new `facilities.read/write`/`areas.read/write` permissions (mirroring each role's existing `assets.*` grants) and reuse the 0.4 `CompanyScope`/audit/repository pattern throughout. Introduces the codebase's first soft-delete (`TenantRepository._soft_delete()`, a new base-class helper) and its first Firestore-level filtered+ordered query (`AssetRepository.query()`, one equality filter plus `order_by(created_at)`, backed by four new composite indexes) — every other list route still reads-then-filters-in-Python. `GET /assets/{id}/history` returns a real, always-empty, correctly-shaped page; no inspection/work-order data is embedded on the asset record. Seed gains 2 facilities/4 areas/11 assets (all categories, all statuses, one self-nested pair) for the Acme demo tenant. Contracts regenerated for `FacilitiesApi`/`AreasApi`/`AssetsApi` and their request/response models. No UI, photo upload, KPI widgets, or QR were built — those are 4.2–4.5. | 2026-07-23 |
| Phase 4.2 — asset list + detail UI (admin + mobile) | Wires the 4.1 `AssetsApi`/`FacilitiesApi`/`AreasApi` into both hand-written client wrappers (a new `AssetsApiClient` type in `apps/admin/src/auth/auth-context.tsx`; 7 new `ApiContract` methods in `apps/mobile/lib/api/api_service.dart`) for the first time since those endpoints shipped. Adds `apps/admin/src/assets/` (list page, the app's first dynamic-segment route at `assets/[id]`, a shared `useAssetsData` hook) and `apps/mobile/lib/assets/` (controller, list screen, and — a new pattern, D-034 — a pushed-route detail screen instead of the Users/Audit/Roles bottom-sheet convention, since 5 tabs of real content don't fit a sheet). Both detail views render the same 5-tab reserved-seam contract (Overview real today; Inspections/Work Orders/History/Media honest-empty, to be filled by Phases 7, 11, and 4.3 respectively querying by `asset_id` — mirrors 4.1's D-033 history-by-reference decision, no UI change anticipated when those land). Fixed a real defect the new nested route exposed: `nav-config.tsx`'s `findNavItem` now prefix-matches like `isRouteActive` instead of requiring an exact match, so the shell breadcrumb no longer reads "Not found" on `/assets/{id}`. No Google Maps Platform integration was added (D-035); GPS renders as coordinates plus an external map link on both clients. No backend, schema, or permission changes. | 2026-07-26 |
| Phase 4.3 — asset create/edit + media upload | Activates 4.1's create/update endpoints through reusable admin and mobile forms and fills 4.2's Media tab. `AssetManagementService` remains the server-authoritative tenant/RBAC boundary, adding case-insensitive company-scoped tag uniqueness, hierarchy-cycle and required-field validation. Media reuses 3.3's private Storage adapter under `companies/{company_id}/assets/{asset_id}/{kind}/{uuid}_{filename}`; Firestore stores structured references in `photos`/`documents`/`manuals`, with `ArrayUnion`/`ArrayRemove` preventing concurrent replacement and detail reads materializing fresh one-hour signed URLs. Android/iOS runners establish the permanent D-037 identity `com.flacronenterprises.energyverse` and display name `EnergyVerse`; camera/gallery selection remains reference-media capture, not Phase 7 inspection/AR capture. Contracts expose the upload/delete endpoints and `AssetMediaResponse` to both generated clients. | 2026-07-27 |
| Phase 4.4 — dashboard KPI widgets + pluggable widget framework (resolves 2.3) | Replaces 2.2's hardcoded `ReservedKpiRegion`/`_ReservedKpiRegion` array with a real registry (`registerWidget`/`registerDashboardWidget` + `DashboardWidgetGrid`) on both clients, gated by 0.6 permissions and a real-but-currently-inert tier hook, each widget isolated in its own failure boundary. New `AssetRepository.count()` (Firestore `count()` aggregation, D-039) backs a new `AssetManagementService.get_dashboard_summary()` behind a new `GET /api/v1/dashboard/assets-summary` route, gated by `assets.read` specifically (not the whole-dashboard `reports.read` gate). Registers the first 3 real widgets — Total Assets, Critical Assets (crimson emphasis, links to the 4.2 asset list pre-filtered via a new admin URL-param read on mount / mobile route argument), and Asset Condition (admin reuses D-020's `DonutChart`; mobile's `chart.dart` gains its own `DonutChart`/`DonutSlice` to reach the same reusable-chart contract). Mobile adds a role-based task-focused subset (Total + Critical only) for field_inspector/maintenance_technician. Work Orders/Permits/Safety continue rendering through the same registry as honest empty-state widgets (`reserved-widgets.tsx`/`reserved_widgets.dart`) until their own phases arrive. Contracts regenerated for `AssetDashboardSummary`/`AssetCategoryCount`/`AssetFacilityCount` and the new `DashboardApi` method — zero new composite indexes needed since every count filter is a plain equality filter. Phase 2.3 is retroactively resolved by this implementation. | 2026-07-28 |
| Phase 7.1 — inspection data model, backend CRUD, and lifecycle | Adds the flagship module's spine: a new `inspections` collection (client-generated UUID id, idempotent upsert, monotonic `revision` for the 7.2 sync/conflict contract) and a new `checklist_templates` collection (per-category, lightly versioned, snapshotted onto the inspection at assignment time), each with a thin-route/fat-service split (`app/inspections/`, `app/checklists/`) mirroring 4.1's `app/assets/` exactly, including the same one-equality-filter Firestore query + in-memory-filter pattern and four new composite indexes. Resolves D-033: `AssetManagementService.get_asset_history` now queries real completed inspections by `asset_id` instead of returning a hard-coded empty page. New `checklist_templates.read`/`.write` permissions join the already-existing `inspections.read`/`.write` placeholders from 0.4 — `operations_manager` gains both (template management), all read-only roles gain `.read`; existing `inspections.*` grants are untouched (no assignment feature exists yet, deferred to 7.11). Seed gains 3 checklist templates and 3 demo inspections (completed/in_progress/draft) for the Acme tenant. Admin gains `apps/admin/src/inspections/` (list + read-only detail) and `apps/admin/src/checklist-templates/` (list + create/edit form), replacing the Inspections `ComingSoonScreen` stub; mobile gains `apps/mobile/lib/inspections/` (list + read-only detail, D-034's pushed-route pattern) and a real "Start Inspection" draft-creation flow on the QR scan-result screen (previously a stub). Both clients' asset-detail Inspections tab now renders real data instead of the 4.2 static empty state. Contracts regenerated for `InspectionsApi`/`ChecklistTemplatesApi` and their models; mobile's `ApiContract` gained the three new methods as real (fakeable) interface methods, touching every existing hand-rolled `FakeApi` test double. No offline engine, camera/annotation/voice/readings/signature/AR/AI capture, or admin review UI — those are 7.2–7.11. | 2026-07-29 |
| Phase 7.2 — offline persistence and sync engine | Adds the local-first engine every subsequent inspection phase builds on: a Drift (SQLite) `LocalInspections`+`Outbox` store behind a single `LocalInspectionsRepository` facade, and a `SyncEngine` that drains the outbox against the 7.1 API on connectivity/resume/periodic/manual triggers with revision-based conflict surfacing (a two-button "keep mine"/"use server's" resolution, no diff view). `InspectionsController`/`InspectionDetailScreen`/`QrScanResultScreen` no longer call `ApiContract` directly for inspections. See "Phase 7.2 Offline Persistence and Sync Engine" above for the full breakdown (this row was missing when the phase shipped; backfilled alongside 7.3 for an accurate record). | 2026-07-29 |
| Phase 7.3 — inspection start flow and checklist filling | Turns 7.1's data model + 7.2's offline engine into the real field workflow. Mobile: `LocalInspectionsRepository` gains a `LocalChecklistTemplates` cache table (refreshed best-effort after sign-in) and `selectChecklistTemplateForCategory` (category match → most-recently-updated tie-break → `Generic` fallback → no-template if nothing's cached), so template auto-selection runs entirely offline; a new local-only `LocalInspections.assetCategory` column (schema v1→v2, this repository's first Drift migration) carries the asset's category into the local draft without a network fetch. `InspectionDetailScreen` (explicitly read-only since 7.2) now renders interactive per-item inputs (`boolean`/`numeric`/`text`/`select` — the model's real types, not the phase brief's illustrative `pass_fail`/`rating` naming) with autosave through `updateInspection`, a progress header, reserved disabled rows for the 7.4+ capture steps, and a Complete button gated on `missingRequiredItemIds`; on load, a `draft` inspection gets its template auto-assigned and transitions to `in_progress` in one place, covering both a fresh start and resuming a stale local draft. New "Start Inspection" entry point on the asset detail screen (previously QR-only); both entry points capture best-effort GPS via a new `geolocator` dependency (Android/iOS permission entries added), non-blocking if denied or unavailable. **Bug fix, not new design:** `updateInspection`'s checklist-response merge was a wholesale array replace, not an upsert by `item_id` — harmless under 7.2 (never exercised with a real partial update) but would have silently erased prior answers under 7.3's continuous per-item autosave; fixed on both the mobile repository and `InspectionService.update_inspection` (upsert-by-`item_id`, D-048). Also fixed in the same pass: `_upsertFromServer` was storing `status`/`inspectionType` as builtvalue's Dart-identifier enum name (`inProgress`) instead of the wire value (`in_progress`) that every local write path and this phase's new status-gated rendering compare against — invisible before now since `draft`/`completed`/`cancelled` happen to be identical either way. No route/schema changes, so **no contracts regeneration was needed**; no new audit action needed (the existing `update()`/`_write_audit` path already covers answer autosave). Admin's read-only checklist rendering (7.1) gains the assigned template's name/version and each item's type, plus an explicit "filled in the field — read-only here" note (D-045's mobile-only-filling decision made visible in the UI, not just the docs). | 2026-07-30 |
| Phase 7.4 — camera capture (photos + videos), GPS/timestamp, and before/after | See "Phase 7.4 Camera Capture" above for the full breakdown. In short: a new `MediaQueue` table + `MediaUploadWorker`, entirely independent of 7.2's `Outbox`/`SyncEngine`, uploads media bytes directly from the mobile client to Firebase Storage (a deliberate departure from 4.3's server-mediated asset-media pattern, D-0xx) via a new `storage.rules` carve-out scoped by the caller's `company_id` claim; only a small metadata reference then rides the existing 7.2 outbox as a new `attach_media`/`edit_media`/`detach_media` mutation type, all three idempotent and carrying no `expected_revision` by design. New backend `InspectionMedia` entity and three routes (attach/update/detach) on the existing `inspections` router, gated by the existing `inspections.write`; the backend never touches media bytes, only verifying what the client already uploaded and issuing signed URLs. Mobile capture (`camera`/`video_player`/`video_thumbnail`/`firebase_storage`, new dependencies) mirrors 4.5's `QrScanScreen` injectable-builder testing seam; video is capped at 3 minutes/~1080p. Before/after is an independent per-item tag (not a linked pair). `InspectionMediaSection` (mobile) and a read-only grid in admin's existing `InspectionDetailPage` round out the gallery, with a live "N of M uploaded" count so a completed-while-media-pending inspection stays honest. Contracts regenerated for `AttachInspectionMediaRequest`/`UpdateInspectionMediaRequest`/`InspectionMediaResponse` and the three new `InspectionsApi` operations. | 2026-08-02 |
| Phase 7.5 — damage annotation (draw on inspection photos) | See "Phase 7.5 Damage Annotation" above for the full breakdown. In short: `Inspection.annotations[]` (typed since 7.1's untyped placeholder) holds normalized (0–1) vector shapes keyed by `media_local_id`, one `points[]` field covering all five shapes so 7.10's AI-detected regions can render on the same overlay via the reserved `source`/`confidence` fields. Three new routes mirror 7.4 media's mutation protocol exactly (idempotent by id, no `expected_revision`, `ArrayUnion`/`ArrayRemove` repository methods). Mobile annotations ride the existing 7.2 outbox/record (three new `OutboxMutationType` values) but — unlike media — write to the local cache optimistically, since there's no secondary upload queue standing between "drawn" and "visible offline." New `AnnotationCanvasScreen` (draw/label/undo/redo/select/move/delete) opens from any photo tile in `InspectionMediaSection`; overlay rendering (toggleable) lands on the gallery tile, the canvas itself, and a new read-only SVG overlay in admin's existing `InspectionDetailPage`. Contracts regenerated for `AnnotationResponse`/`CreateAnnotationRequest`/`UpdateAnnotationRequest`/`AnnotationPointResponse`/`AnnotationPointInput` and the three new `InspectionsApi` operations. | 2026-08-05 |
| Phase 7.7 — manual status readings (resolves the deferred §9 manual-status log) | See "Phase 7.7 Manual Status Readings" above for the full breakdown. In short: `Inspection.readings` (typed since 7.1's untyped `dict` placeholder) is a single nullable `Readings` object, not an array — deliberately rides the existing generic `update_inspection`/revision-aware PATCH the 7.3 checklist already uses (D-059), never the 7.4/7.5/7.6 append-idempotent-by-id/no-revision pattern, since it's one form with one editor rather than independent records. Fixed documented units (Celsius/bar/decibels, D-058) via unit-suffixed field names, no per-reading unit picker. On `complete_inspection` only, `READINGS_CONDITION_TO_ASSET_STATUS` maps the condition onto the asset's 4.1 `current_status` through a new `AssetRepository.roll_up_status_from_inspection` (own `asset.status_rolled_up` audit action), which the existing 4.4 dashboard `count()` query picks up on its next read with zero caching — verified end to end against the real Firebase project. Mobile's `InspectionReadingsSection` autosaves through a new `updateInspection(..., readings:)` parameter (not a new outbox mutation type), backed by a new nullable `LocalInspections.readings` column (schema v5→v6). Admin gains a read-only readings review section. Contracts regenerated for `ReadingsInput`/`ReadingsResponse` and the updated `InspectionDetail`/`UpdateInspectionRequest`. | 2026-08-06 |
| Phase 7.8 — digital signature (inspector sign-off) | See "Phase 7.8 Digital Signature" above for the full breakdown. In short: `Inspection.signature` (typed since 7.1's untyped placeholder) is a single nullable `Signature` object holding a list of `SignatureStroke` objects (each `points: list[AnnotationPoint]`) — a named-stroke shape chosen specifically to avoid a real doubly-nested-list builder-factory gap in the pinned Dart generator. Signing is now the mandatory final step of `POST /inspections/{id}/complete` (a new required `CompleteInspectionRequest` body: `strokes` + `expected_revision`) — there is no separate sign-then-complete call and no way to complete unsigned. Signer identity is always server-derived (`InspectionService` gained a `UserRepository` dependency for the `display_name` lookup); a stale `expected_revision` is rejected with the existing `revision_conflict` 409 before the checklist-completeness check runs, which is also the entire "re-sign" mechanism — no reopen/re-edit capability was added, since a completed inspection stays immutable. Mobile gained `SignaturePad`/`SignaturePadController` and a `_SignatureCaptureSheet` modal opened from "Complete Inspection"; `LocalInspectionsRepository.completeInspection` now requires `strokes`, and `LocalInspections` gained `signature`/`pendingSignatureStrokes` columns (schema v6→v7). `markConflict` was fixed to re-sync `status`/`startedAt`/`completedAt` from the server on any conflict, so a stale `complete` attempt's optimistic status flip reverts correctly. Admin gains a read-only signature review section (signer/role/timestamp, valid-vs-superseded indicator, SVG stroke preview). Contracts regenerated for `Signature`/`SignatureStroke` request/response models and the updated `InspectionDetail`. | 2026-08-06 |
| Phase 7.9 — AR/manual dimension measurement | See "Phase 7.9 AR/Manual Dimension Measurement" above for the full breakdown. In short: `Inspection.ar_measurements[]` (typed since 7.1's untyped placeholder) holds `ArMeasurement` records (method, distance in meters, optional label/note/checklist link, optional screenshot reference, optional overlay points) — mutation protocol is a field-for-field copy of 7.5's annotation pattern (idempotent by id, no `expected_revision`), and the evidence screenshot is a plain photo through the *existing* 7.4 media pipeline, not a new storage namespace. `points` stays genuinely optional even for AR captures since `ar_flutter_plugin_2` exposes no 2D tap coordinate to populate them honestly (D-064). Session opened on an already-uncommitted Step-1 spike (D-062) gated behind physical-device validation; the product owner waived that gate (D-063) so this phase shipped the full feature. Mobile gained `ArMeasurementScreen`/`ManualMeasurementScreen`/`InspectionMeasurementsSection`, three new `OutboxMutationType` values, and a new `LocalInspections.arMeasurements` column (schema v7→v8). Admin gains a read-only measurements review section. Contracts regenerated for `ArMeasurementResponse`/`CreateArMeasurementRequest`/`UpdateArMeasurementRequest` and the updated `InspectionDetail`. AR plane-detection/measurement accuracy on real hardware remains unverified — accepted risk, confined to the capture screen only. | 2026-08-10 |
| Phase 7.10 — AI photo analysis | See "Phase 7.10 AI Photo Analysis" above for the full breakdown. In short: `Inspection.ai_analysis[]` (typed since 7.1's untyped placeholder) holds `AiAnalysis` run records; every detected finding is its own `Annotation(source="ai", confidence)` — the exact reuse Phase 7.5 (D-054) reserved those fields for, so no new overlay model was needed. First third-party HTTP/SDK call in this backend: new `app/ai/vision_client.py` (`ClaudeVisionClient`, forced tool-use for structured output) behind a `VisionAnalysisClient` protocol tests fake out. New `InspectionMediaStorage.download_bytes()` breaks the "bytes never pass through this backend" precedent since a vision call needs real image bytes. Two new routes (`analyze`, `review`) mirror neither the create/update/delete pattern nor the attach/detach pattern — `analyze` triggers a fresh run, `review` marks one reviewed (the "confirm" half of D-008; "override" is just editing/deleting the resulting annotations). `InspectionRepository.append_ai_analysis` writes annotations + the analysis record atomically; a real ArrayUnion-rejects-empty-list bug (a no-findings photo) was found and fixed. Mobile/admin: `analyzeMedia`/`reviewAiAnalysis` are direct, online-only calls, never queued through the offline outbox (no honest optimistic echo for an AI response that doesn't exist yet); mobile gained an "Analyze with AI" action on the annotation canvas and a new `InspectionAiAnalysisSection`, admin a read-only mirror. New `LocalInspections.aiAnalysis` column (schema v8→v9) — this migration also retroactively fixed 7.9's `arMeasurements` column, which had been added without ever bumping `schemaVersion`. Contracts regenerated for `AiAnalysisResponse` and the updated `InspectionDetail`. The real Claude API call is unverified this phase (no `ANTHROPIC_API_KEY` available in-session); all logic is fully tested against a `FakeAiClient`. | 2026-08-10 |
| Phase 8.1 — work order data model and backend CRUD/lifecycle | See "Phase 8.1 Work Order Data Model" above for the full breakdown. In short: new `WorkOrder` entity/repository/service/router (9 routes), lifecycle `open → assigned → in_progress → pending_review → closed` + terminal `cancelled` mirroring `Inspection`'s D-045 shape. A new `work_orders.close` permission (D-066) is deliberately distinct from `work_orders.write` — granted to `operations_manager`/`company_admin`/`super_admin`, withheld from `maintenance_technician` — enforced at the route layer on `close` only; `accept`/`submit-for-review` are separately enforced self-only in `WorkOrderService` (technician can't be acted for by anyone else). Backend-only scope, mirroring Phase 7.1's foundation-before-UI precedent — mobile/admin work-order screens are deferred to future sub-phases. Contracts regenerated for the new request/response models and 9 `WorkOrdersApi` operations. Real-creds verified against the live Firebase project; `reconcile_roles.py` run against the one real non-demo tenant to backfill `work_orders.close`. | 2026-08-11 |
| Phase 8.2 — work order mobile + admin UI | See "Phase 8.2 Work Order Mobile + Admin UI" above for the full breakdown. In short: mobile ships a separate `LocalWorkOrders`/`WorkOrderOutbox`/`WorkOrderSyncEngine` triple (own Drift tables, schema v9→v10) rather than reusing the inspections one — only `accept`/`submit_for_review` (the technician's two field actions) ride the offline outbox; assign/close/cancel/create/delete are always-online supervisor actions from admin. `WorkOrderSyncEngine._alreadyApplied`'s `accept` case compares the fresh server `technicianId` against this device's own unmutated local row to distinguish a genuine reassignment conflict from "my own accept already landed" — inspections' `start` never needed this since its inspector is fixed at creation. `markConflict` preserves the technician's own `completionNotes`/`laborHours`/`materialsUsed` (only status-machinery fields sync from the snapshot), so "keep mine" has real content to re-submit. `WorkOrdersScreen` defaults to "assigned to me"; `WorkOrderDetailScreen` offers Accept/Submit-for-review only to the actually-assigned technician. Admin ships `work-orders-page.tsx`/`work-order-detail-page.tsx` mirroring the Assets/Users conventions, with Close gated by `work_orders.close` specifically (distinct from Assign/Cancel's `work_orders.write` gate) — the UI mirror of D-066's route split. No contract regeneration needed (Phase 8.1 already shipped the complete client surface); Phase 8 (data model, mobile technician flow, admin supervisor flow) is now **COMPLETE** per its own scope description in `PHASE_TRACKER.md`. | 2026-08-11 |
