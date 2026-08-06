# Phase 7.6 Manual Testing Guide — Voice Notes (Record + Attach to Inspection)

This is a manual walkthrough for a human to verify Phase 7.6 (recording a
voice note during an inspection, offline-capable, uploading through the same
media queue 7.4 built, with an admin read-only review list) against a real
device or simulator and a real Firebase project. Automated tests (the
`voice_recording_screen_test.dart` unit/widget tests, the new audio cases in
`local_media_repository_test.dart`/`media_upload_worker_test.dart`/
`sync_engine_test.dart`, `inspection_detail_screen_test.dart`'s voice-notes
section tests, the backend's attach/update/detach voice-note tests, and
admin's voice-notes-section tests) already cover the logic exhaustively —
this guide confirms the real recording feel, real offline persistence, and
real admin review look the way those tests say they do.

## Prerequisites

1. Backend running locally: `cd apps/api && poetry run uvicorn app.main:app --reload`
2. Seed the demo tenant if you haven't already:
   `cd apps/api && poetry run python -m scripts.seed`
3. Mobile app running on a **real device or simulator with real microphone
   and network control** (`cd apps/mobile && flutter run`) — the recording
   feel and offline behavior are the whole point of this phase, so a
   screenshot-only review isn't enough.
4. Sign in as `field_inspector@acme.example.invalid` and open an
   `in_progress` inspection on the seeded Feed Pump asset (`P-101`).

## Part 1 — Recording, previewing, and saving, online

1. Scroll to the **VOICE NOTES** section (below MEDIA). Confirm it shows
   "No voice notes yet" and a **Record voice note** button.
2. Tap **Record voice note**. Confirm the recorder screen opens showing a
   single microphone button.
3. Tap the microphone button to start recording. Confirm:
   - An elapsed-time counter starts at `00:00` and counts up.
   - A pulsing circle (the level meter) visibly reacts to your voice —
     speak loudly, then softly, and confirm the circle grows/brightens and
     shrinks/dims accordingly.
4. Speak a short test note, then tap the stop button. Confirm the screen
   switches to a preview state showing the final elapsed duration and a
   play button.
5. Tap the play button. Confirm your recording plays back through the
   device speaker, and the button changes to a pause icon while playing.
6. Tap **Re-record**. Confirm it discards the take and returns to the
   microphone button, ready to record again.
7. Record a second, real test note, stop it, and tap **Save**. Confirm the
   recorder screen closes and you're back on the inspection detail screen.
8. Confirm the new voice note now appears in the VOICE NOTES list showing
   its duration and an "Uploading"/"Queued" state that transitions to
   "Uploaded" within a few seconds (still online).

## Part 2 — Maximum length auto-stop

1. Tap **Record voice note** and start recording.
2. Wait the full 10 minutes (or, for a faster check, read
   `kMaxVoiceNoteDuration` in `apps/mobile/lib/media/
   voice_recording_screen.dart` and temporarily lower it to something like
   10 seconds on a local branch — **do not commit that change**).
3. Confirm the recording auto-stops exactly at the cap and lands in the
   preview state, with no need to tap stop yourself.

## Part 3 — Microphone permission denied

1. In your device/simulator's system settings, revoke microphone
   permission for the app (or run a completely fresh install so it hasn't
   been granted yet).
2. Tap **Record voice note**. Confirm a graceful message appears
   ("Microphone access was denied. Enable it in system settings...") with
   a **Try again** button — no crash, no blank screen.
3. Grant the permission in system settings, return to the app, and tap
   **Try again**. Confirm the microphone button now appears normally.

## Part 4 — Attaching to a checklist item

1. On an already-uploaded voice note in the VOICE NOTES list, tap its
   overflow menu. Confirm a **Link: <item label>** entry exists for each
   checklist item on this inspection's assigned template.
2. Tap one. Confirm the voice note's row now shows that checklist item's
   label beneath the duration.
3. Repeat for a **not-yet-uploaded** (still queued) voice note. Confirm the
   same linking works, plus an **Unlink checklist item** option that isn't
   offered once the item has already synced (an intentional limitation,
   same as media's own before/after tag).

## Part 5 — Removing a voice note

1. Record a new voice note and save it, but act quickly: while it still
   shows "Queued"/"Uploading", tap its overflow menu and choose **Remove**.
   Confirm it disappears immediately from the list and never appears in
   the admin app afterward.
2. Record and save another one, wait for it to reach "Uploaded", then
   remove it the same way. Confirm it disappears from the mobile list; in
   the admin app, confirm the inspection's voice note list no longer
   includes it either (the detach round-tripped to the server).

## Part 6 — Offline recording, then reconnect (the critical scenario)

1. Turn on **airplane mode**.
2. Tap **Record voice note**, record a real test note, and save it.
   Confirm it appears in the VOICE NOTES list immediately with a "Queued"
   badge — recording itself never depends on connectivity.
3. Leave the app entirely (force-quit it), then relaunch it while still in
   airplane mode. Re-open the same inspection. Confirm the queued voice
   note is **still there**, still "Queued" — proving it persisted to local
   storage (the `MediaQueue` table), not just in-memory state.
4. Turn airplane mode **off**. Watch the voice note's badge without
   touching anything else: confirm it progresses `Queued` → `Uploading`
   (with a percentage, for a long-enough recording) → `Uploaded`, fully
   automatically via the same background worker that drives 7.4's photo/
   video uploads.
5. Open the admin app and load the same inspection. Confirm the
   offline-recorded voice note now appears there too, with the correct
   duration and (if you linked one) checklist item — proving it actually
   synced to the server, played back via its real signed Storage URL.

## Part 7 — Completing an inspection with a voice note still uploading

1. Record a voice note, and **immediately** (before it finishes uploading)
   answer every required checklist item and tap **Complete Inspection**.
2. Confirm the inspection completes successfully — it never blocks on a
   still-uploading voice note.
3. Confirm the voice note keeps uploading in the background and still
   reaches "Uploaded" even after the inspection is `completed`.

## Part 8 — Admin review

1. In the admin app, open the inspection detail page for the same
   inspection. Confirm a **Voice notes** section appears below Media,
   listing every uploaded voice note with a native audio player, its
   duration (`MM:SS`), and its linked checklist item's label if any.
2. Click each audio player's play control and confirm it actually plays
   the recorded audio through your browser.
3. With zero voice notes on a fresh inspection, confirm the section reads
   "No voice notes have been recorded yet."

## What you are NOT testing here (out of scope for 7.6)

- Readings, signature, AR measurement, or AI analysis — 7.7–7.10; this
  phase only activates the "voice notes" layer, the other reserved rows
  remain.
- A transcription or waveform-scrubber view of a recording — the level
  meter shown while recording is deliberately simple (D-056); admin
  playback is a plain native `<audio>` element, not a custom player.
- The full admin review workflow (7.11) — admin's voice-notes list here is
  read-only polish on the existing inspection detail page, not a new
  dedicated review screen.
