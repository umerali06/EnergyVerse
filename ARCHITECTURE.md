# FEV Architecture

## Status

Phase 0.2 is complete. The monorepo application and infrastructure boundaries are scaffolded; detailed feature architecture remains intentionally incremental and is recorded after each tested micro-task. Locked platform decisions are tracked in `DECISIONS.md`.

## Architecture Goals

- Strict multi-tenant isolation using `company_id`
- Permission-based RBAC enforced server-side and reflected in the UI
- Offline-first field workflows with durable local queues, background synchronization, and defined conflict resolution
- Safety-critical auditability and human confirmation of AI findings
- Modular boundaries that permit future IoT, telemetry, ERP, SCADA, and live digital-twin integrations without redesign
- Scalable cloud deployment and maintainable, reusable components

## System Context

_To be defined after the blocking backend, database, and authentication decisions are confirmed._

### Client Applications

- Flutter field/mobile and web application
- React / Next.js admin dashboard
- Three.js static 3D experience
- Unity for VR and AR cases that require it

### Backend and APIs

- Framework: **PENDING — blocking**
- API style and versioning: _To be decided_
- Module boundaries: _To be defined slice by slice_
- Future integration interfaces: _To be defined without implementing out-of-scope systems_

### Data and Storage

- Primary database: **PENDING — blocking**
- Tenant isolation strategy: every tenant-owned record carries `company_id`; detailed enforcement awaits database selection
- Role/permission model: many-to-many and extensible for custom roles
- AI vector storage: **PENDING clarification alongside database selection**
- Offline device store: SQLite or Hive, final choice pending
- Object storage: Firebase Storage or AWS S3, final choice pending

### Identity and Access

- Authentication provider: **PENDING — blocking**
- Token/session issuance boundary must remain provider-agnostic
- Enterprise SSO through SAML/OIDC is a future capability
- API authorization is authoritative; UI authorization supports user experience but is not a security boundary

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
