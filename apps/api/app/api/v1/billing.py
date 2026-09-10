"""Billing routes: the plan catalog, checkout, the webhook, and the read model.

Note the authentication split. `/catalog` is public — the pricing page renders
it. `/checkout` requires a signed-in Company Admin, because it binds a Stripe
subscription to *their* company. `/webhook` is unauthenticated by necessity
(Stripe calls it) and is instead protected by signature verification, which is
the security boundary of the whole flow: a forged event could grant a paid tier.
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status

from app.audit.service import AuditService
from app.billing.dependencies import get_entitlements, require_billing_admin
from app.billing.entitlements import Entitlements
from app.billing.plans import (
    PLANS,
    TIER_ORDER,
    TRIAL_DAYS,
    BillingInterval,
    PlanTier,
)
from app.billing.service import BillingError, SubscriptionService
from app.billing.stripe_gateway import (
    StripeGatewayError,
    StripeNotConfiguredError,
    get_stripe_gateway,
)
from app.core.settings import settings
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.models.api import (
    BillingCatalogResponse,
    BillingPlanQuotasResponse,
    BillingPlanResponse,
    CheckoutSessionRequest,
    CheckoutSessionResponse,
    SubscriptionResponse,
    error_responses,
)
from app.models.entities import CurrentUser

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/v1/billing", tags=["billing"])


def get_subscription_service() -> SubscriptionService:
    return SubscriptionService(
        gateway=get_stripe_gateway(),
        companies=CompanyRepository(),
        audit=AuditService(AuditLogRepository()),
    )


@router.get(
    "/catalog",
    response_model=BillingCatalogResponse,
    operation_id="get_billing_catalog",
    summary="Published plan catalog",
)
async def get_catalog() -> BillingCatalogResponse:
    """Public. Serves the same catalog the API enforces against, so a client
    can never render a tier the backend does not honour."""
    return BillingCatalogResponse(
        trial_days=TRIAL_DAYS,
        plans=[
            BillingPlanResponse(
                tier=tier.value,
                name=PLANS[tier].name,
                audience=PLANS[tier].audience,
                list_monthly_cents=PLANS[tier].list_monthly_cents,
                annual_total_cents=PLANS[tier].annual_total_cents,
                monthly_cents=PLANS[tier].monthly_cents,
                quotas=BillingPlanQuotasResponse(
                    facilities=PLANS[tier].quotas.facilities,
                    assets=PLANS[tier].quotas.assets,
                    seats=PLANS[tier].quotas.seats,
                ),
                features=sorted(feature.value for feature in PLANS[tier].features),
                digital_twin_scope=PLANS[tier].digital_twin_scope,
                support=PLANS[tier].support,
                custom_quoted=PLANS[tier].custom_quoted,
            )
            for tier in TIER_ORDER
        ],
    )


@router.get(
    "/subscription",
    response_model=SubscriptionResponse,
    responses=error_responses(401, 403, 404),
    operation_id="get_subscription",
    summary="This company's plan and entitlements",
)
async def get_subscription(
    entitlements: Annotated[Entitlements, Depends(get_entitlements)],
) -> SubscriptionResponse:
    """Every authenticated user may read their own company's plan — the shell
    needs it to decide which modules to render, so gating it behind an admin
    permission would break the app for everyone else."""
    return SubscriptionResponse(
        tier=entitlements.tier.value,
        plan_name=entitlements.plan.name if entitlements.plan else None,
        status=entitlements.status.value,
        is_entitled=entitlements.is_entitled,
        features=sorted(feature.value for feature in entitlements.features),
        trial_ends_at=entitlements.trial_ends_at,
        trial_days_remaining=entitlements.trial_days_remaining(),
        current_period_end=entitlements.current_period_end,
        quotas=BillingPlanQuotasResponse(
            facilities=entitlements.limit_for("facilities"),
            assets=entitlements.limit_for("assets"),
            seats=entitlements.limit_for("seats"),
        ),
    )


@router.post(
    "/checkout",
    response_model=CheckoutSessionResponse,
    responses=error_responses(400, 401, 403, 503),
    operation_id="create_checkout_session",
    summary="Start a Stripe Checkout session for a plan",
)
async def create_checkout(
    request: CheckoutSessionRequest,
    current_user: Annotated[CurrentUser, Depends(require_billing_admin)],
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> CheckoutSessionResponse:
    """Only a Company Admin may attach billing to the company. The tier and
    interval are validated against the catalog rather than passed to Stripe as
    given, so a tampered request cannot buy an unpublished price."""
    try:
        tier = PlanTier(request.tier)
        interval = BillingInterval(request.interval)
    except ValueError as error:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": "unknown_plan", "message": "Unknown plan or interval"},
        ) from error
    if tier not in PLANS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": "unknown_plan", "message": "Unknown plan"},
        )

    base = settings.app_base_url.rstrip("/")
    try:
        session = await service.start_checkout(
            company_id=current_user.company_id,
            customer_email=current_user.email,
            tier=tier,
            interval=interval,
            # Stripe substitutes the session id, which the completion page uses
            # to poll until the webhook has landed.
            success_url=f"{base}{settings.stripe_success_path}?session_id={{CHECKOUT_SESSION_ID}}",
            cancel_url=f"{base}{settings.stripe_cancel_path}?checkout=cancelled",
        )
    except StripeNotConfiguredError as error:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={
                "error": "billing_unavailable",
                "message": "Billing is not configured on this deployment",
            },
        ) from error
    except StripeGatewayError as error:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={"error": error.code, "message": str(error)},
        ) from error
    except BillingError as error:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": error.code, "message": error.message},
        ) from error
    return CheckoutSessionResponse(session_id=session.id, checkout_url=session.url)


@router.post(
    "/webhook",
    status_code=status.HTTP_200_OK,
    include_in_schema=False,
    operation_id="stripe_webhook",
    summary="Stripe webhook receiver",
)
async def stripe_webhook(
    request: Request,
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> Response:
    """Unauthenticated by necessity; the signature is the gate.

    Returns 200 for anything successfully verified — including events we choose
    to ignore — because a non-2xx makes Stripe retry. Only a signature failure
    or an unconfigured secret is an error, and those must never be treated as
    "probably fine".
    """
    signature = request.headers.get("stripe-signature", "")
    payload = await request.body()
    gateway = get_stripe_gateway()
    try:
        event = gateway.verify_webhook(payload, signature)
    except StripeNotConfiguredError as error:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={
                "error": "webhook_unconfigured",
                "message": "STRIPE_WEBHOOK_SECRET is not configured",
            },
        ) from error
    except StripeGatewayError as error:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": error.code, "message": str(error)},
        ) from error

    try:
        outcome = await service.reconcile_event(event)
    except Exception:
        # Reconciliation failed on a *verified* event. Log and return 500 so
        # Stripe retries — dropping it would leave a paying tenant unentitled.
        logger.exception("Failed to reconcile Stripe event %s", event.get("id"))
        raise
    return Response(
        content=f'{{"received":true,"outcome":"{outcome}"}}',
        media_type="application/json",
    )
