"use client";

import { useEffect, useState } from "react";
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

const RefreshCwIcon = ({ className }: { className?: string }) => (
  <IconSvg className={className} path="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8m0 0V3m0 5h5M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16m0 0v5m0-5h-5" />
);

import { useAuth } from "@/auth/auth-context";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  MotionSection,
  Select,
  Skeleton,
} from "@/design-system";
import { SafetyNotice } from "@/legal/safety-notices";

import { useCachedQuery } from "@/cache/cache-context";
import { DigitalTwinScene, DigitalTwinViewer } from "./digital-twin-viewer";

export function DigitalTwinPage() {
  const { apiClient } = useAuth();
  const [selectedFacilityId, setSelectedFacilityId] = useState<string>("");

  // Load tenant facilities with Stale-While-Revalidate caching
  const facilitiesQuery = useCachedQuery<Array<{ id: string; name: string }>>(
    "facilities:list:50",
    async () => {
      const res = await apiClient.listFacilities({ limit: 50 });
      return res.items.map((f) => ({ id: f.id, name: f.name }));
    },
  );

  const facilities = facilitiesQuery.data ?? [];

  // Select the tenant's first real facility once the list resolves; there is
  // no hard-coded default facility to fall back on any more.
  useEffect(() => {
    if (!selectedFacilityId && facilities.length > 0) {
      setSelectedFacilityId(facilities[0].id);
    }
  }, [facilities, selectedFacilityId]);

  // The 3D scene comes from the tenant's real facility record. It previously
  // used a bare `fetch` to a relative URL -- which never reaches the API and
  // carries no bearer token -- and silently fell back to three hard-coded
  // sample assets, so the viewer showed fabricated equipment for every
  // tenant. It now goes through the authenticated client and surfaces a real
  // failure instead of inventing one.
  const sceneQuery = useCachedQuery<DigitalTwinScene>(
    `digital-twin:scene:${selectedFacilityId}`,
    async () => {
      const response = await apiClient.getFacility3dScene(selectedFacilityId);
      return {
        facility_id: response.facilityId,
        facility_name: response.facilityName,
        scene_type: response.sceneType ?? "procedural_refinery",
        updated_at: response.updatedAt.toISOString(),
        model_3d_url: response.model3dUrl ?? null,
        camera_presets: (response.cameraPresets ?? []).map((preset) => ({
          id: preset.id,
          name: preset.name,
          position: preset.position as [number, number, number],
          target: preset.target as [number, number, number],
        })),
        hotspots: (response.hotspots ?? []).map((hotspot) => ({
          id: hotspot.id,
          asset_id: hotspot.assetId,
          asset_name: hotspot.assetName,
          asset_tag: hotspot.assetTag,
          category: hotspot.category,
          current_status: hotspot.currentStatus,
          position: hotspot.position as [number, number, number],
          radius: hotspot.radius ?? 1.5,
          label: hotspot.label ?? hotspot.assetName,
        })),
      };
    },
    { enabled: Boolean(selectedFacilityId) },
  );

  const scene = sceneQuery.data;
  const loadingFacilities = facilitiesQuery.loading;
  const loadingScene = sceneQuery.loading && !scene;
  // A failed scene request must read as a failure. Without this it fell
  // through to the "No Facility Selected" empty state, presenting a broken
  // request as though the tenant simply had nothing to show.
  const error = facilitiesQuery.error
    ? "Unable to load facilities for the 3D view."
    : sceneQuery.error
      ? "The 3D scene for this facility could not be loaded."
      : null;

  return (
    <section className="p-4 md:p-6 min-h-[calc(100vh-4rem)] flex flex-col">
      <MotionSection className="mx-auto max-w-7xl w-full flex-1 flex flex-col">
        {/* Header */}
        <div className="flex flex-wrap items-start justify-between gap-4 mb-6">
          <div>
            <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400 flex items-center gap-2">
              <BoxIcon className="h-4 w-4" /> 3D Spatial Visualization • Static Twin
            </p>
            <h1 className="mt-2 text-h2 font-bold text-text-primary">Digital Twin 3D View</h1>
            <SafetyNotice className="mt-6" kind="digital-twin" />
            <p className="mt-1 text-bodySmall text-text-secondary">
              Inspect facility spatial layout, locate asset nodes in 3D, and monitor live status indicators.
            </p>
          </div>

          {/* Facility Selector */}
          {facilities.length > 0 && (
            <div className="w-64">
              <Select
                label="Facility"
                value={selectedFacilityId}
                onChange={(e) => setSelectedFacilityId(e.target.value)}
              >
                {facilities.map((f) => (
                  <option key={f.id} value={f.id}>
                    {f.name}
                  </option>
                ))}
              </Select>
            </div>
          )}
        </div>

        {/* Main Content Viewport */}
        {loadingFacilities || loadingScene ? (
          <Card className="flex-1 flex flex-col items-center justify-center p-12 text-center min-h-[70vh]">
            <RefreshCwIcon className="h-10 w-10 text-primary-500 animate-spin mb-4" />
            <h3 className="text-h5 font-bold text-text-primary">Loading 3D Digital Twin</h3>
            <p className="text-bodySmall text-text-secondary mt-1">
              Initializing WebGL scene viewport and mapping asset spatial anchors...
            </p>
          </Card>
        ) : error ? (
          <Card className="p-8">
            <EmptyState
              title="3D View Unavailable"
              description={error}
              action={
                <Button
                  variant="ghost"
                  onClick={() => {
                    void facilitiesQuery.refetch();
                    void sceneQuery.refetch();
                  }}
                >
                  Retry Loading Scene
                </Button>
              }
            />
          </Card>
        ) : scene ? (
          <div className="flex-1 min-h-[70vh] w-full">
            <DigitalTwinViewer scene={scene} />
          </div>
        ) : (
          <Card className="p-8">
            <EmptyState
              title="No Facility Selected"
              description="Select a facility from the dropdown above to render its 3D digital twin."
            />
          </Card>
        )}
      </MotionSection>
    </section>
  );
}
