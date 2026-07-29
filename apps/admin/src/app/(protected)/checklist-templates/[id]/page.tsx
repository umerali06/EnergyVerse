import { RequirePermission } from "@/auth/route-guards";
import { ChecklistTemplateFormPage } from "@/checklist-templates/checklist-template-form-page";

export default async function EditChecklistTemplateRoute({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  return (
    <RequirePermission permission="checklist_templates.write">
      <ChecklistTemplateFormPage templateId={id} />
    </RequirePermission>
  );
}
