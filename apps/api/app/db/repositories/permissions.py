from google.cloud.firestore_v1.async_client import AsyncClient

from app.db.firestore import get_firestore_client
from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS
from app.models.base import global_creation_fields, utc_now
from app.models.entities import (
    Permission,
    PermissionCreate,
    PermissionUpdate,
    without_none,
)


class PermissionRepository:
    """System-managed global permission catalog; intentionally not tenant-scoped."""

    collection_name = "permissions"

    def __init__(self, client: AsyncClient | None = None) -> None:
        self._client = client or get_firestore_client()

    async def get(self, permission_id: str) -> Permission | None:
        snapshot = await self._client.collection(self.collection_name).document(
            permission_id
        ).get(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None)
        if not snapshot.exists:
            return None
        data = snapshot.to_dict()
        return Permission.model_validate(data) if data is not None else None

    async def list(self) -> list[Permission]:
        permissions = []
        async for snapshot in self._client.collection(self.collection_name).stream(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS
        ):
            data = snapshot.to_dict()
            if data is not None:
                permissions.append(Permission.model_validate(data))
        return permissions

    async def create(self, payload: PermissionCreate) -> Permission:
        reference = self._client.collection(self.collection_name).document(payload.id)
        if (
            await reference.get(
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        ).exists:
            raise ValueError("permission already exists")
        permission = Permission.model_validate(
            {**payload.model_dump(), **global_creation_fields()}
        )
        await reference.set(
            permission.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        return permission

    async def update(
        self,
        permission_id: str,
        payload: PermissionUpdate,
    ) -> Permission:
        current = await self.get(permission_id)
        if current is None:
            raise LookupError("permission not found")
        permission = Permission.model_validate(
            {
                **current.model_dump(),
                **without_none(payload.model_dump()),
                "updated_at": utc_now(),
            }
        )
        await self._client.collection(self.collection_name).document(permission_id).set(
            permission.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        return permission

    async def delete(self, permission_id: str) -> None:
        if await self.get(permission_id) is None:
            raise LookupError("permission not found")
        await self._client.collection(self.collection_name).document(permission_id).delete(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
