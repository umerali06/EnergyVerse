import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.claims import ClaimsService
from app.auth.dependencies import get_current_user
from app.auth.provisioning import UserProvisioningService
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope, utc_now
from app.models.entities import User, UserUpdate
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.rbac.service import PermissionResolver
from app.roles.service import RoleManagementService, get_role_management_service
from app.users.service import UserManagementService, get_user_management_service
from scripts.seed import ACME_COMPANY_ID, role_id, run_seed
from tests.fakes.auth import FakeAuthAdmin, FakeAuthUser
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    auth_admin = FakeAuthAdmin(
        users={
            f"demo-acme-{role_key}": FakeAuthUser(
                uid=f"demo-acme-{role_key}",
                email=f"{role_key}@acme.example.invalid",
                custom_claims={"company_id": ACME_COMPANY_ID},
            )
            for role_key in SYSTEM_ROLE_TEMPLATES
        }
    )

    audit = AuditService(AuditLogRepository(client))
    users = UserRepository(client, audit)
    roles = RoleRepository(client, audit)
    role_permissions = RolePermissionRepository(client, audit)
    permissions = PermissionRepository(client)
    claims = ClaimsService(auth_admin, users, roles)
    provisioner = UserProvisioningService(
        admin=auth_admin, users=users, roles=roles, audit=audit, claims=claims
    )
    resolver = PermissionResolver(users, roles, role_permissions, permissions)
    user_service = UserManagementService(
        users=users,
        roles=roles,
        claims=claims,
        provisioner=provisioner,
        resolver=resolver,
    )
    role_service = RoleManagementService(
        roles=roles,
        role_permissions=role_permissions,
        permissions=permissions,
        users=users,
        claims=claims,
        audit=audit,
    )

    app.dependency_overrides[get_user_management_service] = lambda: user_service
    app.dependency_overrides[get_role_management_service] = lambda: role_service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "auth_admin": auth_admin, "users": users, "audit": audit}
    app.dependency_overrides.pop(get_user_management_service, None)
    app.dependency_overrides.pop(get_role_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-admin",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"roles.manage"}),
) -> Any:
    from app.models.entities import CurrentUser

    return CurrentUser(
        uid=uid,
        email=f"{uid}@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom_admin",
        permissions=permissions,
    )


def _request(identity: Any, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _insert_user(
    client: FakeAsyncClient,
    *,
    user_id: str,
    company_id: str,
    email: str,
    display_name: str,
    role_id_value: str,
    status: str = "active",
) -> None:
    now = utc_now()
    user = User(
        id=user_id,
        company_id=company_id,
        email=email,
        display_name=display_name,
        role_id=role_id_value,
        status=status,
        created_at=now,
        updated_at=now,
        created_by="test",
    )
    client._store.setdefault("users", {})[user_id] = user.model_dump()


def _register_auth_user(auth_admin: FakeAuthAdmin, *, user_id: str, company_id: str) -> None:
    auth_admin.users[user_id] = FakeAuthUser(
        uid=user_id,
        email=f"{user_id}@acme.example.invalid",
        custom_claims={"company_id": company_id},
    )


def _create_role(
    identity: Any,
    *,
    name: str,
    description: str = "",
    permission_keys: list[str] | None = None,
    clone_from_role_id: str | None = None,
) -> Any:
    payload: dict[str, Any] = {"name": name, "description": description}
    if permission_keys is not None:
        payload["permission_keys"] = permission_keys
    if clone_from_role_id is not None:
        payload["clone_from_role_id"] = clone_from_role_id
    return _request(identity, "POST", "/api/v1/roles", json=payload)


# --- list / detail -----------------------------------------------------------


def test_list_roles_excludes_super_admin_and_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/roles")
    assert response.status_code == 200
    keys = {role["key"] for role in response.json()["items"]}
    assert keys == set(SYSTEM_ROLE_TEMPLATES) - {"super_admin"}

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/roles")
    assert beta.status_code == 200
    assert {role["key"] for role in beta.json()["items"]} == {"company_admin"}


def test_list_roles_accepts_users_manage_or_roles_manage(wiring: dict[str, Any]) -> None:
    via_users_manage = _request(
        _identity(permissions=frozenset({"users.manage"})), "GET", "/api/v1/roles"
    )
    assert via_users_manage.status_code == 200

    via_roles_manage = _request(
        _identity(permissions=frozenset({"roles.manage"})), "GET", "/api/v1/roles"
    )
    assert via_roles_manage.status_code == 200

    neither = _request(
        _identity(permissions=frozenset({"reports.read"})), "GET", "/api/v1/roles"
    )
    assert neither.status_code == 403


def test_list_roles_reports_permission_and_user_counts(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/roles")
    assert response.status_code == 200
    company_admin = next(
        role for role in response.json()["items"] if role["key"] == "company_admin"
    )
    assert company_admin["permission_count"] == len(
        SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys
    )
    assert company_admin["assigned_user_count"] == 1


def test_get_role_requires_roles_manage_not_just_users_manage(wiring: dict[str, Any]) -> None:
    admin_role_id = role_id(ACME_COMPANY_ID, "company_admin")
    response = _request(
        _identity(permissions=frozenset({"users.manage"})),
        "GET",
        f"/api/v1/roles/{admin_role_id}",
    )
    assert response.status_code == 403


def test_get_role_returns_full_permission_set(wiring: dict[str, Any]) -> None:
    hse_role_id = role_id(ACME_COMPANY_ID, "hse_manager")
    response = _request(_identity(), "GET", f"/api/v1/roles/{hse_role_id}")
    assert response.status_code == 200
    body = response.json()
    assert set(body["permission_keys"]) == set(
        SYSTEM_ROLE_TEMPLATES["hse_manager"].permission_keys
    )
    assert body["is_system"] is True
    assert body["assigned_user_count"] == 1


def test_get_role_hides_super_admin_and_cross_tenant_roles(wiring: dict[str, Any]) -> None:
    super_admin_role_id = role_id(ACME_COMPANY_ID, "super_admin")
    hidden = _request(_identity(), "GET", f"/api/v1/roles/{super_admin_role_id}")
    assert hidden.status_code == 404
    assert hidden.json()["error"] == "role_not_found"

    beta_admin_role_id = role_id(BETA_COMPANY_ID, "company_admin")
    cross_tenant = _request(_identity(), "GET", f"/api/v1/roles/{beta_admin_role_id}")
    assert cross_tenant.status_code == 404
    assert cross_tenant.json()["error"] == "role_not_found"


# --- create --------------------------------------------------------------


def test_create_role_requires_roles_manage(wiring: dict[str, Any]) -> None:
    response = _create_role(
        _identity(permissions=frozenset({"users.manage"})),
        name="HR Manager",
        permission_keys=["users.manage"],
    )
    assert response.status_code == 403


def test_create_role_rejects_unknown_permission_key(wiring: dict[str, Any]) -> None:
    response = _create_role(
        _identity(), name="Bogus Role", permission_keys=["not.a.real.permission"]
    )
    assert response.status_code == 422
    assert response.json()["error"] == "unknown_permission_key"


def test_create_role_rejects_platform_admin(wiring: dict[str, Any]) -> None:
    response = _create_role(
        _identity(), name="Sneaky Super", permission_keys=["platform.admin"]
    )
    assert response.status_code == 403
    assert response.json()["error"] == "platform_admin_not_grantable"


def test_create_role_rejects_duplicate_name_case_insensitive(wiring: dict[str, Any]) -> None:
    response = _create_role(_identity(), name="company admin", permission_keys=[])
    assert response.status_code == 409
    assert response.json()["error"] == "role_name_in_use"


def test_create_role_succeeds_and_is_not_system(wiring: dict[str, Any]) -> None:
    response = _create_role(
        _identity(),
        name="HR Manager",
        description="Handles onboarding paperwork",
        permission_keys=["users.manage", "reports.read"],
    )
    assert response.status_code == 201
    body = response.json()
    assert body["is_system"] is False
    assert set(body["permission_keys"]) == {"users.manage", "reports.read"}
    assert body["assigned_user_count"] == 0


def test_create_role_clone_copies_source_permission_set_exactly(wiring: dict[str, Any]) -> None:
    source = _create_role(
        _identity(),
        name="Template Role",
        permission_keys=["assets.read", "assets.write", "reports.read"],
    )
    assert source.status_code == 201
    source_id = source.json()["id"]

    cloned = _create_role(
        _identity(),
        name="Cloned Role",
        clone_from_role_id=source_id,
    )
    assert cloned.status_code == 201
    assert set(cloned.json()["permission_keys"]) == {
        "assets.read",
        "assets.write",
        "reports.read",
    }


# --- update ----------------------------------------------------------------


def test_update_system_role_is_rejected(wiring: dict[str, Any]) -> None:
    admin_role_id = role_id(ACME_COMPANY_ID, "company_admin")
    response = _request(
        _identity(), "PATCH", f"/api/v1/roles/{admin_role_id}", json={"name": "Renamed"}
    )
    assert response.status_code == 409
    assert response.json()["error"] == "system_role_locked"


def test_update_role_rejects_platform_admin(wiring: dict[str, Any]) -> None:
    created = _create_role(_identity(), name="Ops Role", permission_keys=["assets.read"])
    role_id_value = created.json()["id"]
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{role_id_value}",
        json={"permission_keys": ["assets.read", "platform.admin"]},
    )
    assert response.status_code == 403
    assert response.json()["error"] == "platform_admin_not_grantable"


def test_update_role_rejects_duplicate_name(wiring: dict[str, Any]) -> None:
    _create_role(_identity(), name="Role One", permission_keys=[])
    second = _create_role(_identity(), name="Role Two", permission_keys=[])
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{second.json()['id']}",
        json={"name": "role one"},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "role_name_in_use"


def test_update_role_permission_diff_writes_audit_entry(wiring: dict[str, Any]) -> None:
    client: FakeAsyncClient = wiring["client"]
    created = _create_role(_identity(), name="Field Role", permission_keys=["assets.read"])
    role_id_value = created.json()["id"]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{role_id_value}",
        json={"permission_keys": ["assets.read", "assets.write"]},
    )
    assert response.status_code == 200
    assert set(response.json()["permission_keys"]) == {"assets.read", "assets.write"}

    audits = asyncio.run(
        AuditLogRepository(client).list(CompanyScope(company_id=ACME_COMPANY_ID))
    )
    entry = next(
        log
        for log in audits
        if log.action == "role.permissions_updated" and log.target_id == role_id_value
    )
    assert entry.metadata["before"] == ["assets.read"]
    assert set(entry.metadata["after"]) == {"assets.read", "assets.write"}
    assert entry.metadata["added"] == ["assets.write"]
    assert entry.metadata["removed"] == []


def test_update_role_syncs_claims_for_all_current_holders(wiring: dict[str, Any]) -> None:
    client: FakeAsyncClient = wiring["client"]
    auth_admin: FakeAuthAdmin = wiring["auth_admin"]
    created = _create_role(_identity(), name="Field Crew", permission_keys=["assets.read"])
    role_id_value = created.json()["id"]

    for holder_id in ("holder-one", "holder-two"):
        _insert_user(
            client,
            user_id=holder_id,
            company_id=ACME_COMPANY_ID,
            email=f"{holder_id}@acme.example.invalid",
            display_name=holder_id,
            role_id_value=role_id_value,
        )
        _register_auth_user(auth_admin, user_id=holder_id, company_id=ACME_COMPANY_ID)

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{role_id_value}",
        json={"permission_keys": ["assets.read", "reports.read"]},
    )
    assert response.status_code == 200

    for holder_id in ("holder-one", "holder-two"):
        auth_user = asyncio.run(auth_admin.get_user(holder_id))
        assert auth_user.custom_claims == {
            "company_id": ACME_COMPANY_ID,
            "role_id": role_id_value,
            "role_key": role_id_value,
        }


def test_removing_users_manage_blocked_when_it_would_leave_zero_active_holders(
    wiring: dict[str, Any],
) -> None:
    client: FakeAsyncClient = wiring["client"]
    auth_admin: FakeAuthAdmin = wiring["auth_admin"]

    # Move every seeded holder of users.manage (company_admin, super_admin) out of
    # the way so the custom role becomes the sole active holder.
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    for holder in ("demo-acme-company_admin", "demo-acme-super_admin"):
        asyncio.run(
            UserRepository(client).update(scope, holder, UserUpdate(status="inactive"), "test")
        )

    created = _create_role(_identity(), name="HR Only", permission_keys=["users.manage"])
    role_id_value = created.json()["id"]
    _insert_user(
        client,
        user_id="hr-holder",
        company_id=ACME_COMPANY_ID,
        email="hr-holder@acme.example.invalid",
        display_name="HR Holder",
        role_id_value=role_id_value,
    )
    _register_auth_user(auth_admin, user_id="hr-holder", company_id=ACME_COMPANY_ID)

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{role_id_value}",
        json={"permission_keys": ["reports.read"]},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "last_holder_of_users_manage"


def test_removing_users_manage_allowed_when_another_holder_remains(
    wiring: dict[str, Any],
) -> None:
    client: FakeAsyncClient = wiring["client"]
    auth_admin: FakeAuthAdmin = wiring["auth_admin"]
    # The seeded active Company Admin remains a holder, so removing users.manage
    # from a second role is allowed.
    created = _create_role(_identity(), name="HR Backup", permission_keys=["users.manage"])
    role_id_value = created.json()["id"]
    _insert_user(
        client,
        user_id="hr-backup-holder",
        company_id=ACME_COMPANY_ID,
        email="hr-backup@acme.example.invalid",
        display_name="HR Backup Holder",
        role_id_value=role_id_value,
    )
    _register_auth_user(auth_admin, user_id="hr-backup-holder", company_id=ACME_COMPANY_ID)

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/roles/{role_id_value}",
        json={"permission_keys": ["reports.read"]},
    )
    assert response.status_code == 200
    assert "users.manage" not in response.json()["permission_keys"]


# --- delete ------------------------------------------------------------------


def test_delete_system_role_is_rejected(wiring: dict[str, Any]) -> None:
    admin_role_id = role_id(ACME_COMPANY_ID, "company_admin")
    response = _request(_identity(), "DELETE", f"/api/v1/roles/{admin_role_id}")
    assert response.status_code == 409
    assert response.json()["error"] == "system_role_locked"


def test_delete_role_blocked_when_users_assigned(wiring: dict[str, Any]) -> None:
    client: FakeAsyncClient = wiring["client"]
    created = _create_role(_identity(), name="Occupied Role", permission_keys=[])
    role_id_value = created.json()["id"]
    _insert_user(
        client,
        user_id="occupant",
        company_id=ACME_COMPANY_ID,
        email="occupant@acme.example.invalid",
        display_name="Occupant",
        role_id_value=role_id_value,
    )

    response = _request(_identity(), "DELETE", f"/api/v1/roles/{role_id_value}")
    assert response.status_code == 409
    body = response.json()
    assert body["error"] == "role_has_assigned_users"
    assert body["details"]["assigned_user_count"] == 1


def test_delete_role_succeeds_when_unassigned(wiring: dict[str, Any]) -> None:
    created = _create_role(_identity(), name="Empty Role", permission_keys=["assets.read"])
    role_id_value = created.json()["id"]

    response = _request(_identity(), "DELETE", f"/api/v1/roles/{role_id_value}")
    assert response.status_code == 200
    assert response.json() == {"id": role_id_value, "deleted": True}

    follow_up = _request(_identity(), "GET", f"/api/v1/roles/{role_id_value}")
    assert follow_up.status_code == 404


# --- permission catalog ------------------------------------------------------


def test_permission_catalog_is_grouped_and_gated_by_roles_manage(
    wiring: dict[str, Any],
) -> None:
    denied = _request(
        _identity(permissions=frozenset({"users.manage"})), "GET", "/api/v1/permissions"
    )
    assert denied.status_code == 403

    response = _request(_identity(), "GET", "/api/v1/permissions")
    assert response.status_code == 200
    groups = {group["group"] for group in response.json()["groups"]}
    assert "users" in groups
    assert "roles" in groups
    users_group = next(g for g in response.json()["groups"] if g["group"] == "users")
    assert any(item["key"] == "users.manage" for item in users_group["items"])
