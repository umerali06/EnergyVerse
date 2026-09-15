"""Notification fan-out and retrieval.

`notify` is the single entry point every other module calls. It always writes
the in-app record first -- that is the durable, auditable copy -- then attempts
email and push. Email and push failures are swallowed by design: the action
that produced the notification (assigning a work order, requesting a permit
approval) has already succeeded and must not be rolled back because an alert
could not be delivered.

Notifications are personal, not permission-scoped. Every read path filters on
`user_id == actor_uid`, so there is no new RBAC permission: a user can only
ever see their own, exactly like `/auth/me`.
"""

import hashlib
import logging
from uuid import uuid4

from app.audit.service import AuditService
from app.core.settings import settings
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.device_tokens import DeviceTokenRepository
from app.db.repositories.notifications import NotificationRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    DeviceTokenCreate,
    Notification,
    NotificationChannel,
    NotificationCreate,
    NotificationEvent,
    NotificationTargetType,
)
from app.notifications.channels import (
    EmailNotifier,
    PushNotifier,
    get_email_notifier,
    get_push_notifier,
)

logger = logging.getLogger(__name__)

# Events important enough to leave the app. Everything else is in-app only, so
# routine traffic does not train people to ignore their inbox.
EMAIL_EVENTS: frozenset[NotificationEvent] = frozenset(
    {
        "work_order.assigned",
        "safety_report.assigned",
        "safety_report.corrective_action_assigned",
        "permit.approval_requested",
        "permit.expiring",
    }
)

# Anything a field user needs on their phone without opening the app.
PUSH_EVENTS: frozenset[NotificationEvent] = frozenset(
    {
        "work_order.assigned",
        "safety_report.assigned",
        "safety_report.corrective_action_assigned",
        "permit.approval_requested",
        "permit.activated",
        "permit.expiring",
    }
)


def device_token_id(token: str) -> str:
    """Hash the token for use as a document id.

    The raw FCM token is a credential; hashing keeps it out of document paths,
    logs and error messages while staying stable for upserts.
    """
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


class NotificationServiceError(Exception):
    def __init__(self, status_code: int, error: str, message: str) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.error = error
        self.message = message


class NotificationService:
    def __init__(
        self,
        *,
        notifications: NotificationRepository,
        device_tokens: DeviceTokenRepository,
        users: UserRepository,
        email: EmailNotifier | None = None,
        push: PushNotifier | None = None,
    ) -> None:
        self._notifications = notifications
        self._device_tokens = device_tokens
        self._users = users
        self._email = email or get_email_notifier()
        self._push = push or get_push_notifier()

    async def notify(
        self,
        scope: CompanyScope,
        *,
        user_id: str,
        event: NotificationEvent,
        title: str,
        body: str,
        target_type: NotificationTargetType,
        target_id: str,
        actor_uid: str,
        metadata: dict[str, str] | None = None,
    ) -> Notification | None:
        """Deliver one notification to one user across every enabled channel.

        Returns the stored record, or None when the notification was
        suppressed -- currently only when a user would be notified about their
        own action, which is noise rather than news.
        """
        if user_id == actor_uid:
            return None

        delivered: list[NotificationChannel] = ["in_app"]
        notification_id = f"notification_{uuid4().hex}"

        if event in EMAIL_EVENTS and await self._send_email(scope, user_id, title, body):
            delivered.append("email")
        if event in PUSH_EVENTS and await self._send_push(
            scope, user_id, title, body, event, target_type, target_id
        ):
            delivered.append("push")

        return await self._notifications.create(
            scope,
            NotificationCreate(
                id=notification_id,
                user_id=user_id,
                event=event,
                title=title,
                body=body,
                target_type=target_type,
                target_id=target_id,
                metadata=metadata or {},
                delivered_channels=delivered,
            ),
            actor_uid,
        )

    async def _send_email(self, scope: CompanyScope, user_id: str, title: str, body: str) -> bool:
        if not settings.email_configured:
            return False
        recipient = await self._users.get(scope, user_id)
        if recipient is None or not recipient.email:
            logger.info("No email address for %s; skipping notification email", user_id)
            return False
        return await self._email.send(
            to=recipient.email,
            display_name=recipient.display_name or recipient.email,
            title=title,
            body=body,
        )

    async def _send_push(
        self,
        scope: CompanyScope,
        user_id: str,
        title: str,
        body: str,
        event: NotificationEvent,
        target_type: NotificationTargetType,
        target_id: str,
    ) -> bool:
        registrations = await self._device_tokens.list_for_user(scope, user_id)
        if not registrations:
            return False
        tokens = [registration.token for registration in registrations]
        invalid = await self._push.send(
            tokens=tokens,
            title=title,
            body=body,
            # The client routes on these rather than the server emitting a URL.
            data={"event": event, "target_type": target_type, "target_id": target_id},
        )
        for token in invalid:
            # A token FCM reports as unregistered will never work again;
            # keeping it only produces repeated failed sends.
            await self._device_tokens.delete_token(scope, device_token_id(token))
        return len(invalid) < len(tokens)

    async def list_for_user(
        self, scope: CompanyScope, user_id: str, *, unread_only: bool = False
    ) -> list[Notification]:
        return await self._notifications.list_for_user(scope, user_id, unread_only=unread_only)

    async def unread_count(self, scope: CompanyScope, user_id: str) -> int:
        return len(await self._notifications.list_for_user(scope, user_id, unread_only=True))

    async def mark_read(
        self, scope: CompanyScope, notification_id: str, actor_uid: str
    ) -> Notification:
        updated = await self._notifications.mark_read(scope, notification_id, actor_uid)
        if updated is None:
            # A notification belonging to someone else is reported as missing
            # rather than forbidden, so the endpoint cannot be used to probe
            # whether another user's notification id exists.
            raise NotificationServiceError(
                404, "notification_not_found", "No notification with that id exists"
            )
        return updated

    async def mark_all_read(self, scope: CompanyScope, user_id: str) -> int:
        return await self._notifications.mark_all_read(scope, user_id)

    async def register_device(
        self, scope: CompanyScope, *, user_id: str, token: str, platform: str
    ) -> None:
        if platform not in ("android", "ios", "web"):
            raise NotificationServiceError(
                422, "invalid_platform", "platform must be android, ios, or web"
            )
        await self._device_tokens.upsert(
            scope,
            DeviceTokenCreate(
                id=device_token_id(token),
                user_id=user_id,
                token=token,
                platform=platform,
                last_seen_at=utc_now(),
            ),
            user_id,
        )

    async def unregister_device(self, scope: CompanyScope, token: str) -> None:
        await self._device_tokens.delete_token(scope, device_token_id(token))


def get_notification_service() -> NotificationService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return NotificationService(
        notifications=NotificationRepository(client, audit),
        device_tokens=DeviceTokenRepository(client, audit),
        users=UserRepository(client, audit),
    )
