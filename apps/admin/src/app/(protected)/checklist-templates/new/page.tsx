import { RequirePermission } from "@/auth/route-guards";
import { ChecklistTemplateFormPage } from "@/checklist-templates/checklist-template-form-page";

export default function NewChecklistTemplateRoute() {
  return (
    <RequirePermission permission="checklist_templates.write">
      <ChecklistTemplateFormPage />
    </RequirePermission>
  );
}
