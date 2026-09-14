import Link from "next/link";

/**
 * The in-product safety notices, in one place.
 *
 * The package requires specific wording on specific screens: AI analysis, AR
 * inspection, safety reporting, permit-to-work, work orders, the 3D view, VR
 * training, and report export. Keeping the text here rather than inline on each
 * screen is what makes the wording auditable — a notice can be proven present
 * and proven identical to the published disclaimer, and changing it once
 * changes it everywhere.
 *
 * Every notice links to the full disclaimer, so a reader is one click from the
 * complete text rather than only the summary.
 */

export type SafetyNoticeKind =
  | "ai-analysis"
  | "ar-measurement"
  | "safety-report"
  | "permit-to-work"
  | "work-order"
  | "digital-twin"
  | "vr-training"
  | "report-export"
  | "offline-sync";

const NOTICES: Record<SafetyNoticeKind, { title: string; body: string }> = {
  "ai-analysis": {
    title: "AI review required",
    body: "AI-detected corrosion, cracks, leaks, missing components, wear, damage, abnormalities, confidence scores, or recommended actions are advisory. An authorized inspector or qualified professional must review and confirm findings before they are finalized or relied upon.",
  },
  "ar-measurement": {
    title: "Verify critical measurements",
    body: "AR measurements and annotations may be affected by device and environmental conditions. Verify safety-critical, engineering-critical, fabrication, construction, isolation, or regulatory measurements using appropriate professional methods.",
  },
  "safety-report": {
    title: "Safety-critical notice",
    body: "Flacron Energy supports reporting and workflow management but is not an emergency-response or life-safety system. Follow site emergency procedures and contact the appropriate emergency or safety personnel when immediate action is required.",
  },
  "permit-to-work": {
    title: "Permit approval does not replace field verification",
    body: "Digital approval does not by itself confirm that hazards have been eliminated or controlled. Required isolations, tests, LOTO, PPE, barricades, competent-person checks, and site procedures must be completed and verified independently.",
  },
  "work-order": {
    title: "Maintenance decision notice",
    body: "Work-order recommendations, priorities, AI findings, and generated maintenance summaries are workflow aids. Qualified maintenance personnel remain responsible for determining safe repair methods, parts, procedures, and return-to-service decisions.",
  },
  "digital-twin": {
    title: "Static 3D visualization",
    body: "3D visualization is for navigation and operational context. Unless specifically integrated and identified otherwise, it is not a live digital twin, certified as-built survey, or real-time source of process condition.",
  },
  "vr-training": {
    title: "Supplemental training only",
    body: "VR simulations are supplemental training tools. Completion does not replace required certifications, practical competency assessments, site induction, supervised instruction, or legally required training.",
  },
  "report-export": {
    title: "Review before finalizing",
    body: "Confirm asset identity, inspection findings, measurements, photos, dates, safety information, maintenance history, AI findings, recommendations, risk scores, signatures, and approvals before issuing or relying on this report.",
  },
  "offline-sync": {
    title: "Queued until synchronized",
    body: "Offline work is stored on this device until connectivity is restored. Do not assume queued safety, permit, inspection, or maintenance information has reached the server until synchronization is confirmed.",
  },
};

/**
 * A compact, always-visible notice. Deliberately not dismissible: the package
 * requires these to be easy to locate on the screen they govern, and a notice
 * that can be permanently dismissed is absent for every session afterwards.
 */
export function SafetyNotice({
  kind,
  className,
}: {
  kind: SafetyNoticeKind;
  className?: string;
}) {
  const notice = NOTICES[kind];
  return (
    <aside
      aria-label={notice.title}
      className={`rounded-lg border border-accent-500/40 bg-accent-500/5 p-4 ${className ?? ""}`}
      role="note"
    >
      <p className="flex items-center gap-2 text-bodySmall font-semibold text-text-primary">
        <svg
          aria-hidden
          className="size-4 shrink-0 text-accent-600 dark:text-accent-400"
          fill="none"
          stroke="currentColor"
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth="2"
          viewBox="0 0 24 24"
        >
          <path d="M12 9v4M12 17h.01" />
          <path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
        </svg>
        {notice.title}
      </p>
      <p className="mt-2 text-caption leading-relaxed text-text-secondary">
        {notice.body}{" "}
        <Link
          className="font-semibold text-accent-600 underline underline-offset-2 dark:text-accent-400"
          href="/industrial-disclaimer"
        >
          Read the full disclaimer
        </Link>
        .
      </p>
    </aside>
  );
}
