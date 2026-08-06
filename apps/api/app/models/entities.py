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


class AssetMedia(StrictModel):
    id: str
    path: str
    filename: str
    kind: Literal["photo", "document", "manual"]
    content_type: str
    size: int
    uploaded_by: str
    uploaded_at: datetime


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
    photos: list["AssetMedia"] = Field(default_factory=list)
    documents: list["AssetMedia"] = Field(default_factory=list)
    manuals: list["AssetMedia"] = Field(default_factory=list)
    model_3d_url: str | None = None
    deleted_at: datetime | None = None


class AssetCreate(StrictModel):
    id: str
    facility_id: str
    area_id: str | None = None
    parent_asset_id: str | None = None
    asset_tag: str
    qr_code_id: str
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




class ChecklistTemplateItem(StrictModel):
    id: str
    label: str = Field(min_length=1, max_length=200)
    item_type: Literal["boolean", "numeric", "text", "select"]
    required: bool = True
    options: list[str] | None = None
    help_text: str | None = Field(default=None, max_length=500)


class ChecklistTemplate(TenantDoc):
    id: str
    name: str
    category: str
    description: str | None = None
    items: list["ChecklistTemplateItem"] = Field(default_factory=list)
    version: int = 1
    deleted_at: datetime | None = None


class ChecklistTemplateItemInput(StrictModel):
    id: str | None = None
    label: str = Field(min_length=1, max_length=200)
    item_type: Literal["boolean", "numeric", "text", "select"]
    required: bool = True
    options: list[str] | None = None
    help_text: str | None = Field(default=None, max_length=500)


class ChecklistTemplateCreate(StrictModel):
    id: str
    name: str
    category: str
    description: str | None = None
    items: list[ChecklistTemplateItem] = Field(default_factory=list)


class ChecklistTemplateUpdate(StrictModel):
    name: str | None = None
    category: str | None = None
    description: str | None = None
    items: list[ChecklistTemplateItem] | None = None


class ChecklistResponse(StrictModel):
    item_id: str
    value: str | float | bool | None = None
    note: str | None = Field(default=None, max_length=1000)
    answered_at: datetime | None = None
    answered_by: str | None = None


class InspectionMedia(StrictModel):
    id: str
    local_id: str
    path: str
    kind: Literal["photo", "video"]
    filename: str
    content_type: str
    size: int
    gps_lat: float | None = None
    gps_lng: float | None = None
    captured_at: datetime
    checklist_item_id: str | None = None
    before_after_tag: Literal["before", "after"] | None = None
    uploaded_by: str
    uploaded_at: datetime


class AnnotationPoint(StrictModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)


class Annotation(StrictModel):
    """A human- or AI-marked damage region drawn over an inspection photo
    (spec 7.2/7.10). Vector-only, normalized (0-1) coordinates so it renders
    correctly at any display size -- never bakes pixels into the image.
    `source`/`confidence` exist now so Phase 7.10's AI-detected regions can
    render on this same overlay model without a schema change."""

    id: str
    media_local_id: str
    shape: Literal["freehand", "rectangle", "circle", "arrow", "point"]
    points: list[AnnotationPoint] = Field(min_length=1)
    color: str = Field(min_length=1, max_length=20)
    damage_type: Literal[
        "corrosion",
        "rust",
        "crack",
        "surface_damage",
        "paint_deterioration",
        "missing_bolt",
        "broken_component",
        "leak",
        "wear",
        "other",
    ] | None = None
    note: str | None = Field(default=None, max_length=1000)
    source: Literal["manual", "ai"] = "manual"
    confidence: float | None = Field(default=None, ge=0, le=1)
    created_by: str
    created_at: datetime


class VoiceNote(StrictModel):
    """A recorded audio note attached to an inspection, optionally linked to
    a checklist item (spec 7.2 "voice recording", Phase 7.6). Bytes upload
    directly to Storage via the same 7.4 media queue/worker; this only
    stores the reference, mirroring `InspectionMedia`."""

    id: str
    local_id: str
    path: str
    filename: str
    content_type: str
    size: int
    duration_ms: int
    checklist_item_id: str | None = None
    uploaded_by: str
    uploaded_at: datetime


class Inspection(TenantDoc):
    id: str
    asset_id: str
    facility_id: str
    area_id: str | None = None
    inspector_id: str
    status: Literal["draft", "in_progress", "completed", "cancelled"] = "draft"
    inspection_type: Literal["routine", "scheduled", "ad_hoc"]
    title: str | None = None
    notes: str | None = None
    checklist_template_id: str | None = None
    checklist_template_version: int | None = None
    checklist_items_snapshot: list[ChecklistTemplateItem] = Field(default_factory=list)
    checklist_responses: list[ChecklistResponse] = Field(default_factory=list)
    started_at: datetime | None = None
    completed_at: datetime | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    client_created_at: datetime
    device_id: str | None = None
    origin: str | None = None
    revision: int = 1
    deleted_at: datetime | None = None
    media: list[InspectionMedia] = Field(default_factory=list)
    annotations: list[Annotation] = Field(default_factory=list)
    voice_notes: list["VoiceNote"] = Field(default_factory=list)
    # Reserved, always-empty until their own phases give these real shapes.
    readings: dict[str, Any] = Field(default_factory=dict)
    ar_measurements: list[dict[str, Any]] = Field(default_factory=list)
    ai_analysis: dict[str, Any] | None = None
    signature: dict[str, Any] | None = None


class InspectionCreate(StrictModel):
    id: str
    asset_id: str
    facility_id: str
    area_id: str | None = None
    inspector_id: str
    status: Literal["draft", "in_progress", "completed", "cancelled"] = "draft"
    inspection_type: Literal["routine", "scheduled", "ad_hoc"]
    title: str | None = None
    notes: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    client_created_at: datetime
    device_id: str | None = None
    origin: str | None = None


class InspectionUpdate(StrictModel):
    title: str | None = None
    notes: str | None = None
    inspection_type: Literal["routine", "scheduled", "ad_hoc"] | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    checklist_responses: list[ChecklistResponse] | None = None


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
    checklist_templates: int
    inspections: int


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
