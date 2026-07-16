from collections.abc import Mapping

from app.auth.admin import AuthAdmin, get_auth_admin
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope


class ClaimsService:
    def __init__(
        self,
        admin: AuthAdmin | None = None,
        users: UserRepository | None = None,
        roles: RoleRepository | None = None,
    ) -> None:
        self._admin = admin or get_auth_admin()
        self._users = users or UserRepository()
        self._roles = roles or RoleRepository()

    async def set_claims(
        self,
        uid: str,
        *,
        company_id: str,
        role_id: str,
        role_key: str,
    ) -> Mapping[str, object]:
        claims: dict[str, object] = {
            "company_id": company_id,
            "role_id": role_id,
            "role_key": role_key,
        }
        await self._admin.set_custom_user_claims(uid, claims)
        return claims

    async def sync_claims_from_role(self, uid: str) -> Mapping[str, object]:
        auth_user = await self._admin.get_user(uid)
        existing_claims = auth_user.custom_claims or {}
        company_id = existing_claims.get("company_id")
        if not isinstance(company_id, str) or not company_id:
            raise LookupError("Firebase user has no company_id claim")

        scope = CompanyScope(company_id=company_id)
        user = await self._users.get(scope, uid)
        if user is None:
            raise LookupError("user not found in company scope")
        role = await self._roles.get(scope, user.role_id)
        if role is None:
            raise LookupError("user role not found in company scope")
        return await self.set_claims(
            uid,
            company_id=company_id,
            role_id=role.id,
            role_key=role.key,
        )
