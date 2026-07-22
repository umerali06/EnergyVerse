import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.facilities import FacilityRepository
from app.facilities.service import FacilityManagementService, get_facility_management_service
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import ACME_COMPANY_ID, FACILITY_NORTH_REFINERY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = FacilityManagementService(
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        assets=AssetRepository(client, audit),
        companies=CompanyRepository(client, audit),
    )

    app.dependency_overrides[get_facility_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_facility_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"facilities.read", "facilities.write"}),
) -> CurrentUser:
    return CurrentUser(
        uid=uid,
        email=f"{uid}@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom",
        permissions=permissions,
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


# --- tenant isolation and RBAC ----------------------------------------------


def test_list_facilities_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/facilities")
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 2

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/facilities")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_get_facility_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID),
        "GET",
        f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}",
    )
    assert response.status_code == 404
    assert response.json()["error"] == "facility_not_found"


def test_facilities_read_route_is_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        response = _request(identity, "GET", "/api/v1/facilities")
        if "facilities.read" in template.permission_keys:
            assert response.status_code == 200, (role_key, response.json())
        else:
            assert response.status_code == 403, role_key


def test_create_facility_requires_write_permission(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"facilities.read"})),
        "POST",
        "/api/v1/facilities",
        json={"name": "New Facility"},
    )
    assert response.status_code == 403


# --- create / update / soft-delete ------------------------------------------


def test_create_facility_defaults_timezone_from_company(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "POST", "/api/v1/facilities", json={"name": "New Site"})
    assert response.status_code == 201
    body = response.json()
    assert body["timezone"] == "UTC"
    assert body["status"] == "active"


def test_create_update_and_soft_delete_facility(wiring: dict[str, Any]) -> None:
    created = _request(
        _identity(),
        "POST",
        "/api/v1/facilities",
        json={"name": "Empty Yard", "sector": "Storage"},
    )
    assert created.status_code == 201
    facility_id = created.json()["id"]

    updated = _request(
        _identity(),
        "PATCH",
        f"/api/v1/facilities/{facility_id}",
        json={"name": "Renamed Yard"},
    )
    assert updated.status_code == 200
    assert updated.json()["name"] == "Renamed Yard"

    deleted = _request(_identity(), "DELETE", f"/api/v1/facilities/{facility_id}")
    assert deleted.status_code == 200
    assert deleted.json() == {"id": facility_id, "deleted": True}

    after = _request(_identity(), "GET", f"/api/v1/facilities/{facility_id}")
    assert after.status_code == 404

    listed = _request(_identity(), "GET", "/api/v1/facilities")
    assert facility_id not in {item["id"] for item in listed.json()["items"]}


def test_delete_facility_with_children_returns_409(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "DELETE", f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}"
    )
    assert response.status_code == 409
    assert response.json()["error"] == "facility_has_children"
