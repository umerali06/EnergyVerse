# Flacron EnergyVerse (FEV) — Project Context

## Mission

Flacron EnergyVerse (FEV) is an enterprise, multi-tenant SaaS platform for modernizing field operations across oil and gas, energy, utilities, mining, manufacturing, chemical, industrial, and EPC sectors. It replaces paper-based inspection, maintenance, and safety workflows with offline-capable digital workflows, advisory AI, augmented reality, and a static 3D facility view.

FEV operates in a safety-critical domain where liability, traceability, and reliable field operation matter. The MVP excludes live IoT and telemetry, but its boundaries and APIs must allow those capabilities to be added later without redesigning the product.

## Users and RBAC

The seven initial roles are:

1. Super Admin
2. Company Admin
3. Operations Manager
4. Field Inspector
5. Maintenance Technician
6. HSE Manager
7. Executive (read-only)

Every record is tenant-scoped by `company_id`. Authorization must be enforced at both the API and UI layers; client-side checks are never authoritative. Permissions must use a many-to-many role-to-permission model rather than hardcoded role enums, allowing custom roles without a schema migration.

## MVP V1 Scope

- Authentication
- Role-aware dashboard with KPIs and charts
- Asset management
- QR code asset scanning
- AR inspection (core)
- AI photo and video analysis
- Manual asset status
- Safety reports
- Permit-to-work
- Work orders
- AI report generation in PDF, Word, and Excel formats
- Static digital twin / 3D view
- Admin portal

## Product Capabilities Sequenced After MVP

- Basic VR training
- Notifications: in-app, email, and push
- Global search
- Document management
- Reports and analytics
- Subscriptions and billing

## Explicitly Out of MVP

The following belong to future phases. MVP architecture must expose clean integration boundaries for them, but they must not be implemented in MVP:

- Live IoT sensors and MQTT
- Live telemetry and predictive maintenance
- Live pipeline pressure monitoring
- Wearables and gas detectors
- Drones and robots
- Live digital twin
- ERP integrations such as SAP, Oracle, and Maximo
- SCADA integrations

## Confirmed Technology Direction

- Field mobile and web application: Flutter
- Admin dashboard: React / Next.js
- Web 3D: Three.js
- VR: Unity
- AI: Claude API plus computer-vision models
- AR: ARCore / ARKit / Flutter AR plugin; Unity where required
- Maps: Google Maps Platform
- Push notifications: Firebase Cloud Messaging
- Email notifications: Amazon SES or SendGrid
- Object storage candidate: Firebase Storage or AWS S3

Backend framework, database, authentication provider, final email provider, and final object-storage provider are not confirmed. Blocking decisions are recorded in `DECISIONS.md`.

## Non-Negotiable Principles

- AI findings are advisory, never authoritative. An inspector must confirm or override every AI finding before finalizing a report.
- Field inspections are offline-first, using an on-device queue such as SQLite or Hive, a background sync worker, and explicit conflict resolution.
- Critical actions require comprehensive audit logging.
- Features must be real and functional; dummy, mock, and placeholder functionality is prohibited.
- Every screen requires polished UI, animation, and motion.
- The system must be modular, reusable, maintainable, mobile-first, and suitable for scalable cloud deployment.
- Requirements must not be assumed. Unclear or consequential gaps must be raised with the product owner.

