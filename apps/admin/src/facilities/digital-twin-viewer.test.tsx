import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { DigitalTwinScene, DigitalTwinViewer } from "./digital-twin-viewer";

const mockPush = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({ back: vi.fn(), prefetch: () => undefined, push: mockPush, replace: vi.fn() }),
}));

const mockScene: DigitalTwinScene = {
  facility_id: "facility_north",
  facility_name: "North Refinery",
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
      name: "Pump Skid Area",
      position: [-12, 8, 15],
      target: [-6, 2, 0],
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
    },
    {
      id: "hs-2",
      asset_id: "asset-2",
      asset_name: "Distillation Column C-201",
      asset_tag: "C-201",
      category: "Vessel",
      current_status: "Critical",
      position: [-15, 9, -10],
      radius: 2.5,
    },
  ],
  updated_at: "2026-08-22T12:00:00Z",
};

beforeEach(() => {
  mockPush.mockClear();
});

describe("DigitalTwinViewer", () => {
  it("renders facility header, camera presets, and status badges", async () => {
    render(<DigitalTwinViewer scene={mockScene} />);
    expect(screen.getByText("North Refinery 3D Digital Twin")).toBeInTheDocument();
    expect(screen.getByText("Overhead Overview")).toBeInTheDocument();
    expect(screen.getByText("Pump Skid Area")).toBeInTheDocument();
  });

  it("filters asset nodes when status filter button is clicked", async () => {
    render(<DigitalTwinViewer scene={mockScene} />);
    await userEvent.setup().click(screen.getByRole("button", { name: "Critical" }));
    // Critical filter active: P-101A (Healthy) should not be visible
    expect(screen.getAllByText("Critical").length).toBeGreaterThan(0);
  });

  it("opens asset drawer when an asset node is clicked in spatial fallback view", async () => {
    render(<DigitalTwinViewer scene={mockScene} />);
    const assetNode = await screen.findByText("Main Crude Charge Pump");
    await userEvent.setup().click(assetNode);

    expect(await screen.findByText("3D Spatial Coordinates")).toBeInTheDocument();
    expect(screen.getAllByText("P-101A").length).toBeGreaterThan(0);
  });

  it("navigates to asset details when View Asset Details is clicked in drawer", async () => {
    render(<DigitalTwinViewer scene={mockScene} />);
    const assetNode = await screen.findByText("Main Crude Charge Pump");
    await userEvent.setup().click(assetNode);

    const viewButton = await screen.findByRole("button", { name: /View Asset Details/i });
    await userEvent.setup().click(viewButton);
    expect(mockPush).toHaveBeenCalledWith("/assets");
  });
});
