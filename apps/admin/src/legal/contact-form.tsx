"use client";

import { type FormEvent, useState } from "react";

import { FevApiClient } from "@/api";
import { Button, Input, Select, Textarea } from "@/design-system";

import { OPERATOR } from "./legal-content";

/**
 * The public contact form.
 *
 * Built on its own `FevApiClient` rather than the one in `AuthContext`: the
 * page must work for a visitor with no account at all, which is most of the
 * people the package expects to use it — prospective customers, security
 * researchers, and anyone exercising a privacy right.
 *
 * The placeholder warning about credentials and card numbers is required
 * wording, not decoration: this text is the only thing standing between a
 * support inbox and a pasted password.
 */

export const CONTACT_CATEGORIES = [
  "General Question",
  "Account / Login Support",
  "Company Administration",
  "User / Role / Permission Issue",
  "Asset Management",
  "QR Code / Asset Scanning",
  "AR Inspection",
  "AI Analysis",
  "Safety Report",
  "Permit-to-Work",
  "Work Order / Maintenance",
  "Report Generation",
  "3D Facility View",
  "VR Training",
  "Mobile App",
  "Offline Sync",
  "Billing / Subscription",
  "Facility / Asset / Seat Add-On",
  "Implementation / Onboarding",
  "Data Migration",
  "Enterprise / SSO",
  "Integration Request",
  "Privacy Request",
  "Legal Inquiry",
  "Security Concern",
  "Partnership",
  "Other",
] as const;

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

type Errors = Partial<Record<"name" | "email" | "subject" | "message", string>>;

/**
 * Short `?topic=` values a link may carry, mapped to a published category.
 *
 * Kept deliberately small and one-way: a link cannot name an arbitrary
 * category, so a stale or hand-edited URL falls back to the default rather
 * than putting an unoffered value into the select — which the API would then
 * refuse, after the person had typed their message.
 */
const TOPIC_CATEGORIES: Record<string, (typeof CONTACT_CATEGORIES)[number]> = {
  enterprise: "Enterprise / SSO",
  billing: "Billing / Subscription",
  onboarding: "Implementation / Onboarding",
  migration: "Data Migration",
  integration: "Integration Request",
  security: "Security Concern",
  privacy: "Privacy Request",
};

export function ContactForm({
  client,
  topic,
}: {
  client?: Pick<FevApiClient, "submitContactMessage">;
  /** From the query string, so "Request a quote" lands on the right category. */
  topic?: string;
}) {
  const [api] = useState(() => client ?? new FevApiClient());
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [company, setCompany] = useState("");
  const [category, setCategory] = useState<string>(
    (topic ? TOPIC_CATEGORIES[topic.toLowerCase()] : undefined) ?? CONTACT_CATEGORIES[0],
  );
  const [subject, setSubject] = useState("");
  const [message, setMessage] = useState("");
  const [errors, setErrors] = useState<Errors>({});
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);
  const [failure, setFailure] = useState<string | null>(null);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const next: Errors = {};
    if (!name.trim()) next.name = "Your name is required";
    if (!email.trim()) next.email = "Email is required";
    else if (!emailPattern.test(email.trim())) next.email = "Enter a valid email address";
    if (!subject.trim()) next.subject = "A subject is required";
    if (!message.trim()) next.message = "A message is required";
    setErrors(next);
    if (Object.keys(next).length > 0 || sending) return;

    setSending(true);
    setFailure(null);
    try {
      await api.submitContactMessage({
        name: name.trim(),
        email: email.trim(),
        company: company.trim() || null,
        category,
        subject: subject.trim(),
        message: message.trim(),
      });
      setSent(true);
    } catch {
      setFailure(
        `We could not send that message. Please email ${OPERATOR.email} directly and we will pick it up there.`,
      );
    } finally {
      setSending(false);
    }
  }

  if (sent) {
    return (
      <div className="rounded-xl border border-accent-500/40 bg-accent-500/5 p-6" role="status">
        <h2 className="font-heading text-h3 font-bold text-text-primary">Message received</h2>
        <p className="mt-3 text-body leading-relaxed text-text-secondary">
          Thank you for contacting {OPERATOR.product}. Your message has been received and our team
          will review your request. We will respond using the contact information you provided.
        </p>
      </div>
    );
  }

  return (
    <form className="grid gap-5 md:grid-cols-2" noValidate onSubmit={submit}>
      <Input
        disabled={sending}
        error={errors.name}
        label="Your name"
        onChange={(event) => setName(event.target.value)}
        value={name}
      />
      <Input
        autoComplete="email"
        disabled={sending}
        error={errors.email}
        label="Email"
        onChange={(event) => setEmail(event.target.value)}
        type="email"
        value={email}
      />
      <Input
        disabled={sending}
        label="Company or organization"
        onChange={(event) => setCompany(event.target.value)}
        value={company}
      />
      <Select
        disabled={sending}
        label="Category"
        onChange={(event) => setCategory(event.target.value)}
        value={category}
      >
        {CONTACT_CATEGORIES.map((option) => (
          <option key={option} value={option}>
            {option}
          </option>
        ))}
      </Select>
      <div className="md:col-span-2">
        <Input
          disabled={sending}
          error={errors.subject}
          label="Subject"
          onChange={(event) => setSubject(event.target.value)}
          value={subject}
        />
      </div>
      <div className="md:col-span-2">
        <Textarea
          disabled={sending}
          error={errors.message}
          label="Message"
          onChange={(event) => setMessage(event.target.value)}
          placeholder="Please describe your question or issue. Do not include passwords, access tokens, complete payment-card information, or unnecessary confidential operational data."
          rows={7}
          value={message}
        />
        <p className="mt-2 text-caption leading-relaxed text-text-muted">
          Never include passwords, access tokens, complete payment-card information, or
          unnecessary confidential operational data. Security reports should include enough
          technical detail to investigate; please do not access another customer&apos;s data or
          publicly disclose an active vulnerability before allowing reasonable time for
          investigation.
        </p>
      </div>
      {failure ? (
        <p
          className="md:col-span-2 rounded-lg border border-status-critical/40 bg-status-critical/10 p-3 text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical"
          role="alert"
        >
          {failure}
        </p>
      ) : null}
      <div className="md:col-span-2">
        <Button loading={sending} type="submit" variant="accent">
          Send message
        </Button>
      </div>
    </form>
  );
}
