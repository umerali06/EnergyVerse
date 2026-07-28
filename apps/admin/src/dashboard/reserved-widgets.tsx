import { Card } from "@/design-system";

import { registerWidget } from "./widget-registry";

/**
 * Honest empty-state widgets for modules that don't exist yet (Work Orders,
 * Permits, Safety & Incidents). This is the Phase 2.2 "reserved KPI region"
 * contract, now expressed as ordinary registrations instead of a hardcoded
 * dashboard-page array -- when a future phase builds one of these modules,
 * it deletes that module's entry here and registers its own real widget the
 * same way `asset-widgets.tsx` does (see ARCHITECTURE.md Phase 4.4).
 */
const RESERVED_MODULES = [
  {
    id: "reserved.work-orders",
    label: "Work Orders",
    permission: "work_orders.read",
    copy: "Work order metrics appear once the Work Orders module is enabled.",
  },
  {
    id: "reserved.permits",
    label: "Permits",
    permission: "permits.read",
    copy: "Permit metrics appear once the Permits module is enabled.",
  },
  {
    id: "reserved.safety",
    label: "Safety & Incidents",
    permission: "safety.read",
    copy: "Safety and incident metrics appear once the Safety module is enabled.",
  },
] as const;

for (const module of RESERVED_MODULES) {
  registerWidget({
    id: module.id,
    title: module.label,
    requiredPermission: module.permission,
    size: "sm",
    render: () => (
      <Card className="p-4" key={module.id}>
        <p className="text-bodySmall font-semibold">{module.label}</p>
        <p className="mt-1 text-caption text-text-muted">{module.copy}</p>
      </Card>
    ),
  });
}
