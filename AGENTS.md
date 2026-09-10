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

## Locked Foundation Decisions

The former Phase 0 blockers are resolved and locked: FastAPI (D-001), Firebase
Firestore with no separate MVP vector store (D-002), and Firebase Authentication
behind a provider-neutral verification boundary (D-003/D-007). Server-mediated
Firebase Storage is locked by D-027. See `DECISIONS.md` for the authoritative
record; do not reopen or silently change these choices.

## Working Protocol

- Work in one micro-task at a time.
- Each implementation slice includes frontend, backend, and database behavior.
- Test the exact screen/page/endpoint and relevant data/security/offline behavior, then show the result.
- Mark Done in `PHASE_TRACKER.md` only after the focused test succeeds and its result is shown.
- After Done, document slice connections in `ARCHITECTURE.md`.
- Do not start the next micro-task before the current one is tested, marked, and documented.
- Update `PHASE_TRACKER.md` and `DECISIONS.md` every session.

## Current State

Phases 0–10 are complete through Static Digital Twin / 3D Facility View.

Phase 9 (AI Report Generation) is COMPLETE across all 5 subphases (9.1 policy, 9.2 backend, 9.3 exports, 9.4 admin & mobile workflows, 9.5 dashboard KPI & full regression).

Phase 10 (Static Digital Twin / 3D Facility View) is COMPLETE across all 4 subphases:
- 10.1: 3D Scene & Hotspot Data Contract and Backend Foundation (`GET`/`PUT` `/api/v1/facilities/{id}/3d-scene`)
- 10.2: Admin Three.js Web 3D Viewport & Dynamic Facility Page
- 10.3: Mobile Client 3D Digital Twin Experience (`DigitalTwinScreen` + route)
- 10.4: Dashboard Integration & Full Multi-Suite System Regression (438 API pytest tests, 212 admin vitest tests, 283 mobile flutter tests passed 100%).
