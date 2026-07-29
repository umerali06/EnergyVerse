import asyncio
import uuid
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.inspections import InspectionRepository
from app.inspections.service import InspectionService, get_inspection_service
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import (
    ACME_COMPANY_ID,
    ASSET_FEED_PUMP_ID,
    CHECKLIST_TEMPLATE_PUMP_ID,
    CHECKLIST_TEMPLATE_TANK_ID,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"
CLIENT_CREATED_AT = "2026-07-20T10:00:00Z"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
    )

    app.dependency_overrides[get_inspection_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_inspection_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"inspections.read", "inspections.write"}),
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


def _create_inspection(identity: CurrentUser, **overrides: Any) -> Any:
    payload: dict[str, Any] = {
        "id": str(uuid.uuid4()),
        "asset_id": ASSET_FEED_PUMP_ID,
        "inspection_type": "routine",
        "client_created_at": CLIENT_CREATED_AT,
    }
    payload.update(overrides)
    return _request(identity, "POST", "/api/v1/inspections", json=payload)


# --- tenant isolation and RBAC ------------------------------------------------


def test_list_inspections_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/inspections", params={"limit": 100})
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 3

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/inspections")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_get_inspection_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity())
    inspection_id = created.json()["id"]
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/inspections/{inspection_id}"
    )
    assert response.status_code == 404
    assert response.json()["error"] == "inspection_not_found"


def test_inspection_routes_are_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        read_response = _request(identity, "GET", "/api/v1/inspections")
        if "inspections.read" in template.permission_keys:
            assert read_response.status_code == 200, (role_key, read_response.json())
        else:
            assert read_response.status_code == 403, role_key

        write_response = _create_inspection(identity)
        if "inspections.write" in template.permission_keys:
            assert write_response.status_code == 200, (role_key, write_response.json())
        else:
            assert write_response.status_code == 403, role_key


# --- create / idempotent upsert ----------------------------------------------


def test_create_inspection_rejects_unknown_asset(wiring: dict[str, Any]) -> None:
    response = _create_inspection(_identity(), asset_id="does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "asset_not_found"


def test_create_inspection_rejects_malformed_uuid(wiring: dict[str, Any]) -> None:
    response = _create_inspection(_identity(), id="not-a-uuid")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_inspection_id"


def test_create_inspection_resubmit_is_idempotent_noop(wiring: dict[str, Any]) -> None:
    inspection_id = str(uuid.uuid4())
    first = _create_inspection(_identity(), id=inspection_id, title="Same Title")
    assert first.status_code == 200
    second = _create_inspection(_identity(), id=inspection_id, title="Same Title")
    assert second.status_code == 200
    assert first.json()["revision"] == second.json()["revision"] == 1

    listed = _request(_identity(), "GET", "/api/v1/inspections", params={"limit": 100})
    matching = [item for item in listed.json()["items"] if item["id"] == inspection_id]
    assert len(matching) == 1


def test_create_inspection_resubmit_with_different_data_conflicts(wiring: dict[str, Any]) -> None:
    inspection_id = str(uuid.uuid4())
    first = _create_inspection(_identity(), id=inspection_id, title="Original")
    assert first.status_code == 200
    second = _create_inspection(_identity(), id=inspection_id, title="Different")
    assert second.status_code == 409
    assert second.json()["error"] == "inspection_id_conflict"


def test_create_inspection_rejects_incomplete_gps(wiring: dict[str, Any]) -> None:
    response = _create_inspection(_identity(), gps_lat=29.0)
    assert response.status_code == 422
    assert response.json()["error"] == "incomplete_gps"


def test_new_inspection_defaults_to_draft_with_no_started_at(wiring: dict[str, Any]) -> None:
    response = _create_inspection(_identity())
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "draft"
    assert body["started_at"] is None
    assert body["completed_at"] is None
    assert body["revision"] == 1


# --- update / revision conflict ----------------------------------------------


def test_update_inspection_bumps_revision_on_real_change(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "Updated notes"},
    )
    assert response.status_code == 200
    assert response.json()["notes"] == "Updated notes"
    assert response.json()["revision"] == 2


def test_update_inspection_is_noop_when_nothing_changes(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity(), notes="Same").json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "Same"},
    )
    assert response.status_code == 200
    assert response.json()["revision"] == 1


def test_update_inspection_rejects_stale_expected_revision(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "New", "expected_revision": 99},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "revision_conflict"


def test_update_inspection_locked_once_completed(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    complete = _request(
        _identity(), "POST", f"/api/v1/inspections/{created['id']}/complete"
    )
    assert complete.status_code == 200

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "Too late"},
    )
    assert response.status_code == 409
    assert response.json()["error"] == "inspection_locked"


# --- checklist template assignment + responses --------------------------------


def test_assign_checklist_template_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "POST",
        f"/api/v1/inspections/{created['id']}/checklist-template",
        json={"checklist_template_id": CHECKLIST_TEMPLATE_PUMP_ID},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["checklist_template_id"] == CHECKLIST_TEMPLATE_PUMP_ID
    assert len(body["checklist_items_snapshot"]) == 4
    assert body["checklist_responses"] == []


def test_assign_checklist_template_rejects_category_mismatch(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()  # asset is a Pump
    response = _request(
        _identity(),
        "POST",
        f"/api/v1/inspections/{created['id']}/checklist-template",
        json={"checklist_template_id": CHECKLIST_TEMPLATE_TANK_ID},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "checklist_template_category_mismatch"


def test_assign_unknown_checklist_template_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "POST",
        f"/api/v1/inspections/{created['id']}/checklist-template",
        json={"checklist_template_id": "does-not-exist"},
    )
    assert response.status_code == 404
    assert response.json()["error"] == "checklist_template_not_found"


def _assign_pump_template(identity: CurrentUser, inspection_id: str) -> Any:
    return _request(
        identity,
        "POST",
        f"/api/v1/inspections/{inspection_id}/checklist-template",
        json={"checklist_template_id": CHECKLIST_TEMPLATE_PUMP_ID},
    )


def test_checklist_response_rejects_unknown_item(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _assign_pump_template(_identity(), created["id"])
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"checklist_responses": [{"item_id": "not_a_real_item", "value": True}]},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "checklist_response_invalid"


def test_checklist_response_rejects_type_mismatch(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _assign_pump_template(_identity(), created["id"])
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"checklist_responses": [{"item_id": "vibration_normal", "value": "not-a-bool"}]},
    )
    assert response.status_code == 422
    assert response.json()["error"] == "checklist_response_invalid"


def test_checklist_response_rejects_duplicate_item_id(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _assign_pump_template(_identity(), created["id"])
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={
            "checklist_responses": [
                {"item_id": "vibration_normal", "value": True},
                {"item_id": "vibration_normal", "value": False},
            ]
        },
    )
    assert response.status_code == 422
    assert response.json()["error"] == "checklist_response_invalid"


def test_checklist_response_accepts_valid_values(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _assign_pump_template(_identity(), created["id"])
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"checklist_responses": [{"item_id": "vibration_normal", "value": True}]},
    )
    assert response.status_code == 200
    responses = response.json()["checklist_responses"]
    assert len(responses) == 1
    assert responses[0]["answered_by"] == "test-user"
    assert responses[0]["answered_at"] is not None


# --- lifecycle -----------------------------------------------------------------


def test_full_lifecycle_start_complete(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    inspection_id = created["id"]
    _assign_pump_template(_identity(), inspection_id)

    started = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/start")
    assert started.status_code == 200
    assert started.json()["status"] == "in_progress"
    assert started.json()["started_at"] is not None

    incomplete = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/complete")
    assert incomplete.status_code == 422
    assert incomplete.json()["error"] == "checklist_incomplete"
    missing = set(incomplete.json()["details"]["missing_item_ids"])
    assert missing == {"vibration_normal", "bearing_temp_f", "seal_condition"}

    _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{inspection_id}",
        json={
            "checklist_responses": [
                {"item_id": "vibration_normal", "value": True},
                {"item_id": "bearing_temp_f", "value": 140.0},
                {"item_id": "seal_condition", "value": "Good"},
            ]
        },
    )
    completed = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/complete")
    assert completed.status_code == 200
    assert completed.json()["status"] == "completed"
    assert completed.json()["completed_at"] is not None


def test_complete_without_any_template_succeeds(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(), "POST", f"/api/v1/inspections/{created['id']}/complete"
    )
    assert response.status_code == 200
    assert response.json()["status"] == "completed"


def test_start_twice_returns_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    inspection_id = created["id"]
    first = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/start")
    assert first.status_code == 200
    second = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/start")
    assert second.status_code == 409
    assert second.json()["error"] == "invalid_transition"


def test_cancel_after_completed_returns_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    inspection_id = created["id"]
    _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/complete")
    response = _request(_identity(), "POST", f"/api/v1/inspections/{inspection_id}/cancel")
    assert response.status_code == 409
    assert response.json()["error"] == "invalid_transition"


def test_cancel_from_draft_succeeds(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(), "POST", f"/api/v1/inspections/{created['id']}/cancel"
    )
    assert response.status_code == 200
    assert response.json()["status"] == "cancelled"


# --- soft delete ---------------------------------------------------------------


def test_soft_deleted_inspection_is_excluded_from_list_and_get(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    inspection_id = created["id"]

    deleted = _request(_identity(), "DELETE", f"/api/v1/inspections/{inspection_id}")
    assert deleted.status_code == 200
    assert deleted.json() == {"id": inspection_id, "deleted": True}

    after = _request(_identity(), "GET", f"/api/v1/inspections/{inspection_id}")
    assert after.status_code == 404

    listed = _request(_identity(), "GET", "/api/v1/inspections", params={"limit": 100})
    assert inspection_id not in {item["id"] for item in listed.json()["items"]}


# --- filters -------------------------------------------------------------------


def test_list_inspections_filters_by_asset_and_status(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(),
        "GET",
        "/api/v1/inspections",
        params={"asset_id": ASSET_FEED_PUMP_ID, "status": "completed"},
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert len(items) == 1
    assert items[0]["asset_id"] == ASSET_FEED_PUMP_ID
    assert items[0]["status"] == "completed"
