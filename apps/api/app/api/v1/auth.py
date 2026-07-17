from typing import Annotated

from fastapi import APIRouter, Depends, status

from app.auth.dependencies import get_current_user
from app.auth.registration import (
    CompanyRegistrationService,
    RegistrationError,
    get_registration_service,
)
from app.core.errors import ApiError
from app.models.api import error_responses
from app.models.entities import (
    CompanyRegistrationRequest,
    CompanyRegistrationResponse,
    CurrentUser,
)

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])


@router.get(
    "/me",
    response_model=CurrentUser,
    operation_id="get_current_user",
    responses=error_responses(401, 403, 422, 500),
)
async def me(current_user: Annotated[CurrentUser, Depends(get_current_user)]) -> CurrentUser:
    return current_user


@router.post(
    "/register",
    response_model=CompanyRegistrationResponse,
    status_code=status.HTTP_201_CREATED,
    operation_id="register_company_admin",
    responses=error_responses(409, 422, 500),
)
async def register_company_admin(
    request: CompanyRegistrationRequest,
    service: Annotated[CompanyRegistrationService, Depends(get_registration_service)],
) -> CompanyRegistrationResponse:
    try:
        return await service.register(request)
    except RegistrationError as error:
        status_code = 409 if error.code == "email_already_in_use" else 422
        raise ApiError(
            status_code=status_code,
            error=error.code,
            message=error.message,
        ) from error
