from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.repositories.base import TenantRepository
from app.models.base import CompanyScope
from app.models.entities import Role, RoleCreate, RoleUpdate, without_none


class RoleRepository(TenantRepository[Role]):
    collection_name = "roles"
    target_type = "role"
    model_type = Role

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        super().__init__(client, audit)

    async def create(
        self,
        scope: CompanyScope,
        payload: RoleCreate,
        actor_uid: str,
    ) -> Role:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        role_id: str,
        payload: RoleUpdate,
        actor_uid: str,
    ) -> Role:
        return await self._update(
            scope,
            role_id,
            without_none(payload.model_dump()),
            actor_uid,
        )
