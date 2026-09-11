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
    # --- Phase 13 subscription state (D-090) -----------------------------
    # `subscription_tier` above names the plan; these carry whether it is paid
    # for. Defaulted so every company document written before Phase 13 still
    # loads: an existing row reads as `incomplete`, which grants no features
    # until a checkout completes or a platform admin assigns a tier.
    subscription_status: str = "incomplete"
    billing_interval: str | None = None
    trial_ends_at: datetime | None = None
    current_period_end: datetime | None = None
    stripe_customer_id: str | None = None
    stripe_subscription_id: str | None = None


class CompanyCreate(StrictModel):
    id: str
    name: str
    status: str
    subscription_tier: str
    subscription_status: str = "incomplete"


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
    subscription_status: str | None = None
    billing_interval: str | None = None
    trial_ends_at: datetime | None = None
    current_period_end: datetime | None = None
    stripe_customer_id: str | None = None
    stripe_subscription_id: str | None = None


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


AssetCondition = Literal["Excellent", "Good", "Fair", "Poor", "Critical"]


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
    # The five-state condition the requirements name, carried from the most
    # recent completed inspection's readings. `current_status` is the 3-state
    # rollup that drives the dashboard KPI; this is the term a human reads.
    # Null until the asset has been inspected at least once.
    current_condition: AssetCondition | None = None
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
    source: Literal["manual", "ai"] = "manual"
    confidence: float | None = Field(default=None, ge=0, le=1)
    # Set only for a region found in a video: the offset, in seconds, of the
    # frame the coordinates belong to. Normalized points are meaningless on a
    # clip without knowing which frame they were measured against. Null for
    # every photo annotation, so existing records stay valid unchanged.
    frame_timestamp_seconds: float | None = Field(default=None, ge=0)
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
    # "photo" for a still; "video" when the run sampled frames from a clip.
    media_kind: Literal["photo", "video"] = "photo"
    # How many frames were sampled and analysed (video runs only), so a
    # reviewer knows the coverage behind the summary.
    frames_analyzed: int | None = Field(default=None, ge=1)
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


PermitType = Literal[
    "hot_work",
    "confined_space",
    "electrical_isolation_loto",
    "excavation",
    "working_at_height",
    "general_maintenance",
]


class PermitChecklistTemplateItem(StrictModel):
    id: str
    label: str = Field(min_length=1, max_length=300)
    required: bool = True
    help_text: str | None = Field(default=None, max_length=1000)


class PermitApprovalTemplateStep(StrictModel):
    id: str
    label: str = Field(min_length=1, max_length=200)
    approver_role_id: str
    required: bool = True


class PermitTemplate(TenantDoc):
    id: str
    name: str = Field(min_length=1, max_length=200)
    permit_type: PermitType
    description: str | None = Field(default=None, max_length=2000)
    checklist_items: list[PermitChecklistTemplateItem] = Field(min_length=1)
    approval_steps: list[PermitApprovalTemplateStep] = Field(min_length=1)
    version: int = 1
    deleted_at: datetime | None = None


class PermitTemplateCreate(StrictModel):
    id: str
    name: str = Field(min_length=1, max_length=200)
    permit_type: PermitType
    description: str | None = Field(default=None, max_length=2000)
    checklist_items: list[PermitChecklistTemplateItem] = Field(min_length=1)
    approval_steps: list[PermitApprovalTemplateStep] = Field(min_length=1)


PermitRiskBand = Literal["low", "medium", "high", "critical"]


class PermitRiskAssessmentItem(StrictModel):
    id: str
    hazard: str = Field(min_length=1, max_length=500)
    persons_at_risk: str = Field(min_length=1, max_length=500)
    initial_likelihood: int = Field(ge=1, le=5)
    initial_severity: int = Field(ge=1, le=5)
    initial_score: int = Field(ge=1, le=25)
    initial_band: PermitRiskBand
    controls: str = Field(min_length=1, max_length=2000)
    residual_likelihood: int = Field(ge=1, le=5)
    residual_severity: int = Field(ge=1, le=5)
    residual_score: int = Field(ge=1, le=25)
    residual_band: PermitRiskBand


class PermitChecklistSnapshotItem(StrictModel):
    id: str
    template_item_id: str
    label: str
    required: bool
    help_text: str | None = None
    completed: bool = False
    completed_by: str | None = None
    completed_at: datetime | None = None


class PermitApprovalSnapshotStep(StrictModel):
    id: str
    template_step_id: str
    label: str
    approver_role_id: str
    required: bool
    status: Literal["pending", "approved", "rejected"] = "pending"
    signed_by: str | None = None
    signed_at: datetime | None = None
    rejection_reason: str | None = None


class PermitDigitalSignature(StrictModel):
    signer_id: str
    signed_at: datetime
    meaning: str


class PermitWorkerAcknowledgement(StrictModel):
    worker_id: str
    client_mutation_id: str
    client_signed_at: datetime
    received_at: datetime
    signed_at: datetime
    device_id: str | None = None
    meaning: str


class Permit(TenantDoc):
    id: str
    permit_number: str
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=3000)
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
    ] = "draft"
    facility_id: str
    area_id: str | None = None
    asset_id: str | None = None
    valid_from: datetime
    valid_until: datetime
    template_id: str
    template_name: str
    template_version: int = Field(ge=1)
    checklist_snapshot: list[PermitChecklistSnapshotItem] = Field(min_length=1)
    approval_snapshot: list[PermitApprovalSnapshotStep] = Field(min_length=1)
    risk_assessment: list[PermitRiskAssessmentItem] = Field(min_length=1)
    worker_ids: list[str] = Field(min_length=1)
    issuer_signature: PermitDigitalSignature | None = None
    submitted_at: datetime | None = None
    worker_acknowledgements: list[PermitWorkerAcknowledgement] = Field(default_factory=list)
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
    revision: int = Field(default=1, ge=1)
    deleted_at: datetime | None = None


class PermitCreate(StrictModel):
    id: str
    permit_number: str
    title: str
    description: str
    permit_type: PermitType
    facility_id: str
    area_id: str | None = None
    asset_id: str | None = None
    valid_from: datetime
    valid_until: datetime
    template_id: str
    template_name: str
    template_version: int
    checklist_snapshot: list[PermitChecklistSnapshotItem]
    approval_snapshot: list[PermitApprovalSnapshotStep]
    risk_assessment: list[PermitRiskAssessmentItem]
    worker_ids: list[str]


class WorkOrder(TenantDoc):
    """A maintenance work order raised against an asset (spec section 12,
    Phase 8.1). Lifecycle: `open -> assigned -> in_progress ->
    pending_review -> closed`, plus a terminal `cancelled` reachable from
    any non-terminal state -- mirrors `Inspection`'s draft/in_progress/
    completed + cancelled shape (D-045), adapted for the spec's explicit
    Assign/Accept/Supervisor-Review steps. Closing requires
    `work_orders.close` (D-066) -- deliberately distinct from
    `work_orders.write` so the assigned technician can submit their repair
    for review but cannot close it themselves. `media` is reserved,
    always-empty until a future phase gives "Upload Photos" a real shape,
    matching how `Inspection.ar_measurements`/`ai_analysis` were reserved
    in Phase 7.1 ahead of their own phases."""

    id: str
    asset_id: str
    facility_id: str
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    priority: Literal["low", "medium", "high", "critical"] = "medium"
    status: Literal["open", "assigned", "in_progress", "pending_review", "closed", "cancelled"] = (
        "open"
    )
    source_inspection_id: str | None = None
    technician_id: str | None = None
    assigned_by: str | None = None
    assigned_at: datetime | None = None
    due_date: datetime | None = None
    accepted_at: datetime | None = None
    labor_hours: float | None = Field(default=None, ge=0, le=1000)
    materials_used: list[str] = Field(default_factory=list)
    completion_notes: str | None = Field(default=None, max_length=2000)
    submitted_at: datetime | None = None
    closed_by: str | None = None
    closed_at: datetime | None = None
    cancelled_at: datetime | None = None
    revision: int = 1
    deleted_at: datetime | None = None
    media: list[dict[str, Any]] = Field(default_factory=list)


class WorkOrderCreate(StrictModel):
    id: str
    asset_id: str
    facility_id: str
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    priority: Literal["low", "medium", "high", "critical"] = "medium"
    due_date: datetime | None = None
    source_inspection_id: str | None = None


class SafetyEvidence(StrictModel):
    id: str
    path: str
    filename: str
    kind: Literal["photo", "video"]
    content_type: str
    size: int
    uploaded_by: str
    uploaded_at: datetime


class CorrectiveAction(StrictModel):
    id: str
    description: str = Field(min_length=1, max_length=2000)
    assignee_id: str
    due_date: datetime
    priority: Literal["low", "medium", "high", "critical"] = "medium"
    status: Literal["open", "in_progress", "completed", "cancelled"] = "open"
    completion_notes: str | None = Field(default=None, max_length=2000)
    cancellation_reason: str | None = Field(default=None, max_length=1000)
    created_by: str
    created_at: datetime
    updated_at: datetime
    started_at: datetime | None = None
    completed_at: datetime | None = None
    completed_by: str | None = None
    cancelled_at: datetime | None = None
    cancelled_by: str | None = None


class SafetyReport(TenantDoc):
    """Tenant-scoped safety incident (source brief section 10, D-068)."""

    id: str
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=5000)
    category: Literal[
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
    severity: Literal["low", "medium", "high", "critical"]
    status: Literal[
        "reported", "under_review", "corrective_action", "resolved", "closed", "cancelled"
    ] = "reported"
    reporter_id: str
    occurred_at: datetime
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)
    assigned_manager_id: str | None = None
    assigned_at: datetime | None = None
    resolved_at: datetime | None = None
    closed_at: datetime | None = None
    closed_by: str | None = None
    cancelled_at: datetime | None = None
    revision: int = 1
    deleted_at: datetime | None = None
    evidence: list[SafetyEvidence] = Field(default_factory=list)
    corrective_actions: list[CorrectiveAction] = Field(default_factory=list)


class SafetyReportCreate(StrictModel):
    id: str
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=5000)
    category: Literal[
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
    severity: Literal["low", "medium", "high", "critical"]
    reporter_id: str
    occurred_at: datetime
    gps_lat: float | None = Field(default=None, ge=-90, le=90)
    gps_lng: float | None = Field(default=None, ge=-180, le=180)


ReportType = Literal[
    "inspection",
    "maintenance",
    "safety",
    "executive_summary",
    "asset_health",
]


class ReportNarrative(StrictModel):
    """Advisory AI-authored prose stored separately from the immutable source snapshot."""

    summary: str = Field(min_length=1, max_length=10000)
    findings: list[str] = Field(default_factory=list, max_length=100)
    recommendations: list[str] = Field(default_factory=list, max_length=100)
    risk_score: float | None = Field(default=None, ge=0, le=100)


class ReportExport(StrictModel):
    format: Literal["pdf", "docx", "xlsx"]
    path: str
    filename: str
    content_type: str
    size: int = Field(gt=0)
    generated_by: str
    generated_at: datetime


class GeneratedReport(TenantDoc):
    """Tenant-owned report draft/finalized snapshot (Phase 9, D-083)."""

    id: str
    report_type: ReportType
    source_id: str | None = None
    title: str = Field(min_length=1, max_length=200)
    status: Literal["draft", "finalized"] = "draft"
    source_snapshot: dict[str, Any]
    source_revision: int | None = None
    narrative: ReportNarrative
    ai_model: str
    finalized_by: str | None = None
    finalized_at: datetime | None = None
    finalization_attestation: bool = False
    exports: list[ReportExport] = Field(default_factory=list)
    revision: int = Field(default=1, ge=1)
    deleted_at: datetime | None = None


class GeneratedReportCreate(StrictModel):
    id: str
    report_type: ReportType
    source_id: str | None = None
    title: str
    source_snapshot: dict[str, Any]
    source_revision: int | None = None
    narrative: ReportNarrative
    ai_model: str


class AuditLog(AppendOnlyDoc):
    id: str
    company_id: str
    action: str
    target_type: str
    target_id: str
    metadata: dict[str, Any] = Field(default_factory=dict)


DocumentCategory = Literal["sop", "manual", "safety_policy", "certificate", "drawing", "report"]
DocumentFileFormat = Literal["pdf", "docx", "png", "xlsx", "txt"]
DocumentStatus = Literal["active", "archived", "under_review"]


class Document(TenantDoc):
    id: str
    title: str = Field(min_length=1, max_length=200)
    document_code: str = Field(min_length=1, max_length=100)
    category: DocumentCategory
    description: str | None = Field(default=None, max_length=2000)
    facility_id: str | None = None
    asset_id: str | None = None
    file_path: str
    filename: str
    file_format: DocumentFileFormat = "pdf"
    file_size_bytes: int = Field(ge=0)
    version: int = Field(default=1, ge=1)
    status: DocumentStatus = "active"
    tags: list[str] = Field(default_factory=list)
    download_url: str | None = None
    created_by: str
    deleted_at: datetime | None = None


class DocumentCreate(StrictModel):
    id: str
    title: str = Field(min_length=1, max_length=200)
    document_code: str = Field(min_length=1, max_length=100)
    category: DocumentCategory
    description: str | None = Field(default=None, max_length=2000)
    facility_id: str | None = None
    asset_id: str | None = None
    file_path: str
    filename: str
    file_format: DocumentFileFormat = "pdf"
    file_size_bytes: int = Field(ge=0)
    status: DocumentStatus = "active"
    tags: list[str] = Field(default_factory=list)


class DocumentUpdate(StrictModel):
    title: str | None = Field(default=None, min_length=1, max_length=200)
    document_code: str | None = Field(default=None, min_length=1, max_length=100)
    category: DocumentCategory | None = None
    description: str | None = Field(default=None, max_length=2000)
    facility_id: str | None = None
    asset_id: str | None = None
    status: DocumentStatus | None = None
    tags: list[str] | None = None


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
    work_orders: int
    documents: int
    permit_templates: int
    permits: int


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


class VerificationEmailResponse(StrictModel):
    """`sent=False` means the address was already verified, not a failure --
    re-verifying a confirmed address is a no-op rather than an error."""

    sent: bool


def without_none(values: dict[str, object | None]) -> dict[str, object]:
    return {key: value for key, value in values.items() if value is not None}


# --- Notifications -----------------------------------------------------------

# The events a tenant user can be notified about. Each one is raised by the
# module that owns the action, so the vocabulary stays closed and a client can
# switch on it to pick an icon or a deep link.
NotificationEvent = Literal[
    "work_order.assigned",
    "work_order.submitted_for_review",
    "work_order.closed",
    "safety_report.assigned",
    "safety_report.corrective_action_assigned",
    "permit.approval_requested",
    "permit.activated",
    "permit.expiring",
    "inspection.completed",
    "report.finalized",
]

# Where a notification points. Clients map this to their own route table
# rather than the server hard-coding client URLs.
NotificationTargetType = Literal[
    "work_order",
    "safety_report",
    "permit",
    "inspection",
    "report",
]

NotificationChannel = Literal["in_app", "email", "push"]


class Notification(TenantDoc):
    """One notification addressed to one user.

    Notifications are personal rather than permission-scoped: the recipient is
    named on the record and the service only ever returns rows where
    `user_id` matches the caller, so no new RBAC permission is involved.

    `delivered_channels` records what actually went out. Email and push are
    best-effort -- a bounced email or a stale device token must never fail the
    action that triggered the notification -- so this is the audit trail of
    what really happened, not what was intended.
    """

    id: str
    user_id: str
    event: NotificationEvent
    title: str = Field(min_length=1, max_length=200)
    body: str = Field(min_length=1, max_length=1000)
    target_type: NotificationTargetType
    target_id: str
    # Free-form extras a client may render (e.g. an asset tag); never trusted
    # for authorization.
    metadata: dict[str, str] = Field(default_factory=dict)
    delivered_channels: list[NotificationChannel] = Field(default_factory=list)
    read_at: datetime | None = None
    created_by: str


class NotificationCreate(StrictModel):
    id: str
    user_id: str
    event: NotificationEvent
    title: str = Field(min_length=1, max_length=200)
    body: str = Field(min_length=1, max_length=1000)
    target_type: NotificationTargetType
    target_id: str
    metadata: dict[str, str] = Field(default_factory=dict)
    delivered_channels: list[NotificationChannel] = Field(default_factory=list)


class DeviceToken(TenantDoc):
    """An FCM registration token for one user's device.

    Keyed by a hash of the token rather than the token itself so the document
    id is safe to log. A token can move between users (a shared site tablet),
    so registering one that already exists reassigns it rather than failing.
    """

    id: str
    user_id: str
    token: str = Field(min_length=1, max_length=4096)
    platform: Literal["android", "ios", "web"]
    created_by: str
    last_seen_at: datetime


class DeviceTokenCreate(StrictModel):
    id: str
    user_id: str
    token: str = Field(min_length=1, max_length=4096)
    platform: Literal["android", "ios", "web"]
    last_seen_at: datetime


# --- VR training --------------------------------------------------------------

# The five competencies the requirements name. The kind drives how the WebXR
# runner scores a module, so it is a closed vocabulary rather than free text.
TrainingModuleKind = Literal[
    "exploration",
    "equipment_location",
    "safety_procedure",
    "emergency_drill",
    "maintenance_simulation",
]

# What a trainee must do to clear one step. `locate` and `sequence` are the two
# that can be failed; the rest are acknowledgements.
TrainingStepAction = Literal["observe", "locate", "acknowledge", "sequence", "choose"]

TrainingProgressStatus = Literal["not_started", "in_progress", "completed", "failed"]


class TrainingStep(StrictModel):
    """One instruction inside a module.

    A step either points at a real asset (`target_asset_id`, resolved against
    the facility's own 3D scene so training uses live equipment rather than a
    fabricated mock-up) or at a fixed position in the scene.
    """

    id: str
    order: int = Field(ge=1)
    title: str = Field(min_length=1, max_length=200)
    instruction: str = Field(min_length=1, max_length=1000)
    action: TrainingStepAction
    target_asset_id: str | None = None
    target_position: list[float] | None = None
    # For `choose` steps: the options offered and which one is correct.
    options: list[str] = Field(default_factory=list)
    correct_option: str | None = None
    # Seconds allowed before an emergency drill step counts as failed. Null
    # means untimed, which is every non-drill step.
    time_limit_seconds: int | None = Field(default=None, ge=1)


class TrainingModule(TenantDoc):
    """A guided VR scenario bound to one facility's 3D scene."""

    id: str
    title: str = Field(min_length=1, max_length=200)
    kind: TrainingModuleKind
    facility_id: str
    description: str = Field(min_length=1, max_length=2000)
    steps: list[TrainingStep] = Field(default_factory=list)
    estimated_minutes: int = Field(ge=1)
    # Percentage of scored steps needed to pass.
    pass_threshold: int = Field(default=80, ge=0, le=100)
    created_by: str
    deleted_at: datetime | None = None


class TrainingModuleCreate(StrictModel):
    id: str
    title: str = Field(min_length=1, max_length=200)
    kind: TrainingModuleKind
    facility_id: str
    description: str = Field(min_length=1, max_length=2000)
    steps: list[TrainingStep] = Field(default_factory=list)
    estimated_minutes: int = Field(ge=1)
    pass_threshold: int = Field(default=80, ge=0, le=100)


class TrainingProgress(TenantDoc):
    """One trainee's run of one module.

    Progress is personal, like a notification: the service only ever returns
    rows whose `user_id` matches the caller, so no new RBAC permission gates a
    trainee reading their own record.
    """

    id: str
    module_id: str
    user_id: str
    status: TrainingProgressStatus = "in_progress"
    completed_step_ids: list[str] = Field(default_factory=list)
    # Scored steps answered correctly, over scored steps attempted.
    correct_count: int = Field(default=0, ge=0)
    scored_count: int = Field(default=0, ge=0)
    score: int | None = Field(default=None, ge=0, le=100)
    attempts: int = Field(default=1, ge=1)
    started_at: datetime
    completed_at: datetime | None = None
    created_by: str


class TrainingProgressCreate(StrictModel):
    id: str
    module_id: str
    user_id: str
    status: TrainingProgressStatus = "in_progress"
    started_at: datetime
    attempts: int = Field(default=1, ge=1)
