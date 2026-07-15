from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.repositories.base import TenantRepository
from app.models.base import CompanyScope
from app.models.entities import (
    RolePermission,
    RolePermissionCreate,
    RolePermissionUpdate,
    without_none,
)


class RolePermissionRepository(TenantRepository[RolePermission]):
    collection_name = "role_permissions"
    target_type = "role_permission"
    model_type = RolePermission

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        super().__init__(client, audit)

    async def create(
        self,
        scope: CompanyScope,
        payload: RolePermissionCreate,
        actor_uid: str,
    ) -> RolePermission:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        mapping_id: str,
        payload: RolePermissionUpdate,
        actor_uid: str,
    ) -> RolePermission:
        return await self._update(
            scope,
            mapping_id,
            without_none(payload.model_dump()),
            actor_uid,
        )

    async def list_for_role(
        self,
        scope: CompanyScope,
        role_id: str,
    ) -> list[RolePermission]:
        mappings = await self.list(scope)
        return [mapping for mapping in mappings if mapping.role_id == role_id]
