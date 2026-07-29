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
from app.db.repositories.inspections import InspectionRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import get_access_denial_audit
from app.storage.service import AssetMediaStorage
from scripts.seed import (
    ACME_COMPANY_ID,
    ASSET_FEED_PUMP_ID,
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
        inspections=InspectionRepository(client, audit),
        storage=AssetMediaStorage(bucket),
    )

    app.dependency_overrides[get_asset_management_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "audit": audit}
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


def _request(identity: CurrentUser | None, method: str, path: str, **kwargs: Any) -> Any:
    if identity is not None:
        app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _create_asset(identity: CurrentUser, **overrides: Any) -> Any:
    payload = {
        "facility_id": FACILITY_NORTH_REFINERY_ID,
        "asset_tag": "QR-TEST-1",
        "name": "QR Test Asset",
        "category": "Pumps",
    }
    payload.update(overrides)
    return _request(identity, "POST", "/api/v1/assets", json=payload)


# --- qr_code_id generation on create -----------------------------------------


def test_create_asset_generates_unique_qr_code_id(wiring: dict[str, Any]) -> None:
    first = _create_asset(_identity(), asset_tag="QR-A").json()
    second = _create_asset(_identity(), asset_tag="QR-B").json()
    assert first["qr_code_id"]
    assert second["qr_code_id"]
    assert first["qr_code_id"] != second["qr_code_id"]
    # Opaque -- not derived from (or equal to) the asset's own id/uuid.
    assert first["qr_code_id"] != first["id"]


# --- resolve ------------------------------------------------------------------


def test_resolve_qr_code_returns_scan_surface(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-RESOLVE").json()
    code = created["qr_code_id"]

    response = _request(_identity(), "GET", f"/api/v1/qr/{code}/resolve")
    assert response.status_code == 200
    body = response.json()
    assert body["asset"]["id"] == created["id"]
    assert body["asset"]["asset_tag"] == "QR-RESOLVE"
    assert body["inspections_total"] == 0
    assert body["maintenance_total"] == 0
    assert body["work_orders_total"] == 0


def test_resolve_unknown_code_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/qr/does-not-exist/resolve")
    assert response.status_code == 404
    assert response.json()["error"] == "qr_code_not_found"


def test_resolve_cross_tenant_code_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-CROSS").json()
    code = created["qr_code_id"]

    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/qr/{code}/resolve"
    )
    assert response.status_code == 404
    assert response.json()["error"] == "qr_code_not_found"


def test_resolve_unauthenticated_returns_401(wiring: dict[str, Any]) -> None:
    response = _request(None, "GET", f"/api/v1/qr/{ASSET_FEED_PUMP_ID}/resolve")
    assert response.status_code == 401


def test_resolve_without_assets_read_returns_403(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-FORBIDDEN").json()
    code = created["qr_code_id"]

    response = _request(
        _identity(permissions=frozenset()), "GET", f"/api/v1/qr/{code}/resolve"
    )
    assert response.status_code == 403


def test_resolve_is_audited(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-AUDIT").json()
    code = created["qr_code_id"]

    scanner = _identity(uid="scanner-uid")
    response = _request(scanner, "GET", f"/api/v1/qr/{code}/resolve")
    assert response.status_code == 200

    logs = asyncio.run(wiring["audit"]._repository.list(CompanyScope(company_id=ACME_COMPANY_ID)))
    scan_entries = [log for log in logs if log.action == "asset.qr_scanned"]
    assert any(
        entry.actor_uid == "scanner-uid" and entry.target_id == created["id"]
        for entry in scan_entries
    )


# --- printable label endpoint --------------------------------------------------


def test_get_asset_qr_label_returns_url(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-LABEL").json()

    response = _request(_identity(), "GET", f"/api/v1/assets/{created['id']}/qr")
    assert response.status_code == 200
    body = response.json()
    assert body["qr_code_id"] == created["qr_code_id"]
    assert body["url"].endswith(f"/qr/{created['qr_code_id']}")
    assert body["asset_tag"] == "QR-LABEL"


def test_get_asset_qr_label_requires_assets_read(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-LABEL-2").json()

    response = _request(
        _identity(permissions=frozenset()), "GET", f"/api/v1/assets/{created['id']}/qr"
    )
    assert response.status_code == 403


def test_get_asset_qr_label_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_asset(_identity(), asset_tag="QR-LABEL-3").json()

    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/assets/{created['id']}/qr"
    )
    assert response.status_code == 404
