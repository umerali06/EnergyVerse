"""Send one real notification email through the configured transport.

The notification module's email channel is covered by tests only against
`FakeEmailNotifier`. This proves the real path: credentials resolve, the
provider accepts the message, and the branded template renders as a multipart
MIME with its inline logo. For all three templates at once, and which transport
carried them, use `verify_smtp_email_live.py` instead.

Defaults to sending to the configured From address -- already a verified
identity, since nothing sends without one -- so a default run cannot mail a
third party.
Pass a recipient explicitly to send elsewhere; in an SES sandbox account that
address must also be verified or SES will reject it.

Usage:
    poetry run python -m scripts.verify_notification_email_live
    poetry run python -m scripts.verify_notification_email_live someone@example.com
"""

import asyncio
import sys

from app.core.settings import settings
from app.email.sender import EmailMessage, EmailNotConfiguredError, get_email_sender
from app.email.templates import render_notification_email

SUBJECT = "New work order assigned"
BODY = (
    "Replace pump seal on Feed Pump 101 (P-101) was assigned to you. "
    "This is a delivery test of the FEV notification email channel."
)


async def main() -> int:
    if not settings.email_configured:
        print(
            "No email transport is configured. Set SMTP_HOST / SMTP_PORT / "
            "SMTP_USER / SMTP_PASS / SMTP_FROM in apps/api/.env, or the "
            "AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / SES_FROM_EMAIL trio.",
            file=sys.stderr,
        )
        return 2

    recipient = sys.argv[1] if len(sys.argv) > 1 else settings.email_from_address
    assert recipient is not None

    rendered = render_notification_email(
        display_name="Dana Okafor",
        title=SUBJECT,
        body=BODY,
    )

    print(f"from      : {settings.ses_from_name} <{settings.email_from_address}>")
    print(f"to        : {recipient}")
    print(f"subject   : {rendered.subject}")
    print(f"html bytes: {len(rendered.html_body)}")
    print(f"text bytes: {len(rendered.text_body)}")
    print(f"inline    : {', '.join(rendered.inline_images) or 'none'}")

    try:
        sender = get_email_sender()
    except EmailNotConfiguredError as error:
        print(f"Email not configured: {error}", file=sys.stderr)
        return 2

    try:
        await sender.send(
            EmailMessage(
                to=recipient,
                subject=rendered.subject,
                html_body=rendered.html_body,
                text_body=rendered.text_body,
                inline_images=rendered.inline_images,
            )
        )
    except Exception as error:
        # SES rejects an unverified recipient in a sandbox account, which is
        # the most common failure here and worth naming rather than dumping.
        print(f"\nThe provider rejected the message: {error}", file=sys.stderr)
        return 1

    print("\nAccepted. Check the recipient's inbox (and spam).")
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
