import logging
from collections.abc import Mapping
from http import HTTPStatus
from typing import Any

from fastapi import HTTPException, Request
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app.core.request_id import REQUEST_ID_HEADER, get_request_id
from app.models.api import ErrorEnvelope

logger = logging.getLogger(__name__)

STATUS_ERROR_CODES = {
    401: "unauthorized",
    403: "forbidden",
    404: "not_found",
    409: "conflict",
    422: "validation_error",
    500: "internal_error",
}


class ApiError(Exception):
    def __init__(
        self,
        *,
        status_code: int,
        error: str,
        message: str,
        details: dict[str, Any] | None = None,
        headers: Mapping[str, str] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.error = error
        self.message = message
        self.details = details
        self.headers = dict(headers or {})


def _response(
    request: Request,
    *,
    status_code: int,
    error: str,
    message: str,
    details: dict[str, Any] | None = None,
    headers: Mapping[str, str] | None = None,
) -> JSONResponse:
    request_id = get_request_id(request)
    envelope = ErrorEnvelope(
        error=error,
        message=message,
        details=details,
        request_id=request_id,
    )
    response_headers = dict(headers or {})
    response_headers[REQUEST_ID_HEADER] = request_id
    return JSONResponse(
        status_code=status_code,
        content=jsonable_encoder(envelope.model_dump(exclude_none=True)),
        headers=response_headers,
    )


async def api_error_response(request: Request, error: Exception) -> JSONResponse:
    if not isinstance(error, ApiError):
        raise error
    return _response(
        request,
        status_code=error.status_code,
        error=error.error,
        message=error.message,
        details=error.details,
        headers=error.headers,
    )


async def http_exception_response(request: Request, error: Exception) -> JSONResponse:
    if not isinstance(error, HTTPException):
        raise error

    detail = error.detail
    machine_code = STATUS_ERROR_CODES.get(error.status_code, "request_failed")
    message = HTTPStatus(error.status_code).phrase
    details: dict[str, Any] | None = None

    if isinstance(detail, Mapping):
        supplied_code = detail.get("code") or detail.get("error")
        if isinstance(supplied_code, str):
            machine_code = supplied_code
        supplied_message = detail.get("message")
        if isinstance(supplied_message, str):
            message = supplied_message
        if "details" in detail:
            supplied_details = detail["details"]
            details = dict(supplied_details) if isinstance(supplied_details, Mapping) else None
        else:
            extra = {
                key: value
                for key, value in detail.items()
                if key not in {"code", "error", "message"}
            }
            details = extra or None
    elif detail:
        message = str(detail)

    return _response(
        request,
        status_code=error.status_code,
        error=machine_code,
        message=message,
        details=details,
        headers=error.headers,
    )


async def validation_exception_response(
    request: Request,
    error: Exception,
) -> JSONResponse:
    if not isinstance(error, RequestValidationError):
        raise error
    return _response(
        request,
        status_code=422,
        error="validation_error",
        message="Request validation failed",
        details={"errors": jsonable_encoder(error.errors())},
    )


async def unhandled_exception_response(
    request: Request,
    error: Exception,
) -> JSONResponse:
    logger.exception("Unhandled API error; request_id=%s", get_request_id(request), exc_info=error)
    return _response(
        request,
        status_code=500,
        error="internal_error",
        message="An unexpected error occurred",
    )
