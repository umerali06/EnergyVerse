import asyncio

from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope


class PermissionResolver:
    def __init__(
        self,
        users: UserRepository,
        roles: RoleRepository,
        role_permissions: RolePermissionRepository,
        permissions: PermissionRepository,
    ) -> None:
        self._users = users
        self._roles = roles
        self._role_permissions = role_permissions
        self._permissions = permissions

    async def resolve_for_user(
        self,
        scope: CompanyScope,
        user_id: str,
    ) -> frozenset[str]:
        user = await self._users.get(scope, user_id)
        if user is None:
            raise LookupError("user not found in company scope")
        if await self._roles.get(scope, user.role_id) is None:
            raise LookupError("user role not found in company scope")

        mappings = await self._role_permissions.list_for_role(scope, user.role_id)
        permissions = await asyncio.gather(
            *(self._permissions.get(mapping.permission_id) for mapping in mappings)
        )
        permission_keys = set()
        for permission in permissions:
            if permission is None:
                raise LookupError("role references an unknown permission")
            permission_keys.add(permission.key)
        return frozenset(permission_keys)
