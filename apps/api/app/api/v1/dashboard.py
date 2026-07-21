import base64
import binascii
from datetime import datetime, timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import (
    DashboardActivityItem,
    DashboardActivityPage,
    DashboardActivitySeries,
    DashboardSeriesPoint,
    DashboardSummary,
    error_responses,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/dashboard", tags=["dashboard"])

# Dashboard reads are operational reporting: every system role holds
# reports.read (0.4 matrix), so the whole company can see its own dashboard
# while the client hides finer-grained cards per permission (0.6 guards).
_dashboard_access = require_permission("reports.read")

SUPPORTED_WINDOWS = (7, 30, 90)

# Read-cost policy (D-019): every audit read is bounded to the window start
# (90 days max) in a single tenant-filtered query, hard-capped in memory.
MAX_WINDOW_EVENTS = 5000


def _window_start(now: datetime, window: int) -> datetime:
    return now - timedelta(days=window)


def _validate_window(window: int) -> None:
    if window not in SUPPORTED_WINDOWS:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "error": "invalid_window",
                "message": "window must be one of 7, 30, 90",
            },
        )


@router.get(
    "/summary",
    response_model=DashboardSummary,
    operation_id="get_dashboard_summary",
    responses=error_responses(401, 403, 422, 500),
)
async def dashboard_summary(
    current_user: Annotated[CurrentUser, Depends(_dashboard_access)],
    window: Annotated[int, Query()] = 30,
) -> DashboardSummary:
    _validate_window(window)
    scope = CompanyScope(company_id=current_user.company_id)
    company = await CompanyRepository().get(scope)
    if company is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"error": "company_not_found", "message": "Company is unavailable"},
        )
    users = await UserRepository().list(scope)
    roles = await RoleRepository().list(scope)
    now = utc_now()
    events = await AuditLogRepository().list_since(
        scope, _window_start(now, window), MAX_WINDOW_EVENTS
    )
    return DashboardSummary(
        company_name=company.name,
        subscription_tier=company.subscription_tier,
        company_created_at=company.created_at,
        users_total=len(users),
        users_active=sum(1 for user in users if user.status == "active"),
        roles_total=len(roles),
        audit_events=len(events),
        window_days=window,
    )


def _encode_cursor(created_at: datetime, event_id: str) -> str:
    # base64url keeps the cursor opaque and URL-safe (isoformat contains "+").
    raw = f"{created_at.isoformat()}~{event_id}"
    return base64.urlsafe_b64encode(raw.encode()).decode()


def _decode_cursor(cursor: str) -> tuple[datetime, str]:
    try:
        raw = base64.urlsafe_b64decode(cursor.encode()).decode()
        raw_time, _, event_id = raw.partition("~")
        return datetime.fromisoformat(raw_time), event_id
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={"error": "invalid_cursor", "message": "Cursor is not valid"},
        ) from error


@router.get(
    "/activity",
    response_model=DashboardActivityPage,
    operation_id="get_dashboard_activity",
    responses=error_responses(401, 403, 422, 500),
)
async def dashboard_activity(
    current_user: Annotated[CurrentUser, Depends(_dashboard_access)],
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
    cursor: Annotated[str | None, Query()] = None,
    action: Annotated[str | None, Query(max_length=120)] = None,
) -> DashboardActivityPage:
    scope = CompanyScope(company_id=current_user.company_id)
    now = utc_now()
    events = await AuditLogRepository().list_since(
        scope, _window_start(now, 90), MAX_WINDOW_EVENTS
    )
    if action:
        events = [event for event in events if event.action == action]
    if cursor:
        after_time, after_id = _decode_cursor(cursor)
        events = [
            event
            for event in events
            if (event.created_at, event.id) < (after_time, after_id)
        ]
    page = events[:limit]
    users = await UserRepository().list(scope)
    names = {user.id: user.display_name for user in users}
    items = [
        DashboardActivityItem(
            id=event.id,
            actor_uid=event.actor_uid,
            actor_name=names.get(event.actor_uid),
            action=event.action,
            target_type=event.target_type,
            target_id=event.target_id,
            created_at=event.created_at,
        )
        for event in page
    ]
    next_cursor = (
        _encode_cursor(page[-1].created_at, page[-1].id)
        if len(events) > limit and page
        else None
    )
    return DashboardActivityPage(items=items, next_cursor=next_cursor)


@router.get(
    "/activity-series",
    response_model=DashboardActivitySeries,
    operation_id="get_dashboard_activity_series",
    responses=error_responses(401, 403, 422, 500),
)
async def dashboard_activity_series(
    current_user: Annotated[CurrentUser, Depends(_dashboard_access)],
    window: Annotated[int, Query()] = 30,
) -> DashboardActivitySeries:
    _validate_window(window)
    scope = CompanyScope(company_id=current_user.company_id)
    now = utc_now()
    start = _window_start(now, window - 1).date()
    events = await AuditLogRepository().list_since(
        scope, _window_start(now, window), MAX_WINDOW_EVENTS
    )
    counts: dict[str, int] = {}
    for event in events:
        key = event.created_at.date().isoformat()
        counts[key] = counts.get(key, 0) + 1
    points = []
    for offset in range(window):
        day = start + timedelta(days=offset)
        points.append(
            DashboardSeriesPoint(date=day, count=counts.get(day.isoformat(), 0))
        )
    return DashboardActivitySeries(window_days=window, points=points)
