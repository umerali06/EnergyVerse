import argparse
import asyncio
from dataclasses import dataclass

from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.service import AuditService
from app.auth.admin import AuthAdmin
from app.auth.provisioning import UserProvisioningService
from app.core.settings import settings
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.models.entities import (
    CompanyCreate,
    CompanyUpdate,
    PermissionCreate,
    PermissionUpdate,
    RoleCreate,
    RolePermission,
    RolePermissionCreate,
    RoleUpdate,
    SeedCounts,
    UserCreate,
    UserUpdate,
)
from app.rbac.constants import PERMISSION_CATALOG, SYSTEM_ROLE_TEMPLATES, SystemRoleTemplate

SEED_ACTOR_UID = "system:seed"
ACME_COMPANY_ID = "acme-energy"
SECOND_COMPANY_ID = "beta-utilities"


@dataclass(frozen=True)
class DemoUserSeed:
    company_id: str
    placeholder_uid: str
    email: str
    display_name: str
    role_key: str


DEMO_USERS = tuple(
    DemoUserSeed(
        company_id=ACME_COMPANY_ID,
        placeholder_uid=f"demo-acme-{role_key}",
        email=f"{role_key}@acme.example.invalid",
        display_name=f"Acme {template.name}",
        role_key=role_key,
    )
    for role_key, template in SYSTEM_ROLE_TEMPLATES.items()
) + (
    DemoUserSeed(
        company_id=SECOND_COMPANY_ID,
        placeholder_uid="demo-beta-company-admin",
        email="company_admin@beta.example.invalid",
        display_name="Beta Company Admin",
        role_key="company_admin",
    ),
)


def role_id(company_id: str, role_key: str) -> str:
    return f"{company_id}__{role_key}"


def role_permission_id(company_id: str, role_key: str, permission_key: str) -> str:
    return f"{role_id(company_id, role_key)}__{permission_key}"


async def _ensure_company(
    repository: CompanyRepository,
    payload: CompanyCreate,
) -> None:
    scope = CompanyScope(company_id=payload.id)
    existing = await repository.get(scope)
    if existing is None:
        await repository.create(payload, SEED_ACTOR_UID)
        return
    if (
        existing.name != payload.name
        or existing.status != payload.status
        or existing.subscription_tier != payload.subscription_tier
    ):
        await repository.update(
            scope,
            CompanyUpdate(
                name=payload.name,
                status=payload.status,
                subscription_tier=payload.subscription_tier,
            ),
            SEED_ACTOR_UID,
        )


async def _ensure_permission(
    repository: PermissionRepository,
    *,
    key: str,
    group: str,
    description: str,
) -> None:
    existing = await repository.get(key)
    if existing is None:
        await repository.create(
            PermissionCreate(id=key, key=key, group=group, description=description)
        )
        return
    if existing.key != key:
        raise ValueError(f"Permission {key} has an incompatible stored key")
    if existing.group != group or existing.description != description:
        await repository.update(
            key,
            PermissionUpdate(group=group, description=description),
        )


async def _ensure_role(
    repository: RoleRepository,
    scope: CompanyScope,
    template: SystemRoleTemplate,
) -> str:
    document_id = role_id(scope.company_id, template.key)
    existing = await repository.get(scope, document_id)
    if existing is None:
        await repository.create(
            scope,
            RoleCreate(
                id=document_id,
                key=template.key,
                name=template.name,
                description=template.description,
                is_system=True,
            ),
            SEED_ACTOR_UID,
        )
    else:
        if existing.key != template.key:
            raise ValueError(f"Role {document_id} has an incompatible stored key")
        if (
            existing.name != template.name
            or existing.description != template.description
            or not existing.is_system
        ):
            await repository.update(
                scope,
                document_id,
                RoleUpdate(
                    name=template.name,
                    description=template.description,
                    is_system=True,
                ),
                SEED_ACTOR_UID,
            )
    return document_id


async def _ensure_role_permissions(
    repository: RolePermissionRepository,
    scope: CompanyScope,
    template: SystemRoleTemplate,
    existing_mappings: list[RolePermission],
) -> None:
    document_role_id = role_id(scope.company_id, template.key)
    expected_ids = {
        role_permission_id(scope.company_id, template.key, permission_key)
        for permission_key in template.permission_keys
    }
    existing_by_id = {
        mapping.id: mapping
        for mapping in existing_mappings
        if mapping.role_id == document_role_id
    }
    creations = []
    for permission_key in template.permission_keys:
        mapping_id = role_permission_id(scope.company_id, template.key, permission_key)
        existing = existing_by_id.get(mapping_id)
        if existing is None:
            creations.append(
                repository.create(
                    scope,
                    RolePermissionCreate(
                        id=mapping_id,
                        role_id=document_role_id,
                        permission_id=permission_key,
                    ),
                    SEED_ACTOR_UID,
                )
            )
        elif (
            existing.role_id != document_role_id
            or existing.permission_id != permission_key
        ):
            raise ValueError(f"Role-permission mapping {mapping_id} is incompatible")
    if creations:
        await asyncio.gather(*creations)

    deletions = [
        repository.delete(scope, existing.id, SEED_ACTOR_UID)
        for existing in existing_by_id.values()
        if existing.id not in expected_ids
    ]
    if deletions:
        await asyncio.gather(*deletions)


async def _ensure_user(
    repository: UserRepository,
    scope: CompanyScope,
    *,
    user_id: str,
    email: str,
    display_name: str,
    user_role_id: str,
) -> None:
    existing = await repository.get(scope, user_id)
    if existing is None:
        existing = await repository.find_by_email(scope, email)
    if existing is None:
        await repository.create(
            scope,
            UserCreate(
                id=user_id,
                email=email,
                display_name=display_name,
                role_id=user_role_id,
                status="active",
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.email != email
        or existing.display_name != display_name
        or existing.role_id != user_role_id
        or existing.status != "active"
    ):
        await repository.update(
            scope,
            existing.id,
            UserUpdate(
                email=email,
                display_name=display_name,
                role_id=user_role_id,
                status="active",
            ),
            SEED_ACTOR_UID,
        )


async def run_seed(
    client: AsyncClient | None = None,
    *,
    with_auth_users: bool = False,
    demo_password: str | None = None,
    auth_admin: AuthAdmin | None = None,
) -> SeedCounts:
    firestore_client = client or get_firestore_client()
    audit_logs = AuditLogRepository(firestore_client)
    audit = AuditService(audit_logs)
    companies = CompanyRepository(firestore_client, audit)
    permissions = PermissionRepository(firestore_client)
    roles = RoleRepository(firestore_client, audit)
    role_permissions = RolePermissionRepository(firestore_client, audit)
    users = UserRepository(firestore_client, audit)

    await asyncio.gather(
        _ensure_company(
            companies,
            CompanyCreate(
                id=ACME_COMPANY_ID,
                name="Acme Energy",
                status="active",
                subscription_tier="demo",
            ),
        ),
        _ensure_company(
            companies,
            CompanyCreate(
                id=SECOND_COMPANY_ID,
                name="Beta Utilities",
                status="active",
                subscription_tier="demo",
            ),
        ),
    )

    await asyncio.gather(
        *(
            _ensure_permission(
                permissions,
                key=permission.key,
                group=permission.group,
                description=permission.description,
            )
            for permission in PERMISSION_CATALOG
        )
    )

    acme_scope = CompanyScope(company_id=ACME_COMPANY_ID)
    role_entries = tuple(SYSTEM_ROLE_TEMPLATES.items())
    acme_role_ids = await asyncio.gather(
        *(_ensure_role(roles, acme_scope, template) for _, template in role_entries)
    )
    acme_existing_mappings = await role_permissions.list(acme_scope)
    await asyncio.gather(
        *(
            _ensure_role_permissions(
                role_permissions,
                acme_scope,
                template,
                acme_existing_mappings,
            )
            for _, template in role_entries
        )
    )
    await asyncio.gather(
        *(
            _ensure_user(
                users,
                acme_scope,
                user_id=f"demo-acme-{role_key}",
                email=f"{role_key}@acme.example.invalid",
                display_name=f"Acme {template.name}",
                user_role_id=document_role_id,
            )
            for (role_key, template), document_role_id in zip(
                role_entries,
                acme_role_ids,
                strict=True,
            )
        )
    )

    second_scope = CompanyScope(company_id=SECOND_COMPANY_ID)
    second_template = SYSTEM_ROLE_TEMPLATES["company_admin"]
    second_role_id = await _ensure_role(roles, second_scope, second_template)
    await _ensure_role_permissions(
        role_permissions,
        second_scope,
        second_template,
        await role_permissions.list(second_scope),
    )
    await _ensure_user(
        users,
        second_scope,
        user_id="demo-beta-company-admin",
        email="company_admin@beta.example.invalid",
        display_name="Beta Company Admin",
        user_role_id=second_role_id,
    )

    if with_auth_users:
        password = demo_password or settings.seed_demo_password
        if not password:
            raise ValueError("SEED_DEMO_PASSWORD is required with --with-auth-users")
        provisioner = UserProvisioningService(
            admin=auth_admin,
            users=users,
            roles=roles,
            audit=audit,
        )
        for demo_user in DEMO_USERS:
            await provisioner.provision_seed_user(
                placeholder_uid=demo_user.placeholder_uid,
                email=demo_user.email,
                company_id=demo_user.company_id,
                role_id=role_id(demo_user.company_id, demo_user.role_key),
                display_name=demo_user.display_name,
                password=password,
                actor_uid=SEED_ACTOR_UID,
            )

    acme_roles, second_roles, acme_mappings, second_mappings, acme_users, second_users = (
        await asyncio.gather(
            roles.list(acme_scope),
            roles.list(second_scope),
            role_permissions.list(acme_scope),
            role_permissions.list(second_scope),
            users.list(acme_scope),
            users.list(second_scope),
        )
    )
    acme_audits, second_audits = await asyncio.gather(
        audit_logs.list(acme_scope),
        audit_logs.list(second_scope),
    )
    return SeedCounts(
        companies=sum(
            company is not None
            for company in (
                await companies.get(acme_scope),
                await companies.get(second_scope),
            )
        ),
        permissions=len(await permissions.list()),
        roles=len(acme_roles) + len(second_roles),
        role_permissions=len(acme_mappings) + len(second_mappings),
        users=len(acme_users) + len(second_users),
        audit_logs=len(acme_audits) + len(second_audits),
    )


async def main() -> None:
    parser = argparse.ArgumentParser(description="Seed the FEV data foundation")
    parser.add_argument(
        "--with-auth-users",
        action="store_true",
        help="Create/reconcile real Firebase Auth demo users and custom claims",
    )
    arguments = parser.parse_args()
    counts = await run_seed(with_auth_users=arguments.with_auth_users)
    print(counts.model_dump_json(indent=2))


if __name__ == "__main__":
    asyncio.run(main())
