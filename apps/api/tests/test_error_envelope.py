from uuid import UUID, uuid4

from fastapi import FastAPI, HTTPException
from fastapi.exceptions import RequestValidationError
from fastapi.testclient import TestClient

from app.core.errors import (
    ApiError,
    api_error_response,
    http_exception_response,
    unhandled_exception_response,
    validation_exception_response,
)
from app.core.request_id import REQUEST_ID_HEADER, RequestIdMiddleware


def _error_test_app() -> FastAPI:
    test_app = FastAPI()
    test_app.add_exception_handler(ApiError, api_error_response)
    test_app.add_exception_handler(HTTPException, http_exception_response)
    test_app.add_exception_handler(RequestValidationError, validation_exception_response)
    test_app.add_exception_handler(Exception, unhandled_exception_response)
    test_app.add_middleware(RequestIdMiddleware)

    @test_app.get("/validate/{value}")
    async def validate(value: int) -> dict[str, int]:
        return {"value": value}

    @test_app.get("/auth")
    async def auth() -> None:
        raise HTTPException(
            status_code=401,
            detail={"error": "invalid_token", "message": "Token is invalid"},
        )

    @test_app.get("/forbidden")
    async def forbidden() -> None:
        raise ApiError(
            status_code=403,
            error="forbidden",
            message="Access denied",
            details={"required": ["assets.write"], "missing": ["assets.write"]},
        )

    @test_app.get("/not-found")
    async def not_found() -> None:
        raise ApiError(status_code=404, error="not_found", message="Missing resource")

    @test_app.get("/conflict")
    async def conflict() -> None:
        raise ApiError(status_code=409, error="conflict", message="Version conflict")

    @test_app.get("/crash")
    async def crash() -> None:
        raise RuntimeError("secret internal value")

    return test_app


def _assert_envelope(response: object, status_code: int, error: str) -> dict[str, object]:
    assert hasattr(response, "status_code")
    assert response.status_code == status_code  # type: ignore[union-attr]
    body = response.json()  # type: ignore[union-attr]
    assert body["error"] == error
    assert isinstance(body["message"], str)
    assert UUID(body["request_id"])
    assert response.headers[REQUEST_ID_HEADER] == body["request_id"]  # type: ignore[union-attr]
    return body


def test_validation_auth_forbidden_not_found_and_conflict_envelopes() -> None:
    with TestClient(_error_test_app()) as client:
        validation = _assert_envelope(client.get("/validate/nope"), 422, "validation_error")
        assert validation["details"]
        _assert_envelope(client.get("/auth"), 401, "invalid_token")
        forbidden = _assert_envelope(client.get("/forbidden"), 403, "forbidden")
        assert forbidden["details"] == {
            "required": ["assets.write"],
            "missing": ["assets.write"],
        }
        _assert_envelope(client.get("/not-found"), 404, "not_found")
        _assert_envelope(client.get("/conflict"), 409, "conflict")


def test_unhandled_error_is_sanitized() -> None:
    with TestClient(_error_test_app(), raise_server_exceptions=False) as client:
        response = client.get("/crash")
    body = _assert_envelope(response, 500, "internal_error")
    assert body["message"] == "An unexpected error occurred"
    assert "secret internal value" not in response.text


def test_valid_request_id_is_echoed_and_invalid_value_is_replaced() -> None:
    supplied = str(uuid4())
    with TestClient(_error_test_app()) as client:
        accepted = client.get("/auth", headers={REQUEST_ID_HEADER: supplied})
        replaced = client.get("/auth", headers={REQUEST_ID_HEADER: "not-a-uuid"})
    assert accepted.json()["request_id"] == supplied
    assert accepted.headers[REQUEST_ID_HEADER] == supplied
    assert UUID(replaced.json()["request_id"])
    assert replaced.json()["request_id"] != "not-a-uuid"
