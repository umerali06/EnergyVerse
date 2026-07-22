from typing import Annotated

from fastapi import APIRouter, Depends

from app.core.errors import ApiError
from app.models.api import (
    CreateRoleRequest,
    RoleDeleted,
    RoleDetail,
    RoleList,
    UpdateRoleRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.roles.service import (
    RoleManagementError,
    RoleManagementService,
    get_role_management_service,
)

router = APIRouter(prefix="/api/v1/roles", tags=["roles"])

# The list route is also consumed by the 3.1 user-management role picker, which
# gates on users.manage rather than roles.manage -- accept either so a custom
# role holding one but not the other keeps working (D-024).
_roles_read_access = require_permission("roles.manage", "users.manage", mode="any")
_roles_manage_access = require_permission("roles.manage")


def _raise_api_error(error: RoleManagementError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=RoleList,
    operation_id="list_roles",
    responses=error_responses(401, 403, 422, 500),
)
async def list_roles(
    current_user: Annotated[CurrentUser, Depends(_roles_read_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> RoleList:
    scope = CompanyScope(company_id=current_user.company_id)
    return await service.list_roles(scope)


@router.get(
    "/{role_id}",
    response_model=RoleDetail,
    operation_id="get_role",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def get_role(
    role_id: str,
    current_user: Annotated[CurrentUser, Depends(_roles_manage_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> RoleDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.get_role(scope, role_id)
    except RoleManagementError as error:
        _raise_api_error(error)
        raise


@router.post(
    "",
    response_model=RoleDetail,
    status_code=201,
    operation_id="create_role",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def create_role(
    request: CreateRoleRequest,
    current_user: Annotated[CurrentUser, Depends(_roles_manage_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> RoleDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.create_role(scope, request, current_user.uid)
    except RoleManagementError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{role_id}",
    response_model=RoleDetail,
    operation_id="update_role",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_role(
    role_id: str,
    request: UpdateRoleRequest,
    current_user: Annotated[CurrentUser, Depends(_roles_manage_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> RoleDetail:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return await service.update_role(scope, role_id, request, current_user.uid)
    except RoleManagementError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{role_id}",
    response_model=RoleDeleted,
    operation_id="delete_role",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def delete_role(
    role_id: str,
    current_user: Annotated[CurrentUser, Depends(_roles_manage_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> RoleDeleted:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.delete_role(scope, role_id, current_user.uid)
    except RoleManagementError as error:
        _raise_api_error(error)
        raise
    return RoleDeleted(id=role_id)
