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
    size: int | None = None
    content_type: str | None = None

    def upload_from_string(self, data: bytes, content_type: str) -> None:
        self.bucket.objects[self.path] = (data, content_type)

    def exists(self) -> bool:
        return self.path in self.bucket.objects

    def reload(self) -> None:
        """Populates `.size`/`.content_type` from the fake bucket's stored
        object -- mimics the real `Blob.reload()` used by
        `InspectionMediaStorage.verify_uploaded` (Phase 7.4) to read back
        what a mobile client already uploaded directly to Storage."""
        data, content_type = self.bucket.objects[self.path]
        self.size = len(data)
        self.content_type = content_type

    def delete(self) -> None:
        self.bucket.objects.pop(self.path, None)

    def generate_signed_url(self, expiration: timedelta, version: str = "v4") -> str:
        return f"https://fake-storage.invalid/{self.path}?signed=1"


@dataclass
class FakeBucket:
    objects: dict[str, tuple[bytes, str]] = field(default_factory=dict)

    def blob(self, path: str) -> FakeBlob:
        return FakeBlob(self, path)

    def seed(self, path: str, data: bytes, content_type: str) -> None:
        """Test helper simulating a direct-to-Storage client upload (Phase
        7.4) that never goes through this fake's own `upload_from_string`."""
        self.objects[path] = (data, content_type)
