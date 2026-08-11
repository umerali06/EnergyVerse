import argparse
import asyncio
import uuid
from dataclasses import dataclass, field

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
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.inspections import InspectionRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
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
    FacilityCreate,
    FacilityUpdate,
    InspectionCreate,
    PermissionCreate,
    PermissionUpdate,
    RoleCreate,
    RolePermission,
    RolePermissionCreate,
    RoleUpdate,
    SeedCounts,
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


def role_id(company_id: str, role_key: str) -> str:
    return system_role_id(company_id, role_key)


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
        acme_inspections,
        acme_work_orders,
    ) = await asyncio.gather(
        facilities.list(acme_scope),
        areas.list(acme_scope),
        assets.list(acme_scope),
        checklist_templates.list(acme_scope),
        inspections.list(acme_scope),
        work_orders.list(acme_scope),
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
