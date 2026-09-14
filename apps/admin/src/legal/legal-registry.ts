import type { LegalDocument, LegalSlug } from "./legal-content";
import { cookiePolicy } from "./documents/cookies";
import { industrialDisclaimer } from "./documents/disclaimer";
import { privacyPolicy } from "./documents/privacy";
import { refundPolicy } from "./documents/refund";
import { termsOfService } from "./documents/terms";

/** Every published legal document, keyed by the route that serves it. */
export const LEGAL_DOCUMENTS: Record<LegalSlug, LegalDocument> = {
  privacy: privacyPolicy,
  terms: termsOfService,
  "industrial-disclaimer": industrialDisclaimer,
  "refund-policy": refundPolicy,
  "cookie-policy": cookiePolicy,
};

export const LEGAL_DOCUMENT_LIST = Object.values(LEGAL_DOCUMENTS);
