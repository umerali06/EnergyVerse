import asyncio
from collections.abc import Mapping
from typing import Any

import pytest
from fastapi.testclient import TestClient
from starlette.requests import Request

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import (
    get_access_denial_audit,
    require_permission,
    require_role,
)
from scripts.seed import ACME_COMPANY_ID
from tests.fakes.firestore import FakeAsyncClient

DEMO_ROUTE_OUTCOMES: Mapping[str, Mapping[str, bool]] = {
    "super_admin": {"single": True, "all": True, "any": True},
    "company_admin": {"single": True, "all": True, "any": True},
    "operations_manager": {"single": True, "all": True, "any": True},
    "field_inspector": {"single": False, "all": False, "any": False},
    "maintenance_technician": {"single": False, "all": False, "any": True},
    "hse_manager": {"single": False, "all": False, "any": True},
    "executive": {"single": False, "all": False, "any": False},
}


def _identity(role_key: str, permissions: frozenset[str]) -> CurrentUser:
    return CurrentUser(
        uid=f"test-{role_key}",
        email=f"{role_key}@example.invalid",
        company_id=ACME_COMPANY_ID,
        role_key=role_key,
        permissions=permissions,
    )


def _request_as(identity: CurrentUser, route: str) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    app.dependency_overrides[get_access_denial_audit] = lambda: AuditService(
        AuditLogRepository(FakeAsyncClient())
    )
    try:
        with TestClient(app) as client:
            return client.get(f"/api/v1/_rbac-demo/{route}")
    finally:
        app.dependency_overrides.clear()


def test_single_permission_allows_caller_with_permission() -> None:
    response = _request_as(_identity("custom", frozenset({"assets.write"})), "single")
    assert response.status_code == 200
    assert response.json() == {"ok": True}


def test_single_permission_denies_with_exact_missing_contract() -> None:
    response = _request_as(_identity("custom", frozenset()), "single")
    assert response.status_code == 403
    assert response.json() == {
        "error": "forbidden",
        "required": ["assets.write"],
        "mode": "all",
        "missing": ["assets.write"],
    }


def test_all_mode_denies_when_one_permission_is_missing() -> None:
    response = _request_as(
        _identity("custom", frozenset({"assets.write"})),
        "all",
    )
    assert response.status_code == 403
    assert response.json()["missing"] == ["reports.generate"]
    assert response.json()["mode"] == "all"


def test_any_mode_allows_when_one_permission_is_present() -> None:
    response = _request_as(
        _identity("custom", frozenset({"work_orders.write"})),
        "any",
    )
    assert response.status_code == 200


def test_unauthenticated_demo_request_is_401_not_403() -> None:
    with TestClient(app) as client:
        response = client.get("/api/v1/_rbac-demo/single")
    assert response.status_code == 401
    assert response.json()["error"] == "unauthorized"


@pytest.mark.parametrize(
    ("role_key", "route", "allowed"),
    [
        (role_key, route, allowed)
        for role_key, outcomes in DEMO_ROUTE_OUTCOMES.items()
        for route, allowed in outcomes.items()
    ],
)
def test_seeded_role_matrix_matches_demo_route_outcomes(
    role_key: str,
    route: str,
    allowed: bool,
) -> None:
    template = SYSTEM_ROLE_TEMPLATES[role_key]
    response = _request_as(_identity(role_key, template.permission_keys), route)
    assert response.status_code == (200 if allowed else 403)


def test_denial_writes_access_denied_audit() -> None:
    firestore = FakeAsyncClient()
    identity = _identity("executive", frozenset({"assets.read"}))
    app.dependency_overrides[get_current_user] = lambda: identity
    app.dependency_overrides[get_access_denial_audit] = lambda: AuditService(
        AuditLogRepository(firestore)
    )
    try:
        with TestClient(app) as client:
            response = client.get("/api/v1/_rbac-demo/single")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 403
    audits = asyncio.run(
        AuditLogRepository(firestore).list(CompanyScope(company_id=ACME_COMPANY_ID))
    )
    assert len(audits) == 1
    denial = audits[0]
    assert denial.action == "access.denied"
    assert denial.actor_uid == identity.uid
    assert denial.metadata == {
        "route": "/api/v1/_rbac-demo/single",
        "required": ["assets.write"],
        "missing": ["assets.write"],
        "mode": "all",
        "gate": "permission",
    }


def test_require_role_allows_listed_role_and_denies_other_role() -> None:
    dependency = require_role("company_admin", "super_admin")
    request = Request(
        {
            "type": "http",
            "method": "GET",
            "path": "/role-only",
            "headers": [],
            "query_string": b"",
            "server": ("testserver", 80),
            "scheme": "http",
        }
    )
    audit = AuditService(AuditLogRepository(FakeAsyncClient()))
    allowed = _identity("company_admin", frozenset())
    assert asyncio.run(dependency(request, allowed, audit)) == allowed

    denied = _identity("executive", frozenset())
    with pytest.raises(Exception) as error:
        asyncio.run(dependency(request, denied, audit))
    assert getattr(error.value, "status_code", None) == 403


def test_permission_factory_rejects_invalid_configuration() -> None:
    with pytest.raises(ValueError):
        require_permission()
    with pytest.raises(ValueError):
        require_permission("assets.read", mode="invalid")  # type: ignore[arg-type]
