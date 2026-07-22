from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.assets.service import (
    AssetManagementError,
    AssetManagementService,
    get_asset_management_service,
)
from app.core.errors import ApiError
from app.models.api import (
    AssetDeleted,
    AssetDetail,
    AssetHistoryPage,
    AssetListPage,
    CreateAssetRequest,
    UpdateAssetRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/assets", tags=["assets"])

_assets_read_access = require_permission("assets.read")
_assets_write_access = require_permission("assets.write")


def _raise_api_error(error: AssetManagementError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=AssetListPage,
    operation_id="list_assets",
    responses=error_responses(401, 403, 422, 500),
)
async def list_assets(
    current_user: Annotated[CurrentUser, Depends(_assets_read_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    area_id: Annotated[str | None, Query(max_length=200)] = None,
    category: Annotated[str | None, Query(max_length=60)] = None,
    current_status: Annotated[str | None, Query(max_length=20)] = None,
    parent_asset_id: Annotated[str | None, Query(max_length=200)] = None,
    search: Annotated[str | None, Query(max_length=200)] = None,
    sort: Annotated[str, Query(max_length=20)] = "-created_at",
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> AssetListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_assets(
            scope,
            facility_id=facility_id,
            area_id=area_id,
            category=category,
            current_status=current_status,
            parent_asset_id=parent_asset_id,
            search=search,
            sort=sort,
            cursor=cursor,
            limit=limit,
        )
    except AssetManagementError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{asset_id}",
    response_model=AssetDetail,
    operation_id="get_asset",
    responses=error_responses(401, 403, 404, 500),
)
async def get_asset(
    asset_id: str,
    current_user: Annotated[CurrentUser, Depends(_assets_read_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> AssetDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_asset(scope, asset_id)
    except AssetManagementError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{asset_id}/history",
    response_model=AssetHistoryPage,
    operation_id="get_asset_history",
    responses=error_responses(401, 403, 404, 500),
)
async def get_asset_history(
    asset_id: str,
    current_user: Annotated[CurrentUser, Depends(_assets_read_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> AssetHistoryPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_asset_history(scope, asset_id)
    except AssetManagementError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=AssetDetail,
    status_code=201,
    operation_id="create_asset",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def create_asset(
    request: CreateAssetRequest,
    current_user: Annotated[CurrentUser, Depends(_assets_write_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> AssetDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_asset(scope, request, current_user.uid)
    except AssetManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{asset_id}",
    response_model=AssetDetail,
    operation_id="update_asset",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_asset(
    asset_id: str,
    request: UpdateAssetRequest,
    current_user: Annotated[CurrentUser, Depends(_assets_write_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> AssetDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_asset(scope, asset_id, request, current_user.uid)
    except AssetManagementError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{asset_id}",
    response_model=AssetDeleted,
    operation_id="delete_asset",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_asset(
    asset_id: str,
    current_user: Annotated[CurrentUser, Depends(_assets_write_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> AssetDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_asset(scope, asset_id, current_user.uid)
    except AssetManagementError as error:
        _raise_api_error(error)
        raise
    return AssetDeleted(id=asset_id)
