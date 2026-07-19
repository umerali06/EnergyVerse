import asyncio
from collections.abc import Mapping
from typing import Any
from uuid import UUID

import pytest
from fastapi.testclient import TestClient

import app.auth.dependencies as auth_dependencies
from app.audit.service import AuditService
from app.auth.admin import AuthAdmin
from app.auth.claims import ClaimsService
from app.auth.provisioning import UserProvisioningService
from app.auth.verifier import TokenVerificationError, TokenVerifier, get_token_verifier
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import UserUpdate
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from scripts.seed import ACME_COMPANY_ID, role_id, run_seed
from tests.fakes.auth import FakeAuthAdmin, FakeAuthUser
from tests.fakes.firestore import FakeAsyncClient


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


def _override_repositories(
    monkeypatch: pytest.MonkeyPatch,
    client: FakeAsyncClient,
) -> None:
    monkeypatch.setattr(
        auth_dependencies,
        "CompanyRepository",
        lambda: CompanyRepository(client),
    )
    monkeypatch.setattr(
        auth_dependencies,
        "UserRepository",
        lambda: UserRepository(client),
    )
    monkeypatch.setattr(
        auth_dependencies,
        "RoleRepository",
        lambda: RoleRepository(client),
    )
    monkeypatch.setattr(
        auth_dependencies,
        "RolePermissionRepository",
        lambda: RolePermissionRepository(client),
    )
    monkeypatch.setattr(
        auth_dependencies,
        "PermissionRepository",
        lambda: PermissionRepository(client),
    )


def _request_with_verifier(verifier: TokenVerifier, token: str | None = "token") -> Any:
    app.dependency_overrides[get_token_verifier] = lambda: verifier
    headers = {"Authorization": f"Bearer {token}"} if token is not None else {}
    try:
        with TestClient(app) as client:
            return client.get("/api/v1/auth/me", headers=headers)
    finally:
        app.dependency_overrides.clear()


def test_me_missing_token_returns_401() -> None:
    response = _request_with_verifier(StaticTokenVerifier(), token=None)
    assert response.status_code == 401
    body = response.json()
    assert body["error"] == "missing_token"
    assert body["message"] == "Bearer token is required"
    assert "details" not in body
    assert UUID(body["request_id"])
    assert response.headers["X-Request-ID"] == body["request_id"]


@pytest.mark.parametrize(
    ("code", "message"),
    [
        ("invalid_token", "Token is invalid"),
        ("token_expired", "Token has expired"),
        ("token_revoked", "Token has been revoked"),
    ],
)
def test_me_bad_token_returns_401(code: str, message: str) -> None:
    response = _request_with_verifier(
        StaticTokenVerifier(error=TokenVerificationError(code, message))
    )
    assert response.status_code == 401
    body = response.json()
    assert body["error"] == code
    assert body["message"] == message
    assert UUID(body["request_id"])


def test_me_returns_seeded_identity_and_exact_permissions(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    _override_repositories(monkeypatch, firestore)
    uid = "demo-acme-field_inspector"
    response = _request_with_verifier(
        StaticTokenVerifier(
            {"uid": uid, "company_id": ACME_COMPANY_ID, "email_verified": True}
        )
    )

    assert response.status_code == 200
    body = response.json()
    assert body["uid"] == uid
    assert body["email"] == "field_inspector@acme.example.invalid"
    assert body["email_verified"] is True
    assert body["company_id"] == ACME_COMPANY_ID
    assert body["company_name"] == "Acme Energy"
    assert body["role_key"] == "field_inspector"
    assert set(body["permissions"]) == set(SYSTEM_ROLE_TEMPLATES["field_inspector"].permission_keys)


def test_me_returns_unverified_identity_for_verification_flow(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    _override_repositories(monkeypatch, firestore)
    response = _request_with_verifier(
        StaticTokenVerifier(
            {
                "uid": "demo-acme-executive",
                "company_id": ACME_COMPANY_ID,
                "email_verified": False,
            }
        )
    )

    assert response.status_code == 200
    assert response.json()["email_verified"] is False
    assert set(response.json()["permissions"]) == set(
        SYSTEM_ROLE_TEMPLATES["executive"].permission_keys
    )


def test_me_inactive_user_returns_403(monkeypatch: pytest.MonkeyPatch) -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    asyncio.run(
        UserRepository(firestore).update(
            scope,
            "demo-acme-executive",
            UserUpdate(status="inactive"),
            "test",
        )
    )
    _override_repositories(monkeypatch, firestore)
    response = _request_with_verifier(
        StaticTokenVerifier({"uid": "demo-acme-executive", "company_id": ACME_COMPANY_ID})
    )
    assert response.status_code == 403
    assert response.json()["error"] == "user_inactive"
    assert UUID(response.json()["request_id"])


def test_me_missing_firestore_user_returns_403(monkeypatch: pytest.MonkeyPatch) -> None:
    firestore = FakeAsyncClient()
    _override_repositories(monkeypatch, firestore)
    response = _request_with_verifier(
        StaticTokenVerifier({"uid": "missing", "company_id": ACME_COMPANY_ID})
    )
    assert response.status_code == 403
    assert response.json()["error"] == "user_not_found"
    assert UUID(response.json()["request_id"])


def test_sync_claims_from_role_sets_exact_payload() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    uid = "demo-acme-hse_manager"
    admin = FakeAuthAdmin(
        users={
            uid: FakeAuthUser(
                uid=uid,
                email="hse_manager@acme.example.invalid",
                custom_claims={"company_id": ACME_COMPANY_ID, "stale": True},
            )
        }
    )
    service = ClaimsService(
        admin,
        UserRepository(firestore),
        RoleRepository(firestore),
    )
    claims = asyncio.run(service.sync_claims_from_role(uid))
    expected = {
        "company_id": ACME_COMPANY_ID,
        "role_id": role_id(ACME_COMPANY_ID, "hse_manager"),
        "role_key": "hse_manager",
    }
    assert claims == expected
    assert admin.users[uid].custom_claims == expected


def test_provision_user_creates_firestore_user_claims_and_audit() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    admin: AuthAdmin = FakeAuthAdmin()
    audit = AuditService(AuditLogRepository(firestore))
    users = UserRepository(firestore, audit)
    service = UserProvisioningService(
        admin=admin,
        users=users,
        roles=RoleRepository(firestore),
        audit=audit,
    )
    provisioned = asyncio.run(
        service.provision_user(
            email="new.user@acme.example.invalid",
            company_id=ACME_COMPANY_ID,
            role_id=role_id(ACME_COMPANY_ID, "executive"),
            display_name="New User",
            actor_uid="admin-uid",
            password="ValidPass123!",
        )
    )

    assert asyncio.run(users.get(scope, provisioned.id)) == provisioned
    auth_user = asyncio.run(admin.get_user(provisioned.id))
    assert auth_user.custom_claims == {
        "company_id": ACME_COMPANY_ID,
        "role_id": role_id(ACME_COMPANY_ID, "executive"),
        "role_key": "executive",
    }
    audits = asyncio.run(AuditLogRepository(firestore).list(scope))
    assert any(
        entry.action == "user.provisioned" and entry.target_id == provisioned.id for entry in audits
    )
