from collections.abc import Mapping
from typing import Any

from app.audit.types import AuditSink
from app.db.repositories.audit_logs import AuditLogRepository
from app.models.base import CompanyScope
from app.models.entities import AuditEvent, AuditLog


class AuditService(AuditSink):
    def __init__(self, repository: AuditLogRepository) -> None:
        self._repository = repository

    async def audit(
        self,
        scope: CompanyScope,
        *,
        actor_uid: str,
        action: str,
        target_type: str,
        target_id: str,
        metadata: Mapping[str, Any] | None = None,
    ) -> AuditLog:
        event = AuditEvent(
            company_id=scope.company_id,
            actor_uid=actor_uid,
            action=action,
            target_type=target_type,
            target_id=target_id,
            metadata=dict(metadata or {}),
        )
        return await self._repository.append(scope, event)
