import base64
import binascii

from app.audit.service import AuditService
from app.auth.admin import get_auth_admin
from app.auth.claims import ClaimsService
from app.auth.provisioning import UserProvisioningService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import (
    InviteUserRequest,
    UpdateUserRequest,
    UpdateUserStatusRequest,
    UserDetail,
    UserListItem,
    UserListPage,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser, Role, User, UserUpdate
from app.rbac.service import PermissionResolver

# Only company_admin/super_admin ever hold users.manage (0.4/0.4 matrix), but a
# super_admin role document still exists per company (seed_system_roles seeds all
# seven templates for every tenant) -- so "cannot grant platform.admin/super_admin"
# must be enforced explicitly rather than relying on scoping alone.
ADMIN_ROLE_KEYS = frozenset({"company_admin", "super_admin"})
SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at"})


class UserManagementError(Exception):
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


def _encode_cursor(user_id: str) -> str:
    return base64.urlsafe_b64encode(user_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise UserManagementError(422, "invalid_cursor", "Cursor is not valid") from error


class UserManagementService:
    def __init__(
        self,
        *,
        users: UserRepository,
        roles: RoleRepository,
        claims: ClaimsService,
        provisioner: UserProvisioningService,
        resolver: PermissionResolver,
    ) -> None:
        self._users = users
        self._roles = roles
        self._claims = claims
        self._provisioner = provisioner
        self._resolver = resolver

    def _to_list_item(self, user: User, roles_by_id: dict[str, Role]) -> UserListItem:
        role = roles_by_id.get(user.role_id)
        if role is None:
            raise LookupError(f"role {user.role_id} not found for user {user.id}")
        return UserListItem(
            id=user.id,
            email=user.email,
            display_name=user.display_name,
            role_id=user.role_id,
            role_key=role.key,
            role_name=role.name,
            status=user.status,
            created_at=user.created_at,
            updated_at=user.updated_at,
        )

    async def _active_admin_count(self, scope: CompanyScope, roles_by_id: dict[str, Role]) -> int:
        admin_role_ids = {
            role_id for role_id, role in roles_by_id.items() if role.key == "company_admin"
        }
        users = await self._users.list(scope)
        return sum(
            1
            for user in users
            if user.status == "active" and user.role_id in admin_role_ids
        )

    async def list_users(
        self,
        scope: CompanyScope,
        *,
        search: str | None,
        role_id: str | None,
        status: str | None,
        sort: str,
        cursor: str | None,
        limit: int,
    ) -> UserListPage:
        if sort not in SORT_OPTIONS:
            raise UserManagementError(
                422,
                "invalid_sort",
                "sort must be one of name, -name, created_at, -created_at",
            )
        users = await self._users.list(scope)
        if search and search.strip():
            term = search.strip().casefold()
            users = [
                user
                for user in users
                if term in user.email.casefold() or term in user.display_name.casefold()
            ]
        if role_id:
            users = [user for user in users if user.role_id == role_id]
        if status:
            users = [user for user in users if user.status == status]

        reverse = sort.startswith("-")
        key = sort.lstrip("-")
        if key == "name":
            users.sort(key=lambda user: (user.display_name.casefold(), user.id), reverse=reverse)
        else:
            users.sort(key=lambda user: (user.created_at, user.id), reverse=reverse)

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [user.id for user in users]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(users)
            users = users[start:]

        page = users[:limit]
        roles_by_id = {role.id: role for role in await self._roles.list(scope)}
        items = [self._to_list_item(user, roles_by_id) for user in page]
        next_cursor = (
            _encode_cursor(page[-1].id) if len(users) > limit and page else None
        )
        return UserListPage(items=items, next_cursor=next_cursor)

    async def get_user(self, scope: CompanyScope, user_id: str) -> UserDetail:
        user = await self._users.get(scope, user_id)
        if user is None:
            raise UserManagementError(404, "user_not_found", "User was not found")
        roles_by_id = {role.id: role for role in await self._roles.list(scope)}
        item = self._to_list_item(user, roles_by_id)
        permissions = await self._resolver.resolve_for_user(scope, user_id)
        return UserDetail(**item.model_dump(), permissions=sorted(permissions))

    async def invite_user(
        self,
        scope: CompanyScope,
        request: InviteUserRequest,
        actor: CurrentUser,
    ) -> UserDetail:
        role = await self._roles.get(scope, request.role_id)
        if role is None:
            raise UserManagementError(404, "role_not_found", "Role was not found in this company")
        if role.key == "super_admin":
            raise UserManagementError(
                422,
                "role_not_assignable",
                "Company Admins cannot assign the Super Admin role",
            )
        email = request.email.strip().casefold()
        display_name = " ".join(request.display_name.split())
        try:
            user = await self._provisioner.provision_user(
                email=email,
                company_id=scope.company_id,
                role_id=request.role_id,
                display_name=display_name,
                actor_uid=actor.uid,
                password=None,
            )
        except ValueError as error:
            if "already exists" in str(error).casefold():
                raise UserManagementError(
                    409,
                    "email_already_in_use",
                    "A user with this email already exists",
                ) from error
            raise
        except LookupError as error:
            raise UserManagementError(
                404, "role_not_found", "Role was not found in this company"
            ) from error
        return await self.get_user(scope, user.id)

    async def update_user(
        self,
        scope: CompanyScope,
        user_id: str,
        request: UpdateUserRequest,
        actor: CurrentUser,
    ) -> UserDetail:
        current = await self._users.get(scope, user_id)
        if current is None:
            raise UserManagementError(404, "user_not_found", "User was not found")
        roles_by_id = {role.id: role for role in await self._roles.list(scope)}
        current_role = roles_by_id.get(current.role_id)
        if current_role is None:
            raise LookupError(f"role {current.role_id} not found for user {current.id}")

        role_changing = request.role_id is not None and request.role_id != current.role_id
        if role_changing:
            new_role = roles_by_id.get(request.role_id) if request.role_id else None
            if new_role is None:
                raise UserManagementError(
                    404, "role_not_found", "Role was not found in this company"
                )
            if new_role.key == "super_admin":
                raise UserManagementError(
                    422,
                    "role_not_assignable",
                    "Company Admins cannot assign the Super Admin role",
                )

            is_self = user_id == actor.uid
            demoted_out_of_admin = (
                current_role.key in ADMIN_ROLE_KEYS and new_role.key not in ADMIN_ROLE_KEYS
            )
            if is_self and demoted_out_of_admin:
                raise UserManagementError(
                    409,
                    "cannot_demote_self",
                    "You cannot demote yourself out of an admin role",
                )

            if (
                current_role.key == "company_admin"
                and new_role.key != "company_admin"
                and current.status == "active"
                and await self._active_admin_count(scope, roles_by_id) <= 1
            ):
                raise UserManagementError(
                    409,
                    "last_admin_protected",
                    "The last active Company Admin cannot be demoted",
                )

        await self._users.update(
            scope,
            user_id,
            UserUpdate(
                display_name=request.display_name,
                role_id=request.role_id if role_changing else None,
            ),
            actor.uid,
        )
        if role_changing:
            await self._claims.sync_claims_from_role(user_id)
        return await self.get_user(scope, user_id)

    async def set_status(
        self,
        scope: CompanyScope,
        user_id: str,
        request: UpdateUserStatusRequest,
        actor: CurrentUser,
    ) -> UserDetail:
        current = await self._users.get(scope, user_id)
        if current is None:
            raise UserManagementError(404, "user_not_found", "User was not found")
        if request.status == current.status:
            return await self.get_user(scope, user_id)

        if user_id == actor.uid and request.status == "inactive":
            raise UserManagementError(
                409,
                "cannot_modify_self",
                "You cannot deactivate your own account",
            )

        if request.status == "inactive":
            roles_by_id = {role.id: role for role in await self._roles.list(scope)}
            current_role = roles_by_id.get(current.role_id)
            if (
                current_role is not None
                and current_role.key == "company_admin"
                and current.status == "active"
                and await self._active_admin_count(scope, roles_by_id) <= 1
            ):
                raise UserManagementError(
                    409,
                    "last_admin_protected",
                    "The last active Company Admin cannot be deactivated",
                )

        await self._users.update(
            scope,
            user_id,
            UserUpdate(status=request.status),
            actor.uid,
        )
        return await self.get_user(scope, user_id)


def get_user_management_service() -> UserManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    admin = get_auth_admin()
    users = UserRepository(client, audit)
    roles = RoleRepository(client, audit)
    role_permissions = RolePermissionRepository(client, audit)
    permissions = PermissionRepository(client)
    claims = ClaimsService(admin, users, roles)
    provisioner = UserProvisioningService(
        admin=admin,
        users=users,
        roles=roles,
        audit=audit,
        claims=claims,
    )
    resolver = PermissionResolver(users, roles, role_permissions, permissions)
    return UserManagementService(
        users=users,
        roles=roles,
        claims=claims,
        provisioner=provisioner,
        resolver=resolver,
    )
