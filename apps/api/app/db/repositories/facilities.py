from app.db.repositories.base import TenantRepository
from app.models.base import CompanyScope
from app.models.entities import Facility, FacilityCreate, FacilityUpdate, without_none


class FacilityRepository(TenantRepository[Facility]):
    collection_name = "facilities"
    target_type = "facility"
    model_type = Facility

    async def create(
        self,
        scope: CompanyScope,
        payload: FacilityCreate,
        actor_uid: str,
    ) -> Facility:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        facility_id: str,
        payload: FacilityUpdate,
        actor_uid: str,
    ) -> Facility:
        return await self._update(
            scope,
            facility_id,
            without_none(payload.model_dump()),
            actor_uid,
        )

    async def soft_delete(self, scope: CompanyScope, facility_id: str, actor_uid: str) -> Facility:
        return await self._soft_delete(scope, facility_id, actor_uid)
