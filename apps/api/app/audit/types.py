from collections.abc import Mapping
from typing import Any, Protocol

from app.models.base import CompanyScope
from app.models.entities import AuditLog


class AuditSink(Protocol):
    async def audit(
        self,
        scope: CompanyScope,
        *,
        actor_uid: str,
        action: str,
        target_type: str,
        target_id: str,
        metadata: Mapping[str, Any] | None = None,
    ) -> AuditLog: ...
