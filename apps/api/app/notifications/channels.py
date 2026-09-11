"""Outbound delivery for notifications: email and push.

Both sit behind a Protocol so `NotificationService` can be tested without AWS
credentials or a Firebase messaging round trip -- the same seam used for the
vision client, media storage and the video frame extractor.

Delivery on both channels is best-effort by design. A bounced email or a stale
device token must never fail the action that produced the notification: a
technician's work order is still assigned even if the alert about it could not
be sent. Failures are logged and reflected in `delivered_channels`, which
records what actually went out rather than what was intended.
"""

import asyncio
import logging
from typing import Protocol

from firebase_admin import messaging  # type: ignore[import-untyped]

from app.core.firebase import get_firebase_app
from app.core.settings import settings
from app.email.sender import EmailMessage, EmailNotConfiguredError, get_email_sender
from app.email.templates import render_notification_email

logger = logging.getLogger(__name__)


class EmailNotifier(Protocol):
    async def send(self, *, to: str, display_name: str, title: str, body: str) -> bool: ...


class PushNotifier(Protocol):
    async def send(
        self, *, tokens: list[str], title: str, body: str, data: dict[str, str]
    ) -> list[str]: ...


class SesEmailNotifier:
    """Renders the branded template and hands it to the SES sender."""

    async def send(self, *, to: str, display_name: str, title: str, body: str) -> bool:
        try:
            sender = get_email_sender()
        except EmailNotConfiguredError:
            # Local and CI environments have no SES credentials. Logging keeps
            # the flow observable there instead of raising into the caller.
            logger.info("Email not configured; skipping notification email to %s", to)
            return False
        rendered = render_notification_email(display_name=display_name, title=title, body=body)
        try:
            await sender.send(
                EmailMessage(
                    to=to,
                    subject=rendered.subject,
                    html_body=rendered.html_body,
                    text_body=rendered.text_body,
                    inline_images=rendered.inline_images,
                )
            )
        except Exception:
            logger.exception("Notification email to %s failed", to)
            return False
        return True


class FcmPushNotifier:
    """Sends through the Firebase Admin SDK, reusing the app's own credentials.

    Returns the tokens FCM rejected as permanently unregistered so the caller
    can prune them. A token that merely failed this once is not returned:
    deleting it would silently stop push for a working device.
    """

    async def send(
        self, *, tokens: list[str], title: str, body: str, data: dict[str, str]
    ) -> list[str]:
        if not tokens or not settings.push_notifications_enabled:
            return []
        app = get_firebase_app()
        if app is None:
            logger.info("Firebase app unavailable; skipping push notification")
            return []

        message = messaging.MulticastMessage(
            tokens=tokens,
            notification=messaging.Notification(title=title, body=body),
            data=data,
        )
        try:
            # The SDK call is blocking; keep it off the event loop.
            response = await asyncio.to_thread(
                messaging.send_each_for_multicast, message, app=app
            )
        except Exception:
            logger.exception("Push notification send failed")
            return []

        invalid: list[str] = []
        for token, result in zip(tokens, response.responses, strict=False):
            if result.success:
                continue
            if isinstance(result.exception, messaging.UnregisteredError):
                invalid.append(token)
            else:
                logger.warning("Push to one device token failed: %s", result.exception)
        return invalid


def get_email_notifier() -> EmailNotifier:
    return SesEmailNotifier()


def get_push_notifier() -> PushNotifier:
    return FcmPushNotifier()
