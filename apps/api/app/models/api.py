from datetime import date, datetime
from typing import Any, Literal
from uuid import UUID

from pydantic import BaseModel, Field

from app.billing.plans import TIER_ORDER


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


#: The published tiers, cheapest first, derived so a repricing cannot leave a
#: stale copy behind -- this list used to read ("demo", "starter",
#: "professional", "enterprise"), none of which survived Phase 13, and a tier
#: missing from it makes any `minTier` gate hide everything from that tenant.
SUBSCRIPTION_TIERS = tuple(tier.value for tier in TIER_ORDER)


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


class CameraPreset(BaseModel):
    id: str = Field(min_length=1, max_length=100)
    name: str = Field(min_length=1, max_length=100)
    position: list[float] = Field(min_length=3, max_length=3)
    target: list[float] = Field(min_length=3, max_length=3)


class DigitalTwinHotspotResponse(BaseModel):
    id: str
    asset_id: str
    asset_name: str
    asset_tag: str
    category: str
    current_status: Literal["Healthy", "Warning", "Critical"]
    current_condition: Literal["Excellent", "Good", "Fair", "Poor", "Critical"] | None = None
    position: list[float] = Field(min_length=3, max_length=3)
    radius: float = Field(default=1.0, gt=0)
    label: str | None = None


class DigitalTwinSceneResponse(BaseModel):
    facility_id: str
    facility_name: str
    model_3d_url: str | None = None
    scene_type: str = "procedural_refinery"
    camera_presets: list[CameraPreset] = Field(default_factory=list)
    hotspots: list[DigitalTwinHotspotResponse] = Field(default_factory=list)
    updated_at: datetime


class UpdateDigitalTwinHotspotRequest(BaseModel):
    id: str = Field(min_length=1, max_length=100)
    asset_id: str = Field(min_length=1, max_length=100)
    position: list[float] = Field(min_length=3, max_length=3)
    radius: float = Field(default=1.0, gt=0)
    label: str | None = Field(default=None, max_length=200)


class UpdateDigitalTwinSceneRequest(BaseModel):
    model_3d_url: str | None = Field(default=None, max_length=1000)
    scene_type: str = Field(default="procedural_refinery", max_length=100)
    camera_presets: list[CameraPreset] | None = None
    hotspots: list[UpdateDigitalTwinHotspotRequest] | None = None


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
    # The five-state condition the requirements name, from the most recent
    # completed inspection. `current_status` is the 3-state rollup driving the
    # dashboard KPI; this is the term a human reads. Null until first inspected.
    current_condition: Literal["Excellent", "Good", "Fair", "Poor", "Critical"] | None = None
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


class InspectionMediaResponse(BaseModel):
    id: str
    local_id: str
    url: str
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


class VoiceNoteResponse(BaseModel):
    id: str
    local_id: str
    url: str
    filename: str
    content_type: str
    size: int
    duration_ms: int
    checklist_item_id: str | None = None
    uploaded_by: str
    uploaded_at: datetime


class AnnotationPointResponse(BaseModel):
    x: float
    y: float


class AnnotationResponse(BaseModel):
    id: str
    media_local_id: str
    shape: Literal["freehand", "rectangle", "circle", "arrow", "point"]
    points: list[AnnotationPointResponse]
    color: str
    damage_type: (
        Literal[
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
        ]
        | None
    ) = None
    note: str | None = None
    source: Literal["manual", "ai"] = "manual"
    confidence: float | None = None
    frame_timestamp_seconds: float | None = None
    created_by: str
    created_at: datetime


class ReadingsResponse(BaseModel):
    condition: Literal["Excellent", "Good", "Fair", "Poor", "Critical"]
    temperature_c: float | None = None
    pressure_bar: float | None = None
    noise_level_db: float | None = None
    vibration_observation: str | None = None
    leak_observed: bool | None = None
    operational_status: Literal["running", "stopped", "degraded"] | None = None
    comments: str | None = None
    recommendations: str | None = None
    priority_level: Literal["low", "medium", "high", "critical"] | None = None
    recorded_at: datetime | None = None
    recorded_by: str | None = None


class ReadingsInput(BaseModel):
    """Client-submitted readings (spec section 9, Phase 7.7). `recorded_at`/
    `recorded_by` are never accepted from the client -- the server always
    stamps them, mirroring how `answered_at`/`answered_by` are handled on
    `ChecklistResponse`."""

    condition: Literal["Excellent", "Good", "Fair", "Poor", "Critical"]
    temperature_c: float | None = Field(default=None, ge=-50, le=1000)
    pressure_bar: float | None = Field(default=None, ge=0, le=1000)
    noise_level_db: float | None = Field(default=None, ge=0, le=200)
    vibration_observation: str | None = Field(default=None, max_length=500)
    leak_observed: bool | None = None
    operational_status: Literal["running", "stopped", "degraded"] | None = None
    comments: str | None = Field(default=None, max_length=2000)
    recommendations: str | None = Field(default=None, max_length=2000)
    priority_level: Literal["low", "medium", "high", "critical"] | None = None


class SignaturePointResponse(BaseModel):
    x: float
    y: float


class SignatureStrokeResponse(BaseModel):
    points: list[SignaturePointResponse]


class SignatureResponse(BaseModel):
    strokes: list[SignatureStrokeResponse]
    signer_uid: str
    signer_name: str
    signer_role: str
    signed_at: datetime
    inspection_revision: int


class ArMeasurementResponse(BaseModel):
    id: str
    method: Literal["ar", "manual"]
    distance_meters: float
    label: str | None = None
    media_local_id: str | None = None
    points: list[AnnotationPointResponse] = Field(default_factory=list)
    note: str | None = None
    checklist_item_id: str | None = None
    created_by: str
    created_at: datetime


class AiAnalysisResponse(BaseModel):
    id: str
    media_local_id: str
    model: str
    summary: str
    recommendations: str | None = None
    risk_level: Literal["low", "medium", "high", "critical"] | None = None
    annotation_ids: list[str] = Field(default_factory=list)
    media_kind: Literal["photo", "video"] = "photo"
    frames_analyzed: int | None = None
    reviewed: bool = False
    reviewed_by: str | None = None
    reviewed_at: datetime | None = None
    created_by: str
    created_at: datetime


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
    media: list[InspectionMediaResponse] = Field(default_factory=list)
    annotations: list[AnnotationResponse] = Field(default_factory=list)
    voice_notes: list[VoiceNoteResponse] = Field(default_factory=list)
    readings: ReadingsResponse | None = None
    signature: SignatureResponse | None = None
    ar_measurements: list[ArMeasurementResponse] = Field(default_factory=list)
    ai_analysis: list[AiAnalysisResponse] = Field(default_factory=list)


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
    readings: ReadingsInput | None = None
    expected_revision: int | None = None


class AssignChecklistTemplateRequest(BaseModel):
    checklist_template_id: str = Field(min_length=1)
    expected_revision: int | None = None


class SignaturePointInput(BaseModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)


class SignatureStrokeInput(BaseModel):
    points: list[SignaturePointInput] = Field(min_length=1)


class CompleteInspectionRequest(BaseModel):
    """Signature capture is the final step of completion (spec 7.2 "digital
    signature", Phase 7.8) -- there is no separate sign-then-complete
    endpoint. `expected_revision` is required, unlike the optional field on
    `UpdateInspectionRequest`/`AssignChecklistTemplateRequest`: the whole
    point of binding a signature to a revision is to reject a stale view
    outright (409 `revision_conflict`) and force a refresh + re-sign, never
    silently complete against out-of-date checklist/readings data. `strokes`
    is a list of stroke objects (each with its own `points`), not a raw
    `list[list[...]]` -- see `Signature.strokes`'s docstring for why."""

    strokes: list[SignatureStrokeInput] = Field(min_length=1)
    expected_revision: int


class AttachInspectionMediaRequest(BaseModel):
    local_id: str = Field(min_length=1, max_length=200)
    filename: str = Field(min_length=1, max_length=300)
    kind: Literal["photo", "video"]
    content_type: str = Field(min_length=1, max_length=120)
    size: int = Field(gt=0)
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    captured_at: datetime
    checklist_item_id: str | None = Field(default=None, max_length=200)
    before_after_tag: Literal["before", "after"] | None = None


class UpdateInspectionMediaRequest(BaseModel):
    checklist_item_id: str | None = Field(default=None, max_length=200)
    before_after_tag: Literal["before", "after"] | None = None


class InspectionMediaDetached(BaseModel):
    id: str
    detached: bool = True


class AttachVoiceNoteRequest(BaseModel):
    local_id: str = Field(min_length=1, max_length=200)
    filename: str = Field(min_length=1, max_length=300)
    content_type: str = Field(min_length=1, max_length=120)
    size: int = Field(gt=0)
    duration_ms: int = Field(gt=0)
    checklist_item_id: str | None = Field(default=None, max_length=200)


class UpdateVoiceNoteRequest(BaseModel):
    checklist_item_id: str | None = Field(default=None, max_length=200)


class AnnotationPointInput(BaseModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)


class CreateAnnotationRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    media_local_id: str = Field(min_length=1, max_length=200)
    shape: Literal["freehand", "rectangle", "circle", "arrow", "point"]
    points: list[AnnotationPointInput] = Field(min_length=1)
    color: str = Field(min_length=1, max_length=20)
    damage_type: (
        Literal[
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
        ]
        | None
    ) = None
    note: str | None = Field(default=None, max_length=1000)


class UpdateAnnotationRequest(BaseModel):
    points: list[AnnotationPointInput] | None = Field(default=None, min_length=1)
    color: str | None = Field(default=None, min_length=1, max_length=20)
    damage_type: (
        Literal[
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
        ]
        | None
    ) = None
    note: str | None = Field(default=None, max_length=1000)


class CreateArMeasurementRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    method: Literal["ar", "manual"]
    distance_meters: float = Field(gt=0, le=100000)
    label: str | None = Field(default=None, max_length=200)
    media_local_id: str | None = Field(default=None, max_length=200)
    points: list[AnnotationPointInput] = Field(default_factory=list)
    note: str | None = Field(default=None, max_length=1000)
    checklist_item_id: str | None = Field(default=None, max_length=200)


class UpdateArMeasurementRequest(BaseModel):
    label: str | None = Field(default=None, max_length=200)
    note: str | None = Field(default=None, max_length=1000)
    checklist_item_id: str | None = Field(default=None, max_length=200)


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


PermitType = Literal[
    "hot_work",
    "confined_space",
    "electrical_isolation_loto",
    "excavation",
    "working_at_height",
    "general_maintenance",
]


class PermitChecklistTemplateItemInput(BaseModel):
    id: str | None = Field(default=None, max_length=200)
    label: str = Field(min_length=1, max_length=300)
    required: bool = True
    help_text: str | None = Field(default=None, max_length=1000)


class PermitApprovalTemplateStepInput(BaseModel):
    id: str | None = Field(default=None, max_length=200)
    label: str = Field(min_length=1, max_length=200)
    approver_role_id: str = Field(min_length=1, max_length=200)
    required: bool = True


class PermitChecklistTemplateItemResponse(BaseModel):
    id: str
    label: str
    required: bool
    help_text: str | None = None


class PermitApprovalTemplateStepResponse(BaseModel):
    id: str
    label: str
    approver_role_id: str
    required: bool


class PermitTemplateListItem(BaseModel):
    id: str
    name: str
    permit_type: PermitType
    version: int
    created_at: datetime
    updated_at: datetime


class PermitTemplateDetail(PermitTemplateListItem):
    description: str | None = None
    checklist_items: list[PermitChecklistTemplateItemResponse]
    approval_steps: list[PermitApprovalTemplateStepResponse]


class PermitTemplateListPage(BaseModel):
    items: list[PermitTemplateListItem]
    next_cursor: str | None = None


class CreatePermitTemplateRequest(BaseModel):
    name: str = Field(min_length=1, max_length=200)
    permit_type: PermitType
    description: str | None = Field(default=None, max_length=2000)
    checklist_items: list[PermitChecklistTemplateItemInput] = Field(min_length=1, max_length=100)
    approval_steps: list[PermitApprovalTemplateStepInput] = Field(min_length=1, max_length=20)


class UpdatePermitTemplateRequest(BaseModel):
    expected_version: int = Field(ge=1)
    name: str | None = Field(default=None, min_length=1, max_length=200)
    permit_type: PermitType | None = None
    description: str | None = Field(default=None, max_length=2000)
    checklist_items: list[PermitChecklistTemplateItemInput] | None = Field(
        default=None, min_length=1, max_length=100
    )
    approval_steps: list[PermitApprovalTemplateStepInput] | None = Field(
        default=None, min_length=1, max_length=20
    )


class PermitTemplateDeleted(BaseModel):
    id: str
    deleted: bool = True


PermitRiskBand = Literal["low", "medium", "high", "critical"]


class PermitRiskAssessmentInput(BaseModel):
    id: str | None = Field(default=None, max_length=200)
    hazard: str = Field(min_length=1, max_length=500)
    persons_at_risk: str = Field(min_length=1, max_length=500)
    initial_likelihood: int = Field(ge=1, le=5)
    initial_severity: int = Field(ge=1, le=5)
    controls: str = Field(min_length=1, max_length=2000)
    residual_likelihood: int = Field(ge=1, le=5)
    residual_severity: int = Field(ge=1, le=5)


class PermitRiskAssessmentResponse(BaseModel):
    id: str
    hazard: str
    persons_at_risk: str
    initial_likelihood: int
    initial_severity: int
    initial_score: int
    initial_band: PermitRiskBand
    controls: str
    residual_likelihood: int
    residual_severity: int
    residual_score: int
    residual_band: PermitRiskBand


class PermitChecklistSnapshotResponse(BaseModel):
    id: str
    template_item_id: str
    label: str
    required: bool
    help_text: str | None = None
    completed: bool
    completed_by: str | None = None
    completed_at: datetime | None = None


class PermitApprovalSnapshotResponse(BaseModel):
    id: str
    template_step_id: str
    label: str
    approver_role_id: str
    required: bool
    status: Literal["pending", "approved", "rejected"]
    signed_by: str | None = None
    signed_at: datetime | None = None
    rejection_reason: str | None = None


class PermitDigitalSignatureResponse(BaseModel):
    signer_id: str
    signed_at: datetime
    meaning: str


class PermitWorkerAcknowledgementResponse(BaseModel):
    worker_id: str
    client_mutation_id: str
    client_signed_at: datetime
    received_at: datetime
    signed_at: datetime
    device_id: str | None = None
    meaning: str


class PermitListItem(BaseModel):
    id: str
    permit_number: str
    title: str
    permit_type: PermitType
    status: Literal[
        "draft",
        "pending_approval",
        "pending_signatures",
        "active",
        "closed",
        "expired",
        "suspended",
        "revoked",
    ]
    facility_id: str
    valid_from: datetime
    valid_until: datetime
    worker_count: int
    highest_residual_risk: PermitRiskBand
    revision: int
    created_at: datetime
    updated_at: datetime


class PermitDetail(PermitListItem):
    description: str
    area_id: str | None = None
    asset_id: str | None = None
    template_id: str
    template_name: str
    template_version: int
    checklist_snapshot: list[PermitChecklistSnapshotResponse]
    approval_snapshot: list[PermitApprovalSnapshotResponse]
    risk_assessment: list[PermitRiskAssessmentResponse]
    worker_ids: list[str]
    issuer_signature: PermitDigitalSignatureResponse | None = None
    submitted_at: datetime | None = None
    worker_acknowledgements: list[PermitWorkerAcknowledgementResponse]
    activated_by: str | None = None
    activated_at: datetime | None = None
    suspended_by: str | None = None
    suspended_at: datetime | None = None
    suspension_reason: str | None = None
    revoked_by: str | None = None
    revoked_at: datetime | None = None
    revocation_reason: str | None = None
    closed_by: str | None = None
    closed_at: datetime | None = None
    closeout_notes: str | None = None
    expired_at: datetime | None = None


class PermitListPage(BaseModel):
    items: list[PermitListItem]
    next_cursor: str | None = None


class CreatePermitRequest(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=3000)
    permit_type: PermitType
    facility_id: str = Field(min_length=1, max_length=200)
    area_id: str | None = Field(default=None, max_length=200)
    asset_id: str | None = Field(default=None, max_length=200)
    valid_from: datetime
    valid_until: datetime
    template_id: str = Field(min_length=1, max_length=200)
    risk_assessment: list[PermitRiskAssessmentInput] = Field(min_length=1, max_length=100)
    worker_ids: list[str] = Field(min_length=1, max_length=100)


class UpdatePermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    title: str | None = Field(default=None, min_length=1, max_length=200)
    description: str | None = Field(default=None, min_length=1, max_length=3000)
    valid_from: datetime | None = None
    valid_until: datetime | None = None
    risk_assessment: list[PermitRiskAssessmentInput] | None = Field(
        default=None, min_length=1, max_length=100
    )
    worker_ids: list[str] | None = Field(default=None, min_length=1, max_length=100)


class PermitDeleted(BaseModel):
    id: str
    deleted: bool = True


class SubmitPermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    completed_checklist_item_ids: list[str] = Field(max_length=100)
    issuer_attestation: Literal[True]


class DecidePermitApprovalRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    decision: Literal["approve", "reject"]
    digital_signature_attestation: Literal[True]
    rejection_reason: str | None = Field(default=None, min_length=3, max_length=1000)


class AcknowledgePermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    client_mutation_id: str = Field(min_length=8, max_length=200)
    client_signed_at: datetime
    device_id: str | None = Field(default=None, min_length=1, max_length=200)
    worker_attestation: Literal[True]


class ActivatePermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    activation_attestation: Literal[True]


class ControlPermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    reason: str = Field(min_length=3, max_length=1000)


class ResumePermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    resume_attestation: Literal[True]


class ClosePermitRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    closeout_notes: str = Field(min_length=3, max_length=2000)
    close_attestation: Literal[True]


class WorkOrderListItem(BaseModel):
    id: str
    asset_id: str
    facility_id: str
    title: str
    priority: Literal["low", "medium", "high", "critical"]
    status: Literal["open", "assigned", "in_progress", "pending_review", "closed", "cancelled"]
    technician_id: str | None = None
    due_date: datetime | None = None
    revision: int
    created_at: datetime
    updated_at: datetime


class WorkOrderListPage(BaseModel):
    items: list[WorkOrderListItem]
    next_cursor: str | None = None


class WorkOrderDetail(WorkOrderListItem):
    description: str | None = None
    source_inspection_id: str | None = None
    assigned_by: str | None = None
    assigned_at: datetime | None = None
    accepted_at: datetime | None = None
    labor_hours: float | None = None
    materials_used: list[str] = Field(default_factory=list)
    completion_notes: str | None = None
    submitted_at: datetime | None = None
    closed_by: str | None = None
    closed_at: datetime | None = None
    cancelled_at: datetime | None = None
    created_by: str


class CreateWorkOrderRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    asset_id: str = Field(min_length=1, max_length=200)
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    priority: Literal["low", "medium", "high", "critical"] = "medium"
    due_date: datetime | None = None
    source_inspection_id: str | None = Field(default=None, max_length=200)


class AssignWorkOrderRequest(BaseModel):
    technician_id: str = Field(min_length=1, max_length=200)
    due_date: datetime | None = None
    expected_revision: int | None = None


class SubmitWorkOrderForReviewRequest(BaseModel):
    completion_notes: str = Field(min_length=1, max_length=2000)
    labor_hours: float | None = Field(default=None, ge=0, le=1000)
    materials_used: list[str] = Field(default_factory=list)
    expected_revision: int | None = None


class WorkOrderDeleted(BaseModel):
    id: str
    deleted: bool = True


SafetyCategory = Literal[
    "near_miss",
    "unsafe_condition",
    "unsafe_behavior",
    "fire",
    "gas_leak",
    "chemical_spill",
    "environmental_incident",
    "equipment_failure",
    "injury",
]
SafetyStatus = Literal[
    "reported",
    "under_review",
    "corrective_action",
    "resolved",
    "closed",
    "cancelled",
]


class SafetyCategoryCount(BaseModel):
    category: SafetyCategory
    count: int


class SafetyDashboardSummary(BaseModel):
    total: int
    by_category: list[SafetyCategoryCount]


class PermitDashboardSummary(BaseModel):
    active: int


class ReportDashboardSummary(BaseModel):
    total: int
    drafts: int
    finalized: int


class SafetyReportListItem(BaseModel):
    id: str
    title: str
    category: SafetyCategory
    severity: Literal["low", "medium", "high", "critical"]
    status: SafetyStatus
    reporter_id: str
    assigned_manager_id: str | None = None
    occurred_at: datetime
    revision: int
    created_at: datetime
    updated_at: datetime


class SafetyReportListPage(BaseModel):
    items: list[SafetyReportListItem]
    next_cursor: str | None = None


class SafetyReportDetail(SafetyReportListItem):
    description: str
    gps_lat: float | None = None
    gps_lng: float | None = None
    assigned_at: datetime | None = None
    resolved_at: datetime | None = None
    closed_at: datetime | None = None
    closed_by: str | None = None
    cancelled_at: datetime | None = None
    created_by: str
    evidence: list["SafetyEvidenceResponse"] = Field(default_factory=list)
    corrective_actions: list["CorrectiveActionResponse"] = Field(default_factory=list)


class SafetyEvidenceResponse(BaseModel):
    id: str
    filename: str
    kind: Literal["photo", "video"]
    content_type: str
    size: int
    uploaded_by: str
    uploaded_at: datetime
    url: str


class CorrectiveActionResponse(BaseModel):
    id: str
    description: str
    assignee_id: str
    due_date: datetime
    priority: Literal["low", "medium", "high", "critical"]
    status: Literal["open", "in_progress", "completed", "cancelled"]
    completion_notes: str | None = None
    cancellation_reason: str | None = None
    created_by: str
    created_at: datetime
    updated_at: datetime
    started_at: datetime | None = None
    completed_at: datetime | None = None
    completed_by: str | None = None
    cancelled_at: datetime | None = None
    cancelled_by: str | None = None


class CreateSafetyReportRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=5000)
    category: SafetyCategory
    severity: Literal["low", "medium", "high", "critical"]
    occurred_at: datetime
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)


class AssignSafetyReportRequest(BaseModel):
    manager_id: str = Field(min_length=1, max_length=200)
    expected_revision: int | None = None


class TransitionSafetyReportRequest(BaseModel):
    status: Literal["under_review", "corrective_action", "resolved", "cancelled"]
    expected_revision: int | None = None


class CreateCorrectiveActionRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=2000)
    assignee_id: str = Field(min_length=1, max_length=200)
    due_date: datetime
    priority: Literal["low", "medium", "high", "critical"] = "medium"


class UpdateCorrectiveActionRequest(BaseModel):
    status: Literal["in_progress", "completed"]
    completion_notes: str | None = Field(default=None, max_length=2000)


class CancelCorrectiveActionRequest(BaseModel):
    reason: str = Field(min_length=1, max_length=1000)


class SafetyReportDeleted(BaseModel):
    id: str
    deleted: bool = True


ReportType = Literal[
    "inspection",
    "maintenance",
    "safety",
    "executive_summary",
    "asset_health",
]


class ReportNarrativeResponse(BaseModel):
    summary: str
    findings: list[str] = Field(default_factory=list)
    recommendations: list[str] = Field(default_factory=list)
    risk_score: float | None = None


class GeneratedReportListItem(BaseModel):
    id: str
    report_type: ReportType
    source_id: str | None = None
    title: str
    status: Literal["draft", "finalized"]
    revision: int
    created_by: str
    created_at: datetime
    updated_at: datetime
    finalized_by: str | None = None
    finalized_at: datetime | None = None


class GeneratedReportListPage(BaseModel):
    items: list[GeneratedReportListItem]
    next_cursor: str | None = None


class GeneratedReportDetail(GeneratedReportListItem):
    source_snapshot: dict[str, Any]
    source_revision: int | None = None
    narrative: ReportNarrativeResponse
    ai_model: str
    finalization_attestation: bool


class GeneratedReportExportResponse(BaseModel):
    report_id: str
    format: Literal["pdf", "docx", "xlsx"]
    filename: str
    content_type: str
    size: int
    generated_by: str
    generated_at: datetime
    url: str


class CreateGeneratedReportRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    report_type: ReportType
    source_id: str | None = Field(default=None, min_length=1, max_length=200)
    title: str | None = Field(default=None, min_length=1, max_length=200)


class UpdateGeneratedReportRequest(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=200)
    summary: str | None = Field(default=None, min_length=1, max_length=10000)
    findings: list[str] | None = Field(default=None, max_length=100)
    recommendations: list[str] | None = Field(default=None, max_length=100)
    risk_score: float | None = Field(default=None, ge=0, le=100)
    expected_revision: int = Field(ge=1)


class FinalizeGeneratedReportRequest(BaseModel):
    expected_revision: int = Field(ge=1)
    finalization_attestation: Literal[True]


class RegenerateGeneratedReportRequest(BaseModel):
    expected_revision: int = Field(ge=1)


class DocumentListItem(BaseModel):
    id: str
    title: str
    document_code: str
    category: Literal["sop", "manual", "safety_policy", "certificate", "drawing", "report"]
    description: str | None = None
    facility_id: str | None = None
    asset_id: str | None = None
    file_path: str
    filename: str
    file_format: Literal["pdf", "docx", "png", "xlsx", "txt"]
    file_size_bytes: int
    version: int
    status: Literal["active", "archived", "under_review"]
    tags: list[str] = Field(default_factory=list)
    download_url: str | None = None
    created_by: str
    created_at: datetime
    updated_at: datetime


class DocumentDetail(DocumentListItem):
    pass


class DocumentListPage(BaseModel):
    items: list[DocumentListItem]
    next_cursor: str | None = None


class CreateDocumentRequest(BaseModel):
    id: str = Field(min_length=1, max_length=200)
    title: str = Field(min_length=1, max_length=200)
    document_code: str = Field(min_length=1, max_length=100)
    category: Literal["sop", "manual", "safety_policy", "certificate", "drawing", "report"]
    description: str | None = Field(default=None, max_length=2000)
    facility_id: str | None = Field(default=None, max_length=200)
    asset_id: str | None = Field(default=None, max_length=200)
    file_path: str = Field(min_length=1, max_length=1000)
    filename: str = Field(min_length=1, max_length=300)
    file_format: Literal["pdf", "docx", "png", "xlsx", "txt"] = "pdf"
    file_size_bytes: int = Field(ge=0)
    status: Literal["active", "archived", "under_review"] = "active"
    tags: list[str] = Field(default_factory=list)


class UpdateDocumentRequest(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=200)
    document_code: str | None = Field(default=None, min_length=1, max_length=100)
    category: (
        Literal["sop", "manual", "safety_policy", "certificate", "drawing", "report"] | None
    ) = None
    description: str | None = Field(default=None, max_length=2000)
    facility_id: str | None = Field(default=None, max_length=200)
    asset_id: str | None = Field(default=None, max_length=200)
    status: Literal["active", "archived", "under_review"] | None = None
    tags: list[str] | None = None


class GeneratedReportDeleted(BaseModel):
    id: str
    deleted: bool = True


class DocumentDeleted(BaseModel):
    id: str
    deleted: bool = True


def error_responses(*status_codes: int) -> dict[int | str, dict[str, Any]]:
    descriptions = {
        201: "Resource created",
        400: "Request was malformed or referenced an unknown plan",
        401: "Authentication failed",
        # Phase 13: the entitlement gate. Distinct from 403 -- the caller is
        # allowed, but the company's plan does not include the module, so the
        # body carries the tier that unlocks it.
        402: "Company's subscription does not include this capability",
        403: "Authenticated caller is not authorized",
        404: "Resource was not found",
        409: "Request conflicts with current state",
        413: "Request payload exceeds the allowed size",
        422: "Request validation failed",
        500: "Unexpected server error",
        502: "An upstream service (e.g. the AI vision provider) failed or is unreachable",
        503: "A required upstream dependency (e.g. billing) is not configured",
    }
    return {
        code: {"model": ErrorEnvelope, "description": descriptions[code]} for code in status_codes
    }


# --- Phase 13 billing (D-090) --------------------------------------------


class BillingPlanQuotasResponse(BaseModel):
    """`None` means unlimited. An unentitled company reports 0, not None."""

    facilities: int | None
    assets: int | None
    seats: int | None


class BillingPlanResponse(BaseModel):
    """One published tier.

    The price fields are nullable because a custom-quoted tier has no list
    price at all -- `starting_monthly_cents` is the floor it is sold from, and
    a client must render that as "starting around", never as a buyable amount.
    `self_serve` is what a client should branch on: false means the call to
    action is a conversation, not a card.
    """

    tier: str
    name: str
    audience: str
    monthly_cents: int | None
    annual_total_cents: int | None
    #: What the annual total works out to per month, for "or $X/mo billed annually".
    annual_monthly_equivalent_cents: int | None
    starting_monthly_cents: int | None
    quotas: BillingPlanQuotasResponse
    features: list[str]
    digital_twin_scope: str
    support: str
    adds: list[str]
    custom_quoted: bool
    self_serve: bool


class BillingCatalogResponse(BaseModel):
    trial_days: int
    #: Months charged for twelve months of service on annual billing.
    annual_months_charged: int
    plans: list[BillingPlanResponse]
    #: What an Enterprise quote is built from, published so "custom" reads as a
    #: method rather than an evasion.
    enterprise_quote_factors: list[str]


class SubscriptionResponse(BaseModel):
    """What the shell needs to decide which modules to render. `features` is the
    authoritative list -- the client must not derive it from `tier` itself."""

    tier: str
    plan_name: str | None
    status: str
    is_entitled: bool
    features: list[str]
    trial_ends_at: datetime | None
    trial_days_remaining: int | None
    current_period_end: datetime | None
    quotas: BillingPlanQuotasResponse


class CheckoutSessionRequest(BaseModel):
    tier: str
    interval: str


class CheckoutSessionResponse(BaseModel):
    session_id: str
    checkout_url: str


class CheckoutConfirmRequest(BaseModel):
    """The session id Stripe substitutes into the success URL."""

    session_id: str = Field(min_length=1, max_length=255)


class CheckoutConfirmResponse(BaseModel):
    """`outcome` is `reconciled` once the purchase has been written to the
    company, or `pending` while Stripe has not yet attached a subscription to
    the session. `subscription` is the freshly resolved plan either way, so the
    completion screen never needs a second round trip to decide what to show."""

    outcome: Literal["reconciled", "pending"]
    subscription: "SubscriptionResponse"


# --- Legal package: contact form and acceptance records (D-105) -----------


#: The categories the contact page offers. Validated here rather than typed as
#: a Literal so a 26-value enum is not generated into the Dart client for a
#: web-only form; the page renders this same list.
CONTACT_CATEGORIES: frozenset[str] = frozenset(
    {
        "General Question",
        "Account / Login Support",
        "Company Administration",
        "User / Role / Permission Issue",
        "Asset Management",
        "QR Code / Asset Scanning",
        "AR Inspection",
        "AI Analysis",
        "Safety Report",
        "Permit-to-Work",
        "Work Order / Maintenance",
        "Report Generation",
        "3D Facility View",
        "VR Training",
        "Mobile App",
        "Offline Sync",
        "Billing / Subscription",
        "Facility / Asset / Seat Add-On",
        "Implementation / Onboarding",
        "Data Migration",
        "Enterprise / SSO",
        "Integration Request",
        "Privacy Request",
        "Legal Inquiry",
        "Security Concern",
        "Partnership",
        "Other",
    }
)


class ContactRequest(BaseModel):
    """A public contact-form submission.

    Every field is length-bounded because this endpoint is unauthenticated. The
    form tells senders not to include passwords, tokens, or full card numbers;
    nothing here is stored, only forwarded to the support inbox.
    """

    name: str = Field(min_length=1, max_length=120)
    email: str = Field(min_length=5, max_length=320)
    company: str | None = Field(default=None, max_length=160)
    category: str = Field(min_length=1, max_length=64)
    subject: str = Field(min_length=1, max_length=200)
    message: str = Field(min_length=1, max_length=5000)


class ContactResponse(BaseModel):
    """`received` is always true on a 2xx. Kept as a field so the client has a
    typed success body rather than an empty one."""

    received: bool


class LegalAcceptanceResponse(BaseModel):
    """What the signed-in user has accepted, and at which version.

    `current_version` is what the deployment publishes today; when it differs
    from `accepted_version` the client knows to re-ask rather than assuming an
    older acceptance still covers a materially changed document.
    """

    accepted_version: str | None
    current_version: str
    terms_accepted: bool
    privacy_accepted: bool
    safety_disclaimer_accepted: bool
    accepted_at: datetime | None
    acceptance_source: str | None
    requires_acceptance: bool


class NotificationResponse(BaseModel):
    id: str
    event: str
    title: str
    body: str
    target_type: str
    target_id: str
    metadata: dict[str, str] = Field(default_factory=dict)
    # What actually went out, not what was intended -- email and push are
    # best-effort and a failure there never fails the triggering action.
    delivered_channels: list[str] = Field(default_factory=list)
    read_at: datetime | None = None
    created_at: datetime


class NotificationListPage(BaseModel):
    items: list[NotificationResponse] = Field(default_factory=list)
    unread_count: int = 0


class NotificationRead(BaseModel):
    id: str
    read_at: datetime | None = None


class NotificationsAllRead(BaseModel):
    marked: int


class RegisterDeviceRequest(BaseModel):
    token: str = Field(min_length=1, max_length=4096)
    platform: Literal["android", "ios", "web"]


class DeviceRegistered(BaseModel):
    registered: bool


class DeviceUnregistered(BaseModel):
    unregistered: bool


class TrainingStepResponse(BaseModel):
    id: str
    order: int
    title: str
    instruction: str
    action: str
    target_asset_id: str | None = None
    target_position: list[float] | None = None
    options: list[str] = Field(default_factory=list)
    # Deliberately not exposed: `correct_option` stays server-side so the
    # answer cannot be read out of the payload the trainee's client receives.
    time_limit_seconds: int | None = None


class TrainingModuleResponse(BaseModel):
    id: str
    title: str
    kind: str
    facility_id: str
    description: str
    steps: list[TrainingStepResponse] = Field(default_factory=list)
    estimated_minutes: int
    pass_threshold: int


class TrainingModuleListPage(BaseModel):
    items: list[TrainingModuleResponse] = Field(default_factory=list)


class TrainingProgressResponse(BaseModel):
    id: str
    module_id: str
    status: str
    completed_step_ids: list[str] = Field(default_factory=list)
    correct_count: int = 0
    scored_count: int = 0
    score: int | None = None
    attempts: int = 1
    started_at: datetime
    completed_at: datetime | None = None


class TrainingProgressListPage(BaseModel):
    items: list[TrainingProgressResponse] = Field(default_factory=list)


class CompleteTrainingStepRequest(BaseModel):
    # For `choose` steps the client sends what the trainee picked and the
    # server decides whether it was right -- the correct answer is never sent
    # out, so the client has nothing to compare against.
    selected_option: str | None = None
    # For `locate`/`sequence` steps, whether the trainee reached the target.
    # Ignored for `choose` (the server judges) and for steps that cannot be
    # answered wrongly at all.
    correct: bool | None = None
