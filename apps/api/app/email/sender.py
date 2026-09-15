import asyncio
import smtplib
import ssl
from collections.abc import Mapping
from dataclasses import dataclass, field
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formataddr, formatdate, make_msgid
from typing import Protocol

import boto3
from botocore.exceptions import BotoCoreError, ClientError

from app.core.settings import settings

# Long enough for a TLS handshake on a slow link, short enough that a
# blocked port fails the request instead of hanging it.
_SMTP_TIMEOUT_SECONDS = 20


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
    """No transport is configured at all. The deployment cannot send mail."""


class EmailDeliveryError(Exception):
    """The provider was reachable and refused, or the call failed.

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


def _decode(raw: bytes | str) -> str:
    return raw.decode(errors="replace") if isinstance(raw, bytes) else str(raw)


def _from_address() -> str:
    address = settings.email_from_address
    if not address:
        raise EmailNotConfiguredError("No sender address is configured")
    return address


def _build_mime(message: EmailMessage) -> MIMEMultipart:
    root = MIMEMultipart("related")
    root["Subject"] = message.subject
    # `formataddr` quotes and encodes the display name. An unescaped name
    # holding a comma or a non-ASCII character produces a malformed From
    # header, which on its own is enough for a filter to reject the message.
    root["From"] = formataddr((settings.ses_from_name, _from_address()))
    root["To"] = message.to
    if settings.ses_reply_to:
        root["Reply-To"] = settings.ses_reply_to
    # Message-ID and Date are not optional for deliverability: several large
    # providers treat a message missing either as a spam signal. SES adds them
    # itself when it accepts a message through the API, but over SMTP the
    # sender is responsible for them -- which is exactly the kind of difference
    # that turns "it sends" into "it sends, into spam".
    root["Message-ID"] = make_msgid(domain=_from_address().rpartition("@")[2] or None)
    root["Date"] = formatdate(localtime=True)

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


class SmtpEmailSender:
    """Sends through an SMTP relay -- in this deployment, SES's SMTP endpoint.

    Preferred over the API client when SMTP is configured, because SMTP
    credentials are scoped to sending and nothing else, whereas the API path
    needs AWS keys carrying whatever else that IAM user can do.

    The connection is opened per send rather than pooled. An idle SMTP session
    is dropped by the server after a few minutes and the failure then surfaces
    on some later, unrelated send; at this volume reconnecting is the cheaper
    correctness.
    """

    def __init__(self) -> None:
        if not settings.smtp_configured:
            raise EmailNotConfiguredError("SMTP credentials are not configured")
        self._host = str(settings.smtp_host)
        self._port = int(settings.smtp_port)
        self._user = str(settings.smtp_user)
        self._password = str(settings.smtp_pass)

    def _deliver(self, raw: str, recipient: str) -> None:
        context = ssl.create_default_context()
        # 465 is implicit TLS; 587 (and 25 / 2587) negotiate it with STARTTLS.
        # Either way the session is encrypted before the password crosses it --
        # SMTP AUTH on a cleartext channel hands the credentials to anyone on
        # the path.
        if self._port in (465, 2465):
            with smtplib.SMTP_SSL(
                self._host, self._port, context=context, timeout=_SMTP_TIMEOUT_SECONDS
            ) as client:
                client.login(self._user, self._password)
                client.sendmail(_from_address(), [recipient], raw)
            return
        with smtplib.SMTP(self._host, self._port, timeout=_SMTP_TIMEOUT_SECONDS) as client:
            client.ehlo()
            client.starttls(context=context)
            client.ehlo()
            client.login(self._user, self._password)
            client.sendmail(_from_address(), [recipient], raw)

    async def send(self, message: EmailMessage) -> None:
        raw = _build_mime(message).as_string()
        try:
            await asyncio.to_thread(self._deliver, raw, message.to)
        except smtplib.SMTPAuthenticationError as error:
            # The most common failure here, and the one worth naming: SES SMTP
            # credentials are not the AWS access key, they are derived from it
            # in the SES console, so a pasted AWS key authenticates against
            # nothing and the generic message would not say why.
            raise EmailDeliveryError(
                f"SMTP rejected the credentials: {_decode(error.smtp_error)}",
                code="smtp_auth_failed",
            ) from error
        except smtplib.SMTPRecipientsRefused as error:
            raise EmailDeliveryError(
                f"SMTP refused the recipient {message.to}: {error.recipients}",
                code="smtp_recipient_refused",
            ) from error
        except smtplib.SMTPSenderRefused as error:
            # Almost always an unverified From identity, or the SES sandbox.
            raise EmailDeliveryError(
                f"SMTP refused the sender {error.sender}: {_decode(error.smtp_error)}",
                code="smtp_sender_refused",
            ) from error
        except smtplib.SMTPException as error:
            raise EmailDeliveryError(f"SMTP send failed: {error}", code="smtp_error") from error
        except (OSError, ssl.SSLError) as error:
            # Wrong port, blocked egress, or a TLS failure. Kept apart from a
            # refusal because the fix is network or configuration, not content.
            raise EmailDeliveryError(
                f"Could not reach the SMTP host {self._host}:{self._port}: {error}",
                code="smtp_unreachable",
            ) from error


def get_email_sender() -> EmailSender:
    """The configured transport, SMTP first.

    Both are kept because they fail differently and a deployment may have only
    one: SMTP needs egress on the submission port, which some hosts block,
    while the API path needs nothing but HTTPS.
    """
    if settings.smtp_configured:
        return SmtpEmailSender()
    return SesEmailSender()
