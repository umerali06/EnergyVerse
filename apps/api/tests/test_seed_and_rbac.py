import asyncio

from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.rbac.constants import PERMISSION_CATALOG, SYSTEM_ROLE_TEMPLATES
from app.rbac.service import PermissionResolver
from scripts.seed import ACME_COMPANY_ID, SECOND_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient

EXPECTED_ROLE_PERMISSIONS = {
    "super_admin": frozenset(
        {
            "assets.read",
            "assets.write",
            "inspections.read",
            "inspections.write",
            "permits.read",
            "permits.approve",
            "work_orders.read",
            "work_orders.write",
            "reports.read",
            "reports.generate",
            "safety.read",
            "safety.write",
            "users.manage",
            "roles.manage",
            "company.settings",
            "platform.admin",
        }
    ),
    "company_admin": frozenset(
        {
            "assets.read",
            "assets.write",
            "inspections.read",
            "inspections.write",
            "permits.read",
            "permits.approve",
            "work_orders.read",
            "work_orders.write",
            "reports.read",
            "reports.generate",
            "safety.read",
            "safety.write",
            "users.manage",
            "roles.manage",
            "company.settings",
        }
    ),
    "operations_manager": frozenset(
        {
            "assets.read",
            "assets.write",
            "inspections.read",
            "permits.read",
            "work_orders.read",
            "work_orders.write",
            "reports.read",
            "reports.generate",
            "safety.read",
        }
    ),
    "field_inspector": frozenset(
        {
            "assets.read",
            "inspections.read",
            "inspections.write",
            "permits.read",
            "work_orders.read",
            "reports.read",
            "reports.generate",
            "safety.read",
            "safety.write",
        }
    ),
    "maintenance_technician": frozenset(
        {
            "assets.read",
            "inspections.read",
            "permits.read",
            "work_orders.read",
            "work_orders.write",
            "reports.read",
            "safety.read",
        }
    ),
    "hse_manager": frozenset(
        {
            "assets.read",
            "inspections.read",
            "permits.read",
            "permits.approve",
            "work_orders.read",
            "reports.read",
            "reports.generate",
            "safety.read",
            "safety.write",
        }
    ),
    "executive": frozenset(
        {
            "assets.read",
            "inspections.read",
            "permits.read",
            "work_orders.read",
            "reports.read",
            "safety.read",
        }
    ),
}


def test_permission_catalog_is_exact() -> None:
    grouped = {
        "assets": {"assets.read", "assets.write"},
        "inspections": {"inspections.read", "inspections.write"},
        "permits": {"permits.read", "permits.approve"},
        "work_orders": {"work_orders.read", "work_orders.write"},
        "reports": {"reports.read", "reports.generate"},
        "safety": {"safety.read", "safety.write"},
        "users": {"users.manage"},
        "roles": {"roles.manage"},
        "company": {"company.settings"},
        "platform": {"platform.admin"},
    }
    actual = {
        group: {permission.key for permission in PERMISSION_CATALOG if permission.group == group}
        for group in grouped
    }
    assert actual == grouped
    assert len(PERMISSION_CATALOG) == 16


def test_seed_is_idempotent_and_base_contracts_are_exact() -> None:
    async def scenario() -> None:
        client = FakeAsyncClient()
        first = await run_seed(client)  # type: ignore[arg-type]
        counts_after_first = client.counts()
        second = await run_seed(client)  # type: ignore[arg-type]

        expected_mappings = sum(
            len(template.permission_keys) for template in SYSTEM_ROLE_TEMPLATES.values()
        ) + len(SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys)
        assert first == second
        assert client.counts() == counts_after_first
        assert first.companies == 2
        assert first.permissions == 16
        assert first.roles == 8
        assert first.role_permissions == expected_mappings
        assert first.users == 8
        assert set(client.counts()) == {
            "audit_logs",
            "companies",
            "permissions",
            "role_permissions",
            "roles",
            "users",
        }

        company = client.documents("companies")[ACME_COMPANY_ID]
        permission = client.documents("permissions")["assets.read"]
        role = client.documents("roles")[f"{ACME_COMPANY_ID}__field_inspector"]
        mapping = next(iter(client.documents("role_permissions").values()))
        user = client.documents("users")["demo-acme-field_inspector"]
        audit_log = next(iter(client.documents("audit_logs").values()))

        assert set(company) == {
            "id",
            "name",
            "status",
            "subscription_tier",
            "created_at",
            "updated_at",
            "created_by",
        }
        assert set(permission) == {
            "id",
            "key",
            "group",
            "description",
            "created_at",
            "updated_at",
        }
        assert set(role) == {
            "id",
            "company_id",
            "key",
            "name",
            "description",
            "is_system",
            "created_at",
            "updated_at",
            "created_by",
        }
        assert set(mapping) == {
            "id",
            "company_id",
            "role_id",
            "permission_id",
            "created_at",
            "updated_at",
            "created_by",
        }
        assert set(user) == {
            "id",
            "company_id",
            "email",
            "display_name",
            "role_id",
            "status",
            "created_at",
            "updated_at",
            "created_by",
        }
        assert set(audit_log) == {
            "id",
            "company_id",
            "actor_uid",
            "action",
            "target_type",
            "target_id",
            "metadata",
            "created_at",
        }
        assert "company_id" not in company
        assert "company_id" not in permission
        assert "created_by" not in permission
        assert "updated_at" not in audit_log
        assert "created_by" not in audit_log

    asyncio.run(scenario())


def test_company_a_query_never_returns_company_b_documents() -> None:
    async def scenario() -> None:
        client = FakeAsyncClient()
        await run_seed(client)  # type: ignore[arg-type]
        users = UserRepository(client)  # type: ignore[arg-type]
        roles = RoleRepository(client)  # type: ignore[arg-type]
        acme = CompanyScope(company_id=ACME_COMPANY_ID)
        second = CompanyScope(company_id=SECOND_COMPANY_ID)

        acme_users = await users.list(acme)
        second_users = await users.list(second)
        assert len(acme_users) == 7
        assert len(second_users) == 1
        assert all(user.company_id == ACME_COMPANY_ID for user in acme_users)
        assert all(user.company_id == SECOND_COMPANY_ID for user in second_users)
        assert await users.get(acme, "demo-beta-company-admin") is None
        assert await users.get(second, "demo-acme-super_admin") is None
        assert all(role.company_id == ACME_COMPANY_ID for role in await roles.list(acme))
        assert all(
            role.company_id == SECOND_COMPANY_ID for role in await roles.list(second)
        )

    asyncio.run(scenario())


def test_each_system_role_resolves_to_exact_immutable_permission_set() -> None:
    async def scenario() -> None:
        client = FakeAsyncClient()
        await run_seed(client)  # type: ignore[arg-type]
        resolver = PermissionResolver(
            UserRepository(client),  # type: ignore[arg-type]
            RoleRepository(client),  # type: ignore[arg-type]
            RolePermissionRepository(client),  # type: ignore[arg-type]
            PermissionRepository(client),  # type: ignore[arg-type]
        )
        scope = CompanyScope(company_id=ACME_COMPANY_ID)

        assert set(SYSTEM_ROLE_TEMPLATES) == set(EXPECTED_ROLE_PERMISSIONS)
        for role_key, expected_permissions in EXPECTED_ROLE_PERMISSIONS.items():
            resolved = await resolver.resolve_for_user(
                scope,
                f"demo-acme-{role_key}",
            )
            assert isinstance(resolved, frozenset)
            assert resolved == expected_permissions
            assert SYSTEM_ROLE_TEMPLATES[role_key].permission_keys == expected_permissions

    asyncio.run(scenario())
