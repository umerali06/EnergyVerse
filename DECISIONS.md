# FEV Decision Log

No Phase 0 coding may begin until decisions D-001 through D-003 are confirmed by the product owner.

| ID | Decision | Options / clarification required | Status | Impact |
|---|---|---|---|---|
| D-001 | Backend framework | NestJS (Node.js) or FastAPI (Python) | **PENDING — blocking** | Blocks backend architecture and Phase 0 coding. |
| D-002 | Primary database and AI vector storage | Confirm Firebase Firestore or PostgreSQL. The source brief said “not PostgreSQL,” so this must be explicitly resolved. Also confirm whether AI embeddings require a separate vector store. | **PENDING — blocking** | Blocks data modeling, tenant enforcement details, offline sync design, and backend architecture. |
| D-003 | Authentication provider | Firebase Auth or custom authentication. In either case, the issuance layer must be provider-agnostic; enterprise SSO/SAML/OIDC comes later. | **PENDING — blocking** | Blocks identity architecture and authentication implementation. |

## Decision Record Template

When a decision is confirmed, preserve the history and add:

- Decision and date
- Decision owner
- Chosen option
- Context and rationale
- Alternatives considered
- Consequences and follow-up actions

