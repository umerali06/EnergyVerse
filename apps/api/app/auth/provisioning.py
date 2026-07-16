from app.audit.service import AuditService
from app.auth.admin import AuthAdmin, AuthUser, get_auth_admin
from app.auth.claims import ClaimsService
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.models.entities import User, UserCreate


class UserProvisioningService:
    def __init__(
        self,
        admin: AuthAdmin | None = None,
        users: UserRepository | None = None,
        roles: RoleRepository | None = None,
        audit: AuditService | None = None,
        claims: ClaimsService | None = None,
    ) -> None:
        self._admin = admin or get_auth_admin()
        self._audit = audit or AuditService(AuditLogRepository())
        self._users = users or UserRepository(audit=self._audit)
        self._roles = roles or RoleRepository()
        self._claims = claims or ClaimsService(self._admin, self._users, self._roles)

    async def _ensure_auth_user(
        self,
        *,
        email: str,
        password: str | None,
        display_name: str,
        allow_existing: bool,
    ) -> AuthUser:
        existing = await self._admin.get_user_by_email(email)
        if existing is not None:
            if not allow_existing:
                raise ValueError("Firebase Auth user already exists")
            return await self._admin.update_user(
                existing.uid,
                password=password,
                display_name=display_name,
            )
        return await self._admin.create_user(
            email=email,
            password=password,
            display_name=display_name,
        )

    async def provision_user(
        self,
        *,
        email: str,
        company_id: str,
        role_id: str,
        display_name: str,
        actor_uid: str,
        password: str | None = None,
    ) -> User:
        scope = CompanyScope(company_id=company_id)
        role = await self._roles.get(scope, role_id)
        if role is None:
            raise LookupError("role not found in company scope")
        auth_user = await self._ensure_auth_user(
            email=email,
            password=password,
            display_name=display_name,
            allow_existing=False,
        )
        user = await self._users.create(
            scope,
            UserCreate(
                id=auth_user.uid,
                email=email,
                display_name=display_name,
                role_id=role_id,
                status="active",
            ),
            actor_uid,
        )
        await self._claims.set_claims(
            auth_user.uid,
            company_id=company_id,
            role_id=role_id,
            role_key=role.key,
        )
        await self._audit.audit(
            scope,
            actor_uid=actor_uid,
            action="user.provisioned",
            target_type="user",
            target_id=auth_user.uid,
            metadata={"email": email, "role_id": role_id},
        )
        return user

    async def provision_seed_user(
        self,
        *,
        placeholder_uid: str,
        email: str,
        company_id: str,
        role_id: str,
        display_name: str,
        password: str,
        actor_uid: str,
    ) -> User:
        if not placeholder_uid.startswith("demo-"):
            raise ValueError("Only declared demo users may use seed provisioning")
        scope = CompanyScope(company_id=company_id)
        role = await self._roles.get(scope, role_id)
        if role is None:
            raise LookupError("role not found in company scope")
        auth_user = await self._ensure_auth_user(
            email=email,
            password=password,
            display_name=display_name,
            allow_existing=True,
        )
        user = await self._users.migrate_seed_user_id(
            scope,
            placeholder_id=placeholder_uid,
            firebase_uid=auth_user.uid,
            expected_email=email,
            actor_uid=actor_uid,
        )
        await self._claims.set_claims(
            auth_user.uid,
            company_id=company_id,
            role_id=role_id,
            role_key=role.key,
        )
        return user
