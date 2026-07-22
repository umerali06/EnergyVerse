from typing import Annotated

from fastapi import Depends

from app.models.base import AdminScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission

_platform_admin_access = require_permission("platform.admin")


async def get_admin_scope(
    current_user: Annotated[CurrentUser, Depends(_platform_admin_access)],
) -> AdminScope:
    """The only constructor of `AdminScope` -- requires an already-verified
    `platform.admin` permission, never a client-supplied field."""
    return AdminScope(acting_uid=current_user.uid, acting_company_id=current_user.company_id)
