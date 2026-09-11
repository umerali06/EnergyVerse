import argparse
import asyncio
import uuid
from dataclasses import dataclass, field
from datetime import datetime, timedelta

from google.cloud.firestore_v1.async_client import AsyncClient

from app.assets.qr import generate_unique_qr_code_id
from app.audit.service import AuditService
from app.auth.admin import AuthAdmin
from app.auth.provisioning import UserProvisioningService
from app.core.settings import settings
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.documents import DocumentRepository
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.inspections import InspectionRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.permit_templates import PermitTemplateRepository
from app.db.repositories.permits import PermitRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.training import TrainingModuleRepository
from app.db.repositories.users import UserRepository
from app.db.repositories.work_orders import WorkOrderRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    AreaCreate,
    AreaUpdate,
    AssetCreate,
    AssetUpdate,
    ChecklistResponse,
    ChecklistTemplateCreate,
    ChecklistTemplateItem,
    CompanyCreate,
    CompanyUpdate,
    DocumentCreate,
    FacilityCreate,
    FacilityUpdate,
    InspectionCreate,
    PermissionCreate,
    PermissionUpdate,
    PermitApprovalSnapshotStep,
    PermitApprovalTemplateStep,
    PermitChecklistSnapshotItem,
    PermitChecklistTemplateItem,
    PermitCreate,
    PermitRiskAssessmentItem,
    PermitRiskBand,
    PermitTemplateCreate,
    RoleCreate,
    RolePermission,
    RolePermissionCreate,
    RoleUpdate,
    SeedCounts,
    TrainingModuleCreate,
    TrainingStep,
    UserCreate,
    UserUpdate,
    WorkOrderCreate,
)
from app.rbac.constants import PERMISSION_CATALOG, SYSTEM_ROLE_TEMPLATES, SystemRoleTemplate
from app.rbac.seeding import (
    seed_system_roles,
    system_role_id,
    system_role_permission_id,
)

SEED_ACTOR_UID = "system:seed"
ACME_COMPANY_ID = "acme-energy"
SECOND_COMPANY_ID = "beta-utilities"
FIELD_INSPECTOR_UID = "demo-acme-field_inspector"
MAINTENANCE_TECHNICIAN_UID = "demo-acme-maintenance_technician"


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

# 4.1 demo facility/area/asset hierarchy -- deliberately demo-flagged data for
# ACME_COMPANY_ID only, so 4.2's UI has real data to render. Deterministic IDs
# keep re-running the seed idempotent rather than duplicating rows.
FACILITY_NORTH_REFINERY_ID = f"{ACME_COMPANY_ID}__facility__north-refinery"
FACILITY_COMPRESSOR_STATION_ID = f"{ACME_COMPANY_ID}__facility__compressor-station-2"

AREA_TANK_FARM_A_ID = f"{ACME_COMPANY_ID}__area__tank-farm-a"
AREA_PROCESS_UNIT_1_ID = f"{ACME_COMPANY_ID}__area__process-unit-1"
AREA_COMPRESSOR_BUILDING_ID = f"{ACME_COMPANY_ID}__area__compressor-building"
AREA_YARD_ID = f"{ACME_COMPANY_ID}__area__yard"


@dataclass(frozen=True)
class DemoFacilitySeed:
    id: str
    name: str
    sector: str
    gps_lat: float
    gps_lng: float
    address: str
    timezone: str


DEMO_FACILITIES = (
    DemoFacilitySeed(
        id=FACILITY_NORTH_REFINERY_ID,
        name="North Refinery",
        sector="Oil & Gas Refining",
        gps_lat=29.7604,
        gps_lng=-95.3698,
        address="1000 Refinery Rd, Houston, TX",
        timezone="America/Chicago",
    ),
    DemoFacilitySeed(
        id=FACILITY_COMPRESSOR_STATION_ID,
        name="Compressor Station 2",
        sector="Midstream / Pipeline",
        gps_lat=31.9686,
        gps_lng=-99.9018,
        address="200 Pipeline Way, Abilene, TX",
        timezone="America/Chicago",
    ),
)


@dataclass(frozen=True)
class DemoAreaSeed:
    id: str
    facility_id: str
    name: str
    code: str


DEMO_AREAS = (
    DemoAreaSeed(
        id=AREA_TANK_FARM_A_ID,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        name="Tank Farm A",
        code="TFA",
    ),
    DemoAreaSeed(
        id=AREA_PROCESS_UNIT_1_ID,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        name="Process Unit 1",
        code="PU1",
    ),
    DemoAreaSeed(
        id=AREA_COMPRESSOR_BUILDING_ID,
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        name="Compressor Building",
        code="CB1",
    ),
    DemoAreaSeed(
        id=AREA_YARD_ID,
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        name="Yard",
        code="YARD",
    ),
)


@dataclass(frozen=True)
class DemoAssetSeed:
    id: str
    facility_id: str
    area_id: str | None
    parent_asset_id: str | None
    asset_tag: str
    name: str
    category: str
    category_other: str | None
    manufacturer: str | None
    model: str | None
    current_status: str


ASSET_FEED_PUMP_ID = f"{ACME_COMPANY_ID}__asset__p-101"

DEMO_ASSETS = (
    DemoAssetSeed(
        id=ASSET_FEED_PUMP_ID,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=AREA_PROCESS_UNIT_1_ID,
        parent_asset_id=None,
        asset_tag="P-101",
        name="Feed Pump 101",
        category="Pumps",
        category_other=None,
        manufacturer="Flowserve",
        model="RM 300",
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__c-201",
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=AREA_COMPRESSOR_BUILDING_ID,
        parent_asset_id=None,
        asset_tag="C-201",
        name="Reciprocating Compressor 201",
        category="Compressors",
        category_other=None,
        manufacturer="Ariel",
        model="JGK/4",
        current_status="Warning",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__t-301",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=AREA_TANK_FARM_A_ID,
        parent_asset_id=None,
        asset_tag="T-301",
        name="Crude Storage Tank 301",
        category="Tanks",
        category_other=None,
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__v-401",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=AREA_PROCESS_UNIT_1_ID,
        parent_asset_id=None,
        asset_tag="V-401",
        name="Pressure Relief Valve 401",
        category="Valves",
        category_other=None,
        manufacturer="Emerson",
        model=None,
        current_status="Critical",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__m-501",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=AREA_PROCESS_UNIT_1_ID,
        parent_asset_id=ASSET_FEED_PUMP_ID,
        asset_tag="M-501",
        name="Pump Drive Motor 501",
        category="Motors",
        category_other=None,
        manufacturer="WEG",
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__ep-601",
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=AREA_COMPRESSOR_BUILDING_ID,
        parent_asset_id=None,
        asset_tag="EP-601",
        name="Main Electrical Panel",
        category="Electrical Panels",
        category_other=None,
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__g-701",
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=AREA_YARD_ID,
        parent_asset_id=None,
        asset_tag="G-701",
        name="Backup Generator 701",
        category="Generators",
        category_other=None,
        manufacturer="Caterpillar",
        model=None,
        current_status="Warning",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__xf-801",
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=AREA_YARD_ID,
        parent_asset_id=None,
        asset_tag="XF-801",
        name="Step-Down Transformer 801",
        category="Transformers",
        category_other=None,
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__wh-901",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=AREA_TANK_FARM_A_ID,
        parent_asset_id=None,
        asset_tag="WH-901",
        name="Wellhead 901",
        category="Wellheads",
        category_other=None,
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__pl-001",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        area_id=None,
        parent_asset_id=None,
        asset_tag="PL-001",
        name="Crude Transfer Pipeline",
        category="Pipelines",
        category_other=None,
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
    DemoAssetSeed(
        id=f"{ACME_COMPANY_ID}__asset__x-999",
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        area_id=None,
        parent_asset_id=None,
        asset_tag="X-999",
        name="Custom Skid Unit",
        category="Other",
        category_other="Modular Skid Assembly",
        manufacturer=None,
        model=None,
        current_status="Healthy",
    ),
)


# 7.1 demo checklist templates + inspections -- deterministic uuid5 ids so the
# seed satisfies the same UUID validation the inspections API enforces on
# client-generated ids, while staying idempotent across re-runs.
def _deterministic_id(slug: str) -> str:
    return str(uuid.uuid5(uuid.NAMESPACE_DNS, f"{ACME_COMPANY_ID}:{slug}"))


CHECKLIST_TEMPLATE_GENERIC_ID = _deterministic_id("checklist_template:generic")
CHECKLIST_TEMPLATE_PUMP_ID = _deterministic_id("checklist_template:pump")
CHECKLIST_TEMPLATE_TANK_ID = _deterministic_id("checklist_template:tank")

GENERIC_CHECKLIST_ITEMS = (
    ChecklistTemplateItem(
        id="visual_condition",
        label="Visual condition acceptable",
        item_type="boolean",
        required=True,
        help_text="Check for obvious physical damage or wear",
    ),
    ChecklistTemplateItem(
        id="leaks_observed",
        label="Any leaks observed",
        item_type="boolean",
        required=True,
    ),
    ChecklistTemplateItem(
        id="notes",
        label="Additional notes",
        item_type="text",
        required=False,
    ),
)

PUMP_CHECKLIST_ITEMS = (
    ChecklistTemplateItem(
        id="vibration_normal",
        label="Vibration within normal range",
        item_type="boolean",
        required=True,
    ),
    ChecklistTemplateItem(
        id="bearing_temp_f",
        label="Bearing temperature (°F)",
        item_type="numeric",
        required=True,
        help_text="Record in degrees Fahrenheit",
    ),
    ChecklistTemplateItem(
        id="seal_condition",
        label="Seal condition",
        item_type="select",
        required=True,
        options=["Good", "Fair", "Poor"],
    ),
    ChecklistTemplateItem(
        id="notes",
        label="Additional notes",
        item_type="text",
        required=False,
    ),
)

TANK_CHECKLIST_ITEMS = (
    ChecklistTemplateItem(
        id="shell_integrity",
        label="Shell integrity acceptable",
        item_type="boolean",
        required=True,
    ),
    ChecklistTemplateItem(
        id="level_gauge_functioning",
        label="Level gauge functioning",
        item_type="boolean",
        required=True,
    ),
    ChecklistTemplateItem(
        id="corrosion_observed",
        label="Corrosion observed",
        item_type="select",
        required=True,
        options=["None", "Minor", "Moderate", "Severe"],
    ),
    ChecklistTemplateItem(
        id="notes",
        label="Additional notes",
        item_type="text",
        required=False,
    ),
)


@dataclass(frozen=True)
class DemoChecklistTemplateSeed:
    id: str
    name: str
    category: str
    description: str
    items: tuple[ChecklistTemplateItem, ...]


DEMO_CHECKLIST_TEMPLATES = (
    DemoChecklistTemplateSeed(
        id=CHECKLIST_TEMPLATE_GENERIC_ID,
        name="Generic Inspection Checklist",
        category="Generic",
        description="Baseline checklist for any asset category.",
        items=GENERIC_CHECKLIST_ITEMS,
    ),
    DemoChecklistTemplateSeed(
        id=CHECKLIST_TEMPLATE_PUMP_ID,
        name="Pump Inspection Checklist",
        category="Pumps",
        description="Routine pump condition checklist.",
        items=PUMP_CHECKLIST_ITEMS,
    ),
    DemoChecklistTemplateSeed(
        id=CHECKLIST_TEMPLATE_TANK_ID,
        name="Tank Inspection Checklist",
        category="Tanks",
        description="Routine storage tank condition checklist.",
        items=TANK_CHECKLIST_ITEMS,
    ),
)


@dataclass(frozen=True)
class DemoChecklistResponseSeed:
    item_id: str
    value: str | float | bool
    note: str | None = None


@dataclass(frozen=True)
class DemoInspectionSeed:
    id: str
    asset_id: str
    inspection_type: str
    title: str | None
    notes: str | None
    template_id: str | None
    target_status: str
    responses: tuple[DemoChecklistResponseSeed, ...] = field(default_factory=tuple)


DEMO_INSPECTIONS = (
    DemoInspectionSeed(
        id=_deterministic_id("inspection:pump-101-completed"),
        asset_id=ASSET_FEED_PUMP_ID,
        inspection_type="routine",
        title="Q3 Routine Pump Inspection",
        notes="Completed during the scheduled maintenance window.",
        template_id=CHECKLIST_TEMPLATE_PUMP_ID,
        target_status="completed",
        responses=(
            DemoChecklistResponseSeed(item_id="vibration_normal", value=True),
            DemoChecklistResponseSeed(item_id="bearing_temp_f", value=142.5),
            DemoChecklistResponseSeed(item_id="seal_condition", value="Good"),
            DemoChecklistResponseSeed(item_id="notes", value="No issues found."),
        ),
    ),
    DemoInspectionSeed(
        id=_deterministic_id("inspection:tank-301-in-progress"),
        asset_id=f"{ACME_COMPANY_ID}__asset__t-301",
        inspection_type="scheduled",
        title="Tank 301 Scheduled Inspection",
        notes=None,
        template_id=CHECKLIST_TEMPLATE_TANK_ID,
        target_status="in_progress",
        responses=(DemoChecklistResponseSeed(item_id="shell_integrity", value=True),),
    ),
    DemoInspectionSeed(
        id=_deterministic_id("inspection:compressor-201-draft"),
        asset_id=f"{ACME_COMPANY_ID}__asset__c-201",
        inspection_type="ad_hoc",
        title=None,
        notes=None,
        template_id=None,
        target_status="draft",
        responses=(),
    ),
)


@dataclass(frozen=True)
class DemoWorkOrderSeed:
    id: str
    asset_id: str
    title: str
    description: str | None
    priority: str
    target_status: str
    technician_id: str | None = None
    completion_notes: str | None = None
    labor_hours: float | None = None
    materials_used: tuple[str, ...] = field(default_factory=tuple)


DEMO_WORK_ORDERS = (
    DemoWorkOrderSeed(
        id=_deterministic_id("work_order:pump-101-open"),
        asset_id=ASSET_FEED_PUMP_ID,
        title="Replace worn bearing seal",
        description="Inspection flagged early-stage wear on the flange bearing seal.",
        priority="medium",
        target_status="open",
    ),
    DemoWorkOrderSeed(
        id=_deterministic_id("work_order:tank-301-assigned"),
        asset_id=f"{ACME_COMPANY_ID}__asset__t-301",
        title="Recoat shell corrosion patch",
        description=None,
        priority="high",
        target_status="assigned",
        technician_id=MAINTENANCE_TECHNICIAN_UID,
    ),
    DemoWorkOrderSeed(
        id=_deterministic_id("work_order:compressor-201-in-progress"),
        asset_id=f"{ACME_COMPANY_ID}__asset__c-201",
        title="Replace compressor drive belt",
        description="Belt showing visible fraying during last inspection.",
        priority="high",
        target_status="in_progress",
        technician_id=MAINTENANCE_TECHNICIAN_UID,
    ),
    DemoWorkOrderSeed(
        id=_deterministic_id("work_order:pump-101-pending-review"),
        asset_id=ASSET_FEED_PUMP_ID,
        title="Lubricate feed pump coupling",
        description=None,
        priority="low",
        target_status="pending_review",
        technician_id=MAINTENANCE_TECHNICIAN_UID,
        completion_notes="Coupling lubricated and re-torqued to spec.",
        labor_hours=1.5,
        materials_used=("Grease cartridge (NLGI 2)",),
    ),
    DemoWorkOrderSeed(
        id=_deterministic_id("work_order:tank-301-closed"),
        asset_id=f"{ACME_COMPANY_ID}__asset__t-301",
        title="Replace pressure relief valve",
        description="Valve failed function test during scheduled inspection.",
        priority="critical",
        target_status="closed",
        technician_id=MAINTENANCE_TECHNICIAN_UID,
        completion_notes="Valve replaced with OEM part and function-tested.",
        labor_hours=3.0,
        materials_used=("Pressure relief valve (OEM #4471-A)",),
    ),
)


@dataclass(frozen=True)
class DemoDocumentSeed:
    id: str
    title: str
    document_code: str
    category: str
    description: str
    file_path: str
    filename: str
    file_format: str
    file_size_bytes: int
    facility_id: str | None = None
    asset_id: str | None = None
    tags: tuple[str, ...] = field(default_factory=tuple)


DEMO_DOCUMENTS = (
    DemoDocumentSeed(
        id=_deterministic_id("doc:sop-001"),
        title="High Pressure Feed Pump Operation & Safety SOP",
        document_code="DOC-SOP-001",
        category="sop",
        description=(
            "Standard operating procedure for pre-start inspection, startup sequence, normal "
            "operation, and emergency shutdown of Feed Pump P-101."
        ),
        file_path="sops/DOC-SOP-001_feed_pump_sop.pdf",
        filename="DOC-SOP-001_feed_pump_sop.pdf",
        file_format="pdf",
        file_size_bytes=2450120,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        asset_id=ASSET_FEED_PUMP_ID,
        tags=("SOP", "P-101", "Safety", "High Pressure"),
    ),
    DemoDocumentSeed(
        id=_deterministic_id("doc:man-201"),
        title="Ariel JGK/4 Compressor Technical Specification & Maintenance Manual",
        document_code="DOC-MAN-201",
        category="manual",
        description=(
            "Original OEM technical specifications, lubrication guidelines, torque settings, "
            "and preventive maintenance manual for Reciprocating Compressor C-201."
        ),
        file_path="manuals/DOC-MAN-201_ariel_compressor_manual.pdf",
        filename="DOC-MAN-201_ariel_compressor_manual.pdf",
        file_format="pdf",
        file_size_bytes=8910400,
        facility_id=FACILITY_COMPRESSOR_STATION_ID,
        asset_id=f"{ACME_COMPANY_ID}__asset__c-201",
        tags=("Manual", "Compressor", "Ariel", "C-201"),
    ),
    DemoDocumentSeed(
        id=_deterministic_id("doc:pol-101"),
        title="Site HSE Safety Policy & Hazardous Chemical Exposure Standard",
        document_code="DOC-POL-101",
        category="safety_policy",
        description=(
            "Site-wide health, safety, and environmental compliance regulations governing PPE, "
            "chemical spill containment, and emergency evacuation protocols."
        ),
        file_path="policies/DOC-POL-101_hse_safety_policy.pdf",
        filename="DOC-POL-101_hse_safety_policy.pdf",
        file_format="pdf",
        file_size_bytes=1840000,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        tags=("HSE", "Policy", "Safety", "Compliance"),
    ),
    DemoDocumentSeed(
        id=_deterministic_id("doc:crt-301"),
        title="Crude Tank T-301 Annual API 653 Integrity Certificate",
        document_code="DOC-CRT-301",
        category="certificate",
        description=(
            "Certified third-party inspection compliance certificate confirming shell "
            "thickness, foundation stability, and roof seal integrity per API 653 standards."
        ),
        file_path="certificates/DOC-CRT-301_api653_inspection.pdf",
        filename="DOC-CRT-301_api653_inspection.pdf",
        file_format="pdf",
        file_size_bytes=1120000,
        facility_id=FACILITY_NORTH_REFINERY_ID,
        asset_id=f"{ACME_COMPANY_ID}__asset__t-301",
        tags=("Certificate", "API 653", "Tank 301", "Compliance"),
    ),
)


def role_id(company_id: str, role_key: str) -> str:
    return system_role_id(company_id, role_key)


def _seed_time(*, hours: int) -> datetime:
    """A timestamp relative to now, so seeded permits are always current.

    Permits expire on a wall-clock window; fixed dates would leave every demo
    permit expired within days of being written.
    """
    return utc_now() + timedelta(hours=hours)


def role_permission_id(company_id: str, role_key: str, permission_key: str) -> str:
    return system_role_permission_id(company_id, role_key, permission_key)


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
        or existing.subscription_status != payload.subscription_status
    ):
        await repository.update(
            scope,
            CompanyUpdate(
                name=payload.name,
                status=payload.status,
                subscription_tier=payload.subscription_tier,
                subscription_status=payload.subscription_status,
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
        mapping.id: mapping for mapping in existing_mappings if mapping.role_id == document_role_id
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
        elif existing.role_id != document_role_id or existing.permission_id != permission_key:
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


async def _ensure_facility(
    repository: FacilityRepository,
    scope: CompanyScope,
    seed: DemoFacilitySeed,
) -> None:
    existing = await repository.get(scope, seed.id)
    if existing is None:
        await repository.create(
            scope,
            FacilityCreate(
                id=seed.id,
                name=seed.name,
                sector=seed.sector,
                gps_lat=seed.gps_lat,
                gps_lng=seed.gps_lng,
                address=seed.address,
                timezone=seed.timezone,
                status="active",
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.name != seed.name
        or existing.sector != seed.sector
        or existing.address != seed.address
        or existing.timezone != seed.timezone
    ):
        await repository.update(
            scope,
            seed.id,
            FacilityUpdate(
                name=seed.name,
                sector=seed.sector,
                gps_lat=seed.gps_lat,
                gps_lng=seed.gps_lng,
                address=seed.address,
                timezone=seed.timezone,
            ),
            SEED_ACTOR_UID,
        )


async def _ensure_area(
    repository: AreaRepository,
    scope: CompanyScope,
    seed: DemoAreaSeed,
) -> None:
    existing = await repository.get(scope, seed.id)
    if existing is None:
        await repository.create(
            scope,
            AreaCreate(
                id=seed.id,
                facility_id=seed.facility_id,
                name=seed.name,
                code=seed.code,
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.facility_id != seed.facility_id
        or existing.name != seed.name
        or existing.code != seed.code
    ):
        await repository.update(
            scope,
            seed.id,
            AreaUpdate(name=seed.name, code=seed.code),
            SEED_ACTOR_UID,
        )


async def _ensure_asset(
    repository: AssetRepository,
    scope: CompanyScope,
    seed: DemoAssetSeed,
) -> None:
    existing = await repository.get(scope, seed.id)
    if existing is None:
        qr_code_id = await generate_unique_qr_code_id(repository)
        await repository.create(
            scope,
            AssetCreate(
                id=seed.id,
                facility_id=seed.facility_id,
                area_id=seed.area_id,
                parent_asset_id=seed.parent_asset_id,
                asset_tag=seed.asset_tag,
                qr_code_id=qr_code_id,
                name=seed.name,
                category=seed.category,
                category_other=seed.category_other,
                manufacturer=seed.manufacturer,
                model=seed.model,
                current_status=seed.current_status,
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.facility_id != seed.facility_id
        or existing.area_id != seed.area_id
        or existing.parent_asset_id != seed.parent_asset_id
        or existing.asset_tag != seed.asset_tag
        or existing.name != seed.name
        or existing.category != seed.category
        or existing.manufacturer != seed.manufacturer
        or existing.model != seed.model
        or existing.current_status != seed.current_status
    ):
        await repository.update(
            scope,
            seed.id,
            AssetUpdate(
                facility_id=seed.facility_id,
                area_id=seed.area_id,
                parent_asset_id=seed.parent_asset_id,
                asset_tag=seed.asset_tag,
                name=seed.name,
                category=seed.category,
                category_other=seed.category_other,
                manufacturer=seed.manufacturer,
                model=seed.model,
                current_status=seed.current_status,
            ),
            SEED_ACTOR_UID,
        )


async def _ensure_checklist_template(
    repository: ChecklistTemplateRepository,
    scope: CompanyScope,
    seed: DemoChecklistTemplateSeed,
) -> None:
    existing = await repository.get(scope, seed.id)
    if existing is None:
        await repository.create(
            scope,
            ChecklistTemplateCreate(
                id=seed.id,
                name=seed.name,
                category=seed.category,
                description=seed.description,
                items=list(seed.items),
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.name != seed.name
        or existing.category != seed.category
        or existing.description != seed.description
        or tuple(existing.items) != seed.items
    ):
        await repository.update(
            scope,
            seed.id,
            {
                "name": seed.name,
                "category": seed.category,
                "description": seed.description,
                "items": [item.model_dump() for item in seed.items],
            },
            SEED_ACTOR_UID,
        )


async def _ensure_inspection(
    inspections: InspectionRepository,
    checklist_templates: ChecklistTemplateRepository,
    assets: AssetRepository,
    scope: CompanyScope,
    seed: DemoInspectionSeed,
    inspector_id: str,
) -> None:
    """Idempotent by existence check only: demo inspections are static fixture
    data walked through their real lifecycle transitions once, not reconciled
    field-by-field on re-run (unlike facilities/areas/assets) -- the lifecycle
    (draft -> template assignment -> responses -> start -> complete) is
    stateful enough that a full diff-and-patch would just re-implement the
    service layer here for no real benefit to a demo tenant."""
    existing = await inspections.get(scope, seed.id)
    if existing is not None:
        return

    asset = await assets.get(scope, seed.asset_id)
    if asset is None:
        raise ValueError(f"Demo inspection {seed.id} references unknown asset {seed.asset_id}")

    inspection, _created = await inspections.upsert_draft(
        scope,
        InspectionCreate(
            id=seed.id,
            asset_id=asset.id,
            facility_id=asset.facility_id,
            area_id=asset.area_id,
            inspector_id=inspector_id,
            status="draft",
            inspection_type=seed.inspection_type,
            title=seed.title,
            notes=seed.notes,
            gps_lat=None,
            gps_lng=None,
            client_created_at=utc_now(),
            device_id=None,
            origin="seed",
        ),
        SEED_ACTOR_UID,
    )

    if seed.template_id is not None:
        template = await checklist_templates.get(scope, seed.template_id)
        if template is None:
            raise ValueError(f"Demo inspection {seed.id} references unknown template")
        inspection = await inspections.assign_checklist_template(
            scope,
            inspection.id,
            template_id=template.id,
            template_version=template.version,
            snapshot_items=template.items,
            actor_uid=SEED_ACTOR_UID,
        )

    if seed.target_status in ("in_progress", "completed"):
        inspection = await inspections.apply_lifecycle(
            scope,
            inspection.id,
            SEED_ACTOR_UID,
            expected_statuses=frozenset({"draft"}),
            next_status="in_progress",
            extra_fields={"started_at": utc_now()},
            action="started",
        )

    if seed.responses:
        now = utc_now()
        stamped = [
            ChecklistResponse(
                item_id=response.item_id,
                value=response.value,
                note=response.note,
                answered_at=now,
                answered_by=SEED_ACTOR_UID,
            ).model_dump()
            for response in seed.responses
        ]
        inspection = await inspections.update(
            scope,
            inspection.id,
            {"checklist_responses": stamped},
            SEED_ACTOR_UID,
            expected_revision=None,
        )

    if seed.target_status == "completed":
        await inspections.apply_lifecycle(
            scope,
            inspection.id,
            SEED_ACTOR_UID,
            expected_statuses=frozenset({"draft", "in_progress"}),
            next_status="completed",
            extra_fields={"completed_at": utc_now()},
            action="completed",
        )


PERMIT_TEMPLATE_HOT_WORK_ID = f"{ACME_COMPANY_ID}__permit_template__hot-work"
PERMIT_TEMPLATE_CONFINED_SPACE_ID = f"{ACME_COMPANY_ID}__permit_template__confined-space"

PERMIT_ACTIVE_ID = f"{ACME_COMPANY_ID}__permit__hot-work-flare-line"
PERMIT_PENDING_ID = f"{ACME_COMPANY_ID}__permit__confined-space-t301"
PERMIT_DRAFT_ID = f"{ACME_COMPANY_ID}__permit__hot-work-draft"


def _permit_templates() -> tuple[PermitTemplateCreate, ...]:
    """Two real templates so the permit register is usable out of the box.

    Approval steps address roles rather than people, matching how the module
    resolves an approver at runtime -- a template outlives any individual.
    """
    return (
        PermitTemplateCreate(
            id=PERMIT_TEMPLATE_HOT_WORK_ID,
            name="Hot Work Permit",
            permit_type="hot_work",
            description=(
                "Welding, grinding, cutting or any ignition source in a "
                "classified area."
            ),
            checklist_items=[
                PermitChecklistTemplateItem(
                    id="hw-gas-test",
                    label="Atmospheric gas test completed and recorded (LEL < 5%)",
                    help_text="Re-test if work is suspended for more than 30 minutes.",
                ),
                PermitChecklistTemplateItem(
                    id="hw-isolation",
                    label="Equipment isolated, drained and purged",
                ),
                PermitChecklistTemplateItem(
                    id="hw-fire-watch",
                    label="Fire watch assigned and extinguisher within 10 m",
                ),
                PermitChecklistTemplateItem(
                    id="hw-combustibles",
                    label="Combustible material removed or protected within 15 m",
                ),
                PermitChecklistTemplateItem(
                    id="hw-ppe",
                    label="Flame-resistant PPE and eye protection verified",
                ),
            ],
            approval_steps=[
                PermitApprovalTemplateStep(
                    id="hw-approval-operations",
                    label="Operations Manager authorisation",
                    approver_role_id=role_id(ACME_COMPANY_ID, "operations_manager"),
                ),
                PermitApprovalTemplateStep(
                    id="hw-approval-hse",
                    label="HSE Manager authorisation",
                    approver_role_id=role_id(ACME_COMPANY_ID, "hse_manager"),
                ),
            ],
        ),
        PermitTemplateCreate(
            id=PERMIT_TEMPLATE_CONFINED_SPACE_ID,
            name="Confined Space Entry Permit",
            permit_type="confined_space",
            description="Entry into any tank, vessel, pit or other confined space.",
            checklist_items=[
                PermitChecklistTemplateItem(
                    id="cs-atmosphere",
                    label="Oxygen 19.5-23.5%, LEL < 5%, H2S < 10 ppm verified",
                ),
                PermitChecklistTemplateItem(
                    id="cs-isolation",
                    label="All lines blinded and energy sources locked out",
                ),
                PermitChecklistTemplateItem(
                    id="cs-attendant",
                    label="Standby attendant posted at the entry point",
                ),
                PermitChecklistTemplateItem(
                    id="cs-rescue",
                    label="Rescue plan briefed and retrieval equipment rigged",
                ),
                PermitChecklistTemplateItem(
                    id="cs-comms",
                    label="Continuous communication method agreed and tested",
                ),
            ],
            approval_steps=[
                PermitApprovalTemplateStep(
                    id="cs-approval-hse",
                    label="HSE Manager authorisation",
                    approver_role_id=role_id(ACME_COMPANY_ID, "hse_manager"),
                ),
            ],
        ),
    )


def _risk(
    item_id: str,
    hazard: str,
    persons: str,
    controls: str,
    initial: tuple[int, int],
    residual: tuple[int, int],
) -> PermitRiskAssessmentItem:
    """Build one 5x5 risk row, deriving score and band the way the module does."""

    def band(score: int) -> PermitRiskBand:
        if score >= 15:
            return "critical"
        if score >= 8:
            return "high"
        if score >= 4:
            return "medium"
        return "low"

    initial_score = initial[0] * initial[1]
    residual_score = residual[0] * residual[1]
    return PermitRiskAssessmentItem(
        id=item_id,
        hazard=hazard,
        persons_at_risk=persons,
        initial_likelihood=initial[0],
        initial_severity=initial[1],
        initial_score=initial_score,
        initial_band=band(initial_score),
        controls=controls,
        residual_likelihood=residual[0],
        residual_severity=residual[1],
        residual_score=residual_score,
        residual_band=band(residual_score),
    )


def _snapshot(
    template: PermitTemplateCreate, completed: bool
) -> tuple[list[PermitChecklistSnapshotItem], list[PermitApprovalSnapshotStep]]:
    """Freeze a template onto a permit, exactly as the service does on create."""
    checklist = [
        PermitChecklistSnapshotItem(
            id=f"snap-{item.id}",
            template_item_id=item.id,
            label=item.label,
            required=item.required,
            help_text=item.help_text,
            completed=completed,
            completed_by=FIELD_INSPECTOR_UID if completed else None,
            completed_at=_seed_time(hours=-6) if completed else None,
        )
        for item in template.checklist_items
    ]
    approvals = [
        PermitApprovalSnapshotStep(
            id=f"snap-{step.id}",
            template_step_id=step.id,
            label=step.label,
            approver_role_id=step.approver_role_id,
            required=step.required,
        )
        for step in template.approval_steps
    ]
    return checklist, approvals


def _demo_permits() -> tuple[tuple[PermitCreate, dict[str, object]], ...]:
    """Three permits spanning the lifecycle the requirements ask to be shown:
    one active, one waiting on approval, one still being drafted.

    Each is paired with the extra fields its state implies, applied after
    creation because `PermitCreate` only carries what a draft legitimately has.
    """
    hot_work, confined_space = _permit_templates()

    active_checklist, active_approvals = _snapshot(hot_work, completed=True)
    for step in active_approvals:
        step.status = "approved"
        step.signed_by = SEED_ACTOR_UID
        step.signed_at = _seed_time(hours=-5)

    pending_checklist, pending_approvals = _snapshot(confined_space, completed=True)

    draft_checklist, draft_approvals = _snapshot(hot_work, completed=False)

    return (
        (
            PermitCreate(
                id=PERMIT_ACTIVE_ID,
                permit_number="PTW-2026-0118",
                title="Flare line weld repair",
                description=(
                    "Replace the cracked 6-inch flare header spool downstream "
                    "of the knock-out drum."
                ),
                permit_type="hot_work",
                facility_id=FACILITY_NORTH_REFINERY_ID,
                asset_id=ASSET_FEED_PUMP_ID,
                valid_from=_seed_time(hours=-4),
                valid_until=_seed_time(hours=8),
                template_id=hot_work.id,
                template_name=hot_work.name,
                template_version=1,
                checklist_snapshot=active_checklist,
                approval_snapshot=active_approvals,
                risk_assessment=[
                    _risk(
                        "risk-ignition",
                        "Ignition of residual hydrocarbon in the flare header",
                        "Welder, fire watch, nearby operators",
                        "Purge to < 5% LEL, continuous gas monitoring, fire "
                        "watch posted with extinguisher and hose reel.",
                        initial=(4, 5),
                        residual=(1, 5),
                    ),
                    _risk(
                        "risk-burns",
                        "Contact burns and arc-eye from welding operations",
                        "Welder and assisting technician",
                        "Flame-resistant PPE, welding screens, dedicated "
                        "assistant briefed on the work pack.",
                        initial=(3, 3),
                        residual=(1, 3),
                    ),
                ],
                worker_ids=[MAINTENANCE_TECHNICIAN_UID, FIELD_INSPECTOR_UID],
            ),
            {
                "status": "active",
                "submitted_at": _seed_time(hours=-6),
                "activated_by": SEED_ACTOR_UID,
                "activated_at": _seed_time(hours=-4),
            },
        ),
        (
            PermitCreate(
                id=PERMIT_PENDING_ID,
                permit_number="PTW-2026-0119",
                title="Tank T-301 internal inspection entry",
                description=(
                    "Internal visual inspection of tank T-301 following the "
                    "scheduled drain and clean."
                ),
                permit_type="confined_space",
                facility_id=FACILITY_NORTH_REFINERY_ID,
                asset_id=f"{ACME_COMPANY_ID}__asset__t-301",
                valid_from=_seed_time(hours=12),
                valid_until=_seed_time(hours=24),
                template_id=confined_space.id,
                template_name=confined_space.name,
                template_version=1,
                checklist_snapshot=pending_checklist,
                approval_snapshot=pending_approvals,
                risk_assessment=[
                    _risk(
                        "risk-atmosphere",
                        "Oxygen deficiency or residual hydrocarbon vapour",
                        "Entrant and standby attendant",
                        "Continuous four-gas monitoring, forced-air "
                        "ventilation, entry aborted on any alarm.",
                        initial=(4, 5),
                        residual=(2, 5),
                    ),
                    _risk(
                        "risk-rescue",
                        "Entrant incapacitated with no means of retrieval",
                        "Entrant",
                        "Tripod and winch rigged, attendant in continuous "
                        "contact, rescue team briefed before entry.",
                        initial=(3, 5),
                        residual=(1, 5),
                    ),
                ],
                worker_ids=[FIELD_INSPECTOR_UID],
            ),
            {"status": "pending_approval", "submitted_at": _seed_time(hours=-1)},
        ),
        (
            PermitCreate(
                id=PERMIT_DRAFT_ID,
                permit_number="PTW-2026-0120",
                title="Compressor skid pipework modification",
                description=(
                    "Cut and re-route the 2-inch instrument air line on "
                    "compressor skid C-201."
                ),
                permit_type="hot_work",
                facility_id=FACILITY_COMPRESSOR_STATION_ID,
                asset_id=f"{ACME_COMPANY_ID}__asset__c-201",
                valid_from=_seed_time(hours=48),
                valid_until=_seed_time(hours=56),
                template_id=hot_work.id,
                template_name=hot_work.name,
                template_version=1,
                checklist_snapshot=draft_checklist,
                approval_snapshot=draft_approvals,
                risk_assessment=[
                    _risk(
                        "risk-stored-energy",
                        "Stored pressure released during the cut",
                        "Fitter and nearby operators",
                        "Isolate, depressurise and verify at zero before any "
                        "cut; double-block-and-bleed confirmed.",
                        initial=(3, 4),
                        residual=(1, 4),
                    ),
                ],
                worker_ids=[MAINTENANCE_TECHNICIAN_UID],
            ),
            {},
        ),
    )


async def _ensure_document(
    documents: DocumentRepository,
    scope: CompanyScope,
    seed: DemoDocumentSeed,
) -> None:
    existing = await documents.get(scope, seed.id)
    if existing is None:
        await documents.create(
            scope,
            DocumentCreate(
                id=seed.id,
                title=seed.title,
                document_code=seed.document_code,
                category=seed.category,
                description=seed.description,
                facility_id=seed.facility_id,
                asset_id=seed.asset_id,
                file_path=seed.file_path,
                filename=seed.filename,
                file_format=seed.file_format,
                file_size_bytes=seed.file_size_bytes,
                status="active",
                tags=list(seed.tags),
            ),
            SEED_ACTOR_UID,
        )
        return
    if (
        existing.title != seed.title
        or existing.document_code != seed.document_code
        or existing.category != seed.category
        or existing.description != seed.description
    ):
        await documents.update_metadata(
            scope,
            seed.id,
            {
                "title": seed.title,
                "document_code": seed.document_code,
                "category": seed.category,
                "description": seed.description,
                "tags": list(seed.tags),
            },
            SEED_ACTOR_UID,
        )


async def _ensure_work_order(
    work_orders: WorkOrderRepository,
    assets: AssetRepository,
    scope: CompanyScope,
    seed: DemoWorkOrderSeed,
) -> None:
    """Idempotent by existence check only, same posture as `_ensure_inspection`
    -- walks each fixture through its real create -> assign -> accept ->
    submit-for-review -> close transitions up to `seed.target_status`, calling
    the repository directly (bypassing `WorkOrderService`'s self-accept/
    self-submit checks, which are an authorization concern for real callers,
    not a data-integrity one for a trusted seed script)."""
    existing = await work_orders.get(scope, seed.id)
    if existing is not None:
        return

    asset = await assets.get(scope, seed.asset_id)
    if asset is None:
        raise ValueError(f"Demo work order {seed.id} references unknown asset {seed.asset_id}")

    technician_id = seed.technician_id or MAINTENANCE_TECHNICIAN_UID
    work_order = await work_orders.create(
        scope,
        WorkOrderCreate(
            id=seed.id,
            asset_id=asset.id,
            facility_id=asset.facility_id,
            title=seed.title,
            description=seed.description,
            priority=seed.priority,
            due_date=None,
            source_inspection_id=None,
        ),
        SEED_ACTOR_UID,
    )

    if seed.target_status in ("assigned", "in_progress", "pending_review", "closed"):
        work_order = await work_orders.assign(
            scope,
            work_order.id,
            technician_id=technician_id,
            due_date=None,
            actor_uid=SEED_ACTOR_UID,
            expected_revision=None,
        )

    if seed.target_status in ("in_progress", "pending_review", "closed"):
        work_order = await work_orders.accept(scope, work_order.id, technician_id)

    if seed.target_status in ("pending_review", "closed"):
        work_order = await work_orders.submit_for_review(
            scope,
            work_order.id,
            completion_notes=seed.completion_notes or "Repair completed.",
            labor_hours=seed.labor_hours,
            materials_used=list(seed.materials_used),
            actor_uid=technician_id,
            expected_revision=None,
        )

    if seed.target_status == "closed":
        await work_orders.close(scope, work_order.id, SEED_ACTOR_UID)



# --- VR training modules ------------------------------------------------------
#
# One module per competency the requirements name, each bound to the North
# Refinery's real 3D scene and its real assets, so a trainee learns the
# equipment their site actually has. `correct_option` never reaches the client
# (see TrainingStepResponse), so the answers below stay server-side.

ASSET_TANK_301_ID = f"{ACME_COMPANY_ID}__asset__t-301"
ASSET_VALVE_401_ID = f"{ACME_COMPANY_ID}__asset__v-401"
ASSET_MOTOR_501_ID = f"{ACME_COMPANY_ID}__asset__m-501"

MUSTER_POINT = [-20.0, 1.7, 25.0]

DEMO_TRAINING_MODULES = (
    TrainingModuleCreate(
        id=f"{ACME_COMPANY_ID}__training__facility-orientation",
        title="North Refinery orientation walk",
        kind="exploration",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        description=(
            "A guided walk of the North Refinery: the process unit, the tank "
            "farm and the muster point, so a new starter can orient themselves "
            "before working on site."
        ),
        estimated_minutes=8,
        steps=[
            TrainingStep(
                id="step-orientation-entry",
                order=1,
                title="Site entry",
                instruction=(
                    "You are standing at the North Refinery main gate. Look "
                    "around to take in the site layout before moving in."
                ),
                action="observe",
                target_position=[0.0, 1.7, 30.0],
            ),
            TrainingStep(
                id="step-orientation-process-unit",
                order=2,
                title="Process Unit 1",
                instruction=(
                    "Walk to Process Unit 1, where the feed pump and its drive "
                    "motor are installed."
                ),
                action="observe",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-orientation-tank-farm",
                order=3,
                title="Tank Farm A",
                instruction="Continue to Tank Farm A and note the bunding around the tank.",
                action="observe",
                target_asset_id=ASSET_TANK_301_ID,
            ),
            TrainingStep(
                id="step-orientation-muster",
                order=4,
                title="Muster point",
                instruction=(
                    "Finish at the muster point. Confirm you can find your way "
                    "here from anywhere on site."
                ),
                action="acknowledge",
                target_position=MUSTER_POINT,
            ),
        ],
    ),
    TrainingModuleCreate(
        id=f"{ACME_COMPANY_ID}__training__equipment-location",
        title="Locate critical equipment",
        kind="equipment_location",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        description=(
            "Find each item of critical equipment by tag. Scored: you are "
            "expected to know where these are without prompting."
        ),
        estimated_minutes=6,
        pass_threshold=75,
        steps=[
            TrainingStep(
                id="step-locate-p101",
                order=1,
                title="Find P-101",
                instruction="Locate Feed Pump 101 (tag P-101) and select it.",
                action="locate",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-locate-t301",
                order=2,
                title="Find T-301",
                instruction="Locate Crude Storage Tank 301 (tag T-301) and select it.",
                action="locate",
                target_asset_id=ASSET_TANK_301_ID,
            ),
            TrainingStep(
                id="step-locate-v401",
                order=3,
                title="Find V-401",
                instruction="Locate Pressure Relief Valve 401 (tag V-401) and select it.",
                action="locate",
                target_asset_id=ASSET_VALVE_401_ID,
            ),
            TrainingStep(
                id="step-locate-m501",
                order=4,
                title="Find M-501",
                instruction="Locate Pump Drive Motor 501 (tag M-501) and select it.",
                action="locate",
                target_asset_id=ASSET_MOTOR_501_ID,
            ),
        ],
    ),
    TrainingModuleCreate(
        id=f"{ACME_COMPANY_ID}__training__loto-procedure",
        title="Lock-out / tag-out on the feed pump",
        kind="safety_procedure",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        description=(
            "Isolate Feed Pump 101 safely before maintenance. Every scored "
            "step must be right: an out-of-order isolation is how people get "
            "hurt."
        ),
        estimated_minutes=10,
        pass_threshold=100,
        steps=[
            TrainingStep(
                id="step-loto-permit",
                order=1,
                title="Confirm the permit",
                instruction=(
                    "Before touching anything, confirm a valid permit to work "
                    "is in place for P-101."
                ),
                action="acknowledge",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-loto-first-action",
                order=2,
                title="First isolation action",
                instruction="What is the first action once the permit is confirmed?",
                action="choose",
                target_asset_id=ASSET_MOTOR_501_ID,
                options=[
                    "Notify the control room and request shutdown",
                    "Close the suction valve",
                    "Remove the coupling guard",
                    "Drain the casing",
                ],
                correct_option="Notify the control room and request shutdown",
            ),
            TrainingStep(
                id="step-loto-isolate",
                order=3,
                title="Isolate the drive motor",
                instruction=(
                    "Isolate Pump Drive Motor 501 at the local isolator and "
                    "apply your personal lock."
                ),
                action="sequence",
                target_asset_id=ASSET_MOTOR_501_ID,
            ),
            TrainingStep(
                id="step-loto-verify",
                order=4,
                title="Prove dead",
                instruction=(
                    "Attempt a start from the local station to prove the "
                    "isolation holds, then return the selector to off."
                ),
                action="sequence",
                target_asset_id=ASSET_MOTOR_501_ID,
            ),
            TrainingStep(
                id="step-loto-tag",
                order=5,
                title="Tag the isolation",
                instruction="Attach your tag showing your name, the date and the reason.",
                action="acknowledge",
                target_asset_id=ASSET_MOTOR_501_ID,
            ),
        ],
    ),
    TrainingModuleCreate(
        id=f"{ACME_COMPANY_ID}__training__gas-release-drill",
        title="Emergency drill: gas release at the tank farm",
        kind="emergency_drill",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        description=(
            "A timed drill. Gas is detected at Tank Farm A: raise the alarm, "
            "take the correct escape route and reach the muster point."
        ),
        estimated_minutes=5,
        pass_threshold=100,
        steps=[
            TrainingStep(
                id="step-drill-detect",
                order=1,
                title="Gas detected",
                instruction="The gas alarm sounds near T-301. Identify the source area.",
                action="locate",
                target_asset_id=ASSET_TANK_301_ID,
                time_limit_seconds=30,
            ),
            TrainingStep(
                id="step-drill-raise-alarm",
                order=2,
                title="Raise the alarm",
                instruction="What do you do first?",
                action="choose",
                options=[
                    "Raise the alarm and evacuate upwind",
                    "Investigate the leak more closely",
                    "Attempt to close the tank valve",
                    "Return to your vehicle for a gas monitor",
                ],
                correct_option="Raise the alarm and evacuate upwind",
                time_limit_seconds=20,
            ),
            TrainingStep(
                id="step-drill-route",
                order=3,
                title="Escape upwind",
                instruction="Take the upwind escape route. Do not pass downwind of the tank.",
                action="sequence",
                target_position=MUSTER_POINT,
                time_limit_seconds=60,
            ),
            TrainingStep(
                id="step-drill-muster",
                order=4,
                title="Report at muster",
                instruction="Reach the muster point and report yourself present.",
                action="acknowledge",
                target_position=MUSTER_POINT,
                time_limit_seconds=60,
            ),
        ],
    ),
    TrainingModuleCreate(
        id=f"{ACME_COMPANY_ID}__training__seal-replacement",
        title="Maintenance simulation: replace the P-101 mechanical seal",
        kind="maintenance_simulation",
        facility_id=FACILITY_NORTH_REFINERY_ID,
        description=(
            "Carry out a mechanical seal replacement on Feed Pump 101 in the "
            "correct order, from isolation through to handback."
        ),
        estimated_minutes=15,
        pass_threshold=80,
        steps=[
            TrainingStep(
                id="step-seal-isolation",
                order=1,
                title="Confirm isolation",
                instruction="Confirm P-101 is isolated and locked off before opening anything.",
                action="acknowledge",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-seal-drain",
                order=2,
                title="Drain and depressurise",
                instruction="Drain the casing and confirm zero pressure at the gauge.",
                action="sequence",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-seal-remove",
                order=3,
                title="Remove the seal",
                instruction="Remove the coupling guard, then withdraw the seal cartridge.",
                action="sequence",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-seal-fit",
                order=4,
                title="Fit the replacement",
                instruction="Fit the new cartridge and torque the gland nuts evenly.",
                action="sequence",
                target_asset_id=ASSET_FEED_PUMP_ID,
            ),
            TrainingStep(
                id="step-seal-handback",
                order=5,
                title="Hand back",
                instruction="What must happen before the pump is returned to service?",
                action="choose",
                target_asset_id=ASSET_FEED_PUMP_ID,
                options=[
                    "Remove locks, close the permit and record the work",
                    "Start the pump and watch for leaks",
                    "Leave the isolation in place for the next shift",
                    "Refit the guard only",
                ],
                correct_option="Remove locks, close the permit and record the work",
            ),
        ],
    ),
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
    facilities = FacilityRepository(firestore_client, audit)
    areas = AreaRepository(firestore_client, audit)
    assets = AssetRepository(firestore_client, audit)
    checklist_templates = ChecklistTemplateRepository(firestore_client, audit)
    inspections = InspectionRepository(firestore_client, audit)
    work_orders = WorkOrderRepository(firestore_client, audit)
    documents = DocumentRepository(firestore_client, audit)
    training_modules = TrainingModuleRepository(firestore_client, audit)
    permit_templates = PermitTemplateRepository(firestore_client, audit)
    permits = PermitRepository(firestore_client, audit)

    await asyncio.gather(
        _ensure_company(
            companies,
            CompanyCreate(
                id=ACME_COMPANY_ID,
                name="Acme Energy",
                status="active",
                # Phase 13: the demo tenant must exercise every module, so it
                # carries the richest plan. "demo" was never a published tier,
                # so it resolved to no entitlements once the gate went live.
                subscription_tier="enterprise",
                subscription_status="active",
            ),
        ),
        _ensure_company(
            companies,
            CompanyCreate(
                id=SECOND_COMPANY_ID,
                name="Beta Utilities",
                status="active",
                # Deliberately the entry tier: the second tenant already proves
                # multi-tenant isolation, and on Starter it also demonstrates
                # plan gating -- its admin holds work_orders.read and still
                # gets a 402, with no Work Orders or Permits in either client.
                subscription_tier="starter",
                subscription_status="active",
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
    acme_role_ids = await seed_system_roles(
        acme_scope,
        roles,
        role_permissions,
        actor_uid=SEED_ACTOR_UID,
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
            for role_key, template in role_entries
            for document_role_id in (acme_role_ids[role_key],)
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

    await asyncio.gather(
        *(_ensure_facility(facilities, acme_scope, facility) for facility in DEMO_FACILITIES)
    )
    await asyncio.gather(*(_ensure_area(areas, acme_scope, area) for area in DEMO_AREAS))
    await asyncio.gather(*(_ensure_asset(assets, acme_scope, asset) for asset in DEMO_ASSETS))
    await asyncio.gather(
        *(
            _ensure_checklist_template(checklist_templates, acme_scope, template)
            for template in DEMO_CHECKLIST_TEMPLATES
        )
    )
    # Sequential, not gathered: each inspection walks real lifecycle
    # transitions (draft -> template assignment -> responses -> start ->
    # complete) against the same document, so concurrent writes would race.
    for inspection_seed in DEMO_INSPECTIONS:
        await _ensure_inspection(
            inspections,
            checklist_templates,
            assets,
            acme_scope,
            inspection_seed,
            FIELD_INSPECTOR_UID,
        )

    # Sequential, not gathered: each work order walks real lifecycle
    # transitions (create -> assign -> accept -> submit-for-review -> close)
    # against the same document, same rationale as the inspections loop above.
    for work_order_seed in DEMO_WORK_ORDERS:
        await _ensure_work_order(work_orders, assets, acme_scope, work_order_seed)

    for doc_seed in DEMO_DOCUMENTS:
        await _ensure_document(documents, acme_scope, doc_seed)

    for module_seed in DEMO_TRAINING_MODULES:
        if await training_modules.get(acme_scope, module_seed.id) is None:
            await training_modules.create(acme_scope, module_seed, SEED_ACTOR_UID)

    # Permits were never seeded, so the register rendered empty on a fresh
    # tenant and the module looked unbuilt.
    for template_seed in _permit_templates():
        if await permit_templates.get(acme_scope, template_seed.id) is None:
            await permit_templates.create(acme_scope, template_seed, SEED_ACTOR_UID)

    for permit_seed, extra in _demo_permits():
        if await permits.get(acme_scope, permit_seed.id) is not None:
            continue
        await permits.create(acme_scope, permit_seed, SEED_ACTOR_UID)
        if extra:
            # `PermitCreate` only carries what a draft legitimately has, so the
            # approved/active state is stamped on afterwards.
            await firestore_client.collection("permits").document(permit_seed.id).update(
                {**extra, "updated_at": utc_now()}
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

    (
        acme_roles,
        second_roles,
        acme_mappings,
        second_mappings,
        acme_users,
        second_users,
    ) = await asyncio.gather(
        roles.list(acme_scope),
        roles.list(second_scope),
        role_permissions.list(acme_scope),
        role_permissions.list(second_scope),
        users.list(acme_scope),
        users.list(second_scope),
    )
    acme_audits, second_audits = await asyncio.gather(
        audit_logs.list(acme_scope),
        audit_logs.list(second_scope),
    )
    (
        acme_facilities,
        acme_areas,
        acme_assets,
        acme_checklist_templates,
    ) = await asyncio.gather(
        facilities.list(acme_scope),
        areas.list(acme_scope),
        assets.list(acme_scope),
        checklist_templates.list(acme_scope),
    )
    (
        acme_inspections,
        acme_work_orders,
        acme_documents,
        acme_permit_templates,
        acme_permits,
    ) = await asyncio.gather(
        inspections.list(acme_scope),
        work_orders.list(acme_scope),
        documents.list(acme_scope),
        permit_templates.list(acme_scope),
        permits.list(acme_scope),
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
        facilities=len(acme_facilities),
        areas=len(acme_areas),
        assets=len(acme_assets),
        checklist_templates=len(acme_checklist_templates),
        inspections=len(acme_inspections),
        work_orders=len(acme_work_orders),
        documents=len(acme_documents),
        permit_templates=len(acme_permit_templates),
        permits=len(acme_permits),
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
