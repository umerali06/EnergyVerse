# Phase 7.4 Manual Testing Guide — Camera Capture (Photos + Videos), GPS/Timestamp, and Before/After

This is a manual walkthrough for a human to verify Phase 7.4 (photo/video
capture during an inspection, offline-capable, GPS/timestamp tagging, and
before/after comparison) against a real device or simulator with a real
camera, real airplane-mode network control, and a real Firebase Storage
bucket. Automated tests (`local_media_repository_test.dart`,
`media_upload_worker_test.dart`, `media_capture_screen_test.dart`,
`sync_engine_test.dart`, `inspection_detail_screen_test.dart`, plus the
backend's attach/update/detach tests) already cover the logic exhaustively —
this guide confirms the real UI, real camera, and a real background upload
behave the way those tests say they do.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running on a **real device or simulator with a real camera,
   real network control, and real Firebase Storage access**
   (`cd apps/mobile && flutter run`) — a desktop/CI runner cannot exercise
   the camera or a real upload.
4. Sign in as `field_inspector@acme.example.invalid`, then start (or open an
   existing `in_progress`) inspection on the seeded Feed Pump asset (`P-101`)
   — Phase 7.3's flow, unchanged by this phase.

## Part 1 — Capturing a photo, online

1. Scroll to the **MEDIA** section (below the checklist, above the reserved
   voice/readings/signature rows). Confirm it shows "No media yet" for a
   fresh inspection.
2. Tap **Add photo/video**. Confirm the real camera preview appears (not a
   placeholder) with a photo-capture button and a video-record button.
3. Take a photo. Confirm you're returned to the inspection detail screen and
   a new thumbnail appears in the MEDIA grid almost immediately, with an
   "Uploading" (or "Queued" → "Uploading") badge.
4. Within a few seconds (real network), confirm the badge disappears and the
   "N of M uploaded" count reads "1 of 1 uploaded" — the upload completed and
   the reference synced.
5. In the admin app, open the same inspection's detail page. Confirm the new
   Media section shows the photo (a real thumbnail, not broken), with its
   captured timestamp and GPS coordinates (if location was available).

## Part 2 — Capturing a video, with the 3-minute cap

1. Tap **Add photo/video** again, then start recording video.
2. Confirm a running duration counter is visible while recording.
3. Let it record past 3 minutes (or manually verify the cap by checking the
   code path if 3 real minutes is impractical) — confirm it **auto-stops**
   at exactly 3 minutes rather than continuing indefinitely.
4. Confirm the resulting video appears in the MEDIA grid with a play icon
   over its thumbnail, and uploads the same way the photo did.
5. Tap the video thumbnail. Confirm a full-screen player opens and the video
   actually plays back.

## Part 3 — Gallery-pick fallback

1. Tap **Add photo/video**, then **Photo from gallery** — confirm the native
   photo picker opens and a picked photo is captured the same way a camera
   shot would be.
2. Repeat with **Video from gallery** for an existing video file. If the
   picked video is unusually large, confirm an oversized one (over the
   backend's 500MB cap) is rejected locally with a clear message, before any
   upload attempt.

## Part 4 — Offline capture, then reconnect and watch it upload (the critical scenario)

1. Turn on **airplane mode**.
2. Capture a photo and a video while still offline. Confirm both appear in
   the MEDIA grid immediately with a "Queued" badge — capture always works
   locally-first, with no network dependency.
3. Confirm the "N of M uploaded" count reads "0 of 2 uploaded" while
   offline — nothing pretends to have finished.
4. While still offline, answer every remaining required checklist item and
   tap **Complete Inspection**. Confirm the inspection completes locally
   (status flips to `Completed`, sync badge shows "Pending sync") **even
   though its media is still queued** — this is the "an inspection can sync
   as completed while its media is still uploading" design point.
5. Turn airplane mode **off**. Watch the MEDIA section without navigating
   away: confirm the badges progress `Queued` → `Uploading` (with a
   progress percentage) → cleared, one at a time, and the "N of M uploaded"
   count climbs to "2 of 2 uploaded".
6. Confirm the inspection's own sync badge also clears once the checklist/
   completion mutation syncs — note this can (and should) happen
   independently of the media upload timing; the two are separate queues.
7. In the admin app, confirm both media items now appear on the completed
   inspection with real, loadable thumbnails.

## Part 5 — Before/after tagging and comparison

1. On two different photos (ideally of the same equipment at different
   times — reuse two from earlier parts if needed), open each photo's "..."
   menu and tag one **before** and the other **after**.
2. Confirm a small "Before"/"After" badge appears on each tagged thumbnail.
3. Confirm a **Compare before/after** button now appears below the grid
   (it should not appear before at least one of each tag exists).
4. Tap it. Confirm a comparison screen opens with two pickers (choose the
   before photo, choose the after photo) and a slider — dragging left/right
   should reveal more of one photo vs. the other.
5. Remove a tag from one photo via its "..." menu. Confirm the Compare
   button disappears once fewer than one before/one after tag remains.

## Part 6 — Linking media to a checklist item, and removing a not-yet-synced item

1. On any media item's "..." menu, link it to a specific checklist item
   (e.g. "Vibration normal"). Confirm the admin app's read-only media grid
   shows that linked item's label under the corresponding thumbnail.
2. Capture a fresh photo, then **immediately** (before it finishes
   uploading) remove it via the "..." menu. Confirm it disappears from the
   grid and never appears in the admin app — a not-yet-synced item was
   removed cleanly with no orphaned server reference.

## Part 7 — Removing an already-synced item

1. On a photo that has already fully uploaded and synced (no badge), remove
   it via the "..." menu.
2. Confirm it disappears from the mobile grid. Reload the admin app's page
   for this inspection and confirm it's gone there too, proving the detach
   actually reached the server (not just a local-only removal).

## What you are NOT testing here (out of scope for 7.4)

- Annotation (drawing on photos), voice notes, readings, signature, AR
  measurements, or AI analysis — 7.5–7.10; this phase only activates the
  "photos" placeholder row from 7.3, the other reserved rows remain.
- The full admin review workflow (7.11) — admin's media surface here is
  read-only polish on the existing inspection detail page, not a new
  dedicated review screen.
- Resumable upload across a killed app mid-upload at the exact byte offset
  — an interrupted upload simply retries as a fresh whole-file upload on the
  next drain pass (D-051's documented scope boundary), not a literal
  resume-from-byte-N; you can confirm this by force-quitting mid-upload and
  observing the retry rather than expecting the progress bar to resume from
  where it left off.
