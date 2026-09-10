from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import Permit, PermitCreate


class PermitRevisionConflictError(Exception):
    def __init__(self, current: Permit) -> None:
        self.current = current


class PermitRepository(TenantRepository[Permit]):
    collection_name = "permits"
    target_type = "permit"
    model_type = Permit

    async def create(self, scope: CompanyScope, payload: PermitCreate, actor_uid: str) -> Permit:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        permit_id: str,
        changes: dict[str, object],
        actor_uid: str,
        expected_revision: int,
    ) -> Permit:
        current = await self.get(scope, permit_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("permit not found in company scope")
        if current.revision != expected_revision:
            raise PermitRevisionConflictError(current)
        protected = {
            "id",
            "company_id",
            "created_at",
            "created_by",
            "updated_at",
            "revision",
            "permit_number",
            "permit_type",
            "facility_id",
            "area_id",
            "asset_id",
            "template_id",
            "template_name",
            "template_version",
            "checklist_snapshot",
            "approval_snapshot",
            "status",
        }
        data = {
            **current.model_dump(),
            **{key: value for key, value in changes.items() if key not in protected},
            "revision": current.revision + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(permit_id).set(
            model.model_dump(), timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="permit.updated",
            target_id=permit_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def soft_delete(self, scope: CompanyScope, permit_id: str, actor_uid: str) -> Permit:
        return await self._soft_delete(scope, permit_id, actor_uid)

    async def transition(
        self,
        scope: CompanyScope,
        permit_id: str,
        *,
        expected_revision: int,
        expected_status: str,
        next_status: str,
        changes: dict[str, object],
        actor_uid: str,
        action: str,
    ) -> Permit:
        current = await self.get(scope, permit_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("permit not found in company scope")
        if current.revision != expected_revision:
            raise PermitRevisionConflictError(current)
        if current.status != expected_status:
            raise ValueError(current.status)
        data = {
            **current.model_dump(),
            **changes,
            "status": next_status,
            "revision": current.revision + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(permit_id).set(
            model.model_dump(), timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"permit.{action}",
            target_id=permit_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model
