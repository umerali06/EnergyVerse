from datetime import date, datetime
from typing import Any, Literal

from pydantic import Field, field_validator

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


class Readings(StrictModel):
    """Manually entered inspector readings (spec section 9, Phase 7.7) --
    MVP has no live IoT sensors. Units are fixed and documented rather than
    a per-reading unit field (temperature in Celsius, pressure in bar, noise
    in decibels), so every stored value is directly comparable across
    inspections/companies with no conversion step; a company-level unit
    display preference can layer on top later without a data migration."""

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
    recorded_at: datetime | None = None
    recorded_by: str | None = None


class SignatureStroke(StrictModel):
    """One continuous pen-down-to-pen-up stroke -- `Signature.strokes` is a
    list of these rather than a raw `list[list[AnnotationPoint]]` because
    generated clients (built_value's Dart codegen in particular) handle a
    single level of list-of-object nesting far more reliably than a
    doubly-nested `list[list[...]]`, which needs a builder factory the
    generator doesn't always emit. A named `points` field sidesteps that
    entirely and leaves room for future per-stroke metadata (color, width)
    without another schema change."""

    points: list[AnnotationPoint] = Field(min_length=1)


class Signature(StrictModel):
    """Inspector sign-off at inspection completion (spec 7.2 "digital
    signature", Phase 7.8). Vector-drawn, mirroring `Annotation`'s D-054
    normalized-points precedent, rather than a raster image -- tiny payload,
    no Storage upload/signed-URL round trip, renders at any canvas size.
    Identity fields (`signer_uid`/`signer_name`/`signer_role`) are always
    server-derived from the authenticated caller, never taken from the
    client. `inspection_revision` is the inspection's own `revision` at the
    moment of signing -- `complete_inspection` requires `expected_revision`
    to match before writing, so this is always exactly the completed
    inspection's final revision. A completed inspection can never be edited
    (see `TERMINAL_STATUSES` locking in `update_inspection`/
    `assign_checklist_template`), so a persisted signature can never
    actually go stale after the fact; "edited since signing" instead means
    the pre-completion offline race where the signature was drawn against a
    revision the server has since moved past -- that's rejected by the same
    `revision_conflict` 409 the checklist/readings autosave protocol already
    uses, forcing the client to refresh and re-sign before completing."""

    strokes: list[SignatureStroke] = Field(min_length=1)
    signer_uid: str
    signer_name: str
    signer_role: str
    signed_at: datetime
    inspection_revision: int


class ArMeasurement(StrictModel):
    """A dimension measurement captured either via AR plane-tap distance
    (`method="ar"`) or manual numeric entry (`method="manual"`, spec 7.2's
    mandatory fallback for unsupported devices/plugin failure, D-063).
    Distance is always stored in meters -- same fixed-unit rationale as
    `Readings` (D-058) -- so it is unambiguous in storage regardless of
    which unit the device displayed at capture time; unit conversion for
    display is a client concern. An AR measurement always references the
    screenshot it was measured against (`media_local_id`, an existing
    `InspectionMedia` item) as visual evidence; a manual measurement has no
    required screenshot but may optionally reference an existing photo for
    context. `points` is an optional set of normalized (0-1) overlay
    markers on that screenshot, reusing `AnnotationPoint`'s shape so it can
    render on the same overlay model as damage annotations -- left empty
    when the capturing client can't reliably supply exact tap coordinates
    (true of the Phase 7.9 AR capture screen today, D-064)."""

    id: str
    method: Literal["ar", "manual"]
    distance_meters: float = Field(gt=0, le=100000)
    label: str | None = Field(default=None, max_length=200)
    media_local_id: str | None = None
    points: list[AnnotationPoint] = Field(default_factory=list)
    note: str | None = Field(default=None, max_length=1000)
    checklist_item_id: str | None = None
    created_by: str
    created_at: datetime


class AiAnalysis(StrictModel):
    """One AI-assisted photo analysis run (spec 8 "AI Photo & Video Analysis",
    Phase 7.10). Findings are never authoritative -- each one is persisted as
    its own `Annotation(source="ai", ...)` (D-054's reserved fields, exactly
    the mechanism this phase was designed to use); this record is the
    analysis-level summary/metadata plus a `reviewed` flag the inspector sets
    explicitly once they've looked at the findings, distinct from freely
    editing/deleting the underlying annotations (that IS the "override" half
    of "confirm or override")."""

    id: str
    media_local_id: str
    model: str
    summary: str
    recommendations: str | None = None
    risk_level: Literal["low", "medium", "high", "critical"] | None = None
    annotation_ids: list[str] = Field(default_factory=list)
    reviewed: bool = False
    reviewed_by: str | None = None
    reviewed_at: datetime | None = None
    created_by: str
    created_at: datetime


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
    readings: Readings | None = None
    signature: Signature | None = None
    ar_measurements: list[ArMeasurement] = Field(default_factory=list)
    ai_analysis: list[AiAnalysis] = Field(default_factory=list)

    @field_validator("readings", mode="before")
    @classmethod
    def _normalize_legacy_empty_readings(cls, value: object) -> object:
        """Every inspection created before Phase 7.7 was written with the old
        `readings: dict = {}` placeholder default, so an empty dict must still
        load cleanly as "no readings yet" rather than fail `Readings`
        validation (which requires `condition`)."""
        if value == {}:
            return None
        return value

    @field_validator("ai_analysis", mode="before")
    @classmethod
    def _normalize_legacy_ai_analysis(cls, value: object) -> object:
        """Every inspection created before Phase 7.10 was written with the
        old `ai_analysis: dict | None = None` placeholder, so a stored `None`
        must still load cleanly as "never analyzed" rather than fail
        `list[AiAnalysis]` validation."""
        if value is None:
            return []
        return value


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
    readings: Readings | None = None


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
