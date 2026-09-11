import base64
import binascii

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.documents import DocumentRepository
from app.models.api import (
    CreateDocumentRequest,
    DocumentDetail,
    DocumentListItem,
    DocumentListPage,
    UpdateDocumentRequest,
)
from app.models.base import CompanyScope
from app.models.entities import Document, DocumentCreate


class DocumentServiceError(Exception):
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


def _encode_cursor(doc_id: str) -> str:
    return base64.urlsafe_b64encode(doc_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise DocumentServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(doc: Document) -> DocumentListItem:
    return DocumentListItem(
        id=doc.id,
        title=doc.title,
        document_code=doc.document_code,
        category=doc.category,
        description=doc.description,
        facility_id=doc.facility_id,
        asset_id=doc.asset_id,
        file_path=doc.file_path,
        filename=doc.filename,
        file_format=doc.file_format,
        file_size_bytes=doc.file_size_bytes,
        version=doc.version,
        status=doc.status,
        tags=doc.tags,
        download_url=doc.download_url or f"https://storage.googleapis.com/fev-documents/{doc.file_path}",
        created_by=doc.created_by,
        created_at=doc.created_at,
        updated_at=doc.updated_at,
    )


def _to_detail(doc: Document) -> DocumentDetail:
    return DocumentDetail(**_to_list_item(doc).model_dump())


class DocumentService:
    def __init__(self, documents: DocumentRepository) -> None:
        self._documents = documents

    async def list_documents(
        self,
        scope: CompanyScope,
        *,
        category: str | None = None,
        facility_id: str | None = None,
        status: str | None = None,
        search: str | None = None,
        cursor: str | None = None,
        limit: int = 25,
    ) -> DocumentListPage:
        docs = await self._documents.query(
            scope,
            category=category,
            facility_id=None if category else facility_id,
            status=None if (category or facility_id) else status,
        )
        docs = [d for d in docs if d.deleted_at is None]

        if category and facility_id:
            docs = [d for d in docs if d.facility_id == facility_id]
        if (category or facility_id) and status:
            docs = [d for d in docs if d.status == status]
        if search:
            q = search.lower().strip()
            docs = [
                d
                for d in docs
                if q in d.title.lower()
                or q in d.document_code.lower()
                or (d.description and q in d.description.lower())
                or any(q in t.lower() for t in d.tags)
            ]

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [d.id for d in docs]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(docs)
            docs = docs[start:]

        page = docs[:limit]
        items = [_to_list_item(d) for d in page]
        next_cursor = _encode_cursor(page[-1].id) if len(docs) > limit and page else None
        return DocumentListPage(items=items, next_cursor=next_cursor)

    async def create_document(
        self,
        scope: CompanyScope,
        request: CreateDocumentRequest,
        actor_uid: str,
    ) -> DocumentDetail:
        payload = DocumentCreate(**request.model_dump())
        try:
            doc = await self._documents.create(scope, payload, actor_uid)
        except ValueError as error:
            raise DocumentServiceError(
                409, "document_id_conflict", "A document with this ID already exists"
            ) from error
        return _to_detail(doc)

    async def get_document(
        self,
        scope: CompanyScope,
        document_id: str,
    ) -> DocumentDetail:
        doc = await self._documents.get(scope, document_id)
        if doc is None or doc.deleted_at is not None:
            raise DocumentServiceError(404, "document_not_found", "Document was not found")
        return _to_detail(doc)

    async def update_document(
        self,
        scope: CompanyScope,
        document_id: str,
        request: UpdateDocumentRequest,
        actor_uid: str,
    ) -> DocumentDetail:
        updates = {k: v for k, v in request.model_dump().items() if v is not None}
        try:
            doc = await self._documents.update_metadata(scope, document_id, updates, actor_uid)
        except LookupError as error:
            raise DocumentServiceError(
                404, "document_not_found", "Document was not found"
            ) from error
        return _to_detail(doc)

    async def delete_document(
        self,
        scope: CompanyScope,
        document_id: str,
        actor_uid: str,
    ) -> None:
        try:
            await self._documents.soft_delete(scope, document_id, actor_uid)
        except LookupError as error:
            raise DocumentServiceError(
                404, "document_not_found", "Document was not found"
            ) from error


def get_document_service() -> DocumentService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return DocumentService(DocumentRepository(client, audit))
