from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.core.errors import ApiError
from app.models.api import (
    InviteUserRequest,
    UpdateUserRequest,
    UpdateUserStatusRequest,
    UserDetail,
    UserListPage,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.users.service import (
    UserManagementError,
    UserManagementService,
    get_user_management_service,
)

router = APIRouter(prefix="/api/v1/users", tags=["users"])

# Only company_admin/super_admin hold users.manage (0.4 matrix): a Company
# Admin manages the people in their own tenant only (0.4 tenancy boundary).
_users_access = require_permission("users.manage")


def _raise_api_error(error: UserManagementError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=UserListPage,
    operation_id="list_users",
    responses=error_responses(401, 403, 422, 500),
)
async def list_users(
    current_user: Annotated[CurrentUser, Depends(_users_access)],
    service: Annotated[UserManagementService, Depends(get_user_management_service)],
    search: Annotated[str | None, Query(max_length=200)] = None,
    role_id: Annotated[str | None, Query(max_length=200)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    sort: Annotated[str, Query(max_length=20)] = "name",
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> UserListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.list_users(
            scope,
            search=search,
            role_id=role_id,
            status=status,
            sort=sort,
            cursor=cursor,
            limit=limit,
        )
    except UserManagementError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{user_id}",
    response_model=UserDetail,
    operation_id="get_user",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def get_user(
    user_id: str,
    current_user: Annotated[CurrentUser, Depends(_users_access)],
    service: Annotated[UserManagementService, Depends(get_user_management_service)],
) -> UserDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_user(scope, user_id)
    except UserManagementError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/invite",
    response_model=UserDetail,
    status_code=201,
    operation_id="invite_user",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def invite_user(
    request: InviteUserRequest,
    current_user: Annotated[CurrentUser, Depends(_users_access)],
    service: Annotated[UserManagementService, Depends(get_user_management_service)],
) -> UserDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.invite_user(scope, request, current_user)
    except UserManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{user_id}",
    response_model=UserDetail,
    operation_id="update_user",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_user(
    user_id: str,
    request: UpdateUserRequest,
    current_user: Annotated[CurrentUser, Depends(_users_access)],
    service: Annotated[UserManagementService, Depends(get_user_management_service)],
) -> UserDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_user(scope, user_id, request, current_user)
    except UserManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{user_id}/status",
    response_model=UserDetail,
    operation_id="set_user_status",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def set_user_status(
    user_id: str,
    request: UpdateUserStatusRequest,
    current_user: Annotated[CurrentUser, Depends(_users_access)],
    service: Annotated[UserManagementService, Depends(get_user_management_service)],
) -> UserDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.set_status(scope, user_id, request, current_user)
    except UserManagementError as error:
        _raise_api_error(error)
        raise
