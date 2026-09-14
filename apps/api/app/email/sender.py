import asyncio
from collections.abc import Mapping
from dataclasses import dataclass, field
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from typing import Protocol

import boto3
from botocore.exceptions import BotoCoreError, ClientError

from app.core.settings import settings


@dataclass(frozen=True)
class EmailMessage:
    to: str
    subject: str
    html_body: str
    text_body: str
    # Content-ID (without angle brackets) -> raw image bytes, referenced in
    # html_body as `cid:<content_id>` so the logo renders without depending on
    # externally-hosted assets (which most mail clients block by default).
    inline_images: Mapping[str, bytes] = field(default_factory=dict)


class EmailSender(Protocol):
    async def send(self, message: EmailMessage) -> None: ...


class EmailNotConfiguredError(Exception):
    """No SES credentials at all. The deployment cannot send mail."""


class EmailDeliveryError(Exception):
    """SES was reachable and refused, or the call failed.

    Distinct from `EmailNotConfiguredError` because the causes are different
    and so is the fix: credentials that are present but rejected
    (`InvalidClientTokenId` after a key rotation), a sender address that is no
    longer verified, a region mismatch, sandbox restrictions, throttling. All
    of those used to escape as an unhandled 500, which said "the server is
    broken" about a working server whose mail provider had refused it.

    Carries the provider's own error code so a log or a support ticket names
    the actual cause rather than "email failed".
    """

    def __init__(self, message: str, *, code: str = "ses_error") -> None:
        super().__init__(message)
        self.code = code


def _build_mime(message: EmailMessage) -> MIMEMultipart:
    root = MIMEMultipart("related")
    root["Subject"] = message.subject
    root["From"] = f"{settings.ses_from_name} <{settings.ses_from_email}>"
    root["To"] = message.to
    if settings.ses_reply_to:
        root["Reply-To"] = settings.ses_reply_to

    alternative = MIMEMultipart("alternative")
    alternative.attach(MIMEText(message.text_body, "plain", "utf-8"))
    alternative.attach(MIMEText(message.html_body, "html", "utf-8"))
    root.attach(alternative)

    for content_id, image_bytes in message.inline_images.items():
        image = MIMEImage(image_bytes)
        image.add_header("Content-ID", f"<{content_id}>")
        image.add_header("Content-Disposition", "inline", filename=f"{content_id}.png")
        root.attach(image)

    return root


class SesEmailSender:
    def __init__(self) -> None:
        if not settings.ses_configured:
            raise EmailNotConfiguredError("SES credentials are not configured")
        self._client = boto3.client(
            "ses",
            region_name=settings.aws_region,
            aws_access_key_id=settings.aws_access_key_id,
            aws_secret_access_key=settings.aws_secret_access_key,
        )

    async def send(self, message: EmailMessage) -> None:
        mime_message = _build_mime(message)
        try:
            await asyncio.to_thread(
                self._client.send_raw_email,
                Source=settings.ses_from_email,
                Destinations=[message.to],
                RawMessage={"Data": mime_message.as_string()},
            )
        except ClientError as error:
            # `ses_configured` can only check the keys are *present*; whether
            # they are still valid is something only SES can answer.
            code = str(error.response.get("Error", {}).get("Code") or "ses_error")
            raise EmailDeliveryError(
                f"SES refused the message ({code})", code=code
            ) from error
        except BotoCoreError as error:
            raise EmailDeliveryError(f"Could not reach SES: {error}") from error


def get_email_sender() -> EmailSender:
    return SesEmailSender()
