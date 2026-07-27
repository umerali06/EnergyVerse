import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

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
    AREA_PROCESS_UNIT_1_ID,
    AREA_TANK_FARM_A_ID,
    ASSET_FEED_PUMP_ID,
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
    bucket = FakeBucket()
    service = AssetManagementService(
        assets=AssetRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        storage=AssetMediaStorage(bucket),
    )

    app.dependency_overrides[get_asset_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "bucket": bucket}
    app.dependency_overrides.pop(get_asset_management_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"assets.read", "assets.write"}),
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


def _create_asset(identity: CurrentUser, **overrides: Any) -> Any:
    payload = {
        "facility_id": FACILITY_NORTH_REFINERY_ID,
        "asset_tag": "TEST-1",
        "name": "Test Asset",
        "category": "Pumps",
    }
    payload.update(overrides)
    return _request(identity, "POST", "/api/v1/assets", json=payload)


# --- tenant isolation and RBAC ----------------------------------------------


def test_list_assets_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/assets", params={"limit": 100})
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 11

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/assets")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_get_asset_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/assets/{ASSET_FEED_PUMP_ID}"
    )
    assert response.status_code == 404
    assert response.json()["error"] == "asset_not_found"


def test_assets_routes_are_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        read_response = _request(identity, "GET", "/api/v1/assets")
        if "assets.read" in template.permission_keys:
            assert read_response.status_code == 200, (role_key, read_response.json())
        else:
            assert read_response.status_code == 403, role_key

        write_response = _create_asset(identity, asset_tag=f"RBAC-{role_key}")
        if "assets.write" in template.permission_keys:
            assert write_response.status_code == 201, (role_key, write_response.json())
        else:
            assert write_response.status_code == 403, role_key


# --- hierarchy integrity -----------------------------------------------------


def test_create_asset_rejects_unknown_facility(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity(), facility_id="does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "facility_not_found"


def test_create_asset_rejects_area_from_a_different_facility(wiring: dict[str, Any]) -> None:
    response = _create_asset(
        _identity(),
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=AREA_TANK_FARM_A_ID,  # belongs to North Refinery, not Compressor Station
    )
    assert response.status_code == 422
    assert response.json()["error"] == "area_not_in_facility"


def test_create_asset_rejects_unknown_parent(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity(), parent_asset_id="does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "parent_asset_not_found"


def test_create_asset_accepts_valid_parent_in_same_tenant(wiring: dict[str, Any]) -> None:
    response = _create_asset(
        _identity(),
        area_id=AREA_PROCESS_UNIT_1_ID,
        parent_asset_id=ASSET_FEED_PUMP_ID,
    )
    assert response.status_code == 201
    assert response.json()["parent_asset_id"] == ASSET_FEED_PUMP_ID


def test_update_asset_rejects_self_parenting(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity())
    asset_id = created.json()["id"]
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/assets/{asset_id}",
        json={"parent_asset_id": asset_id},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "asset_cannot_parent_itself"


def test_asset_tag_is_unique_within_company(wiring: dict[str, Any]) -> None:
    assert _create_asset(_identity(), asset_tag="UNIQUE-1").status_code == 201
    duplicate = _create_asset(_identity(), asset_tag=" unique-1 ")
    assert duplicate.status_code == 409
    assert duplicate.json()["error"] == "asset_tag_conflict"


def test_update_rejects_parent_cycle(wiring: dict[str, Any]) -> None:
    parent = _create_asset(_identity(), asset_tag="CYCLE-P").json()
    child = _create_asset(
        _identity(), asset_tag="CYCLE-C", parent_asset_id=parent["id"]
    ).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/assets/{parent['id']}",
        json={"parent_asset_id": child["id"]},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "asset_parent_cycle"


def test_update_can_clear_nullable_asset_fields(wiring: dict[str, Any]) -> None:
    created = _create_asset(
        _identity(),
        asset_tag="CLEAR-1",
        area_id=AREA_PROCESS_UNIT_1_ID,
        parent_asset_id=ASSET_FEED_PUMP_ID,
        manufacturer="Before",
        gps_lat=29.0,
        gps_lng=71.0,
    ).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/assets/{created['id']}",
        json={
            "area_id": None,
            "parent_asset_id": None,
            "manufacturer": None,
            "gps_lat": None,
            "gps_lng": None,
        },
    )
    assert response.status_code == 200
    assert response.json()["area_id"] is None
    assert response.json()["parent_asset_id"] is None
    assert response.json()["manufacturer"] is None
    assert response.json()["gps_lat"] is None
    assert response.json()["gps_lng"] is None


def test_create_rejects_incomplete_gps(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity(), asset_tag="GPS-1", gps_lat=29.0)
    assert response.status_code == 422
    assert response.json()["error"] == "incomplete_gps"


def test_media_upload_and_delete_use_scoped_private_object(
    wiring: dict[str, Any],
) -> None:
    asset = _create_asset(_identity(), asset_tag="MEDIA-1").json()
    uploaded = _request(
        _identity(),
        "POST",
        f"/api/v1/assets/{asset['id']}/media",
        params={"kind": "photo"},
        files={"file": ("pump.jpg", b"real-image-bytes", "image/jpeg")},
    )
    assert uploaded.status_code == 200
    media = uploaded.json()["photos"][0]
    assert media["filename"] == "pump.jpg"
    assert media["url"].startswith("https://fake-storage.invalid/")
    paths = list(wiring["bucket"].objects)
    assert len(paths) == 1
    assert paths[0].startswith(
        f"companies/{ACME_COMPANY_ID}/assets/{asset['id']}/photo/"
    )

    deleted = _request(
        _identity(),
        "DELETE",
        f"/api/v1/assets/{asset['id']}/media/{media['id']}",
    )
    assert deleted.status_code == 200
    assert deleted.json()["photos"] == []
    assert wiring["bucket"].objects == {}


def test_media_rejects_wrong_type_and_write_permission(
    wiring: dict[str, Any],
) -> None:
    asset = _create_asset(_identity(), asset_tag="MEDIA-2").json()
    wrong = _request(
        _identity(),
        "POST",
        f"/api/v1/assets/{asset['id']}/media",
        params={"kind": "manual"},
        files={"file": ("photo.jpg", b"image", "image/jpeg")},
    )
    assert wrong.status_code == 422
    assert wrong.json()["error"] == "invalid_media_type"

    read_only = _identity(permissions=frozenset({"assets.read"}))
    denied = _request(
        read_only,
        "POST",
        f"/api/v1/assets/{asset['id']}/media",
        params={"kind": "photo"},
        files={"file": ("photo.jpg", b"image", "image/jpeg")},
    )
    assert denied.status_code == 403


# --- category / status -------------------------------------------------------


def test_new_asset_defaults_current_status_to_healthy(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity())
    assert response.status_code == 201
    assert response.json()["current_status"] == "Healthy"


def test_create_asset_rejects_unknown_category(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity(), category="Not A Real Category")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_category"


def test_create_asset_accepts_other_category_with_subtype(wiring: dict[str, Any]) -> None:
    response = _create_asset(_identity(), category="Other", category_other="Custom Skid")
    assert response.status_code == 201
    assert response.json()["category"] == "Other"
    assert response.json()["category_other"] == "Custom Skid"


def test_create_asset_requires_category_other_when_category_is_other(
    wiring: dict[str, Any],
) -> None:
    response = _create_asset(_identity(), category="Other")
    assert response.status_code == 422
    assert response.json()["error"] == "category_other_required"


# --- filters / search / sort / pagination -----------------------------------


def test_list_assets_filters_by_facility(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(),
        "GET",
        "/api/v1/assets",
        params={"facility_id": FACILITY_NORTH_REFINERY_ID, "limit": 100},
    )
    assert response.status_code == 200
    assert all(
        item["facility_id"] == FACILITY_NORTH_REFINERY_ID for item in response.json()["items"]
    )


def test_list_assets_filters_by_category_and_status(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "GET", "/api/v1/assets", params={"category": "Pumps", "limit": 100}
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert len(items) == 1
    assert items[0]["asset_tag"] == "P-101"

    warning = _request(
        _identity(), "GET", "/api/v1/assets", params={"current_status": "Warning", "limit": 100}
    )
    assert warning.status_code == 200
    assert {item["asset_tag"] for item in warning.json()["items"]} == {"C-201", "G-701"}


def test_list_assets_search_matches_tag_and_name(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/assets", params={"search": "p-101"})
    assert response.status_code == 200
    assert {item["asset_tag"] for item in response.json()["items"]} == {"P-101"}


def test_list_assets_pagination_cursor_walks_full_set(wiring: dict[str, Any]) -> None:
    seen: list[str] = []
    cursor = None
    for _ in range(20):
        params = {"limit": 4}
        if cursor:
            params["cursor"] = cursor
        response = _request(_identity(), "GET", "/api/v1/assets", params=params)
        assert response.status_code == 200
        body = response.json()
        seen.extend(item["id"] for item in body["items"])
        cursor = body["next_cursor"]
        if cursor is None:
            break
    assert len(seen) == 11
    assert len(set(seen)) == 11


def test_list_assets_sort_by_name(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "GET", "/api/v1/assets", params={"sort": "name", "limit": 100}
    )
    assert response.status_code == 200
    names = [item["name"] for item in response.json()["items"]]
    assert names == sorted(names, key=str.casefold)


# --- history -----------------------------------------------------------------


def test_asset_history_returns_empty_shaped_page(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", f"/api/v1/assets/{ASSET_FEED_PUMP_ID}/history")
    assert response.status_code == 200
    assert response.json() == {"items": [], "next_cursor": None}


def test_asset_history_404s_for_unknown_asset(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/assets/does-not-exist/history")
    assert response.status_code == 404


# --- soft delete -------------------------------------------------------------


def test_soft_deleted_asset_is_excluded_from_list_and_get(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity())
    asset_id = created.json()["id"]

    deleted = _request(_identity(), "DELETE", f"/api/v1/assets/{asset_id}")
    assert deleted.status_code == 200
    assert deleted.json() == {"id": asset_id, "deleted": True}

    after = _request(_identity(), "GET", f"/api/v1/assets/{asset_id}")
    assert after.status_code == 404

    listed = _request(_identity(), "GET", "/api/v1/assets", params={"limit": 100})
    assert asset_id not in {item["id"] for item in listed.json()["items"]}
