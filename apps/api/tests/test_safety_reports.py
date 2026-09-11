import asyncio
import uuid
from datetime import UTC, datetime
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.safety_reports import SafetyReportRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.safety_reports.constants import SAFETY_CATEGORIES
from app.safety_reports.service import SafetyReportService, get_safety_report_service
from app.storage.service import SafetyEvidenceStorage
from scripts.seed import ACME_COMPANY_ID, MAINTENANCE_TECHNICIAN_UID, run_seed
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.storage import FakeBucket


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    audit = AuditService(AuditLogRepository(client))
    bucket = FakeBucket()
    service = SafetyReportService(
        SafetyReportRepository(client, audit),
        UserRepository(client, audit),
        SafetyEvidenceStorage(bucket),
    )
    app.dependency_overrides[get_safety_report_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "bucket": bucket}
    app.dependency_overrides.pop(get_safety_report_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def identity(role: str = "hse_manager", company_id: str = ACME_COMPANY_ID) -> CurrentUser:
    return CurrentUser(
        uid=role,
        email=f"{role}@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Test",
        role_key=role,
        permissions=SYSTEM_ROLE_TEMPLATES[role].permission_keys,
    )


def request(who: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: who
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def create(who: CurrentUser | None = None) -> Any:
    return request(
        who or identity("field_inspector"),
        "POST",
        "/api/v1/safety-reports",
        json={
            "id": str(uuid.uuid4()),
            "title": "Gas odor near separator",
            "description": "Strong odor detected during inspection.",
            "category": "gas_leak",
            "severity": "critical",
            "occurred_at": datetime.now(UTC).isoformat(),
            "gps_lat": 29.1,
            "gps_lng": -95.4,
        },
    )


def test_dashboard_safety_summary_uses_real_tenant_counts(wiring: dict[str, Any]) -> None:
    assert create().status_code == 200
    response = request(identity(), "GET", "/api/v1/dashboard/safety-summary")
    assert response.status_code == 200
    body = response.json()
    assert body["total"] == 1
    by_category = {row["category"]: row["count"] for row in body["by_category"]}
    assert set(by_category) == set(SAFETY_CATEGORIES)
    assert by_category["gas_leak"] == 1
    assert sum(by_category.values()) == body["total"]


def test_dashboard_safety_summary_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    assert create().status_code == 200
    response = request(
        identity(company_id="beta-utilities"), "GET", "/api/v1/dashboard/safety-summary"
    )
    assert response.status_code == 200
    assert response.json()["total"] == 0
    assert all(row["count"] == 0 for row in response.json()["by_category"])


def test_dashboard_safety_summary_requires_safety_read(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        response = request(identity(role_key), "GET", "/api/v1/dashboard/safety-summary")
        expected = 200 if "safety.read" in template.permission_keys else 403
        assert response.status_code == expected, role_key


def test_dashboard_safety_summary_excludes_soft_deleted_reports(
    wiring: dict[str, Any],
) -> None:
    created = create()
    report_id = created.json()["id"]
    deleted = request(identity(), "DELETE", f"/api/v1/safety-reports/{report_id}")
    assert deleted.status_code == 200
    response = request(identity(), "GET", "/api/v1/dashboard/safety-summary")
    assert response.status_code == 200
    assert response.json()["total"] == 0


def test_reporter_identity_is_server_derived_and_tenant_isolated(wiring: dict[str, Any]) -> None:
    created = create()
    assert created.status_code == 200
    assert created.json()["reporter_id"] == "field_inspector"
    hidden = request(
        identity("hse_manager", "another-company"),
        "GET",
        f"/api/v1/safety-reports/{created.json()['id']}",
    )
    assert hidden.status_code == 404


def test_role_permissions_keep_operations_read_only_and_reporter_from_closing(
    wiring: dict[str, Any],
) -> None:
    assert (
        request(identity("operations_manager"), "GET", "/api/v1/safety-reports").status_code == 200
    )
    assert create(identity("operations_manager")).status_code == 403
    assert (
        request(
            identity("field_inspector"), "POST", "/api/v1/safety-reports/missing/close"
        ).status_code
        == 403
    )
    assert (
        request(identity("hse_manager"), "POST", "/api/v1/safety-reports/missing/close").status_code
        == 404
    )


def test_full_controlled_lifecycle_and_revision_conflict(wiring: dict[str, Any]) -> None:
    report = create().json()
    stale = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/assign",
        json={"manager_id": "hse-1", "expected_revision": 99},
    )
    assert stale.status_code == 409
    assigned = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/assign",
        json={"manager_id": "hse-1", "expected_revision": report["revision"]},
    )
    assert assigned.status_code == 200
    current = assigned.json()
    for status in ("under_review", "corrective_action"):
        response = request(
            identity(),
            "PATCH",
            f"/api/v1/safety-reports/{report['id']}/transition",
            json={"status": status, "expected_revision": current["revision"]},
        )
        assert response.status_code == 200, response.json()
        current = response.json()
    action_id = str(uuid.uuid4())
    added = request(
        identity(),
        "POST",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions",
        json={
            "id": action_id,
            "description": "Remove the immediate hazard",
            "assignee_id": MAINTENANCE_TECHNICIAN_UID,
            "due_date": datetime.now(UTC).isoformat(),
        },
    )
    assert added.status_code == 200
    completed = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions/{action_id}",
        json={"status": "completed", "completion_notes": "Hazard removed."},
    )
    assert completed.status_code == 200
    resolved = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/transition",
        json={"status": "resolved", "expected_revision": completed.json()["revision"]},
    )
    assert resolved.status_code == 200
    closed = request(identity(), "POST", f"/api/v1/safety-reports/{report['id']}/close")
    assert closed.status_code == 200
    assert closed.json()["status"] == "closed"
    assert closed.json()["closed_by"] == "hse_manager"


def test_cannot_skip_lifecycle_or_close_unresolved(wiring: dict[str, Any]) -> None:
    report = create().json()
    skipped = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/transition",
        json={"status": "resolved"},
    )
    assert skipped.status_code == 409
    closed = request(identity(), "POST", f"/api/v1/safety-reports/{report['id']}/close")
    assert closed.status_code == 409


def test_list_filter_and_soft_delete(wiring: dict[str, Any]) -> None:
    report = create().json()
    listed = request(identity(), "GET", "/api/v1/safety-reports", params={"category": "gas_leak"})
    assert report["id"] in {item["id"] for item in listed.json()["items"]}
    deleted = request(identity(), "DELETE", f"/api/v1/safety-reports/{report['id']}")
    assert deleted.status_code == 200
    assert request(identity(), "GET", f"/api/v1/safety-reports/{report['id']}").status_code == 404


def test_private_evidence_upload_delete_and_closed_lock(wiring: dict[str, Any]) -> None:
    report = create().json()
    uploaded = request(
        identity("field_inspector"),
        "POST",
        f"/api/v1/safety-reports/{report['id']}/evidence",
        params={"kind": "photo"},
        files={"file": ("leak.jpg", b"real-image-bytes", "image/jpeg")},
    )
    assert uploaded.status_code == 200, uploaded.json()
    evidence = uploaded.json()["evidence"][0]
    assert evidence["url"].startswith("https://fake-storage.invalid/")
    assert "companies/" in next(iter(wiring["bucket"].objects))
    deleted = request(
        identity("field_inspector"),
        "DELETE",
        f"/api/v1/safety-reports/{report['id']}/evidence/{evidence['id']}",
    )
    assert deleted.status_code == 200
    assert deleted.json()["evidence"] == []


def test_corrective_action_self_service_and_resolution_gate(wiring: dict[str, Any]) -> None:
    report = create().json()
    for status in ("under_review", "corrective_action"):
        response = request(
            identity(),
            "PATCH",
            f"/api/v1/safety-reports/{report['id']}/transition",
            json={"status": status},
        )
        assert response.status_code == 200
    blocked = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/transition",
        json={"status": "resolved"},
    )
    assert blocked.status_code == 409
    action_id = str(uuid.uuid4())
    added = request(
        identity(),
        "POST",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions",
        json={
            "id": action_id,
            "description": "Replace the leaking seal",
            "assignee_id": MAINTENANCE_TECHNICIAN_UID,
            "due_date": datetime.now(UTC).isoformat(),
            "priority": "critical",
        },
    )
    assert added.status_code == 200, added.json()
    technician = identity("maintenance_technician")
    technician = technician.model_copy(update={"uid": MAINTENANCE_TECHNICIAN_UID})
    started = request(
        technician,
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions/{action_id}",
        json={"status": "in_progress"},
    )
    assert started.status_code == 200
    completed = request(
        technician,
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions/{action_id}",
        json={"status": "completed", "completion_notes": "Seal replaced and leak tested."},
    )
    assert completed.status_code == 200
    resolved = request(
        identity(),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/transition",
        json={"status": "resolved"},
    )
    assert resolved.status_code == 200, resolved.json()


def test_non_assignee_cannot_complete_and_cancel_requires_reason(wiring: dict[str, Any]) -> None:
    report = create().json()
    action_id = str(uuid.uuid4())
    assert (
        request(
            identity(),
            "POST",
            f"/api/v1/safety-reports/{report['id']}/corrective-actions",
            json={
                "id": action_id,
                "description": "Barricade the affected area",
                "assignee_id": MAINTENANCE_TECHNICIAN_UID,
                "due_date": datetime.now(UTC).isoformat(),
            },
        ).status_code
        == 200
    )
    forbidden = request(
        identity("operations_manager"),
        "PATCH",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions/{action_id}",
        json={"status": "completed", "completion_notes": "Not my task"},
    )
    assert forbidden.status_code == 403
    invalid = request(
        identity(),
        "POST",
        f"/api/v1/safety-reports/{report['id']}/corrective-actions/{action_id}/cancel",
        json={"reason": ""},
    )
    assert invalid.status_code == 422
