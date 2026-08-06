import type { SignatureResponse } from "@fev/api-client";

/**
 * A read-only SVG rendering of a signature's drawn strokes (Phase 7.8 admin
 * review). Same `viewBox="0 0 100 100"` normalized-coordinate convention as
 * `AnnotationOverlay` -- the strokes are stretched into a fixed-height box
 * rather than overlaid on a photo, since a signature has no underlying image.
 */
export function SignaturePreview({ strokes }: { strokes: SignatureResponse["strokes"] }) {
  if (strokes.length === 0) return null;
  return (
    <svg
      aria-label="Signature"
      className="h-24 w-full rounded-md border border-border bg-elevated"
      preserveAspectRatio="none"
      role="img"
      viewBox="0 0 100 100"
    >
      {strokes.map((stroke, index) => (
        <polyline
          fill="none"
          key={index}
          points={stroke.points.map((p) => `${p.x * 100},${p.y * 100}`).join(" ")}
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth={1.5}
          className="text-text-primary"
        />
      ))}
    </svg>
  );
}
