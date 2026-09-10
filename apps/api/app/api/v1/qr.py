from typing import Annotated

from fastapi import APIRouter, Depends

from app.assets.service import (
    AssetManagementError,
    AssetManagementService,
    get_asset_management_service,
)
from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import QrScanResult, error_responses
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(
    prefix="/api/v1/qr", tags=["qr"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.ASSETS))],
)

_qr_scan_access = require_permission("assets.read")


@router.get(
    "/{code}/resolve",
    response_model=QrScanResult,
    operation_id="resolve_qr_code",
    responses=error_responses(401, 403, 404, 500),
)
async def resolve_qr_code(
    code: str,
    current_user: Annotated[CurrentUser, Depends(_qr_scan_access)],
    service: Annotated[AssetManagementService, Depends(get_asset_management_service)],
) -> QrScanResult:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.resolve_qr_code(scope, code, current_user.uid)
    except AssetManagementError as error:
        raise ApiError(
            status_code=error.status_code,
            error=error.code,
            message=error.message,
            details=error.details,
        ) from error
