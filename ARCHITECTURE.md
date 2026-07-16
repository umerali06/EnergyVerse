# FEV Architecture

## Status

Phase 0.7 is complete. Both clients now consume one framework-neutral visual and
motion token source through generated bindings, dark/light themes, and reusable
accessible primitives. Detailed feature architecture remains intentionally
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
- API style and versioning: _To be decided_
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
  non-essential motion. Inter and JetBrains Mono are bundled locally in both
  clients for deterministic/offline typography.
- Admin and mobile expose parity primitives for actions, fields, surfaces, status,
  overlays, feedback, tabs, loading, and empty states. Development-only showcases
  exercise those primitives without entering normal navigation.
- **Rule:** every future screen must compose these primitives and shared tokens.
  Feature modules may extend the system centrally but may not introduce parallel
  color, spacing, typography, elevation, or motion constants.

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
| Phase 0.6 — RBAC enforcement | Connects the Phase 0.5 token → `CurrentUser` chain and Phase 0.4 immutable role matrix to `require_permission` (`all`/`any`) and the narrowly reserved `require_role`. Three temporary `/api/v1/_rbac-demo` routes prove single/all/any gates; 401 and 403 use top-level JSON contracts, and permission/role denials attempt a scoped append-only `access.denied` audit without allowing audit failure to weaken or crash the gate. Super Admin receives no bypass or cross-tenant path. The Next.js permission context and Flutter permission provider consume `/me` once through future-auth token seams and expose matching predicates/wrappers on existing scaffold screens; these client guards are explicitly advisory. CI now executes admin and mobile guard tests. No feature module or Phase 0.7 behavior was added. | 2026-07-16 |
| Phase 0.7 — shared design system | Establishes `packages/design-tokens/tokens.json` as the single framework-neutral source and generates committed bindings into Next.js Tailwind/CSS and Flutter `ThemeData`. Both clients default to dark, persist light/dark choice, bundle Inter/JetBrains Mono, share equivalent reusable primitives, and implement the same fast/standard/slow motion feel with reduced-animation paths. Development-only showcases render every primitive and motion behavior without adding feature or auth screens. All future screens must reuse this foundation. | 2026-07-16 |
