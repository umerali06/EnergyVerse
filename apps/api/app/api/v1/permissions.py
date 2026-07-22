from typing import Annotated

from fastapi import APIRouter, Depends

from app.models.api import PermissionCatalog, error_responses
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.roles.service import RoleManagementService, get_role_management_service

router = APIRouter(prefix="/api/v1/permissions", tags=["permissions"])

_permissions_access = require_permission("roles.manage")


@router.get(
    "",
    response_model=PermissionCatalog,
    operation_id="list_permission_catalog",
    responses=error_responses(401, 403, 422, 500),
)
async def list_permission_catalog(
    _current_user: Annotated[CurrentUser, Depends(_permissions_access)],
    service: Annotated[RoleManagementService, Depends(get_role_management_service)],
) -> PermissionCatalog:
    return await service.list_permission_catalog()
