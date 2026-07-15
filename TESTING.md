# FEV Testing and Micro-Task Protocol

## Mandatory Workflow

1. Build one micro-task at a time.
2. Each implementation micro-task must include its frontend, backend, and database work and must be real and functional.
3. Test the specific screen, page, endpoint, and relevant data behavior created by that micro-task.
4. Show the product owner the focused test result.
5. Only after successful testing and evidence is shown, mark the micro-task **Done** in `PHASE_TRACKER.md`.
6. After marking it Done, update `ARCHITECTURE.md` with how the completed slice connects to other slices.
7. Do not start the next micro-task until the current one is tested, marked Done, and documented.
8. Never assume requirements. Stop and ask when a requirement or consequential choice is unclear.
9. Update `PHASE_TRACKER.md` and `DECISIONS.md` every session so progress, remaining work, and blockers stay current.

## Per-Micro-Task Test Record

For every micro-task, record:

- Micro-task identifier and acceptance criteria
- Components changed: frontend, backend, database, and infrastructure where applicable
- Automated checks run and their exact results
- Focused manual scenario tested, including offline behavior where applicable
- Tenant isolation and API authorization checks where applicable
- Permission/UI visibility checks where applicable
- Audit-log checks for critical actions where applicable
- AI confirmation/override checks where AI is involved
- Sync, conflict, retry, and recovery checks for offline workflows where applicable
- Defects or limitations discovered
- Evidence shown to the product owner
- Final status and completion date

## Completion Gate

A micro-task is not Done merely because code was written. Done requires passing focused verification, sharing the result, updating the phase tracker, and recording the slice’s architectural connections.

Phase 0.1 contains documentation only. Its focused verification is checking that all requested context files exist, contain the supplied constraints, and preserve open decisions without inventing answers.

## Phase 0.2 Evidence

| Micro-task | Acceptance and focused evidence | Result | Date |
|---|---|---|---|
| 0.2 — monorepo scaffold | API: `poetry install` completed; `poetry run ruff check .` → `All checks passed!`; `poetry run mypy app` → no issues in 4 source files; `poetry run pytest` → 2 passed; Uvicorn served `GET /` with HTTP 200 and `{"service":"fev-api","status":"ok"}`. Admin: pnpm install completed; `pnpm lint` → no warnings/errors; `pnpm build` compiled and generated 4 static pages; `pnpm dev` became ready and served `/` with HTTP 200. Mobile: `flutter pub get` completed; `flutter analyze` → no issues; `flutter build web` succeeded; Flutter web-server served `/` with HTTP 200. CI: GitHub Actions workflow `CI` run 29414241787 passed all three jobs — API (24s), Admin (42s), Mobile (48s). PR: https://github.com/umerali06/EnergyVerse/pull/1. Tenant isolation, authorization, audit, AI, and offline-sync checks are not applicable to this scaffold-only slice. | Passed | 2026-07-15 |
| 0.3 — Firebase Admin and health pipe | API CI-safe checks: `poetry check --lock` passed; Ruff passed; mypy reported no issues in 9 source files; pytest reported 10 passed and 1 credential-dependent skip. Tests cover all three health statuses, valid timestamp shape, four local CORS origins, Firestore error conversion, and the root route. Live checks against Firebase project `thinking-case-469504-c0`: the integration test passed with `GOOGLE_APPLICATION_CREDENTIALS` and separately with in-memory `FIREBASE_CREDENTIALS_B64`; Uvicorn served `GET /health` as HTTP 200 with `firestore: connected`; no-credential execution returned HTTP 200 with `firestore: unconfigured`. Admin lint/build passed and a headless browser rendered `API: connected · Firestore: connected`. Flutter analyze, widget test, and web build passed; the built web app served HTTP 200 and a headless-browser screenshot visibly showed the same connected indicator. CORS preflights for admin port 3000 and Flutter port 8080 returned their requested allow-origin. `infra/firebase/firestore.rules` denies every client read/write; deployment instructions are documented but rules deployment was not part of this slice. GitHub Actions run 29422051072 passed API (28s), Admin (35s), and Mobile (50s). PR: https://github.com/umerali06/EnergyVerse/pull/2. No tenant records, auth/permissions, audit events, AI, or offline-sync behavior exists yet, so those checks are not applicable. | Passed | 2026-07-15 |
| 0.4 — tenant data and RBAC foundation | CI-safe API suite: Ruff passed; strict mypy passed for 29 `app`/`scripts` source files; pytest collected 18 tests and reported 16 passed with 2 real-credential integration tests skipped. Coverage includes repository CRUD for all mutable collections plus append/read for immutable audit logs; exact base-contract fields and exceptions; exact 16-key permission catalog; hard-coded seven-role matrix and immutable resolution; mutation audit shape; deterministic seed idempotency; and `test_company_a_query_never_returns_company_b_documents`. The real seed against `thinking-case-469504-c0` produced `companies=2`, `permissions=16`, `roles=8`, `role_permissions=86`, `users=8`, `audit_logs=104`; an optimized second run returned the identical counts without new audit records. The real credential-gated isolation/RBAC test passed in 39.11s, verifying cross-company reads return no user and all seven Acme roles resolve. Admin lint/build and Flutter analyze remained green. GitHub Actions run 29426235503 passed API (30s), Admin (34s), and Mobile (40s). PR: https://github.com/umerali06/EnergyVerse/pull/3. Firestore client rules remain deny-all. No auth flow, HTTP data route, UI, feature collection, AI, or offline-sync behavior was introduced, so those checks are not applicable. | Passed | 2026-07-15 |
