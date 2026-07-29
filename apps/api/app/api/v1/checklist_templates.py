from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.checklists.service import (
    ChecklistTemplateService,
    ChecklistTemplateServiceError,
    get_checklist_template_service,
)
from app.core.errors import ApiError
from app.models.api import (
    ChecklistTemplateDeleted,
    ChecklistTemplateDetail,
    ChecklistTemplateListPage,
    CreateChecklistTemplateRequest,
    UpdateChecklistTemplateRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/checklist-templates", tags=["checklist-templates"])

_templates_read_access = require_permission("checklist_templates.read")
_templates_write_access = require_permission("checklist_templates.write")


def _raise_api_error(error: ChecklistTemplateServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=ChecklistTemplateListPage,
    operation_id="list_checklist_templates",
    responses=error_responses(401, 403, 422, 500),
)
async def list_checklist_templates(
    current_user: Annotated[CurrentUser, Depends(_templates_read_access)],
    service: Annotated[ChecklistTemplateService, Depends(get_checklist_template_service)],
    category: Annotated[str | None, Query(max_length=60)] = None,
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> ChecklistTemplateListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_templates(scope, category=category, cursor=cursor, limit=limit)
    except ChecklistTemplateServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{template_id}",
    response_model=ChecklistTemplateDetail,
    operation_id="get_checklist_template",
    responses=error_responses(401, 403, 404, 500),
)
async def get_checklist_template(
    template_id: str,
    current_user: Annotated[CurrentUser, Depends(_templates_read_access)],
    service: Annotated[ChecklistTemplateService, Depends(get_checklist_template_service)],
) -> ChecklistTemplateDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_template(scope, template_id)
    except ChecklistTemplateServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=ChecklistTemplateDetail,
    status_code=201,
    operation_id="create_checklist_template",
    responses=error_responses(401, 403, 422, 500),
)
async def create_checklist_template(
    request: CreateChecklistTemplateRequest,
    current_user: Annotated[CurrentUser, Depends(_templates_write_access)],
    service: Annotated[ChecklistTemplateService, Depends(get_checklist_template_service)],
) -> ChecklistTemplateDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_template(scope, request, current_user.uid)
    except ChecklistTemplateServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{template_id}",
    response_model=ChecklistTemplateDetail,
    operation_id="update_checklist_template",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_checklist_template(
    template_id: str,
    request: UpdateChecklistTemplateRequest,
    current_user: Annotated[CurrentUser, Depends(_templates_write_access)],
    service: Annotated[ChecklistTemplateService, Depends(get_checklist_template_service)],
) -> ChecklistTemplateDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_template(scope, template_id, request, current_user.uid)
    except ChecklistTemplateServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{template_id}",
    response_model=ChecklistTemplateDeleted,
    operation_id="delete_checklist_template",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_checklist_template(
    template_id: str,
    current_user: Annotated[CurrentUser, Depends(_templates_write_access)],
    service: Annotated[ChecklistTemplateService, Depends(get_checklist_template_service)],
) -> ChecklistTemplateDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_template(scope, template_id, current_user.uid)
    except ChecklistTemplateServiceError as error:
        _raise_api_error(error)
        raise
    return ChecklistTemplateDeleted(id=template_id)
