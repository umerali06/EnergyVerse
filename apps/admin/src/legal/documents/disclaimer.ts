import type { LegalDocument } from "../legal-content";

export const industrialDisclaimer: LegalDocument = {
  slug: "industrial-disclaimer",
  title: "AI, AR/VR, Industrial Safety & Operations Disclaimer",
  lede: "What Flacron Energy's AI, AR measurement, reporting, 3D and VR tools are — and, just as importantly, what they are not.",
  intro: [
    {
      kind: "notice",
      title: "Important Notice",
      text: "Flacron Energy provides AI-assisted analysis, AR measurement, workflow, reporting, 3D visualization, and optional VR training tools. It does not replace qualified engineers, inspectors, maintenance professionals, HSE professionals, competent persons, licensed professionals, emergency systems, regulatory compliance programs, or site-specific procedures.",
      tone: "warning",
    },
  ],
  sections: [
    {
      id: "ai-assistance-only",
      title: "1. AI Assistance Only",
      blocks: [
        {
          kind: "p",
          text: "AI-generated detections, confidence scores, recommendations, summaries, risk indicators, and reports are decision-support outputs and may be incorrect, incomplete, outdated, or unsuitable for a specific asset or facility.",
        },
      ],
    },
    {
      id: "human-review",
      title: "2. Human Review Required",
      blocks: [
        {
          kind: "p",
          text: "Authorized personnel must review, confirm, edit, or reject AI findings before reports are finalized or operational decisions are made. The customer is responsible for establishing appropriate human-review and approval workflows.",
        },
      ],
    },
    {
      id: "ar-limitations",
      title: "3. AR Measurement Limitations",
      blocks: [
        {
          kind: "p",
          text: "AR measurements can vary based on hardware, calibration, environment, lighting, surface visibility, camera movement, software, and other factors. Verify safety-critical or construction-critical dimensions with appropriate professional methods.",
        },
      ],
    },
    {
      id: "no-certification",
      title: "4. No Engineering Certification",
      blocks: [
        {
          kind: "p",
          text: "Flacron Energy does not issue engineering certifications, fitness-for-service determinations, pressure-vessel certifications, pipeline integrity certifications, structural certifications, electrical certifications, or other licensed-professional determinations unless expressly performed by a separately engaged qualified professional.",
        },
      ],
    },
    {
      id: "emergency-use",
      title: "5. Safety and Emergency Use",
      blocks: [
        {
          kind: "p",
          text: "Do not rely on Flacron Energy as an emergency alarm, gas detector, fire alarm, process-safety interlock, shutdown system, life-safety system, SCADA safety function, or sole means of detecting hazardous conditions.",
        },
      ],
    },
    {
      id: "permit-to-work",
      title: "6. Permit-to-Work",
      blocks: [
        {
          kind: "p",
          text: "Electronic permit workflows do not by themselves establish that a work area is safe. Required isolation, atmospheric testing, LOTO, competent-person checks, PPE, barricading, approvals, and site procedures remain the customer's responsibility.",
        },
      ],
    },
    {
      id: "manual-data-entry",
      title: "7. Manual Data Entry",
      blocks: [
        {
          kind: "p",
          text: "Where temperature, pressure, vibration, noise, leak observations, operational status, or other values are manually entered, Flacron Energy does not independently verify their accuracy.",
        },
      ],
    },
    {
      id: "digital-twin",
      title: "8. Static Digital Twin / 3D View",
      blocks: [
        {
          kind: "p",
          text: "MVP 3D visualization is a static visual representation and should not be treated as live process telemetry, as-built survey data, or a real-time digital twin unless specifically integrated and contractually identified as such in a future release.",
        },
      ],
    },
    {
      id: "vr-training",
      title: "9. VR Training",
      blocks: [
        {
          kind: "p",
          text: "VR simulations are supplemental training tools. They do not replace legally required training, competency assessments, certifications, drills, site induction, or supervised practical instruction.",
        },
      ],
    },
    {
      id: "reports-and-risk",
      title: "10. Reports and Risk Scores",
      blocks: [
        {
          kind: "p",
          text: "Generated reports and risk scores are informational and workflow aids. Final inspection, maintenance, safety, regulatory, and operational decisions remain with qualified personnel and the customer organization.",
        },
        {
          kind: "notice",
          title: "Required App-Wide Safety Notice",
          text: "AI and AR outputs may contain errors. Review and verify findings, measurements, risk indicators, and recommendations before acting. Flacron Energy does not replace qualified professional judgment, required safety controls, or regulatory compliance procedures.",
          tone: "warning",
        },
        { kind: "contact" },
      ],
    },
  ],
};
