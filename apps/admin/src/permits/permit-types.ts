import type { CreatePermitTemplateRequest } from "@fev/api-client";

export type PermitType = CreatePermitTemplateRequest["permitType"];

export const PERMIT_TYPES: { value: PermitType; label: string }[] = [
  { value: "hot_work", label: "Hot work" },
  { value: "confined_space", label: "Confined space" },
  { value: "electrical_isolation_loto", label: "Electrical isolation / LOTO" },
  { value: "excavation", label: "Excavation" },
  { value: "working_at_height", label: "Working at height" },
  { value: "general_maintenance", label: "General maintenance" },
];

export function permitTypeLabel(value: string) {
  return PERMIT_TYPES.find((item) => item.value === value)?.label ?? value.replaceAll("_", " ");
}
