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
