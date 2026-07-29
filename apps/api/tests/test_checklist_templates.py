import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.checklists.service import ChecklistTemplateService, get_checklist_template_service
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import ACME_COMPANY_ID, CHECKLIST_TEMPLATE_PUMP_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = ChecklistTemplateService(templates=ChecklistTemplateRepository(client, audit))

    app.dependency_overrides[get_checklist_template_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client}
    app.dependency_overrides.pop(get_checklist_template_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-user",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset(
        {"checklist_templates.read", "checklist_templates.write"}
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


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _create_template(identity: CurrentUser, **overrides: Any) -> Any:
    payload: dict[str, Any] = {
        "name": "Test Template",
        "category": "Generic",
        "items": [
            {"label": "Looks fine", "item_type": "boolean", "required": True},
        ],
    }
    payload.update(overrides)
    return _request(identity, "POST", "/api/v1/checklist-templates", json=payload)


# --- tenant isolation and RBAC ------------------------------------------------


def test_list_templates_is_tenant_scoped(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/checklist-templates", params={"limit": 100})
    assert acme.status_code == 200
    assert len(acme.json()["items"]) == 3

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/checklist-templates")
    assert beta.status_code == 200
    assert beta.json()["items"] == []


def test_get_template_cross_tenant_returns_404(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID),
        "GET",
        f"/api/v1/checklist-templates/{CHECKLIST_TEMPLATE_PUMP_ID}",
    )
    assert response.status_code == 404
    assert response.json()["error"] == "checklist_template_not_found"


def test_checklist_template_routes_are_table_driven_across_roles(wiring: dict[str, Any]) -> None:
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items():
        identity = _identity(role_key, permissions=template.permission_keys)
        read_response = _request(identity, "GET", "/api/v1/checklist-templates")
        if "checklist_templates.read" in template.permission_keys:
            assert read_response.status_code == 200, (role_key, read_response.json())
        else:
            assert read_response.status_code == 403, role_key

        write_response = _create_template(identity, name=f"RBAC {role_key}")
        if "checklist_templates.write" in template.permission_keys:
            assert write_response.status_code == 201, (role_key, write_response.json())
        else:
            assert write_response.status_code == 403, role_key


# --- create / update / delete + versioning -----------------------------------


def test_create_update_and_soft_delete_template(wiring: dict[str, Any]) -> None:
    created = _create_template(_identity(), name="Generator Checklist", category="Generators")
    assert created.status_code == 201
    body = created.json()
    template_id = body["id"]
    assert body["version"] == 1

    updated = _request(
        _identity(),
        "PATCH",
        f"/api/v1/checklist-templates/{template_id}",
        json={"name": "Generator Checklist v2"},
    )
    assert updated.status_code == 200
    assert updated.json()["name"] == "Generator Checklist v2"
    assert updated.json()["version"] == 2

    deleted = _request(_identity(), "DELETE", f"/api/v1/checklist-templates/{template_id}")
    assert deleted.status_code == 200
    assert deleted.json() == {"id": template_id, "deleted": True}

    after = _request(_identity(), "GET", f"/api/v1/checklist-templates/{template_id}")
    assert after.status_code == 404

    listed = _request(_identity(), "GET", "/api/v1/checklist-templates", params={"limit": 100})
    assert template_id not in {item["id"] for item in listed.json()["items"]}


def test_list_templates_filters_by_category(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(), "GET", "/api/v1/checklist-templates", params={"category": "Pumps"}
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert len(items) == 1
    assert items[0]["category"] == "Pumps"


# --- item validation -----------------------------------------------------------


def test_create_rejects_unknown_category(wiring: dict[str, Any]) -> None:
    response = _create_template(_identity(), category="Not A Real Category")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_category"


def test_create_rejects_select_item_without_options(wiring: dict[str, Any]) -> None:
    response = _create_template(
        _identity(),
        items=[{"label": "Condition", "item_type": "select", "required": True}],
    )
    assert response.status_code == 422
    assert response.json()["error"] == "select_options_required"


def test_create_rejects_non_select_item_with_options(wiring: dict[str, Any]) -> None:
    response = _create_template(
        _identity(),
        items=[
            {
                "label": "Looks fine",
                "item_type": "boolean",
                "required": True,
                "options": ["Yes", "No"],
            }
        ],
    )
    assert response.status_code == 422
    assert response.json()["error"] == "options_not_allowed"


def test_create_rejects_duplicate_item_ids(wiring: dict[str, Any]) -> None:
    response = _create_template(
        _identity(),
        items=[
            {"id": "dup", "label": "First", "item_type": "boolean", "required": True},
            {"id": "dup", "label": "Second", "item_type": "boolean", "required": True},
        ],
    )
    assert response.status_code == 422
    assert response.json()["error"] == "duplicate_item_id"


def test_create_accepts_valid_select_item(wiring: dict[str, Any]) -> None:
    response = _create_template(
        _identity(),
        items=[
            {
                "label": "Condition",
                "item_type": "select",
                "required": True,
                "options": ["Good", "Fair", "Poor"],
            }
        ],
    )
    assert response.status_code == 201
    assert response.json()["items"][0]["options"] == ["Good", "Fair", "Poor"]
