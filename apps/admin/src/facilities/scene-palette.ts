/**
 * The colour layer for the Three.js facility scene.
 *
 * WebGL materials, lights and fog take colour values directly -- they cannot
 * consume a Tailwind class or a CSS variable the way the DOM does. So the
 * repo-wide ban on raw hex (see `eslint.config.mjs`, Phase 2.1c) would have no
 * legal way to express a scene colour at all. This module is the single
 * exemption: every colour the 3D scene uses is declared here and nowhere else,
 * so the scene still has one place to change, exactly like the token layer it
 * sits beside.
 *
 * Status colours intentionally mirror the semantic roles in
 * `packages/design-tokens/tokens.json`; the industrial tones below are
 * scene-only and have no DOM equivalent.
 */

/** Scene shell -- background and depth fog. */
export const SCENE_BACKGROUND = "#090D16";
export const SCENE_FOG = "#090D16";

/** Lighting rig. */
export const LIGHT_AMBIENT = "#94A3B8";
export const LIGHT_HEMISPHERE_SKY = "#38BDF8";
export const LIGHT_HEMISPHERE_GROUND = "#0F172A";
export const LIGHT_DIRECTIONAL = "#FFFFFF";

/** Ground plane and reference grid. */
export const GRID_PRIMARY = "#334155";
export const GRID_SECONDARY = "#1E293B";
export const GROUND = "#0B132B";

/** Structural materials for the procedural refinery. */
export const MATERIAL_METAL = "#475569";
export const MATERIAL_DARK_METAL = "#1E293B";
export const MATERIAL_PIPE = "#64748B";
export const MATERIAL_ACCENT = "#0284C7";

/** Asset hotspot markers, keyed by the asset's rolled-up health. */
export const HOTSPOT_HEALTHY = "#10B981";
export const HOTSPOT_WARNING = "#F59E0B";
export const HOTSPOT_CRITICAL = "#EF4444";
