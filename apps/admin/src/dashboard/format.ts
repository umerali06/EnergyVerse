/**
 * Human-readable formatting for real audit_logs data. No fabricated copy —
 * every string here describes an actual field on a real event; unknown
 * action strings fall back to a generic de-slugified label rather than
 * being silently dropped, so future audit actions never render blank.
 */

const KNOWN_ACTIONS: Record<string, string> = {
  "company.created": "created the company",
  "company.updated": "updated the company",
  "company.deleted": "deleted the company",
  "company.self_registered": "registered the company",
  "user.provisioned": "provisioned a user",
  "user.migrated_to_auth_uid": "migrated a user record",
  "access.denied": "was denied access",
};

export function describeAction(action: string): string {
  return KNOWN_ACTIONS[action] ?? action.replace(/[._]/g, " ");
}

export function actionIconKey(action: string): "company" | "user" | "access" | "generic" {
  if (action.startsWith("company.")) return "company";
  if (action.startsWith("user.")) return "user";
  if (action.startsWith("access.")) return "access";
  return "generic";
}

const RELATIVE_UNITS: Array<[number, string]> = [
  [60, "s"],
  [60, "m"],
  [24, "h"],
  [7, "d"],
  [4.345, "w"],
  [12, "mo"],
];

/** Company-wide date/time formatting preferences (3.3 timezone/locale settings). */
export type DateFormatOptions = {
  locale?: string;
  timeZone?: string;
};

/** Compact relative time (e.g. "3m", "5h", "2d") to keep the mono feed dense. */
export function formatRelativeTime(iso: string | Date, now: Date = new Date()): string {
  const then = typeof iso === "string" ? new Date(iso) : iso;
  let deltaSeconds = Math.max(0, (now.getTime() - then.getTime()) / 1000);
  if (deltaSeconds < 5) return "just now";
  for (const [amount, unit] of RELATIVE_UNITS) {
    if (deltaSeconds < amount) return `${Math.floor(deltaSeconds)}${unit} ago`;
    deltaSeconds /= amount;
  }
  return `${Math.floor(deltaSeconds)}y ago`;
}

/** Short day label for chart ticks, e.g. "Jul 19". */
export function formatChartDay(iso: string | Date, options: DateFormatOptions = {}): string {
  const date = typeof iso === "string" ? new Date(iso) : iso;
  return date.toLocaleDateString(options.locale, {
    month: "short",
    day: "numeric",
    timeZone: options.timeZone,
  });
}

/** "route" + "/api/v1/x" -> "route/api/v1/x", not "route//api/v1/x" — some
 * target ids (e.g. access.denied's route path) already carry a leading
 * slash. */
export function formatTarget(targetType: string, targetId: string): string {
  return targetId.startsWith("/") ? `${targetType}${targetId}` : `${targetType}/${targetId}`;
}

/** Exact "Jul 22, 2026, 4:32 PM" for hover/title text, in the tenant's timezone. */
export function formatCompanyDateTime(
  iso: string | Date,
  options: DateFormatOptions = {},
): string {
  const date = typeof iso === "string" ? new Date(iso) : iso;
  return date.toLocaleString(options.locale, {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
    timeZone: options.timeZone,
  });
}

export function formatCompanyDate(iso: string | Date, options: DateFormatOptions = {}): string {
  const date = typeof iso === "string" ? new Date(iso) : iso;
  return date.toLocaleDateString(options.locale, {
    year: "numeric",
    month: "long",
    day: "numeric",
    timeZone: options.timeZone,
  });
}
