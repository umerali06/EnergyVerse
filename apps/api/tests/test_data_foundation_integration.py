import asyncio
import os

import pytest

from app.db.firestore import get_firestore_client, reset_firestore_client_for_testing
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.seeding import system_role_id
from app.rbac.service import PermissionResolver
from scripts.seed import ACME_COMPANY_ID, SECOND_COMPANY_ID

has_real_credentials = bool(
    os.getenv("GOOGLE_APPLICATION_CREDENTIALS") or os.getenv("FIREBASE_CREDENTIALS_B64")
)


@pytest.mark.integration
@pytest.mark.skipif(not has_real_credentials, reason="Firebase credentials are not configured")
def test_real_seeded_tenants_are_isolated_and_roles_resolve() -> None:
    reset_firestore_client_for_testing()
    async def scenario() -> None:
        client = get_firestore_client()
        users = UserRepository(client)
        roles = RoleRepository(client)
        mappings = RolePermissionRepository(client)
        permissions = PermissionRepository(client)
        resolver = PermissionResolver(users, roles, mappings, permissions)
        acme = CompanyScope(company_id=ACME_COMPANY_ID)
        second = CompanyScope(company_id=SECOND_COMPANY_ID)

        acme_users = await users.list(acme)
        assert len(acme_users) == 7
        assert len(await users.list(second)) == 1
        assert await users.get(acme, "demo-beta-company-admin") is None
        assert await users.get(second, "demo-acme-super_admin") is None

        for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
            role_user = next(
                user
                for user in acme_users
                if user.role_id == system_role_id(ACME_COMPANY_ID, role_key)
            )
            resolved = await resolver.resolve_for_user(acme, role_user.id)
            assert resolved == template.permission_keys

    asyncio.run(scenario())
