import type { LegalDocument } from "../legal-content";

export const refundPolicy: LegalDocument = {
  slug: "refund-policy",
  title: "Refund & Cancellation Policy",
  lede: "How subscription charges, cancellation, non-renewal, and refund requests are handled for Flacron Energy.",
  intro: [
    {
      kind: "p",
      text: "This policy applies to Flacron Energy subscriptions and services provided by Flacron Enterprises LLC unless a signed enterprise agreement, order form, statement of work, or applicable law states otherwise.",
    },
  ],
  sections: [
    {
      id: "charges",
      title: "1. Subscription and Service Charges",
      blocks: [
        {
          kind: "p",
          text: "Flacron Energy uses enterprise pricing that may include base subscription fees, per-seat charges, asset-volume charges, facility/site add-ons, AI usage, VR modules, custom 3D modeling, implementation, onboarding, data migration, integrations, premium support, and other professional services.",
        },
      ],
    },
    {
      id: "billing-frequency",
      title: "2. Billing Frequency",
      blocks: [
        {
          kind: "p",
          text: "Standard published tier pricing is billed annually. Monthly billing may be available at an approximately 15% premium where offered. Custom enterprise billing schedules may apply under negotiated agreements.",
        },
      ],
    },
    {
      id: "cancellation",
      title: "3. Cancellation / Non-Renewal",
      blocks: [
        {
          kind: "p",
          text: "Customers should follow the cancellation or non-renewal process stated in their order form, enterprise agreement, account billing portal, or written contract. Cancellation generally prevents future renewal and does not automatically refund the current paid term unless required by law or expressly agreed.",
        },
      ],
    },
    {
      id: "general-refund",
      title: "4. General Refund Policy",
      blocks: [
        {
          kind: "p",
          text: "Except where required by applicable law or agreed in writing, subscription payments and committed enterprise fees are generally non-refundable after the applicable billing or committed service period begins.",
        },
        {
          kind: "list",
          items: [
            "Unused time within a committed term",
            "Unused seats, assets, facilities, or AI quotas",
            "Failure to use purchased functionality",
            "Operational outcomes that differ from expectations",
            "AI findings or risk scores that require correction",
            "Customer-side configuration, connectivity, device, or workflow issues not caused by Flacron Energy",
            "Change of mind after services have begun",
          ],
        },
      ],
    },
    {
      id: "professional-services",
      title: "5. Implementation and Professional Services",
      blocks: [
        {
          kind: "p",
          text: "Onboarding, migration, custom integration, custom 3D modeling, consulting, training, and other professional-service fees may be non-refundable once work begins, except where a signed statement of work provides otherwise or law requires a refund.",
        },
      ],
    },
    {
      id: "incorrect-charges",
      title: "6. Duplicate or Incorrect Charges",
      blocks: [
        {
          kind: "p",
          text: "Contact Contact@flacronenterprises.com if you believe you were charged twice, charged an incorrect amount, charged after proper cancellation, or affected by a confirmed billing-system error. Do not send complete payment-card information by email.",
        },
      ],
    },
    {
      id: "service-failure",
      title: "7. Service Failure Review",
      blocks: [
        {
          kind: "p",
          text: "Flacron Enterprises LLC may review refund or service-credit requests involving confirmed billing errors or significant service failures. Enterprise service credits, if any, are governed by the applicable SLA or signed agreement.",
        },
      ],
    },
    {
      id: "chargebacks",
      title: "8. Chargebacks",
      blocks: [
        {
          kind: "p",
          text: "Customers are encouraged to contact support before initiating a payment dispute so the billing issue can be investigated. Fraudulent or abusive chargebacks may result in account restrictions where legally permitted.",
        },
        { kind: "contact" },
      ],
    },
  ],
};
