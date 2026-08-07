# Phase 7.8 Manual Testing Guide — Digital Signature (Inspector Sign-Off)

This is a manual walkthrough for a human to verify Phase 7.8 (capturing the
inspector's digital signature as the mandatory final step of inspection
completion, offline-capable, server-derived signer identity, revision-bound
with a pre-completion revision-conflict rejection) against a real device or
simulator and a real Firebase project. Automated tests (the backend's
signature-persistence/gating/server-derived-identity/revision-binding tests,
the new signature coverage in `local_inspections_repository_test.dart`/
`sync_engine_test.dart`/`inspection_detail_screen_test.dart`, and admin's
signature-section tests) already cover the logic exhaustively — this guide
confirms the real signature-pad feel, real offline sign→sync, and the real
re-sign flow look the way those tests say they do.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running (`cd apps/mobile && flutter run`) — a simulator with
   network control (airplane mode) and touch/mouse drag is enough for this
   phase; no camera/mic hardware is involved.
4. Admin app running locally: `cd apps/admin && pnpm dev`
5. Sign in as `field_inspector@acme.example.invalid` on mobile and open an
   `in_progress` inspection with every required checklist item already
   answered (so the Complete button is enabled).

## Part 1 — Signing completes the inspection, online

1. Tap **Complete Inspection**. Confirm a "Sign to complete" sheet opens —
   note the signer line reads your signed-in email, and there is no field
   anywhere to type or pick a different name.
2. Confirm **Sign & Complete** is disabled until you draw something.
3. Draw a signature with your finger/mouse (a few strokes). Confirm the
   drawing renders as you draw it, and **Sign & Complete** becomes enabled.
4. Tap **Clear**. Confirm the drawing disappears and **Sign & Complete**
   disables again. Draw again.
5. Tap **Sign & Complete**. Confirm the sheet closes and the inspection now
   shows status **Completed**, with a new **SIGNATURE** section showing your
   drawn strokes.
6. Open the admin app and load the same inspection. Confirm the **Signature**
   section shows: your real display name and role (never something you
   typed — there was nowhere to type it), a signed-at timestamp, a
   **Signed** badge, a **Valid at revision N** indicator, and a rendering of
   the strokes you drew.

## Part 2 — Signing is mandatory; there is no way to complete unsigned

1. Open a second `in_progress` inspection with its checklist fully answered.
2. Tap **Complete Inspection**, then dismiss the sheet without drawing
   anything (swipe it away or tap outside it).
3. Confirm the inspection is still `in_progress` — nothing completed, no
   signature was recorded. Tapping Complete again re-opens the same empty
   signature sheet.

## Part 3 — Offline sign → sync (the critical scenario)

1. Turn on **airplane mode**.
2. Open a fresh `in_progress` inspection (checklist fully answered). Tap
   **Complete Inspection**, draw a signature, and tap **Sign & Complete**.
3. Confirm the inspection immediately shows **Completed** with your drawn
   signature visible (labeled "syncing" or similarly not-yet-confirmed) —
   this is entirely local, no network required.
4. Force-quit the app entirely while still in airplane mode, then relaunch
   it and re-open the same inspection. Confirm it still shows **Completed**
   with your signature drawing still visible — proving it persisted to
   local storage, not just in-memory state.
5. Turn airplane mode **off**. Give the app a few seconds (or pull to sync).
   Confirm the sync badge settles to "Synced".
6. Open the admin app and load the same inspection. Confirm the signature
   now shows your real server-confirmed name/role/timestamp (the "syncing"
   placeholder is gone) — proving it actually synced to the server.

## Part 4 — Edit-after-sign → re-sign (the offline race)

This reproduces the scenario where a signature is drawn against a revision
that changes before the completion call reaches the server.

1. On mobile, open an `in_progress` inspection with its checklist answered.
   Turn on **airplane mode**.
2. Tap **Complete Inspection**, draw a signature, tap **Sign & Complete**.
   The inspection shows **Completed** locally (unsynced).
3. Without going back online yet, use a second identity (or the admin app,
   if it has write access, or a second real-creds device) to edit the SAME
   inspection's checklist/notes while it's still `in_progress` on the
   server — this is easiest to do with the real-creds script below rather
   than a second physical device.
4. Turn airplane mode **off** and let the app try to sync.
5. Confirm the app detects a conflict: the inspection reverts to its real
   `in_progress` status (not falsely stuck on "Completed"), and the
   standard "This inspection changed elsewhere" conflict sheet appears.
6. Pick either option. Confirm the inspection is back to `in_progress` with
   your checklist answers intact, and **Complete Inspection** is available
   again — signing again (Part 1) is the re-sign.
7. Alternatively, exercise the same rejection directly against the real
   project without a second device:
   `cd apps/api && poetry run python -m scripts.verify_signature_completion`
   — this script signs a real inspection, confirms the persisted signer
   identity/revision, then reproduces the stale-revision race (signs
   against a revision an edit has already moved past) and confirms the
   server rejects it with `revision_conflict`, then re-signs successfully
   against the current revision. Cleans up after itself.

## Part 5 — A spoofed client signer is ignored (defense in depth)

This is really a backend guarantee (`CompleteInspectionRequest` has no
signer field at all, so there's nothing to spoof through the real app) — the
real-creds script in Part 4 step 7 also exercises this directly by sending
extra `signer_uid`/`signer_name` fields in the raw request and confirming
the persisted signature still shows the real authenticated identity.

## What you are NOT testing here (out of scope for 7.8)

- AR measurements or AI analysis — 7.9/7.10; this phase only activates the
  "signature" layer of completion.
- Reopening a completed inspection for further edits — no such capability
  exists (by design, D-061); a completed inspection is permanently locked,
  and the only "edited after signing" scenario is the pre-completion
  offline race in Part 4, not a post-completion edit.
- The full admin review workflow (7.11) — admin's signature section here is
  read-only polish on the existing inspection detail page, not a new
  dedicated review screen.
- A company-level policy requiring more than one signature, or a
  supervisor co-sign — out of scope; one inspector signs at completion.
