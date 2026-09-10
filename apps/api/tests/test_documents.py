import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_documents_api_contract_shapes() -> None:
    # Verify openapi includes list_documents and create_document
    response = client.get("/openapi.json")
    assert response.status_code == 200
    schema = response.json()
    paths = schema.get("paths", {})
    assert "/api/v1/documents" in paths
    assert "get" in paths["/api/v1/documents"]
    assert "post" in paths["/api/v1/documents"]
    assert "/api/v1/documents/{document_id}" in paths
