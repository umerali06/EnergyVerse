import type { LegalDocument } from "../legal-content";

export const termsOfService: LegalDocument = {
  slug: "terms",
  title: "Terms of Service",
  lede: "The agreement governing access to and use of Flacron Energy, its applications, workflows, subscriptions, and enterprise services.",
  intro: [
    {
      kind: "p",
      text: "These Terms govern access to and use of Flacron Energy, including its web and mobile applications, dashboards, asset-management tools, QR scanning, AR inspections, AI analysis, safety reporting, permit-to-work workflows, work orders, reports, 3D visualization, VR training, subscriptions, enterprise services, and related functionality.",
    },
    { kind: "contact" },
    {
      kind: "p",
      text: "By creating an account, accepting an order form, purchasing a subscription, or using Flacron Energy, you agree to these Terms and any applicable enterprise agreement, order form, statement of work, or data-processing addendum.",
    },
  ],
  sections: [
    {
      id: "description",
      title: "1. Description of Flacron Energy",
      blocks: [
        {
          kind: "list",
          items: [
            "Enterprise asset and project management",
            "QR-based asset access",
            "AR-assisted industrial inspections",
            "AI photo and video analysis",
            "Manual condition/status entry",
            "Safety and incident reporting",
            "Permit-to-work workflows",
            "Maintenance work orders",
            "AI-assisted report generation",
            "Static 3D facility visualization",
            "Optional VR training",
            "Dashboards, search, analytics, notifications, and document management",
          ],
        },
      ],
    },
    {
      id: "eligibility",
      title: "2. Eligibility and Organizational Authority",
      blocks: [
        {
          kind: "list",
          items: [
            "You must have legal capacity to enter into a binding agreement.",
            "If you use Flacron Energy for an organization, you represent that you are authorized to do so.",
            "Access may be limited to authorized employees, contractors, inspectors, technicians, HSE personnel, executives, and administrators.",
          ],
        },
      ],
    },
    {
      id: "accounts",
      title: "3. Accounts, Roles and Access",
      blocks: [
        {
          kind: "list",
          items: [
            "Provide accurate account information.",
            "Protect passwords, devices, access tokens, and email accounts.",
            "Do not share credentials except through authorized enterprise identity systems.",
            "Do not attempt to access another customer's organization, assets, reports, media, or documents.",
            "Company administrators are responsible for assigning appropriate roles and promptly removing access when personnel no longer require it.",
          ],
        },
      ],
    },
    {
      id: "ai-assistance",
      title: "4. AI and Computer-Vision Assistance",
      blocks: [
        {
          kind: "list",
          items: [
            "AI output may be incomplete, incorrect, or unsuitable.",
            "AI findings are advisory and require qualified human review.",
            "The platform does not certify equipment condition, legal compliance, engineering fitness, or worker safety.",
            "Users remain responsible for validating findings, measurements, recommendations, risk scores, and generated reports before acting on them.",
          ],
        },
      ],
    },
    {
      id: "ar-measurements",
      title: "5. AR Measurements and Field Conditions",
      blocks: [
        {
          kind: "list",
          items: [
            "AR measurements may be affected by device hardware, camera calibration, lighting, surface visibility, movement, environmental conditions, or software limitations.",
            "AR measurements should not replace certified survey, engineering, metrology, or other legally required measurement methods.",
            "Users must verify critical dimensions before construction, isolation, repair, lifting, confined-space, electrical, excavation, or other safety-sensitive work.",
          ],
        },
      ],
    },
    {
      id: "safety-critical-use",
      title: "6. Safety-Critical Use",
      blocks: [
        {
          kind: "list",
          items: [
            "Flacron Energy is a workflow and decision-support platform. It is not an emergency-response system.",
            "Users must follow site procedures, lockout/tagout requirements, permit rules, PPE requirements, regulatory obligations, manufacturer instructions, and qualified-professional judgment.",
            "Do not rely on Flacron Energy as the sole control for preventing injury, environmental harm, fire, explosion, release, equipment failure, or other hazardous events.",
          ],
        },
      ],
    },
    {
      id: "permit-to-work",
      title: "7. Permit-to-Work",
      blocks: [
        {
          kind: "list",
          items: [
            "Digital permit workflows support administrative processing and recordkeeping.",
            "A digital approval does not replace required physical isolation, atmospheric testing, gas monitoring, lockout/tagout, competent-person review, or site-specific verification.",
            "Customer organizations are responsible for configuring approval chains and ensuring permits comply with their procedures and applicable law.",
          ],
        },
      ],
    },
    {
      id: "customer-content",
      title: "8. User and Customer Content",
      blocks: [
        {
          kind: "list",
          items: [
            "Customers retain ownership of content they lawfully submit.",
            "Flacron Enterprises LLC receives a limited right to host, process, transmit, analyze, reproduce, and generate outputs from submitted content as necessary to provide and secure the service.",
            "Customers are responsible for ensuring they have the rights and permissions necessary to upload operational, employee, contractor, facility, asset, media, and document information.",
          ],
        },
      ],
    },
    {
      id: "prohibited-uses",
      title: "9. Prohibited Uses",
      blocks: [
        {
          kind: "list",
          items: [
            "Illegal activity",
            "Unauthorized access or penetration attempts",
            "Malware or harmful code",
            "Circumventing role, subscription, facility, asset, or seat restrictions",
            "Falsifying inspection, safety, permit, maintenance, training, or audit records",
            "Using AI output to intentionally misrepresent equipment condition or compliance",
            "Scraping or bulk extraction without authorization",
            "Reverse engineering where prohibited",
            "Interfering with service availability",
            "Infringing privacy, confidentiality, intellectual-property, or contractual rights",
          ],
        },
      ],
    },
    {
      id: "availability",
      title: "10. Service Availability and Changes",
      blocks: [
        {
          kind: "list",
          items: [
            "Features may be added, modified, suspended, or removed.",
            "Maintenance may affect availability.",
            "Third-party services may experience interruptions.",
            "Enterprise uptime or response-time commitments apply only where expressly stated in an applicable signed SLA or order form.",
          ],
        },
      ],
    },
    {
      id: "suspension",
      title: "11. Suspension and Termination",
      blocks: [
        {
          kind: "list",
          items: [
            "Fraud or security concerns",
            "Non-payment",
            "Illegal or unsafe misuse",
            "Material Terms violations",
            "Unauthorized access attempts",
            "Abuse of infrastructure",
            "Customer request or contract termination",
            "Legal or regulatory requirements",
          ],
        },
      ],
    },
    {
      id: "intellectual-property",
      title: "12. Intellectual Property",
      blocks: [
        {
          kind: "list",
          items: [
            "Flacron Energy software, branding, interface, templates, workflows, report formats, AI orchestration, AR/3D components, and platform technology are owned by, licensed to, or otherwise lawfully used by Flacron Enterprises LLC.",
            "Customer data ownership does not transfer ownership of underlying Flacron Energy technology or Flacron Engine assets.",
          ],
        },
      ],
    },
    {
      id: "pricing",
      title: "13. Pricing, Orders and Subscriptions",
      blocks: [
        {
          kind: "p",
          text: "Commercial terms may be presented through pricing pages, proposals, order forms, invoices, or negotiated enterprise agreements. Unless a signed agreement states otherwise, displayed checkout or order-form pricing and scope control the transaction.",
        },
        {
          kind: "table",
          head: ["Tier", "Base Price", "Included Facilities / Assets / Seats", "Notes"],
          rows: [
            [
              "Pilot",
              "$499/mo ($4,990/yr)",
              "1 facility / 100 assets / 5 seats",
              "Entry tier; includes AI analysis, AR inspection, work orders, and reports",
            ],
            [
              "Starter",
              "$999/mo ($9,990/yr)",
              "1 facility / 250 assets / 10 seats",
              "Annual billing is charged as ten months for twelve months of service",
            ],
            [
              "Field",
              "$1,999/mo ($19,990/yr)",
              "2 facilities / 750 assets / 25 seats",
              "Industrial field operations tier",
            ],
            [
              "Operations",
              "$4,999/mo ($49,990/yr)",
              "Up to 5 facilities / 2,500 assets / 75 seats",
              "Adds permit-to-work, 3D across every facility, and priority support",
            ],
            [
              "Enterprise",
              "Custom pricing, starting around $9,999/mo",
              "Unlimited facilities / assets / seats",
              "Quoted by sales; not available for self-service purchase",
            ],
          ],
        },
        {
          kind: "p",
          text: "Pilot, Starter, Field, and Operations are available for self-service purchase. Enterprise is not offered through self-service checkout: its pricing is quoted individually based on number of facilities, assets, users and seats, AI usage, storage requirements, 3D and VR requirements, custom integrations, SSO and enterprise security requirements, support SLA, data migration, and onboarding and implementation scope, and is governed by the applicable order form or agreement rather than by the figures above.",
        },
        {
          kind: "p",
          text: "Additional facilities, additional tracked assets, additional AI analysis volume, VR training, premium support and custom SLA, custom 3D facility modeling, custom integrations, data migration, onboarding, and implementation may be billed separately according to the applicable order form or pricing schedule. Promotional, founding-customer, or negotiated pricing may be applied by discount code or written agreement, in which case the agreed amount governs for the period stated.",
        },
      ],
    },
    {
      id: "billing",
      title: "14. Billing and Automatic Renewal",
      blocks: [
        {
          kind: "p",
          text: "Subscriptions may renew automatically for the billing period stated at checkout or in the applicable order form unless canceled or non-renewed as permitted by the applicable agreement. Taxes and usage-based charges may apply. Enterprise contracts may include minimum commitments, implementation fees, onboarding fees, or custom payment schedules.",
        },
      ],
    },
    {
      id: "cancellation",
      title: "15. Cancellation and Refunds",
      blocks: [
        {
          kind: "p",
          text: "Cancellation and refund rights are governed by the Flacron Energy Refund & Cancellation Policy, the applicable order form, enterprise agreement, and mandatory law. Enterprise implementation, onboarding, migration, custom 3D modeling, integration, and professional-service fees may be non-refundable once work begins except where otherwise agreed in writing or required by law.",
        },
      ],
    },
    {
      id: "warranties",
      title: "16. Disclaimers of Warranties",
      blocks: [
        {
          kind: "p",
          text: "TO THE FULLEST EXTENT PERMITTED BY LAW, FLACRON ENERGY IS PROVIDED “AS IS” AND “AS AVAILABLE.” Flacron Enterprises LLC does not guarantee that AI findings, AR measurements, risk scores, condition assessments, safety suggestions, reports, 3D models, training simulations, or third-party integrations will be error-free, complete, or suitable for every industrial context.",
        },
      ],
    },
    {
      id: "liability",
      title: "17. Limitation of Liability",
      blocks: [
        {
          kind: "p",
          text: "To the fullest extent permitted by applicable law, Flacron Enterprises LLC, Flacron Energy, their affiliates, officers, employees, contractors, licensors, and service providers will not be liable for indirect, incidental, special, consequential, exemplary, or punitive damages arising from use of or inability to use the service. This may include lost production, downtime, lost profits, missed maintenance, equipment damage, environmental loss, regulatory exposure, safety incidents, or reliance on AI/AR outputs. Nothing excludes liability that cannot lawfully be excluded.",
        },
      ],
    },
    {
      id: "indemnification",
      title: "18. Indemnification",
      blocks: [
        {
          kind: "p",
          text: "To the extent permitted by law and subject to any negotiated enterprise agreement, you agree to indemnify and hold harmless Flacron Enterprises LLC from claims, liabilities, damages, and expenses arising from unlawful use, unauthorized content, intentional falsification, violation of these Terms, or infringement of third-party rights.",
        },
      ],
    },
    {
      id: "governing-law",
      title: "19. Governing Law",
      blocks: [
        {
          kind: "p",
          text: "Unless a signed enterprise agreement states otherwise, these Terms are governed by the laws of the State of New York, United States, without regard to conflict-of-law principles, except where mandatory law provides otherwise.",
        },
      ],
    },
    {
      id: "changes",
      title: "20. Changes, Severability and Entire Agreement",
      blocks: [
        {
          kind: "p",
          text: "Updated Terms will display a revised Last Updated date. Material changes may be communicated through email, in-product notice, contract notice, or renewed acceptance where appropriate. If a provision is unenforceable, remaining provisions continue to the extent permitted by law. These Terms, together with referenced policies and any applicable signed agreement or order form, constitute the governing agreement for use of Flacron Energy.",
        },
        { kind: "contact" },
      ],
    },
  ],
};
