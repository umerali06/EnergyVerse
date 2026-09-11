from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    TrainingModule,
    TrainingModuleCreate,
    TrainingProgress,
    TrainingProgressCreate,
)

TRAINING_QUERY_CAP = 500


class TrainingModuleRepository(TenantRepository[TrainingModule]):
    collection_name = "training_modules"
    target_type = "training_module"
    model_type = TrainingModule

    async def create(
        self, scope: CompanyScope, payload: TrainingModuleCreate, actor_uid: str
    ) -> TrainingModule:
        now = utc_now()
        data = {
            **payload.model_dump(),
            "created_by": actor_uid,
            "deleted_at": None,
            "created_at": now,
            "updated_at": now,
        }
        return await self._create(scope, payload.id, data, actor_uid)

    async def query(
        self, scope: CompanyScope, *, facility_id: str | None = None, kind: str | None = None
    ) -> list[TrainingModule]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if facility_id:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        modules: list[TrainingModule] = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is None or data.get("company_id") != scope.company_id:
                continue
            module = self.model_type.model_validate(data)
            if module.deleted_at is not None:
                continue
            # Filtered in memory: a second equality filter beside company_id
            # would need its own composite index for a small, capped set.
            if kind and module.kind != kind:
                continue
            modules.append(module)
            if len(modules) >= TRAINING_QUERY_CAP:
                break
        modules.sort(key=lambda module: module.title)
        return modules


class TrainingProgressRepository(TenantRepository[TrainingProgress]):
    collection_name = "training_progress"
    target_type = "training_progress"
    model_type = TrainingProgress

    async def create(
        self, scope: CompanyScope, payload: TrainingProgressCreate, actor_uid: str
    ) -> TrainingProgress:
        now = utc_now()
        data = {
            **payload.model_dump(),
            "completed_step_ids": [],
            "correct_count": 0,
            "scored_count": 0,
            "score": None,
            "completed_at": None,
            "created_by": actor_uid,
            "created_at": now,
            "updated_at": now,
        }
        return await self._create(scope, payload.id, data, actor_uid)

    async def list_for_user(
        self, scope: CompanyScope, user_id: str, *, module_id: str | None = None
    ) -> list[TrainingProgress]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        query = query.where(filter=FieldFilter("user_id", "==", user_id))
        rows: list[TrainingProgress] = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is None or data.get("company_id") != scope.company_id:
                continue
            progress = self.model_type.model_validate(data)
            if module_id and progress.module_id != module_id:
                continue
            rows.append(progress)
            if len(rows) >= TRAINING_QUERY_CAP:
                break
        rows.sort(key=lambda row: row.started_at, reverse=True)
        return rows

    async def update_progress(
        self,
        scope: CompanyScope,
        progress_id: str,
        values: dict[str, object],
        actor_uid: str,
    ) -> TrainingProgress | None:
        current = await self.get(scope, progress_id)
        if current is None or current.user_id != actor_uid:
            return None
        await self._collection.document(progress_id).update(
            {**values, "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        return await self.get(scope, progress_id)
