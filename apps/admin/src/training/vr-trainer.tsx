"use client";

import type { DigitalTwinSceneResponse, TrainingModuleResponse } from "@fev/api-client";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import * as THREE from "three";
import { VRButton } from "three/examples/jsm/webxr/VRButton.js";

import { Button, cn } from "@/design-system";

import {
  GRID_PRIMARY,
  GRID_SECONDARY,
  GROUND,
  HOTSPOT_CRITICAL,
  HOTSPOT_HEALTHY,
  HOTSPOT_WARNING,
  LIGHT_AMBIENT,
  LIGHT_DIRECTIONAL,
  LIGHT_HEMISPHERE_GROUND,
  LIGHT_HEMISPHERE_SKY,
  SCENE_BACKGROUND,
  SCENE_FOG,
  TARGET_ACTIVE,
  TARGET_CLEARED,
} from "@/facilities/scene-palette";

/** How close the trainee must get for a `locate`/`sequence` target to count. */
const TARGET_RADIUS_METRES = 3.5;

export type StepOutcome = {
  stepId: string;
  /** Whether the trainee reached the target. Meaningless for `choose` steps. */
  correct: boolean | null;
  /** What the trainee picked on a `choose` step; the server judges it. */
  selectedOption: string | null;
};

type Marker = {
  stepId: string;
  group: THREE.Group;
  position: THREE.Vector3;
};

function statusColor(status: string): string {
  if (status === "Healthy") return HOTSPOT_HEALTHY;
  if (status === "Warning") return HOTSPOT_WARNING;
  return HOTSPOT_CRITICAL;
}

/**
 * The WebXR scenario runner.
 *
 * Renders the facility's real 3D scene, drops a marker on the asset each step
 * points at, and advances as the trainee reaches or answers it. The same scene
 * is used on a desktop monitor and in a headset: entering VR is a mode of this
 * component, not a separate build, so a site without headsets still gets the
 * training.
 *
 * Every outcome is reported upward via `onStepComplete` rather than held here,
 * so a dropped session loses at most the current step -- progress already
 * recorded server-side survives.
 */
export function VrTrainer({
  module,
  scene,
  onStepComplete,
  onFinish,
  onExit,
}: {
  module: TrainingModuleResponse;
  scene: DigitalTwinSceneResponse;
  onStepComplete: (outcome: StepOutcome) => Promise<void> | void;
  onFinish: () => Promise<void> | void;
  onExit: () => void;
}) {
  const containerRef = useRef<HTMLDivElement>(null);
  const cameraRef = useRef<THREE.PerspectiveCamera | null>(null);
  const markersRef = useRef<Map<string, Marker>>(new Map());
  const [stepIndex, setStepIndex] = useState(0);
  const [xrSupported, setXrSupported] = useState(false);
  const [distance, setDistance] = useState<number | null>(null);
  const [busy, setBusy] = useState(false);
  const [finished, setFinished] = useState(false);

  const steps = useMemo(
    () => [...(module.steps ?? [])].sort((a, b) => a.order - b.order),
    [module.steps],
  );
  const step = steps[stepIndex];

  /** Where a step's target sits in the scene: an asset's hotspot, or a fixed
   * position for steps that are about a place rather than a thing. */
  const targetFor = useCallback(
    (stepId: string): THREE.Vector3 | null => {
      const candidate = steps.find((entry) => entry.id === stepId);
      if (!candidate) return null;
      if (candidate.targetAssetId) {
        const hotspot = (scene.hotspots ?? []).find(
          (spot) => spot.assetId === candidate.targetAssetId,
        );
        if (hotspot) {
          return new THREE.Vector3(hotspot.position[0], hotspot.position[1], hotspot.position[2]);
        }
      }
      if (candidate.targetPosition && candidate.targetPosition.length === 3) {
        const [x, y, z] = candidate.targetPosition;
        return new THREE.Vector3(x, y, z);
      }
      return null;
    },
    [scene.hotspots, steps],
  );

  useEffect(() => {
    // `isSessionSupported` is absent outside secure contexts and on browsers
    // without WebXR, so the desktop path must never depend on it.
    const xr = (navigator as Navigator & { xr?: { isSessionSupported(mode: string): Promise<boolean> } }).xr;
    if (!xr?.isSessionSupported) return;
    let active = true;
    void xr
      .isSessionSupported("immersive-vr")
      .then((supported) => {
        if (active) setXrSupported(supported);
      })
      .catch(() => undefined);
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const width = container.clientWidth || 800;
    const height = container.clientHeight || 600;

    const threeScene = new THREE.Scene();
    threeScene.background = new THREE.Color(SCENE_BACKGROUND);
    threeScene.fog = new THREE.FogExp2(SCENE_FOG, 0.012);

    const camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 500);
    // Eye height: the scene is authored in metres, so the trainee starts
    // standing rather than floating.
    camera.position.set(0, 1.7, 28);
    cameraRef.current = camera;

    let renderer: THREE.WebGLRenderer;
    try {
      renderer = new THREE.WebGLRenderer({ antialias: true });
    } catch {
      // jsdom and browsers without WebGL: the panel beside the canvas still
      // drives the whole module, so training is never blocked by this.
      return;
    }
    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.xr.enabled = true;
    container.appendChild(renderer.domElement);

    let vrButton: HTMLElement | null = null;
    try {
      vrButton = VRButton.createButton(renderer);
      vrButton.style.position = "absolute";
      vrButton.style.bottom = "16px";
      vrButton.style.left = "50%";
      vrButton.style.transform = "translateX(-50%)";
      container.appendChild(vrButton);
    } catch {
      vrButton = null;
    }

    threeScene.add(new THREE.AmbientLight(LIGHT_AMBIENT, 0.7));
    const hemi = new THREE.HemisphereLight(LIGHT_HEMISPHERE_SKY, LIGHT_HEMISPHERE_GROUND, 0.8);
    hemi.position.set(0, 50, 0);
    threeScene.add(hemi);
    const sun = new THREE.DirectionalLight(LIGHT_DIRECTIONAL, 1.1);
    sun.position.set(25, 45, 20);
    threeScene.add(sun);

    const grid = new THREE.GridHelper(120, 48, GRID_PRIMARY, GRID_SECONDARY);
    grid.position.y = 0.01;
    threeScene.add(grid);

    const ground = new THREE.Mesh(
      new THREE.PlaneGeometry(140, 140),
      new THREE.MeshStandardMaterial({ color: GROUND, roughness: 0.9, metalness: 0.1 }),
    );
    ground.rotation.x = -Math.PI / 2;
    threeScene.add(ground);

    // Every asset in the facility, so the trainee is learning the real layout.
    for (const hotspot of scene.hotspots ?? []) {
      const body = new THREE.Mesh(
        new THREE.BoxGeometry(2.2, 3, 2.2),
        new THREE.MeshStandardMaterial({
          color: statusColor(hotspot.currentStatus),
          roughness: 0.5,
          metalness: 0.4,
        }),
      );
      body.position.set(hotspot.position[0], hotspot.position[1], hotspot.position[2]);
      threeScene.add(body);
    }

    // A ring per targeted step, hidden until that step is active.
    const markers = new Map<string, Marker>();
    for (const entry of steps) {
      const position = targetFor(entry.id);
      if (!position) continue;
      const group = new THREE.Group();
      const ring = new THREE.Mesh(
        new THREE.TorusGeometry(TARGET_RADIUS_METRES, 0.16, 12, 48),
        new THREE.MeshBasicMaterial({ color: TARGET_ACTIVE }),
      );
      ring.rotation.x = -Math.PI / 2;
      group.add(ring);
      const beam = new THREE.Mesh(
        new THREE.CylinderGeometry(0.12, 0.12, 12, 12),
        new THREE.MeshBasicMaterial({ color: TARGET_ACTIVE, transparent: true, opacity: 0.35 }),
      );
      beam.position.y = 6;
      group.add(beam);
      group.position.set(position.x, 0.05, position.z);
      group.visible = false;
      threeScene.add(group);
      markers.set(entry.id, { stepId: entry.id, group, position });
    }
    markersRef.current = markers;

    // Orbit-free navigation: drag to look, WASD to walk. Deliberately not
    // OrbitControls -- a trainee should move through the site, not spin it.
    let yaw = 0;
    let dragging = false;
    let lastX = 0;
    const pressed = new Set<string>();

    const onPointerDown = (event: PointerEvent) => {
      dragging = true;
      lastX = event.clientX;
    };
    const onPointerUp = () => {
      dragging = false;
    };
    const onPointerMove = (event: PointerEvent) => {
      if (!dragging) return;
      yaw -= (event.clientX - lastX) * 0.005;
      lastX = event.clientX;
    };
    const onKeyDown = (event: KeyboardEvent) => pressed.add(event.key.toLowerCase());
    const onKeyUp = (event: KeyboardEvent) => pressed.delete(event.key.toLowerCase());

    renderer.domElement.addEventListener("pointerdown", onPointerDown);
    window.addEventListener("pointerup", onPointerUp);
    window.addEventListener("pointermove", onPointerMove);
    window.addEventListener("keydown", onKeyDown);
    window.addEventListener("keyup", onKeyUp);

    const onResize = () => {
      const nextWidth = container.clientWidth || width;
      const nextHeight = container.clientHeight || height;
      camera.aspect = nextWidth / nextHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(nextWidth, nextHeight);
    };
    window.addEventListener("resize", onResize);

    const clock = new THREE.Clock();
    renderer.setAnimationLoop(() => {
      const delta = clock.getDelta();
      const speed = 8 * delta;
      const forward = new THREE.Vector3(-Math.sin(yaw), 0, -Math.cos(yaw));
      const right = new THREE.Vector3(Math.cos(yaw), 0, -Math.sin(yaw));

      if (!renderer.xr.isPresenting) {
        if (pressed.has("w") || pressed.has("arrowup")) camera.position.addScaledVector(forward, speed);
        if (pressed.has("s") || pressed.has("arrowdown")) camera.position.addScaledVector(forward, -speed);
        if (pressed.has("a") || pressed.has("arrowleft")) camera.position.addScaledVector(right, -speed);
        if (pressed.has("d") || pressed.has("arrowright")) camera.position.addScaledVector(right, speed);
        camera.rotation.set(0, yaw, 0);
      }

      const elapsed = clock.getElapsedTime();
      for (const marker of markers.values()) {
        if (!marker.group.visible) continue;
        marker.group.rotation.y = elapsed * 0.6;
      }

      renderer.render(threeScene, camera);
    });

    return () => {
      renderer.setAnimationLoop(null);
      renderer.domElement.removeEventListener("pointerdown", onPointerDown);
      window.removeEventListener("pointerup", onPointerUp);
      window.removeEventListener("pointermove", onPointerMove);
      window.removeEventListener("keydown", onKeyDown);
      window.removeEventListener("keyup", onKeyUp);
      window.removeEventListener("resize", onResize);
      vrButton?.remove();
      renderer.domElement.remove();
      renderer.dispose();
      cameraRef.current = null;
    };
  }, [scene.hotspots, steps, targetFor]);

  // Show only the active step's marker, and report how far away the trainee is
  // so the panel can tell them whether they are getting warmer.
  useEffect(() => {
    for (const marker of markersRef.current.values()) {
      const active = marker.stepId === step?.id;
      marker.group.visible = active;
      const material = (marker.group.children[0] as THREE.Mesh | undefined)?.material;
      if (material instanceof THREE.MeshBasicMaterial) {
        material.color.set(active ? TARGET_ACTIVE : TARGET_CLEARED);
      }
    }
    if (!step) return;
    const timer = window.setInterval(() => {
      const camera = cameraRef.current;
      const marker = markersRef.current.get(step.id);
      if (!camera || !marker) {
        setDistance(null);
        return;
      }
      const flat = new THREE.Vector3(camera.position.x, 0, camera.position.z);
      setDistance(flat.distanceTo(new THREE.Vector3(marker.position.x, 0, marker.position.z)));
    }, 200);
    return () => window.clearInterval(timer);
  }, [step]);

  const withinTarget = distance != null && distance <= TARGET_RADIUS_METRES;

  async function advance(correct: boolean | null, selectedOption: string | null = null) {
    if (!step || busy) return;
    setBusy(true);
    try {
      await onStepComplete({ stepId: step.id, correct, selectedOption });
      if (stepIndex + 1 >= steps.length) {
        await onFinish();
        setFinished(true);
      } else {
        setStepIndex((index) => index + 1);
      }
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_340px]">
      <div
        className="relative min-h-[60vh] w-full overflow-hidden rounded-xl border border-border bg-black"
        data-testid="vr-trainer-canvas"
        ref={containerRef}
      />

      <aside className="flex flex-col gap-4 rounded-xl border border-border bg-surface p-4">
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.18em] text-primary-600 dark:text-primary-400">
            {module.kind.replace(/_/g, " ")}
          </p>
          <h2 className="mt-1 text-h5 font-bold">{module.title}</h2>
          <p className="mt-1 text-caption text-text-muted">
            Step {Math.min(stepIndex + 1, steps.length)} of {steps.length}
            {xrSupported ? " · headset ready" : " · desktop mode"}
          </p>
        </div>

        {finished ? (
          <div className="rounded-lg border border-border p-3">
            <p className="text-bodySmall font-semibold">Module complete</p>
            <p className="mt-1 text-caption text-text-secondary">
              Your result has been recorded against your training history.
            </p>
            <Button className="mt-3 w-full justify-center" onClick={onExit}>
              Back to training
            </Button>
          </div>
        ) : step ? (
          <div className="flex flex-1 flex-col gap-3">
            <div className="rounded-lg border border-border p-3">
              <p className="text-bodySmall font-semibold">{step.title}</p>
              <p className="mt-1 text-caption text-text-secondary">{step.instruction}</p>
              {step.timeLimitSeconds != null && (
                <p className="mt-2 font-mono text-caption text-status-warning">
                  Drill pace: {step.timeLimitSeconds}s
                </p>
              )}
            </div>

            {distance != null && step.action !== "choose" && (
              <p
                className={cn(
                  "font-mono text-caption",
                  withinTarget ? "text-status-success" : "text-text-muted",
                )}
              >
                {withinTarget
                  ? "You are at the target."
                  : `${distance.toFixed(1)} m from the target`}
              </p>
            )}

            {step.action === "choose" ? (
              <div className="grid gap-2">
                {(step.options ?? []).map((option: string) => (
                  <Button
                    className="justify-start text-left"
                    disabled={busy}
                    key={option}
                    // Scoring happens server-side: the correct answer is never
                    // sent to the client, so the runner reports the choice and
                    // the server decides.
                    onClick={() => void advance(null, option)}
                    variant="ghost"
                  >
                    {option}
                  </Button>
                ))}
              </div>
            ) : (
              <Button
                className="w-full justify-center"
                disabled={busy || (step.action === "locate" && !withinTarget)}
                loading={busy}
                onClick={() => void advance(step.action === "observe" || step.action === "acknowledge" ? null : withinTarget)}
              >
                {step.action === "locate"
                  ? withinTarget
                    ? "Confirm this is the equipment"
                    : "Walk to the highlighted target"
                  : "Mark step done"}
              </Button>
            )}

            <Button className="mt-auto w-full justify-center" onClick={onExit} variant="ghost">
              Leave module
            </Button>
          </div>
        ) : (
          <p className="text-bodySmall text-text-muted">This module has no steps yet.</p>
        )}
      </aside>
    </div>
  );
}
