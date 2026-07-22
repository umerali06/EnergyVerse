from datetime import date, datetime
from typing import Any, Literal

from pydantic import Field

from app.models.base import AppendOnlyDoc, GlobalDoc, StrictModel, TenantDoc


class Company(GlobalDoc):
    id: str
    name: str
    status: str
    subscription_tier: str
    industry: str | None = None
    timezone: str = "UTC"
    locale: str = "en-US"
    contact_email: str | None = None
    contact_phone: str | None = None
    logo_path: str | None = None
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
    industry: str | None = None
    timezone: str | None = None
    locale: str | None = None
    contact_email: str | None = None
    contact_phone: str | None = None
    logo_path: str | None = None


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


class Facility(TenantDoc):
    id: str
    name: str
    sector: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = None
    timezone: str = "UTC"
    status: Literal["active", "inactive"] = "active"
    deleted_at: datetime | None = None


class FacilityCreate(StrictModel):
    id: str
    name: str
    sector: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = None
    timezone: str = "UTC"
    status: Literal["active", "inactive"] = "active"


class FacilityUpdate(StrictModel):
    name: str | None = None
    sector: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = None
    timezone: str | None = None
    status: Literal["active", "inactive"] | None = None


class Area(TenantDoc):
    id: str
    facility_id: str
    name: str
    code: str | None = None
    description: str | None = None
    deleted_at: datetime | None = None


class AreaCreate(StrictModel):
    id: str
    facility_id: str
    name: str
    code: str | None = None
    description: str | None = None


class AreaUpdate(StrictModel):
    name: str | None = None
    code: str | None = None
    description: str | None = None


class Asset(TenantDoc):
    id: str
    facility_id: str
    area_id: str | None = None
    parent_asset_id: str | None = None
    asset_tag: str
    qr_code_id: str | None = None
    name: str
    category: str
    category_other: str | None = None
    manufacturer: str | None = None
    model: str | None = None
    serial_number: str | None = None
    installation_date: date | None = None
    description: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    current_status: Literal["Healthy", "Warning", "Critical"] = "Healthy"
    photos: list[str] = Field(default_factory=list)
    documents: list[str] = Field(default_factory=list)
    manuals: list[str] = Field(default_factory=list)
    model_3d_url: str | None = None
    deleted_at: datetime | None = None


class AssetCreate(StrictModel):
    id: str
    facility_id: str
    area_id: str | None = None
    parent_asset_id: str | None = None
    asset_tag: str
    name: str
    category: str
    category_other: str | None = None
    manufacturer: str | None = None
    model: str | None = None
    serial_number: str | None = None
    installation_date: date | None = None
    description: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    current_status: Literal["Healthy", "Warning", "Critical"] = "Healthy"


class AssetUpdate(StrictModel):
    facility_id: str | None = None
    area_id: str | None = None
    parent_asset_id: str | None = None
    asset_tag: str | None = None
    name: str | None = None
    category: str | None = None
    category_other: str | None = None
    manufacturer: str | None = None
    model: str | None = None
    serial_number: str | None = None
    installation_date: date | None = None
    description: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    current_status: Literal["Healthy", "Warning", "Critical"] | None = None


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
    facilities: int
    areas: int
    assets: int


class CurrentUser(StrictModel):
    uid: str
    email: str
    email_verified: bool
    company_id: str
    company_name: str
    company_timezone: str = "UTC"
    company_locale: str = "en-US"
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
