import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.api.v1.notifications import router as notifications_router  # noqa: F401
from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.device_tokens import DeviceTokenRepository
from app.db.repositories.notifications import NotificationRepository
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser, UserCreate
from app.notifications.service import (
    NotificationService,
    device_token_id,
    get_notification_service,
)
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient
from tests.fakes.notifications import FakeEmailNotifier, FakePushNotifier

BETA_COMPANY_ID = "beta-utilities"

RECIPIENT_UID = "notify-recipient"
ACTOR_UID = "notify-actor"


@pytest.fixture()
def wiring() -> Any:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    users = UserRepository(client, audit)
    email = FakeEmailNotifier()
    push = FakePushNotifier()
    service = NotificationService(
        notifications=NotificationRepository(client, audit),
        device_tokens=DeviceTokenRepository(client, audit),
        users=users,
        email=email,
        push=push,
    )
    for uid, address in ((RECIPIENT_UID, "recipient"), (ACTOR_UID, "actor")):
        asyncio.run(
            users.create(
                CompanyScope(company_id=ACME_COMPANY_ID),
                UserCreate(
                    id=uid,
                    email=f"{address}@acme.example.invalid",
                    display_name=address.title(),
                    role_id="test-role",
                    status="active",
                ),
                "seed-script",
            )
        )
    app.dependency_overrides[get_notification_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "service": service, "email": email, "push": push}
    app.dependency_overrides.pop(get_notification_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(uid: str = RECIPIENT_UID, company_id: str = ACME_COMPANY_ID) -> CurrentUser:
    return CurrentUser(
        uid=uid,
        email=f"{uid}@acme.example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Acme Energy",
        role_key="company_admin",
        permissions=frozenset(SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys),
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _notify(wiring: Any, **overrides: Any) -> Any:
    payload: dict[str, Any] = {
        "user_id": RECIPIENT_UID,
        "event": "work_order.assigned",
        "title": "New work order assigned",
        "body": "Replace pump seal was assigned to you.",
        "target_type": "work_order",
        "target_id": "wo-1",
        "actor_uid": ACTOR_UID,
    }
    payload.update(overrides)
    return asyncio.run(
        wiring["service"].notify(CompanyScope(company_id=ACME_COMPANY_ID), **payload)
    )


def test_notify_stores_an_in_app_record(wiring: Any) -> None:
    notification = _notify(wiring)

    assert notification is not None
    assert notification.user_id == RECIPIENT_UID
    assert notification.read_at is None
    # In-app is the durable copy and is always recorded, even with no email or
    # push configured.
    assert "in_app" in notification.delivered_channels


def test_notify_never_tells_a_user_about_their_own_action(wiring: Any) -> None:
    # Assigning a work order to yourself is not news.
    assert _notify(wiring, user_id=ACTOR_UID) is None


def test_list_returns_only_the_callers_own_notifications(wiring: Any) -> None:
    _notify(wiring, user_id=RECIPIENT_UID)
    _notify(wiring, user_id="someone-else")

    body = _request(_identity(RECIPIENT_UID), "GET", "/api/v1/notifications").json()

    assert len(body["items"]) == 1
    assert body["unread_count"] == 1
    assert body["items"][0]["target_id"] == "wo-1"


def test_notifications_are_returned_newest_first(wiring: Any) -> None:
    _notify(wiring, target_id="wo-old", title="Older")
    _notify(wiring, target_id="wo-new", title="Newer")

    items = _request(_identity(), "GET", "/api/v1/notifications").json()["items"]

    assert [item["target_id"] for item in items] == ["wo-new", "wo-old"]


def test_marking_read_clears_the_unread_count(wiring: Any) -> None:
    notification = _notify(wiring)
    assert notification is not None

    response = _request(
        _identity(), "POST", f"/api/v1/notifications/{notification.id}/read"
    )
    assert response.status_code == 200
    assert response.json()["read_at"] is not None

    assert _request(_identity(), "GET", "/api/v1/notifications").json()["unread_count"] == 0


def test_marking_read_is_idempotent(wiring: Any) -> None:
    notification = _notify(wiring)
    assert notification is not None
    path = f"/api/v1/notifications/{notification.id}/read"

    first = _request(_identity(), "POST", path).json()["read_at"]
    second = _request(_identity(), "POST", path).json()["read_at"]

    # A re-read keeps the original timestamp rather than re-stamping it.
    assert first == second


def test_cannot_mark_another_users_notification_read(wiring: Any) -> None:
    notification = _notify(wiring, user_id="someone-else")
    assert notification is not None

    response = _request(
        _identity(RECIPIENT_UID), "POST", f"/api/v1/notifications/{notification.id}/read"
    )
    # Reported as missing, not forbidden, so the endpoint cannot be used to
    # probe whether another user's notification id exists.
    assert response.status_code == 404


def test_notifications_are_tenant_isolated(wiring: Any) -> None:
    _notify(wiring)

    body = _request(
        _identity(RECIPIENT_UID, company_id=BETA_COMPANY_ID), "GET", "/api/v1/notifications"
    ).json()

    assert body["items"] == []
    assert body["unread_count"] == 0


def test_mark_all_read(wiring: Any) -> None:
    _notify(wiring, target_id="wo-1")
    _notify(wiring, target_id="wo-2")

    response = _request(_identity(), "POST", "/api/v1/notifications/read-all")

    assert response.status_code == 200
    assert response.json()["marked"] == 2
    assert _request(_identity(), "GET", "/api/v1/notifications").json()["unread_count"] == 0


def test_unread_only_filter_still_reports_the_full_unread_count(wiring: Any) -> None:
    first = _notify(wiring, target_id="wo-1")
    _notify(wiring, target_id="wo-2")
    assert first is not None
    _request(_identity(), "POST", f"/api/v1/notifications/{first.id}/read")

    body = _request(
        _identity(), "GET", "/api/v1/notifications", params={"unread_only": True}
    ).json()

    assert len(body["items"]) == 1
    assert body["unread_count"] == 1


# --- delivery channels -------------------------------------------------------


def test_push_is_sent_to_every_registered_device(wiring: Any) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "device-token-1", "platform": "android"},
    )

    notification = _notify(wiring)

    assert wiring["push"].sent, "a registered device should have received a push"
    assert wiring["push"].sent[0]["tokens"] == ["device-token-1"]
    # The client routes on these rather than the server emitting a URL.
    assert wiring["push"].sent[0]["data"]["target_type"] == "work_order"
    assert notification is not None
    assert "push" in notification.delivered_channels


def test_no_push_channel_is_recorded_without_a_registered_device(wiring: Any) -> None:
    notification = _notify(wiring)

    assert wiring["push"].sent == []
    assert notification is not None
    assert "push" not in notification.delivered_channels


def test_a_token_fcm_rejects_is_pruned(wiring: Any) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "stale-token", "platform": "ios"},
    )
    wiring["push"].invalid_tokens = ["stale-token"]

    _notify(wiring)

    tokens = asyncio.run(
        DeviceTokenRepository(wiring["client"]).list_for_user(
            CompanyScope(company_id=ACME_COMPANY_ID), RECIPIENT_UID
        )
    )
    # A permanently unregistered token would only cause repeated failed sends.
    assert tokens == []


def test_registering_an_existing_token_reassigns_it(wiring: Any) -> None:
    _request(
        _identity(RECIPIENT_UID),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "shared-tablet", "platform": "android"},
    )
    _request(
        _identity(ACTOR_UID),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "shared-tablet", "platform": "android"},
    )

    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    repository = DeviceTokenRepository(wiring["client"])
    # A shared site tablet must stop pushing the previous holder's alerts.
    assert asyncio.run(repository.list_for_user(scope, RECIPIENT_UID)) == []
    assert len(asyncio.run(repository.list_for_user(scope, ACTOR_UID))) == 1


def test_device_token_is_not_stored_as_the_document_id(wiring: Any) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "secret-token", "platform": "web"},
    )

    # The raw token is a credential; the id is a hash so it is safe to log.
    assert device_token_id("secret-token") != "secret-token"
    stored = asyncio.run(
        DeviceTokenRepository(wiring["client"]).get(
            CompanyScope(company_id=ACME_COMPANY_ID), device_token_id("secret-token")
        )
    )
    assert stored is not None
    assert stored.token == "secret-token"


def test_unregistering_a_device_stops_its_push(wiring: Any) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "signed-out", "platform": "android"},
    )
    _request(_identity(), "DELETE", "/api/v1/notifications/devices/signed-out")

    _notify(wiring)

    assert wiring["push"].sent == []


def test_an_invalid_platform_is_rejected(wiring: Any) -> None:
    response = _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "t", "platform": "blackberry"},
    )
    assert response.status_code == 422


def test_an_in_app_only_event_does_not_push(wiring: Any) -> None:
    _request(
        _identity(),
        "POST",
        "/api/v1/notifications/devices",
        json={"token": "device-token-1", "platform": "android"},
    )

    # `report.finalized` is deliberately not in PUSH_EVENTS: routine traffic
    # must not train people to ignore their phone.
    notification = _notify(
        wiring, event="report.finalized", target_type="report", target_id="rep-1"
    )

    assert wiring["push"].sent == []
    assert notification is not None
    assert notification.delivered_channels == ["in_app"]
