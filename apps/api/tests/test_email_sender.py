"""The SMTP transport, and the transport choice.

These cover what a live send cannot check cheaply on every run: that the
session is encrypted *before* the password crosses it, that each way SMTP can
refuse is reported as its own actionable code rather than a bare 500, and that
the credentials never reach an error message. The real send lives in
`scripts/verify_smtp_email_live.py`.
"""

import asyncio
import smtplib
import ssl
from email import message_from_string

import pytest

from app.core.settings import settings
from app.email.sender import (
    EmailDeliveryError,
    EmailMessage,
    EmailNotConfiguredError,
    SesEmailSender,
    SmtpEmailSender,
    _build_mime,
    get_email_sender,
)

PASSWORD = "BLkUjk-not-the-real-one"


@pytest.fixture
def smtp_settings(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(settings, "smtp_host", "email-smtp.us-east-1.amazonaws.com")
    monkeypatch.setattr(settings, "smtp_port", 587)
    monkeypatch.setattr(settings, "smtp_user", "AKIAEXAMPLE")
    monkeypatch.setattr(settings, "smtp_pass", PASSWORD)
    monkeypatch.setattr(settings, "smtp_from", "noreply@flacronenergy.test")
    monkeypatch.setattr(settings, "ses_from_name", "Flacron Energy")
    monkeypatch.setattr(settings, "ses_reply_to", None)


@pytest.fixture
def ses_only_settings(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(settings, "smtp_host", None)
    monkeypatch.setattr(settings, "smtp_user", None)
    monkeypatch.setattr(settings, "smtp_pass", None)
    monkeypatch.setattr(settings, "smtp_from", None)
    monkeypatch.setattr(settings, "aws_region", "us-east-1")
    monkeypatch.setattr(settings, "aws_access_key_id", "AKIAEXAMPLE")
    monkeypatch.setattr(settings, "aws_secret_access_key", "secret")
    monkeypatch.setattr(settings, "ses_from_email", "noreply@flacronenergy.test")


def _message() -> EmailMessage:
    return EmailMessage(
        to="dana@operator.test",
        subject="Verify your email",
        html_body="<p>Hello</p>",
        text_body="Hello",
        inline_images={"fev-logo": b"\x89PNG\r\n\x1a\nnot-a-real-png"},
    )


class _FakeSmtp:
    """Records the call order, which is the part that matters for AUTH."""

    def __init__(self, *args: object, **kwargs: object) -> None:
        self.init_args = args
        self.init_kwargs = kwargs
        self.calls: list[str] = []
        self.sent: tuple[str, list[str], str] | None = None
        _FakeSmtp.last = self

    last: "_FakeSmtp | None" = None

    def __enter__(self) -> "_FakeSmtp":
        return self

    def __exit__(self, *exc: object) -> None:
        self.calls.append("quit")

    def ehlo(self) -> None:
        self.calls.append("ehlo")

    def starttls(self, context: ssl.SSLContext | None = None) -> None:
        self.calls.append("starttls")

    def login(self, user: str, password: str) -> None:
        self.calls.append("login")

    def sendmail(self, sender: str, recipients: list[str], raw: str) -> None:
        self.calls.append("sendmail")
        self.sent = (sender, recipients, raw)


# --------------------------------------------------------------- transport


def test_smtp_is_preferred_when_configured(smtp_settings: None) -> None:
    assert settings.smtp_configured is True
    assert settings.email_configured is True
    assert isinstance(get_email_sender(), SmtpEmailSender)


def test_falls_back_to_the_api_client_when_only_ses_is_configured(
    ses_only_settings: None,
) -> None:
    # Both are kept: a host that blocks the submission port can still send.
    assert settings.smtp_configured is False
    assert settings.email_configured is True
    assert isinstance(get_email_sender(), SesEmailSender)


def test_no_transport_at_all_is_reported_as_not_configured(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    for field in ("smtp_host", "smtp_user", "smtp_pass", "smtp_from"):
        monkeypatch.setattr(settings, field, None)
    for field in ("aws_access_key_id", "aws_secret_access_key", "ses_from_email"):
        monkeypatch.setattr(settings, field, None)

    assert settings.email_configured is False
    with pytest.raises(EmailNotConfiguredError):
        get_email_sender()


def test_smtp_only_still_counts_as_configured_for_the_send_gates(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    # Notifications used to gate on `ses_configured`, which an SMTP-only
    # deployment fails -- every notification email would have been skipped
    # silently while the transport worked perfectly.
    monkeypatch.setattr(settings, "aws_access_key_id", None)
    monkeypatch.setattr(settings, "aws_secret_access_key", None)
    monkeypatch.setattr(settings, "ses_from_email", None)

    assert settings.ses_configured is False
    assert settings.email_configured is True
    assert settings.email_from_address == "noreply@flacronenergy.test"


# ------------------------------------------------------------------- MIME


def test_the_message_carries_the_headers_a_filter_looks_for(smtp_settings: None) -> None:
    raw = _build_mime(_message()).as_string()
    parsed = message_from_string(raw)

    assert parsed["From"] == "Flacron Energy <noreply@flacronenergy.test>"
    assert parsed["To"] == "dana@operator.test"
    # Absent over SMTP unless the sender adds them; both are spam signals.
    assert parsed["Message-ID"] and parsed["Message-ID"].endswith("@flacronenergy.test>")
    assert parsed["Date"]


def test_the_logo_travels_in_the_message_rather_than_as_a_remote_image(
    smtp_settings: None,
) -> None:
    parsed = message_from_string(_build_mime(_message()).as_string())

    assert parsed.get_content_type() == "multipart/related"
    parts = list(parsed.walk())
    assert [part.get_content_type() for part in parts].count("text/plain") == 1
    assert [part.get_content_type() for part in parts].count("text/html") == 1
    images = [part for part in parts if part.get_content_type().startswith("image/")]
    assert len(images) == 1
    # Referenced from the HTML as `cid:fev-logo`, so it renders even when the
    # client blocks remote content -- which most do by default.
    assert images[0]["Content-ID"] == "<fev-logo>"


def test_a_reply_to_is_set_only_when_configured(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    assert message_from_string(_build_mime(_message()).as_string())["Reply-To"] is None

    monkeypatch.setattr(settings, "ses_reply_to", "support@flacronenergy.test")
    parsed = message_from_string(_build_mime(_message()).as_string())
    assert parsed["Reply-To"] == "support@flacronenergy.test"


# ------------------------------------------------------------------ sending


def test_the_session_is_encrypted_before_the_password_is_sent(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(smtplib, "SMTP", _FakeSmtp)

    asyncio.run(SmtpEmailSender().send(_message()))

    fake = _FakeSmtp.last
    assert fake is not None
    assert fake.calls == ["ehlo", "starttls", "ehlo", "login", "sendmail", "quit"]
    assert fake.calls.index("starttls") < fake.calls.index("login")
    assert fake.sent is not None
    envelope_sender, recipients, raw = fake.sent
    assert envelope_sender == "noreply@flacronenergy.test"
    assert recipients == ["dana@operator.test"]
    assert "Verify your email" in raw


def test_an_implicit_tls_port_opens_an_ssl_session_instead(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(settings, "smtp_port", 465)
    monkeypatch.setattr(smtplib, "SMTP_SSL", _FakeSmtp)

    asyncio.run(SmtpEmailSender().send(_message()))

    fake = _FakeSmtp.last
    assert fake is not None
    # No STARTTLS: 465 is already encrypted, and issuing it there fails.
    assert fake.calls == ["login", "sendmail", "quit"]


@pytest.mark.parametrize(
    ("raised", "expected_code"),
    [
        (
            smtplib.SMTPAuthenticationError(535, b"Authentication Credentials Invalid"),
            "smtp_auth_failed",
        ),
        (
            smtplib.SMTPSenderRefused(
                554, b"Email address is not verified", "noreply@flacronenergy.test"
            ),
            "smtp_sender_refused",
        ),
        (
            smtplib.SMTPRecipientsRefused({"dana@operator.test": (550, b"User unknown")}),
            "smtp_recipient_refused",
        ),
        (smtplib.SMTPServerDisconnected("connection lost"), "smtp_error"),
        (OSError("[WinError 10060] connection timed out"), "smtp_unreachable"),
    ],
)
def test_each_refusal_is_reported_as_its_own_actionable_code(
    smtp_settings: None,
    monkeypatch: pytest.MonkeyPatch,
    raised: Exception,
    expected_code: str,
) -> None:
    # Every one of these used to escape as an unhandled 500, which said "the
    # server is broken" about a working server whose provider had refused it.
    class _Failing(_FakeSmtp):
        def login(self, user: str, password: str) -> None:
            raise raised

    monkeypatch.setattr(smtplib, "SMTP", _Failing)

    with pytest.raises(EmailDeliveryError) as caught:
        asyncio.run(SmtpEmailSender().send(_message()))

    assert caught.value.code == expected_code


def test_a_failure_never_quotes_the_password(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    # The auth failure is the one most likely to be pasted into a ticket.
    class _Failing(_FakeSmtp):
        def login(self, user: str, password: str) -> None:
            raise smtplib.SMTPAuthenticationError(535, b"Authentication Credentials Invalid")

    monkeypatch.setattr(smtplib, "SMTP", _Failing)

    with pytest.raises(EmailDeliveryError) as caught:
        asyncio.run(SmtpEmailSender().send(_message()))

    assert PASSWORD not in str(caught.value)
    assert "Authentication Credentials Invalid" in str(caught.value)


def test_an_unreachable_host_names_the_host_and_port(
    smtp_settings: None, monkeypatch: pytest.MonkeyPatch
) -> None:
    # The original .env had SMTP_PORT=58, which is not an SMTP port at all --
    # the error has to say where it tried, or the typo is invisible.
    monkeypatch.setattr(settings, "smtp_port", 58)

    def _refuse(*args: object, **kwargs: object) -> None:
        raise OSError("connection refused")

    monkeypatch.setattr(smtplib, "SMTP", _refuse)

    with pytest.raises(EmailDeliveryError) as caught:
        asyncio.run(SmtpEmailSender().send(_message()))

    assert caught.value.code == "smtp_unreachable"
    assert "email-smtp.us-east-1.amazonaws.com:58" in str(caught.value)


def test_constructing_the_sender_without_credentials_fails_fast(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.setattr(settings, "smtp_pass", None)
    with pytest.raises(EmailNotConfiguredError):
        SmtpEmailSender()
