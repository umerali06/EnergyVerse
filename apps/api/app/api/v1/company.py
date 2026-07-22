from typing import Annotated

from fastapi import APIRouter, Depends, File, UploadFile

from app.company.service import (
    CompanyProfileError,
    CompanyProfileService,
    get_company_profile_service,
)
from app.core.errors import ApiError
from app.models.api import CompanyProfile, UpdateCompanyRequest, error_responses
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/company", tags=["company"])

_company_settings_access = require_permission("company.settings")


def _raise_api_error(error: CompanyProfileError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=CompanyProfile,
    operation_id="get_company",
    responses=error_responses(401, 403, 404, 500),
)
async def get_company(
    current_user: Annotated[CurrentUser, Depends(_company_settings_access)],
    service: Annotated[CompanyProfileService, Depends(get_company_profile_service)],
) -> CompanyProfile:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_profile(scope)
    except CompanyProfileError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "",
    response_model=CompanyProfile,
    operation_id="update_company",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def update_company(
    request: UpdateCompanyRequest,
    current_user: Annotated[CurrentUser, Depends(_company_settings_access)],
    service: Annotated[CompanyProfileService, Depends(get_company_profile_service)],
) -> CompanyProfile:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_profile(scope, request, current_user.uid)
    except CompanyProfileError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/logo",
    response_model=CompanyProfile,
    operation_id="upload_company_logo",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def upload_company_logo(
    current_user: Annotated[CurrentUser, Depends(_company_settings_access)],
    service: Annotated[CompanyProfileService, Depends(get_company_profile_service)],
    file: Annotated[UploadFile, File()],
) -> CompanyProfile:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.upload_logo(scope, file, current_user.uid)
    except CompanyProfileError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/logo",
    response_model=CompanyProfile,
    operation_id="remove_company_logo",
    responses=error_responses(401, 403, 404, 500),
)
async def remove_company_logo(
    current_user: Annotated[CurrentUser, Depends(_company_settings_access)],
    service: Annotated[CompanyProfileService, Depends(get_company_profile_service)],
) -> CompanyProfile:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.remove_logo(scope, current_user.uid)
    except CompanyProfileError as error:
        _raise_api_error(error)
        raise
