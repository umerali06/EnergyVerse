import os

import pytest
from fastapi.testclient import TestClient

from app.main import app

has_real_credentials = bool(
    os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    or os.getenv("FIREBASE_CREDENTIALS_B64")
)


@pytest.mark.integration
@pytest.mark.skipif(not has_real_credentials, reason="Firebase credentials are not configured")
def test_health_connects_to_real_firestore() -> None:
    with TestClient(app) as client:
        response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["firestore"] == "connected"
