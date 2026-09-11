import asyncio
from datetime import UTC, datetime, timedelta
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.permit_templates import PermitTemplateRepository
from app.db.repositories.permits import PermitRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.permit_templates.service import PermitTemplateService, get_permit_template_service
from app.permits.service import PermitService, get_permit_service
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import (
    ACME_COMPANY_ID,
    AREA_PROCESS_UNIT_1_ID,
    ASSET_FEED_PUMP_ID,
    FACILITY_NORTH_REFINERY_ID,
    role_id,
    run_seed,
)
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"
WORKER_ID = "demo-acme-field_inspector"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    audit = AuditService(AuditLogRepository(client))
    templates = PermitTemplateRepository(client, audit)
    template_service = PermitTemplateService(templates, RoleRepository(client, audit))
    permit_service = PermitService(
        PermitRepository(client, audit),
        templates,
        UserRepository(client, audit),
        FacilityRepository(client, audit),
        AreaRepository(client, audit),
        AssetRepository(client, audit),
    )
    app.dependency_overrides[get_permit_template_service] = lambda: template_service
    app.dependency_overrides[get_permit_service] = lambda: permit_service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "permit_service": permit_service}
    app.dependency_overrides.pop(get_permit_template_service, None)
    app.dependency_overrides.pop(get_permit_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def identity(role: str = "operations_manager", company_id: str = ACME_COMPANY_ID) -> CurrentUser:
    return CurrentUser(
        uid=(f"demo-acme-{role}" if company_id == ACME_COMPANY_ID else role),
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


def create_template() -> dict[str, Any]:
    response = request(
        identity(),
        "POST",
        "/api/v1/permit-templates",
        json={
            "name": "Hot work controlled task",
            "permit_type": "hot_work",
            "checklist_items": [
                {"id": "gas-test", "label": "Gas test completed"},
                {"id": "extinguisher", "label": "Extinguisher available"},
            ],
            "approval_steps": [
                {
                    "id": "operations",
                    "label": "Operations approval",
                    "approver_role_id": role_id(ACME_COMPANY_ID, "operations_manager"),
                },
                {
                    "id": "hse",
                    "label": "HSE approval",
                    "approver_role_id": role_id(ACME_COMPANY_ID, "hse_manager"),
                },
            ],
        },
    )
    assert response.status_code == 201
    return response.json()


def payload(template_id: str, **overrides: Any) -> dict[str, Any]:
    result: dict[str, Any] = {
        "title": "Weld process line support",
        "description": "Repair the cracked process line support using controlled hot work.",
        "permit_type": "hot_work",
        "facility_id": FACILITY_NORTH_REFINERY_ID,
        "area_id": AREA_PROCESS_UNIT_1_ID,
        "asset_id": ASSET_FEED_PUMP_ID,
        "valid_from": (datetime.now(UTC) + timedelta(hours=1)).isoformat(),
        "valid_until": (datetime.now(UTC) + timedelta(hours=8)).isoformat(),
        "template_id": template_id,
        "risk_assessment": [
            {
                "hazard": "Ignition of flammable vapour",
                "persons_at_risk": "Welders and nearby operators",
                "initial_likelihood": 4,
                "initial_severity": 5,
                "controls": "Isolate, gas test, ventilate, and maintain a fire watch.",
                "residual_likelihood": 1,
                "residual_severity": 5,
            }
        ],
        "worker_ids": [WORKER_ID],
    }
    result.update(overrides)
    return result


def create_permit(**overrides: Any) -> Any:
    template = create_template()
    return request(identity(), "POST", "/api/v1/permits", json=payload(template["id"], **overrides))


def test_create_calculates_risk_and_freezes_template_snapshot(wiring: dict[str, Any]) -> None:
    response = create_permit()
    assert response.status_code == 201
    body = response.json()
    assert body["permit_number"].startswith(f"PTW-{datetime.now(UTC).strftime('%Y%m%d')}-")
    assert body["status"] == "draft"
    assert body["risk_assessment"][0]["initial_score"] == 20
    assert body["risk_assessment"][0]["initial_band"] == "critical"
    assert body["risk_assessment"][0]["residual_score"] == 5
    assert body["risk_assessment"][0]["residual_band"] == "medium"
    assert [row["template_item_id"] for row in body["checklist_snapshot"]] == [
        "gas-test",
        "extinguisher",
    ]
    assert [row["template_step_id"] for row in body["approval_snapshot"]] == [
        "operations",
        "hse",
    ]


def test_snapshot_survives_later_template_update(wiring: dict[str, Any]) -> None:
    created = create_permit().json()
    updated = request(
        identity(),
        "PATCH",
        f"/api/v1/permit-templates/{created['template_id']}",
        json={
            "expected_version": 1,
            "checklist_items": [{"id": "replacement", "label": "Replacement control"}],
        },
    )
    assert updated.status_code == 200
    detail = request(identity(), "GET", f"/api/v1/permits/{created['id']}").json()
    assert detail["template_version"] == 1
    assert [row["template_item_id"] for row in detail["checklist_snapshot"]] == [
        "gas-test",
        "extinguisher",
    ]


def test_role_matrix_for_read_and_write(wiring: dict[str, Any]) -> None:
    template = create_template()
    for role_key, role in SYSTEM_ROLE_TEMPLATES.items():
        who = identity(role_key)
        listing = request(who, "GET", "/api/v1/permits")
        assert listing.status_code == (200 if "permits.read" in role.permission_keys else 403)
        created = request(
            who, "POST", "/api/v1/permits", json=payload(template["id"], title=role_key)
        )
        assert created.status_code == (201 if "permits.write" in role.permission_keys else 403)


def test_tenant_isolation_hides_record(wiring: dict[str, Any]) -> None:
    created = create_permit().json()
    beta = identity("operations_manager", BETA_COMPANY_ID)
    assert request(beta, "GET", "/api/v1/permits").json()["items"] == []
    hidden = request(beta, "GET", f"/api/v1/permits/{created['id']}")
    assert hidden.status_code == 404


@pytest.mark.parametrize(
    ("override", "code"),
    [
        ({"worker_ids": ["demo-beta-company-admin"]}, "worker_not_found"),
        ({"worker_ids": [WORKER_ID, WORKER_ID]}, "duplicate_worker"),
        ({"valid_until": "2026-08-20T05:00:00Z"}, "invalid_validity_window"),
        (
            {
                "risk_assessment": [
                    {
                        "hazard": "Heat",
                        "persons_at_risk": "Worker",
                        "initial_likelihood": 1,
                        "initial_severity": 2,
                        "controls": "Insulation and exclusion zone",
                        "residual_likelihood": 2,
                        "residual_severity": 2,
                    }
                ]
            },
            "residual_risk_increased",
        ),
    ],
)
def test_invalid_safety_inputs_are_rejected(
    wiring: dict[str, Any], override: dict[str, Any], code: str
) -> None:
    response = create_permit(**override)
    assert response.status_code == 422
    assert response.json()["error"] == code


def test_template_type_and_location_relationships_are_enforced(wiring: dict[str, Any]) -> None:
    mismatch = create_permit(permit_type="confined_space")
    assert mismatch.status_code == 422
    assert mismatch.json()["error"] == "permit_template_type_mismatch"
    wrong_area = create_permit(area_id="acme-energy__area__compressor-building")
    assert wrong_area.status_code == 422
    assert wrong_area.json()["error"] == "area_not_found"


def test_update_revision_conflict_preserves_current_record(wiring: dict[str, Any]) -> None:
    created = create_permit().json()
    changed = request(
        identity(),
        "PATCH",
        f"/api/v1/permits/{created['id']}",
        json={"expected_revision": 1, "title": "Updated controlled work"},
    )
    assert changed.status_code == 200
    assert changed.json()["revision"] == 2
    stale = request(
        identity(),
        "PATCH",
        f"/api/v1/permits/{created['id']}",
        json={"expected_revision": 1, "title": "Stale overwrite"},
    )
    assert stale.status_code == 409
    assert stale.json()["details"] == {"current_revision": 2}
    current = request(identity(), "GET", f"/api/v1/permits/{created['id']}").json()
    assert current["title"] == "Updated controlled work"


def test_filter_pagination_soft_delete_and_audit(wiring: dict[str, Any]) -> None:
    first = create_permit(title="First permit").json()
    second = create_permit(title="Second permit").json()
    page = request(identity(), "GET", "/api/v1/permits?limit=1")
    assert page.status_code == 200
    assert len(page.json()["items"]) == 1
    assert page.json()["next_cursor"] is not None
    filtered = request(
        identity(), "GET", f"/api/v1/permits?worker_id={WORKER_ID}&permit_type=hot_work"
    )
    # Seeded demo permits share this tenant, so assert the pair this test
    # created is returned rather than that the tenant holds nothing else.
    assert {first["id"], second["id"]} <= {row["id"] for row in filtered.json()["items"]}
    deleted = request(identity(), "DELETE", f"/api/v1/permits/{first['id']}")
    assert deleted.status_code == 200
    assert request(identity(), "GET", f"/api/v1/permits/{first['id']}").status_code == 404
    audits = wiring["client"].documents("audit_logs")
    actions = {doc["action"] for doc in audits.values() if doc.get("target_id") == first["id"]}
    assert {"permit.created", "permit.deleted"} <= actions


def submit(created: dict[str, Any], **overrides: Any) -> Any:
    body: dict[str, Any] = {
        "expected_revision": created["revision"],
        "completed_checklist_item_ids": [row["id"] for row in created["checklist_snapshot"]],
        "issuer_attestation": True,
    }
    body.update(overrides)
    return request(identity(), "POST", f"/api/v1/permits/{created['id']}/submit", json=body)


def decide(created: dict[str, Any], role: str, decision: str = "approve", **overrides: Any) -> Any:
    body: dict[str, Any] = {
        "expected_revision": created["revision"],
        "decision": decision,
        "digital_signature_attestation": True,
    }
    if decision == "reject":
        body["rejection_reason"] = "Control measures require correction."
    body.update(overrides)
    return request(
        identity(role),
        "POST",
        f"/api/v1/permits/{created['id']}/approval-decision",
        json=body,
    )


def test_submit_confirms_checklist_and_server_signs_issuer(wiring: dict[str, Any]) -> None:
    created = create_permit().json()
    response = submit(created)
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "pending_approval"
    assert body["revision"] == 2
    assert body["issuer_signature"]["signer_id"] == "demo-acme-operations_manager"
    assert body["submitted_at"] is not None
    assert all(row["completed"] for row in body["checklist_snapshot"])
    assert all(
        row["completed_by"] == "demo-acme-operations_manager" for row in body["checklist_snapshot"]
    )


def test_submission_blocks_incomplete_checklist_and_high_residual_risk(
    wiring: dict[str, Any],
) -> None:
    created = create_permit().json()
    incomplete = submit(created, completed_checklist_item_ids=[])
    assert incomplete.status_code == 422
    assert incomplete.json()["error"] == "permit_checklist_incomplete"
    risky = create_permit(
        risk_assessment=[
            {
                "hazard": "Fire",
                "persons_at_risk": "Crew",
                "initial_likelihood": 5,
                "initial_severity": 5,
                "controls": "Isolation and fire watch",
                "residual_likelihood": 3,
                "residual_severity": 4,
            }
        ]
    ).json()
    blocked = submit(risky)
    assert blocked.status_code == 422
    assert blocked.json()["error"] == "residual_risk_too_high"


def test_approvals_are_role_matched_sequential_and_server_signed(wiring: dict[str, Any]) -> None:
    pending = submit(create_permit().json()).json()
    out_of_order = decide(pending, "hse_manager")
    assert out_of_order.status_code == 403
    assert out_of_order.json()["error"] == "approval_step_role_mismatch"
    operations = decide(pending, "operations_manager")
    assert operations.status_code == 200
    after_operations = operations.json()
    assert after_operations["status"] == "pending_approval"
    assert after_operations["approval_snapshot"][0]["signed_by"] == "demo-acme-operations_manager"
    hse = decide(after_operations, "hse_manager")
    assert hse.status_code == 200
    completed = hse.json()
    assert completed["status"] == "pending_signatures"
    assert completed["approval_snapshot"][1]["signed_by"] == "demo-acme-hse_manager"


def test_rejection_returns_to_draft_and_resubmit_resets_chain(wiring: dict[str, Any]) -> None:
    pending = submit(create_permit().json()).json()
    rejected = decide(pending, "operations_manager", "reject")
    assert rejected.status_code == 200
    draft = rejected.json()
    assert draft["status"] == "draft"
    assert draft["approval_snapshot"][0]["status"] == "rejected"
    assert draft["approval_snapshot"][0]["rejection_reason"] is not None
    resubmitted = submit(draft)
    assert resubmitted.status_code == 200
    assert all(row["status"] == "pending" for row in resubmitted.json()["approval_snapshot"])


def test_submission_and_approval_revision_conflicts_preserve_state(wiring: dict[str, Any]) -> None:
    created = create_permit().json()
    stale_submit = submit(created, expected_revision=999)
    assert stale_submit.status_code == 409
    assert stale_submit.json()["error"] == "permit_revision_conflict"
    pending = submit(created).json()
    stale_approval = decide(pending, "operations_manager", expected_revision=1)
    assert stale_approval.status_code == 409
    current = request(identity(), "GET", f"/api/v1/permits/{created['id']}").json()
    assert current["status"] == "pending_approval"
    assert current["approval_snapshot"][0]["status"] == "pending"


def approve_all(created: dict[str, Any]) -> dict[str, Any]:
    pending = submit(created).json()
    operations = decide(pending, "operations_manager").json()
    return decide(operations, "hse_manager").json()


def acknowledge(pending: dict[str, Any], role: str = "field_inspector", **overrides: Any) -> Any:
    body: dict[str, Any] = {
        "expected_revision": pending["revision"],
        "client_mutation_id": f"ack-{role}-0001",
        "client_signed_at": datetime.now(UTC).isoformat(),
        "device_id": "field-device-17",
        "worker_attestation": True,
    }
    body.update(overrides)
    return request(
        identity(role), "POST", f"/api/v1/permits/{pending['id']}/acknowledge", json=body
    )


def test_assigned_worker_acknowledgement_is_server_signed_and_idempotent(
    wiring: dict[str, Any],
) -> None:
    pending = approve_all(create_permit().json())
    response = acknowledge(pending)
    assert response.status_code == 200
    acknowledged = response.json()
    assert acknowledged["revision"] == pending["revision"] + 1
    signature = acknowledged["worker_acknowledgements"][0]
    assert signature["worker_id"] == WORKER_ID
    assert signature["device_id"] == "field-device-17"
    assert signature["signed_at"] == signature["received_at"]
    replay = acknowledge(
        acknowledged,
        expected_revision=pending["revision"],
        client_mutation_id="ack-field_inspector-0001",
    )
    assert replay.status_code == 200
    assert replay.json()["revision"] == acknowledged["revision"]
    assert len(replay.json()["worker_acknowledgements"]) == 1


def test_unassigned_worker_and_future_client_signature_are_rejected(
    wiring: dict[str, Any],
) -> None:
    pending = approve_all(create_permit().json())
    unassigned = acknowledge(pending, "maintenance_technician")
    assert unassigned.status_code == 403
    assert unassigned.json()["error"] == "worker_not_assigned"
    future = acknowledge(
        pending, client_signed_at=(datetime.now(UTC) + timedelta(minutes=10)).isoformat()
    )
    assert future.status_code == 422
    assert future.json()["error"] == "client_signature_in_future"


def test_two_worker_offline_revisions_conflict_then_rebase_succeeds(wiring: dict[str, Any]) -> None:
    created = create_permit(worker_ids=[WORKER_ID, "demo-acme-maintenance_technician"]).json()
    pending = approve_all(created)
    first = acknowledge(pending).json()
    stale = acknowledge(
        pending,
        "maintenance_technician",
        client_mutation_id="ack-maintenance-0001",
    )
    assert stale.status_code == 409
    assert stale.json()["details"] == {"current_revision": first["revision"]}
    rebased = acknowledge(
        first,
        "maintenance_technician",
        client_mutation_id="ack-maintenance-0001",
    )
    assert rebased.status_code == 200
    assert {row["worker_id"] for row in rebased.json()["worker_acknowledgements"]} == {
        WORKER_ID,
        "demo-acme-maintenance_technician",
    }


def test_activation_requires_all_workers_and_current_online_validity(
    wiring: dict[str, Any],
) -> None:
    now = datetime.now(UTC)
    pending = approve_all(
        create_permit(
            valid_from=(now - timedelta(hours=1)).isoformat(),
            valid_until=(now + timedelta(hours=8)).isoformat(),
        ).json()
    )
    incomplete = request(
        identity(),
        "POST",
        f"/api/v1/permits/{pending['id']}/activate",
        json={"expected_revision": pending["revision"], "activation_attestation": True},
    )
    assert incomplete.status_code == 422
    assert incomplete.json()["error"] == "worker_acknowledgements_incomplete"
    acknowledged = acknowledge(pending).json()
    denied = request(
        identity("field_inspector"),
        "POST",
        f"/api/v1/permits/{pending['id']}/activate",
        json={"expected_revision": acknowledged["revision"], "activation_attestation": True},
    )
    assert denied.status_code == 403
    activated = request(
        identity(),
        "POST",
        f"/api/v1/permits/{pending['id']}/activate",
        json={"expected_revision": acknowledged["revision"], "activation_attestation": True},
    )
    assert activated.status_code == 200
    assert activated.json()["status"] == "active"
    assert activated.json()["activated_by"] == "demo-acme-operations_manager"
    assert activated.json()["activated_at"] is not None


def create_active_permit() -> dict[str, Any]:
    now = datetime.now(UTC)
    pending = approve_all(
        create_permit(
            valid_from=(now - timedelta(hours=1)).isoformat(),
            valid_until=(now + timedelta(hours=8)).isoformat(),
        ).json()
    )
    acknowledged = acknowledge(pending).json()
    response = request(
        identity(),
        "POST",
        f"/api/v1/permits/{pending['id']}/activate",
        json={"expected_revision": acknowledged["revision"], "activation_attestation": True},
    )
    assert response.status_code == 200
    return response.json()


def control(created: dict[str, Any], action: str, **overrides: Any) -> Any:
    body: dict[str, Any] = {
        "expected_revision": created["revision"],
        "reason": f"Safety control requires permit {action}.",
    }
    body.update(overrides)
    return request(
        identity("hse_manager"),
        "POST",
        f"/api/v1/permits/{created['id']}/{action}",
        json=body,
    )


def test_suspend_and_resume_preserve_reasoned_control_history(wiring: dict[str, Any]) -> None:
    active = create_active_permit()
    suspended = control(active, "suspend")
    assert suspended.status_code == 200
    body = suspended.json()
    assert body["status"] == "suspended"
    assert body["suspended_by"] == "demo-acme-hse_manager"
    assert body["suspension_reason"] == "Safety control requires permit suspend."
    resumed = request(
        identity("hse_manager"),
        "POST",
        f"/api/v1/permits/{active['id']}/resume",
        json={"expected_revision": body["revision"], "resume_attestation": True},
    )
    assert resumed.status_code == 200
    assert resumed.json()["status"] == "active"
    assert resumed.json()["suspension_reason"] is None


def test_revoke_and_close_are_terminal_reasoned_transitions(wiring: dict[str, Any]) -> None:
    pending = approve_all(create_permit().json())
    revoked = control(pending, "revoke")
    assert revoked.status_code == 200
    assert revoked.json()["status"] == "revoked"
    assert revoked.json()["revoked_by"] == "demo-acme-hse_manager"
    assert control(revoked.json(), "revoke").status_code == 409

    active = create_active_permit()
    closed = request(
        identity("hse_manager"),
        "POST",
        f"/api/v1/permits/{active['id']}/close",
        json={
            "expected_revision": active["revision"],
            "closeout_notes": "Work completed, area inspected, and isolations removed.",
            "close_attestation": True,
        },
    )
    assert closed.status_code == 200
    assert closed.json()["status"] == "closed"
    assert closed.json()["closed_by"] == "demo-acme-hse_manager"


def test_due_active_permit_expires_on_read_with_system_audit(wiring: dict[str, Any]) -> None:
    active = create_active_permit()
    repository = PermitRepository(
        wiring["client"], AuditService(AuditLogRepository(wiring["client"]))
    )
    asyncio.run(
        repository.update(
            CompanyScope(company_id=ACME_COMPANY_ID),
            active["id"],
            {"valid_until": datetime.now(UTC) - timedelta(minutes=1)},
            "test-clock",
            active["revision"],
        )
    )
    response = request(identity(), "GET", f"/api/v1/permits/{active['id']}")
    assert response.status_code == 200
    assert response.json()["status"] == "expired"
    assert response.json()["expired_at"] is not None
    audits = wiring["client"].documents("audit_logs")
    expiry = [
        row
        for row in audits.values()
        if row.get("target_id") == active["id"] and row.get("action") == "permit.expired"
    ]
    assert len(expiry) == 1
    assert expiry[0]["actor_uid"] == "system:permit-expiry"


def test_dashboard_active_permit_kpi_reconciles_expiry(
    wiring: dict[str, Any],
) -> None:
    # Measured as a delta: the demo tenant seeds its own active permit so the
    # register is not empty, and this assertion is about expiry reconciliation,
    # not about how much demo data exists.
    baseline = request(
        identity("executive"), "GET", "/api/v1/dashboard/permits-summary"
    ).json()["active"]

    active = create_active_permit()
    response = request(identity("executive"), "GET", "/api/v1/dashboard/permits-summary")
    assert response.status_code == 200
    assert response.json() == {"active": baseline + 1}

    repository = PermitRepository(
        wiring["client"], AuditService(AuditLogRepository(wiring["client"]))
    )
    asyncio.run(
        repository.update(
            CompanyScope(company_id=ACME_COMPANY_ID),
            active["id"],
            {"valid_until": datetime.now(UTC) - timedelta(minutes=1)},
            "test-clock",
            active["revision"],
        )
    )
    refreshed = request(identity("executive"), "GET", "/api/v1/dashboard/permits-summary")
    assert refreshed.status_code == 200
    # Expiring the one this test created returns the count to its baseline.
    assert refreshed.json() == {"active": baseline}


def test_non_draft_cannot_use_generic_edit_or_delete_and_stale_resume_conflicts(
    wiring: dict[str, Any],
) -> None:
    active = create_active_permit()
    edited = request(
        identity(),
        "PATCH",
        f"/api/v1/permits/{active['id']}",
        json={"expected_revision": active["revision"], "title": "Unsafe rewrite"},
    )
    assert edited.status_code == 409
    assert edited.json()["error"] == "permit_not_editable"
    deleted = request(identity(), "DELETE", f"/api/v1/permits/{active['id']}")
    assert deleted.status_code == 409
    assert deleted.json()["error"] == "permit_not_deletable"
    suspended = control(active, "suspend").json()
    stale_resume = request(
        identity("hse_manager"),
        "POST",
        f"/api/v1/permits/{active['id']}/resume",
        json={"expected_revision": active["revision"], "resume_attestation": True},
    )
    assert stale_resume.status_code == 409
    assert stale_resume.json()["details"] == {"current_revision": suspended["revision"]}
