# FEV Persistent Agent Context

This file is the Codex auto-loaded master context for Flacron EnergyVerse (FEV). Read and follow it for every session. Detailed records live in `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, `PHASE_TRACKER.md`, `DECISIONS.md`, and `TESTING.md`; keep those files current.

## Product Mission

FEV is an enterprise, multi-tenant SaaS platform replacing paper-based inspection, maintenance, and safety workflows in oil and gas, energy, utilities, mining, manufacturing, chemical, industrial, and EPC operations. It combines offline-first field workflows with advisory AI, AR, and a static 3D facility view. The domain is safety-critical and requires strong security, traceability, reliability, and tenant isolation.

MVP excludes live IoT and telemetry, but architectural boundaries must permit later IoT, MQTT, telemetry, predictive maintenance, wearables, gas detectors, drones, robots, live digital twins, ERP, and SCADA integrations without redesign.

## Roles and Authorization

Initial roles: Super Admin, Company Admin, Operations Manager, Field Inspector, Maintenance Technician, HSE Manager, and Executive (read-only).

- Scope every tenant-owned record by `company_id`.
- Enforce RBAC at the API and UI layers; never trust client-side checks.
- Model roles and permissions as many-to-many data, not hardcoded enums, so custom roles require no schema migration.

## MVP V1

Authentication; role-aware dashboard with KPIs/charts; asset management; QR asset scanning; core AR inspection; AI photo/video analysis; manual asset status; safety reports; permit-to-work; work orders; AI report generation to PDF/Word/Excel; static digital twin/3D view; admin portal.

Later product sequencing: basic VR training, notifications, global search, document management, reports/analytics, and subscriptions/billing.

## Non-Negotiable Engineering Rules

- AI is advisory. An inspector must confirm or override every AI finding before report finalization.
- Field inspection is offline-first: durable local queue (SQLite/Hive), background synchronization, and explicit conflict resolution.
- Audit all critical actions comprehensively.
- Build real, functional behavior only; no dummy, mock, or placeholder functionality.
- Give every screen polished UI, animation, and motion.
- Favor modular, reusable, maintainable, scalable, mobile-first design.
- Never invent requirements or silently resolve ambiguity; stop and ask.

## Confirmed Stack Direction

Flutter for mobile/web field clients; React/Next.js admin; Three.js web 3D; Unity VR and where AR requires it; Claude API plus computer vision; ARCore/ARKit/Flutter AR plugin; Google Maps; FCM push; SES or SendGrid email; Firebase Storage or AWS S3 object storage.

## Blocking Decisions

Do not begin Phase 0 coding until the product owner confirms all three:

1. Backend: NestJS or FastAPI.
2. Database: Firestore or PostgreSQL, explicitly resolving the source brief’s “not PostgreSQL” statement; also determine whether AI embeddings need a separate vector store.
3. Authentication: Firebase Auth or custom, while keeping token/session issuance provider-agnostic for later enterprise SSO/SAML/OIDC.

See `DECISIONS.md` for current state. Do not assume an answer.

## Working Protocol

- Work in one micro-task at a time.
- Each implementation slice includes frontend, backend, and database behavior.
- Test the exact screen/page/endpoint and relevant data/security/offline behavior, then show the result.
- Mark Done in `PHASE_TRACKER.md` only after the focused test succeeds and its result is shown.
- After Done, document slice connections in `ARCHITECTURE.md`.
- Do not start the next micro-task before the current one is tested, marked, and documented.
- Update `PHASE_TRACKER.md` and `DECISIONS.md` every session.

## Current State

Phase 0.1 — Project bootstrap and persistent context setup: **In progress**.

Do not begin Phase 0.2 unless explicitly directed after Phase 0.1 is reviewed.
