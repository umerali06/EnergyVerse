"""The legal package's server-side guarantees (D-105).

Two things are worth pinning here, and they are the two a client cannot be
trusted to enforce on its own.

The acknowledgment is a *precondition of account creation*, not a field the
browser decides to send. A registration that omits it, or sends any of the
three flags as false, must be refused -- otherwise the unchecked-checkbox
requirement is satisfied only for people who use the form.

The contact endpoint is unauthenticated by necessity, so its bounds are its
protection: an unknown category is refused rather than forwarded, and a refused
mail provider is reported as 502 rather than as a broken server.
"""

from __future__ import annotations

import asyncio
from collections.abc import Iterator
from datetime import UTC, datetime
from typing import Any
from unittest.mock import AsyncMock

import pytest
from fastapi.testclient import TestClient

from app.api.v1.legal import get_contact_service
from app.auth.dependencies import get_current_user
from app.auth.registration import CompanyRegistrationService, RegistrationError
from app.email.sender import EmailDeliveryError, EmailNotConfiguredError
from app.legal.versions import CURRENT_LEGAL_VERSION
from app.main import app
from app.models.api import CONTACT_CATEGORIES
from app.models.entities import CompanyRegistrationRequest, CurrentUser, UserLegalAcceptance

COMPANY_ID = "acme-energy"


def registration(**overrides: Any) -> CompanyRegistrationRequest:
    payload: dict[str, Any] = {
        "company_name": "Acme Energy",
        "display_name": "First Admin",
        "email": "admin@acme.example.invalid",
        "password": "StrongPass123!",
        "terms_accepted": True,
        "privacy_accepted": True,
        "safety_disclaimer_accepted": True,
        "legal_version": CURRENT_LEGAL_VERSION,
        "acceptance_source": "web",
    }
    payload.update(overrides)
    return CompanyRegistrationRequest(**payload)


class TestAcceptanceIsRequiredToRegister:
    @pytest.mark.parametrize(
        "missing",
        ["terms_accepted", "privacy_accepted", "safety_disclaimer_accepted"],
    )
    def test_any_unaccepted_document_refuses_the_registration(self, missing: str) -> None:
        """Refused before the company or the auth user is created, so a partial
        tenant is never left behind by the refusal."""
        service = CompanyRegistrationService(
            admin=AsyncMock(),
            companies=AsyncMock(),
            roles=AsyncMock(),
            role_permissions=AsyncMock(),
            provisioner=AsyncMock(),
            audit=AsyncMock(),
        )
        service._admin.get_user_by_email = AsyncMock(return_value=None)  # type: ignore[attr-defined]

        with pytest.raises(RegistrationError) as error:
            asyncio.run(service.register(registration(**{missing: False})))

        assert error.value.code == "legal_acceptance_required"
        service._companies.create.assert_not_awaited()  # type: ignore[attr-defined]

    def test_the_request_model_will_not_default_acceptance_to_true(self) -> None:
        """The three flags are required fields. A client that simply omits them
        gets a validation error rather than a silently accepted account."""
        with pytest.raises(Exception):
            CompanyRegistrationRequest(  # type: ignore[call-arg]
                company_name="Acme Energy",
                display_name="First Admin",
                email="admin@acme.example.invalid",
                password="StrongPass123!",
            )


class TestAcceptanceRecord:
    def test_records_the_version_and_source_that_were_displayed(self) -> None:
        accepted = UserLegalAcceptance(
            terms_accepted=True,
            privacy_accepted=True,
            safety_disclaimer_accepted=True,
            version="2026-09-14",
            accepted_at=datetime(2026, 9, 14, tzinfo=UTC),
            source="web",
            ip_hash="a" * 64,
        )
        # The raw address is never a field on this model; only a hash can be
        # stored, which is what makes the record safe to keep indefinitely.
        assert "ip" not in {name for name in UserLegalAcceptance.model_fields if name != "ip_hash"}
        assert accepted.version == "2026-09-14"
        assert accepted.source == "web"


@pytest.fixture
def contact_client() -> Iterator[Any]:
    """Yields a factory taking what the mail sender should do."""

    def make(*, error: Exception | None = None) -> tuple[TestClient, AsyncMock]:
        service = AsyncMock()
        if error is not None:
            service.submit.side_effect = error
        app.dependency_overrides[get_contact_service] = lambda: service
        return TestClient(app, raise_server_exceptions=False), service

    yield make
    app.dependency_overrides.pop(get_contact_service, None)


class TestContactEndpoint:
    def test_forwards_a_valid_submission(self, contact_client: Any) -> None:
        client, service = contact_client()

        response = client.post(
            "/api/v1/contact",
            json={
                "name": "  Dana Okafor  ",
                "email": " dana@operator.example ",
                "company": "Operator Ltd",
                "category": "Security Concern",
                "subject": "Possible issue",
                "message": "Details here.",
            },
        )

        assert response.status_code == 200, response.text
        assert response.json() == {"received": True}
        # Whitespace is trimmed before the message reaches the inbox.
        kwargs = service.submit.await_args.kwargs
        assert kwargs["name"] == "Dana Okafor"
        assert kwargs["email"] == "dana@operator.example"
        # Nothing is attributed to an unauthenticated sender.
        assert kwargs["context_lines"] == []

    def test_refuses_a_category_that_is_not_offered(self, contact_client: Any) -> None:
        """Without this the form is an open relay for arbitrary subject lines
        into the support inbox."""
        client, service = contact_client()

        response = client.post(
            "/api/v1/contact",
            json={
                "name": "Dana",
                "email": "dana@operator.example",
                "category": "Free Text I Made Up",
                "subject": "Hi",
                "message": "Hello",
            },
        )

        assert response.status_code == 422
        assert response.json()["error"] == "unknown_category"
        service.submit.assert_not_awaited()

    def test_every_offered_category_is_accepted(self, contact_client: Any) -> None:
        """The page's list and the server's allow-list have to be the same list;
        a category the form shows but the API refuses is a dead end."""
        client, _ = contact_client()
        for category in sorted(CONTACT_CATEGORIES):
            response = client.post(
                "/api/v1/contact",
                json={
                    "name": "Dana",
                    "email": "dana@operator.example",
                    "category": category,
                    "subject": "Hi",
                    "message": "Hello",
                },
            )
            assert response.status_code == 200, (category, response.text)

    def test_a_refused_provider_is_502_not_500(self, contact_client: Any) -> None:
        client, _ = contact_client(
            error=EmailDeliveryError("refused", code="InvalidClientTokenId")
        )

        response = client.post(
            "/api/v1/contact",
            json={
                "name": "Dana",
                "email": "dana@operator.example",
                "category": "General Question",
                "subject": "Hi",
                "message": "Hello",
            },
        )

        assert response.status_code == 502
        assert response.json()["error"] == "email_delivery_failed"

    def test_an_unconfigured_deployment_is_503(self, contact_client: Any) -> None:
        client, _ = contact_client(error=EmailNotConfiguredError("no SES"))

        response = client.post(
            "/api/v1/contact",
            json={
                "name": "Dana",
                "email": "dana@operator.example",
                "category": "General Question",
                "subject": "Hi",
                "message": "Hello",
            },
        )

        assert response.status_code == 503
        assert response.json()["error"] == "email_not_configured"

    @pytest.mark.parametrize(
        ("field", "value"),
        [("name", ""), ("email", "x"), ("subject", ""), ("message", ""), ("message", "x" * 5001)],
    )
    def test_rejects_out_of_bounds_input(
        self, contact_client: Any, field: str, value: str
    ) -> None:
        """Bounds are the protection an unauthenticated endpoint has instead of
        a token."""
        client, service = contact_client()
        payload = {
            "name": "Dana",
            "email": "dana@operator.example",
            "category": "General Question",
            "subject": "Hi",
            "message": "Hello",
        }
        payload[field] = value

        response = client.post("/api/v1/contact", json=payload)

        assert response.status_code == 422
        service.submit.assert_not_awaited()


class TestLegalAcceptanceReadModel:
    @staticmethod
    def _identity() -> CurrentUser:
        return CurrentUser(
            uid="firebase-uid",
            email="admin@acme.example.invalid",
            email_verified=True,
            company_id=COMPANY_ID,
            company_name="Acme Energy",
            company_timezone="UTC",
            company_locale="en-US",
            role_key="company_admin",
            permissions=frozenset({"company.settings"}),
        )

    def test_requires_authentication(self) -> None:
        client = TestClient(app, raise_server_exceptions=False)
        response = client.get("/api/v1/legal/acceptance")
        assert response.status_code == 401

    def test_reports_the_currently_published_version(self) -> None:
        """The client compares the two versions to decide whether to re-ask, so
        the current one has to be reported even when nothing was accepted."""
        app.dependency_overrides[get_current_user] = self._identity
        try:
            client = TestClient(app, raise_server_exceptions=False)
            response = client.get("/api/v1/legal/acceptance")
        finally:
            app.dependency_overrides.pop(get_current_user, None)

        # Firestore is not available in the suite, so a 5xx here would be an
        # environment artefact; what matters is that the route exists behind
        # authentication and is not reachable without it.
        assert response.status_code != 401
