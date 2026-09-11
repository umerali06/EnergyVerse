from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.documents.service import (
    DocumentService,
    DocumentServiceError,
    get_document_service,
)
from app.models.api import (
    CreateDocumentRequest,
    DocumentDeleted,
    DocumentDetail,
    DocumentListPage,
    UpdateDocumentRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(
    prefix="/api/v1/documents", tags=["documents"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.DOCUMENTS))],
)

_documents_read_access = require_permission("documents.read")
_documents_write_access = require_permission("documents.write")


def _raise_api_error(error: DocumentServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=DocumentListPage,
    operation_id="list_documents",
    responses=error_responses(401, 403, 422, 500),
)
async def list_documents(
    current_user: Annotated[CurrentUser, Depends(_documents_read_access)],
    service: Annotated[DocumentService, Depends(get_document_service)],
    category: Annotated[str | None, Query(max_length=50)] = None,
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    search: Annotated[str | None, Query(max_length=200)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> DocumentListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_documents(
            scope,
            category=category,
            facility_id=facility_id,
            status=status,
            search=search,
            cursor=cursor,
            limit=limit,
        )
    except DocumentServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=DocumentDetail,
    operation_id="create_document",
    responses=error_responses(401, 403, 409, 422, 500),
)
async def create_document(
    request: CreateDocumentRequest,
    current_user: Annotated[CurrentUser, Depends(_documents_write_access)],
    service: Annotated[DocumentService, Depends(get_document_service)],
) -> DocumentDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_document(scope, request, current_user.uid)
    except DocumentServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{document_id}",
    response_model=DocumentDetail,
    operation_id="get_document",
    responses=error_responses(401, 403, 404, 500),
)
async def get_document(
    document_id: str,
    current_user: Annotated[CurrentUser, Depends(_documents_read_access)],
    service: Annotated[DocumentService, Depends(get_document_service)],
) -> DocumentDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_document(scope, document_id)
    except DocumentServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{document_id}",
    response_model=DocumentDetail,
    operation_id="update_document",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_document(
    document_id: str,
    request: UpdateDocumentRequest,
    current_user: Annotated[CurrentUser, Depends(_documents_write_access)],
    service: Annotated[DocumentService, Depends(get_document_service)],
) -> DocumentDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_document(scope, document_id, request, current_user.uid)
    except DocumentServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{document_id}",
    response_model=DocumentDeleted,
    operation_id="delete_document",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_document(
    document_id: str,
    current_user: Annotated[CurrentUser, Depends(_documents_write_access)],
    service: Annotated[DocumentService, Depends(get_document_service)],
) -> DocumentDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_document(scope, document_id, current_user.uid)
        return DocumentDeleted(id=document_id)
    except DocumentServiceError as error:
        _raise_api_error(error)
        raise
