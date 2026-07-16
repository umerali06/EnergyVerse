from typing import Annotated

from fastapi import APIRouter, Depends

from app.models.api import DemoGateResponse, error_responses
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/_rbac-demo", tags=["rbac-demo"])

# TODO: remove when real modules land.


@router.get(
    "/single",
    response_model=DemoGateResponse,
    operation_id="rbac_demo_single_permission",
    responses=error_responses(401, 403, 422, 500),
)
async def single_permission(
    _: Annotated[CurrentUser, Depends(require_permission("assets.write"))],
) -> DemoGateResponse:
    return DemoGateResponse(ok=True)


@router.get(
    "/all",
    response_model=DemoGateResponse,
    operation_id="rbac_demo_all_permissions",
    responses=error_responses(401, 403, 422, 500),
)
async def all_permissions(
    _: Annotated[
        CurrentUser,
        Depends(require_permission("assets.write", "reports.generate", mode="all")),
    ],
) -> DemoGateResponse:
    return DemoGateResponse(ok=True)


@router.get(
    "/any",
    response_model=DemoGateResponse,
    operation_id="rbac_demo_any_permission",
    responses=error_responses(401, 403, 422, 500),
)
async def any_permission(
    _: Annotated[
        CurrentUser,
        Depends(require_permission("permits.approve", "work_orders.write", mode="any")),
    ],
) -> DemoGateResponse:
    return DemoGateResponse(ok=True)
