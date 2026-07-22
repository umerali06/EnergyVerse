"use client";

import type { PermissionCatalogGroup } from "@fev/api-client";

import { Checkbox } from "@/design-system";

const GROUP_LABELS: Record<string, string> = {
  assets: "Assets",
  inspections: "Inspections",
  permits: "Permits",
  work_orders: "Work Orders",
  reports: "Reports",
  safety: "Safety",
  users: "Users",
  roles: "Roles",
  company: "Company",
  platform: "Platform",
};

export function PermissionMatrix({
  disabledKeys = [],
  groups,
  onToggle,
  readOnly = false,
  selected,
}: {
  disabledKeys?: readonly string[];
  groups: readonly PermissionCatalogGroup[];
  onToggle?: (key: string, checked: boolean) => void;
  readOnly?: boolean;
  selected: ReadonlySet<string>;
}) {
  const disabled = new Set(disabledKeys);

  return (
    <div className="grid gap-4" data-testid="permission-matrix">
      <p className="text-bodySmall font-semibold text-text-primary" data-testid="permission-count">
        {selected.size} permission{selected.size === 1 ? "" : "s"} selected
      </p>
      {groups.map((group) => {
        const keys = group.items.map((item) => item.key);
        const selectableKeys = keys.filter((key) => !disabled.has(key));
        const allSelected =
          selectableKeys.length > 0 && selectableKeys.every((key) => selected.has(key));
        const someSelected = selectableKeys.some((key) => selected.has(key));
        return (
          <div className="rounded-lg border border-border p-3" key={group.group}>
            <div className="flex items-center justify-between gap-2 border-b border-border pb-2">
              <h3 className="text-bodySmall font-bold uppercase tracking-[0.08em] text-text-secondary">
                {GROUP_LABELS[group.group] ?? group.group}
              </h3>
              {!readOnly && selectableKeys.length > 1 && (
                <Checkbox
                  checked={allSelected}
                  indeterminate={someSelected && !allSelected}
                  label="Select all"
                  onChange={(checked) => {
                    for (const key of selectableKeys) onToggle?.(key, checked);
                  }}
                />
              )}
            </div>
            <div className="mt-2 grid gap-2 sm:grid-cols-2">
              {group.items.map((item) => (
                <Checkbox
                  checked={selected.has(item.key)}
                  disabled={readOnly || disabled.has(item.key)}
                  hint={item.description}
                  key={item.key}
                  label={item.key}
                  onChange={(checked) => onToggle?.(item.key, checked)}
                />
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
}
