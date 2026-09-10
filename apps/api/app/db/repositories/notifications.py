from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import Notification, NotificationCreate

# Matches the read-cap convention used across this codebase: the query is
# already bounded by company_id plus the recipient, but this guards the worst
# case of a very long-lived account.
NOTIFICATION_QUERY_CAP = 2000


class NotificationRepository(TenantRepository[Notification]):
    collection_name = "notifications"
    target_type = "notification"
    model_type = Notification

    async def create(
        self, scope: CompanyScope, payload: NotificationCreate, actor_uid: str
    ) -> Notification:
        now = utc_now()
        data = {
            **payload.model_dump(),
            "created_by": actor_uid,
            "read_at": None,
            "created_at": now,
            "updated_at": now,
        }
        return await self._create(scope, payload.id, data, actor_uid)

    async def list_for_user(
        self, scope: CompanyScope, user_id: str, *, unread_only: bool = False
    ) -> list[Notification]:
        """Newest first, for one recipient only.

        Ordering is applied in memory rather than pushed to Firestore: a
        `company_id` + `user_id` equality pair plus an `order_by` needs its own
        composite index, and the per-user row count is small and capped.
        """
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        query = query.where(filter=FieldFilter("user_id", "==", user_id))
        rows: list[Notification] = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is None or data.get("company_id") != scope.company_id:
                continue
            notification = self.model_type.model_validate(data)
            if unread_only and notification.read_at is not None:
                continue
            rows.append(notification)
            if len(rows) >= NOTIFICATION_QUERY_CAP:
                break
        rows.sort(key=lambda row: row.created_at, reverse=True)
        return rows

    async def mark_read(
        self, scope: CompanyScope, notification_id: str, actor_uid: str
    ) -> Notification | None:
        """Idempotent: an already-read notification keeps its original
        `read_at` rather than being re-stamped."""
        current = await self.get(scope, notification_id)
        if current is None or current.user_id != actor_uid:
            return None
        if current.read_at is not None:
            return current
        now = utc_now()
        await self._collection.document(notification_id).update(
            {"read_at": now, "updated_at": now},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        return await self.get(scope, notification_id)

    async def mark_all_read(self, scope: CompanyScope, user_id: str) -> int:
        unread = await self.list_for_user(scope, user_id, unread_only=True)
        now = utc_now()
        for notification in unread:
            await self._collection.document(notification.id).update(
                {"read_at": now, "updated_at": now},
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        return len(unread)
