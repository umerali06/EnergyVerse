from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.core.errors import ApiError
from app.models.api import (
    AssignWorkOrderRequest,
    CreateWorkOrderRequest,
    SubmitWorkOrderForReviewRequest,
    WorkOrderDeleted,
    WorkOrderDetail,
    WorkOrderListPage,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.work_orders.service import (
    WorkOrderService,
    WorkOrderServiceError,
    get_work_order_service,
)

router = APIRouter(prefix="/api/v1/work-orders", tags=["work_orders"])

_work_orders_read_access = require_permission("work_orders.read")
_work_orders_write_access = require_permission("work_orders.write")
_work_orders_close_access = require_permission("work_orders.close")


def _raise_api_error(error: WorkOrderServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=WorkOrderListPage,
    operation_id="list_work_orders",
    responses=error_responses(401, 403, 422, 500),
)
async def list_work_orders(
    current_user: Annotated[CurrentUser, Depends(_work_orders_read_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
    asset_id: Annotated[str | None, Query(max_length=200)] = None,
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    technician_id: Annotated[str | None, Query(max_length=200)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> WorkOrderListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_work_orders(
            scope,
            asset_id=asset_id,
            facility_id=facility_id,
            status=status,
            technician_id=technician_id,
            cursor=cursor,
            limit=limit,
        )
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=WorkOrderDetail,
    operation_id="create_work_order",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def create_work_order(
    request: CreateWorkOrderRequest,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_work_order(scope, request, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{work_order_id}",
    response_model=WorkOrderDetail,
    operation_id="get_work_order",
    responses=error_responses(401, 403, 404, 500),
)
async def get_work_order(
    work_order_id: str,
    current_user: Annotated[CurrentUser, Depends(_work_orders_read_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_work_order(scope, work_order_id)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{work_order_id}/assign",
    response_model=WorkOrderDetail,
    operation_id="assign_work_order",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def assign_work_order(
    work_order_id: str,
    request: AssignWorkOrderRequest,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    """Reachable from `open` (first assignment) or `assigned` (reassign to
    a different technician) -- never from `in_progress` onward, since the
    original technician has already started real repair work by then."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.assign_work_order(scope, work_order_id, request, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{work_order_id}/accept",
    response_model=WorkOrderDetail,
    operation_id="accept_work_order",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def accept_work_order(
    work_order_id: str,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    """Only the assigned technician can accept -- a 403
    `not_assigned_technician` otherwise, even for a caller who holds
    `work_orders.write` for other reasons (D-066)."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.accept_work_order(scope, work_order_id, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{work_order_id}/submit-for-review",
    response_model=WorkOrderDetail,
    operation_id="submit_work_order_for_review",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def submit_work_order_for_review(
    work_order_id: str,
    request: SubmitWorkOrderForReviewRequest,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    """Only the assigned technician can submit -- same 403 posture as
    `accept_work_order` (D-066)."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.submit_work_order_for_review(
            scope, work_order_id, request, current_user.uid
        )
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{work_order_id}/close",
    response_model=WorkOrderDetail,
    operation_id="close_work_order",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def close_work_order(
    work_order_id: str,
    current_user: Annotated[CurrentUser, Depends(_work_orders_close_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    """Gated by `work_orders.close`, deliberately distinct from
    `work_orders.write` (D-066) -- the assigned technician (who only holds
    `.write`) cannot reach this route at all, enforcing the spec's
    "Supervisor Review" step rather than leaving it advisory."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.close_work_order(scope, work_order_id, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{work_order_id}/cancel",
    response_model=WorkOrderDetail,
    operation_id="cancel_work_order",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def cancel_work_order(
    work_order_id: str,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.cancel_work_order(scope, work_order_id, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{work_order_id}",
    response_model=WorkOrderDeleted,
    operation_id="delete_work_order",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_work_order(
    work_order_id: str,
    current_user: Annotated[CurrentUser, Depends(_work_orders_write_access)],
    service: Annotated[WorkOrderService, Depends(get_work_order_service)],
) -> WorkOrderDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.delete_work_order(scope, work_order_id, current_user.uid)
    except WorkOrderServiceError as error:
        _raise_api_error(error)
        raise
