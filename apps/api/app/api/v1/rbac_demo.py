from typing import Annotated

from fastapi import APIRouter, Depends

from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/_rbac-demo", tags=["rbac-demo"])

# TODO: remove when real modules land.


@router.get("/single")
async def single_permission(
    _: Annotated[CurrentUser, Depends(require_permission("assets.write"))],
) -> dict[str, bool]:
    return {"ok": True}


@router.get("/all")
async def all_permissions(
    _: Annotated[
        CurrentUser,
        Depends(require_permission("assets.write", "reports.generate", mode="all")),
    ],
) -> dict[str, bool]:
    return {"ok": True}


@router.get("/any")
async def any_permission(
    _: Annotated[
        CurrentUser,
        Depends(require_permission("permits.approve", "work_orders.write", mode="any")),
    ],
) -> dict[str, bool]:
    return {"ok": True}
