from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.areas.service import (
    AreaManagementError,
    AreaManagementService,
    get_area_management_service,
)
from app.core.errors import ApiError
from app.models.api import (
    AreaDeleted,
    AreaDetail,
    AreaListPage,
    CreateAreaRequest,
    UpdateAreaRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/areas", tags=["areas"])

_areas_read_access = require_permission("areas.read")
_areas_write_access = require_permission("areas.write")


def _raise_api_error(error: AreaManagementError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=AreaListPage,
    operation_id="list_areas",
    responses=error_responses(401, 403, 422, 500),
)
async def list_areas(
    current_user: Annotated[CurrentUser, Depends(_areas_read_access)],
    service: Annotated[AreaManagementService, Depends(get_area_management_service)],
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    search: Annotated[str | None, Query(max_length=200)] = None,
    sort: Annotated[str, Query(max_length=20)] = "name",
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> AreaListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_areas(
            scope,
            facility_id=facility_id,
            search=search,
            sort=sort,
            cursor=cursor,
            limit=limit,
        )
    except AreaManagementError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{area_id}",
    response_model=AreaDetail,
    operation_id="get_area",
    responses=error_responses(401, 403, 404, 500),
)
async def get_area(
    area_id: str,
    current_user: Annotated[CurrentUser, Depends(_areas_read_access)],
    service: Annotated[AreaManagementService, Depends(get_area_management_service)],
) -> AreaDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_area(scope, area_id)
    except AreaManagementError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=AreaDetail,
    status_code=201,
    operation_id="create_area",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def create_area(
    request: CreateAreaRequest,
    current_user: Annotated[CurrentUser, Depends(_areas_write_access)],
    service: Annotated[AreaManagementService, Depends(get_area_management_service)],
) -> AreaDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_area(scope, request, current_user.uid)
    except AreaManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{area_id}",
    response_model=AreaDetail,
    operation_id="update_area",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_area(
    area_id: str,
    request: UpdateAreaRequest,
    current_user: Annotated[CurrentUser, Depends(_areas_write_access)],
    service: Annotated[AreaManagementService, Depends(get_area_management_service)],
) -> AreaDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_area(scope, area_id, request, current_user.uid)
    except AreaManagementError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{area_id}",
    response_model=AreaDeleted,
    operation_id="delete_area",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def delete_area(
    area_id: str,
    current_user: Annotated[CurrentUser, Depends(_areas_write_access)],
    service: Annotated[AreaManagementService, Depends(get_area_management_service)],
) -> AreaDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_area(scope, area_id, current_user.uid)
    except AreaManagementError as error:
        _raise_api_error(error)
        raise
    return AreaDeleted(id=area_id)
