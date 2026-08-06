# Phase 7.5 Manual Testing Guide — Damage Annotation (Draw on Inspection Photos)

This is a manual walkthrough for a human to verify Phase 7.5 (drawing/labeling
damage annotations on inspection photos, fully offline-capable, with an admin
read-only review overlay) against a real device or simulator and a real
Firebase project. Automated tests (`local_inspections_repository_test.dart`'s
`annotations` group, `sync_engine_test.dart`'s `annotation sync` group,
`inspection_detail_screen_test.dart`'s overlay/canvas-navigation tests, plus
the backend's create/update/delete annotation tests and admin's overlay
tests) already cover the logic exhaustively — this guide confirms the real
drawing feel, real offline persistence, and real admin review look the way
those tests say they do.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running on a **real device or simulator with real network
   control** (`cd apps/mobile && flutter run`) — the drawing gesture feel is
   the whole point of this phase, so a screenshot-only review isn't enough.
4. Sign in as `field_inspector@acme.example.invalid`, open an `in_progress`
   inspection on the seeded Feed Pump asset (`P-101`), and capture at least
   one photo (Phase 7.4's flow, unchanged by this phase) if it doesn't
   already have one.

## Part 1 — Drawing each shape, online

1. Tap a photo thumbnail in the MEDIA grid. Confirm the annotation canvas
   opens full-screen with the photo filling the frame and a toolbar at the
   bottom (Select / Freehand / Rectangle / Circle / Arrow / Point, plus a
   row of color swatches).
2. Select **Rectangle**, pick a color, and drag a rectangle over a visible
   feature in the photo. On release, confirm a bottom sheet appears asking
   for a **damage type** (dropdown) and an optional **note**. Pick
   "Corrosion", type a note, and tap **Save**.
3. Confirm the rectangle now renders on the photo in the color you picked,
   immediately (no spinner/delay beyond a brief "Saving" overlay).
4. Repeat for **Circle**, **Arrow**, and **Freehand** (drag to draw a
   free-form squiggle), and **Point** (a single tap, no drag) — each with a
   different damage type. Confirm all five shapes render distinctly and
   simultaneously without visual glitches or lag while drawing.
5. Leave the canvas (back button) and confirm the same shapes render as an
   overlay on the MEDIA grid's thumbnail for that photo (a lighter-weight
   preview, may be very slightly offset from the full canvas for a
   non-square photo — this is expected, not a bug).

## Part 2 — Undo/redo and clear

1. Re-open the same photo's canvas. Draw one more shape.
2. Tap **Undo** (top app bar). Confirm the just-drawn shape disappears.
3. Tap **Redo**. Confirm it reappears, unchanged.
4. Draw two more shapes, then tap **Clear all** (the sweep icon). Confirm a
   confirmation dialog appears; confirm it, and confirm **every** shape on
   this photo is removed — not just the ones drawn this session.

## Part 3 — Selecting, moving, editing, and deleting an existing shape

1. Switch to **Select** mode. Tap an existing shape. Confirm it highlights
   (a thin white selection outline).
2. Tap it again (while still selected). Confirm a detail sheet opens showing
   its damage type and note.
3. Close the sheet, then drag the selected shape to a new position on the
   photo. Confirm it moves smoothly and stays where you drop it after
   releasing.
4. Tap it once more to re-open its detail sheet, and tap **Delete**. Confirm
   it's removed from the photo immediately.

## Part 4 — Toggling the overlay

1. In the MEDIA section header, confirm an eye icon appears (only once at
   least one annotation exists anywhere on the inspection). Tap it. Confirm
   every photo's overlay in the grid disappears.
2. Tap it again. Confirm the overlays reappear.
3. Open a photo's canvas and confirm it has its own independent eye icon in
   its app bar, toggling that single photo's overlay without affecting the
   grid's toggle state.

## Part 5 — Offline drawing, then reconnect (the critical scenario)

1. Turn on **airplane mode**.
2. Open a photo and draw a new shape with a damage type and note. Confirm it
   renders immediately, exactly as it did online — offline-first, no
   network dependency for drawing itself.
3. Leave the app entirely (force-quit it), then relaunch it while still in
   airplane mode. Re-open the same inspection and the same photo. Confirm
   the shape you drew before quitting is **still there** — proving it
   persisted to local storage, not just in-memory state.
4. Turn airplane mode **off**. Give the app a few seconds (or tap the sync
   queue's "Sync now" if visible). Open the admin app and load the same
   inspection. Confirm the offline-drawn shape now appears there too, with
   the correct shape, color, position, damage type, and note — proving it
   actually synced to the server.

## Part 6 — Admin review

1. In the admin app, open the inspection detail page for the same
   inspection. Confirm the Media section's photo tiles show the annotation
   overlays drawn earlier, and a below-tile line lists the damage type(s)
   present on that photo (e.g. "Corrosion, Crack").
2. Confirm a "Hide annotations" text toggle appears next to the Media
   label; click it and confirm every tile's overlay disappears; click it
   again (now labeled "Show annotations") and confirm they return.
3. Hover over a shape (desktop) and confirm a tooltip shows its damage type
   and note.

## Part 7 — A completed inspection is read-only

1. Complete the inspection (answer all required checklist items, tap
   Complete Inspection).
2. Re-open one of its photos. Confirm the canvas opens with **no toolbar** —
   drawing tools are gone — but tapping an existing shape still opens its
   detail sheet (view-only: no Delete button, no drag-to-move).

## What you are NOT testing here (out of scope for 7.5)

- Voice notes, readings, signature, AR measurement, or AI analysis —
  7.6–7.10; this phase only activates the "photos" annotation layer, the
  other reserved rows remain.
- AI-detected regions rendering alongside manual ones — the `source`/
  `confidence` fields exist in the schema for 7.10 to populate later, but
  nothing generates an `ai`-sourced annotation yet; every annotation you
  create in this walkthrough is `manual`.
- The full admin review workflow (7.11) — admin's overlay here is read-only
  polish on the existing inspection detail page, not a new dedicated review
  screen with its own lightbox/zoom.
- Precise pixel-perfect overlay alignment on the MEDIA grid **thumbnail**
  specifically (as opposed to the full canvas) — the thumbnail crops via
  `BoxFit.cover` while its overlay stretches to the full tile box, so a
  very wide or very tall photo's thumbnail overlay can look very slightly
  offset; the canvas itself (and the synced server data) are always
  correct regardless.
