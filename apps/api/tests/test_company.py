import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.company.service import CompanyProfileService, get_company_profile_service
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import get_access_denial_audit
from app.storage.service import CompanyLogoStorage
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.storage import FakeBucket

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def wiring() -> dict[str, Any]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    companies = CompanyRepository(client, audit)
    users = UserRepository(client, audit)
    roles = RoleRepository(client, audit)
    bucket = FakeBucket()
    storage = CompanyLogoStorage(bucket=bucket)
    service = CompanyProfileService(
        companies=companies,
        users=users,
        roles=roles,
        storage=storage,
        audit=audit,
    )

    app.dependency_overrides[get_company_profile_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "bucket": bucket, "audit": audit}
    app.dependency_overrides.pop(get_company_profile_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    uid: str = "test-admin",
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"company.settings"}),
) -> CurrentUser:
    return CurrentUser(
        uid=uid,
        email=f"{uid}@example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom_admin",
        permissions=permissions,
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


# --- get -----------------------------------------------------------------


def test_get_company_is_tenant_scoped_and_reports_counts(wiring: dict[str, Any]) -> None:
    acme = _request(_identity(), "GET", "/api/v1/company")
    assert acme.status_code == 200
    body = acme.json()
    assert body["name"] == "Acme Energy"
    assert body["timezone"] == "UTC"
    assert body["locale"] == "en-US"
    assert body["users_total"] >= 1
    assert body["roles_total"] >= 1
    assert body["logo_url"] is None

    beta = _request(_identity(company_id=BETA_COMPANY_ID), "GET", "/api/v1/company")
    assert beta.status_code == 200
    assert beta.json()["name"] != body["name"]


def test_get_company_requires_company_settings_permission(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"reports.read"})), "GET", "/api/v1/company"
    )
    assert response.status_code == 403


# --- update ----------------------------------------------------------------


def test_update_company_validates_and_audits_before_after(wiring: dict[str, Any]) -> None:
    before = _request(_identity(), "GET", "/api/v1/company").json()

    response = _request(
        _identity(),
        "PATCH",
        "/api/v1/company",
        json={
            "name": "Acme Energy Holdings",
            "industry": "Electric Utility",
            "timezone": "America/Chicago",
            "locale": "en-GB",
            "contact_email": "ops@acme.example.invalid",
            "contact_phone": "+1-555-0100",
        },
    )
    assert response.status_code == 200
    body = response.json()
    assert body["name"] == "Acme Energy Holdings"
    assert body["industry"] == "Electric Utility"
    assert body["timezone"] == "America/Chicago"
    assert body["locale"] == "en-GB"
    assert body["contact_email"] == "ops@acme.example.invalid"
    assert body["contact_phone"] == "+1-555-0100"

    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    audits = asyncio.run(AuditLogRepository(wiring["client"]).list(scope))
    updated = next(entry for entry in audits if entry.action == "company.updated")
    assert updated.metadata["before"]["name"] == before["name"]
    assert updated.metadata["after"]["name"] == "Acme Energy Holdings"


@pytest.mark.parametrize(
    ("field", "value", "expected_error"),
    [
        ("industry", "Not A Real Industry", "invalid_industry"),
        ("timezone", "Not/A_Zone", "invalid_timezone"),
        ("locale", "not-a-locale-tag", "invalid_locale"),
    ],
)
def test_update_company_rejects_invalid_field_values(
    wiring: dict[str, Any], field: str, value: str, expected_error: str
) -> None:
    response = _request(_identity(), "PATCH", "/api/v1/company", json={field: value})
    assert response.status_code == 422
    assert response.json()["error"] == expected_error


def test_update_company_can_explicitly_clear_optional_fields(wiring: dict[str, Any]) -> None:
    _request(
        _identity(),
        "PATCH",
        "/api/v1/company",
        json={
            "industry": "Electric Utility",
            "contact_email": "ops@acme.example.invalid",
            "contact_phone": "+1-555-0100",
        },
    )

    response = _request(
        _identity(),
        "PATCH",
        "/api/v1/company",
        json={"industry": None, "contact_email": None, "contact_phone": None},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["industry"] is None
    assert body["contact_email"] is None
    assert body["contact_phone"] is None
    # Untouched fields (name, timezone, locale) must survive the clear.
    assert body["name"] == "Acme Energy"


def test_update_company_omitted_fields_stay_untouched(wiring: dict[str, Any]) -> None:
    _request(_identity(), "PATCH", "/api/v1/company", json={"industry": "Mining"})
    response = _request(
        _identity(), "PATCH", "/api/v1/company", json={"contact_email": "a@acme.example.invalid"}
    )
    assert response.status_code == 200
    assert response.json()["industry"] == "Mining"


@pytest.mark.parametrize("field", ["name", "timezone", "locale"])
def test_update_company_rejects_explicit_null_for_required_fields(
    wiring: dict[str, Any], field: str
) -> None:
    response = _request(_identity(), "PATCH", "/api/v1/company", json={field: None})
    assert response.status_code == 422
    assert response.json()["error"] == f"invalid_{field}"


def test_update_company_requires_company_settings_permission(wiring: dict[str, Any]) -> None:
    response = _request(
        _identity(permissions=frozenset({"reports.read"})),
        "PATCH",
        "/api/v1/company",
        json={"name": "Should Not Apply"},
    )
    assert response.status_code == 403


# --- logo ------------------------------------------------------------------

_PNG_BYTES = b"\x89PNG\r\n\x1a\n" + b"0" * 32


def test_upload_logo_rejects_wrong_type_and_oversized(wiring: dict[str, Any]) -> None:
    wrong_type = _request(
        _identity(),
        "POST",
        "/api/v1/company/logo",
        files={"file": ("logo.gif", b"GIF89a", "image/gif")},
    )
    assert wrong_type.status_code == 422
    assert wrong_type.json()["error"] == "invalid_logo_type"

    too_large = _request(
        _identity(),
        "POST",
        "/api/v1/company/logo",
        files={"file": ("logo.png", b"0" * (5 * 1024 * 1024 + 1), "image/png")},
    )
    assert too_large.status_code == 422
    assert too_large.json()["error"] == "logo_too_large"


def test_upload_logo_stores_at_company_scoped_path_and_updates_doc(
    wiring: dict[str, Any],
) -> None:
    response = _request(
        _identity(),
        "POST",
        "/api/v1/company/logo",
        files={"file": ("logo.png", _PNG_BYTES, "image/png")},
    )
    assert response.status_code == 200
    body = response.json()
    expected_path = f"companies/{ACME_COMPANY_ID}/branding/logo"
    assert body["logo_url"] is not None
    assert expected_path in body["logo_url"]
    assert expected_path in wiring["bucket"].objects

    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    audits = asyncio.run(AuditLogRepository(wiring["client"]).list(scope))
    assert any(entry.action == "company.logo_updated" for entry in audits)

    # Uploading again overwrites the same path -- no orphaned blobs.
    second = _request(
        _identity(),
        "POST",
        "/api/v1/company/logo",
        files={"file": ("logo2.png", _PNG_BYTES, "image/png")},
    )
    assert second.status_code == 200
    assert len(wiring["bucket"].objects) == 1


def test_remove_logo_clears_reference(wiring: dict[str, Any]) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/company/logo",
        files={"file": ("logo.png", _PNG_BYTES, "image/png")},
    )
    response = _request(_identity(), "DELETE", "/api/v1/company/logo")
    assert response.status_code == 200
    body = response.json()
    assert body["logo_url"] is None
    expected_path = f"companies/{ACME_COMPANY_ID}/branding/logo"
    assert expected_path not in wiring["bucket"].objects

    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    audits = asyncio.run(AuditLogRepository(wiring["client"]).list(scope))
    assert any(entry.action == "company.logo_removed" for entry in audits)
