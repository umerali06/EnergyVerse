import asyncio

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.provisioning import UserProvisioningService
from app.auth.registration import (
    CompanyRegistrationService,
    RegistrationError,
    get_registration_service,
)
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CompanyRegistrationRequest
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.service import PermissionResolver
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.auth import FakeAuthAdmin
from tests.fakes.firestore import FakeAsyncClient

NEW_COMPANY_ID = "cmp_0123456789abcdef0123456789abcdef"


def _service(
    firestore: FakeAsyncClient,
    admin: FakeAuthAdmin,
) -> CompanyRegistrationService:
    audit = AuditService(AuditLogRepository(firestore))
    roles = RoleRepository(firestore, audit)
    users = UserRepository(firestore, audit)
    return CompanyRegistrationService(
        admin=admin,
        companies=CompanyRepository(firestore, audit),
        roles=roles,
        role_permissions=RolePermissionRepository(firestore, audit),
        provisioner=UserProvisioningService(
            admin=admin,
            users=users,
            roles=roles,
            audit=audit,
        ),
        audit=audit,
        company_id_factory=lambda: NEW_COMPANY_ID,
    )


def _request() -> CompanyRegistrationRequest:
    return CompanyRegistrationRequest(
        company_name="  Acme Energy  ",
        display_name="  New Company Admin  ",
        email="NEW.ADMIN@EXAMPLE.COM",
        password="StrongPass123!",
    )


def test_register_creates_isolated_company_admin_and_seven_roles() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    admin = FakeAuthAdmin()
    service = _service(firestore, admin)

    result = asyncio.run(service.register(_request()))
    scope = CompanyScope(company_id=NEW_COMPANY_ID)
    users = UserRepository(firestore)
    roles = RoleRepository(firestore)
    mappings = RolePermissionRepository(firestore)
    company = asyncio.run(CompanyRepository(firestore).get(scope))
    user = asyncio.run(users.get(scope, result.uid))

    assert company is not None
    assert company.name == "Acme Energy"
    assert company.id.startswith("cmp_")
    assert company.subscription_tier == "unassigned"
    assert result.role_key == "company_admin"
    assert result.email_verified is False
    assert user is not None and user.role_id.endswith("__company_admin")
    assert len(asyncio.run(roles.list(scope))) == 7
    assert len(asyncio.run(mappings.list_for_role(scope, user.role_id))) == len(
        SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys
    )

    resolver = PermissionResolver(
        users,
        roles,
        mappings,
        PermissionRepository(firestore),
    )
    assert asyncio.run(resolver.resolve_for_user(scope, result.uid)) == (
        SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys
    )
    assert asyncio.run(users.get(CompanyScope(company_id=ACME_COMPANY_ID), result.uid)) is None
    assert len(asyncio.run(users.list(CompanyScope(company_id=ACME_COMPANY_ID)))) == 7
    assert any(
        entry.action == "company.self_registered" and entry.actor_uid == result.uid
        for entry in asyncio.run(AuditLogRepository(firestore).list(scope))
    )


def test_register_allows_duplicate_company_display_names() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    result = asyncio.run(_service(firestore, FakeAuthAdmin()).register(_request()))

    assert result.company_id != ACME_COMPANY_ID
    assert firestore.documents("companies")[ACME_COMPANY_ID]["name"] == "Acme Energy"
    assert firestore.documents("companies")[result.company_id]["name"] == "Acme Energy"


def test_register_rejects_existing_email_before_creating_company() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    admin = FakeAuthAdmin()
    service = _service(firestore, admin)
    asyncio.run(service.register(_request()))
    counts = firestore.counts()

    with pytest.raises(RegistrationError, match="account already exists") as raised:
        asyncio.run(service.register(_request()))

    assert raised.value.code == "email_already_in_use"
    assert firestore.counts() == counts


def test_register_route_returns_typed_201_and_unified_conflict() -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    service = _service(firestore, FakeAuthAdmin())
    app.dependency_overrides[get_registration_service] = lambda: service
    try:
        with TestClient(app) as client:
            first = client.post("/api/v1/auth/register", json=_request().model_dump())
            second = client.post("/api/v1/auth/register", json=_request().model_dump())
    finally:
        app.dependency_overrides.clear()

    assert first.status_code == 201
    assert first.json()["company_id"] == NEW_COMPANY_ID
    assert first.json()["role_key"] == "company_admin"
    assert second.status_code == 409
    assert second.json()["error"] == "email_already_in_use"
    assert second.json()["request_id"]


def test_register_route_rejects_weak_password_before_service() -> None:
    firestore = FakeAsyncClient()
    service = _service(firestore, FakeAuthAdmin())
    app.dependency_overrides[get_registration_service] = lambda: service
    try:
        with TestClient(app) as client:
            response = client.post(
                "/api/v1/auth/register",
                json={**_request().model_dump(), "password": "short"},
            )
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 422
    assert response.json()["error"] == "validation_error"
