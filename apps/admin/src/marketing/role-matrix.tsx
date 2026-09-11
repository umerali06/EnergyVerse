/**
 * The seven built-in roles and what each one can actually do.
 *
 * The permission counts are the real sizes of the system role templates in
 * `apps/api/app/rbac/constants.py`, and the separation-of-duties notes describe
 * gates the API enforces — not aspirational copy. Publishing the matrix is the
 * point: a buyer evaluating an operations platform wants to see the access
 * model before a demo, and no competitor's landing page shows it.
 *
 * Keep in sync with `SYSTEM_ROLE_TEMPLATES` if a template changes.
 */

export type RoleRow = {
  key: string;
  name: string;
  permissions: number;
  scope: string;
  note: string;
  emphasis?: boolean;
};

export const roleRows: readonly RoleRow[] = [
  {
    key: "field_inspector",
    name: "Field Inspector",
    permissions: 14,
    scope: "Runs inspections, raises safety reports, generates reports",
    note: "The mobile persona. Cannot approve a permit or close a work order.",
    emphasis: true,
  },
  {
    key: "maintenance_technician",
    name: "Maintenance Technician",
    permissions: 11,
    scope: "Accepts, progresses, and submits assigned work",
    note: "Deliberately cannot sign off its own work — closure is a separate gate.",
    emphasis: true,
  },
  {
    key: "hse_manager",
    name: "HSE Manager",
    permissions: 17,
    scope: "Approves permits, closes safety findings, reads the audit log",
    note: "The only operational role that can authorise hot work and isolation.",
  },
  {
    key: "operations_manager",
    name: "Operations Manager",
    permissions: 20,
    scope: "Owns the asset hierarchy, templates, and work-order lifecycle",
    note: "Plans and closes work; does not administer users or roles.",
  },
  {
    key: "executive",
    name: "Executive",
    permissions: 11,
    scope: "Read-only across every module, plus the audit log",
    note: "Cannot change a single record — useful for boards and auditors.",
  },
  {
    key: "company_admin",
    name: "Company Admin",
    permissions: 27,
    scope: "Everything in the tenant: users, roles, settings, all modules",
    note: "Owns its own company and nothing outside it.",
  },
  {
    key: "super_admin",
    name: "Super Admin",
    permissions: 28,
    scope: "Company admin plus platform administration",
    note: "The one role holding platform.admin.",
  },
];

export function RoleMatrix() {
  return (
    <div className="overflow-hidden rounded-xl border border-border bg-surface">
      <div className="overflow-x-auto">
        <table className="w-full min-w-[640px] border-collapse text-left">
          <caption className="sr-only">
            The seven built-in roles, their permission counts, and what each can do
          </caption>
          <thead>
            <tr className="border-b border-border">
              <th
                className="px-5 py-3 font-mono text-micro uppercase tracking-[0.16em] text-text-muted"
                scope="col"
              >
                Role
              </th>
              <th
                className="px-5 py-3 font-mono text-micro uppercase tracking-[0.16em] text-text-muted"
                scope="col"
              >
                Keys
              </th>
              <th
                className="px-5 py-3 font-mono text-micro uppercase tracking-[0.16em] text-text-muted"
                scope="col"
              >
                Can do
              </th>
            </tr>
          </thead>
          <tbody>
            {roleRows.map((role) => (
              <tr
                className="border-b border-border last:border-b-0 transition-colors hover:bg-elevated"
                key={role.key}
              >
                <th className="px-5 py-4 align-top" scope="row">
                  <span className="block text-bodySmall font-semibold text-text-primary">
                    {role.name}
                  </span>
                  <span className="mt-1 block font-mono text-micro text-text-muted">
                    {role.key}
                  </span>
                </th>
                <td className="whitespace-nowrap px-5 py-4 align-top">
                  <span
                    className={`inline-flex items-baseline gap-1 rounded-full px-2.5 py-0.5 font-mono text-micro font-semibold ${
                      role.emphasis
                        ? "mk-accent-soft text-accent-600 dark:text-accent-400"
                        : "border border-border text-text-secondary"
                    }`}
                  >
                    {role.permissions}
                  </span>
                </td>
                <td className="px-5 py-4 align-top">
                  <span className="block text-bodySmall text-text-secondary">{role.scope}</span>
                  <span className="mt-1 block text-caption text-text-muted">{role.note}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <p className="border-t border-border px-5 py-3.5 text-caption text-text-muted">
        Counts are the real permission-key totals of each built-in template. Roles are editable, and
        every gate is enforced by the API — not by hiding a button.
      </p>
    </div>
  );
}
