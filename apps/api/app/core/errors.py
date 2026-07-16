from collections.abc import Mapping
from typing import Any

from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse


async def http_exception_response(_: Request, error: Exception) -> JSONResponse:
    """Keep authentication and authorization failures as top-level JSON contracts."""
    if not isinstance(error, HTTPException):
        raise error
    if isinstance(error.detail, Mapping):
        content: dict[str, Any] = dict(error.detail)
    else:
        content = {"error": "request_failed", "message": str(error.detail)}
    return JSONResponse(
        status_code=error.status_code,
        content=content,
        headers=error.headers,
    )
