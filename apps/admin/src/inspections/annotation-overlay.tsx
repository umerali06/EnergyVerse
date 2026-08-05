import type { AnnotationResponse } from "@fev/api-client";

export const DAMAGE_TYPE_LABELS: Record<string, string> = {
  corrosion: "Corrosion",
  rust: "Rust",
  crack: "Crack",
  surface_damage: "Surface damage",
  paint_deterioration: "Paint deterioration",
  missing_bolt: "Missing bolt",
  broken_component: "Broken component",
  leak: "Leak",
  wear: "Wear",
  other: "Other",
};

export function damageTypeLabel(damageType: string | null | undefined): string {
  if (!damageType) return "Unlabeled";
  return DAMAGE_TYPE_LABELS[damageType] ?? damageType;
}

/**
 * A read-only SVG overlay of [annotations] over a photo tile (Phase 7.5
 * admin review). `viewBox="0 0 100 100"` with `preserveAspectRatio="none"`
 * lets normalized (0-1) coordinates map directly onto the tile's own box
 * regardless of its pixel size -- the same "at-a-glance, not pixel-perfect"
 * tolerance as the mobile gallery's thumbnail overlay, since the sibling
 * `<img>` crops via `object-cover` while this stretches edge-to-edge. The
 * full review surface (7.11) is where a precisely aligned lightbox belongs.
 */
export function AnnotationOverlay({ annotations }: { annotations: AnnotationResponse[] }) {
  if (annotations.length === 0) return null;
  return (
    <svg
      className="pointer-events-none absolute inset-0 h-full w-full"
      preserveAspectRatio="none"
      viewBox="0 0 100 100"
    >
      {annotations.map((annotation) => (
        <AnnotationShape annotation={annotation} key={annotation.id} />
      ))}
    </svg>
  );
}

function AnnotationShape({ annotation }: { annotation: AnnotationResponse }) {
  const points = annotation.points.map((p) => ({ x: p.x * 100, y: p.y * 100 }));
  const color = annotation.color;
  const title = `${damageTypeLabel(annotation.damageType)}${annotation.note ? ` — ${annotation.note}` : ""}`;
  const strokeWidth = 1.5;

  switch (annotation.shape) {
    case "point":
      return (
        <circle cx={points[0].x} cy={points[0].y} fill={color} r={2}>
          <title>{title}</title>
        </circle>
      );
    case "rectangle": {
      const [a, b] = points;
      return (
        <rect
          fill="none"
          height={Math.abs(b.y - a.y)}
          stroke={color}
          strokeWidth={strokeWidth}
          width={Math.abs(b.x - a.x)}
          x={Math.min(a.x, b.x)}
          y={Math.min(a.y, b.y)}
        >
          <title>{title}</title>
        </rect>
      );
    }
    case "circle": {
      const [a, b] = points;
      return (
        <ellipse
          cx={(a.x + b.x) / 2}
          cy={(a.y + b.y) / 2}
          fill="none"
          rx={Math.abs(b.x - a.x) / 2}
          ry={Math.abs(b.y - a.y) / 2}
          stroke={color}
          strokeWidth={strokeWidth}
        >
          <title>{title}</title>
        </ellipse>
      );
    }
    case "arrow": {
      const [a, b] = points;
      return (
        <g>
          <line stroke={color} strokeWidth={strokeWidth} x1={a.x} x2={b.x} y1={a.y} y2={b.y} />
          <title>{title}</title>
        </g>
      );
    }
    case "freehand":
    default:
      return (
        <polyline
          fill="none"
          points={points.map((p) => `${p.x},${p.y}`).join(" ")}
          stroke={color}
          strokeWidth={strokeWidth}
        >
          <title>{title}</title>
        </polyline>
      );
  }
}
