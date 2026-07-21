from datetime import date, datetime
from typing import Any, Literal
from uuid import UUID

from pydantic import BaseModel, Field


class ErrorEnvelope(BaseModel):
    """Stable error contract returned by every API failure."""

    error: str = Field(description="Stable machine-readable error code")
    message: str = Field(description="Human-readable error summary")
    details: dict[str, Any] | None = Field(
        default=None,
        description="Optional structured JSON object",
    )
    request_id: UUID = Field(description="Request correlation identifier")


class ServiceResponse(BaseModel):
    service: Literal["fev-api"]
    status: Literal["ok"]


class DemoGateResponse(BaseModel):
    ok: Literal[True]


class DashboardSummary(BaseModel):
    company_name: str
    subscription_tier: str
    company_created_at: datetime
    users_total: int
    users_active: int
    roles_total: int
    audit_events: int
    window_days: int


class DashboardActivityItem(BaseModel):
    id: str
    actor_uid: str
    actor_name: str | None = None
    action: str
    target_type: str
    target_id: str
    created_at: datetime


class DashboardActivityPage(BaseModel):
    items: list[DashboardActivityItem]
    next_cursor: str | None = None


class DashboardSeriesPoint(BaseModel):
    date: date
    count: int


class DashboardActivitySeries(BaseModel):
    window_days: int
    points: list[DashboardSeriesPoint]


def error_responses(*status_codes: int) -> dict[int | str, dict[str, Any]]:
    descriptions = {
        201: "Resource created",
        401: "Authentication failed",
        403: "Authenticated caller is not authorized",
        404: "Resource was not found",
        409: "Request conflicts with current state",
        422: "Request validation failed",
        500: "Unexpected server error",
    }
    return {
        code: {"model": ErrorEnvelope, "description": descriptions[code]} for code in status_codes
    }
