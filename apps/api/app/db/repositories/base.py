from collections.abc import Mapping
from typing import Any, Generic, TypeVar

from google.cloud.firestore_v1 import FieldFilter
from google.cloud.firestore_v1.async_client import AsyncClient
from pydantic import BaseModel

from app.audit.types import AuditSink
from app.db.firestore import get_firestore_client
from app.models.base import CompanyScope, tenant_creation_fields, utc_now

ModelT = TypeVar("ModelT", bound=BaseModel)

FIRESTORE_OPERATION_TIMEOUT_SECONDS = 30.0


class TenantRepository(Generic[ModelT]):
    collection_name: str
    target_type: str
    model_type: type[ModelT]

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        self._client = client or get_firestore_client()
        self._audit = audit

    @property
    def _collection(self) -> Any:
        return self._client.collection(self.collection_name)

    async def get(self, scope: CompanyScope, document_id: str) -> ModelT | None:
        snapshot = await self._collection.document(document_id).get(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        if not snapshot.exists:
            return None
        data = snapshot.to_dict()
        if data is None or data.get("company_id") != scope.company_id:
            return None
        return self.model_type.model_validate(data)

    async def list(self, scope: CompanyScope) -> list[ModelT]:
        query = self._collection.where(
            filter=FieldFilter("company_id", "==", scope.company_id)
        )
        documents = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                documents.append(self.model_type.model_validate(data))
        return documents

    async def _create(
        self,
        scope: CompanyScope,
        document_id: str,
        values: Mapping[str, Any],
        actor_uid: str,
    ) -> ModelT:
        reference = self._collection.document(document_id)
        existing = await reference.get(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        if existing.exists:
            existing_data = existing.to_dict() or {}
            if existing_data.get("company_id") != scope.company_id:
                raise PermissionError("Document ID belongs to another company")
            raise ValueError(f"{self.target_type} already exists")

        data = {
            **values,
            "id": document_id,
            **tenant_creation_fields(scope, actor_uid),
        }
        model = self.model_type.model_validate(data)
        await reference.set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"{self.target_type}.created",
            target_id=document_id,
            metadata={"after": model.model_dump(mode="json")},
        )
        return model

    async def _update(
        self,
        scope: CompanyScope,
        document_id: str,
        values: Mapping[str, Any],
        actor_uid: str,
    ) -> ModelT:
        current = await self.get(scope, document_id)
        if current is None:
            raise LookupError(f"{self.target_type} not found in company scope")

        protected = {"id", "company_id", "created_at", "created_by", "updated_at"}
        changes = {key: value for key, value in values.items() if key not in protected}
        data = {
            **current.model_dump(),
            **changes,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(document_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"{self.target_type}.updated",
            target_id=document_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def delete(
        self,
        scope: CompanyScope,
        document_id: str,
        actor_uid: str,
    ) -> None:
        current = await self.get(scope, document_id)
        if current is None:
            raise LookupError(f"{self.target_type} not found in company scope")
        await self._collection.document(document_id).delete(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"{self.target_type}.deleted",
            target_id=document_id,
            metadata={"before": current.model_dump(mode="json")},
        )

    async def _write_audit(
        self,
        scope: CompanyScope,
        *,
        actor_uid: str,
        action: str,
        target_id: str,
        metadata: Mapping[str, Any],
    ) -> None:
        if self._audit is not None:
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action=action,
                target_type=self.target_type,
                target_id=target_id,
                metadata=metadata,
            )
