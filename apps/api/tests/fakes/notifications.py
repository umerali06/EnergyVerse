"""In-memory stand-ins for the email and push channels.

Keeps notification tests free of AWS credentials and Firebase messaging, the
same seam used for the vision client, media storage and the frame extractor.
"""

from dataclasses import dataclass, field


@dataclass
class FakeEmailNotifier:
    sent: list[dict[str, str]] = field(default_factory=list)
    succeeds: bool = True

    async def send(self, *, to: str, display_name: str, title: str, body: str) -> bool:
        self.sent.append(
            {"to": to, "display_name": display_name, "title": title, "body": body}
        )
        return self.succeeds


@dataclass
class FakePushNotifier:
    sent: list[dict[str, object]] = field(default_factory=list)
    # Tokens to report back as permanently unregistered, so the caller prunes
    # them -- mirrors what FCM returns for a device that has been wiped.
    invalid_tokens: list[str] = field(default_factory=list)

    async def send(
        self, *, tokens: list[str], title: str, body: str, data: dict[str, str]
    ) -> list[str]:
        self.sent.append({"tokens": list(tokens), "title": title, "body": body, "data": data})
        return [token for token in tokens if token in self.invalid_tokens]
