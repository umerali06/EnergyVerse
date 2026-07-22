import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.areas.service import AreaManagementService, get_area_management_service
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser, FacilityCreate
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import (
    ACME_COMPANY_ID,
    AREA_PROCESS_UNIT_1_ID,
    AREA_TANK_FARM_A_ID,
    FACILITY_NORTH_REFINERY_ID,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    facilities = FacilityRepository(client, audit)
    service = AreaManagementService(
        areas=AreaRepository(client, audit),
        facilities=facilities,
        assets=AssetRepository(client, audit),
    )

    app.dependency_overrides[get_area_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "facilities": facilities}
    app.dependency_overrides.pop(get_area_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"areas.read", "areas.write"}),
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


def test_list_areas_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/areas")
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 4

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/areas")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_list_areas_filters_by_facility(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "GET", "/api/v1/areas", params={"facility_id": FACILITY_NORTH_REFINERY_ID}
    )
    assert response.status_code == 200
    ids = {item["id"] for item in response.json()["items"]}
    assert ids == {AREA_TANK_FARM_A_ID, AREA_PROCESS_UNIT_1_ID}


def test_get_area_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/areas/{AREA_TANK_FARM_A_ID}"
    )
    assert response.status_code == 404
    assert response.json()["error"] == "area_not_found"


def test_areas_read_route_is_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        response = _request(identity, "GET", "/api/v1/areas")
        if "areas.read" in template.permission_keys:
            assert response.status_code == 200, (role_key, response.json())
        else:
            assert response.status_code == 403, role_key


def test_create_area_requires_write_permission(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"areas.read"})),
        "POST",
        "/api/v1/areas",
        json={"facility_id": FACILITY_NORTH_REFINERY_ID, "name": "New Area"},
    )
    assert response.status_code == 403


# --- hierarchy integrity -----------------------------------------------------


def test_create_area_rejects_unknown_facility(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(),
        "POST",
        "/api/v1/areas",
        json={"facility_id": "does-not-exist", "name": "Ghost Area"},
    )
    assert response.status_code == 404
    assert response.json()["error"] == "facility_not_found"


def test_create_area_rejects_cross_tenant_facility(wiring: dict[str, Any]) -> None:
    beta_scope = CompanyScope(company_id=BETA_COMPANY_ID)
    asyncio.run(
        wiring["facilities"].create(
            beta_scope,
            FacilityCreate(id="beta-facility", name="Beta Site"),
            "test-seed",
        )
    )

    response = _request(
        _identity(),
        "POST",
        "/api/v1/areas",
        json={"facility_id": "beta-facility", "name": "Ghost Area"},
    )
    assert response.status_code == 404
    assert response.json()["error"] == "facility_not_found"


# --- create / update / soft-delete ------------------------------------------


def test_create_update_and_soft_delete_area(wiring: dict[str, Any]) -> None:
    created = _request(
        _identity(),
        "POST",
        "/api/v1/areas",
        json={"facility_id": FACILITY_NORTH_REFINERY_ID, "name": "New Wing", "code": "NW"},
    )
    assert created.status_code == 201
    area_id = created.json()["id"]

    updated = _request(
        _identity(), "PATCH", f"/api/v1/areas/{area_id}", json={"name": "Renamed Wing"}
    )
    assert updated.status_code == 200
    assert updated.json()["name"] == "Renamed Wing"

    deleted = _request(_identity(), "DELETE", f"/api/v1/areas/{area_id}")
    assert deleted.status_code == 200
    assert deleted.json() == {"id": area_id, "deleted": True}

    after = _request(_identity(), "GET", f"/api/v1/areas/{area_id}")
    assert after.status_code == 404


def test_delete_area_with_children_returns_409(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "DELETE", f"/api/v1/areas/{AREA_TANK_FARM_A_ID}")
    assert response.status_code == 409
    assert response.json()["error"] == "area_has_children"
