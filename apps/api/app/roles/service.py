import asyncio
import logging
from uuid import uuid4

from app.audit.service import AuditService
from app.audit.types import AuditSink
from app.auth.admin import get_auth_admin
from app.auth.claims import ClaimsService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import (
    CreateRoleRequest,
    PermissionCatalog,
    PermissionCatalogGroup,
    PermissionCatalogItem,
    RoleDetail,
    RoleList,
    RoleSummary,
    UpdateRoleRequest,
)
from app.models.base import CompanyScope
from app.models.entities import Role, RoleCreate, RolePermissionCreate, RoleUpdate
from app.rbac.constants import ALL_PERMISSION_KEYS

logger = logging.getLogger(__name__)

# 3.5 (Super-Admin cross-tenant) owns the super_admin template; every company-scoped
# 3.2 endpoint treats it as invisible, mirroring the 3.1 role-picker exclusion.
HIDDEN_ROLE_KEY = "super_admin"
PLATFORM_ADMIN_KEY = "platform.admin"
USERS_MANAGE_KEY = "users.manage"

PERMISSION_GROUP_ORDER = (
    "facilities",
    "areas",
    "assets",
    "inspections",
    "permits",
    "work_orders",
    "reports",
    "safety",
    "users",
    "roles",
    "company",
    "platform",
)


class RoleManagementError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.code = code
        self.message = message
        self.details = details


class RoleManagementService:
    def __init__(
        self,
        *,
        roles: RoleRepository,
        role_permissions: RolePermissionRepository,
        permissions: PermissionRepository,
        users: UserRepository,
        claims: ClaimsService,
        audit: AuditSink,
    ) -> None:
        self._roles = roles
        self._role_permissions = role_permissions
        self._permissions = permissions
        self._users = users
        self._claims = claims
        self._audit = audit

    async def _visible_role(self, scope: CompanyScope, role_id: str) -> Role | None:
        role = await self._roles.get(scope, role_id)
        if role is None or role.key == HIDDEN_ROLE_KEY:
            return None
        return role

    async def _permission_keys_for_role(
        self, scope: CompanyScope, role_id: str
    ) -> frozenset[str]:
        mappings = await self._role_permissions.list_for_role(scope, role_id)
        return frozenset(mapping.permission_id for mapping in mappings)

    async def _ensure_unique_name(
        self,
        scope: CompanyScope,
        name: str,
        *,
        exclude_role_id: str | None,
    ) -> None:
        normalized = name.casefold()
        roles = await self._roles.list(scope)
        for role in roles:
            if role.id == exclude_role_id or role.key == HIDDEN_ROLE_KEY:
                continue
            if role.name.casefold() == normalized:
                raise RoleManagementError(
                    409,
                    "role_name_in_use",
                    "A role with this name already exists in this company",
                )

    def _reject_unknown_or_restricted_keys(self, keys: frozenset[str]) -> None:
        unknown = keys - ALL_PERMISSION_KEYS
        if unknown:
            raise RoleManagementError(
                422,
                "unknown_permission_key",
                "One or more permission keys are not recognized",
                {"keys": sorted(unknown)},
            )
        if PLATFORM_ADMIN_KEY in keys:
            raise RoleManagementError(
                403,
                "platform_admin_not_grantable",
                "platform.admin can only be granted by a platform Super Admin",
            )

    async def _count_active_holders(
        self,
        scope: CompanyScope,
        permission_key: str,
        *,
        override_role_id: str | None = None,
        override_keys: frozenset[str] = frozenset(),
    ) -> int:
        users = await self._users.list(scope)
        mappings = await self._role_permissions.list(scope)
        role_keys: dict[str, set[str]] = {}
        for mapping in mappings:
            role_keys.setdefault(mapping.role_id, set()).add(mapping.permission_id)
        if override_role_id is not None:
            role_keys[override_role_id] = set(override_keys)
        return sum(
            1
            for user in users
            if user.status == "active" and permission_key in role_keys.get(user.role_id, set())
        )

    async def _replace_role_permissions(
        self,
        scope: CompanyScope,
        role_id: str,
        desired_keys: frozenset[str],
        actor_uid: str,
    ) -> None:
        existing = await self._role_permissions.list_for_role(scope, role_id)
        existing_by_key = {mapping.permission_id: mapping for mapping in existing}
        creations = [
            self._role_permissions.create(
                scope,
                RolePermissionCreate(
                    id=f"{role_id}__{key}",
                    role_id=role_id,
                    permission_id=key,
                ),
                actor_uid,
            )
            for key in desired_keys
            if key not in existing_by_key
        ]
        deletions = [
            self._role_permissions.delete(scope, mapping.id, actor_uid)
            for key, mapping in existing_by_key.items()
            if key not in desired_keys
        ]
        if creations:
            await asyncio.gather(*creations)
        if deletions:
            await asyncio.gather(*deletions)

    async def _sync_claims_for_role(self, scope: CompanyScope, role_id: str) -> None:
        holders = [user for user in await self._users.list(scope) if user.role_id == role_id]
        if not holders:
            return
        results = await asyncio.gather(
            *(self._claims.sync_claims_from_role(user.id) for user in holders),
            return_exceptions=True,
        )
        for user, result in zip(holders, results, strict=True):
            if isinstance(result, BaseException):
                logger.warning(
                    "Claims sync failed for user %s after role %s permission change: %s",
                    user.id,
                    role_id,
                    result,
                )

    async def list_roles(self, scope: CompanyScope) -> RoleList:
        roles = [role for role in await self._roles.list(scope) if role.key != HIDDEN_ROLE_KEY]
        roles.sort(key=lambda role: role.name.casefold())
        mappings = await self._role_permissions.list(scope)
        users = await self._users.list(scope)
        permission_counts: dict[str, int] = {}
        for mapping in mappings:
            permission_counts[mapping.role_id] = permission_counts.get(mapping.role_id, 0) + 1
        user_counts: dict[str, int] = {}
        for user in users:
            user_counts[user.role_id] = user_counts.get(user.role_id, 0) + 1
        return RoleList(
            items=[
                RoleSummary(
                    id=role.id,
                    key=role.key,
                    name=role.name,
                    description=role.description,
                    is_system=role.is_system,
                    permission_count=permission_counts.get(role.id, 0),
                    assigned_user_count=user_counts.get(role.id, 0),
                )
                for role in roles
            ]
        )

    async def get_role(self, scope: CompanyScope, role_id: str) -> RoleDetail:
        role = await self._visible_role(scope, role_id)
        if role is None:
            raise RoleManagementError(404, "role_not_found", "Role was not found in this company")
        keys = await self._permission_keys_for_role(scope, role.id)
        users = await self._users.list(scope)
        assigned = sum(1 for user in users if user.role_id == role.id)
        return RoleDetail(
            id=role.id,
            key=role.key,
            name=role.name,
            description=role.description,
            is_system=role.is_system,
            permission_keys=sorted(keys),
            assigned_user_count=assigned,
        )

    async def create_role(
        self,
        scope: CompanyScope,
        request: CreateRoleRequest,
        actor_uid: str,
    ) -> RoleDetail:
        if request.clone_from_role_id:
            source = await self._visible_role(scope, request.clone_from_role_id)
            if source is None:
                raise RoleManagementError(
                    404, "role_not_found", "Clone source role was not found in this company"
                )
            keys = await self._permission_keys_for_role(scope, source.id)
        else:
            keys = frozenset(request.permission_keys)
        self._reject_unknown_or_restricted_keys(keys)

        name = " ".join(request.name.split())
        await self._ensure_unique_name(scope, name, exclude_role_id=None)

        role_id_value = f"role_{uuid4().hex}"
        role = await self._roles.create(
            scope,
            RoleCreate(
                id=role_id_value,
                key=role_id_value,
                name=name,
                description=request.description,
                is_system=False,
            ),
            actor_uid,
        )
        if keys:
            await self._replace_role_permissions(scope, role.id, keys, actor_uid)
        return await self.get_role(scope, role.id)

    async def update_role(
        self,
        scope: CompanyScope,
        role_id: str,
        request: UpdateRoleRequest,
        actor_uid: str,
    ) -> RoleDetail:
        role = await self._visible_role(scope, role_id)
        if role is None:
            raise RoleManagementError(404, "role_not_found", "Role was not found in this company")
        if role.is_system:
            raise RoleManagementError(
                409,
                "system_role_locked",
                "System roles are read-only and cannot be modified",
            )

        before_keys = await self._permission_keys_for_role(scope, role.id)
        changes: dict[str, object] = {}
        if request.name is not None:
            name = " ".join(request.name.split())
            await self._ensure_unique_name(scope, name, exclude_role_id=role.id)
            changes["name"] = name
        if request.description is not None:
            changes["description"] = request.description

        after_keys = before_keys
        if request.permission_keys is not None:
            after_keys = frozenset(request.permission_keys)
            self._reject_unknown_or_restricted_keys(after_keys)
            losing_users_manage = (
                USERS_MANAGE_KEY in before_keys and USERS_MANAGE_KEY not in after_keys
            )
            if losing_users_manage:
                holders = await self._count_active_holders(
                    scope,
                    USERS_MANAGE_KEY,
                    override_role_id=role.id,
                    override_keys=after_keys,
                )
                if holders < 1:
                    raise RoleManagementError(
                        409,
                        "last_holder_of_users_manage",
                        "This change would leave no active user able to manage users",
                    )

        if changes:
            await self._roles.update(scope, role.id, RoleUpdate(**changes), actor_uid)

        if after_keys != before_keys:
            await self._replace_role_permissions(scope, role.id, after_keys, actor_uid)
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action="role.permissions_updated",
                target_type="role",
                target_id=role.id,
                metadata={
                    "before": sorted(before_keys),
                    "after": sorted(after_keys),
                    "added": sorted(after_keys - before_keys),
                    "removed": sorted(before_keys - after_keys),
                },
            )
            await self._sync_claims_for_role(scope, role.id)

        return await self.get_role(scope, role.id)

    async def delete_role(self, scope: CompanyScope, role_id: str, actor_uid: str) -> None:
        role = await self._visible_role(scope, role_id)
        if role is None:
            raise RoleManagementError(404, "role_not_found", "Role was not found in this company")
        if role.is_system:
            raise RoleManagementError(
                409,
                "system_role_locked",
                "System roles are read-only and cannot be deleted",
            )
        assigned = [user for user in await self._users.list(scope) if user.role_id == role.id]
        if assigned:
            raise RoleManagementError(
                409,
                "role_has_assigned_users",
                f"{len(assigned)} user(s) are assigned to this role and must be reassigned first",
                {"assigned_user_count": len(assigned)},
            )
        mappings = await self._role_permissions.list_for_role(scope, role.id)
        if mappings:
            await asyncio.gather(
                *(
                    self._role_permissions.delete(scope, mapping.id, actor_uid)
                    for mapping in mappings
                )
            )
        await self._roles.delete(scope, role.id, actor_uid)

    async def list_permission_catalog(self) -> PermissionCatalog:
        permissions = await self._permissions.list()
        by_group: dict[str, list[PermissionCatalogItem]] = {}
        for permission in permissions:
            by_group.setdefault(permission.group, []).append(
                PermissionCatalogItem(
                    key=permission.key,
                    group=permission.group,
                    description=permission.description,
                )
            )
        groups = []
        for group in PERMISSION_GROUP_ORDER:
            items = sorted(by_group.get(group, ()), key=lambda item: item.key)
            if items:
                groups.append(PermissionCatalogGroup(group=group, items=items))
        return PermissionCatalog(groups=groups)


def get_role_management_service() -> RoleManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    admin = get_auth_admin()
    users = UserRepository(client, audit)
    roles = RoleRepository(client, audit)
    role_permissions = RolePermissionRepository(client, audit)
    permissions = PermissionRepository(client)
    claims = ClaimsService(admin, users, roles)
    return RoleManagementService(
        roles=roles,
        role_permissions=role_permissions,
        permissions=permissions,
        users=users,
        claims=claims,
        audit=audit,
    )
