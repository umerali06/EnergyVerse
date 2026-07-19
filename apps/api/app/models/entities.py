from typing import Any

from pydantic import Field

from app.models.base import AppendOnlyDoc, GlobalDoc, StrictModel, TenantDoc


class Company(GlobalDoc):
    id: str
    name: str
    status: str
    subscription_tier: str
    created_by: str | None = None


class CompanyCreate(StrictModel):
    id: str
    name: str
    status: str
    subscription_tier: str


class CompanyUpdate(StrictModel):
    name: str | None = None
    status: str | None = None
    subscription_tier: str | None = None


class User(TenantDoc):
    id: str
    email: str
    display_name: str
    role_id: str
    status: str


class UserCreate(StrictModel):
    id: str
    email: str
    display_name: str
    role_id: str
    status: str


class UserUpdate(StrictModel):
    email: str | None = None
    display_name: str | None = None
    role_id: str | None = None
    status: str | None = None


class Role(TenantDoc):
    id: str
    key: str
    name: str
    description: str
    is_system: bool


class RoleCreate(StrictModel):
    id: str
    key: str
    name: str
    description: str
    is_system: bool


class RoleUpdate(StrictModel):
    name: str | None = None
    description: str | None = None
    is_system: bool | None = None


class Permission(GlobalDoc):
    id: str
    key: str
    group: str
    description: str


class PermissionCreate(StrictModel):
    id: str
    key: str
    group: str
    description: str


class PermissionUpdate(StrictModel):
    group: str | None = None
    description: str | None = None


class RolePermission(TenantDoc):
    id: str
    role_id: str
    permission_id: str


class RolePermissionCreate(StrictModel):
    id: str
    role_id: str
    permission_id: str


class RolePermissionUpdate(StrictModel):
    permission_id: str | None = None


class AuditLog(AppendOnlyDoc):
    id: str
    company_id: str
    action: str
    target_type: str
    target_id: str
    metadata: dict[str, Any] = Field(default_factory=dict)


class AuditEvent(StrictModel):
    company_id: str
    actor_uid: str
    action: str
    target_type: str
    target_id: str
    metadata: dict[str, Any] = Field(default_factory=dict)


class SeedCounts(StrictModel):
    companies: int
    permissions: int
    roles: int
    role_permissions: int
    users: int
    audit_logs: int


class CurrentUser(StrictModel):
    uid: str
    email: str
    email_verified: bool
    company_id: str
    company_name: str
    role_key: str
    permissions: frozenset[str]


class CompanyRegistrationRequest(StrictModel):
    company_name: str = Field(min_length=2, max_length=120)
    display_name: str = Field(min_length=2, max_length=120)
    email: str = Field(min_length=5, max_length=320)
    password: str = Field(min_length=8, max_length=128)


class CompanyRegistrationResponse(StrictModel):
    uid: str
    email: str
    email_verified: bool
    company_id: str
    role_key: str


def without_none(values: dict[str, object | None]) -> dict[str, object]:
    return {key: value for key, value in values.items() if value is not None}
