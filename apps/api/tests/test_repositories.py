import asyncio

from app.audit.service import AuditService
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.models.entities import (
    AuditEvent,
    CompanyCreate,
    CompanyUpdate,
    PermissionCreate,
    PermissionUpdate,
    RoleCreate,
    RolePermissionCreate,
    RolePermissionUpdate,
    RoleUpdate,
    UserCreate,
    UserUpdate,
)
from tests.fakes.firestore import FakeAsyncClient

ACTOR = "test-actor"


def test_repository_crud_round_trips() -> None:
    async def scenario() -> None:
        client = FakeAsyncClient()
        scope = CompanyScope(company_id="company-a")

        companies = CompanyRepository(client)  # type: ignore[arg-type]
        created_company = await companies.create(
            CompanyCreate(
                id=scope.company_id,
                name="Company A",
                status="active",
                subscription_tier="demo",
            ),
            ACTOR,
        )
        assert await companies.get(scope) == created_company
        updated_company = await companies.update(
            scope, CompanyUpdate(name="Company A Updated"), ACTOR
        )
        assert updated_company.name == "Company A Updated"

        permissions = PermissionRepository(client)  # type: ignore[arg-type]
        created_permission = await permissions.create(
            PermissionCreate(
                id="assets.read",
                key="assets.read",
                group="assets",
                description="Read assets",
            )
        )
        assert await permissions.get(created_permission.id) == created_permission
        updated_permission = await permissions.update(
            created_permission.id,
            PermissionUpdate(description="View assets"),
        )
        assert updated_permission.description == "View assets"
        assert len(await permissions.list()) == 1

        roles = RoleRepository(client)  # type: ignore[arg-type]
        created_role = await roles.create(
            scope,
            RoleCreate(
                id="company-a__inspector",
                key="inspector",
                name="Inspector",
                description="Inspects",
                is_system=False,
            ),
            ACTOR,
        )
        assert await roles.get(scope, created_role.id) == created_role
        updated_role = await roles.update(
            scope,
            created_role.id,
            RoleUpdate(description="Field inspector"),
            ACTOR,
        )
        assert updated_role.description == "Field inspector"

        users = UserRepository(client)  # type: ignore[arg-type]
        created_user = await users.create(
            scope,
            UserCreate(
                id="firebase-uid-a",
                email="a@example.invalid",
                display_name="User A",
                role_id=created_role.id,
                status="active",
            ),
            ACTOR,
        )
        assert await users.get(scope, created_user.id) == created_user
        updated_user = await users.update(
            scope,
            created_user.id,
            UserUpdate(display_name="Updated User A"),
            ACTOR,
        )
        assert updated_user.display_name == "Updated User A"

        mappings = RolePermissionRepository(client)  # type: ignore[arg-type]
        created_mapping = await mappings.create(
            scope,
            RolePermissionCreate(
                id="mapping-a",
                role_id=created_role.id,
                permission_id=created_permission.id,
            ),
            ACTOR,
        )
        assert await mappings.get(scope, created_mapping.id) == created_mapping
        updated_mapping = await mappings.update(
            scope,
            created_mapping.id,
            RolePermissionUpdate(permission_id="assets.write"),
            ACTOR,
        )
        assert updated_mapping.permission_id == "assets.write"

        audit_logs = AuditLogRepository(client)  # type: ignore[arg-type]
        audit_log = await audit_logs.append(
            scope,
            AuditEvent(
                company_id=scope.company_id,
                actor_uid=ACTOR,
                action="test.created",
                target_type="test",
                target_id="target-a",
                metadata={"source": "test"},
            ),
            event_id="audit-a",
        )
        assert await audit_logs.get(scope, audit_log.id) == audit_log
        assert await audit_logs.list(scope) == [audit_log]

        await mappings.delete(scope, created_mapping.id, ACTOR)
        await users.delete(scope, created_user.id, ACTOR)
        await roles.delete(scope, created_role.id, ACTOR)
        await permissions.delete(created_permission.id)
        await companies.delete(scope, ACTOR)
        assert await mappings.get(scope, created_mapping.id) is None
        assert await users.get(scope, created_user.id) is None
        assert await roles.get(scope, created_role.id) is None
        assert await permissions.get(created_permission.id) is None
        assert await companies.get(scope) is None

    asyncio.run(scenario())


def test_mutation_writes_correctly_shaped_audit_log() -> None:
    async def scenario() -> None:
        client = FakeAsyncClient()
        scope = CompanyScope(company_id="company-a")
        audit_repository = AuditLogRepository(client)  # type: ignore[arg-type]
        users = UserRepository(  # type: ignore[arg-type]
            client,
            AuditService(audit_repository),
        )

        await users.create(
            scope,
            UserCreate(
                id="firebase-uid-a",
                email="a@example.invalid",
                display_name="User A",
                role_id="role-a",
                status="active",
            ),
            ACTOR,
        )

        logs = await audit_repository.list(scope)
        assert len(logs) == 1
        log = logs[0]
        assert log.company_id == scope.company_id
        assert log.actor_uid == ACTOR
        assert log.action == "user.created"
        assert log.target_type == "user"
        assert log.target_id == "firebase-uid-a"
        assert "after" in log.metadata
        assert set(log.model_dump()) == {
            "id",
            "company_id",
            "actor_uid",
            "action",
            "target_type",
            "target_id",
            "metadata",
            "created_at",
        }

    asyncio.run(scenario())
