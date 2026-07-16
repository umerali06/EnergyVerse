from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
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

    async def find_by_email(self, scope: CompanyScope, email: str) -> User | None:
        """Find within a tenant; used to keep seed identity reconciliation scoped."""
        normalized = email.casefold()
        matches = [user for user in await self.list(scope) if user.email.casefold() == normalized]
        return next((user for user in matches if not user.id.startswith("demo-")), None) or next(
            iter(matches), None
        )

    async def migrate_seed_user_id(
        self,
        scope: CompanyScope,
        *,
        placeholder_id: str,
        firebase_uid: str,
        expected_email: str,
        actor_uid: str,
    ) -> User:
        """Re-key one known demo user; never performs a general user migration."""
        if not placeholder_id.startswith("demo-"):
            raise ValueError("Only demo seed user IDs may be migrated")

        target = await self.get(scope, firebase_uid)
        source = await self.get(scope, placeholder_id)
        if target is not None:
            if target.email.casefold() != expected_email.casefold():
                raise ValueError("Firebase UID belongs to a different user")
            if source is not None:
                await self._collection.document(placeholder_id).delete(
                    timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                    retry=None,
                )
                await self._write_audit(
                    scope,
                    actor_uid=actor_uid,
                    action="user.migrated_to_auth_uid",
                    target_id=firebase_uid,
                    metadata={
                        "old_uid": placeholder_id,
                        "new_uid": firebase_uid,
                        "recovered_partial_run": True,
                    },
                )
            return target

        if source is None:
            by_email = await self.find_by_email(scope, expected_email)
            if by_email is None:
                raise LookupError("Demo seed user is missing")
            if by_email.id == firebase_uid:
                return by_email
            raise ValueError("Demo email belongs to an unexpected user document")
        if source.email.casefold() != expected_email.casefold():
            raise ValueError("Placeholder ID belongs to a different demo user")

        migrated = User.model_validate({**source.model_dump(), "id": firebase_uid})
        await self._collection.document(firebase_uid).set(
            migrated.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._collection.document(placeholder_id).delete(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="user.migrated_to_auth_uid",
            target_id=firebase_uid,
            metadata={"old_uid": placeholder_id, "new_uid": firebase_uid},
        )
        return migrated
