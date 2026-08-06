import asyncio
import uuid
from datetime import UTC, datetime
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.assets.service import AssetManagementService, get_asset_management_service
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.inspections import InspectionRepository
from app.inspections.service import InspectionService, get_inspection_service
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.storage.service import AssetMediaStorage, InspectionMediaStorage
from scripts.seed import (
    ACME_COMPANY_ID,
    ASSET_FEED_PUMP_ID,
    CHECKLIST_TEMPLATE_PUMP_ID,
    CHECKLIST_TEMPLATE_TANK_ID,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.storage import FakeBucket

BETA_COMPANY_ID = "beta-utilities"
CLIENT_CREATED_AT = "2026-07-20T10:00:00Z"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    bucket = FakeBucket()
    service = InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
        storage=InspectionMediaStorage(bucket),
    )

    app.dependency_overrides[get_inspection_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "bucket": bucket}
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


def test_assign_checklist_template_accepts_correct_expected_revision(
    wiring: dict[str, Any],
) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "POST",
        f"/api/v1/inspections/{created['id']}/checklist-template",
        json={
            "checklist_template_id": CHECKLIST_TEMPLATE_PUMP_ID,
            "expected_revision": created["revision"],
        },
    )
    assert response.status_code == 200
    assert response.json()["revision"] == created["revision"] + 1


def test_assign_checklist_template_rejects_stale_expected_revision(
    wiring: dict[str, Any],
) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "POST",
        f"/api/v1/inspections/{created['id']}/checklist-template",
        json={
            "checklist_template_id": CHECKLIST_TEMPLATE_PUMP_ID,
            "expected_revision": created["revision"] + 99,
        },
    )
    assert response.status_code == 409
    assert response.json()["error"] == "revision_conflict"


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


def test_checklist_response_partial_update_preserves_other_answers(
    wiring: dict[str, Any],
) -> None:
    """Autosaving one item at a time (7.3's continuous-autosave UX) must not
    erase items answered in an earlier PATCH -- each PATCH upserts by item_id
    rather than replacing the whole checklist_responses array."""
    created = _create_inspection(_identity()).json()
    inspection_id = created["id"]
    _assign_pump_template(_identity(), inspection_id)

    first = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{inspection_id}",
        json={"checklist_responses": [{"item_id": "vibration_normal", "value": True}]},
    )
    assert {r["item_id"] for r in first.json()["checklist_responses"]} == {"vibration_normal"}

    second = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{inspection_id}",
        json={"checklist_responses": [{"item_id": "bearing_temp_f", "value": 140.0}]},
    )
    assert second.status_code == 200
    by_item = {r["item_id"]: r["value"] for r in second.json()["checklist_responses"]}
    assert by_item == {"vibration_normal": True, "bearing_temp_f": 140.0}

    # Re-answering an already-set item updates it in place rather than duplicating it.
    third = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{inspection_id}",
        json={"checklist_responses": [{"item_id": "vibration_normal", "value": False}]},
    )
    responses = third.json()["checklist_responses"]
    assert len(responses) == 2
    by_item = {r["item_id"]: r["value"] for r in responses}
    assert by_item == {"vibration_normal": False, "bearing_temp_f": 140.0}


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


# --- media (Phase 7.4) -----------------------------------------------------


def _media_path(company_id: str, inspection_id: str, local_id: str, filename: str) -> str:
    return f"companies/{company_id}/inspections/{inspection_id}/media/{local_id}_{filename}"


def _attach_media(
    identity: CurrentUser,
    inspection_id: str,
    *,
    local_id: str,
    filename: str = "photo.jpg",
    kind: str = "photo",
    content_type: str = "image/jpeg",
    size: int = 100,
    captured_at: str = "2026-08-01T10:00:00Z",
    **overrides: Any,
) -> Any:
    payload: dict[str, Any] = {
        "local_id": local_id,
        "filename": filename,
        "kind": kind,
        "content_type": content_type,
        "size": size,
        "captured_at": captured_at,
    }
    payload.update(overrides)
    return _request(
        identity, "POST", f"/api/v1/inspections/{inspection_id}/media", json=payload
    )


def test_attach_inspection_media_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg"),
        b"real-image-bytes",
        "image/jpeg",
    )
    response = _attach_media(_identity(), created["id"], local_id=local_id)
    assert response.status_code == 200
    media = response.json()["media"]
    assert len(media) == 1
    assert media[0]["local_id"] == local_id
    assert media[0]["kind"] == "photo"
    assert media[0]["filename"] == "photo.jpg"
    assert media[0]["url"].startswith("https://fake-storage.invalid/")
    assert media[0]["size"] == len(b"real-image-bytes")
    # attach never bumps revision -- must never collide with checklist autosave.
    assert response.json()["revision"] == created["revision"]


def test_attach_inspection_media_idempotent_replay(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    # 100 bytes to match `_attach_media`'s default `size=100` -- the service
    # trusts Storage-reported size/content_type over the client-asserted
    # request fields, so a true idempotent replay needs both to agree.
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg"),
        b"x" * 100,
        "image/jpeg",
    )
    first = _attach_media(_identity(), created["id"], local_id=local_id)
    assert first.status_code == 200
    second = _attach_media(_identity(), created["id"], local_id=local_id)
    assert second.status_code == 200
    assert len(second.json()["media"]) == 1


def test_attach_inspection_media_conflicting_replay_returns_409(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg"),
        b"bytes",
        "image/jpeg",
    )
    first = _attach_media(_identity(), created["id"], local_id=local_id)
    assert first.status_code == 200
    conflicting = _attach_media(
        _identity(), created["id"], local_id=local_id, filename="different.jpg"
    )
    assert conflicting.status_code == 409
    assert conflicting.json()["error"] == "media_reference_conflict"


def test_attach_inspection_media_requires_uploaded_blob(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _attach_media(_identity(), created["id"], local_id=str(uuid.uuid4()))
    assert response.status_code == 422
    assert response.json()["error"] == "media_not_uploaded"


def test_attach_inspection_media_rejects_wrong_content_type(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "doc.pdf"),
        b"bytes",
        "application/pdf",
    )
    response = _attach_media(
        _identity(), created["id"], local_id=local_id, filename="doc.pdf"
    )
    assert response.status_code == 422
    assert response.json()["error"] == "media_content_type_invalid"


def test_attach_inspection_media_rejects_oversized_blob(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "huge.jpg"),
        b"x" * (16 * 1024 * 1024),
        "image/jpeg",
    )
    response = _attach_media(
        _identity(), created["id"], local_id=local_id, filename="huge.jpg"
    )
    assert response.status_code == 413
    assert response.json()["error"] == "media_too_large"


def test_attach_inspection_media_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _attach_media(
        _identity(company_id=BETA_COMPANY_ID), created["id"], local_id=str(uuid.uuid4())
    )
    assert response.status_code == 404
    assert response.json()["error"] == "inspection_not_found"


def test_update_inspection_media_sets_checklist_link_and_tag(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg"),
        b"bytes",
        "image/jpeg",
    )
    attached = _attach_media(_identity(), created["id"], local_id=local_id).json()
    media_id = attached["media"][0]["id"]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/media/{media_id}",
        json={"checklist_item_id": "vibration_normal", "before_after_tag": "before"},
    )
    assert response.status_code == 200
    media = response.json()["media"][0]
    assert media["checklist_item_id"] == "vibration_normal"
    assert media["before_after_tag"] == "before"


def test_update_inspection_media_is_idempotent_on_missing(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/media/does-not-exist",
        json={"before_after_tag": "after"},
    )
    assert response.status_code == 200
    assert response.json()["media"] == []


def test_detach_inspection_media_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    path = _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg")
    wiring["bucket"].seed(path, b"bytes", "image/jpeg")
    attached = _attach_media(_identity(), created["id"], local_id=local_id).json()
    media_id = attached["media"][0]["id"]

    response = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/media/{media_id}"
    )
    assert response.status_code == 200
    assert response.json()["media"] == []
    # The backend never deletes Storage bytes on detach (direct-upload design).
    assert path in wiring["bucket"].objects


def test_detach_inspection_media_replay_is_idempotent(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _media_path(ACME_COMPANY_ID, created["id"], local_id, "photo.jpg"),
        b"bytes",
        "image/jpeg",
    )
    attached = _attach_media(_identity(), created["id"], local_id=local_id).json()
    media_id = attached["media"][0]["id"]

    first = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/media/{media_id}"
    )
    assert first.status_code == 200
    second = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/media/{media_id}"
    )
    assert second.status_code == 200
    assert second.json()["media"] == []


# --- voice notes (Phase 7.6) -------------------------------------------------


def _voice_path(company_id: str, inspection_id: str, local_id: str, filename: str) -> str:
    return f"companies/{company_id}/inspections/{inspection_id}/voice/{local_id}_{filename}"


def _attach_voice_note(
    identity: CurrentUser,
    inspection_id: str,
    *,
    local_id: str,
    filename: str = "note.m4a",
    content_type: str = "audio/mp4",
    size: int = 100,
    duration_ms: int = 5000,
    **overrides: Any,
) -> Any:
    payload: dict[str, Any] = {
        "local_id": local_id,
        "filename": filename,
        "content_type": content_type,
        "size": size,
        "duration_ms": duration_ms,
    }
    payload.update(overrides)
    return _request(
        identity, "POST", f"/api/v1/inspections/{inspection_id}/voice-notes", json=payload
    )


def test_attach_inspection_voice_note_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"real-audio-bytes",
        "audio/mp4",
    )
    response = _attach_voice_note(_identity(), created["id"], local_id=local_id)
    assert response.status_code == 200
    voice_notes = response.json()["voice_notes"]
    assert len(voice_notes) == 1
    assert voice_notes[0]["local_id"] == local_id
    assert voice_notes[0]["filename"] == "note.m4a"
    assert voice_notes[0]["url"].startswith("https://fake-storage.invalid/")
    assert voice_notes[0]["size"] == len(b"real-audio-bytes")
    assert voice_notes[0]["duration_ms"] == 5000
    assert voice_notes[0]["checklist_item_id"] is None
    # attach never bumps revision -- must never collide with checklist autosave.
    assert response.json()["revision"] == created["revision"]


def test_attach_inspection_voice_note_idempotent_replay(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"x" * 100,
        "audio/mp4",
    )
    first = _attach_voice_note(_identity(), created["id"], local_id=local_id)
    assert first.status_code == 200
    second = _attach_voice_note(_identity(), created["id"], local_id=local_id)
    assert second.status_code == 200
    assert len(second.json()["voice_notes"]) == 1


def test_attach_inspection_voice_note_conflicting_replay_returns_409(
    wiring: dict[str, Any]
) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"bytes",
        "audio/mp4",
    )
    first = _attach_voice_note(_identity(), created["id"], local_id=local_id)
    assert first.status_code == 200
    conflicting = _attach_voice_note(
        _identity(), created["id"], local_id=local_id, filename="different.m4a"
    )
    assert conflicting.status_code == 409
    assert conflicting.json()["error"] == "voice_note_reference_conflict"


def test_attach_inspection_voice_note_requires_uploaded_blob(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _attach_voice_note(_identity(), created["id"], local_id=str(uuid.uuid4()))
    assert response.status_code == 422
    assert response.json()["error"] == "voice_note_not_uploaded"


def test_attach_inspection_voice_note_rejects_wrong_content_type(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.wav"),
        b"bytes",
        "audio/wav",
    )
    response = _attach_voice_note(
        _identity(), created["id"], local_id=local_id, filename="note.wav"
    )
    assert response.status_code == 422
    assert response.json()["error"] == "voice_note_content_type_invalid"


def test_attach_inspection_voice_note_rejects_oversized_blob(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "huge.m4a"),
        b"x" * (21 * 1024 * 1024),
        "audio/mp4",
    )
    response = _attach_voice_note(
        _identity(), created["id"], local_id=local_id, filename="huge.m4a"
    )
    assert response.status_code == 413
    assert response.json()["error"] == "voice_note_too_large"


def test_attach_inspection_voice_note_rejects_too_long_duration(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"bytes",
        "audio/mp4",
    )
    response = _attach_voice_note(
        _identity(), created["id"], local_id=local_id, duration_ms=10 * 60 * 1000 + 1
    )
    assert response.status_code == 422
    assert response.json()["error"] == "voice_note_too_long"


def test_attach_inspection_voice_note_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _attach_voice_note(
        _identity(company_id=BETA_COMPANY_ID), created["id"], local_id=str(uuid.uuid4())
    )
    assert response.status_code == 404
    assert response.json()["error"] == "inspection_not_found"


def test_update_inspection_voice_note_sets_checklist_link(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"bytes",
        "audio/mp4",
    )
    attached = _attach_voice_note(_identity(), created["id"], local_id=local_id).json()
    voice_note_id = attached["voice_notes"][0]["id"]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/voice-notes/{voice_note_id}",
        json={"checklist_item_id": "vibration_normal"},
    )
    assert response.status_code == 200
    assert response.json()["voice_notes"][0]["checklist_item_id"] == "vibration_normal"


def test_update_inspection_voice_note_is_idempotent_on_missing(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/voice-notes/does-not-exist",
        json={"checklist_item_id": "vibration_normal"},
    )
    assert response.status_code == 200
    assert response.json()["voice_notes"] == []


def test_detach_inspection_voice_note_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    path = _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a")
    wiring["bucket"].seed(path, b"bytes", "audio/mp4")
    attached = _attach_voice_note(_identity(), created["id"], local_id=local_id).json()
    voice_note_id = attached["voice_notes"][0]["id"]

    response = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/voice-notes/{voice_note_id}"
    )
    assert response.status_code == 200
    assert response.json()["voice_notes"] == []
    # The backend never deletes Storage bytes on detach (direct-upload design).
    assert path in wiring["bucket"].objects


def test_detach_inspection_voice_note_replay_is_idempotent(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    local_id = str(uuid.uuid4())
    wiring["bucket"].seed(
        _voice_path(ACME_COMPANY_ID, created["id"], local_id, "note.m4a"),
        b"bytes",
        "audio/mp4",
    )
    attached = _attach_voice_note(_identity(), created["id"], local_id=local_id).json()
    voice_note_id = attached["voice_notes"][0]["id"]

    first = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/voice-notes/{voice_note_id}"
    )
    assert first.status_code == 200
    second = _request(
        _identity(), "DELETE", f"/api/v1/inspections/{created['id']}/voice-notes/{voice_note_id}"
    )
    assert second.status_code == 200
    assert second.json()["voice_notes"] == []


# --- annotations (Phase 7.5) -------------------------------------------------


def _attach_photo(identity: CurrentUser, bucket: Any, inspection_id: str) -> str:
    """Seeds a real photo and attaches it, returning its `local_id` -- the
    stable client-generated key annotations reference (works even before a
    media item has synced/been assigned a server `id`)."""
    local_id = str(uuid.uuid4())
    wiring_path = _media_path(ACME_COMPANY_ID, inspection_id, local_id, "photo.jpg")
    bucket.seed(wiring_path, b"bytes", "image/jpeg")
    attached = _attach_media(identity, inspection_id, local_id=local_id)
    assert attached.status_code == 200
    return local_id


def _create_annotation(
    identity: CurrentUser,
    inspection_id: str,
    *,
    annotation_id: str | None = None,
    media_local_id: str,
    shape: str = "rectangle",
    points: list[dict[str, float]] | None = None,
    color: str = "#FF0000",
    damage_type: str | None = "corrosion",
    note: str | None = "Visible corrosion on flange",
    **overrides: Any,
) -> Any:
    payload: dict[str, Any] = {
        "id": annotation_id or str(uuid.uuid4()),
        "media_local_id": media_local_id,
        "shape": shape,
        "points": points or [{"x": 0.1, "y": 0.1}, {"x": 0.4, "y": 0.4}],
        "color": color,
        "damage_type": damage_type,
        "note": note,
    }
    payload.update(overrides)
    return _request(
        identity, "POST", f"/api/v1/inspections/{inspection_id}/annotations", json=payload
    )


def test_create_annotation_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])

    response = _create_annotation(_identity(), created["id"], media_local_id=media_local_id)
    assert response.status_code == 200
    annotations = response.json()["annotations"]
    assert len(annotations) == 1
    annotation = annotations[0]
    assert annotation["media_local_id"] == media_local_id
    assert annotation["shape"] == "rectangle"
    assert annotation["points"] == [{"x": 0.1, "y": 0.1}, {"x": 0.4, "y": 0.4}]
    assert annotation["color"] == "#FF0000"
    assert annotation["damage_type"] == "corrosion"
    assert annotation["note"] == "Visible corrosion on flange"
    assert annotation["source"] == "manual"
    assert annotation["confidence"] is None
    assert annotation["created_by"] == "test-user"
    # annotation traffic never bumps revision -- must never collide with
    # the checklist-autosave revision protocol, same as media.
    assert response.json()["revision"] == created["revision"]


def test_create_annotation_rejects_unknown_media(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _create_annotation(
        _identity(), created["id"], media_local_id=str(uuid.uuid4())
    )
    assert response.status_code == 404
    assert response.json()["error"] == "media_not_found"


def test_create_annotation_idempotent_replay(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    annotation_id = str(uuid.uuid4())

    first = _create_annotation(
        _identity(), created["id"], annotation_id=annotation_id, media_local_id=media_local_id
    )
    assert first.status_code == 200
    second = _create_annotation(
        _identity(), created["id"], annotation_id=annotation_id, media_local_id=media_local_id
    )
    assert second.status_code == 200
    assert len(second.json()["annotations"]) == 1


def test_create_annotation_conflicting_replay_returns_409(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    annotation_id = str(uuid.uuid4())

    first = _create_annotation(
        _identity(), created["id"], annotation_id=annotation_id, media_local_id=media_local_id
    )
    assert first.status_code == 200
    conflicting = _create_annotation(
        _identity(),
        created["id"],
        annotation_id=annotation_id,
        media_local_id=media_local_id,
        color="#00FF00",
    )
    assert conflicting.status_code == 409
    assert conflicting.json()["error"] == "annotation_conflict"


def test_create_annotation_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    response = _create_annotation(
        _identity(company_id=BETA_COMPANY_ID), created["id"], media_local_id=media_local_id
    )
    assert response.status_code == 404
    assert response.json()["error"] == "inspection_not_found"


def test_update_annotation_edits_note_and_damage_type(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    attached = _create_annotation(_identity(), created["id"], media_local_id=media_local_id).json()
    annotation_id = attached["annotations"][0]["id"]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/annotations/{annotation_id}",
        json={"damage_type": "crack", "note": "Updated note"},
    )
    assert response.status_code == 200
    annotation = response.json()["annotations"][0]
    assert annotation["damage_type"] == "crack"
    assert annotation["note"] == "Updated note"
    # unrelated fields are preserved, not clobbered by the partial update.
    assert annotation["color"] == "#FF0000"


def test_update_annotation_moves_points(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    attached = _create_annotation(_identity(), created["id"], media_local_id=media_local_id).json()
    annotation_id = attached["annotations"][0]["id"]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/annotations/{annotation_id}",
        json={"points": [{"x": 0.2, "y": 0.2}, {"x": 0.5, "y": 0.5}]},
    )
    assert response.status_code == 200
    annotation = response.json()["annotations"][0]
    assert annotation["points"] == [{"x": 0.2, "y": 0.2}, {"x": 0.5, "y": 0.5}]


def test_update_annotation_is_idempotent_on_missing(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}/annotations/does-not-exist",
        json={"note": "irrelevant"},
    )
    assert response.status_code == 200
    assert response.json()["annotations"] == []


def test_delete_annotation_success(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    attached = _create_annotation(_identity(), created["id"], media_local_id=media_local_id).json()
    annotation_id = attached["annotations"][0]["id"]

    response = _request(
        _identity(),
        "DELETE",
        f"/api/v1/inspections/{created['id']}/annotations/{annotation_id}",
    )
    assert response.status_code == 200
    assert response.json()["annotations"] == []


def test_delete_annotation_replay_is_idempotent(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    attached = _create_annotation(_identity(), created["id"], media_local_id=media_local_id).json()
    annotation_id = attached["annotations"][0]["id"]

    first = _request(
        _identity(),
        "DELETE",
        f"/api/v1/inspections/{created['id']}/annotations/{annotation_id}",
    )
    assert first.status_code == 200
    second = _request(
        _identity(),
        "DELETE",
        f"/api/v1/inspections/{created['id']}/annotations/{annotation_id}",
    )
    assert second.status_code == 200
    assert second.json()["annotations"] == []


def test_annotation_survives_inspection_sync_round_trip(wiring: dict[str, Any]) -> None:
    """An annotation persists unchanged across an unrelated inspection PATCH
    (the checklist-autosave path) -- proves the two protocols never collide."""
    created = _create_inspection(_identity()).json()
    media_local_id = _attach_photo(_identity(), wiring["bucket"], created["id"])
    attached = _create_annotation(_identity(), created["id"], media_local_id=media_local_id).json()
    annotation_before = attached["annotations"][0]

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "unrelated autosave edit"},
    )
    assert response.status_code == 200
    assert response.json()["annotations"] == [annotation_before]


# --- manual status readings + asset health rollup (Phase 7.7) ----------------


def _put_readings(
    identity: CurrentUser, inspection_id: str, **overrides: Any
) -> Any:
    payload: dict[str, Any] = {"condition": "Good"}
    payload.update(overrides)
    return _request(
        identity, "PATCH", f"/api/v1/inspections/{inspection_id}", json={"readings": payload}
    )


def _asset_status(wiring: dict[str, Any], asset_id: str = ASSET_FEED_PUMP_ID) -> str:
    repo = AssetRepository(wiring["client"], AuditService(AuditLogRepository(wiring["client"])))
    asset = asyncio.run(repo.get(CompanyScope(company_id=ACME_COMPANY_ID), asset_id))
    assert asset is not None
    return asset.current_status


def test_readings_persist_with_server_stamped_recorded_fields(
    wiring: dict[str, Any],
) -> None:
    created = _create_inspection(_identity()).json()
    response = _put_readings(
        _identity(),
        created["id"],
        condition="Fair",
        temperature_c=72.5,
        pressure_bar=4.1,
        noise_level_db=88.0,
        vibration_observation="Slight rattle near the coupling",
        leak_observed=False,
        operational_status="degraded",
        comments="Bearing noise increasing",
        recommendations="Schedule bearing replacement",
        priority_level="high",
        recorded_at="2020-01-01T00:00:00Z",
        recorded_by="someone-else",
    )
    assert response.status_code == 200
    readings = response.json()["readings"]
    assert readings["condition"] == "Fair"
    assert readings["temperature_c"] == 72.5
    assert readings["pressure_bar"] == 4.1
    assert readings["noise_level_db"] == 88.0
    assert readings["vibration_observation"] == "Slight rattle near the coupling"
    assert readings["leak_observed"] is False
    assert readings["operational_status"] == "degraded"
    assert readings["priority_level"] == "high"
    # recorded_at/recorded_by are never client-controlled -- server stamps them.
    assert readings["recorded_by"] == "test-user"
    assert readings["recorded_at"] != "2020-01-01T00:00:00Z"


def test_readings_condition_is_required(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"readings": {"temperature_c": 70}},
    )
    assert response.status_code == 422


def test_readings_update_replaces_whole_object(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _put_readings(_identity(), created["id"], condition="Poor", comments="First pass")
    second = _put_readings(_identity(), created["id"], condition="Good")
    readings = second.json()["readings"]
    assert readings["condition"] == "Good"
    assert readings["comments"] is None


def test_readings_locked_once_completed(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    complete = _request(_identity(), "POST", f"/api/v1/inspections/{created['id']}/complete")
    assert complete.status_code == 200

    response = _put_readings(_identity(), created["id"], condition="Poor")
    assert response.status_code == 409
    assert response.json()["error"] == "inspection_locked"


def test_readings_survive_unrelated_inspection_patch(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    saved = _put_readings(_identity(), created["id"], condition="Excellent").json()

    response = _request(
        _identity(),
        "PATCH",
        f"/api/v1/inspections/{created['id']}",
        json={"notes": "unrelated autosave edit"},
    )
    assert response.status_code == 200
    assert response.json()["readings"] == saved["readings"]


@pytest.mark.parametrize(
    ("condition", "expected_status"),
    [
        ("Excellent", "Healthy"),
        ("Good", "Healthy"),
        ("Fair", "Warning"),
        ("Poor", "Warning"),
        ("Critical", "Critical"),
    ],
)
def test_complete_inspection_rolls_up_asset_health(
    wiring: dict[str, Any], condition: str, expected_status: str
) -> None:
    created = _create_inspection(_identity()).json()
    _put_readings(_identity(), created["id"], condition=condition)

    response = _request(_identity(), "POST", f"/api/v1/inspections/{created['id']}/complete")
    assert response.status_code == 200
    assert _asset_status(wiring) == expected_status


def test_complete_inspection_without_readings_leaves_asset_status_untouched(
    wiring: dict[str, Any],
) -> None:
    assert _asset_status(wiring) == "Healthy"
    created = _create_inspection(_identity()).json()

    response = _request(_identity(), "POST", f"/api/v1/inspections/{created['id']}/complete")
    assert response.status_code == 200
    assert _asset_status(wiring) == "Healthy"


def test_draft_readings_edit_does_not_change_asset_status(wiring: dict[str, Any]) -> None:
    assert _asset_status(wiring) == "Healthy"
    created = _create_inspection(_identity()).json()

    response = _put_readings(_identity(), created["id"], condition="Critical")
    assert response.status_code == 200
    assert _asset_status(wiring) == "Healthy"


def test_asset_status_rollup_is_audited(wiring: dict[str, Any]) -> None:
    created = _create_inspection(_identity()).json()
    _put_readings(_identity(), created["id"], condition="Critical")
    _request(_identity(), "POST", f"/api/v1/inspections/{created['id']}/complete")

    logs = asyncio.run(
        AuditLogRepository(wiring["client"]).list_since(
            CompanyScope(company_id=ACME_COMPANY_ID),
            datetime(2020, 1, 1, tzinfo=UTC),
        )
    )
    matching = [
        entry
        for entry in logs
        if entry.action == "asset.status_rolled_up" and entry.target_id == ASSET_FEED_PUMP_ID
    ]
    assert len(matching) == 1
    assert matching[0].metadata == {
        "from": "Healthy",
        "to": "Critical",
        "inspection_id": created["id"],
    }


def test_completed_critical_inspection_moves_dashboard_critical_assets_kpi(
    wiring: dict[str, Any],
) -> None:
    """Cross-checks the 7.7 rollup against the real 4.4 dashboard KPI query."""
    client = wiring["client"]
    audit = AuditService(AuditLogRepository(client))
    asset_service = AssetManagementService(
        assets=AssetRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        inspections=InspectionRepository(client, audit),
        storage=AssetMediaStorage(FakeBucket()),
    )
    app.dependency_overrides[get_asset_management_service] = lambda: asset_service
    try:
        before = _request(
            _identity(permissions=frozenset({"inspections.read", "inspections.write", "assets.read"})),
            "GET",
            "/api/v1/dashboard/assets-summary",
        ).json()

        created = _create_inspection(_identity()).json()
        _put_readings(_identity(), created["id"], condition="Critical")
        complete = _request(
            _identity(), "POST", f"/api/v1/inspections/{created['id']}/complete"
        )
        assert complete.status_code == 200

        after = _request(
            _identity(permissions=frozenset({"inspections.read", "inspections.write", "assets.read"})),
            "GET",
            "/api/v1/dashboard/assets-summary",
        ).json()
        assert after["critical"] == before["critical"] + 1
        assert after["healthy"] == before["healthy"] - 1
    finally:
        app.dependency_overrides.pop(get_asset_management_service, None)
