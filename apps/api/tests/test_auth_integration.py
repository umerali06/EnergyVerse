import asyncio

import httpx
import pytest

from app.auth.admin import FirebaseAuthAdmin
from app.core.settings import settings
from app.main import app
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from scripts.seed import ACME_COMPANY_ID, run_seed

REAL_AUTH_CONFIGURED = bool(
    settings.firebase_credentials_configured
    and settings.firebase_project_id
    and settings.firebase_web_api_key
    and settings.seed_demo_password
)


@pytest.mark.integration
@pytest.mark.skipif(
    not REAL_AUTH_CONFIGURED,
    reason="Firebase Admin credentials, web API key, and demo password are required",
)
def test_real_firebase_password_sign_in_and_me() -> None:
    async def exercise_auth_chain() -> None:
        await run_seed(with_auth_users=True)
        email = "field_inspector@acme.example.invalid"
        async with httpx.AsyncClient(timeout=30.0) as identity_client:
            response = await identity_client.post(
                "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword",
                params={"key": settings.firebase_web_api_key},
                json={
                    "email": email,
                    "password": settings.seed_demo_password,
                    "returnSecureToken": True,
                },
            )
        response.raise_for_status()
        id_token = response.json()["idToken"]

        transport = httpx.ASGITransport(app=app)
        async with httpx.AsyncClient(
            transport=transport,
            base_url="http://testserver",
        ) as api_client:
            me_response = await api_client.get(
                "/api/v1/auth/me",
                headers={"Authorization": f"Bearer {id_token}"},
            )
            bad_response = await api_client.get(
                "/api/v1/auth/me",
                headers={"Authorization": "Bearer definitely-not-a-token"},
            )

        assert me_response.status_code == 200
        identity = me_response.json()
        assert identity["email"] == email
        assert identity["company_id"] == ACME_COMPANY_ID
        assert identity["role_key"] == "field_inspector"
        assert set(identity["permissions"]) == set(
            SYSTEM_ROLE_TEMPLATES["field_inspector"].permission_keys
        )
        assert bad_response.status_code == 401

        auth_user = await FirebaseAuthAdmin().get_user(identity["uid"])
        assert auth_user.custom_claims == {
            "company_id": ACME_COMPANY_ID,
            "role_id": "acme-energy__field_inspector",
            "role_key": "field_inspector",
        }

    asyncio.run(exercise_auth_chain())
