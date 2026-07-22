import base64
import binascii
import json
from dataclasses import dataclass
from datetime import datetime, timedelta

from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import AuditLogEntry, AuditLogFacets, AuditLogPage
from app.models.base import CompanyScope
from app.models.entities import AuditLog

# Read-cost policy (D-019, extended for 3.4): every audit read is bounded by a
# caller-supplied date range on the already-indexed `created_at` field (no new
# Firestore index), hard-capped in memory. The same cap doubles as the export
# row ceiling — a compliance export must never silently truncate, so exceeding
# it is a 413 asking the caller to narrow the range instead.
AUDIT_QUERY_CAP = 25_000
MAX_RANGE_DAYS = 730
DEFAULT_WINDOW_DAYS = 90


class AuditQueryError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.code = code
        self.message = message
        self.details = details


@dataclass(frozen=True)
class AuditQueryFilters:
    start: datetime
    end: datetime
    actor_uid: str | None = None
    action: str | None = None
    target_type: str | None = None
    q: str | None = None


def default_range(now: datetime) -> tuple[datetime, datetime]:
    return now - timedelta(days=DEFAULT_WINDOW_DAYS), now


def _validate_range(start: datetime, end: datetime) -> None:
    if end < start:
        raise AuditQueryError(
            422,
            "invalid_date_range",
            "The end of the range must not be before its start",
        )
    if (end - start) > timedelta(days=MAX_RANGE_DAYS):
        raise AuditQueryError(
            422,
            "date_range_too_wide",
            f"Date range must not exceed {MAX_RANGE_DAYS} days",
            {"max_days": MAX_RANGE_DAYS},
        )


def _matches(event: AuditLog, filters: AuditQueryFilters) -> bool:
    if filters.actor_uid and event.actor_uid != filters.actor_uid:
        return False
    if filters.action and event.action != filters.action:
        return False
    if filters.target_type and event.target_type != filters.target_type:
        return False
    if filters.q:
        needle = filters.q.lower()
        haystack = " ".join(
            (
                event.action,
                event.target_type,
                event.target_id,
                json.dumps(event.metadata, default=str),
            )
        ).lower()
        if needle not in haystack:
            return False
    return True


def _encode_cursor(created_at: datetime, event_id: str) -> str:
    raw = f"{created_at.isoformat()}~{event_id}"
    return base64.urlsafe_b64encode(raw.encode()).decode()


def _decode_cursor(cursor: str) -> tuple[datetime, str]:
    try:
        raw = base64.urlsafe_b64decode(cursor.encode()).decode()
        raw_time, _, event_id = raw.partition("~")
        return datetime.fromisoformat(raw_time), event_id
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise AuditQueryError(422, "invalid_cursor", "Cursor is not valid") from error


class AuditQueryService:
    def __init__(
        self,
        *,
        audit_logs: AuditLogRepository,
        users: UserRepository,
        roles: RoleRepository,
    ) -> None:
        self._audit_logs = audit_logs
        self._users = users
        self._roles = roles

    async def _fetch(
        self, scope: CompanyScope, filters: AuditQueryFilters
    ) -> tuple[list[AuditLog], bool]:
        _validate_range(filters.start, filters.end)
        raw = await self._audit_logs.list_range(
            scope, filters.start, filters.end, AUDIT_QUERY_CAP
        )
        truncated = len(raw) >= AUDIT_QUERY_CAP
        return [event for event in raw if _matches(event, filters)], truncated

    async def _enrich(
        self, scope: CompanyScope, events: list[AuditLog]
    ) -> list[AuditLogEntry]:
        users = await self._users.list(scope)
        roles = await self._roles.list(scope)
        names = {user.id: user.display_name for user in users}
        user_role_ids = {user.id: user.role_id for user in users}
        role_names = {role.id: role.name for role in roles}
        entries = []
        for event in events:
            role_id = user_role_ids.get(event.actor_uid)
            entries.append(
                AuditLogEntry(
                    id=event.id,
                    actor_uid=event.actor_uid,
                    actor_name=names.get(event.actor_uid),
                    actor_role=role_names.get(role_id) if role_id else None,
                    action=event.action,
                    target_type=event.target_type,
                    target_id=event.target_id,
                    metadata=event.metadata,
                    created_at=event.created_at,
                )
            )
        return entries

    async def list_entries(
        self,
        scope: CompanyScope,
        filters: AuditQueryFilters,
        *,
        cursor: str | None,
        limit: int,
    ) -> AuditLogPage:
        events, truncated = await self._fetch(scope, filters)
        if cursor:
            after_time, after_id = _decode_cursor(cursor)
            events = [
                event
                for event in events
                if (event.created_at, event.id) < (after_time, after_id)
            ]
        page = events[:limit]
        items = await self._enrich(scope, page)
        next_cursor = (
            _encode_cursor(page[-1].created_at, page[-1].id)
            if len(events) > limit and page
            else None
        )
        return AuditLogPage(items=items, next_cursor=next_cursor, truncated=truncated)

    async def list_facets(
        self, scope: CompanyScope, start: datetime, end: datetime
    ) -> AuditLogFacets:
        _validate_range(start, end)
        events = await self._audit_logs.list_range(scope, start, end, AUDIT_QUERY_CAP)
        actions = sorted({event.action for event in events})
        target_types = sorted({event.target_type for event in events})
        return AuditLogFacets(actions=actions, target_types=target_types)

    async def export_entries(
        self, scope: CompanyScope, filters: AuditQueryFilters
    ) -> list[AuditLogEntry]:
        events, truncated = await self._fetch(scope, filters)
        if truncated:
            raise AuditQueryError(
                413,
                "export_too_large",
                f"The filtered result set exceeds the {AUDIT_QUERY_CAP}-row export "
                "cap; narrow the date range or filters and try again",
                {"cap": AUDIT_QUERY_CAP},
            )
        return await self._enrich(scope, events)


def get_audit_query_service() -> AuditQueryService:
    client = get_firestore_client()
    return AuditQueryService(
        audit_logs=AuditLogRepository(client),
        users=UserRepository(client),
        roles=RoleRepository(client),
    )
