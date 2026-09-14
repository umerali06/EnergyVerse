"""The legal package's two server-side surfaces (D-105).

`POST /contact` is deliberately unauthenticated: a prospective customer, a
security researcher, or someone exercising a privacy right has no account, and
the published contact page must work for them. It is protected by strict input
bounds, an allow-list of categories, and by storing nothing -- the submission is
forwarded to the support inbox and not retained here.

`GET /legal/acceptance` reports what the signed-in user accepted and whether the
published version has moved on since, which is what lets the client re-ask after
a material change instead of assuming an old acceptance still covers it.
"""

from __future__ import annotations

import hashlib
import logging
from typing import Annotated

from fastapi import APIRouter, Depends, Request

from app.auth.dependencies import get_current_user
from app.contact.service import ContactService
from app.core.errors import ApiError
from app.core.settings import settings
from app.db.firestore import get_firestore_client
from app.db.repositories.users import UserRepository
from app.email.sender import (
    EmailDeliveryError,
    EmailNotConfiguredError,
    get_email_sender,
)
from app.legal.versions import CURRENT_LEGAL_VERSION
from app.models.api import (
    CONTACT_CATEGORIES,
    ContactRequest,
    ContactResponse,
    LegalAcceptanceResponse,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1", tags=["legal"])


def get_contact_service() -> ContactService:
    return ContactService(
        sender=get_email_sender(),
        destination=settings.contact_destination_email,
    )


def hash_client_ip(request: Request) -> str | None:
    """SHA-256 of the caller's address, or None when it cannot be determined.

    The package permits an `ipHash` "where legally appropriate"; the raw address
    is deliberately never stored. A hash is enough to show two acceptances came
    from the same origin without retaining the origin itself.
    """
    host = request.client.host if request.client else None
    if not host:
        return None
    return hashlib.sha256(host.encode("utf-8")).hexdigest()


@router.post(
    "/contact",
    response_model=ContactResponse,
    responses=error_responses(422, 502, 503),
    operation_id="submit_contact_message",
    summary="Send a message to Flacron Energy support",
)
async def submit_contact(
    payload: ContactRequest,
    service: Annotated[ContactService, Depends(get_contact_service)],
) -> ContactResponse:
    if payload.category not in CONTACT_CATEGORIES:
        raise ApiError(
            status_code=422,
            error="unknown_category",
            message="That contact category is not offered",
        )
    try:
        await service.submit(
            name=payload.name.strip(),
            email=payload.email.strip(),
            company=(payload.company or "").strip() or None,
            category=payload.category,
            subject=payload.subject.strip(),
            message=payload.message.strip(),
            # Nothing is taken from the browser here: an unauthenticated sender
            # has no verified context to attach, and anything they claimed
            # would be worse than nothing in a support inbox.
            context_lines=[],
        )
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
            message="The email provider refused the message",
            details={"provider_code": error.code},
        ) from error
    return ContactResponse(received=True)


@router.get(
    "/legal/acceptance",
    response_model=LegalAcceptanceResponse,
    responses=error_responses(401, 403, 404),
    operation_id="get_legal_acceptance",
    summary="What this user accepted, and whether it is still current",
)
async def get_legal_acceptance(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
) -> LegalAcceptanceResponse:
    users = UserRepository(get_firestore_client())
    user = await users.get(CompanyScope(company_id=current_user.company_id), current_user.uid)
    accepted = user.legal_acceptance if user is not None else None

    if accepted is None:
        return LegalAcceptanceResponse(
            accepted_version=None,
            current_version=CURRENT_LEGAL_VERSION,
            terms_accepted=False,
            privacy_accepted=False,
            safety_disclaimer_accepted=False,
            accepted_at=None,
            acceptance_source=None,
            requires_acceptance=True,
        )

    complete = (
        accepted.terms_accepted
        and accepted.privacy_accepted
        and accepted.safety_disclaimer_accepted
    )
    return LegalAcceptanceResponse(
        accepted_version=accepted.version,
        current_version=CURRENT_LEGAL_VERSION,
        terms_accepted=accepted.terms_accepted,
        privacy_accepted=accepted.privacy_accepted,
        safety_disclaimer_accepted=accepted.safety_disclaimer_accepted,
        accepted_at=accepted.accepted_at,
        acceptance_source=accepted.source,
        requires_acceptance=not complete or accepted.version != CURRENT_LEGAL_VERSION,
    )
