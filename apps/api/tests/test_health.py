from datetime import datetime

import pytest
from fastapi.testclient import TestClient

from app.db.repositories.health import FirestoreStatus, get_firestore_status
from app.main import app


@pytest.mark.parametrize("firestore_status", ["connected", "unavailable", "unconfigured"])
def test_health_returns_valid_shape(firestore_status: FirestoreStatus) -> None:
    async def mocked_firestore_status() -> FirestoreStatus:
        return firestore_status

    app.dependency_overrides[get_firestore_status] = mocked_firestore_status
    try:
        with TestClient(app) as client:
            response = client.get("/health")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json()["service"] == "fev-api"
    assert response.json()["status"] == "ok"
    assert response.json()["firestore"] == firestore_status
    timestamp = datetime.fromisoformat(response.json()["timestamp"].replace("Z", "+00:00"))
    assert timestamp.tzinfo is not None
