import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.assets.constants import ASSET_CATEGORIES
from app.assets.service import AssetManagementService, get_asset_management_service
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.storage.service import AssetMediaStorage
from scripts.seed import (
    ACME_COMPANY_ID,
    FACILITY_COMPRESSOR_STATION_ID,
    FACILITY_NORTH_REFINERY_ID,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.storage import FakeBucket

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = AssetManagementService(
        assets=AssetRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        storage=AssetMediaStorage(FakeBucket()),
    )

    app.dependency_overrides[get_asset_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_asset_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"assets.read"}),
) -> CurrentUser:
    return CurrentUser(
        uid="test-viewer",
        email="viewer@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom_viewer",
        permissions=permissions,
    )


def _get(identity: CurrentUser, path: str = "/api/v1/dashboard/assets-summary") -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.get(path)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def test_assets_summary_returns_real_seeded_counts(wiring: dict[str, Any]) -> None:
    response = _get(_identity())
    assert response.status_code == 200
    body = response.json()
    assert body["total"] == 11
    assert body["healthy"] == 8
    assert body["warning"] == 2
    assert body["critical"] == 1
    assert body["total"] == body["healthy"] + body["warning"] + body["critical"]

    by_category = {row["category"]: row["count"] for row in body["by_category"]}
    assert set(by_category) == set(ASSET_CATEGORIES)
    assert sum(by_category.values()) == 11

    by_facility = {row["facility_id"]: row["count"] for row in body["by_facility"]}
    assert by_facility[FACILITY_NORTH_REFINERY_ID] == 6
    assert by_facility[FACILITY_COMPRESSOR_STATION_ID] == 5


def test_assets_summary_requires_assets_read(wiring: dict[str, Any]) -> None:
    response = _get(_identity(permissions=frozenset({"reports.read"})))
    assert response.status_code == 403
    assert response.json()["error"] == "forbidden"


def test_assets_summary_is_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(permissions=template.permission_keys)
        response = _get(identity)
        if "assets.read" in template.permission_keys:
            assert response.status_code == 200, (role_key, response.json())
        else:
            assert response.status_code == 403, role_key


def test_assets_summary_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    beta = _get(_identity(company_id=BETA_COMPANY_ID))
    assert beta.status_code == 200
    body = beta.json()
    assert body["total"] == 0
    assert body["healthy"] == 0
    assert body["warning"] == 0
    assert body["critical"] == 0
    assert all(row["count"] == 0 for row in body["by_category"])
    assert body["by_facility"] == []


def test_assets_summary_zero_count_tenant_is_not_an_error(wiring: dict[str, Any]) -> None:
    response = _get(_identity(company_id="brand-new-co"))
    assert response.status_code == 200
    body = response.json()
    assert body["total"] == 0
    assert body["by_category"]
    assert all(row["count"] == 0 for row in body["by_category"])


def test_assets_summary_excludes_soft_deleted_assets(wiring: dict[str, Any]) -> None:
    app.dependency_overrides[get_current_user] = lambda: _identity(
        permissions=frozenset({"assets.read", "assets.write"})
    )
    try:
        with TestClient(app) as client:
            listing = client.get("/api/v1/assets", params={"limit": 100})
            asset_id = listing.json()["items"][0]["id"]
            delete_response = client.delete(f"/api/v1/assets/{asset_id}")
            assert delete_response.status_code == 200

            summary = client.get("/api/v1/dashboard/assets-summary")
            assert summary.status_code == 200
            assert summary.json()["total"] == 10
    finally:
        app.dependency_overrides.pop(get_current_user, None)
