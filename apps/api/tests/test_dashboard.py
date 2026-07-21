import asyncio
from datetime import timedelta
from typing import Any
from uuid import UUID

import pytest
from fastapi.testclient import TestClient

import app.api.v1.dashboard as dashboard_module
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import utc_now
from app.models.entities import AuditLog, CurrentUser
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"


@pytest.fixture()
def fake_client(monkeypatch: pytest.MonkeyPatch) -> FakeAsyncClient:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    monkeypatch.setattr(dashboard_module, "CompanyRepository", lambda: CompanyRepository(client))
    monkeypatch.setattr(dashboard_module, "UserRepository", lambda: UserRepository(client))
    monkeypatch.setattr(dashboard_module, "RoleRepository", lambda: RoleRepository(client))
    monkeypatch.setattr(
        dashboard_module, "AuditLogRepository", lambda: AuditLogRepository(client)
    )
    # require_permission's dependency graph always resolves
    # get_access_denial_audit (even on the success path), which otherwise
    # constructs a real Firestore-backed AuditService.
    app.dependency_overrides[get_access_denial_audit] = lambda: AuditService(
        AuditLogRepository(client)
    )
    yield client
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"reports.read"}),
    email_verified: bool = True,
) -> CurrentUser:
    return CurrentUser(
        uid="test-viewer",
        email="viewer@example.invalid",
        email_verified=email_verified,
        company_id=company_id,
        company_name="Test Co",
        role_key="custom_viewer",
        permissions=permissions,
    )


def _get(identity: CurrentUser, path: str) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.get(path)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _insert_events(
    client: FakeAsyncClient,
    company_id: str,
    count: int,
    action: str = "test.event",
    days_ago: float = 0.0,
) -> None:
    store = client._store.setdefault("audit_logs", {})
    base = utc_now() - timedelta(days=days_ago)
    for index in range(count):
        event_id = f"{company_id}-{action}-{days_ago}-{index}"
        log = AuditLog(
            id=event_id,
            company_id=company_id,
            actor_uid="demo-acme-field_inspector",
            action=action,
            target_type="test",
            target_id=f"target-{index}",
            metadata={},
            created_at=base - timedelta(minutes=index),
        )
        store[event_id] = log.model_dump()


def test_summary_returns_real_tenant_counts(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(), "/api/v1/dashboard/summary?window=30")
    assert response.status_code == 200
    body = response.json()
    assert body["company_name"] == "Acme Energy"
    assert body["subscription_tier"]
    assert body["users_total"] == 7
    assert body["users_active"] == 7
    assert body["roles_total"] == 7
    assert body["window_days"] == 30
    assert body["audit_events"] >= 0


def test_summary_requires_reports_read(fake_client: FakeAsyncClient) -> None:
    response = _get(
        _identity(permissions=frozenset({"assets.read"})),
        "/api/v1/dashboard/summary",
    )
    assert response.status_code == 403
    body = response.json()
    assert body["error"] == "forbidden"
    assert UUID(body["request_id"])


def test_unverified_email_is_blocked(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(email_verified=False), "/api/v1/dashboard/summary")
    assert response.status_code == 403
    assert response.json()["error"] == "email_unverified"


def test_tenants_are_isolated(fake_client: FakeAsyncClient) -> None:
    _insert_events(fake_client, ACME_COMPANY_ID, 5, action="acme.only")
    beta = _get(
        _identity(company_id=BETA_COMPANY_ID),
        "/api/v1/dashboard/activity?limit=50",
    )
    assert beta.status_code == 200
    actions = [item["action"] for item in beta.json()["items"]]
    assert "acme.only" not in actions
    summary = _get(_identity(company_id=BETA_COMPANY_ID), "/api/v1/dashboard/summary")
    assert summary.json()["users_total"] == 1


def test_activity_pagination_cursor_walks_without_overlap(
    fake_client: FakeAsyncClient,
) -> None:
    company = "cursor-co"
    _insert_events(fake_client, company, 25)
    identity = _identity(company_id=company)
    seen: list[str] = []
    cursor: str | None = None
    for _ in range(3):
        path = "/api/v1/dashboard/activity?limit=10"
        if cursor:
            path += f"&cursor={cursor}"
        response = _get(identity, path)
        assert response.status_code == 200
        body = response.json()
        seen.extend(item["id"] for item in body["items"])
        cursor = body["next_cursor"]
        if cursor is None:
            break
    assert len(seen) == 25
    assert len(set(seen)) == 25
    assert cursor is None


def test_activity_action_filter_and_actor_enrichment(
    fake_client: FakeAsyncClient,
) -> None:
    _insert_events(fake_client, ACME_COMPANY_ID, 3, action="filter.me")
    response = _get(
        _identity(), "/api/v1/dashboard/activity?limit=50&action=filter.me"
    )
    assert response.status_code == 200
    items = response.json()["items"]
    assert len(items) == 3
    assert all(item["action"] == "filter.me" for item in items)
    assert items[0]["actor_name"] == "Acme Field Inspector"


def test_invalid_cursor_is_rejected(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(), "/api/v1/dashboard/activity?cursor=garbage")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_cursor"


def test_series_zero_fills_the_window(fake_client: FakeAsyncClient) -> None:
    company = "series-co"
    _insert_events(fake_client, company, 2, days_ago=1.0)
    _insert_events(fake_client, company, 3, days_ago=3.0)
    response = _get(
        _identity(company_id=company), "/api/v1/dashboard/activity-series?window=7"
    )
    assert response.status_code == 200
    body = response.json()
    assert body["window_days"] == 7
    points = body["points"]
    assert len(points) == 7
    assert sum(point["count"] for point in points) == 5
    assert points[-1]["date"] == utc_now().date().isoformat()
    zero_days = [point for point in points if point["count"] == 0]
    assert len(zero_days) == 5


def test_series_rejects_unsupported_window(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(), "/api/v1/dashboard/activity-series?window=13")
    assert response.status_code == 422
