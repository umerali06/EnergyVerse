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
