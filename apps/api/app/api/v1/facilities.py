from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.core.errors import ApiError
from app.facilities.service import (
    FacilityManagementError,
    FacilityManagementService,
    get_facility_management_service,
)
from app.models.api import (
    CreateFacilityRequest,
    FacilityDeleted,
    FacilityDetail,
    FacilityListPage,
    UpdateFacilityRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/facilities", tags=["facilities"])

_facilities_read_access = require_permission("facilities.read")
_facilities_write_access = require_permission("facilities.write")


def _raise_api_error(error: FacilityManagementError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=FacilityListPage,
    operation_id="list_facilities",
    responses=error_responses(401, 403, 422, 500),
)
async def list_facilities(
    current_user: Annotated[CurrentUser, Depends(_facilities_read_access)],
    service: Annotated[FacilityManagementService, Depends(get_facility_management_service)],
    search: Annotated[str | None, Query(max_length=200)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    sort: Annotated[str, Query(max_length=20)] = "name",
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> FacilityListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_facilities(
            scope, search=search, status=status, sort=sort, cursor=cursor, limit=limit
        )
    except FacilityManagementError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{facility_id}",
    response_model=FacilityDetail,
    operation_id="get_facility",
    responses=error_responses(401, 403, 404, 500),
)
async def get_facility(
    facility_id: str,
    current_user: Annotated[CurrentUser, Depends(_facilities_read_access)],
    service: Annotated[FacilityManagementService, Depends(get_facility_management_service)],
) -> FacilityDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_facility(scope, facility_id)
    except FacilityManagementError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=FacilityDetail,
    status_code=201,
    operation_id="create_facility",
    responses=error_responses(401, 403, 422, 500),
)
async def create_facility(
    request: CreateFacilityRequest,
    current_user: Annotated[CurrentUser, Depends(_facilities_write_access)],
    service: Annotated[FacilityManagementService, Depends(get_facility_management_service)],
) -> FacilityDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_facility(scope, request, current_user.uid)
    except FacilityManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{facility_id}",
    response_model=FacilityDetail,
    operation_id="update_facility",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_facility(
    facility_id: str,
    request: UpdateFacilityRequest,
    current_user: Annotated[CurrentUser, Depends(_facilities_write_access)],
    service: Annotated[FacilityManagementService, Depends(get_facility_management_service)],
) -> FacilityDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_facility(scope, facility_id, request, current_user.uid)
    except FacilityManagementError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{facility_id}",
    response_model=FacilityDeleted,
    operation_id="delete_facility",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def delete_facility(
    facility_id: str,
    current_user: Annotated[CurrentUser, Depends(_facilities_write_access)],
    service: Annotated[FacilityManagementService, Depends(get_facility_management_service)],
) -> FacilityDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_facility(scope, facility_id, current_user.uid)
    except FacilityManagementError as error:
        _raise_api_error(error)
        raise
    return FacilityDeleted(id=facility_id)
