from typing import Annotated

from fastapi import APIRouter, Depends, status

from app.auth.dependencies import get_current_user
from app.auth.registration import (
    CompanyRegistrationService,
    RegistrationError,
    get_registration_service,
)
from app.auth.verification import VerificationEmailService, get_verification_email_service
from app.core.errors import ApiError
from app.email.sender import EmailDeliveryError, EmailNotConfiguredError
from app.models.api import error_responses
from app.models.entities import (
    CompanyRegistrationRequest,
    CompanyRegistrationResponse,
    CurrentUser,
    VerificationEmailResponse,
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
    "/verification-email",
    response_model=VerificationEmailResponse,
    operation_id="send_verification_email",
    responses=error_responses(401, 403, 422, 500, 502, 503),
)
async def request_verification_email(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[VerificationEmailService, Depends(get_verification_email_service)],
) -> VerificationEmailResponse:
    """Send this user a branded verification email through SES.

    Returns `sent=false` when the address is already verified -- that is a
    no-op, not a failure. A missing SES configuration is reported as a 503
    rather than a 500: the caller asked for something the deployment cannot
    currently do, and the distinction is actionable.

    A configured-but-refused SES is a 502, kept separate from both. Credentials
    can be *present* and still rejected -- a rotated key, an unverified sender,
    the wrong region, sandbox restrictions -- and `ses_configured` cannot see
    any of that, so this used to escape as an unhandled 500 saying "the server
    is broken" about a working server whose mail provider had refused it. It
    matters more since D-103, because registration now sends through this route
    rather than the provider's own unbranded sender; the admin client falls
    back to that sender on any failure here, and a truthful status is what lets
    it tell "cannot send" apart from a genuine fault.
    """
    try:
        sent = await service.send(current_user)
    except EmailNotConfiguredError as error:
        raise ApiError(
            status_code=503,
            error="email_not_configured",
            message="Transactional email is not configured on this deployment",
        ) from error
    except EmailDeliveryError as error:
        raise ApiError(
            status_code=502,
            error="email_delivery_failed",
            message="The email provider refused the verification message",
            details={"provider_code": error.code},
        ) from error
    return VerificationEmailResponse(sent=sent)


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
