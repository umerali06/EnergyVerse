from fastapi.testclient import TestClient

from app.main import app


def test_root_returns_200() -> None:
    with TestClient(app) as client:
        response = client.get("/")
    assert response.status_code == 200


def test_root_returns_expected_body() -> None:
    with TestClient(app) as client:
        response = client.get("/")
    data = response.json()
    assert data["service"] == "fev-api"
    assert data["status"] == "ok"
