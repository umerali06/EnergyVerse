# Phase 7.3 Manual Testing Guide — Inspection Start Flow and Checklist Filling

This is a manual walkthrough for a human to verify Phase 7.3 (checklist-template
auto-selection, GPS capture, interactive offline-first checklist filling, and
completion gating) against a real device or simulator with real airplane-mode
network control. Automated tests (`local_inspections_repository_test.dart`,
`inspection_detail_screen_test.dart`, plus the backend's partial-response-upsert
test) already cover the logic exhaustively — this guide confirms the real UI,
on a real device, behaves the way those tests say it does.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running on a **real device or simulator with real network
   control and real location services** (`cd apps/mobile && flutter run`) —
   both airplane mode and a GPS fix matter for this phase.
4. Sign in as `field_inspector@acme.example.invalid` **while online** at
   least once before testing offline scenarios — the checklist-template
   cache only refreshes after a successful sign-in.

## Part 1 — Starting an inspection: template auto-selection

1. While online, scan (or manually enter) the QR code for the seeded Feed
   Pump asset (`P-101`), or open its asset detail page and tap "Start
   Inspection" (the new 7.3 entry point — confirm the button is visible
   next to "Edit").
2. Confirm the inspection lands `in_progress` (not `draft`) immediately,
   and the checklist section shows the seeded **Pump Inspection Checklist**'s
   three items (Vibration normal, Bearing temp, Seal condition) — proving
   the template was auto-assigned by the asset's `Pumps` category.
3. Repeat with an asset in a category that has **no** matching template
   (if one exists in your seed data) and confirm it falls back to the
   **Generic** template, or starts with no checklist at all if neither
   exists — either way, the inspection should still start successfully,
   never error.

## Part 2 — Filling the checklist, with continuous autosave

1. On the interactive checklist (from Part 1), confirm each item renders
   the right input for its type: Pass/Fail buttons for the boolean item,
   a numeric field for the numeric item, a dropdown for the select item.
2. Tap **Pass** on the boolean item. Confirm the progress header
   ("X / Y answered · Z required remaining") updates immediately — this is
   a local write, not a network round trip.
3. Force-quit the app entirely (not just background it), then relaunch and
   reopen the same inspection. Confirm the Pass answer you just gave is
   still there — this is the local Drift row surviving a process restart,
   not a re-fetch (you can verify by toggling airplane mode on first, if
   you want to rule out a network re-fetch entirely).
4. Answer the remaining required items one at a time, confirming the
   progress header updates after each and that **no earlier answer ever
   disappears** — this is the partial-response merge-by-`item_id` fix
   (D-049): before it, answering item 2 would have silently erased item 1.
5. Confirm the "Complete Inspection" button is disabled until every
   required item is answered, then becomes enabled the moment the last one
   is.
6. Tap **Complete Inspection**. Confirm the status pill flips to
   `Completed` and the checklist becomes read-only (no more Pass/Fail
   buttons, just the answered values).
7. Confirm the reserved "Coming soon" rows (Photos, Voice notes, Readings,
   Signature) are visible but genuinely non-interactive while the
   inspection was still in progress.

## Part 3 — The whole flow, entirely offline

1. While still online, open the app at least once so the checklist-template
   cache has a chance to refresh (Part 1's sign-in requirement).
2. Turn on **airplane mode**.
3. Scan a QR code (or use "Start Inspection" from an asset you've viewed
   before) for an asset whose category has a cached template. Confirm:
   - It starts almost instantly with no spinner hang.
   - The checklist template is still correctly auto-assigned (from the
     local cache — no network call happened).
   - The sync-state badge shows "Local only" or "Pending sync".
4. Answer every required item while still offline. Confirm autosave keeps
   working (progress header updates) and nothing errors.
5. Tap **Complete Inspection** while still offline. Confirm it completes
   locally (status flips, sync badge stays "Pending sync") with no error.
6. Turn airplane mode **off**. Within a few seconds, confirm the pending
   badge clears and the inspection syncs — then confirm in the admin app
   that it now shows as a real, completed server record with all its
   checklist responses.

## Part 4 — Resuming a stale draft

1. Force-quit the app during Part 1 or Part 3 right after tapping "Start
   Inspection" but before it's had a chance to auto-transition (this is
   timing-sensitive and may need a couple of tries, or use airplane mode
   plus a quick force-quit to widen the window).
2. Relaunch and navigate to the same inspection from the Inspections list
   (it should show as `draft` if you caught it in time). Open it.
3. Confirm it auto-assigns its template (if not already assigned) and
   transitions to `in_progress` the moment the detail screen loads — the
   same code path as a fresh start, not a separate "resume" flow.

## Part 5 — GPS capture (best-effort)

1. With location services **enabled** and permission **granted**, start a
   new inspection. There's no GPS field visible in the UI yet (readings/
   location display is a later phase), so confirm via the admin app's
   inspection detail (or a direct API call) that `gps_lat`/`gps_lng` were
   populated on the created inspection.
2. With location services **disabled** (or permission denied), start
   another inspection. Confirm it still starts successfully with no error
   or hang — `gps_lat`/`gps_lng` should simply be absent.

## What you are NOT testing here (out of scope for 7.3)

- Photo, voice, readings, or signature capture — those are 7.4–7.8; this
  phase only reserves their visible-but-disabled placeholder rows.
- An admin-side checklist-filling UI — filling stays a mobile-only field
  activity by design (D-045); admin only gained read-only polish (template
  name/version, item type, a "filled in the field" note).
- AR measurements or AI analysis (7.9–7.10) or the admin review workflow
  (7.11).
