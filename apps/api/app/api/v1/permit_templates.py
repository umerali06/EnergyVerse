from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import (
    CreatePermitTemplateRequest,
    PermitTemplateDeleted,
    PermitTemplateDetail,
    PermitTemplateListPage,
    UpdatePermitTemplateRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.permit_templates.service import (
    PermitTemplateService,
    PermitTemplateServiceError,
    get_permit_template_service,
)
from app.rbac.dependencies import require_permission

router = APIRouter(
    prefix="/api/v1/permit-templates", tags=["permit_templates"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.PERMITS))],
)
_read = require_permission("permits.read")
_write = require_permission("permits.write")


def _raise(error: PermitTemplateServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=PermitTemplateListPage,
    operation_id="list_permit_templates",
    responses=error_responses(401, 403, 422, 500),
)
async def list_permit_templates(
    current_user: Annotated[CurrentUser, Depends(_read)],
    service: Annotated[PermitTemplateService, Depends(get_permit_template_service)],
    permit_type: Annotated[str | None, Query(max_length=60)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> PermitTemplateListPage:
    try:
        return await service.list(
            CompanyScope(company_id=current_user.company_id), permit_type, cursor, limit
        )
    except PermitTemplateServiceError as error:
        _raise(error)
        raise


@router.get(
    "/{template_id}",
    response_model=PermitTemplateDetail,
    operation_id="get_permit_template",
    responses=error_responses(401, 403, 404, 500),
)
async def get_permit_template(
    template_id: str,
    current_user: Annotated[CurrentUser, Depends(_read)],
    service: Annotated[PermitTemplateService, Depends(get_permit_template_service)],
) -> PermitTemplateDetail:
    try:
        return await service.get(CompanyScope(company_id=current_user.company_id), template_id)
    except PermitTemplateServiceError as error:
        _raise(error)
        raise


@router.post(
    "",
    response_model=PermitTemplateDetail,
    status_code=201,
    operation_id="create_permit_template",
    responses=error_responses(401, 403, 422, 500),
)
async def create_permit_template(
    request: CreatePermitTemplateRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitTemplateService, Depends(get_permit_template_service)],
) -> PermitTemplateDetail:
    try:
        return await service.create(
            CompanyScope(company_id=current_user.company_id), request, current_user.uid
        )
    except PermitTemplateServiceError as error:
        _raise(error)
        raise


@router.patch(
    "/{template_id}",
    response_model=PermitTemplateDetail,
    operation_id="update_permit_template",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_permit_template(
    template_id: str,
    request: UpdatePermitTemplateRequest,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitTemplateService, Depends(get_permit_template_service)],
) -> PermitTemplateDetail:
    try:
        return await service.update(
            CompanyScope(company_id=current_user.company_id),
            template_id,
            request,
            current_user.uid,
        )
    except PermitTemplateServiceError as error:
        _raise(error)
        raise


@router.delete(
    "/{template_id}",
    response_model=PermitTemplateDeleted,
    operation_id="delete_permit_template",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_permit_template(
    template_id: str,
    current_user: Annotated[CurrentUser, Depends(_write)],
    service: Annotated[PermitTemplateService, Depends(get_permit_template_service)],
) -> PermitTemplateDeleted:
    try:
        return await service.delete(
            CompanyScope(company_id=current_user.company_id), template_id, current_user.uid
        )
    except PermitTemplateServiceError as error:
        _raise(error)
        raise
