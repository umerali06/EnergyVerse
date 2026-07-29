# Phase 7.1 Manual Testing Guide — Inspections + Checklist Templates

This is a manual walkthrough for a human to verify Phase 7.1 (inspection data
model, backend CRUD/lifecycle, and per-category checklist templates) against
a running app. Automated tests already cover the logic exhaustively — this
guide is for eyeballing that the real UI, on real data, feels right (visual/UX
correctness is the human's job per the locked evidence policy).

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant (idempotent, safe to re-run):
   `cd apps/api && poetry run python -m scripts.seed`
   — this creates/refreshes 3 checklist templates (Generic, Pump, Tank) and 3
   demo inspections (one completed Pump inspection, one in-progress Tank
   inspection, one draft Compressor inspection with no template) for the Acme
   Energy tenant.
3. Admin app running locally: `cd apps/admin && pnpm dev` (http://localhost:3000)
4. Mobile app running (`cd apps/mobile && flutter run`), pointed at the local API.
5. Sign in as a seeded demo user. Two are relevant here:
   - `company_admin@acme.example.invalid` — sees and can manage everything.
   - `field_inspector@acme.example.invalid` — sees inspections, read-only checklist templates.
   (Password: whatever `SEED_DEMO_PASSWORD` is set to locally.)

## Part 1 — Admin: browsing real inspections

1. Sign in as `company_admin`. Open **Inspections** in the left nav (no longer
   "Coming soon").
2. Confirm the list shows 3 real inspections with real statuses (Completed,
   In progress, Draft), types, and relative "updated" timestamps — not a
   static placeholder.
3. Filter by **Status = Completed** — only the Pump inspection should remain.
   Clear the filter.
4. Click the completed inspection. Confirm the detail page shows:
   - Status pill, revision number, asset id, inspector id.
   - Started/Completed timestamps both populated.
   - The checklist section listing each item with its answered value (all
     items should show a real value, not "Not answered").
5. Go back, click the in-progress Tank inspection. Confirm its checklist
   shows a mix of answered and "Not answered" items.
6. Click the draft Compressor inspection. Confirm it shows "No checklist
   template has been assigned yet." and that **Cancel inspection** and
   **Delete** buttons are visible (you're signed in as `company_admin`, who
   has `inspections.write`). Do not actually click them unless you want to
   mutate the demo data — a manual visual check is enough.
7. Open an **asset's** detail page (Assets → Feed Pump 101 → Inspections tab).
   Confirm the same completed Pump inspection now appears there too, and
   that the asset's **History** tab also lists it (this is the D-033 seam —
   history is now real, resolved by 7.1).

## Part 2 — Admin: managing checklist templates

1. Still as `company_admin`, open **Checklist Templates** in the nav.
2. Confirm 3 templates appear: Generic, Pump Inspection Checklist, Tank
   Inspection Checklist, each with a version number and category badge.
3. Click **Create template**. Fill in a name, pick a category (e.g. Valves),
   add one boolean item and one select item (with comma-separated options),
   and save. Confirm you land on the new template with the items you entered.
4. Edit that template (change the name), save, and confirm the version
   number incremented by 1.
5. Delete the template you just created (cleanup) and confirm it disappears
   from the list.
6. Sign out, sign in as `field_inspector@acme.example.invalid`. Open
   **Checklist Templates** again — confirm the list is visible (read access)
   but there is no **Create template** button and clicking a row does
   nothing (no write access).

## Part 3 — Mobile: real inspections + the "Start Inspection" flow

1. Sign in to the mobile app as `field_inspector`.
2. Open the **Inspections** tab from the bottom/more navigation. Confirm the
   same 3 real inspections render, with a working status filter.
3. Tap the completed inspection — confirm the read-only detail screen shows
   the same lifecycle/checklist information as admin.
4. Go to an asset (Assets → Feed Pump 101), confirm its Inspections tab
   shows the same completed inspection.
5. Scan (or manually enter) a QR code for any asset (e.g. the Feed Pump's
   printed label from its admin QR Code tab, or manual entry with its
   `qr_code_id`). On the scan-result screen, tap **Start Inspection**.
6. Confirm: a short loading state, then navigation to a real inspection
   detail screen showing `status: Draft`, the correct asset id, and no
   checklist assigned yet — this is a real `POST /api/v1/inspections` call,
   not a "Coming soon" stub.
7. Go back to Inspections list — confirm the new draft inspection you just
   created now appears there too.
8. (Optional cleanup) Delete that draft inspection from the admin app if you
   don't want it cluttering the demo tenant.

## What you are NOT testing here (out of scope for 7.1)

- Filling in a checklist interactively (no capture UI exists yet — 7.3).
- Camera/photo/voice/AR capture, readings, or signature (7.4–7.9).
- An admin review/approval workflow, or assigning an inspector (7.11).
- Offline creation/sync — the app must be online for all of the above (7.2).
