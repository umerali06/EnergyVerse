from datetime import datetime
from uuid import uuid4

from google.cloud.firestore_v1 import FieldFilter
from google.cloud.firestore_v1.async_client import AsyncClient

from app.db.firestore import get_firestore_client
from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS
from app.models.base import CompanyScope, utc_now
from app.models.entities import AuditEvent, AuditLog


class AuditLogRepository:
    collection_name = "audit_logs"

    def __init__(self, client: AsyncClient | None = None) -> None:
        self._client = client or get_firestore_client()

    async def append(
        self,
        scope: CompanyScope,
        event: AuditEvent,
        event_id: str | None = None,
    ) -> AuditLog:
        if event.company_id != scope.company_id:
            raise PermissionError("Audit event company does not match scope")
        audit_log = AuditLog(
            id=event_id or uuid4().hex,
            company_id=scope.company_id,
            actor_uid=event.actor_uid,
            action=event.action,
            target_type=event.target_type,
            target_id=event.target_id,
            metadata=event.metadata,
            created_at=utc_now(),
        )
        await (
            self._client.collection(self.collection_name)
            .document(audit_log.id)
            .set(
                audit_log.model_dump(),
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        )
        return audit_log

    async def get(self, scope: CompanyScope, event_id: str) -> AuditLog | None:
        snapshot = (
            await self._client.collection(self.collection_name)
            .document(event_id)
            .get(
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        )
        if not snapshot.exists:
            return None
        data = snapshot.to_dict()
        if data is None or data.get("company_id") != scope.company_id:
            return None
        return AuditLog.model_validate(data)

    async def list_since(
        self,
        scope: CompanyScope,
        since: datetime,
        max_events: int = 5000,
    ) -> list[AuditLog]:
        """Bounded-window tenant audit read for dashboard aggregation.

        Read cost: one query filtered to the tenant and the window start, so
        Firestore reads are capped by the tenant's audit volume inside the
        window (max 90 days) with a hard in-memory cap as a backstop.
        """
        query = (
            self._client.collection(self.collection_name)
            .where(filter=FieldFilter("company_id", "==", scope.company_id))
            .where(filter=FieldFilter("created_at", ">=", since))
        )
        audit_logs = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                audit_logs.append(AuditLog.model_validate(data))
        audit_logs.sort(key=lambda log: (log.created_at, log.id), reverse=True)
        return audit_logs[:max_events]

    async def list_range(
        self,
        scope: CompanyScope,
        start: datetime,
        end: datetime,
        max_events: int,
    ) -> list[AuditLog]:
        """Bounded date-range tenant audit read for the 3.4 audit viewer.

        Read cost: one query filtered to the tenant plus a `created_at` floor and
        ceiling on the same already-indexed field (no new composite index needed
        beyond the existing `company_id + created_at`), hard-capped in memory —
        same read-cost shape as `list_since`, but with a caller-controlled range
        instead of a fixed window.
        """
        query = (
            self._client.collection(self.collection_name)
            .where(filter=FieldFilter("company_id", "==", scope.company_id))
            .where(filter=FieldFilter("created_at", ">=", start))
            .where(filter=FieldFilter("created_at", "<=", end))
        )
        audit_logs = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                audit_logs.append(AuditLog.model_validate(data))
        audit_logs.sort(key=lambda log: (log.created_at, log.id), reverse=True)
        return audit_logs[:max_events]

    async def list(self, scope: CompanyScope) -> list[AuditLog]:
        query = self._client.collection(self.collection_name).where(
            filter=FieldFilter("company_id", "==", scope.company_id)
        )
        audit_logs = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                audit_logs.append(AuditLog.model_validate(data))
        return audit_logs
