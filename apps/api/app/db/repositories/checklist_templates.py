from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import ChecklistTemplate, ChecklistTemplateCreate


class ChecklistTemplateRepository(TenantRepository[ChecklistTemplate]):
    collection_name = "checklist_templates"
    target_type = "checklist_template"
    model_type = ChecklistTemplate

    async def create(
        self,
        scope: CompanyScope,
        payload: ChecklistTemplateCreate,
        actor_uid: str,
    ) -> ChecklistTemplate:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        template_id: str,
        changes: dict[str, object],
        actor_uid: str,
    ) -> ChecklistTemplate:
        """Unlike `_update`, this always bumps `version` -- templates are
        server-authored (no client-id upsert/idempotency concern), so every
        accepted edit is a new version for inspection-snapshot provenance."""
        current = await self.get(scope, template_id)
        if current is None:
            raise LookupError(f"{self.target_type} not found in company scope")

        protected = {"id", "company_id", "created_at", "created_by", "updated_at", "version"}
        applied = {key: value for key, value in changes.items() if key not in protected}
        data = {
            **current.model_dump(),
            **applied,
            "version": current.version + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(template_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="checklist_template.updated",
            target_id=template_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def soft_delete(
        self, scope: CompanyScope, template_id: str, actor_uid: str
    ) -> ChecklistTemplate:
        return await self._soft_delete(scope, template_id, actor_uid)
