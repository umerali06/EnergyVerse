# Phase 7.7 Manual Testing Guide — Manual Status Readings

This is a manual walkthrough for a human to verify Phase 7.7 (logging
condition/temperature/pressure/noise/vibration/leak/operational-status/
comments/recommendations/priority readings during an inspection, offline-
capable, rolling up onto the asset's health on completion) against a real
device or simulator and a real Firebase project. Automated tests (the
backend's readings-persistence/rollup/audit/dashboard-cross-check tests, the
new `readings (Phase 7.7)` groups in `local_inspections_repository_test.dart`/
`sync_engine_test.dart`, the readings widget test in
`inspection_detail_screen_test.dart`, and admin's readings-section tests)
already cover the logic exhaustively — this guide confirms the real form
feel, real offline persistence, and the real asset-health/dashboard
consequence look the way those tests say they do.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running (`cd apps/mobile && flutter run`) — a simulator with
   network control (airplane mode) is enough for this phase; no camera/mic
   hardware is involved.
4. Admin app running locally: `cd apps/admin && pnpm dev`
5. Sign in as `field_inspector@acme.example.invalid` on mobile and open an
   `in_progress` inspection on the seeded Feed Pump asset (`P-101`, starts
   `current_status = Healthy`).

## Part 1 — Filling in readings, online

1. Scroll to the **READINGS** section (below Voice notes). Confirm no
   `StatusPill` is shown yet (no condition has been chosen).
2. Tap the **Condition** dropdown. Confirm the five options — Excellent,
   Good, Fair, Poor, Critical — and pick **Good**. Confirm a green
   `StatusPill` labeled "GOOD" now appears next to the READINGS heading.
3. Confirm the **Temperature (°C)**, **Pressure (bar)**, and **Noise level
   (dB)** field labels show their units directly — there is no separate
   unit picker anywhere in this form.
4. Type a temperature, pressure, and noise value using the numeric keypad.
   Type a short vibration observation. Confirm all of this autosaves
   (briefly leave the screen and come back, or pull-to-refresh, to confirm
   the values are still there).
5. Tap **No leak** / **Leak observed** and confirm the selected one
   highlights.
6. Pick an **Operational status** and a **Priority level** from their
   dropdowns.
7. Type a comment and a recommendation. Confirm both autosave the same way.

## Part 2 — Condition is required before anything saves

1. Force-quit and relaunch the app (or navigate away and back) to a
   **different**, never-touched inspection.
2. Scroll to READINGS. Type a temperature value only — do **not** pick a
   condition.
3. Navigate away and back. Confirm the temperature you typed did **not**
   persist (readings are all-or-nothing behind `condition`, matching the
   backend's own validation) — the field is empty again.
4. Now pick a condition first, then re-type the temperature. Confirm it now
   persists across a navigate-away-and-back.

## Part 3 — Offline entry, then reconnect (the critical scenario)

1. Turn on **airplane mode**.
2. Open a fresh `in_progress` inspection. Fill in the READINGS form
   completely (condition **Critical**, a temperature, a leak observed, a
   priority of **critical**).
3. Force-quit the app entirely while still in airplane mode, then relaunch
   it and re-open the same inspection. Confirm every value you entered is
   **still there** — proving it persisted to local storage (the
   `LocalInspections.readings` column), not just in-memory state.
4. Turn airplane mode **off**. Give the app a few seconds (or pull to sync).
   Confirm the inspection's sync badge settles to "Synced".
5. Open the admin app and load the same inspection. Confirm the
   offline-entered readings now appear there too, read-only — proving they
   actually synced to the server.

## Part 4 — Readings survive an unrelated edit

1. On an inspection that already has readings filled in, edit something
   unrelated — e.g. answer a checklist item, or add a note.
2. Confirm the READINGS section still shows every value you entered
   earlier, unchanged. (This is the same "whole object resent on every
   save" contract `title`/`notes`/`checklist_responses` already rely on —
   an unrelated autosave must never silently drop readings.)

## Part 5 — Completing a Critical inspection rolls up the asset's health

1. Note the Feed Pump asset's current status on the dashboard's **Critical
   Assets** KPI card (should read `1` in a freshly seeded tenant, or
   whatever the current real count is) and on the asset's own detail page.
2. On mobile, open (or start) an inspection on the Feed Pump asset. Fill in
   READINGS with **Condition = Critical**. Answer any required checklist
   items, then tap **Complete Inspection**.
3. In the admin app, open the Feed Pump asset's detail page. Confirm its
   status badge now reads **Critical**.
4. Reload the admin dashboard. Confirm the **Critical Assets** KPI count
   increased by exactly 1 from what you noted in step 1, and clicking the
   card lists the Feed Pump asset among the filtered results.
5. Open the completed inspection in the admin app. Confirm the READINGS
   section shows **Critical** prominently via a red `StatusPill`, plus
   every value you entered with its unit, the priority badge, and (if set)
   a leak-observed badge.

## Part 6 — Completing a Good/Excellent inspection restores Healthy

1. Start a second inspection on the same Feed Pump asset. Fill in READINGS
   with **Condition = Good** (or Excellent). Complete it.
2. Confirm the asset's status badge returns to **Healthy** and the
   dashboard's Critical Assets count drops back down by 1.

## Part 7 — Draft/in-progress edits never flip the asset's health

1. Start a new inspection on an asset that currently shows **Healthy**.
2. Fill in READINGS with **Condition = Critical**, but do **not** complete
   the inspection — leave it `in_progress`.
3. Reload the admin dashboard and the asset's detail page. Confirm the
   asset **still shows Healthy** — only completing the inspection triggers
   the rollup, never an in-progress edit.
4. Cancel or leave this inspection uncompleted when you're done, so it
   doesn't affect the tenant's real counts going forward.

## What you are NOT testing here (out of scope for 7.7)

- Signature, AR measurement, or AI analysis — 7.8–7.10; this phase only
  activates the "readings" layer, the signature reserved row remains.
- A manual (inspector-chosen) override of the asset's health — the rollup
  is always derived from the most recent completed inspection's condition
  (D-059); there is no UI to set an asset's status independently of an
  inspection outcome.
- A company-level unit display preference (e.g. Fahrenheit) — units are
  fixed (Celsius/bar/decibels) for every company in this phase (D-058).
- The full admin review workflow (7.11) — admin's readings section here is
  read-only polish on the existing inspection detail page, not a new
  dedicated review screen.
