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
  authorization errors are top-level JSON contracts.
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
