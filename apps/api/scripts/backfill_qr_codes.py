"""Backfill `qr_code_id` for assets created before Phase 4.5 started
generating one at asset-creation time. Idempotent -- only touches assets
where `qr_code_id` is currently null, across every tenant; safe to re-run
(a re-run finds nothing left to do).

Usage:
    poetry run python -m scripts.backfill_qr_codes
"""

import asyncio

from google.cloud.firestore_v1.async_client import AsyncClient

from app.assets.qr import generate_unique_qr_code_id
from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.models.base import CompanyScope

BACKFILL_ACTOR_UID = "system:backfill_qr_codes"


async def backfill_qr_codes(client: AsyncClient | None = None) -> dict[str, str]:
    firestore_client = client or get_firestore_client()
    audit = AuditService(AuditLogRepository(firestore_client))
    assets = AssetRepository(firestore_client, audit)

    missing = await assets.list_missing_qr_codes()
    assigned: dict[str, str] = {}
    for asset in missing:
        code = await generate_unique_qr_code_id(assets)
        scope = CompanyScope(company_id=asset.company_id)
        await assets.backfill_qr_code(scope, asset.id, code, BACKFILL_ACTOR_UID)
        assigned[asset.id] = code
    return assigned


async def main() -> None:
    assigned = await backfill_qr_codes()
    if not assigned:
        print("No assets needed a qr_code_id backfill.")
        return
    for asset_id, code in assigned.items():
        print(f"{asset_id}: {code}")


if __name__ == "__main__":
    asyncio.run(main())
