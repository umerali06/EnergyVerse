# Phase 7.9 Manual Testing Guide — AR Dimension Measurement (Physical Device)

This is the walkthrough that closes D-063. Phase 7.9 shipped AR plane-tap
distance measurement built against `ar_flutter_plugin_2` **without ever running
on physical hardware** — the product owner chose to build anyway rather than
block, and that decision was recorded as an accepted risk, not as evidence.
Everything else in Phase 7.9 (the offline outbox round-trip, the manual
numeric-entry fallback, the admin review display, the backend `ArMeasurement`
model) is covered by automated tests. What no test can cover is whether ARCore
/ ARKit actually detects a plane through this plugin on a real handset.

**A simulator cannot substitute here.** iOS Simulator and Android Emulator do
not expose a real ARCore/ARKit session; the plugin will either fail to
initialise or report no planes, which tells you nothing about the real path.

## Prerequisites

1. A physical device with AR support:
   - **Android**: an [ARCore-supported device](https://developers.google.com/ar/devices)
     with Google Play Services for AR installed and up to date.
   - **iOS**: an A12 Bionic device or newer (iPhone XS / 2018 iPad Pro onward).
2. Backend running and reachable *from the handset* — `localhost` will not
   resolve on the device. Bind to your LAN address and point the app at it:
   `cd apps/api && poetry run uvicorn app.main:app --host 0.0.0.0 --reload`
3. Seed the demo tenant: `cd apps/api && poetry run python -m scripts.seed`
4. `cd apps/mobile && flutter run --release -d <device-id>`. Use `--release`:
   AR plane detection is frame-rate sensitive and a debug build's overhead can
   look like a detection failure that a release build does not have.
5. Sign in as `field_inspector@acme.example.invalid` and open an `in_progress`
   inspection.
6. A well-lit space with a **textured** flat surface — a patterned floor or a
   desk with objects on it. A plain white wall or a uniform glossy floor gives
   ARCore nothing to track and will fail for reasons that are not this app's
   fault.
7. A tape measure or a ruler, and an object of known length (a sheet of A4 is
   297 mm on its long edge, which is a convenient reference).

## Part 1 — The session starts at all (the D-063 question)

1. Open the inspection's **Measurements** section and tap **Add AR
   measurement**.
2. Grant the camera permission when prompted.
3. Confirm the camera preview appears and is live, not frozen.
4. Move the handset slowly, sweeping the textured surface for 5–10 seconds.
5. **Confirm plane detection feedback appears** — the plugin's point cloud or
   plane grid overlay. This is the single most important observation in this
   guide: if nothing ever appears here, `ar_flutter_plugin_2` does not work on
   this hardware and D-063's risk has materialised. Record the device model,
   OS version, and ARCore/ARKit version before doing anything else.

If Part 1 fails, stop and report it. Parts 2–5 all depend on it.

## Part 2 — A measurement is accurate

1. Place your reference object (the A4 sheet) on the detected plane.
2. Tap one end of it, then the other, to place two points.
3. Confirm a distance value renders between the two points.
4. **Compare it against the tape measure.** Record both the app's value and the
   true value. AR distance on a well-tracked plane should land within roughly
   ±2 cm over a 30 cm span; a reading that is out by more than about 10% means
   the plane is being estimated at the wrong depth, which is worth reporting
   even though the session technically "works".
5. Repeat at a longer span (1–2 m) and record the pair again. Error usually
   grows with distance — capture how much.

## Part 3 — The screenshot evidence is real

1. Save the measurement.
2. Confirm the captured screenshot attached to it shows the actual scene with
   the measurement overlay, not a black frame. `ARSessionManager.snapshot()`
   returning an empty or black image is a known failure mode of this plugin
   family and was never observable without hardware.
3. Open the same inspection in the admin portal and confirm the measurement and
   its screenshot both render in the review panel.

## Part 4 — Offline capture and sync

1. Put the handset in airplane mode.
2. Capture a second AR measurement and save it.
3. Confirm it appears immediately in the inspection with a pending indicator.
4. Restore connectivity and let the outbox drain.
5. Confirm the measurement reaches the admin portal exactly once — no
   duplicate, no lost screenshot.

## Part 5 — The manual fallback still works

1. On the same inspection, add a measurement via **Enter manually**.
2. Confirm it saves, syncs, and is visually distinguishable in the admin
   review panel from an AR-captured one (method badge).
3. This path is the documented answer for a device where Part 1 fails, so
   confirm it works even on a handset where AR does.

## Recording the result

Add a row to `TESTING.md` with:

- Device model, OS version, ARCore or ARKit version
- Whether plane detection appeared (Part 1) — the D-063 answer
- The measured-vs-true pairs from Part 2, at both spans
- Whether the screenshot captured real scene content (Part 3)
- Anything that failed, with the exact on-screen message

If Part 1 fails on two or more supported devices, that is grounds to reopen
D-063 and consider the alternatives it named: a different plugin, a platform
channel, Unity, or dropping to manual-only measurement.
