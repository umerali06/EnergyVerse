from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import DeviceToken, DeviceTokenCreate


class DeviceTokenRepository(TenantRepository[DeviceToken]):
    collection_name = "device_tokens"
    target_type = "device_token"
    model_type = DeviceToken

    async def upsert(
        self, scope: CompanyScope, payload: DeviceTokenCreate, actor_uid: str
    ) -> DeviceToken:
        """Register a token, reassigning it if it already exists.

        The same physical device can be handed between people (a shared site
        tablet), so a re-registration under a different user must move the
        token rather than fail -- otherwise push for the new user would go to
        nobody and the old user would keep receiving the new user's alerts.
        """
        existing = await self.get(scope, payload.id)
        now = utc_now()
        if existing is not None:
            await self._collection.document(payload.id).update(
                {"user_id": payload.user_id, "last_seen_at": now, "updated_at": now},
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
            refreshed = await self.get(scope, payload.id)
            assert refreshed is not None
            return refreshed
        data = {
            **payload.model_dump(),
            "created_by": actor_uid,
            "created_at": now,
            "updated_at": now,
        }
        return await self._create(scope, payload.id, data, actor_uid)

    async def list_for_user(self, scope: CompanyScope, user_id: str) -> list[DeviceToken]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        query = query.where(filter=FieldFilter("user_id", "==", user_id))
        tokens: list[DeviceToken] = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                tokens.append(self.model_type.model_validate(data))
        return tokens

    async def delete_token(self, scope: CompanyScope, token_id: str) -> bool:
        """Hard delete -- a token that FCM has rejected is worthless, and
        keeping it would only cause repeated failed sends."""
        existing = await self.get(scope, token_id)
        if existing is None:
            return False
        await self._collection.document(token_id).delete(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        return True
