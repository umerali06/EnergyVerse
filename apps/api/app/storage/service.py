import logging
from datetime import timedelta
from pathlib import Path
from typing import Any
from uuid import uuid4

from firebase_admin import App, storage  # type: ignore[import-untyped]

from app.core.firebase import get_firebase_app
from app.core.settings import settings

logger = logging.getLogger(__name__)

SIGNED_URL_EXPIRATION = timedelta(hours=1)


class StorageNotConfiguredError(Exception):
    """Raised when no Firebase Storage bucket can be resolved."""


def _resolve_bucket_name(app: App) -> str:
    if settings.firebase_storage_bucket:
        return settings.firebase_storage_bucket
    if settings.firebase_project_id:
        return f"{settings.firebase_project_id}.appspot.com"
    raise StorageNotConfiguredError(
        "No Firebase Storage bucket configured; set FIREBASE_STORAGE_BUCKET"
    )


def get_storage_bucket() -> Any:
    app = get_firebase_app()
    if app is None:
        raise StorageNotConfiguredError("Firebase Admin SDK is not initialized")
    return storage.bucket(_resolve_bucket_name(app), app=app)


class CompanyLogoStorage:
    """Server-mediated Storage access for company branding logos.

    Every object lives at a fixed, company-scoped path
    (``companies/{company_id}/branding/logo``) -- the convention
    assets/inspections will reuse for their own object keys. `storage.rules`
    denies all client access; uploads and reads are entirely mediated by this
    service via the Admin SDK, reads via a short-lived signed URL rather than
    a public object.
    """

    def __init__(self, bucket: Any = None) -> None:
        self._bucket = bucket

    def _get_bucket(self) -> Any:
        if self._bucket is None:
            self._bucket = get_storage_bucket()
        return self._bucket

    @staticmethod
    def logo_path(company_id: str) -> str:
        return f"companies/{company_id}/branding/logo"

    def upload(self, company_id: str, data: bytes, content_type: str) -> str:
        path = self.logo_path(company_id)
        blob = self._get_bucket().blob(path)
        blob.upload_from_string(data, content_type=content_type)
        return path

    def delete(self, path: str) -> None:
        blob = self._get_bucket().blob(path)
        if blob.exists():
            blob.delete()

    def signed_url_for(self, path: str) -> str:
        blob = self._get_bucket().blob(path)
        url: str = blob.generate_signed_url(expiration=SIGNED_URL_EXPIRATION, version="v4")
        return url


def get_company_logo_storage() -> CompanyLogoStorage:
    return CompanyLogoStorage()


class AssetMediaStorage:
    """Server-mediated, tenant/asset-scoped private asset objects."""

    def __init__(self, bucket: Any = None) -> None:
        self._bucket = bucket

    def _get_bucket(self) -> Any:
        if self._bucket is None:
            self._bucket = get_storage_bucket()
        return self._bucket

    @staticmethod
    def object_path(company_id: str, asset_id: str, kind: str, filename: str) -> str:
        safe_name = Path(filename).name.replace(" ", "_")
        return (
            f"companies/{company_id}/assets/{asset_id}/{kind}/"
            f"{uuid4().hex}_{safe_name}"
        )

    def upload(
        self,
        company_id: str,
        asset_id: str,
        kind: str,
        filename: str,
        data: bytes,
        content_type: str,
    ) -> str:
        path = self.object_path(company_id, asset_id, kind, filename)
        self._get_bucket().blob(path).upload_from_string(data, content_type=content_type)
        return path

    def delete(self, path: str) -> None:
        blob = self._get_bucket().blob(path)
        if blob.exists():
            blob.delete()

    def signed_url_for(self, path: str) -> str:
        return str(
            self._get_bucket()
            .blob(path)
            .generate_signed_url(expiration=SIGNED_URL_EXPIRATION, version="v4")
        )


def get_asset_media_storage() -> AssetMediaStorage:
    return AssetMediaStorage()
