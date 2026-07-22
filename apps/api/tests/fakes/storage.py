"""In-memory stand-in for a Firebase Storage bucket, used by tests instead of
hitting real GCS. Mimics only the subset of the `google.cloud.storage.Bucket`
surface `CompanyLogoStorage` touches, so the real service class's path/
validation logic is exercised unchanged.
"""

from dataclasses import dataclass, field
from datetime import timedelta


@dataclass
class FakeBlob:
    bucket: "FakeBucket"
    path: str

    def upload_from_string(self, data: bytes, content_type: str) -> None:
        self.bucket.objects[self.path] = (data, content_type)

    def exists(self) -> bool:
        return self.path in self.bucket.objects

    def delete(self) -> None:
        self.bucket.objects.pop(self.path, None)

    def generate_signed_url(self, expiration: timedelta, version: str = "v4") -> str:
        return f"https://fake-storage.invalid/{self.path}?signed=1"


@dataclass
class FakeBucket:
    objects: dict[str, tuple[bytes, str]] = field(default_factory=dict)

    def blob(self, path: str) -> FakeBlob:
        return FakeBlob(self, path)
