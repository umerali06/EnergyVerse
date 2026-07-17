import re
from collections.abc import Callable
from uuid import uuid4

from app.audit.service import AuditService
from app.auth.admin import AuthAdmin, get_auth_admin
from app.auth.provisioning import UserProvisioningService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.models.entities import (
    CompanyCreate,
    CompanyRegistrationRequest,
    CompanyRegistrationResponse,
)
from app.rbac.seeding import seed_system_roles

EMAIL_PATTERN = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")
REGISTRATION_ACTOR = "system:registration"


class RegistrationError(Exception):
    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code
        self.message = message


class CompanyRegistrationService:
    def __init__(
        self,
        *,
        admin: AuthAdmin,
        companies: CompanyRepository,
        roles: RoleRepository,
        role_permissions: RolePermissionRepository,
        provisioner: UserProvisioningService,
        audit: AuditService,
        company_id_factory: Callable[[], str] | None = None,
    ) -> None:
        self._admin = admin
        self._companies = companies
        self._roles = roles
        self._role_permissions = role_permissions
        self._provisioner = provisioner
        self._audit = audit
        self._company_id_factory = company_id_factory or (lambda: f"cmp_{uuid4().hex}")

    async def register(
        self,
        request: CompanyRegistrationRequest,
    ) -> CompanyRegistrationResponse:
        company_name = " ".join(request.company_name.split())
        display_name = " ".join(request.display_name.split())
        email = request.email.strip().casefold()
        if len(company_name) < 2 or len(display_name) < 2:
            raise RegistrationError("invalid_registration", "Required names are invalid")
        if EMAIL_PATTERN.fullmatch(email) is None:
            raise RegistrationError("invalid_email", "Email address is invalid")
        if await self._admin.get_user_by_email(email) is not None:
            raise RegistrationError(
                "email_already_in_use",
                "An account already exists for this email",
            )

        company_id = self._company_id_factory()
        scope = CompanyScope(company_id=company_id)
        await self._companies.create(
            CompanyCreate(
                id=company_id,
                name=company_name,
                status="active",
                subscription_tier="unassigned",
            ),
            REGISTRATION_ACTOR,
        )
        role_ids = await seed_system_roles(
            scope,
            self._roles,
            self._role_permissions,
            actor_uid=REGISTRATION_ACTOR,
        )
        try:
            user = await self._provisioner.provision_user(
                email=email,
                company_id=company_id,
                role_id=role_ids["company_admin"],
                display_name=display_name,
                actor_uid=REGISTRATION_ACTOR,
                password=request.password,
            )
        except ValueError as error:
            if "Auth user already exists" in str(error):
                raise RegistrationError(
                    "email_already_in_use",
                    "An account already exists for this email",
                ) from error
            raise

        await self._audit.audit(
            scope,
            actor_uid=user.id,
            action="company.self_registered",
            target_type="company",
            target_id=company_id,
            metadata={
                "company_name": company_name,
                "admin_uid": user.id,
                "admin_email": email,
            },
        )
        return CompanyRegistrationResponse(
            uid=user.id,
            email=user.email,
            email_verified=False,
            company_id=company_id,
            role_key="company_admin",
        )


def get_registration_service() -> CompanyRegistrationService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    admin = get_auth_admin()
    companies = CompanyRepository(client, audit)
    roles = RoleRepository(client, audit)
    role_permissions = RolePermissionRepository(client, audit)
    users = UserRepository(client, audit)
    provisioner = UserProvisioningService(
        admin=admin,
        users=users,
        roles=roles,
        audit=audit,
    )
    return CompanyRegistrationService(
        admin=admin,
        companies=companies,
        roles=roles,
        role_permissions=role_permissions,
        provisioner=provisioner,
        audit=audit,
    )
