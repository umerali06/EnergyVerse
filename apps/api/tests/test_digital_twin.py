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
from app.facilities.service import (
    DEFAULT_HOTSPOT_POSITION,
    FacilityManagementService,
    _coerce_float,
    _coerce_position,
    get_facility_management_service,
)
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
        audit=audit,
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


def test_get_facility_3d_scene_synthesizes_default_layout_with_asset_statuses(
    wiring: dict[str, Any]
) -> None:
    response = _request(
        _identity(), "GET", f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene"
    )
    assert response.status_code == 200
    body = response.json()
    assert body["facility_id"] == FACILITY_NORTH_REFINERY_ID
    assert body["facility_name"] == "North Refinery"
    assert body["scene_type"] == "procedural_refinery"
    assert len(body["camera_presets"]) >= 3
    assert len(body["hotspots"]) >= 1

    # Verify every hotspot includes live asset attributes and status
    first_hotspot = body["hotspots"][0]
    assert "asset_id" in first_hotspot
    assert "asset_name" in first_hotspot
    assert "current_status" in first_hotspot
    assert first_hotspot["current_status"] in {"Healthy", "Warning", "Critical"}
    assert len(first_hotspot["position"]) == 3


def test_update_facility_3d_scene_persists_custom_hotspots_and_presets(
    wiring: dict[str, Any]
) -> None:
    # First fetch default scene to obtain a valid seeded asset_id
    default_scene = _request(
        _identity(), "GET", f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene"
    ).json()
    target_asset_id = default_scene["hotspots"][0]["asset_id"]

    update_payload = {
        "model_3d_url": "https://storage.example.invalid/models/refinery_v1.glb",
        "scene_type": "gltf_custom",
        "camera_presets": [
            {
                "id": "main_view",
                "name": "Main Entrance View",
                "position": [0.0, 10.0, 20.0],
                "target": [0.0, 0.0, 0.0],
            }
        ],
        "hotspots": [
            {
                "id": "hs_custom_1",
                "asset_id": target_asset_id,
                "position": [5.0, 2.5, -3.0],
                "radius": 2.0,
                "label": "Custom Distillation Skid Node",
            }
        ],
    }

    put_response = _request(
        _identity(),
        "PUT",
        f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene",
        json=update_payload,
    )
    assert put_response.status_code == 200
    updated_body = put_response.json()
    assert updated_body["model_3d_url"] == "https://storage.example.invalid/models/refinery_v1.glb"
    assert updated_body["scene_type"] == "gltf_custom"
    assert len(updated_body["camera_presets"]) == 1
    assert updated_body["camera_presets"][0]["name"] == "Main Entrance View"

    hotspot = updated_body["hotspots"][0]
    assert hotspot["asset_id"] == target_asset_id
    assert hotspot["position"] == [5.0, 2.5, -3.0]
    assert hotspot["radius"] == 2.0
    assert hotspot["label"] == "Custom Distillation Skid Node"


# Scene documents are hand-authored and unvalidated in Firestore, so a hotspot
# can carry a string, a null, or a missing key where a number belongs. Before
# these guards a single bad value raised inside `float()` and returned a 500
# for the entire facility scene rather than degrading that one hotspot.
@pytest.mark.parametrize(
    ("value", "expected"),
    [
        (2.5, 2.5),
        (3, 3.0),
        ("4.5", 4.5),
        (None, 1.0),
        ("not-a-number", 1.0),
        ("", 1.0),
        ({"nested": "object"}, 1.0),
        ([1.0], 1.0),
        (True, 1.0),
        (float("nan"), 1.0),
        (float("inf"), 1.0),
    ],
)
def test_coerce_float_never_raises_on_untrusted_scene_values(
    value: object, expected: float
) -> None:
    assert _coerce_float(value, 1.0) == expected


@pytest.mark.parametrize(
    ("value", "expected"),
    [
        ([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]),
        ([1, 2, 3], [1.0, 2.0, 3.0]),
        (["1.5", "2.5", "3.5"], [1.5, 2.5, 3.5]),
        # A single bad axis falls back to that axis's default, not the whole vector.
        ([1.0, "bad", 3.0], [1.0, DEFAULT_HOTSPOT_POSITION[1], 3.0]),
        (None, DEFAULT_HOTSPOT_POSITION),
        ([1.0, 2.0], DEFAULT_HOTSPOT_POSITION),
        ([1.0, 2.0, 3.0, 4.0], DEFAULT_HOTSPOT_POSITION),
        ("1,2,3", DEFAULT_HOTSPOT_POSITION),
    ],
)
def test_coerce_position_always_returns_three_floats(
    value: object, expected: list[float]
) -> None:
    assert _coerce_position(value) == expected


def test_get_3d_scene_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID),
        "GET",
        f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene",
    )
    assert response.status_code == 404
    assert response.json()["error"] == "facility_not_found"


def test_3d_scene_read_route_is_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        response = _request(
            identity, "GET", f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene"
        )
        if "facilities.read" in template.permission_keys:
            assert response.status_code == 200, (role_key, response.json())
        else:
            assert response.status_code == 403, role_key


def test_update_3d_scene_requires_facilities_write(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"facilities.read"})),
        "PUT",
        f"/api/v1/facilities/{FACILITY_NORTH_REFINERY_ID}/3d-scene",
        json={"scene_type": "procedural_refinery"},
    )
    assert response.status_code == 403
