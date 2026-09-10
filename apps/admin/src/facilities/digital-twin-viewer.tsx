"use client";

import { useEffect, useRef, useState } from "react";
import * as THREE from "three";
import { useRouter } from "next/navigation";

import { Badge, Button, StatusPill, type StatusTone } from "@/design-system";

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
  MATERIAL_ACCENT,
  MATERIAL_DARK_METAL,
  MATERIAL_METAL,
  MATERIAL_PIPE,
  SCENE_BACKGROUND,
  SCENE_FOG,
} from "./scene-palette";

function statusTone(status: DigitalTwinHotspot["current_status"]): StatusTone {
  if (status === "Healthy") return "healthy";
  if (status === "Warning") return "warning";
  return "critical";
}

function IconSvg({ path, className = "h-4 w-4" }: { path: string; className?: string }) {
  return (
    <svg
      aria-hidden
      className={className}
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="1.8"
      viewBox="0 0 24 24"
    >
      <path d={path} />
    </svg>
  );
}

const BoxIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16zM3.3 7.3 12 12.3l8.7-5M12 22V12" />
);

const CameraIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3zM12 17a4 4 0 1 0 0-8 4 4 0 0 0 0 8z" />
);

const LayersIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="m12 2 10 5-10 5L2 7l10-5zm0 9 10 5-10 5-10-5 10-5zm0 9 10 5-10 5-10-5 10-5z" />
);

const ExternalLinkIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6M15 3h6v6M10 14L21 3" />
);

const WrenchIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="M14.7 6.3a4 4 0 0 0-5.4 5.4L3 18v3h3l6.3-6.3a4 4 0 0 0 5.4-5.4l-2.8 2.8-2.1-2.1 2.9-2.7z" />
);

export interface CameraPreset {
  id: string;
  name: string;
  position: [number, number, number];
  target: [number, number, number];
}

export interface DigitalTwinHotspot {
  id: string;
  asset_id: string;
  asset_name: string;
  asset_tag: string;
  category: string;
  current_status: "Healthy" | "Warning" | "Critical";
  position: [number, number, number];
  radius: number;
  label?: string | null;
}

export interface DigitalTwinScene {
  facility_id: string;
  facility_name: string;
  model_3d_url?: string | null;
  scene_type: string;
  camera_presets: CameraPreset[];
  hotspots: DigitalTwinHotspot[];
  updated_at: string;
}

interface DigitalTwinViewerProps {
  scene: DigitalTwinScene;
  onUpdateHotspotPosition?: (hotspotId: string, position: [number, number, number]) => void;
  readOnly?: boolean;
}

export function DigitalTwinViewer({ scene, readOnly = true }: DigitalTwinViewerProps) {
  const router = useRouter();
  const containerRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const [selectedHotspot, setSelectedHotspot] = useState<DigitalTwinHotspot | null>(null);
  const [hoveredHotspot, setHoveredHotspot] = useState<DigitalTwinHotspot | null>(null);
  const [activePreset, setActivePreset] = useState<string | null>("cam_overhead");
  const [is3DMode, setIs3DMode] = useState<boolean>(true);
  const [statusFilter, setStatusFilter] = useState<"All" | "Healthy" | "Warning" | "Critical">("All");
  const [webGlAvailable, setWebGlAvailable] = useState<boolean>(true);
  const [projectedCoords, setProjectedCoords] = useState<
    Map<string, { left: number; top: number; visible: boolean }>
  >(new Map());

  const threeRefs = useRef<{
    scene: THREE.Scene;
    camera: THREE.PerspectiveCamera;
    renderer: THREE.WebGLRenderer;
    hotspotMeshes: Map<string, THREE.Group>;
    targetCameraPos: THREE.Vector3;
    targetCameraLookAt: THREE.Vector3;
    currentLookAt: THREE.Vector3;
    isDragging: boolean;
    previousMousePosition: { x: number; y: number };
    animationFrameId: number | null;
  } | null>(null);

  const filteredHotspots = scene.hotspots.filter(
    (h) => statusFilter === "All" || h.current_status === statusFilter,
  );

  // Initialize Three.js scene
  useEffect(() => {
    if (!canvasRef.current || !containerRef.current) return;

    try {
      const container = containerRef.current;
      const width = container.clientWidth || 800;
      const height = container.clientHeight || 550;

      // Scene setup
      const threeScene = new THREE.Scene();
      threeScene.background = new THREE.Color(SCENE_BACKGROUND);
      threeScene.fog = new THREE.FogExp2(SCENE_FOG, 0.015);

      // Camera setup
      const camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 1000);
      const defaultPos = scene.camera_presets[0]?.position || [0, 30, 40];
      const defaultTarget = scene.camera_presets[0]?.target || [0, 0, 0];
      camera.position.set(defaultPos[0], defaultPos[1], defaultPos[2]);

      // Renderer setup
      const renderer = new THREE.WebGLRenderer({
        canvas: canvasRef.current,
        antialias: true,
        alpha: false,
        powerPreference: "high-performance",
      });
      renderer.setSize(width, height);
      renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
      renderer.shadowMap.enabled = true;
      renderer.shadowMap.type = THREE.PCFSoftShadowMap;

      // Lighting setup
      const ambientLight = new THREE.AmbientLight(LIGHT_AMBIENT, 0.6);
      threeScene.add(ambientLight);

      const hemiLight = new THREE.HemisphereLight(LIGHT_HEMISPHERE_SKY, LIGHT_HEMISPHERE_GROUND, 0.7);
      hemiLight.position.set(0, 50, 0);
      threeScene.add(hemiLight);

      const dirLight = new THREE.DirectionalLight(LIGHT_DIRECTIONAL, 1.2);
      dirLight.position.set(25, 45, 20);
      dirLight.castShadow = true;
      dirLight.shadow.mapSize.width = 2048;
      dirLight.shadow.mapSize.height = 2048;
      dirLight.shadow.camera.near = 0.5;
      dirLight.shadow.camera.far = 150;
      threeScene.add(dirLight);

      // Facility Environment (Procedural Refinery Layout)
      buildProceduralRefinery(threeScene);

      // Hotspot Meshes
      const hotspotMeshes = new Map<string, THREE.Group>();
      filteredHotspots.forEach((hotspot) => {
        const group = createHotspotMesh(hotspot);
        threeScene.add(group);
        hotspotMeshes.set(hotspot.id, group);
      });

      const currentLookAt = new THREE.Vector3(defaultTarget[0], defaultTarget[1], defaultTarget[2]);
      const targetCameraPos = new THREE.Vector3(defaultPos[0], defaultPos[1], defaultPos[2]);
      const targetCameraLookAt = new THREE.Vector3(defaultTarget[0], defaultTarget[1], defaultTarget[2]);

      threeRefs.current = {
        scene: threeScene,
        camera,
        renderer,
        hotspotMeshes,
        targetCameraPos,
        targetCameraLookAt,
        currentLookAt,
        isDragging: false,
        previousMousePosition: { x: 0, y: 0 },
        animationFrameId: null,
      };

      setWebGlAvailable(true);

      // Animation Loop
      let clock = new THREE.Clock();
      const animate = () => {
        if (!threeRefs.current) return;

        const { scene: sc, camera: cam, renderer: rend, targetCameraPos: tPos, targetCameraLookAt: tLook, currentLookAt: cLook } = threeRefs.current;
        const elapsedTime = clock.getElapsedTime();

        // Smooth camera transitions
        cam.position.lerp(tPos, 0.05);
        cLook.lerp(tLook, 0.05);
        cam.lookAt(cLook);

        // Pulsing hotspot animation
        threeRefs.current.hotspotMeshes.forEach((group) => {
          const halo = group.getObjectByName("halo");
          if (halo) {
            const scale = 1.0 + Math.sin(elapsedTime * 3) * 0.15;
            halo.scale.set(scale, scale, scale);
          }
        });

        rend.render(sc, cam);

        // Project 3D positions to 2D screen coordinates
        updateScreenProjections(cam, container);

        threeRefs.current.animationFrameId = requestAnimationFrame(animate);
      };

      animate();

      // Handle Resize
      const handleResize = () => {
        if (!containerRef.current || !threeRefs.current) return;
        const w = containerRef.current.clientWidth || 800;
        const h = containerRef.current.clientHeight || 550;
        threeRefs.current.camera.aspect = w / h;
        threeRefs.current.camera.updateProjectionMatrix();
        threeRefs.current.renderer.setSize(w, h);
      };

      window.addEventListener("resize", handleResize);

      return () => {
        window.removeEventListener("resize", handleResize);
        if (threeRefs.current?.animationFrameId) {
          cancelAnimationFrame(threeRefs.current.animationFrameId);
        }
        renderer.dispose();
      };
    } catch {
      setWebGlAvailable(false);
    }
  }, [scene]);

  // Update hotspots when statusFilter changes
  useEffect(() => {
    if (!threeRefs.current) return;
    const { scene: threeScene, hotspotMeshes } = threeRefs.current;

    // Clear old hotspot meshes
    hotspotMeshes.forEach((group) => threeScene.remove(group));
    hotspotMeshes.clear();

    // Add filtered hotspot meshes
    filteredHotspots.forEach((hotspot) => {
      const group = createHotspotMesh(hotspot);
      threeScene.add(group);
      hotspotMeshes.set(hotspot.id, group);
    });
  }, [statusFilter, scene]);

  // Project 3D hotspot positions to 2D DOM screen space
  const updateScreenProjections = (camera: THREE.PerspectiveCamera, container: HTMLDivElement) => {
    const coordsMap = new Map<string, { left: number; top: number; visible: boolean }>();
    const width = container.clientWidth;
    const height = container.clientHeight;

    filteredHotspots.forEach((hotspot) => {
      const pos = new THREE.Vector3(hotspot.position[0], hotspot.position[1] + 1.2, hotspot.position[2]);
      pos.project(camera);

      // Check if behind camera
      const visible = pos.z < 1;
      const left = ((pos.x + 1) * width) / 2;
      const top = ((-pos.y + 1) * height) / 2;

      coordsMap.set(hotspot.id, { left, top, visible });
    });

    setProjectedCoords(coordsMap);
  };

  // Switch camera to preset
  const handleSelectPreset = (preset: CameraPreset) => {
    setActivePreset(preset.id);
    if (!threeRefs.current) return;
    threeRefs.current.targetCameraPos.set(preset.position[0], preset.position[1], preset.position[2]);
    threeRefs.current.targetCameraLookAt.set(preset.target[0], preset.target[1], preset.target[2]);
  };

  // Mouse Orbit Drag Handling
  const handleMouseDown = (e: React.MouseEvent) => {
    if (!threeRefs.current) return;
    threeRefs.current.isDragging = true;
    threeRefs.current.previousMousePosition = { x: e.clientX, y: e.clientY };
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!threeRefs.current || !threeRefs.current.isDragging) return;
    const deltaX = e.clientX - threeRefs.current.previousMousePosition.x;
    const deltaY = e.clientY - threeRefs.current.previousMousePosition.y;

    const camera = threeRefs.current.camera;
    const lookAt = threeRefs.current.targetCameraLookAt;

    // Orbit horizontally & vertically around lookAt target
    const offset = camera.position.clone().sub(lookAt);
    const radius = offset.length();
    let theta = Math.atan2(offset.x, offset.z) - deltaX * 0.005;
    let phi = Math.acos(Math.max(-1, Math.min(1, offset.y / radius))) - deltaY * 0.005;
    phi = Math.max(0.1, Math.min(Math.PI - 0.1, phi));

    offset.x = radius * Math.sin(phi) * Math.sin(theta);
    offset.y = radius * Math.cos(phi);
    offset.z = radius * Math.sin(phi) * Math.cos(theta);

    camera.position.copy(lookAt).add(offset);
    threeRefs.current.targetCameraPos.copy(camera.position);

    threeRefs.current.previousMousePosition = { x: e.clientX, y: e.clientY };
  };

  const handleMouseUp = () => {
    if (threeRefs.current) {
      threeRefs.current.isDragging = false;
    }
  };

  const handleWheel = (e: React.WheelEvent) => {
    if (!threeRefs.current) return;
    const camera = threeRefs.current.camera;
    const lookAt = threeRefs.current.targetCameraLookAt;
    const direction = camera.position.clone().sub(lookAt).normalize();
    const factor = e.deltaY > 0 ? 1.1 : 0.9;

    const newPos = lookAt.clone().add(camera.position.clone().sub(lookAt).multiplyScalar(factor));
    if (newPos.distanceTo(lookAt) > 5 && newPos.distanceTo(lookAt) < 150) {
      threeRefs.current.targetCameraPos.copy(newPos);
    }
  };

  return (
    <div className="relative flex flex-col h-full w-full rounded-xl border border-border bg-slate-950 overflow-hidden shadow-2xl">
      {/* Top Toolbar */}
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border/80 bg-slate-900/90 px-4 py-3 backdrop-blur-md z-10">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary-500/20 text-primary-400 border border-primary-500/30">
            <BoxIcon className="h-5 w-5" />
          </div>
          <div>
            <h2 className="text-body font-bold text-white flex items-center gap-2">
              {scene.facility_name} 3D Digital Twin
              <Badge className="text-caption font-mono text-primary-300">
                {scene.scene_type}
              </Badge>
            </h2>
            <p className="text-caption text-slate-400">
              Interactive 3D Spatial Layout • {scene.hotspots.length} Asset Nodes
            </p>
          </div>
        </div>

        {/* View Controls & Filters */}
        <div className="flex items-center gap-2">
          {/* Status Filter Buttons */}
          <div className="flex rounded-lg border border-slate-700/60 bg-slate-800/80 p-0.5">
            {(["All", "Healthy", "Warning", "Critical"] as const).map((status) => (
              <button
                key={status}
                onClick={() => setStatusFilter(status)}
                className={`rounded-md px-2.5 py-1 text-caption font-medium transition-colors ${
                  statusFilter === status
                    ? "bg-slate-700 text-white shadow-sm"
                    : "text-slate-400 hover:text-slate-200"
                }`}
              >
                {status}
              </button>
            ))}
          </div>

          {/* Presets Dropdown */}
          {scene.camera_presets.length > 0 && (
            <div className="flex items-center gap-1 rounded-lg border border-slate-700/60 bg-slate-800/80 p-0.5">
              <CameraIcon className="ml-2 h-4 w-4 text-slate-400" />
              {scene.camera_presets.map((preset) => (
                <button
                  key={preset.id}
                  onClick={() => handleSelectPreset(preset)}
                  className={`rounded-md px-2.5 py-1 text-caption font-medium transition-colors ${
                    activePreset === preset.id
                      ? "bg-primary-600 text-white shadow-sm"
                      : "text-slate-300 hover:bg-slate-700/50"
                  }`}
                >
                  {preset.name}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Main 3D Viewport Container */}
      <div
        ref={containerRef}
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseUp}
        onWheel={handleWheel}
        className="relative flex-1 min-h-[70vh] w-full cursor-grab active:cursor-grabbing select-none overflow-hidden"
      >
        {webGlAvailable ? (
          <canvas ref={canvasRef} className="h-full w-full block" />
        ) : (
          /* 2D Isometric Spatial Fallback */
          <div className="flex h-full w-full flex-col items-center justify-center bg-slate-950 p-8 text-center">
            <LayersIcon className="h-12 w-12 text-primary-400 animate-pulse mb-3" />
            <h3 className="text-h5 font-bold text-white">2D Spatial Layout Mode</h3>
            <p className="text-bodySmall text-slate-400 max-w-md mt-1">
              WebGL standard renderer context unavailable. Displaying interactive spatial grid view.
            </p>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mt-6 max-w-2xl w-full">
              {filteredHotspots.map((hotspot) => (
                <button
                  key={hotspot.id}
                  onClick={() => setSelectedHotspot(hotspot)}
                  className={`flex flex-col items-start p-4 rounded-xl border transition-all text-left ${
                    selectedHotspot?.id === hotspot.id
                      ? "border-primary-500 bg-primary-500/10 ring-2 ring-primary-500/30"
                      : "border-slate-800 bg-slate-900/80 hover:border-slate-700"
                  }`}
                >
                  <div className="flex items-center justify-between w-full mb-2">
                    <span className="font-mono text-caption text-slate-400">{hotspot.asset_tag}</span>
                    <StatusPill tone={statusTone(hotspot.current_status)}>
                      {hotspot.current_status}
                    </StatusPill>
                  </div>
                  <span className="text-bodySmall font-bold text-white">{hotspot.asset_name}</span>
                  <span className="text-caption text-slate-400 mt-1">
                    Position: ({hotspot.position.join(", ")})
                  </span>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* 2D Projected Hotspot Badges Over 3D Canvas */}
        {webGlAvailable &&
          filteredHotspots.map((hotspot) => {
            const coord = projectedCoords.get(hotspot.id);
            if (!coord || !coord.visible) return null;

            const isSelected = selectedHotspot?.id === hotspot.id;
            const isHovered = hoveredHotspot?.id === hotspot.id;

            const statusBg =
              hotspot.current_status === "Healthy"
                ? "bg-emerald-500"
                : hotspot.current_status === "Warning"
                ? "bg-amber-500"
                : "bg-red-500";

            return (
              <div
                key={hotspot.id}
                style={{
                  position: "absolute",
                  left: `${coord.left}px`,
                  top: `${coord.top}px`,
                  transform: "translate(-50%, -100%)",
                  pointerEvents: "auto",
                }}
                className="z-20 group"
                onClick={(e) => {
                  e.stopPropagation();
                  setSelectedHotspot(hotspot);
                }}
                onMouseEnter={() => setHoveredHotspot(hotspot)}
                onMouseLeave={() => setHoveredHotspot(null)}
              >
                <div
                  className={`flex items-center gap-1.5 rounded-full border px-2.5 py-1 backdrop-blur-md shadow-lg transition-all duration-200 cursor-pointer ${
                    isSelected
                      ? "border-white bg-slate-900 text-white scale-110 ring-4 ring-primary-500/40"
                      : isHovered
                      ? "border-slate-300 bg-slate-900/90 text-white scale-105"
                      : "border-slate-700/80 bg-slate-950/80 text-slate-200"
                  }`}
                >
                  <span className={`h-2.5 w-2.5 rounded-full animate-ping-slow ${statusBg}`} />
                  <span className="font-mono text-caption font-bold">{hotspot.asset_tag}</span>
                </div>
              </div>
            );
          })}

        {/* Selected Hotspot Asset Side Drawer */}
        {selectedHotspot && (
          <div className="absolute right-4 top-4 bottom-4 z-30 w-80 rounded-xl border border-slate-700 bg-slate-900/95 p-5 backdrop-blur-xl shadow-2xl flex flex-col justify-between animate-in slide-in-from-right">
            <div>
              <div className="flex items-start justify-between">
                <div>
                  <span className="font-mono text-caption text-primary-400 font-bold uppercase tracking-wider">
                    {selectedHotspot.asset_tag}
                  </span>
                  <h3 className="text-h5 font-bold text-white mt-0.5">{selectedHotspot.asset_name}</h3>
                </div>
                <button
                  onClick={() => setSelectedHotspot(null)}
                  className="rounded-lg p-1 text-slate-400 hover:bg-slate-800 hover:text-white"
                >
                  ✕
                </button>
              </div>

              <div className="mt-4 flex items-center gap-2">
                <StatusPill tone={statusTone(selectedHotspot.current_status)}>
                  {selectedHotspot.current_status}
                </StatusPill>
                <span className="text-caption text-slate-400">{selectedHotspot.category}</span>
              </div>

              {/* Spatial Position Card */}
              <div className="mt-5 rounded-lg border border-slate-800 bg-slate-950/60 p-3">
                <span className="text-caption font-medium text-slate-400 block mb-1">
                  3D Spatial Coordinates
                </span>
                <div className="grid grid-cols-3 gap-2 font-mono text-caption text-slate-200 text-center">
                  <div className="rounded bg-slate-900 p-1.5">X: {selectedHotspot.position[0]}m</div>
                  <div className="rounded bg-slate-900 p-1.5">Y: {selectedHotspot.position[1]}m</div>
                  <div className="rounded bg-slate-900 p-1.5">Z: {selectedHotspot.position[2]}m</div>
                </div>
              </div>
            </div>

            {/* Actions */}
            <div className="grid gap-2 pt-4 border-t border-slate-800">
              <Button
                variant="primary"
                className="w-full justify-center"
                onClick={() => router.push(`/assets/${selectedHotspot.asset_id}`)}
              >
                <ExternalLinkIcon className="mr-2 h-4 w-4" />
                View Asset Details
              </Button>
              <Button
                variant="ghost"
                className="w-full justify-center text-slate-200"
                onClick={() =>
                  router.push(`/work-orders?createForAsset=${selectedHotspot.asset_id}`)
                }
              >
                <WrenchIcon className="mr-2 h-4 w-4" />
                Create Work Order
              </Button>
            </div>
          </div>
        )}
      </div>

      {/* Footer Legend */}
      <div className="flex items-center justify-between border-t border-border/80 bg-slate-900/90 px-4 py-2 text-caption text-slate-400 z-10">
        <div className="flex items-center gap-4">
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-emerald-500" /> Healthy
          </span>
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-amber-500" /> Warning
          </span>
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-red-500" /> Critical
          </span>
        </div>
        <span className="font-mono text-slate-500">Drag mouse to orbit • Scroll to zoom</span>
      </div>
    </div>
  );
}

// Procedural 3D Industrial Refinery Layout Constructor
function buildProceduralRefinery(scene: THREE.Scene) {
  // Ground Grid
  const gridHelper = new THREE.GridHelper(100, 40, GRID_PRIMARY, GRID_SECONDARY);
  gridHelper.position.y = -0.01;
  scene.add(gridHelper);

  const groundGeo = new THREE.PlaneGeometry(120, 120);
  const groundMat = new THREE.MeshStandardMaterial({
    color: GROUND,
    roughness: 0.8,
    metalness: 0.2,
  });
  const ground = new THREE.Mesh(groundGeo, groundMat);
  ground.rotation.x = -Math.PI / 2;
  ground.receiveShadow = true;
  scene.add(ground);

  // Materials
  const metalMat = new THREE.MeshStandardMaterial({
    color: MATERIAL_METAL,
    roughness: 0.4,
    metalness: 0.8,
  });
  const darkMetalMat = new THREE.MeshStandardMaterial({
    color: MATERIAL_DARK_METAL,
    roughness: 0.6,
    metalness: 0.7,
  });
  const pipeMat = new THREE.MeshStandardMaterial({
    color: MATERIAL_PIPE,
    roughness: 0.3,
    metalness: 0.9,
  });
  const accentMat = new THREE.MeshStandardMaterial({
    color: MATERIAL_ACCENT,
    roughness: 0.5,
    metalness: 0.5,
  });

  // 1. Distillation Towers
  for (let i = 0; i < 3; i++) {
    const radius = 2.5 - i * 0.4;
    const height = 18 - i * 3;
    const towerGeo = new THREE.CylinderGeometry(radius, radius, height, 24);
    const tower = new THREE.Mesh(towerGeo, metalMat);
    tower.position.set(-15 + i * 8, height / 2, -10);
    tower.castShadow = true;
    tower.receiveShadow = true;
    scene.add(tower);

    // Top Cap
    const capGeo = new THREE.SphereGeometry(radius, 16, 16, 0, Math.PI * 2, 0, Math.PI / 2);
    const cap = new THREE.Mesh(capGeo, metalMat);
    cap.position.set(-15 + i * 8, height, -10);
    scene.add(cap);
  }

  // 2. Storage Tanks (Tank Farm Area)
  for (let r = 0; r < 2; r++) {
    for (let c = 0; c < 2; c++) {
      const tankGeo = new THREE.CylinderGeometry(4.5, 4.5, 8, 32);
      const tank = new THREE.Mesh(tankGeo, darkMetalMat);
      tank.position.set(12 + c * 11, 4, -8 + r * 11);
      tank.castShadow = true;
      tank.receiveShadow = true;
      scene.add(tank);

      // Tank Roof
      const roofGeo = new THREE.ConeGeometry(4.6, 1.5, 32);
      const roof = new THREE.Mesh(roofGeo, accentMat);
      roof.position.set(12 + c * 11, 8.75, -8 + r * 11);
      scene.add(roof);
    }
  }

  // 3. Pipe Rack Racks & Connecting Tube Networks
  for (let p = 0; p < 4; p++) {
    const pipeGeo = new THREE.CylinderGeometry(0.3, 0.3, 35, 12);
    const pipe = new THREE.Mesh(pipeGeo, pipeMat);
    pipe.rotation.z = Math.PI / 2;
    pipe.position.set(0, 3 + p * 0.8, -5);
    scene.add(pipe);
  }

  // 4. Pump Skid Blocks
  const skidGeo = new THREE.BoxGeometry(6, 1.2, 4);
  const skid = new THREE.Mesh(skidGeo, darkMetalMat);
  skid.position.set(-6, 0.6, 10);
  skid.castShadow = true;
  scene.add(skid);

  for (let m = 0; m < 2; m++) {
    const motorGeo = new THREE.CylinderGeometry(0.8, 0.8, 2.2, 16);
    const motor = new THREE.Mesh(motorGeo, accentMat);
    motor.rotation.x = Math.PI / 2;
    motor.position.set(-7.5 + m * 3, 1.8, 10);
    scene.add(motor);
  }
}

// Create 3D Hotspot Spatial Marker Mesh
function createHotspotMesh(hotspot: DigitalTwinHotspot): THREE.Group {
  const group = new THREE.Group();
  group.position.set(hotspot.position[0], hotspot.position[1], hotspot.position[2]);

  const colorHex =
    hotspot.current_status === "Healthy"
      ? HOTSPOT_HEALTHY
      : hotspot.current_status === "Warning"
        ? HOTSPOT_WARNING
        : HOTSPOT_CRITICAL;

  // Inner Glowing Core Sphere
  const coreGeo = new THREE.SphereGeometry(0.5, 16, 16);
  const coreMat = new THREE.MeshBasicMaterial({ color: colorHex });
  const core = new THREE.Mesh(coreGeo, coreMat);
  group.add(core);

  // Outer Pulsing Ring Halo
  const haloGeo = new THREE.RingGeometry(0.7, 0.95, 24);
  const haloMat = new THREE.MeshBasicMaterial({
    color: colorHex,
    side: THREE.DoubleSide,
    transparent: true,
    opacity: 0.6,
  });
  const halo = new THREE.Mesh(haloGeo, haloMat);
  halo.name = "halo";
  halo.rotation.x = Math.PI / 2;
  group.add(halo);

  return group;
}
