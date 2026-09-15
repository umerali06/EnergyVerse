"""Send the three real transactional emails through the configured transport.

`SmtpEmailSender` is what this deployment now uses: SES's SMTP endpoint with
IAM SMTP credentials, rather than the SES API with account-wide AWS keys.
Nothing about that path can be proven by a unit test -- whether the credentials
authenticate, whether the From identity is verified, whether the submission
port is reachable, and whether the branded template survives a real provider
and renders in a real inbox are all questions only a real send answers.

It sends one of each template the product actually uses -- verification,
notification, contact -- because they differ in ways that matter to a mail
client: the contact template escapes untrusted input, and all three carry the
logo as an inline CID part rather than a remote image, which is what keeps it
visible when a client blocks remote content by default.

Usage:
    poetry run python -m scripts.verify_smtp_email_live <recipient>

With no recipient it sends to the configured From address, which is already a
verified identity -- so a default run cannot mail a third party. In an SES
sandbox account the recipient must be verified too, or SES refuses it.
"""

import asyncio
import sys
import time

from app.core.settings import settings
from app.email.sender import (
    EmailDeliveryError,
    EmailMessage,
    EmailNotConfiguredError,
    SmtpEmailSender,
    get_email_sender,
)
from app.email.templates import (
    RenderedEmail,
    render_contact_email,
    render_notification_email,
    render_verification_email,
)


def _cases() -> list[tuple[str, RenderedEmail]]:
    return [
        (
            "verification",
            render_verification_email(
                display_name="Dana Okafor",
                verification_link=f"{settings.app_base_url}/verify-email?oobCode=live-delivery-check",
            ),
        ),
        (
            "notification",
            render_notification_email(
                display_name="Dana Okafor",
                title="New work order assigned",
                body=(
                    "Replace pump seal on Feed Pump 101 (P-101) was assigned to you. "
                    "This is a delivery test of the transactional email pipeline."
                ),
                action_link=f"{settings.app_base_url}/work-orders",
            ),
        ),
        (
            "contact",
            render_contact_email(
                name="Dana Okafor",
                email="dana@operator.example",
                company="Northwind Refining",
                category="General Question",
                # Deliberately hostile input: the template escapes it, and a
                # live send is the only place to confirm the escaping survives
                # the provider rather than being rendered as markup.
                subject="Seat count <script>alert(1)</script>",
                message="How do I add a seat?\nSecond line, to check line breaks.",
                context_lines=["Submitted from the live delivery check"],
            ),
        ),
    ]


async def main() -> int:
    if not settings.email_configured:
        print(
            "No email transport is configured. Set SMTP_HOST / SMTP_PORT / "
            "SMTP_USER / SMTP_PASS / SMTP_FROM in apps/api/.env.",
            file=sys.stderr,
        )
        return 2

    recipient = sys.argv[1] if len(sys.argv) > 1 else settings.email_from_address
    assert recipient is not None

    try:
        sender = get_email_sender()
    except EmailNotConfiguredError as error:
        print(f"Email not configured: {error}", file=sys.stderr)
        return 2

    transport = "SMTP" if isinstance(sender, SmtpEmailSender) else "SES API"
    print(f"transport : {transport}")
    if isinstance(sender, SmtpEmailSender):
        print(f"host      : {settings.smtp_host}:{settings.smtp_port}")
    print(f"from      : {settings.ses_from_name} <{settings.email_from_address}>")
    print(f"reply-to  : {settings.ses_reply_to or '(none)'}")
    print(f"to        : {recipient}\n")

    failures = 0
    for name, rendered in _cases():
        started = time.monotonic()
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
        except EmailDeliveryError as error:
            failures += 1
            print(f"FAIL {name:<13} [{error.code}] {error}", file=sys.stderr)
            continue
        elapsed = time.monotonic() - started
        print(
            f"sent {name:<13} {elapsed:5.2f}s  "
            f"html {len(rendered.html_body):>5}B  text {len(rendered.text_body):>4}B  "
            f"inline {', '.join(rendered.inline_images) or 'none'}"
        )

    if failures:
        print(f"\n{failures} of {len(_cases())} refused.", file=sys.stderr)
        return 1

    print(
        "\nAll three accepted. Check the inbox: the logo should render without "
        "'show images', and the contact subject should show the tags as text."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
