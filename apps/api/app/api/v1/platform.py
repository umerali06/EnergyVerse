from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.admin.dependencies import get_admin_scope
from app.admin.service import (
    AdminCompanyService,
    AdminServiceError,
    get_admin_company_service,
)
from app.core.errors import ApiError
from app.models.api import (
    PlatformCompanyDetail,
    PlatformCompanyPage,
    PlatformStats,
    UpdateCompanyStatusRequest,
    UpdatePlatformCompanyRequest,
    error_responses,
)
from app.models.base import AdminScope

router = APIRouter(prefix="/api/v1/platform", tags=["platform"])


def _raise_api_error(error: AdminServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "/companies",
    response_model=PlatformCompanyPage,
    operation_id="list_platform_companies",
    responses=error_responses(401, 403, 422, 500),
)
async def list_platform_companies(
    _admin_scope: Annotated[AdminScope, Depends(get_admin_scope)],
    service: Annotated[AdminCompanyService, Depends(get_admin_company_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 20,
) -> PlatformCompanyPage:
    try:
        return await service.list_companies(cursor=cursor, limit=limit)
    except AdminServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/companies/{company_id}",
    response_model=PlatformCompanyDetail,
    operation_id="get_platform_company",
    responses=error_responses(401, 403, 404, 500),
)
async def get_platform_company(
    company_id: str,
    _admin_scope: Annotated[AdminScope, Depends(get_admin_scope)],
    service: Annotated[AdminCompanyService, Depends(get_admin_company_service)],
) -> PlatformCompanyDetail:
    try:
        return await service.get_company(company_id)
    except AdminServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/companies/{company_id}/status",
    response_model=PlatformCompanyDetail,
    operation_id="update_platform_company_status",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_platform_company_status(
    company_id: str,
    request: UpdateCompanyStatusRequest,
    admin_scope: Annotated[AdminScope, Depends(get_admin_scope)],
    service: Annotated[AdminCompanyService, Depends(get_admin_company_service)],
) -> PlatformCompanyDetail:
    try:
        return await service.update_status(admin_scope, company_id, request.status)
    except AdminServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/companies/{company_id}",
    response_model=PlatformCompanyDetail,
    operation_id="update_platform_company",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_platform_company(
    company_id: str,
    request: UpdatePlatformCompanyRequest,
    admin_scope: Annotated[AdminScope, Depends(get_admin_scope)],
    service: Annotated[AdminCompanyService, Depends(get_admin_company_service)],
) -> PlatformCompanyDetail:
    try:
        return await service.update_subscription_tier(
            admin_scope, company_id, request.subscription_tier
        )
    except AdminServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/stats",
    response_model=PlatformStats,
    operation_id="get_platform_stats",
    responses=error_responses(401, 403, 500),
)
async def get_platform_stats(
    _admin_scope: Annotated[AdminScope, Depends(get_admin_scope)],
    service: Annotated[AdminCompanyService, Depends(get_admin_company_service)],
) -> PlatformStats:
    return await service.get_stats()
