import secrets

from app.core.settings import settings
from app.db.repositories.assets import AssetRepository

QR_CODE_ID_BYTES = 16
UNIQUE_CODE_ATTEMPTS = 5


async def generate_unique_qr_code_id(
    assets: AssetRepository, *, attempts: int = UNIQUE_CODE_ATTEMPTS
) -> str:
    """An opaque, unguessable token -- never the asset UUID, so a scanned
    label can't be used to enumerate a tenant's assets (D-041)."""
    for _ in range(attempts):
        candidate = secrets.token_urlsafe(QR_CODE_ID_BYTES)
        if await assets.get_by_qr_code(candidate) is None:
            return candidate
    raise RuntimeError(f"Could not generate a unique qr_code_id after {attempts} attempts")


def qr_code_url(code: str) -> str:
    return f"{settings.app_base_url}/qr/{code}"
