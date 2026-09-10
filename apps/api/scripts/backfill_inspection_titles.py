"""Backfill `title` for inspections created before the service started
deriving one at creation time. Those records render as "Untitled" wherever a
reviewer sees them.

The derived title matches what `InspectionService.create_draft` now produces
for a new record -- the inspection type plus the asset it was raised against --
so backfilled and newly created inspections read identically.

Idempotent: only inspections whose `title` is null are touched, across every
tenant, and a re-run finds nothing left to do. The write deliberately does not
bump `revision`, so offline clients holding an optimistic-concurrency token do
not see a spurious conflict on a record nobody edited.

Usage:
    poetry run python -m scripts.backfill_inspection_titles
    poetry run python -m scripts.backfill_inspection_titles --dry-run
"""

import argparse
import asyncio

from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.inspections import InspectionRepository
from app.inspections.service import derive_title
from app.models.base import CompanyScope

BACKFILL_ACTOR_UID = "system:backfill_inspection_titles"

# Used only when the asset an inspection points at has since been hard-deleted,
# so the record still gets a readable name instead of staying "Untitled".
UNKNOWN_ASSET_NAME = "unknown asset"


async def backfill_inspection_titles(
    client: AsyncClient | None = None, *, dry_run: bool = False
) -> dict[str, str]:
    firestore_client = client or get_firestore_client()
    audit = AuditService(AuditLogRepository(firestore_client))
    inspections = InspectionRepository(firestore_client, audit)
    assets = AssetRepository(firestore_client, audit)

    untitled = await inspections.list_untitled()
    titled: dict[str, str] = {}
    asset_names: dict[tuple[str, str], str] = {}

    for inspection in untitled:
        scope = CompanyScope(company_id=inspection.company_id)
        cache_key = (inspection.company_id, inspection.asset_id)
        if cache_key not in asset_names:
            asset = await assets.get(scope, inspection.asset_id)
            asset_names[cache_key] = asset.name if asset is not None else UNKNOWN_ASSET_NAME
        title = derive_title(None, asset_names[cache_key], inspection.inspection_type)
        if not dry_run:
            await inspections.backfill_title(scope, inspection.id, title, BACKFILL_ACTOR_UID)
        titled[inspection.id] = title
    return titled


async def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report what would be titled without writing anything.",
    )
    args = parser.parse_args()

    titled = await backfill_inspection_titles(dry_run=args.dry_run)
    if not titled:
        print("No inspections needed a title backfill.")
        return
    prefix = "[dry-run] " if args.dry_run else ""
    for inspection_id, title in titled.items():
        print(f"{prefix}{inspection_id}: {title}")
    print(f"{prefix}{len(titled)} inspection(s) titled.")


if __name__ == "__main__":
    asyncio.run(main())
