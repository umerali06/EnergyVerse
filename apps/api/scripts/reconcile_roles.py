"""Backfill an already-registered tenant's system roles against the current
`SYSTEM_ROLE_TEMPLATES` (app/rbac/constants.py).

`run_seed` (scripts/seed.py) only reconciles the two demo tenants (Acme/Beta) plus
whatever a fresh registration seeds once at signup time. A permission added to the
catalog after a real tenant already exists (e.g. `audit.read` in Phase 3.4) never
reaches that tenant's system roles automatically. This script re-runs the same
idempotent `seed_system_roles` diff for one arbitrary, already-registered company_id.

Usage:
    poetry run python -m scripts.reconcile_roles --company-id <company_id>
"""

import argparse
import asyncio

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.models.base import CompanyScope
from app.rbac.seeding import seed_system_roles

RECONCILE_ACTOR_UID = "system:reconcile_roles"


async def reconcile_company_roles(company_id: str) -> dict[str, str]:
    client = get_firestore_client()
    scope = CompanyScope(company_id=company_id)
    companies = CompanyRepository(client)
    company = await companies.get(scope)
    if company is None:
        raise ValueError(f"Company {company_id!r} was not found")

    audit_logs = AuditLogRepository(client)
    audit = AuditService(audit_logs)
    roles = RoleRepository(client, audit)
    role_permissions = RolePermissionRepository(client, audit)
    return await seed_system_roles(
        scope,
        roles,
        role_permissions,
        actor_uid=RECONCILE_ACTOR_UID,
    )


async def main() -> None:
    parser = argparse.ArgumentParser(
        description="Reconcile one existing tenant's system roles against SYSTEM_ROLE_TEMPLATES"
    )
    parser.add_argument("--company-id", required=True, help="Target tenant's company_id")
    arguments = parser.parse_args()
    role_ids = await reconcile_company_roles(arguments.company_id)
    for role_key, role_id in role_ids.items():
        print(f"{role_key}: {role_id}")


if __name__ == "__main__":
    asyncio.run(main())
