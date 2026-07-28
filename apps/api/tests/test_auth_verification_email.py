import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

import app.auth.verification as verification_module
from app.auth.dependencies import get_current_user
from app.auth.verification import VerificationEmailService, get_verification_email_service
from app.db.repositories.users import UserRepository
from app.main import app
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.email import FakeEmailSender
from tests.fakes.firestore import FakeAsyncClient


def _identity(*, email_verified: bool) -> CurrentUser:
    return CurrentUser(
        uid="demo-acme-executive",
        email="executive@acme.example.invalid",
        email_verified=email_verified,
        company_id=ACME_COMPANY_ID,
        company_name="Acme Energy",
        role_key="executive",
        permissions=frozenset(),
    )


def _request(identity: CurrentUser, sender: FakeEmailSender, users: UserRepository) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    app.dependency_overrides[get_verification_email_service] = (
        lambda: VerificationEmailService(users=users, sender=sender)
    )
    try:
        with TestClient(app) as client:
            return client.post("/api/v1/auth/verification-email")
    finally:
        app.dependency_overrides.clear()


def test_sends_branded_email_with_generated_link(monkeypatch: pytest.MonkeyPatch) -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    users = UserRepository(firestore)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    expected_user = asyncio.run(users.get(scope, "demo-acme-executive"))
    assert expected_user is not None

    async def fake_generate(email: str) -> str:
        assert email == "executive@acme.example.invalid"
        return "https://fake-verify.example.test/action?oobCode=abc123"

    monkeypatch.setattr(verification_module, "generate_email_verification_link", fake_generate)

    sender = FakeEmailSender()
    response = _request(_identity(email_verified=False), sender, users)

    assert response.status_code == 200
    assert response.json() == {"sent": True}
    assert len(sender.sent) == 1
    message = sender.sent[0]
    assert message.to == "executive@acme.example.invalid"
    assert expected_user.display_name in message.html_body
    assert "https://fake-verify.example.test/action?oobCode=abc123" in message.html_body
    assert "https://fake-verify.example.test/action?oobCode=abc123" in message.text_body
    assert message.inline_images


def test_already_verified_user_does_not_send(monkeypatch: pytest.MonkeyPatch) -> None:
    firestore = FakeAsyncClient()
    asyncio.run(run_seed(firestore))
    users = UserRepository(firestore)

    async def fail_if_called(email: str) -> str:
        raise AssertionError("should not generate a link for an already-verified user")

    monkeypatch.setattr(verification_module, "generate_email_verification_link", fail_if_called)

    sender = FakeEmailSender()
    response = _request(_identity(email_verified=True), sender, users)

    assert response.status_code == 200
    assert response.json() == {"sent": False}
    assert sender.sent == []
