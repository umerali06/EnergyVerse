from app.db.repositories.base import TenantRepository
from app.models.base import CompanyScope
from app.models.entities import Area, AreaCreate, AreaUpdate, without_none


class AreaRepository(TenantRepository[Area]):
    collection_name = "areas"
    target_type = "area"
    model_type = Area

    async def create(
        self,
        scope: CompanyScope,
        payload: AreaCreate,
        actor_uid: str,
    ) -> Area:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        area_id: str,
        payload: AreaUpdate,
        actor_uid: str,
    ) -> Area:
        return await self._update(
            scope,
            area_id,
            without_none(payload.model_dump()),
            actor_uid,
        )

    async def soft_delete(self, scope: CompanyScope, area_id: str, actor_uid: str) -> Area:
        return await self._soft_delete(scope, area_id, actor_uid)
