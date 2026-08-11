import asyncio
import uuid
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.work_orders import WorkOrderRepository
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.work_orders.service import WorkOrderService, get_work_order_service
from scripts.seed import (
    ACME_COMPANY_ID,
    ASSET_FEED_PUMP_ID,
    FACILITY_COMPRESSOR_STATION_ID,
    MAINTENANCE_TECHNICIAN_UID,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"
ASSET_COMPRESSOR_ID = f"{ACME_COMPANY_ID}__asset__c-201"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = WorkOrderService(
        work_orders=WorkOrderRepository(client, audit),
        assets=AssetRepository(client, audit),
    )
    app.dependency_overrides[get_work_order_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_work_order_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset(
        {"work_orders.read", "work_orders.write", "work_orders.close"}
    ),
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


def _technician_identity(**overrides: Any) -> CurrentUser:
    defaults: dict[str, Any] = {
        "uid": MAINTENANCE_TECHNICIAN_UID,
        "permissions": frozenset({"work_orders.read", "work_orders.write"}),
    }
    defaults.update(overrides)
    return _identity(**defaults)


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _create_work_order(identity: CurrentUser, **overrides: Any) -> Any:
    payload: dict[str, Any] = {
        "id": str(uuid.uuid4()),
        "asset_id": ASSET_FEED_PUMP_ID,
        "title": "Replace worn gasket",
    }
    payload.update(overrides)
    return _request(identity, "POST", "/api/v1/work-orders", json=payload)


def _assign(identity: CurrentUser, work_order_id: str, **overrides: Any) -> Any:
    payload: dict[str, Any] = {"technician_id": MAINTENANCE_TECHNICIAN_UID}
    payload.update(overrides)
    return _request(
        identity, "PATCH", f"/api/v1/work-orders/{work_order_id}/assign", json=payload
    )


def _accept(identity: CurrentUser, work_order_id: str) -> Any:
    return _request(identity, "POST", f"/api/v1/work-orders/{work_order_id}/accept")


def _submit_for_review(identity: CurrentUser, work_order_id: str, **overrides: Any) -> Any:
    payload: dict[str, Any] = {"completion_notes": "Repair completed."}
    payload.update(overrides)
    return _request(
        identity,
        "PATCH",
        f"/api/v1/work-orders/{work_order_id}/submit-for-review",
        json=payload,
    )


def _close(identity: CurrentUser, work_order_id: str) -> Any:
    return _request(identity, "POST", f"/api/v1/work-orders/{work_order_id}/close")


def _cancel(identity: CurrentUser, work_order_id: str) -> Any:
    return _request(identity, "POST", f"/api/v1/work-orders/{work_order_id}/cancel")


def _walk_to_pending_review(identity: CurrentUser) -> dict[str, Any]:
    created = _create_work_order(identity).json()
    assert _assign(identity, created["id"]).status_code == 200
    assert _accept(_technician_identity(), created["id"]).status_code == 200
    submitted = _submit_for_review(_technician_identity(), created["id"])
    assert submitted.status_code == 200
    return submitted.json()


# --- tenant isolation and RBAC ------------------------------------------------


def test_list_work_orders_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/work-orders", params={"limit": 100})
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 5

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/work-orders")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_get_work_order_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/work-orders/{created['id']}"
    )
    assert response.status_code == 404
    assert response.json()["error"] == "work_order_not_found"


def test_work_order_routes_are_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        read_response = _request(identity, "GET", "/api/v1/work-orders")
        if "work_orders.read" in template.permission_keys:
            assert read_response.status_code == 200, (role_key, read_response.json())
        else:
            assert read_response.status_code == 403, role_key

        write_response = _create_work_order(identity)
        if "work_orders.write" in template.permission_keys:
            assert write_response.status_code == 200, (role_key, write_response.json())
        else:
            assert write_response.status_code == 403, role_key


def test_close_requires_dedicated_permission_not_write(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        response = _close(identity, "does-not-exist")
        if "work_orders.close" in template.permission_keys:
            assert response.status_code == 404, role_key
        else:
            assert response.status_code == 403, role_key
            assert response.json()["error"] == "forbidden"


# --- create --------------------------------------------------------------------


def test_create_work_order_rejects_unknown_asset(wiring: dict[str, Any]) -> None:
    response = _create_work_order(_identity(), asset_id="does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "asset_not_found"


def test_create_work_order_rejects_duplicate_id(wiring: dict[str, Any]) -> None:
    work_order_id = str(uuid.uuid4())
    first = _create_work_order(_identity(), id=work_order_id)
    assert first.status_code == 200
    second = _create_work_order(_identity(), id=work_order_id, title="Different title")
    assert second.status_code == 409
    assert second.json()["error"] == "work_order_id_conflict"


def test_new_work_order_defaults_to_open(wiring: dict[str, Any]) -> None:
    response = _create_work_order(_identity())
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "open"
    assert body["priority"] == "medium"
    assert body["technician_id"] is None
    assert body["revision"] == 1


# --- list filters and pagination ------------------------------------------------


def test_list_work_orders_filters_by_asset_id(wiring: dict[str, Any]) -> None:
    _create_work_order(_identity(), asset_id=ASSET_COMPRESSOR_ID)
    response = _request(
        _identity(), "GET", "/api/v1/work-orders", params={"asset_id": ASSET_COMPRESSOR_ID}
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert items
    assert all(item["asset_id"] == ASSET_COMPRESSOR_ID for item in items)


def test_list_work_orders_filters_by_facility_id(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(),
        "GET",
        "/api/v1/work-orders",
        params={"facility_id": FACILITY_COMPRESSOR_STATION_ID},
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert items
    assert all(item["asset_id"] == ASSET_COMPRESSOR_ID for item in items)


def test_list_work_orders_filters_by_status(wiring: dict[str, Any]) -> None:
    response = _request(_identity(), "GET", "/api/v1/work-orders", params={"status": "closed"})
    assert response.status_code == 200
    items = response.json()["items"]
    assert items
    assert all(item["status"] == "closed" for item in items)


def test_list_work_orders_filters_by_technician_id(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(),
        "GET",
        "/api/v1/work-orders",
        params={"technician_id": MAINTENANCE_TECHNICIAN_UID},
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert items
    assert all(item["technician_id"] == MAINTENANCE_TECHNICIAN_UID for item in items)


def test_list_work_orders_paginates_with_cursor(wiring: dict[str, Any]) -> None:
    first_page = _request(_identity(), "GET", "/api/v1/work-orders", params={"limit": 2})
    assert first_page.status_code == 200
    first_body = first_page.json()
    assert len(first_body["items"]) == 2
    assert first_body["next_cursor"] is not None

    second_page = _request(
        _identity(),
        "GET",
        "/api/v1/work-orders",
        params={"limit": 2, "cursor": first_body["next_cursor"]},
    )
    assert second_page.status_code == 200
    second_body = second_page.json()
    first_ids = {item["id"] for item in first_body["items"]}
    second_ids = {item["id"] for item in second_body["items"]}
    assert first_ids.isdisjoint(second_ids)


# --- assign ----------------------------------------------------------------------


def test_assign_from_open_succeeds(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _assign(_identity(), created["id"])
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "assigned"
    assert body["technician_id"] == MAINTENANCE_TECHNICIAN_UID


def test_reassign_from_assigned_succeeds(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    response = _assign(_identity(), created["id"], technician_id="a-different-technician")
    assert response.status_code == 200
    assert response.json()["technician_id"] == "a-different-technician"


def test_assign_from_in_progress_is_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    assert _accept(_technician_identity(), created["id"]).status_code == 200
    response = _assign(_identity(), created["id"])
    assert response.status_code == 409
    assert response.json()["error"] == "invalid_transition"


def test_assign_rejects_stale_expected_revision(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _assign(_identity(), created["id"], expected_revision=99)
    assert response.status_code == 409
    assert response.json()["error"] == "revision_conflict"


# --- accept ----------------------------------------------------------------------


def test_accept_by_wrong_technician_is_forbidden(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    response = _accept(_identity(uid="someone-else"), created["id"])
    assert response.status_code == 403
    assert response.json()["error"] == "not_assigned_technician"


def test_accept_from_open_is_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _accept(_technician_identity(), created["id"])
    assert response.status_code == 403
    assert response.json()["error"] == "not_assigned_technician"


def test_accept_success_moves_to_in_progress(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    response = _accept(_technician_identity(), created["id"])
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "in_progress"
    assert body["accepted_at"] is not None


# --- submit for review -------------------------------------------------------------


def test_submit_for_review_by_wrong_technician_is_forbidden(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    assert _accept(_technician_identity(), created["id"]).status_code == 200
    response = _submit_for_review(_identity(uid="someone-else"), created["id"])
    assert response.status_code == 403
    assert response.json()["error"] == "not_assigned_technician"


def test_submit_for_review_from_assigned_is_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    response = _submit_for_review(_technician_identity(), created["id"])
    assert response.status_code == 409
    assert response.json()["error"] == "invalid_transition"


def test_submit_for_review_rejects_stale_expected_revision(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    assert _accept(_technician_identity(), created["id"]).status_code == 200
    response = _submit_for_review(
        _technician_identity(), created["id"], expected_revision=99
    )
    assert response.status_code == 409
    assert response.json()["error"] == "revision_conflict"


def test_submit_for_review_success_moves_to_pending_review(wiring: dict[str, Any]) -> None:
    body = _walk_to_pending_review(_identity())
    assert body["status"] == "pending_review"
    assert body["completion_notes"] == "Repair completed."


# --- close -----------------------------------------------------------------------


def test_close_by_technician_is_forbidden(wiring: dict[str, Any]) -> None:
    submitted = _walk_to_pending_review(_identity())
    response = _close(_technician_identity(), submitted["id"])
    assert response.status_code == 403
    assert response.json()["error"] == "forbidden"


def test_close_by_supervisor_succeeds(wiring: dict[str, Any]) -> None:
    submitted = _walk_to_pending_review(_identity())
    response = _close(_identity(), submitted["id"])
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "closed"
    assert body["closed_at"] is not None


def test_close_from_in_progress_is_invalid_transition(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    assert _assign(_identity(), created["id"]).status_code == 200
    assert _accept(_technician_identity(), created["id"]).status_code == 200
    response = _close(_identity(), created["id"])
    assert response.status_code == 409
    assert response.json()["error"] == "invalid_transition"


# --- cancel ----------------------------------------------------------------------


def test_cancel_from_open_succeeds(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _cancel(_identity(), created["id"])
    assert response.status_code == 200
    assert response.json()["status"] == "cancelled"


def test_cancel_from_pending_review_succeeds(wiring: dict[str, Any]) -> None:
    submitted = _walk_to_pending_review(_identity())
    response = _cancel(_identity(), submitted["id"])
    assert response.status_code == 200
    assert response.json()["status"] == "cancelled"


def test_cancel_from_closed_is_invalid_transition(wiring: dict[str, Any]) -> None:
    submitted = _walk_to_pending_review(_identity())
    assert _close(_identity(), submitted["id"]).status_code == 200
    response = _cancel(_identity(), submitted["id"])
    assert response.status_code == 409
    assert response.json()["error"] == "invalid_transition"


# --- delete ----------------------------------------------------------------------


def test_delete_work_order_soft_deletes(wiring: dict[str, Any]) -> None:
    created = _create_work_order(_identity()).json()
    response = _request(_identity(), "DELETE", f"/api/v1/work-orders/{created['id']}")
    assert response.status_code == 200
    assert response.json() == {"id": created["id"], "deleted": True}

    listed = _request(_identity(), "GET", "/api/v1/work-orders", params={"limit": 100})
    assert created["id"] not in {item["id"] for item in listed.json()["items"]}

    fetched = _request(_identity(), "GET", f"/api/v1/work-orders/{created['id']}")
    assert fetched.status_code == 404
