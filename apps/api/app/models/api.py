from datetime import date, datetime
from typing import Any, Literal
from uuid import UUID

from pydantic import BaseModel, Field


class ErrorEnvelope(BaseModel):
    """Stable error contract returned by every API failure."""

    error: str = Field(description="Stable machine-readable error code")
    message: str = Field(description="Human-readable error summary")
    details: dict[str, Any] | None = Field(
        default=None,
        description="Optional structured JSON object",
    )
    request_id: UUID = Field(description="Request correlation identifier")


class ServiceResponse(BaseModel):
    service: Literal["fev-api"]
    status: Literal["ok"]


class DemoGateResponse(BaseModel):
    ok: Literal[True]


class DashboardSummary(BaseModel):
    company_name: str
    subscription_tier: str
    company_created_at: datetime
    users_total: int
    users_active: int
    roles_total: int
    audit_events: int
    window_days: int


class DashboardActivityItem(BaseModel):
    id: str
    actor_uid: str
    actor_name: str | None = None
    action: str
    target_type: str
    target_id: str
    created_at: datetime


class DashboardActivityPage(BaseModel):
    items: list[DashboardActivityItem]
    next_cursor: str | None = None


class DashboardSeriesPoint(BaseModel):
    date: date
    count: int


class DashboardActivitySeries(BaseModel):
    window_days: int
    points: list[DashboardSeriesPoint]


class AssetCategoryCount(BaseModel):
    category: str
    count: int


class AssetFacilityCount(BaseModel):
    facility_id: str
    facility_name: str
    count: int


class AssetDashboardSummary(BaseModel):
    total: int
    healthy: int
    warning: int
    critical: int
    by_category: list[AssetCategoryCount]
    by_facility: list[AssetFacilityCount]


class AuditLogEntry(BaseModel):
    id: str
    actor_uid: str
    actor_name: str | None = None
    actor_role: str | None = None
    action: str
    target_type: str
    target_id: str
    metadata: dict[str, Any] = Field(default_factory=dict)
    created_at: datetime


class AuditLogPage(BaseModel):
    items: list[AuditLogEntry]
    next_cursor: str | None = None
    truncated: bool = Field(
        description="True when the underlying date range held more events than the "
        "server-side read cap; narrow the range for a complete view"
    )


class AuditLogFacets(BaseModel):
    actions: list[str]
    target_types: list[str]


class UserListItem(BaseModel):
    id: str
    email: str
    display_name: str
    role_id: str
    role_key: str
    role_name: str
    status: str
    created_at: datetime
    updated_at: datetime


class UserListPage(BaseModel):
    items: list[UserListItem]
    next_cursor: str | None = None


class UserDetail(UserListItem):
    permissions: list[str]


class InviteUserRequest(BaseModel):
    email: str = Field(min_length=5, max_length=320)
    display_name: str = Field(min_length=2, max_length=120)
    role_id: str = Field(min_length=1)


class UpdateUserRequest(BaseModel):
    display_name: str | None = Field(default=None, min_length=2, max_length=120)
    role_id: str | None = Field(default=None, min_length=1)


class UpdateUserStatusRequest(BaseModel):
    status: Literal["active", "inactive"]


class RoleSummary(BaseModel):
    id: str
    key: str
    name: str
    description: str
    is_system: bool
    permission_count: int
    assigned_user_count: int


class RoleList(BaseModel):
    items: list[RoleSummary]


class RoleDetail(BaseModel):
    id: str
    key: str
    name: str
    description: str
    is_system: bool
    permission_keys: list[str]
    assigned_user_count: int


class CreateRoleRequest(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    description: str = Field(default="", max_length=500)
    permission_keys: list[str] = Field(default_factory=list)
    clone_from_role_id: str | None = Field(default=None, min_length=1)


class UpdateRoleRequest(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=120)
    description: str | None = Field(default=None, max_length=500)
    permission_keys: list[str] | None = None


class PermissionCatalogItem(BaseModel):
    key: str
    group: str
    description: str


class PermissionCatalogGroup(BaseModel):
    group: str
    items: list[PermissionCatalogItem]


class PermissionCatalog(BaseModel):
    groups: list[PermissionCatalogGroup]


class RoleDeleted(BaseModel):
    id: str
    deleted: bool = True


class CompanyProfile(BaseModel):
    id: str
    name: str
    industry: str | None = None
    timezone: str
    locale: str
    contact_email: str | None = None
    contact_phone: str | None = None
    subscription_tier: str
    logo_url: str | None = None
    created_at: datetime
    users_total: int
    roles_total: int


class UpdateCompanyRequest(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=120)
    industry: str | None = Field(default=None, min_length=1, max_length=60)
    timezone: str | None = Field(default=None, min_length=1, max_length=60)
    locale: str | None = Field(default=None, min_length=2, max_length=35)
    contact_email: str | None = Field(default=None, min_length=5, max_length=320)
    contact_phone: str | None = Field(default=None, min_length=3, max_length=40)


SUBSCRIPTION_TIERS = ("demo", "starter", "professional", "enterprise")


class PlatformCompanySummary(BaseModel):
    id: str
    name: str
    status: str
    subscription_tier: str
    users_total: int
    created_at: datetime


class PlatformCompanyPage(BaseModel):
    items: list[PlatformCompanySummary]
    next_cursor: str | None = None


class PlatformCompanyDetail(PlatformCompanySummary):
    industry: str | None = None
    contact_email: str | None = None
    roles_total: int


class UpdateCompanyStatusRequest(BaseModel):
    status: Literal["active", "suspended"]


class UpdatePlatformCompanyRequest(BaseModel):
    subscription_tier: Literal["demo", "starter", "professional", "enterprise"]


class PlatformStats(BaseModel):
    total_companies: int
    total_users: int
    active_tenants: int
    recent_signups: int
    window_days: int


class FacilityDetail(BaseModel):
    id: str
    name: str
    sector: str | None = None
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = None
    timezone: str
    status: Literal["active", "inactive"]
    created_at: datetime
    updated_at: datetime


class FacilityListPage(BaseModel):
    items: list[FacilityDetail]
    next_cursor: str | None = None


class CreateFacilityRequest(BaseModel):
    name: str = Field(min_length=2, max_length=200)
    sector: str | None = Field(default=None, max_length=120)
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = Field(default=None, max_length=300)
    timezone: str | None = Field(default=None, min_length=1, max_length=60)
    status: Literal["active", "inactive"] = "active"


class UpdateFacilityRequest(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=200)
    sector: str | None = Field(default=None, max_length=120)
    gps_lat: float | None = None
    gps_lng: float | None = None
    address: str | None = Field(default=None, max_length=300)
    timezone: str | None = Field(default=None, min_length=1, max_length=60)
    status: Literal["active", "inactive"] | None = None


class FacilityDeleted(BaseModel):
    id: str
    deleted: bool = True


class AreaDetail(BaseModel):
    id: str
    facility_id: str
    name: str
    code: str | None = None
    description: str | None = None
    created_at: datetime
    updated_at: datetime


class AreaListPage(BaseModel):
    items: list[AreaDetail]
    next_cursor: str | None = None


class CreateAreaRequest(BaseModel):
    facility_id: str = Field(min_length=1)
    name: str = Field(min_length=2, max_length=200)
    code: str | None = Field(default=None, max_length=60)
    description: str | None = Field(default=None, max_length=500)


class UpdateAreaRequest(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=200)
    code: str | None = Field(default=None, max_length=60)
    description: str | None = Field(default=None, max_length=500)


class AreaDeleted(BaseModel):
    id: str
    deleted: bool = True


class AssetListItem(BaseModel):
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
    gps_lat: float | None = None
    gps_lng: float | None = None
    current_status: Literal["Healthy", "Warning", "Critical"]
    created_at: datetime
    updated_at: datetime


class AssetListPage(BaseModel):
    items: list[AssetListItem]
    next_cursor: str | None = None


class AssetMediaResponse(BaseModel):
    id: str
    url: str
    filename: str
    kind: Literal["photo", "document", "manual"]
    content_type: str
    size: int
    uploaded_by: str
    uploaded_at: datetime


class AssetDetail(AssetListItem):
    description: str | None = None
    photos: list[AssetMediaResponse] = Field(default_factory=list)
    documents: list[AssetMediaResponse] = Field(default_factory=list)
    manuals: list[AssetMediaResponse] = Field(default_factory=list)
    model_3d_url: str | None = None


class CreateAssetRequest(BaseModel):
    facility_id: str = Field(min_length=1)
    area_id: str | None = Field(default=None, min_length=1)
    parent_asset_id: str | None = Field(default=None, min_length=1)
    asset_tag: str = Field(min_length=1, max_length=120)
    name: str = Field(min_length=2, max_length=200)
    category: str = Field(min_length=1, max_length=60)
    category_other: str | None = Field(default=None, max_length=120)
    manufacturer: str | None = Field(default=None, max_length=120)
    model: str | None = Field(default=None, max_length=120)
    serial_number: str | None = Field(default=None, max_length=120)
    installation_date: date | None = None
    description: str | None = Field(default=None, max_length=2000)
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    current_status: Literal["Healthy", "Warning", "Critical"] = "Healthy"


class UpdateAssetRequest(BaseModel):
    facility_id: str | None = Field(default=None, min_length=1)
    area_id: str | None = Field(default=None, min_length=1)
    parent_asset_id: str | None = Field(default=None, min_length=1)
    asset_tag: str | None = Field(default=None, min_length=1, max_length=120)
    name: str | None = Field(default=None, min_length=2, max_length=200)
    category: str | None = Field(default=None, min_length=1, max_length=60)
    category_other: str | None = Field(default=None, max_length=120)
    manufacturer: str | None = Field(default=None, max_length=120)
    model: str | None = Field(default=None, max_length=120)
    serial_number: str | None = Field(default=None, max_length=120)
    installation_date: date | None = None
    description: str | None = Field(default=None, max_length=2000)
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    current_status: Literal["Healthy", "Warning", "Critical"] | None = None


class AssetDeleted(BaseModel):
    id: str
    deleted: bool = True


class AssetHistoryEvent(BaseModel):
    """Reserved shape for inspection/work-order timeline entries (later phases)."""

    id: str
    type: str
    occurred_at: datetime
    summary: str


class AssetHistoryPage(BaseModel):
    items: list[AssetHistoryEvent] = Field(default_factory=list)
    next_cursor: str | None = None


class ChecklistTemplateItem(BaseModel):
    id: str
    label: str
    item_type: Literal["boolean", "numeric", "text", "select"]
    required: bool
    options: list[str] | None = None
    help_text: str | None = None


class ChecklistResponse(BaseModel):
    item_id: str
    value: str | float | bool | None = None
    note: str | None = None
    answered_at: datetime | None = None
    answered_by: str | None = None


class InspectionListItem(BaseModel):
    id: str
    asset_id: str
    facility_id: str
    area_id: str | None = None
    inspector_id: str
    status: Literal["draft", "in_progress", "completed", "cancelled"]
    inspection_type: Literal["routine", "scheduled", "ad_hoc"]
    title: str | None = None
    checklist_template_id: str | None = None
    started_at: datetime | None = None
    completed_at: datetime | None = None
    revision: int
    created_at: datetime
    updated_at: datetime


class InspectionListPage(BaseModel):
    items: list[InspectionListItem]
    next_cursor: str | None = None


class InspectionDetail(InspectionListItem):
    notes: str | None = None
    checklist_template_version: int | None = None
    checklist_items_snapshot: list[ChecklistTemplateItem] = Field(default_factory=list)
    checklist_responses: list[ChecklistResponse] = Field(default_factory=list)
    gps_lat: float | None = None
    gps_lng: float | None = None
    client_created_at: datetime
    device_id: str | None = None
    origin: str | None = None
    media: list[dict[str, Any]] = Field(default_factory=list)
    annotations: list[dict[str, Any]] = Field(default_factory=list)
    voice_notes: list[dict[str, Any]] = Field(default_factory=list)
    readings: dict[str, Any] = Field(default_factory=dict)
    ar_measurements: list[dict[str, Any]] = Field(default_factory=list)
    ai_analysis: dict[str, Any] | None = None
    signature: dict[str, Any] | None = None


class CreateInspectionRequest(BaseModel):
    id: str = Field(min_length=1)
    asset_id: str = Field(min_length=1)
    inspection_type: Literal["routine", "scheduled", "ad_hoc"]
    title: str | None = Field(default=None, max_length=200)
    notes: str | None = Field(default=None, max_length=2000)
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    client_created_at: datetime
    device_id: str | None = Field(default=None, max_length=200)
    origin: str | None = Field(default=None, max_length=40)


class UpdateInspectionRequest(BaseModel):
    title: str | None = Field(default=None, max_length=200)
    notes: str | None = Field(default=None, max_length=2000)
    inspection_type: Literal["routine", "scheduled", "ad_hoc"] | None = None
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    checklist_responses: list[ChecklistResponse] | None = None
    expected_revision: int | None = None


class AssignChecklistTemplateRequest(BaseModel):
    checklist_template_id: str = Field(min_length=1)


class InspectionDeleted(BaseModel):
    id: str
    deleted: bool = True


class ChecklistTemplateItemInput(BaseModel):
    id: str | None = None
    label: str = Field(min_length=1, max_length=200)
    item_type: Literal["boolean", "numeric", "text", "select"]
    required: bool = True
    options: list[str] | None = None
    help_text: str | None = Field(default=None, max_length=500)


class ChecklistTemplateListItem(BaseModel):
    id: str
    name: str
    category: str
    version: int
    created_at: datetime
    updated_at: datetime


class ChecklistTemplateListPage(BaseModel):
    items: list[ChecklistTemplateListItem]
    next_cursor: str | None = None


class ChecklistTemplateDetail(ChecklistTemplateListItem):
    description: str | None = None
    items: list[ChecklistTemplateItem] = Field(default_factory=list)


class CreateChecklistTemplateRequest(BaseModel):
    name: str = Field(min_length=2, max_length=200)
    category: str = Field(min_length=1, max_length=60)
    description: str | None = Field(default=None, max_length=2000)
    items: list[ChecklistTemplateItemInput] = Field(default_factory=list)


class UpdateChecklistTemplateRequest(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=200)
    category: str | None = Field(default=None, min_length=1, max_length=60)
    description: str | None = Field(default=None, max_length=2000)
    items: list[ChecklistTemplateItemInput] | None = None


class ChecklistTemplateDeleted(BaseModel):
    id: str
    deleted: bool = True


class AssetQrLabel(BaseModel):
    """Printable label payload -- the frontend renders the QR image itself
    (client-side, from `url`) rather than the backend generating pixels."""

    qr_code_id: str | None = None
    url: str | None = None
    asset_tag: str
    name: str


class QrScanResult(BaseModel):
    """The scan surface: the full asset plus reserved, honestly-empty counts
    for sections later phases (7/11) will populate."""

    asset: AssetDetail
    inspections_total: int = 0
    maintenance_total: int = 0
    work_orders_total: int = 0


def error_responses(*status_codes: int) -> dict[int | str, dict[str, Any]]:
    descriptions = {
        201: "Resource created",
        401: "Authentication failed",
        403: "Authenticated caller is not authorized",
        404: "Resource was not found",
        409: "Request conflicts with current state",
        413: "Request payload exceeds the allowed size",
        422: "Request validation failed",
        500: "Unexpected server error",
    }
    return {
        code: {"model": ErrorEnvelope, "description": descriptions[code]} for code in status_codes
    }
