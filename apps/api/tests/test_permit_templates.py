import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.permit_templates import PermitTemplateRepository
from app.db.repositories.roles import RoleRepository
from app.main import app
from app.models.entities import CurrentUser
from app.permit_templates.service import PermitTemplateService, get_permit_template_service
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import ACME_COMPANY_ID, role_id, run_seed
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    audit = AuditService(AuditLogRepository(client))
    service = PermitTemplateService(
        PermitTemplateRepository(client, audit), RoleRepository(client, audit)
    )
    app.dependency_overrides[get_permit_template_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_permit_template_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def identity(role: str = "operations_manager", company_id: str = ACME_COMPANY_ID) -> CurrentUser:
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


def create(who: CurrentUser | None = None, **overrides: Any) -> Any:
    payload: dict[str, Any] = {
        "name": "Hot work standard",
        "permit_type": "hot_work",
        "checklist_items": [
            {"id": "extinguisher", "label": "Fire extinguisher available", "required": True}
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
    }
    payload.update(overrides)
    return request(who or identity(), "POST", "/api/v1/permit-templates", json=payload)


def test_create_returns_ordered_real_template_and_server_ids(wiring: dict[str, Any]) -> None:
    response = create(
        checklist_items=[{"label": "Gas test complete"}],
        approval_steps=[
            {
                "label": "HSE approval",
                "approver_role_id": role_id(ACME_COMPANY_ID, "hse_manager"),
            }
        ],
    )
    assert response.status_code == 201
    body = response.json()
    assert body["version"] == 1
    assert body["permit_type"] == "hot_work"
    assert body["checklist_items"][0]["id"].startswith("item_")
    assert body["approval_steps"][0]["id"].startswith("step_")


def test_routes_are_table_driven_across_system_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        who = identity(role_key)
        listing = request(who, "GET", "/api/v1/permit-templates")
        assert listing.status_code == (200 if "permits.read" in template.permission_keys else 403)
        created = create(who, name=f"Role {role_key}")
        assert created.status_code == (201 if "permits.write" in template.permission_keys else 403)


def test_tenant_isolation_and_cross_tenant_get_are_indistinguishable_from_missing(
    wiring: dict[str, Any],
) -> None:
    created = create().json()
    beta = identity("operations_manager", BETA_COMPANY_ID)
    listing = request(beta, "GET", "/api/v1/permit-templates")
    assert listing.status_code == 200
    assert listing.json()["items"] == []
    hidden = request(beta, "GET", f"/api/v1/permit-templates/{created['id']}")
    assert hidden.status_code == 404
    assert hidden.json()["error"] == "permit_template_not_found"


def test_approval_role_must_exist_in_same_tenant(wiring: dict[str, Any]) -> None:
    response = create(
        approval_steps=[
            {
                "label": "Foreign role",
                "approver_role_id": role_id(BETA_COMPANY_ID, "hse_manager"),
            }
        ]
    )
    assert response.status_code == 422
    assert response.json()["error"] == "approver_role_not_found"


@pytest.mark.parametrize(
    ("field", "rows", "error"),
    [
        (
            "checklist_items",
            [{"id": "same", "label": "One"}, {"id": "same", "label": "Two"}],
            "duplicate_checklist_item_id",
        ),
        (
            "approval_steps",
            [
                {
                    "id": "same",
                    "label": "One",
                    "approver_role_id": role_id(ACME_COMPANY_ID, "hse_manager"),
                },
                {
                    "id": "same",
                    "label": "Two",
                    "approver_role_id": role_id(ACME_COMPANY_ID, "operations_manager"),
                },
            ],
            "duplicate_approval_step_id",
        ),
    ],
)
def test_duplicate_nested_ids_are_rejected(
    wiring: dict[str, Any], field: str, rows: list[dict[str, Any]], error: str
) -> None:
    response = create(**{field: rows})
    assert response.status_code == 422
    assert response.json()["error"] == error


def test_update_increments_version_and_delete_is_soft(wiring: dict[str, Any]) -> None:
    created = create().json()
    updated = request(
        identity(),
        "PATCH",
        f"/api/v1/permit-templates/{created['id']}",
        json={"name": "Hot work standard v2", "expected_version": 1},
    )
    assert updated.status_code == 200
    assert updated.json()["version"] == 2
    deleted = request(identity(), "DELETE", f"/api/v1/permit-templates/{created['id']}")
    assert deleted.status_code == 200
    assert deleted.json()["deleted"] is True
    after = request(identity(), "GET", f"/api/v1/permit-templates/{created['id']}")
    assert after.status_code == 404


def test_update_rejects_stale_version_without_overwriting(wiring: dict[str, Any]) -> None:
    created = create().json()
    first = request(
        identity(),
        "PATCH",
        f"/api/v1/permit-templates/{created['id']}",
        json={"name": "Current", "expected_version": 1},
    )
    assert first.status_code == 200
    stale = request(
        identity(),
        "PATCH",
        f"/api/v1/permit-templates/{created['id']}",
        json={"name": "Stale overwrite", "expected_version": 1},
    )
    assert stale.status_code == 409
    assert stale.json()["error"] == "permit_template_version_conflict"
    assert stale.json()["details"] == {"current_version": 2}
    current = request(identity(), "GET", f"/api/v1/permit-templates/{created['id']}")
    assert current.json()["name"] == "Current"
