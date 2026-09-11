from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import Document, DocumentCreate

DOCUMENT_QUERY_CAP = 5000


class DocumentRepository(TenantRepository[Document]):
    collection_name = "documents"
    target_type = "document"
    model_type = Document

    async def create(
        self, scope: CompanyScope, payload: DocumentCreate, actor_uid: str
    ) -> Document:
        now = utc_now()
        data = {
            **payload.model_dump(),
            "created_by": actor_uid,
            "version": 1,
            "deleted_at": None,
            "created_at": now,
            "updated_at": now,
        }
        return await self._create(scope, payload.id, data, actor_uid)

    async def query(
        self,
        scope: CompanyScope,
        *,
        category: str | None = None,
        facility_id: str | None = None,
        status: str | None = None,
    ) -> list[Document]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if category is not None:
            query = query.where(filter=FieldFilter("category", "==", category))
        elif facility_id is not None:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        elif status is not None:
            query = query.where(filter=FieldFilter("status", "==", status))
        query = query.order_by("created_at", direction="DESCENDING")

        results = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                results.append(self.model_type.model_validate(data))
            if len(results) >= DOCUMENT_QUERY_CAP:
                break
        return results

    async def update_metadata(
        self,
        scope: CompanyScope,
        document_id: str,
        updates: dict[str, object],
        actor_uid: str,
    ) -> Document:
        current = await self.get(scope, document_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("Document not found in company scope")
        now = utc_now()
        data = {
            **current.model_dump(),
            **updates,
            "version": current.version + 1,
            "updated_at": now,
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
            action="document.updated",
            target_id=document_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def soft_delete(
        self, scope: CompanyScope, document_id: str, actor_uid: str
    ) -> Document:
        current = await self.get(scope, document_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("Document not found in company scope")
        now = utc_now()
        data = {
            **current.model_dump(),
            "deleted_at": now,
            "updated_at": now,
            "version": current.version + 1,
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
            action="document.deleted",
            target_id=document_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model
