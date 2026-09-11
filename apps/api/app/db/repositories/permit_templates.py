from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import PermitTemplate, PermitTemplateCreate


class PermitTemplateVersionConflictError(Exception):
    def __init__(self, current: PermitTemplate) -> None:
        self.current = current


class PermitTemplateRepository(TenantRepository[PermitTemplate]):
    collection_name = "permit_templates"
    target_type = "permit_template"
    model_type = PermitTemplate

    async def create(
        self, scope: CompanyScope, payload: PermitTemplateCreate, actor_uid: str
    ) -> PermitTemplate:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        template_id: str,
        changes: dict[str, object],
        actor_uid: str,
        expected_version: int,
    ) -> PermitTemplate:
        current = await self.get(scope, template_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("permit template not found in company scope")
        if current.version != expected_version:
            raise PermitTemplateVersionConflictError(current)
        protected = {"id", "company_id", "created_at", "created_by", "updated_at", "version"}
        data = {
            **current.model_dump(),
            **{key: value for key, value in changes.items() if key not in protected},
            "version": current.version + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(template_id).set(
            model.model_dump(), timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="permit_template.updated",
            target_id=template_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def soft_delete(
        self, scope: CompanyScope, template_id: str, actor_uid: str
    ) -> PermitTemplate:
        return await self._soft_delete(scope, template_id, actor_uid)
