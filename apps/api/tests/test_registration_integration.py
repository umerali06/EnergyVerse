import asyncio
import os

import httpx
import pytest

from app.core.settings import settings
from app.db.firestore import reset_firestore_client_for_testing
from app.main import app

REAL_SIGNUP_EMAIL = os.getenv("REAL_SIGNUP_TEST_EMAIL")
REAL_SIGNUP_CONFIGURED = bool(
    settings.firebase_credentials_configured
    and settings.firebase_project_id
    and settings.firebase_web_api_key
    and settings.seed_demo_password
    and REAL_SIGNUP_EMAIL
)


@pytest.mark.integration
@pytest.mark.skipif(
    not REAL_SIGNUP_CONFIGURED,
    reason="Real Firebase config and REAL_SIGNUP_TEST_EMAIL are required",
)
def test_real_registration_dispatches_verification_email() -> None:
    """Destructive local-only proof; provide a fresh throwaway inbox each run."""

    reset_firestore_client_for_testing()

    async def exercise_registration() -> None:
        email = str(REAL_SIGNUP_EMAIL)
        password = str(settings.seed_demo_password)
        transport = httpx.ASGITransport(app=app)
        async with httpx.AsyncClient(
            transport=transport,
            base_url="http://testserver",
        ) as api_client:
            registration = await api_client.post(
                "/api/v1/auth/register",
                json={
                    "company_name": "FEV Signup Verification Test",
                    "display_name": "Signup Test Admin",
                    "email": email,
                    "password": password,
                },
            )
        assert registration.status_code == 201, registration.text
        created = registration.json()
        assert created["company_id"].startswith("cmp_")
        assert created["role_key"] == "company_admin"
        assert created["email_verified"] is False

        async with httpx.AsyncClient(timeout=30.0) as identity_client:
            sign_in = await identity_client.post(
                "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword",
                params={"key": settings.firebase_web_api_key},
                json={
                    "email": email,
                    "password": password,
                    "returnSecureToken": True,
                },
            )
            sign_in.raise_for_status()
            send_verification = await identity_client.post(
                "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode",
                params={"key": settings.firebase_web_api_key},
                json={
                    "requestType": "VERIFY_EMAIL",
                    "idToken": sign_in.json()["idToken"],
                },
            )
            send_verification.raise_for_status()
        assert send_verification.json()["email"] == email

    asyncio.run(exercise_registration())
