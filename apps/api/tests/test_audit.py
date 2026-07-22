import asyncio
import csv
import io
from datetime import timedelta
from typing import Any

import pytest
from fastapi.testclient import TestClient

import app.audit.query_service as query_service_module
from app.audit.query_service import AuditQueryService, get_audit_query_service
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
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
    service = AuditQueryService(
        audit_logs=AuditLogRepository(client),
        users=UserRepository(client),
        roles=RoleRepository(client),
    )
    app.dependency_overrides[get_audit_query_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: AuditService(
        AuditLogRepository(client)
    )
    yield client
    app.dependency_overrides.pop(get_audit_query_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(
    company_id: str = ACME_COMPANY_ID,
    permissions: frozenset[str] = frozenset({"audit.read"}),
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
    *,
    action: str = "test.event",
    target_type: str = "test",
    actor_uid: str = "demo-acme-field_inspector",
    days_ago: float = 1.0,
    metadata: dict[str, Any] | None = None,
    id_prefix: str = "",
) -> None:
    store = client._store.setdefault("audit_logs", {})
    base = utc_now() - timedelta(days=days_ago)
    for index in range(count):
        event_id = f"{id_prefix}{company_id}-{action}-{days_ago}-{index}"
        log = AuditLog(
            id=event_id,
            company_id=company_id,
            actor_uid=actor_uid,
            action=action,
            target_type=target_type,
            target_id=f"target-{index}",
            metadata=metadata or {},
            created_at=base - timedelta(minutes=index),
        )
        store[event_id] = log.model_dump()


def test_requires_audit_read_permission(fake_client: FakeAsyncClient) -> None:
    response = _get(
        _identity(permissions=frozenset({"reports.read"})), "/api/v1/audit-logs"
    )
    assert response.status_code == 403
    assert response.json()["error"] == "forbidden"


def test_unverified_email_is_blocked(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(email_verified=False), "/api/v1/audit-logs")
    assert response.status_code == 403
    assert response.json()["error"] == "email_unverified"


def test_tenant_isolation(fake_client: FakeAsyncClient) -> None:
    _insert_events(fake_client, ACME_COMPANY_ID, 3, action="acme.only")
    _insert_events(fake_client, BETA_COMPANY_ID, 3, action="beta.only")

    acme_view_of_beta_action = _get(
        _identity(), "/api/v1/audit-logs?limit=50&action=beta.only"
    )
    assert acme_view_of_beta_action.json()["items"] == []

    acme_view_of_own_action = _get(
        _identity(), "/api/v1/audit-logs?limit=50&action=acme.only"
    )
    items = acme_view_of_own_action.json()["items"]
    assert len(items) == 3
    assert all(item["action"] == "acme.only" for item in items)


def test_date_range_filter_narrows_results(fake_client: FakeAsyncClient) -> None:
    _insert_events(fake_client, ACME_COMPANY_ID, 2, action="recent", days_ago=1.0)
    _insert_events(fake_client, ACME_COMPANY_ID, 2, action="old", days_ago=200.0)
    today = utc_now().date()
    from_date = (utc_now() - timedelta(days=30)).date()

    in_range = _get(
        _identity(),
        f"/api/v1/audit-logs?limit=50&action=recent&from_date={from_date}&to_date={today}",
    )
    assert len(in_range.json()["items"]) == 2

    out_of_range = _get(
        _identity(),
        f"/api/v1/audit-logs?limit=50&action=old&from_date={from_date}&to_date={today}",
    )
    assert out_of_range.json()["items"] == []


def test_actor_action_target_type_filters(fake_client: FakeAsyncClient) -> None:
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        1,
        action="widget.created",
        target_type="widget",
        actor_uid="demo-acme-company_admin",
        id_prefix="match-",
    )
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        1,
        action="widget.deleted",
        target_type="gadget",
        actor_uid="demo-acme-field_inspector",
        id_prefix="nomatch-",
    )

    by_actor = _get(
        _identity(), "/api/v1/audit-logs?limit=50&actor_uid=demo-acme-company_admin"
    ).json()["items"]
    assert {item["action"] for item in by_actor} == {"widget.created"}

    by_action = _get(
        _identity(), "/api/v1/audit-logs?limit=50&action=widget.deleted"
    ).json()["items"]
    assert {item["target_type"] for item in by_action} == {"gadget"}

    by_target = _get(
        _identity(), "/api/v1/audit-logs?limit=50&target_type=widget"
    ).json()["items"]
    assert {item["action"] for item in by_target} == {"widget.created"}

    combined = _get(
        _identity(),
        "/api/v1/audit-logs?limit=50&action=widget.created&target_type=widget",
    ).json()["items"]
    assert len(combined) == 1
    assert combined[0]["action"] == "widget.created"


def test_text_search_matches_metadata(fake_client: FakeAsyncClient) -> None:
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        1,
        action="role.permissions_updated",
        metadata={"added": ["assets.write"], "removed": []},
        id_prefix="meta-",
    )
    response = _get(_identity(), "/api/v1/audit-logs?limit=50&q=assets.write")
    assert response.status_code == 200
    items = response.json()["items"]
    assert any(item["action"] == "role.permissions_updated" for item in items)

    miss = _get(_identity(), "/api/v1/audit-logs?limit=50&q=nonexistent-token")
    assert miss.json()["items"] == []


def test_pagination_cursor_walks_without_overlap(fake_client: FakeAsyncClient) -> None:
    company = "cursor-co"
    _insert_events(fake_client, company, 25, action="paged")
    identity = _identity(company_id=company)
    seen: list[str] = []
    cursor: str | None = None
    for _ in range(4):
        path = "/api/v1/audit-logs?limit=10"
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


def test_invalid_cursor_is_rejected(fake_client: FakeAsyncClient) -> None:
    response = _get(_identity(), "/api/v1/audit-logs?cursor=not-valid")
    assert response.status_code == 422
    assert response.json()["error"] == "invalid_cursor"


def test_date_range_too_wide_is_rejected(fake_client: FakeAsyncClient) -> None:
    today = utc_now().date()
    too_far = (utc_now() - timedelta(days=800)).date()
    response = _get(
        _identity(), f"/api/v1/audit-logs?from_date={too_far}&to_date={today}"
    )
    assert response.status_code == 422
    assert response.json()["error"] == "date_range_too_wide"


def test_deleted_actor_enrichment_does_not_crash(fake_client: FakeAsyncClient) -> None:
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        1,
        action="ghost.action",
        actor_uid="no-longer-exists",
        id_prefix="ghost-",
    )
    response = _get(_identity(), "/api/v1/audit-logs?limit=50&action=ghost.action")
    assert response.status_code == 200
    item = response.json()["items"][0]
    assert item["actor_uid"] == "no-longer-exists"
    assert item["actor_name"] is None
    assert item["actor_role"] is None


def test_facets_return_distinct_actions_and_target_types(
    fake_client: FakeAsyncClient,
) -> None:
    _insert_events(
        fake_client, ACME_COMPANY_ID, 1, action="facet.one", target_type="alpha"
    )
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        1,
        action="facet.two",
        target_type="beta",
        id_prefix="second-",
    )
    response = _get(_identity(), "/api/v1/audit-logs/actions")
    assert response.status_code == 200
    body = response.json()
    assert {"facet.one", "facet.two"}.issubset(set(body["actions"]))
    assert {"alpha", "beta"}.issubset(set(body["target_types"]))


def test_truncated_flag_set_when_range_hits_cap(
    fake_client: FakeAsyncClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(query_service_module, "AUDIT_QUERY_CAP", 5)
    _insert_events(fake_client, ACME_COMPANY_ID, 8, action="capped")
    response = _get(_identity(), "/api/v1/audit-logs?limit=50&action=capped")
    assert response.status_code == 200
    assert response.json()["truncated"] is True


def test_export_produces_matching_csv(fake_client: FakeAsyncClient) -> None:
    _insert_events(
        fake_client,
        ACME_COMPANY_ID,
        2,
        action="export.me",
        id_prefix="export-",
    )
    response = _get(_identity(), "/api/v1/audit-logs/export?action=export.me")
    assert response.status_code == 200
    assert response.headers["content-type"].startswith("text/csv")
    assert "attachment" in response.headers["content-disposition"]
    rows = list(csv.reader(io.StringIO(response.text)))
    header, *data_rows = rows
    assert header == [
        "timestamp",
        "actor_uid",
        "actor_name",
        "actor_role",
        "action",
        "target_type",
        "target_id",
        "metadata",
    ]
    assert len(data_rows) == 2
    assert all(row[4] == "export.me" for row in data_rows)


def test_export_over_cap_is_rejected(
    fake_client: FakeAsyncClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(query_service_module, "AUDIT_QUERY_CAP", 3)
    _insert_events(fake_client, ACME_COMPANY_ID, 5, action="too.many")
    response = _get(_identity(), "/api/v1/audit-logs/export?action=too.many")
    assert response.status_code == 413
    assert response.json()["error"] == "export_too_large"


def test_reading_audit_logs_writes_no_new_audit_entries(
    fake_client: FakeAsyncClient,
) -> None:
    _insert_events(fake_client, ACME_COMPANY_ID, 2, action="observe.me")
    before = fake_client.counts()["audit_logs"]
    _get(_identity(), "/api/v1/audit-logs?limit=50")
    _get(_identity(), "/api/v1/audit-logs/actions")
    _get(_identity(), "/api/v1/audit-logs/export")
    after = fake_client.counts()["audit_logs"]
    assert after == before
