"""Route-level entitlement gate, the paid-for half of access control.

Mirrors `app.rbac.dependencies.require_permission` deliberately — same audit
action (`access.denied`) with `gate="entitlement"`, so one audit query answers
"what was this user refused, and why" across both gates. Stack them on a route:

    dependencies=[Depends(require_permission("work_orders.write")),
                  Depends(require_feature(Feature.WORK_ORDERS))]

The status codes are different on purpose. A permission failure is 403 — the
person is not allowed and no amount of paying changes that. An entitlement
failure is **402 Payment Required**, because the tenant *can* have it: the
response carries the tier that unlocks it so the client renders an upgrade
prompt rather than a dead end.
"""

from __future__ import annotations

import logging
from collections.abc import Awaitable, Callable
from typing import Annotated

from fastapi import Depends, HTTPException, Request, status

from app.audit.types import AuditSink
from app.auth.dependencies import get_current_user, require_verified_email
from app.billing.entitlements import (
    Entitlements,
    QuotaExceededError,
    resolve_entitlements,
    upgrade_hint,
)
from app.billing.plans import Feature
from app.db.repositories.companies import CompanyRepository
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import audit_access_denial, get_access_denial_audit

logger = logging.getLogger(__name__)

EntitlementDependency = Callable[
    [Request, CurrentUser, AuditSink, Entitlements], Awaitable[CurrentUser]
]


def get_company_repository() -> CompanyRepository:
    return CompanyRepository()


async def get_entitlements(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    companies: Annotated[CompanyRepository, Depends(get_company_repository)],
) -> Entitlements:
    """Load the caller's company and resolve its entitlements.

    Injectable on its own so a route can read the tenant's plan (the dashboard
    plan card, the billing page) without also gating on a feature.

    Deliberately depends on `get_current_user`, **not**
    `require_verified_email`: the signup completion page polls this while the
    brand-new admin's email is still unverified. Reading your own company's
    billing state is not reading tenant data, and every module gate that
    consumes these entitlements is stacked with `require_permission`, which
    does enforce verification.
    """
    company = await companies.get(CompanyScope(company_id=current_user.company_id))
    if company is None:
        # The identity resolved, so the company existed a moment ago; treat a
        # miss as unentitled rather than 500 — failing closed.
        raise HTTPException(
            status_code=status.HTTP_402_PAYMENT_REQUIRED,
            detail={
                "error": "subscription_unavailable",
                "message": "No active subscription could be resolved for this company",
            },
        )
    return resolve_entitlements(company)


async def require_billing_admin(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
) -> CurrentUser:
    """Authorize attaching billing to the caller's own company.

    Skips `require_verified_email` on purpose. A company created seconds ago has
    an unverified admin, and the signup flow is details -> pay -> use; demanding
    a mailbox round trip before Stripe would strand every new tenant at the one
    step that makes them a customer. Paying is not access to tenant data, so
    nothing else relaxes: `company.settings` is still required, and every
    module route keeps its verified-email gate.
    """
    if "company.settings" not in current_user.permissions:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "forbidden",
                "message": "Managing this company's subscription requires company.settings",
            },
        )
    return current_user


def require_feature(feature: Feature) -> EntitlementDependency:
    """Gate a route on the tenant's plan including `feature`."""

    async def enforce(
        request: Request,
        current_user: Annotated[CurrentUser, Depends(require_verified_email)],
        audit: Annotated[AuditSink, Depends(get_access_denial_audit)],
        entitlements: Annotated[Entitlements, Depends(get_entitlements)],
    ) -> CurrentUser:
        if entitlements.has(feature):
            return current_user

        await audit_access_denial(
            audit,
            request,
            current_user,
            required=[feature.value],
            missing=[feature.value],
            mode="all",
            gate="entitlement",
        )
        if not entitlements.is_entitled:
            raise HTTPException(
                status_code=status.HTTP_402_PAYMENT_REQUIRED,
                detail={
                    "error": "subscription_inactive",
                    "message": "This company has no active subscription",
                    "details": {
                        "status": entitlements.status.value,
                        "tier": entitlements.tier.value,
                    },
                },
            )
        raise HTTPException(
            status_code=status.HTTP_402_PAYMENT_REQUIRED,
            detail={
                "error": "plan_upgrade_required",
                "message": f"The {entitlements.tier.value} plan does not include this module",
                "details": {
                    "current_tier": entitlements.tier.value,
                    **upgrade_hint(feature),
                },
            },
        )

    return enforce


def quota_error(exceeded: QuotaExceededError) -> HTTPException:
    """Translate a service-layer `QuotaExceededError` into the same 402 envelope.

    Quotas are checked in services rather than dependencies because they need
    the tenant's current row count, which only the service knows how to obtain.
    """
    return HTTPException(
        status_code=status.HTTP_402_PAYMENT_REQUIRED,
        detail={
            "error": "plan_limit_reached",
            "message": str(exceeded),
            "details": {
                "resource": exceeded.resource,
                "limit": exceeded.limit,
                "current": exceeded.current,
                "current_tier": exceeded.tier.value,
                "required_tier": (
                    exceeded.upgrade_tier.value if exceeded.upgrade_tier else None
                ),
            },
        },
    )


def company_scope_of(current_user: CurrentUser) -> CompanyScope:
    return CompanyScope(company_id=current_user.company_id)
