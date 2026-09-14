import type { LegalDocument } from "../legal-content";

export const cookiePolicy: LegalDocument = {
  slug: "cookie-policy",
  title: "Cookie Policy",
  lede: "The cookies and similar technologies Flacron Energy may use in its public website, enterprise dashboard, and web-based functionality.",
  intro: [
    {
      kind: "p",
      text: "This Cookie Policy explains how Flacron Energy, operated by Flacron Enterprises LLC, may use cookies and similar technologies in its public website, enterprise dashboard, and web-based functionality.",
    },
  ],
  sections: [
    {
      id: "technologies",
      title: "1. Technologies We May Use",
      blocks: [
        {
          kind: "list",
          items: [
            "Cookies",
            "Local storage",
            "Session storage",
            "SDKs",
            "Device identifiers",
            "Security identifiers",
            "Analytics technologies",
            "Consent-management technologies",
          ],
        },
      ],
    },
    {
      id: "purposes",
      title: "2. Purposes",
      blocks: [
        {
          kind: "list",
          items: [
            "Authentication and session management",
            "Security and fraud prevention",
            "Remembering organization, language, theme, and interface preferences",
            "Subscription and billing sessions",
            "Performance and error monitoring",
            "Analytics and feature engagement",
            "Marketing attribution where permitted",
            "Consent preference storage",
          ],
        },
      ],
    },
    {
      id: "strictly-necessary",
      title: "3. Strictly Necessary Technologies",
      blocks: [
        {
          kind: "p",
          text: "Strictly necessary technologies may remain active where legally permitted because they support authentication, authorization, security, session management, billing, fraud prevention, load balancing, and consent preferences.",
        },
      ],
    },
    {
      id: "analytics-marketing",
      title: "4. Analytics and Marketing",
      blocks: [
        {
          kind: "p",
          text: "Where consent is required, optional analytics or marketing technologies should not activate until appropriate consent is received.",
        },
      ],
    },
    {
      id: "consent-banner",
      title: "5. Cookie Consent Banner",
      blocks: [
        { kind: "list", items: ["Accept All", "Reject Non-Essential", "Manage Preferences"] },
        { kind: "p", text: "Do not hide or materially obscure the rejection option." },
      ],
    },
    {
      id: "preference-center",
      title: "6. Preference Center",
      blocks: [
        {
          kind: "list",
          items: [
            "Strictly Necessary — Always Active",
            "Preferences — On / Off",
            "Analytics — On / Off",
            "Marketing — On / Off",
            "Save Preferences",
            "Accept All",
            "Reject Non-Essential",
          ],
        },
      ],
    },
    {
      id: "changing-choices",
      title: "7. Changing Choices",
      blocks: [
        {
          kind: "p",
          text: "A permanent “Cookie Preferences” control in the footer reopens the consent manager at any time.",
        },
      ],
    },
    {
      id: "production-accuracy",
      title: "8. Production Accuracy",
      blocks: [
        {
          kind: "p",
          text: "The production Cookie Policy should be kept aligned with the technologies actually deployed, including authentication, analytics, advertising, mapping, monitoring, and support tools.",
        },
        { kind: "contact" },
      ],
    },
  ],
};
