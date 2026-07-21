from typing import Annotated

from fastapi import APIRouter, Depends

from app.db.repositories.roles import RoleRepository
from app.models.api import RoleList, RoleSummary, error_responses
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

router = APIRouter(prefix="/api/v1/roles", tags=["roles"])

# Read-only support for the Phase 3.1 user-management UI's role picker; the
# same 0.4 RoleRepository will grow create/rename/permission-edit endpoints in
# Phase 3.2, but this list-only route is not that -- it never mutates a role.
_roles_access = require_permission("users.manage")


@router.get(
    "",
    response_model=RoleList,
    operation_id="list_roles",
    responses=error_responses(401, 403, 422, 500),
)
async def list_roles(
    current_user: Annotated[CurrentUser, Depends(_roles_access)],
) -> RoleList:
    scope = CompanyScope(company_id=current_user.company_id)
    roles = await RoleRepository().list(scope)
    # super_admin is never an assignable option from this UI (3.1 safety rule).
    assignable = [role for role in roles if role.key != "super_admin"]
    assignable.sort(key=lambda role: role.name)
    return RoleList(
        items=[
            RoleSummary(id=role.id, key=role.key, name=role.name, is_system=role.is_system)
            for role in assignable
        ]
    )
