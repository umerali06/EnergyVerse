# Phase 7.2 Manual Testing Guide — Offline Engine

This is a manual walkthrough for a human to verify Phase 7.2 (local store,
sync queue, and conflict resolution for inspections) against a real device
or simulator with real airplane-mode network control. Automated tests
(`local_inspections_repository_test.dart`, `sync_engine_test.dart`, plus the
rewritten inspections/QR widget tests) already cover the logic exhaustively —
this guide is for confirming the real UI, on a real device losing and
regaining a real connection, behaves the way those tests say it does.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running on a **real device or simulator with real network
   control** (`cd apps/mobile && flutter run`) — a plain desktop/web target
   won't let you toggle airplane mode meaningfully.
4. Sign in as `field_inspector@acme.example.invalid`.

## Part 1 — Offline create → reconnect → confirm sync

1. With the device online, scan (or manually enter) a QR code for any asset
   (e.g. the Feed Pump's printed label). Do **not** tap "Start Inspection"
   yet.
2. Turn on **airplane mode** on the device.
3. Tap **Start Inspection**. Confirm:
   - It completes almost instantly (no spinner hang) and lands you on the
     inspection detail screen — there is no network round trip in this
     path anymore.
   - The screen shows a **"Local only"** or **"Pending sync"** badge next
     to the status pill.
4. Navigate to the app shell (any screen). Confirm an **"Offline — changes
   will sync when you're back online"** banner is visible near the top.
5. Go to **Inspections** list. Confirm your new draft appears in the list
   immediately, with the same pending badge, and that a small pending-count
   indicator is visible near the list header.
6. Tap the pending-count indicator to open the **sync queue** screen.
   Confirm your `create` mutation is listed there with 0 attempts.
7. Turn airplane mode **off**. Within a few seconds (connectivity-triggered
   sync), confirm:
   - The offline banner disappears.
   - The inspection's badge changes to no badge at all (synced).
   - The sync queue screen becomes empty ("Nothing pending").
8. Confirm in the admin app (or by re-fetching in mobile) that the
   inspection is now a real server record with `revision: 1`.

## Part 2 — Offline edit, offline complete, then reconnect

This part exercises coalesced edits and the checklist-completion guard,
which need a checklist template assigned first (do this step online).

1. Online, assign a checklist template to a draft inspection (via the admin
   app, since mobile has no assignment UI yet) — or use one of the seeded
   demo inspections that already has one and is still `draft`/`in_progress`.
2. Turn on airplane mode.
3. If your test flow lets you edit fields locally, make more than one edit
   in quick succession. (There's no dedicated edit UI yet in 7.2 — if you
   don't have a way to trigger `updateInspection` from the UI, skip this
   step; it's fully covered by `local_inspections_repository_test.dart`'s
   coalescing test instead.)
4. Turn airplane mode off and confirm the pending queue drains to empty and
   only one `update` mutation was ever queued (check the sync queue screen
   right before reconnecting — it should show exactly one `update` row
   regardless of how many edits you made).

## Part 3 — Forcing and resolving a conflict

1. Turn on airplane mode.
2. Open an inspection on the device and (if you have an edit affordance)
   change its title locally, or otherwise queue an `update`/
   `assign_checklist_template` mutation for it.
3. While still offline on the device, edit that **same inspection** from
   the admin app (online) — e.g. change its title there. This advances the
   server's revision past what the device's queued mutation expects.
4. Turn airplane mode off on the device and let it sync.
5. Confirm the inspection now shows a **"Conflict"** badge (tappable), and
   tapping it opens a sheet with exactly two options: **"Keep my version"**
   and **"Discard mine, use server's"**.
6. Try **"Keep my version"** first: confirm it requeues your edit (visible
   again briefly in the sync queue) and it re-syncs successfully against the
   now-current revision, overwriting the admin app's edit.
7. Repeat steps 2–5 once more, this time tapping **"Discard mine, use
   server's"**: confirm the device immediately shows the admin app's title
   instead of your local edit, and the sync queue has nothing left for that
   inspection.

## Part 4 — Pending queue survives an app kill

1. Turn on airplane mode.
2. Start a new inspection (queues a `create`).
3. Force-quit the mobile app entirely (not just background it).
4. Relaunch the app while still in airplane mode. Confirm the new
   inspection and its pending badge are still there (the local database
   persisted across the process restart).
5. Turn airplane mode off and confirm it syncs normally.

## Part 5 — Manual "Sync now" and per-item retry/discard

1. Open the sync queue screen while online with an empty queue — confirm
   "Sync now" is disabled/absent.
2. Turn on airplane mode, queue a mutation, turn airplane mode back on
   (stay offline) — confirm "Sync now" is enabled but tapping it doesn't
   succeed while genuinely offline (no crash, no incorrect success state).
3. Turn airplane mode off, then immediately tap "Sync now" rather than
   waiting for the automatic trigger — confirm it drains right away instead
   of waiting for the periodic/connectivity-triggered window.
4. To see the per-item retry/discard affordances, you'll need a mutation
   that fails permanently (hard to trigger organically from the UI — this
   is exhaustively covered by `sync_engine_test.dart`'s permanent-error
   test instead). If you do encounter one (e.g. by editing an inspection
   then having an admin hard-delete its asset before it syncs), confirm the
   sync queue screen shows the error message and both **Retry** and
   **Discard** buttons work as expected.

## What you are NOT testing here (out of scope for 7.2)

- Filling in a checklist interactively via a dedicated capture UI (7.3).
- Camera/photo/voice/AR capture, readings, or signature sync (7.4–7.9).
- An admin review/approval workflow (7.11).
- A batch-sync endpoint — there isn't one by design (D-047); every mutation
  replays individually.
