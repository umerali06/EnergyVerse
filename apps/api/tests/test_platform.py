import asyncio
from collections.abc import Mapping
from typing import Any

import pytest
from fastapi.testclient import TestClient

import app.auth.dependencies as auth_dependencies
from app.admin.service import (
    PLATFORM_AUDIT_COMPANY_ID,
    AdminCompanyService,
    get_admin_company_service,
)
from app.audit.service import AuditService
from app.auth.claims import ClaimsService
from app.auth.dependencies import get_current_user
from app.auth.provisioning import UserProvisioningService
from app.auth.verifier import TokenVerificationError, TokenVerifier, get_token_verifier
from app.company.service import CompanyProfileService, get_company_profile_service
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import AdminScope, CompanyScope
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.rbac.service import PermissionResolver
from app.storage.service import CompanyLogoStorage
from app.users.service import UserManagementService, get_user_management_service
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.auth import FakeAuthAdmin
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.storage import FakeBucket

BETA_COMPANY_ID = "beta-utilities"


class StaticTokenVerifier:
    def __init__(
        self,
        decoded: Mapping[str, Any] | None = None,
        error: TokenVerificationError | None = None,
    ) -> None:
        self._decoded = decoded or {}
        self._error = error

    async def verify(self, token: str) -> Mapping[str, Any]:
        assert token
        if self._error is not None:
            raise self._error
        return self._decoded


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    users = UserRepository(client, audit)
    roles = RoleRepository(client, audit)
    companies_for_admin = CompanyRepository(client, audit=None)
    service = AdminCompanyService(
        companies=companies_for_admin,
        users=UserRepository(client),
        roles=RoleRepository(client),
        audit=audit,
    )

    # Also wire the 3.1/3.3 services this test file's reverse-guard and
    # tier-persistence assertions call through (/api/v1/users, /api/v1/company)
    # against the SAME fake client, so cross-tenant assertions are meaningful.
    auth_admin = FakeAuthAdmin(users={})
    claims = ClaimsService(auth_admin, users, roles)
    provisioner = UserProvisioningService(
        admin=auth_admin, users=users, roles=roles, audit=audit, claims=claims
    )
    resolver = PermissionResolver(
        users, roles, RolePermissionRepository(client), PermissionRepository(client)
    )
    user_service = UserManagementService(
        users=users,
        roles=roles,
        claims=claims,
        provisioner=provisioner,
        resolver=resolver,
    )
    company_service = CompanyProfileService(
        companies=CompanyRepository(client, audit),
        users=users,
        roles=roles,
        storage=CompanyLogoStorage(bucket=FakeBucket()),
        audit=audit,
    )

    app.dependency_overrides[get_admin_company_service] = lambda: service
    app.dependency_overrides[get_user_management_service] = lambda: user_service
    app.dependency_overrides[get_company_profile_service] = lambda: company_service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "audit": audit, "service": service}
    app.dependency_overrides.pop(get_admin_company_service, None)
    app.dependency_overrides.pop(get_user_management_service, None)
    app.dependency_overrides.pop(get_company_profile_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    role_key: str,
    permissions: frozenset[str],
    company_id: str = ACME_COMPANY_ID,
) -> CurrentUser:
    return CurrentUser(
        uid=f"test-{role_key}",
        email=f"{role_key}@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Acme Energy",
        role_key=role_key,
        permissions=permissions,
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


# --- table-driven permission gate ------------------------------------------

ROUTE_CASES: list[tuple[str, str, dict[str, Any] | None]] = [
    ("GET", "/api/v1/platform/companies", None),
    ("GET", f"/api/v1/platform/companies/{BETA_COMPANY_ID}", None),
    ("PATCH", f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status", {"status": "suspended"}),
    ("PATCH", f"/api/v1/platform/companies/{BETA_COMPANY_ID}", {"subscription_tier": "starter"}),
    ("GET", "/api/v1/platform/stats", None),
]


def test_platform_routes_require_platform_admin_table_driven(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, template.permission_keys)
        for method, path, body in ROUTE_CASES:
            response = _request(identity, method, path, json=body)
            if role_key == "super_admin":
                assert response.status_code == 200, (role_key, method, path, response.json())
            else:
                assert response.status_code == 403, (role_key, method, path)
                assert response.json()["error"] == "forbidden"


# --- cross-tenant reads ------------------------------------------------------


def test_list_platform_companies_returns_all_tenants_with_user_counts(
    wiring: dict[str, Any],
) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(identity, "GET", "/api/v1/platform/companies", params={"limit": 50})
    assert response.status_code == 200
    items = {item["id"]: item for item in response.json()["items"]}
    assert ACME_COMPANY_ID in items
    assert BETA_COMPANY_ID in items

    acme_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=ACME_COMPANY_ID))
    )
    beta_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=BETA_COMPANY_ID))
    )
    assert items[ACME_COMPANY_ID]["users_total"] == len(acme_users)
    assert items[BETA_COMPANY_ID]["users_total"] == len(beta_users)


def test_get_platform_company_not_found(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(identity, "GET", "/api/v1/platform/companies/does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "company_not_found"


def test_get_platform_stats_reports_real_counts(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(identity, "GET", "/api/v1/platform/stats")
    assert response.status_code == 200
    body = response.json()

    acme_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=ACME_COMPANY_ID))
    )
    beta_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=BETA_COMPANY_ID))
    )
    assert body["total_companies"] == 2
    assert body["total_users"] == len(acme_users) + len(beta_users)
    assert body["active_tenants"] == 2
    assert body["recent_signups"] == 2
    assert body["window_days"] == 30


# --- the explicit reverse-guard test ---------------------------------------


def test_super_admin_home_company_route_stays_tenant_scoped(wiring: dict[str, Any]) -> None:
    """A platform.admin permission must never widen the scope of existing
    company-scoped routes -- the only cross-tenant path is /api/v1/platform/*."""
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)

    company_response = _request(identity, "GET", "/api/v1/company")
    assert company_response.status_code == 200
    assert company_response.json()["name"] == "Acme Energy"

    users_response = _request(identity, "GET", "/api/v1/users", params={"limit": 100})
    assert users_response.status_code == 200
    returned_ids = {item["id"] for item in users_response.json()["items"]}

    acme_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=ACME_COMPANY_ID))
    )
    beta_users = asyncio.run(
        UserRepository(wiring["client"]).list(CompanyScope(company_id=BETA_COMPANY_ID))
    )
    assert returned_ids == {user.id for user in acme_users}
    assert returned_ids.isdisjoint({user.id for user in beta_users})


# --- suspend / reactivate / tier --------------------------------------------


def test_update_company_status_rejects_invalid_value(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status",
        json={"status": "archived"},
    )
    assert response.status_code == 422


def test_suspend_then_reactivate_round_trip(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)

    suspend = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status",
        json={"status": "suspended"},
    )
    assert suspend.status_code == 200
    assert suspend.json()["status"] == "suspended"

    repeat_suspend = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status",
        json={"status": "suspended"},
    )
    assert repeat_suspend.status_code == 409
    assert repeat_suspend.json()["error"] == "status_unchanged"

    detail = _request(identity, "GET", f"/api/v1/platform/companies/{BETA_COMPANY_ID}")
    assert detail.json()["status"] == "suspended"

    reactivate = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status",
        json={"status": "active"},
    )
    assert reactivate.status_code == 200
    assert reactivate.json()["status"] == "active"


def test_update_subscription_tier_persists(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}",
        json={"subscription_tier": "enterprise"},
    )
    assert response.status_code == 200
    assert response.json()["subscription_tier"] == "enterprise"

    detail = _request(identity, "GET", f"/api/v1/platform/companies/{BETA_COMPANY_ID}")
    assert detail.json()["subscription_tier"] == "enterprise"

    # 3.3's tenant-facing profile route reflects the same real lever.
    tenant_identity = _identity(
        "company_admin",
        SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys,
        company_id=BETA_COMPANY_ID,
    )
    company_profile = _request(tenant_identity, "GET", "/api/v1/company")
    assert company_profile.json()["subscription_tier"] == "enterprise"


def test_update_subscription_tier_rejects_unknown_value(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}",
        json={"subscription_tier": "gold"},
    )
    assert response.status_code == 422


# --- dual audit write --------------------------------------------------------


def test_cross_tenant_mutation_writes_dual_audit_entries(wiring: dict[str, Any]) -> None:
    identity = _identity("super_admin", SYSTEM_ROLE_TEMPLATES["super_admin"].permission_keys)
    response = _request(
        identity,
        "PATCH",
        f"/api/v1/platform/companies/{BETA_COMPANY_ID}/status",
        json={"status": "suspended"},
    )
    assert response.status_code == 200

    target_audits = asyncio.run(
        AuditLogRepository(wiring["client"]).list(CompanyScope(company_id=BETA_COMPANY_ID))
    )
    target_entry = next(entry for entry in target_audits if entry.action == "company.suspended")
    assert target_entry.metadata["cross_tenant"] is True
    assert target_entry.metadata["acting_company_id"] == ACME_COMPANY_ID
    assert target_entry.actor_uid == identity.uid

    platform_audits = asyncio.run(
        AuditLogRepository(wiring["client"]).list(
            CompanyScope(company_id=PLATFORM_AUDIT_COMPANY_ID)
        )
    )
    platform_entry = next(
        entry for entry in platform_audits if entry.action == "platform.company.suspended"
    )
    assert platform_entry.target_id == BETA_COMPANY_ID
    assert platform_entry.actor_uid == identity.uid


# --- suspension blocks /me through the real dependency chain ---------------


def _override_repositories(monkeypatch: pytest.MonkeyPatch, client: FakeAsyncClient) -> None:
    monkeypatch.setattr(auth_dependencies, "CompanyRepository", lambda: CompanyRepository(client))
    monkeypatch.setattr(auth_dependencies, "UserRepository", lambda: UserRepository(client))
    monkeypatch.setattr(auth_dependencies, "RoleRepository", lambda: RoleRepository(client))
    monkeypatch.setattr(
        auth_dependencies, "RolePermissionRepository", lambda: RolePermissionRepository(client)
    )
    monkeypatch.setattr(
        auth_dependencies, "PermissionRepository", lambda: PermissionRepository(client)
    )


def test_suspended_company_blocks_login_and_me(
    wiring: dict[str, Any], monkeypatch: pytest.MonkeyPatch
) -> None:
    client = wiring["client"]
    admin_scope = AdminScope(acting_uid="test-super_admin", acting_company_id=ACME_COMPANY_ID)
    asyncio.run(wiring["service"].update_status(admin_scope, BETA_COMPANY_ID, "suspended"))

    _override_repositories(monkeypatch, client)
    verifier: TokenVerifier = StaticTokenVerifier(
        {
            "uid": "demo-beta-company-admin",
            "company_id": BETA_COMPANY_ID,
            "email_verified": True,
        }
    )
    app.dependency_overrides[get_token_verifier] = lambda: verifier
    try:
        with TestClient(app) as test_client:
            blocked = test_client.get(
                "/api/v1/auth/me", headers={"Authorization": "Bearer token"}
            )
    finally:
        app.dependency_overrides.pop(get_token_verifier, None)
    assert blocked.status_code == 403
    assert blocked.json()["error"] == "company_suspended"

    asyncio.run(wiring["service"].update_status(admin_scope, BETA_COMPANY_ID, "active"))

    app.dependency_overrides[get_token_verifier] = lambda: verifier
    try:
        with TestClient(app) as test_client:
            restored = test_client.get(
                "/api/v1/auth/me", headers={"Authorization": "Bearer token"}
            )
    finally:
        app.dependency_overrides.pop(get_token_verifier, None)
    assert restored.status_code == 200
    assert restored.json()["company_id"] == BETA_COMPANY_ID
