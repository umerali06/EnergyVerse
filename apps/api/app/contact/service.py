"""Delivery of public contact-form submissions.

The form is unauthenticated by necessity -- a prospective customer, a security
researcher, or someone exercising a privacy right has no account -- so the two
protections that matter here are input bounds (enforced by the request model)
and never echoing the sender's text anywhere it could be executed. The rendered
email escapes every field.

Account context is attached by the *caller* from a verified identity when one
exists, never from anything the browser claims: a signed-in user's id, company
and tier are worth having in the support inbox, but only if they are true.
"""

from __future__ import annotations

import logging

from app.email.sender import EmailMessage, EmailSender
from app.email.templates import render_contact_email

logger = logging.getLogger(__name__)


class ContactService:
    def __init__(self, *, sender: EmailSender, destination: str) -> None:
        self._sender = sender
        self._destination = destination

    async def submit(
        self,
        *,
        name: str,
        email: str,
        company: str | None,
        category: str,
        subject: str,
        message: str,
        context_lines: list[str],
    ) -> None:
        rendered = render_contact_email(
            name=name,
            email=email,
            company=company,
            category=category,
            subject=subject,
            message=message,
            context_lines=context_lines,
        )
        await self._sender.send(
            EmailMessage(
                to=self._destination,
                subject=rendered.subject,
                html_body=rendered.html_body,
                text_body=rendered.text_body,
                inline_images=rendered.inline_images,
            )
        )
        logger.info("Contact form submitted: category=%s", category)
