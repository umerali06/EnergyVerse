from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.repositories.base import TenantRepository
from app.models.base import CompanyScope
from app.models.entities import User, UserCreate, UserUpdate, without_none


class UserRepository(TenantRepository[User]):
    collection_name = "users"
    target_type = "user"
    model_type = User

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        super().__init__(client, audit)

    async def create(
        self,
        scope: CompanyScope,
        payload: UserCreate,
        actor_uid: str,
    ) -> User:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        user_id: str,
        payload: UserUpdate,
        actor_uid: str,
    ) -> User:
        return await self._update(
            scope,
            user_id,
            without_none(payload.model_dump()),
            actor_uid,
        )
