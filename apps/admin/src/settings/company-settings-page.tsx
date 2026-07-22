"use client";

import { useEffect, useMemo, useState } from "react";

import { ApiClientError } from "@/api";
import { formatCompanyDate } from "@/dashboard/format";
import {
  Button,
  Card,
  EmptyState,
  Input,
  MotionSection,
  Select,
  Skeleton,
  StatusPill,
  useToast,
} from "@/design-system";

import { useCompanySettingsData } from "./company-settings-data";
import { LogoUpload } from "./logo-upload";

// Mirrors app/company/constants.py::INDUSTRY_CHOICES -- keep both lists in sync.
const INDUSTRY_CHOICES = [
  "Oil & Gas",
  "Electric Utility",
  "Renewable Energy",
  "Water Utility",
  "Mining",
  "Midstream / Pipeline",
  "Industrial Manufacturing",
  "Other",
] as const;

// A small curated subset for the picker's UX; the backend accepts any
// well-formed BCP-47 tag, so this list isn't an artificial restriction.
const LOCALE_CHOICES = [
  { value: "en-US", label: "English (United States)" },
  { value: "en-GB", label: "English (United Kingdom)" },
  { value: "fr-FR", label: "French (France)" },
  { value: "de-DE", label: "German (Germany)" },
  { value: "es-ES", label: "Spanish (Spain)" },
  { value: "pt-BR", label: "Portuguese (Brazil)" },
  { value: "ar-SA", label: "Arabic (Saudi Arabia)" },
  { value: "zh-CN", label: "Chinese (Simplified)" },
  { value: "ja-JP", label: "Japanese (Japan)" },
  { value: "hi-IN", label: "Hindi (India)" },
] as const;

function supportedTimeZones(): string[] {
  // "UTC" is the backend's own default but isn't always a member of the
  // browser's IANA zone list (Chrome omits it in favor of "Etc/UTC") --
  // without this, a fresh tenant's <select> silently mismatches its bound
  // value and displays whatever zone happens to sort first instead.
  let zones: string[];
  try {
    zones = Intl.supportedValuesOf("timeZone");
  } catch {
    zones = [];
  }
  return zones.includes("UTC") ? zones : ["UTC", ...zones];
}

export function CompanySettingsPage({
  reducedMotionOverride,
}: {
  reducedMotionOverride?: boolean;
} = {}) {
  const toast = useToast();
  const data = useCompanySettingsData();
  const { profile } = data.company;
  const timeZones = useMemo(supportedTimeZones, []);

  const [name, setName] = useState("");
  const [industry, setIndustry] = useState("");
  const [timezone, setTimezone] = useState("UTC");
  const [locale, setLocale] = useState("en-US");
  const [contactEmail, setContactEmail] = useState("");
  const [contactPhone, setContactPhone] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!profile) return;
    setName(profile.name);
    setIndustry(profile.industry ?? "");
    setTimezone(profile.timezone);
    setLocale(profile.locale);
    setContactEmail(profile.contactEmail ?? "");
    setContactPhone(profile.contactPhone ?? "");
    setError(null);
  }, [profile]);

  const hasChanges =
    profile !== null &&
    (name.trim() !== profile.name ||
      industry !== (profile.industry ?? "") ||
      timezone !== profile.timezone ||
      locale !== profile.locale ||
      contactEmail !== (profile.contactEmail ?? "") ||
      contactPhone !== (profile.contactPhone ?? ""));

  function discard() {
    if (!profile) return;
    setName(profile.name);
    setIndustry(profile.industry ?? "");
    setTimezone(profile.timezone);
    setLocale(profile.locale);
    setContactEmail(profile.contactEmail ?? "");
    setContactPhone(profile.contactPhone ?? "");
    setError(null);
  }

  async function handleSave() {
    if (!profile || name.trim().length < 2) {
      setError("Enter a company name");
      return;
    }
    setSaving(true);
    setError(null);
    try {
      await data.updateCompany({
        name: name.trim(),
        // An empty string means the field was deliberately cleared (e.g.
        // "Not set" for industry) -- send null so the server actually
        // clears it rather than leaving the previous value untouched.
        industry: industry || null,
        timezone,
        locale,
        contactEmail: contactEmail || null,
        contactPhone: contactPhone || null,
      });
      toast.success("Company settings saved");
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSaving(false);
    }
  }

  const dateFormat = { locale: profile?.locale, timeZone: profile?.timezone };

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-3xl" reducedMotionOverride={reducedMotionOverride}>
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
            Administration
          </p>
          <h1 className="mt-2 text-h2 font-bold">Company Settings</h1>
          <p className="mt-1 text-bodySmall text-text-secondary">
            Manage your organization&apos;s profile and tenant-wide settings.
          </p>
        </div>

        {data.company.status === "loading" && (
          <Card className="mt-6 grid gap-3">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </Card>
        )}

        {data.company.status === "error" && (
          <Card className="mt-6">
            <EmptyState
              action={
                <Button onClick={data.retry} variant="ghost">
                  Retry
                </Button>
              }
              description="Couldn't load company settings. Check your connection and try again."
              title="Something went wrong"
            />
          </Card>
        )}

        {data.company.status === "ready" && profile && (
          <div className="mt-6 grid gap-6">
            <Card>
              <h2 className="text-h5 font-bold">Profile</h2>
              <div className="mt-4 grid gap-4">
                <Input label="Company name" onChange={(event) => setName(event.target.value)} value={name} />
                <Select
                  label="Industry"
                  onChange={(event) => setIndustry(event.target.value)}
                  value={industry}
                >
                  <option value="">Not set</option>
                  {INDUSTRY_CHOICES.map((choice) => (
                    <option key={choice} value={choice}>
                      {choice}
                    </option>
                  ))}
                </Select>
                <Input
                  label="Contact email"
                  onChange={(event) => setContactEmail(event.target.value)}
                  type="email"
                  value={contactEmail}
                />
                <Input
                  label="Contact phone"
                  onChange={(event) => setContactPhone(event.target.value)}
                  type="tel"
                  value={contactPhone}
                />
                <Select
                  hint="Used to format dates shown throughout the dashboard and reports."
                  label="Timezone"
                  onChange={(event) => setTimezone(event.target.value)}
                  value={timezone}
                >
                  {timeZones.map((zone) => (
                    <option key={zone} value={zone}>
                      {zone}
                    </option>
                  ))}
                </Select>
                <Select label="Locale" onChange={(event) => setLocale(event.target.value)} value={locale}>
                  {LOCALE_CHOICES.map((choice) => (
                    <option key={choice.value} value={choice.value}>
                      {choice.label}
                    </option>
                  ))}
                </Select>
                {error && (
                  <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
                    {error}
                  </p>
                )}
                <div className="flex justify-end gap-2">
                  <Button disabled={!hasChanges || saving} onClick={discard} variant="ghost">
                    Discard
                  </Button>
                  <Button disabled={!hasChanges} loading={saving} onClick={() => void handleSave()}>
                    Save
                  </Button>
                </div>
              </div>
            </Card>

            <Card>
              <h2 className="text-h5 font-bold">Branding</h2>
              <p className="mt-1 text-bodySmall text-text-secondary">
                Your company logo, distinct from the FEV product logo.
              </p>
              <div className="mt-4">
                <LogoUpload
                  logoUrl={profile.logoUrl ?? null}
                  onRemove={data.removeLogo}
                  onUpload={data.uploadLogo}
                />
              </div>
            </Card>

            <Card>
              <h2 className="text-h5 font-bold">Overview</h2>
              <div className="mt-4 grid gap-3">
                <div className="flex items-center gap-2">
                  <StatusPill tone="info">{profile.subscriptionTier}</StatusPill>
                  <span className="text-caption text-text-muted">
                    Tier management is available in a later phase.
                  </span>
                </div>
                <p className="text-bodySmall text-text-secondary">
                  Company since {formatCompanyDate(profile.createdAt, dateFormat)}
                </p>
                <div className="flex gap-6">
                  <div>
                    <p className="font-mono text-h5 font-bold">{profile.usersTotal}</p>
                    <p className="text-caption text-text-muted">Users</p>
                  </div>
                  <div>
                    <p className="font-mono text-h5 font-bold">{profile.rolesTotal}</p>
                    <p className="text-caption text-text-muted">Roles</p>
                  </div>
                </div>
              </div>
            </Card>
          </div>
        )}
      </MotionSection>
    </section>
  );
}
