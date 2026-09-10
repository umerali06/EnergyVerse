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

import { useCachedQuery } from "@/cache/cache-context";
import { DigitalTwinScene, DigitalTwinViewer } from "./digital-twin-viewer";

const DEFAULT_FACILITIES = [
  { id: "fac_north_refinery", name: "North Refinery Plant" },
  { id: "fac_compressor_station_2", name: "Compressor Station 2" },
];

export function DigitalTwinPage() {
  const { apiClient } = useAuth();
  const [selectedFacilityId, setSelectedFacilityId] = useState<string>("fac_north_refinery");

  // Load tenant facilities with Stale-While-Revalidate caching
  const facilitiesQuery = useCachedQuery<Array<{ id: string; name: string }>>(
    "facilities:list:50",
    async () => {
      try {
        const res = await apiClient.listFacilities({ limit: 50 });
        const items = res.items.map((f) => ({ id: f.id, name: f.name }));
        return items.length > 0 ? items : DEFAULT_FACILITIES;
      } catch {
        return DEFAULT_FACILITIES;
      }
    },
  );

  const facilities = facilitiesQuery.data ?? DEFAULT_FACILITIES;

  // Load 3D scene with Stale-While-Revalidate caching
  const sceneQuery = useCachedQuery<DigitalTwinScene>(
    `digital-twin:scene:${selectedFacilityId}`,
    async () => {
      let data: DigitalTwinScene | null = null;
      try {
        const res = await fetch(`/api/v1/facilities/${selectedFacilityId}/3d-scene`);
        if (res.ok) {
          data = (await res.json()) as DigitalTwinScene;
        }
      } catch {
        // Fallback to client synthesized scene
      }

      if (!data) {
        const selected = facilities.find((f) => f.id === selectedFacilityId);
        data = {
          facility_id: selectedFacilityId,
          facility_name: selected?.name || "North Refinery Plant",
          scene_type: "procedural_refinery",
          camera_presets: [
            {
              id: "cam_overhead",
              name: "Overhead Overview",
              position: [0, 30, 40],
              target: [0, 0, 0],
            },
            {
              id: "cam_pump_skid",
              name: "Pump Skid Station",
              position: [-12, 8, 15],
              target: [-6, 2, 0],
            },
            {
              id: "cam_tank_farm",
              name: "Tank Farm Area",
              position: [18, 12, 18],
              target: [10, 4, 0],
            },
          ],
          hotspots: [
            {
              id: "hs-1",
              asset_id: "asset-1",
              asset_name: "Main Crude Charge Pump",
              asset_tag: "P-101A",
              category: "Pump",
              current_status: "Healthy",
              position: [-6, 1.8, 10],
              radius: 1.5,
              label: "Main Crude Charge Pump (P-101A)",
            },
            {
              id: "hs-2",
              asset_id: "asset-2",
              asset_name: "Hydrocracker Inlet Valve",
              asset_tag: "V-204B",
              category: "Valve",
              current_status: "Warning",
              position: [0, 4.5, 0],
              radius: 1.5,
              label: "Hydrocracker Inlet Valve (V-204B)",
            },
            {
              id: "hs-3",
              asset_id: "asset-3",
              asset_name: "High Pressure Gas Separator",
              asset_tag: "SEP-301",
              category: "Separator",
              current_status: "Critical",
              position: [12, 2.5, -8],
              radius: 2.0,
              label: "High Pressure Separator (SEP-301)",
            },
          ],
        };
      }
      return data;
    },
    { enabled: Boolean(selectedFacilityId) },
  );

  const scene = sceneQuery.data;
  const loadingFacilities = facilitiesQuery.loading;
  const loadingScene = sceneQuery.loading && !scene;
  const error = facilitiesQuery.error ? "Unable to load facilities for 3D View" : null;

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
                <Button variant="ghost" onClick={() => setSelectedFacilityId(selectedFacilityId)}>
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
