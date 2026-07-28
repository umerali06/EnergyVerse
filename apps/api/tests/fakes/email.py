"""In-memory stand-in for the SES sender, used by tests instead of hitting
real AWS. Mirrors only the `EmailSender` protocol surface.
"""

from dataclasses import dataclass, field

from app.email.sender import EmailMessage


@dataclass
class FakeEmailSender:
    sent: list[EmailMessage] = field(default_factory=list)

    async def send(self, message: EmailMessage) -> None:
        self.sent.append(message)
