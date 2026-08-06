from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.core.errors import ApiError
from app.inspections.service import (
    InspectionService,
    InspectionServiceError,
    get_inspection_service,
)
from app.models.api import (
    AssignChecklistTemplateRequest,
    AttachInspectionMediaRequest,
    CreateAnnotationRequest,
    CreateInspectionRequest,
    InspectionDeleted,
    InspectionDetail,
    InspectionListPage,
    UpdateAnnotationRequest,
    UpdateInspectionMediaRequest,
    UpdateInspectionRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/inspections", tags=["inspections"])

_inspections_read_access = require_permission("inspections.read")
_inspections_write_access = require_permission("inspections.write")


def _raise_api_error(error: InspectionServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=InspectionListPage,
    operation_id="list_inspections",
    responses=error_responses(401, 403, 422, 500),
)
async def list_inspections(
    current_user: Annotated[CurrentUser, Depends(_inspections_read_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
    asset_id: Annotated[str | None, Query(max_length=200)] = None,
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    inspector_id: Annotated[str | None, Query(max_length=200)] = None,
    from_date: Annotated[datetime | None, Query()] = None,
    to_date: Annotated[datetime | None, Query()] = None,
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> InspectionListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_inspections(
            scope,
            asset_id=asset_id,
            facility_id=facility_id,
            status=status,
            inspector_id=inspector_id,
            from_date=from_date,
            to_date=to_date,
            cursor=cursor,
            limit=limit,
        )
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{inspection_id}",
    response_model=InspectionDetail,
    operation_id="get_inspection",
    responses=error_responses(401, 403, 404, 500),
)
async def get_inspection(
    inspection_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_read_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_inspection(scope, inspection_id)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=InspectionDetail,
    status_code=200,
    operation_id="create_inspection",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def create_inspection(
    request: CreateInspectionRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    """Idempotent upsert keyed by the client-generated `id` (sync contract,
    D-0xx): a byte-identical resubmit returns the same resource -- hence a
    fixed 200, never 201, since this route can't statically know whether a
    given call created or replayed a record."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        detail, _created = await service.create_draft(scope, request, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise
    return detail


@router.patch(
    "/{inspection_id}",
    response_model=InspectionDetail,
    operation_id="update_inspection",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_inspection(
    inspection_id: str,
    request: UpdateInspectionRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_inspection(scope, inspection_id, request, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{inspection_id}",
    response_model=InspectionDeleted,
    operation_id="delete_inspection",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_inspection(
    inspection_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_inspection(scope, inspection_id, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise
    return InspectionDeleted(id=inspection_id)


@router.post(
    "/{inspection_id}/checklist-template",
    response_model=InspectionDetail,
    operation_id="assign_inspection_checklist_template",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def assign_checklist_template(
    inspection_id: str,
    request: AssignChecklistTemplateRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.assign_checklist_template(
            scope, inspection_id, request, current_user.uid
        )
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{inspection_id}/start",
    response_model=InspectionDetail,
    operation_id="start_inspection",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def start_inspection(
    inspection_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.start_inspection(scope, inspection_id, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{inspection_id}/complete",
    response_model=InspectionDetail,
    operation_id="complete_inspection",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def complete_inspection(
    inspection_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.complete_inspection(scope, inspection_id, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{inspection_id}/cancel",
    response_model=InspectionDetail,
    operation_id="cancel_inspection",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def cancel_inspection(
    inspection_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.cancel_inspection(scope, inspection_id, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{inspection_id}/media",
    response_model=InspectionDetail,
    operation_id="attach_inspection_media",
    responses=error_responses(401, 403, 404, 409, 413, 422, 500),
)
async def attach_inspection_media(
    inspection_id: str,
    request: AttachInspectionMediaRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    """Registers a reference to media the mobile client already uploaded
    directly to Firebase Storage (Phase 7.4) -- no bytes pass through here."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.attach_media(scope, inspection_id, request, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{inspection_id}/media/{media_id}",
    response_model=InspectionDetail,
    operation_id="update_inspection_media",
    responses=error_responses(401, 403, 404, 500),
)
async def update_inspection_media(
    inspection_id: str,
    media_id: str,
    request: UpdateInspectionMediaRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_media(scope, inspection_id, media_id, request, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{inspection_id}/media/{media_id}",
    response_model=InspectionDetail,
    operation_id="detach_inspection_media",
    responses=error_responses(401, 403, 404, 500),
)
async def detach_inspection_media(
    inspection_id: str,
    media_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    """Idempotent on an already-detached `media_id` -- the mobile outbox
    replays this call at-least-once."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.detach_media(scope, inspection_id, media_id, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{inspection_id}/annotations",
    response_model=InspectionDetail,
    operation_id="create_inspection_annotation",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def create_inspection_annotation(
    inspection_id: str,
    request: CreateAnnotationRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    """Idempotent upsert keyed by the client-generated `id` (mirrors
    `create_inspection`) -- annotations are vector metadata only, no image
    bytes pass through here."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_annotation(scope, inspection_id, request, current_user.uid)
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{inspection_id}/annotations/{annotation_id}",
    response_model=InspectionDetail,
    operation_id="update_inspection_annotation",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_inspection_annotation(
    inspection_id: str,
    annotation_id: str,
    request: UpdateAnnotationRequest,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_annotation(
            scope, inspection_id, annotation_id, request, current_user.uid
        )
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{inspection_id}/annotations/{annotation_id}",
    response_model=InspectionDetail,
    operation_id="delete_inspection_annotation",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_inspection_annotation(
    inspection_id: str,
    annotation_id: str,
    current_user: Annotated[CurrentUser, Depends(_inspections_write_access)],
    service: Annotated[InspectionService, Depends(get_inspection_service)],
) -> InspectionDetail:
    """Idempotent on an already-deleted `annotation_id` -- the mobile outbox
    replays this call at-least-once."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.delete_annotation(
            scope, inspection_id, annotation_id, current_user.uid
        )
    except InspectionServiceError as error:
        _raise_api_error(error)
        raise
