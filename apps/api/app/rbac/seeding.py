import asyncio

from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.models.base import CompanyScope
from app.models.entities import RoleCreate, RolePermission, RolePermissionCreate, RoleUpdate
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES, SystemRoleTemplate


def system_role_id(company_id: str, role_key: str) -> str:
    return f"{company_id}__{role_key}"


def system_role_permission_id(company_id: str, role_key: str, permission_key: str) -> str:
    return f"{system_role_id(company_id, role_key)}__{permission_key}"


async def _ensure_role(
    repository: RoleRepository,
    scope: CompanyScope,
    template: SystemRoleTemplate,
    actor_uid: str,
) -> str:
    document_id = system_role_id(scope.company_id, template.key)
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
            actor_uid,
        )
    elif existing.key != template.key:
        raise ValueError(f"Role {document_id} has an incompatible stored key")
    elif (
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
            actor_uid,
        )
    return document_id


async def _ensure_role_permissions(
    repository: RolePermissionRepository,
    scope: CompanyScope,
    template: SystemRoleTemplate,
    existing_mappings: list[RolePermission],
    actor_uid: str,
) -> None:
    role_id = system_role_id(scope.company_id, template.key)
    expected_ids = {
        system_role_permission_id(scope.company_id, template.key, key)
        for key in template.permission_keys
    }
    existing_by_id = {
        mapping.id: mapping for mapping in existing_mappings if mapping.role_id == role_id
    }
    creations = []
    for permission_key in template.permission_keys:
        mapping_id = system_role_permission_id(scope.company_id, template.key, permission_key)
        existing = existing_by_id.get(mapping_id)
        if existing is None:
            creations.append(
                repository.create(
                    scope,
                    RolePermissionCreate(
                        id=mapping_id,
                        role_id=role_id,
                        permission_id=permission_key,
                    ),
                    actor_uid,
                )
            )
        elif existing.permission_id != permission_key:
            raise ValueError(f"Role-permission mapping {mapping_id} is incompatible")
    if creations:
        await asyncio.gather(*creations)
    deletions = [
        repository.delete(scope, mapping.id, actor_uid)
        for mapping in existing_by_id.values()
        if mapping.id not in expected_ids
    ]
    if deletions:
        await asyncio.gather(*deletions)


async def seed_system_roles(
    scope: CompanyScope,
    roles: RoleRepository,
    role_permissions: RolePermissionRepository,
    *,
    actor_uid: str,
) -> dict[str, str]:
    """Idempotently install the seven locked RBAC templates for one tenant."""
    entries = tuple(SYSTEM_ROLE_TEMPLATES.items())
    role_ids = await asyncio.gather(
        *(_ensure_role(roles, scope, template, actor_uid) for _, template in entries)
    )
    existing = await role_permissions.list(scope)
    await asyncio.gather(
        *(
            _ensure_role_permissions(
                role_permissions,
                scope,
                template,
                existing,
                actor_uid,
            )
            for _, template in entries
        )
    )
    return {key: role_id for (key, _), role_id in zip(entries, role_ids, strict=True)}
