"""Send one real notification email through AWS SES.

The notification module's email channel is covered by tests only against
`FakeEmailNotifier`, and `SesEmailSender` itself has never sent a message in
this codebase -- it sat unmerged on a backup branch from July until it was
recovered. This proves the real path: credentials resolve, SES accepts the
message, and the branded template renders as a multipart MIME with its inline
logo.

Defaults to sending to `SES_FROM_EMAIL` -- the address the account already
verified in order to send at all -- so a default run cannot mail a third party.
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
    if not settings.ses_configured:
        print(
            "SES is not configured (needs AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY "
            "and SES_FROM_EMAIL in apps/api/.env).",
            file=sys.stderr,
        )
        return 2

    recipient = sys.argv[1] if len(sys.argv) > 1 else settings.ses_from_email
    assert recipient is not None

    rendered = render_notification_email(
        display_name="Dana Okafor",
        title=SUBJECT,
        body=BODY,
    )

    print(f"region    : {settings.aws_region}")
    print(f"from      : {settings.ses_from_name} <{settings.ses_from_email}>")
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
        print(f"\nSES rejected the message: {error}", file=sys.stderr)
        return 1

    print("\nSES accepted the message. Check the recipient's inbox (and spam).")
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
