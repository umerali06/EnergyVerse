"""Reconcile time-expired permits across every registered tenant.

Deploy this command as a recurring scheduler job. API reads also run the same
server-time reconciliation, so stale active state cannot be returned between
scheduler runs.

Usage:
    poetry run python -m scripts.expire_permits
"""

import asyncio

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.permit_templates import PermitTemplateRepository
from app.db.repositories.permits import PermitRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.permits.service import PermitService


async def expire_due_permits() -> dict[str, int]:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    service = PermitService(
        PermitRepository(client, audit),
        PermitTemplateRepository(client, audit),
        UserRepository(client, audit),
        FacilityRepository(client, audit),
        AreaRepository(client, audit),
        AssetRepository(client, audit),
    )
    results: dict[str, int] = {}
    for company in await CompanyRepository(client).list_all():
        results[company.id] = await service.reconcile_expired(CompanyScope(company_id=company.id))
    return results


async def main() -> None:
    results = await expire_due_permits()
    for company_id, count in sorted(results.items()):
        print(f"{company_id}: {count}")


if __name__ == "__main__":
    asyncio.run(main())
