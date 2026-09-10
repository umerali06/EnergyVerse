from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import (
    AcknowledgePermitRequest,
    ActivatePermitRequest,
    ClosePermitRequest,
    ControlPermitRequest,
    CreatePermitRequest,
    DecidePermitApprovalRequest,
    PermitDeleted,
    PermitDetail,
    PermitListPage,
    ResumePermitRequest,
    SubmitPermitRequest,
    UpdatePermitRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.permits.service import PermitService, PermitServiceError, get_permit_service
from app.rbac.dependencies import require_permission

router = APIRouter(
    prefix="/api/v1/permits", tags=["permits"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.PERMITS))],
)
_read = require_permission("permits.read")
_write = require_permission("permits.write")
_approve = require_permission("permits.approve")


def _raise(error: PermitServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=PermitListPage,
    operation_id="list_permits",
    responses=error_responses(401, 403, 422, 500),
)
async def list_permits(
    current_user: Annotated[CurrentUser, Depends(_read)],
    service: Annotated[PermitService, Depends(get_permit_service)],
    permit_type: Annotated[str | None, Query(max_length=60)] = None,
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    worker_id: Annotated[str | None, Query(max_length=200)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> PermitListPage:
    try:
        return await service.list(
            CompanyScope(company_id=current_user.company_id),
            permit_type,
            facility_id,
            worker_id,
            cursor,
            limit,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.get(
    "/{permit_id}",
    response_model=PermitDetail,
    operation_id="get_permit",
    responses=error_responses(401, 403, 404, 500),
)
async def get_permit(
    permit_id: str,
    current_user: Annotated[CurrentUser, Depends(_read)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.get(CompanyScope(company_id=current_user.company_id), permit_id)
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "",
    response_model=PermitDetail,
    status_code=201,
    operation_id="create_permit",
    responses=error_responses(401, 403, 422, 500),
)
async def create_permit(
    request: CreatePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.create(
            CompanyScope(company_id=current_user.company_id), request, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.patch(
    "/{permit_id}",
    response_model=PermitDetail,
    operation_id="update_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_permit(
    permit_id: str,
    request: UpdatePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.update(
            CompanyScope(company_id=current_user.company_id),
            permit_id,
            request,
            current_user.uid,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.delete(
    "/{permit_id}",
    response_model=PermitDeleted,
    operation_id="delete_permit",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_permit(
    permit_id: str,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDeleted:
    try:
        return await service.delete(
            CompanyScope(company_id=current_user.company_id), permit_id, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/submit",
    response_model=PermitDetail,
    operation_id="submit_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def submit_permit(
    permit_id: str,
    request: SubmitPermitRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.submit(
            CompanyScope(company_id=current_user.company_id),
            permit_id,
            request,
            current_user.uid,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/approval-decision",
    response_model=PermitDetail,
    operation_id="decide_permit_approval",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def decide_permit_approval(
    permit_id: str,
    request: DecidePermitApprovalRequest,
    current_user: Annotated[CurrentUser, Depends(_approve)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.decide_approval(
            CompanyScope(company_id=current_user.company_id),
            permit_id,
            request,
            current_user.uid,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/acknowledge",
    response_model=PermitDetail,
    operation_id="acknowledge_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def acknowledge_permit(
    permit_id: str,
    request: AcknowledgePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_read)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.acknowledge(
            CompanyScope(company_id=current_user.company_id),
            permit_id,
            request,
            current_user.uid,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/activate",
    response_model=PermitDetail,
    operation_id="activate_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def activate_permit(
    permit_id: str,
    request: ActivatePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.activate(
            CompanyScope(company_id=current_user.company_id),
            permit_id,
            request,
            current_user.uid,
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/suspend",
    response_model=PermitDetail,
    operation_id="suspend_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def suspend_permit(
    permit_id: str,
    request: ControlPermitRequest,
    current_user: Annotated[CurrentUser, Depends(_approve)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.suspend(
            CompanyScope(company_id=current_user.company_id), permit_id, request, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/resume",
    response_model=PermitDetail,
    operation_id="resume_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def resume_permit(
    permit_id: str,
    request: ResumePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_approve)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.resume(
            CompanyScope(company_id=current_user.company_id), permit_id, request, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/revoke",
    response_model=PermitDetail,
    operation_id="revoke_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def revoke_permit(
    permit_id: str,
    request: ControlPermitRequest,
    current_user: Annotated[CurrentUser, Depends(_approve)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.revoke(
            CompanyScope(company_id=current_user.company_id), permit_id, request, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{permit_id}/close",
    response_model=PermitDetail,
    operation_id="close_permit",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def close_permit(
    permit_id: str,
    request: ClosePermitRequest,
    current_user: Annotated[CurrentUser, Depends(_approve)],
    service: Annotated[PermitService, Depends(get_permit_service)],
) -> PermitDetail:
    try:
        return await service.close(
            CompanyScope(company_id=current_user.company_id), permit_id, request, current_user.uid
        )
    except PermitServiceError as error:
        _raise(error)
        raise
