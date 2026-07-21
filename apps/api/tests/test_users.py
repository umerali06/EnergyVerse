import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

import app.api.v1.roles as roles_module
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
from app.models.entities import CurrentUser, User, UserUpdate
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.rbac.service import PermissionResolver
from app.users.service import UserManagementService, get_user_management_service
from scripts.seed import ACME_COMPANY_ID, role_id, run_seed
from tests.fakes.auth import FakeAuthAdmin, FakeAuthUser
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring(monkeypatch: pytest.MonkeyPatch) -> dict[str, Any]:
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
    service = UserManagementService(
        users=users,
        roles=roles,
        claims=claims,
        provisioner=provisioner,
        resolver=resolver,
    )

    monkeypatch.setattr(roles_module, "RoleRepository", lambda: RoleRepository(client))
    app.dependency_overrides[get_user_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "auth_admin": auth_admin, "users": users, "audit": audit}
    app.dependency_overrides.pop(get_user_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-admin",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"users.manage"}),
    email_verified: bool = True,
) -> CurrentUser:
    return CurrentUser(
        uid=uid,
        email=f"{uid}@example.invalid",
        email_verified=email_verified,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom_admin",
        permissions=permissions,
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
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


def test_list_requires_users_manage(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"reports.read"})), "GET", "/api/v1/users"
    )
    assert response.status_code == 403
    assert response.json()["error"] == "forbidden"


def test_list_returns_real_tenant_users_with_role_fields(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/users?limit=50")
    assert response.status_code == 200
    body = response.json()
    assert len(body["items"]) == 7
    inspector = next(
        item for item in body["items"] if item["id"] == "demo-acme-field_inspector"
    )
    assert inspector["email"] == "field_inspector@acme.example.invalid"
    assert inspector["role_key"] == "field_inspector"
    assert inspector["role_name"] == "Field Inspector"
    assert inspector["status"] == "active"


def test_tenants_are_isolated_on_list_and_get(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/users?limit=50"
    )
    assert response.status_code == 200
    ids = {item["id"] for item in response.json()["items"]}
    assert ids == {"demo-beta-company-admin"}

    cross_tenant = _request(
        _identity(company_id=BETA_COMPANY_ID),
        "GET",
        "/api/v1/users/demo-acme-field_inspector",
    )
    assert cross_tenant.status_code == 404
    assert cross_tenant.json()["error"] == "user_not_found"


def test_get_user_returns_effective_permissions(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "GET", "/api/v1/users/demo-acme-hse_manager"
    )
    assert response.status_code == 200
    body = response.json()
    assert set(body["permissions"]) == set(
        SYSTEM_ROLE_TEMPLATES["hse_manager"].permission_keys
    )


def test_search_matches_name_or_email(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/users?search=hse")
    assert response.status_code == 200
    items = response.json()["items"]
    assert {item["id"] for item in items} == {"demo-acme-hse_manager"}


def test_role_and_status_filters(wiring: dict[str, Any], monkeypatch: pytest.MonkeyPatch) -> None:
    client: FakeAsyncClient = wiring["client"]
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    asyncio.run(
        UserRepository(client).update(
            scope,
            "demo-acme-executive",
            UserUpdate(status="inactive"),
            "test",
        )
    )
    inspector_role_id = role_id(ACME_COMPANY_ID, "field_inspector")

    by_role = _request(
        _identity(), "GET", f"/api/v1/users?role_id={inspector_role_id}"
    )
    assert {item["id"] for item in by_role.json()["items"]} == {
        "demo-acme-field_inspector"
    }

    by_status = _request(_identity(), "GET", "/api/v1/users?status=inactive")
    assert {item["id"] for item in by_status.json()["items"]} == {
        "demo-acme-executive"
    }


def test_pagination_cursor_walks_without_overlap(wiring: dict[str, Any]) -> None:
    client: FakeAsyncClient = wiring["client"]
    exec_role_id = role_id(ACME_COMPANY_ID, "executive")
    for index in range(20):
        _insert_user(
            client,
            user_id=f"extra-user-{index:02d}",
            company_id=ACME_COMPANY_ID,
            email=f"extra{index:02d}@acme.example.invalid",
            display_name=f"Extra User {index:02d}",
            role_id_value=exec_role_id,
        )
    identity = _identity()
    seen: list[str] = []
    cursor: str | None = None
    for _ in range(5):
        path = "/api/v1/users?limit=10&sort=name"
        if cursor:
            path += f"&cursor={cursor}"
        response = _request(identity, "GET", path)
        assert response.status_code == 200
        body = response.json()
        seen.extend(item["id"] for item in body["items"])
        cursor = body["next_cursor"]
        if cursor is None:
            break
    assert len(seen) == 27  # 7 seeded + 20 extra
    assert len(set(seen)) == 27
    assert cursor is None


def test_invalid_cursor_is_rejected(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/users?cursor=not-valid-base64!!")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_cursor"


def test_invalid_sort_is_rejected(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/users?sort=bogus")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_sort"


def test_invite_creates_auth_user_firestore_doc_claims_and_audit(
    wiring: dict[str, Any],
) -> None:
    client: FakeAsyncClient = wiring["client"]
    auth_admin: FakeAuthAdmin = wiring["auth_admin"]
    exec_role_id = role_id(ACME_COMPANY_ID, "executive")
    response = _request(
        _identity(),
        "POST",
        "/api/v1/users/invite",
        json={
            "email": "New.Hire@Acme.example.invalid",
            "display_name": "New Hire",
            "role_id": exec_role_id,
        },
    )
    assert response.status_code == 201
    body = response.json()
    assert body["email"] == "new.hire@acme.example.invalid"
    assert body["role_key"] == "executive"

    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    stored = asyncio.run(UserRepository(client).get(scope, body["id"]))
    assert stored is not None
    assert stored.status == "active"

    auth_user = asyncio.run(auth_admin.get_user(body["id"]))
    assert auth_user.custom_claims == {
        "company_id": ACME_COMPANY_ID,
        "role_id": exec_role_id,
        "role_key": "executive",
    }

    audits = asyncio.run(AuditLogRepository(client).list(scope))
    assert any(
        entry.action == "user.provisioned" and entry.target_id == body["id"]
        for entry in audits
    )


def test_duplicate_invite_is_conflict(wiring: dict[str, Any]) -> None:
    exec_role_id = role_id(ACME_COMPANY_ID, "executive")
    payload = {
        "email": "dup@acme.example.invalid",
        "display_name": "Dup User",
        "role_id": exec_role_id,
    }
    first = _request(_identity(), "POST", "/api/v1/users/invite", json=payload)
    assert first.status_code == 201
    second = _request(_identity(), "POST", "/api/v1/users/invite", json=payload)
    assert second.status_code == 409
    assert second.json()["error"] == "email_already_in_use"


def test_invite_rejects_foreign_company_role(wiring: dict[str, Any]) -> None:
    beta_admin_role_id = role_id(BETA_COMPANY_ID, "company_admin")
    response = _request(
        _identity(),
        "POST",
        "/api/v1/users/invite",
        json={
            "email": "cross-tenant@acme.example.invalid",
            "display_name": "Cross Tenant",
            "role_id": beta_admin_role_id,
        },
    )
    assert response.status_code == 404
    assert response.json()["error"] == "role_not_found"


def test_invite_rejects_super_admin_role(wiring: dict[str, Any]) -> None:
    super_admin_role_id = role_id(ACME_COMPANY_ID, "super_admin")
    response = _request(
        _identity(),
        "POST",
        "/api/v1/users/invite",
        json={
            "email": "wannabe-super@acme.example.invalid",
            "display_name": "Wannabe Super",
            "role_id": super_admin_role_id,
        },
    )
    assert response.status_code == 422
    assert response.json()["error"] == "role_not_assignable"


def test_role_change_syncs_claims(wiring: dict[str, Any]) -> None:
    auth_admin: FakeAuthAdmin = wiring["auth_admin"]
    hse_role_id = role_id(ACME_COMPANY_ID, "hse_manager")
    response = _request(
        _identity(),
        "PATCH",
        "/api/v1/users/demo-acme-field_inspector",
        json={"role_id": hse_role_id},
    )
    assert response.status_code == 200
    assert response.json()["role_key"] == "hse_manager"
    auth_user = asyncio.run(auth_admin.get_user("demo-acme-field_inspector"))
    assert auth_user.custom_claims == {
        "company_id": ACME_COMPANY_ID,
        "role_id": hse_role_id,
        "role_key": "hse_manager",
    }


def test_update_rejects_super_admin_role(wiring: dict[str, Any]) -> None:
    super_admin_role_id = role_id(ACME_COMPANY_ID, "super_admin")
    response = _request(
        _identity(),
        "PATCH",
        "/api/v1/users/demo-acme-field_inspector",
        json={"role_id": super_admin_role_id},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "role_not_assignable"


def test_cannot_deactivate_self(wiring: dict[str, Any]) -> None:
    identity = _identity(uid="demo-acme-company_admin")
    response = _request(
        identity,
        "PATCH",
        "/api/v1/users/demo-acme-company_admin/status",
        json={"status": "inactive"},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "cannot_modify_self"


def test_cannot_demote_self_out_of_admin_when_another_admin_exists(
    wiring: dict[str, Any],
) -> None:
    client: FakeAsyncClient = wiring["client"]
    admin_role_id = role_id(ACME_COMPANY_ID, "company_admin")
    _insert_user(
        client,
        user_id="second-admin",
        company_id=ACME_COMPANY_ID,
        email="second-admin@acme.example.invalid",
        display_name="Second Admin",
        role_id_value=admin_role_id,
    )
    exec_role_id = role_id(ACME_COMPANY_ID, "executive")
    identity = _identity(uid="demo-acme-company_admin")
    response = _request(
        identity,
        "PATCH",
        "/api/v1/users/demo-acme-company_admin",
        json={"role_id": exec_role_id},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "cannot_demote_self"


def test_last_remaining_admin_cannot_be_deactivated(wiring: dict[str, Any]) -> None:
    actor = _identity(uid="demo-acme-super_admin")
    response = _request(
        actor,
        "PATCH",
        "/api/v1/users/demo-acme-company_admin/status",
        json={"status": "inactive"},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "last_admin_protected"


def test_last_remaining_admin_cannot_be_demoted(wiring: dict[str, Any]) -> None:
    actor = _identity(uid="demo-acme-super_admin")
    exec_role_id = role_id(ACME_COMPANY_ID, "executive")
    response = _request(
        actor,
        "PATCH",
        "/api/v1/users/demo-acme-company_admin",
        json={"role_id": exec_role_id},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "last_admin_protected"


def test_second_admin_can_deactivate_first_admin(wiring: dict[str, Any]) -> None:
    """Confirms last-admin protection is count-based, not an absolute lock."""
    client: FakeAsyncClient = wiring["client"]
    admin_role_id = role_id(ACME_COMPANY_ID, "company_admin")
    _insert_user(
        client,
        user_id="second-admin",
        company_id=ACME_COMPANY_ID,
        email="second-admin@acme.example.invalid",
        display_name="Second Admin",
        role_id_value=admin_role_id,
    )
    actor = _identity(uid="second-admin")
    response = _request(
        actor,
        "PATCH",
        "/api/v1/users/demo-acme-company_admin/status",
        json={"status": "inactive"},
    )
    assert response.status_code == 200
    assert response.json()["status"] == "inactive"


def test_get_user_not_found_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/users/does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "user_not_found"


def test_list_roles_excludes_super_admin_and_is_tenant_scoped(
    wiring: dict[str, Any],
) -> None:
    response = _request(_identity(), "GET", "/api/v1/roles")
    assert response.status_code == 200
    keys = {role["key"] for role in response.json()["items"]}
    assert keys == set(SYSTEM_ROLE_TEMPLATES) - {"super_admin"}

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/roles")
    assert beta.status_code == 200
    assert {role["key"] for role in beta.json()["items"]} == {"company_admin"}


def test_list_roles_requires_users_manage(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"reports.read"})), "GET", "/api/v1/roles"
    )
    assert response.status_code == 403
