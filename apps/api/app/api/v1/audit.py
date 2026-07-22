import csv
import io
import json
from datetime import UTC, date, datetime, time, timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, Query
from fastapi.responses import StreamingResponse

from app.audit.query_service import (
    AuditQueryError,
    AuditQueryFilters,
    AuditQueryService,
    default_range,
    get_audit_query_service,
)
from app.core.errors import ApiError
from app.models.api import AuditLogFacets, AuditLogPage, error_responses
from app.models.base import CompanyScope, utc_now
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/audit-logs", tags=["audit"])

_audit_access = require_permission("audit.read")


def _raise_api_error(error: AuditQueryError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


def _day_bounds(day: date, *, end_of_day: bool) -> datetime:
    moment = time.max if end_of_day else time.min
    return datetime.combine(day, moment, tzinfo=UTC)


def _resolve_range(
    now: datetime, from_date: date | None, to_date: date | None
) -> tuple[datetime, datetime]:
    if from_date is None and to_date is None:
        return default_range(now)
    start = _day_bounds(from_date, end_of_day=False) if from_date else now - timedelta(
        days=730
    )
    end = _day_bounds(to_date, end_of_day=True) if to_date else now
    return start, end


@router.get(
    "",
    response_model=AuditLogPage,
    operation_id="list_audit_logs",
    responses=error_responses(401, 403, 422, 500),
)
async def list_audit_logs(
    current_user: Annotated[CurrentUser, Depends(_audit_access)],
    service: Annotated[AuditQueryService, Depends(get_audit_query_service)],
    from_date: Annotated[date | None, Query()] = None,
    to_date: Annotated[date | None, Query()] = None,
    actor_uid: Annotated[str | None, Query(max_length=200)] = None,
    action: Annotated[str | None, Query(max_length=120)] = None,
    target_type: Annotated[str | None, Query(max_length=120)] = None,
    q: Annotated[str | None, Query(max_length=200)] = None,
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> AuditLogPage:
    scope = CompanyScope(company_id=current_user.company_id)
    start, end = _resolve_range(utc_now(), from_date, to_date)
    filters = AuditQueryFilters(
        start=start,
        end=end,
        actor_uid=actor_uid,
        action=action,
        target_type=target_type,
        q=q,
    )
    try:
        return await service.list_entries(scope, filters, cursor=cursor, limit=limit)
    except AuditQueryError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/actions",
    response_model=AuditLogFacets,
    operation_id="get_audit_log_facets",
    responses=error_responses(401, 403, 422, 500),
)
async def get_audit_log_facets(
    current_user: Annotated[CurrentUser, Depends(_audit_access)],
    service: Annotated[AuditQueryService, Depends(get_audit_query_service)],
    from_date: Annotated[date | None, Query()] = None,
    to_date: Annotated[date | None, Query()] = None,
) -> AuditLogFacets:
    scope = CompanyScope(company_id=current_user.company_id)
    start, end = _resolve_range(utc_now(), from_date, to_date)
    try:
        return await service.list_facets(scope, start, end)
    except AuditQueryError as error:
        _raise_api_error(error)
        raise


CSV_COLUMNS = (
    "timestamp",
    "actor_uid",
    "actor_name",
    "actor_role",
    "action",
    "target_type",
    "target_id",
    "metadata",
)


@router.get(
    "/export",
    operation_id="export_audit_logs",
    responses={
        200: {
            "description": "CSV export of the filtered audit trail",
            "content": {"text/csv": {"schema": {"type": "string", "format": "binary"}}},
        },
        **error_responses(401, 403, 413, 422, 500),
    },
)
async def export_audit_logs(
    current_user: Annotated[CurrentUser, Depends(_audit_access)],
    service: Annotated[AuditQueryService, Depends(get_audit_query_service)],
    from_date: Annotated[date | None, Query()] = None,
    to_date: Annotated[date | None, Query()] = None,
    actor_uid: Annotated[str | None, Query(max_length=200)] = None,
    action: Annotated[str | None, Query(max_length=120)] = None,
    target_type: Annotated[str | None, Query(max_length=120)] = None,
    q: Annotated[str | None, Query(max_length=200)] = None,
) -> StreamingResponse:
    scope = CompanyScope(company_id=current_user.company_id)
    start, end = _resolve_range(utc_now(), from_date, to_date)
    filters = AuditQueryFilters(
        start=start,
        end=end,
        actor_uid=actor_uid,
        action=action,
        target_type=target_type,
        q=q,
    )
    try:
        entries = await service.export_entries(scope, filters)
    except AuditQueryError as error:
        _raise_api_error(error)
        raise

    buffer = io.StringIO()
    writer = csv.writer(buffer)
    writer.writerow(CSV_COLUMNS)
    for entry in entries:
        writer.writerow(
            (
                entry.created_at.isoformat(),
                entry.actor_uid,
                entry.actor_name or "",
                entry.actor_role or "",
                entry.action,
                entry.target_type,
                entry.target_id,
                json.dumps(entry.metadata, default=str),
            )
        )
    buffer.seek(0)
    filename = f"audit-log-{current_user.company_id}-{start.date()}-{end.date()}.csv"
    return StreamingResponse(
        iter([buffer.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )
