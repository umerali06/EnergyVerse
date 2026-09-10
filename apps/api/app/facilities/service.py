import base64
import binascii
from datetime import UTC, datetime
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.facilities import FacilityRepository
from app.models.api import (
    CameraPreset,
    CreateFacilityRequest,
    DigitalTwinHotspotResponse,
    DigitalTwinSceneResponse,
    FacilityDetail,
    FacilityListPage,
    UpdateDigitalTwinSceneRequest,
    UpdateFacilityRequest,
)
from app.models.base import CompanyScope
from app.models.entities import Facility, FacilityCreate, FacilityUpdate

SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at"})

DEFAULT_CAMERA_PRESETS = [
    CameraPreset(
        id="cam_overhead",
        name="Overhead Overview",
        position=[0.0, 30.0, 40.0],
        target=[0.0, 0.0, 0.0],
    ),
    CameraPreset(
        id="cam_pump_station",
        name="Pump Skid Station",
        position=[-12.0, 8.0, 15.0],
        target=[-6.0, 2.0, 0.0],
    ),
    CameraPreset(
        id="cam_tank_farm",
        name="Tank Farm Area",
        position=[18.0, 12.0, 18.0],
        target=[10.0, 4.0, 0.0],
    ),
]


DEFAULT_HOTSPOT_POSITION = [0.0, 1.5, 0.0]


def _coerce_float(value: object, default: float) -> float:
    """Read a number out of a Firestore document without trusting it.

    Scene documents are hand-authored and have no schema enforcement, so a
    hotspot can carry a string, a null, or nothing at all where a number
    belongs. `float()` would raise on those and take the whole facility scene
    down with a 500; a bad single value should cost that value only.
    """
    if isinstance(value, bool) or not isinstance(value, int | float | str):
        return default
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return default
    if parsed != parsed or parsed in (float("inf"), float("-inf")):
        return default
    return parsed


def _coerce_position(value: object) -> list[float]:
    """Coerce a stored hotspot position to three finite floats."""
    if not isinstance(value, list) or len(value) != 3:
        return list(DEFAULT_HOTSPOT_POSITION)
    return [
        _coerce_float(axis, DEFAULT_HOTSPOT_POSITION[index]) for index, axis in enumerate(value)
    ]


class FacilityManagementError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.code = code
        self.message = message
        self.details = details


def _encode_cursor(facility_id: str) -> str:
    return base64.urlsafe_b64encode(facility_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise FacilityManagementError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_detail(facility: Facility) -> FacilityDetail:
    return FacilityDetail(
        id=facility.id,
        name=facility.name,
        sector=facility.sector,
        gps_lat=facility.gps_lat,
        gps_lng=facility.gps_lng,
        address=facility.address,
        timezone=facility.timezone,
        status=facility.status,
        created_at=facility.created_at,
        updated_at=facility.updated_at,
    )


class FacilityManagementService:
    def __init__(
        self,
        *,
        facilities: FacilityRepository,
        areas: AreaRepository,
        assets: AssetRepository,
        companies: CompanyRepository,
        audit: AuditService | None = None,
    ) -> None:
        self._facilities = facilities
        self._areas = areas
        self._assets = assets
        self._companies = companies
        self._audit = audit

    async def _active_facility(self, scope: CompanyScope, facility_id: str) -> Facility:
        facility = await self._facilities.get(scope, facility_id)
        if facility is None or facility.deleted_at is not None:
            raise FacilityManagementError(404, "facility_not_found", "Facility was not found")
        return facility

    async def list_facilities(
        self,
        scope: CompanyScope,
        *,
        search: str | None,
        status: str | None,
        sort: str,
        cursor: str | None,
        limit: int,
    ) -> FacilityListPage:
        if sort not in SORT_OPTIONS:
            raise FacilityManagementError(
                422,
                "invalid_sort",
                "sort must be one of name, -name, created_at, -created_at",
            )
        facilities = [
            facility
            for facility in await self._facilities.list(scope)
            if facility.deleted_at is None
        ]
        if search and search.strip():
            term = search.strip().casefold()
            facilities = [facility for facility in facilities if term in facility.name.casefold()]
        if status:
            facilities = [facility for facility in facilities if facility.status == status]

        reverse = sort.startswith("-")
        key = sort.lstrip("-")
        if key == "name":
            facilities.sort(
                key=lambda facility: (facility.name.casefold(), facility.id), reverse=reverse
            )
        else:
            facilities.sort(
                key=lambda facility: (facility.created_at, facility.id), reverse=reverse
            )

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [facility.id for facility in facilities]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(facilities)
            facilities = facilities[start:]

        page = facilities[:limit]
        items = [_to_detail(facility) for facility in page]
        next_cursor = _encode_cursor(page[-1].id) if len(facilities) > limit and page else None
        return FacilityListPage(items=items, next_cursor=next_cursor)

    async def get_facility(self, scope: CompanyScope, facility_id: str) -> FacilityDetail:
        facility = await self._active_facility(scope, facility_id)
        return _to_detail(facility)

    async def create_facility(
        self,
        scope: CompanyScope,
        request: CreateFacilityRequest,
        actor_uid: str,
    ) -> FacilityDetail:
        timezone = request.timezone
        if timezone is None:
            company = await self._companies.get(scope)
            timezone = company.timezone if company is not None else "UTC"

        facility = await self._facilities.create(
            scope,
            FacilityCreate(
                id=f"facility_{uuid4().hex}",
                name=" ".join(request.name.split()),
                sector=request.sector,
                gps_lat=request.gps_lat,
                gps_lng=request.gps_lng,
                address=request.address,
                timezone=timezone,
                status=request.status,
            ),
            actor_uid,
        )
        return _to_detail(facility)

    async def update_facility(
        self,
        scope: CompanyScope,
        facility_id: str,
        request: UpdateFacilityRequest,
        actor_uid: str,
    ) -> FacilityDetail:
        await self._active_facility(scope, facility_id)
        name = " ".join(request.name.split()) if request.name is not None else None
        facility = await self._facilities.update(
            scope,
            facility_id,
            FacilityUpdate(
                name=name,
                sector=request.sector,
                gps_lat=request.gps_lat,
                gps_lng=request.gps_lng,
                address=request.address,
                timezone=request.timezone,
                status=request.status,
            ),
            actor_uid,
        )
        return _to_detail(facility)

    async def delete_facility(self, scope: CompanyScope, facility_id: str, actor_uid: str) -> None:
        await self._active_facility(scope, facility_id)
        areas = [area for area in await self._areas.list(scope) if area.deleted_at is None]
        assets = [asset for asset in await self._assets.list(scope) if asset.deleted_at is None]
        child_areas = [area for area in areas if area.facility_id == facility_id]
        child_assets = [asset for asset in assets if asset.facility_id == facility_id]
        if child_areas or child_assets:
            raise FacilityManagementError(
                409,
                "facility_has_children",
                "Facility still has areas or assets and must be emptied first",
                {"area_count": len(child_areas), "asset_count": len(child_assets)},
            )
        await self._facilities.soft_delete(scope, facility_id, actor_uid)

    async def get_facility_3d_scene(
        self, scope: CompanyScope, facility_id: str
    ) -> DigitalTwinSceneResponse:
        facility = await self._active_facility(scope, facility_id)
        facility_assets = [
            asset
            for asset in await self._assets.list(scope)
            if asset.facility_id == facility_id and asset.deleted_at is None
        ]
        asset_map = {asset.id: asset for asset in facility_assets}

        client = self._facilities._client
        doc_ref = client.collection("digital_twin_scenes").document(
            f"{scope.company_id}:{facility_id}"
        )
        doc = await doc_ref.get()

        model_3d_url: str | None = None
        scene_type = "procedural_refinery"
        camera_presets = DEFAULT_CAMERA_PRESETS
        configured_hotspots: list[dict[str, object]] = []
        updated_at = facility.updated_at

        if doc.exists:
            data = doc.to_dict() or {}
            raw_model_url = data.get("model_3d_url")
            model_3d_url = raw_model_url if isinstance(raw_model_url, str) else None
            scene_type = str(data.get("scene_type", "procedural_refinery"))
            if "camera_presets" in data and isinstance(data["camera_presets"], list):
                camera_presets = [
                    CameraPreset(**p) for p in data["camera_presets"] if isinstance(p, dict)
                ]
            if "hotspots" in data and isinstance(data["hotspots"], list):
                configured_hotspots = [h for h in data["hotspots"] if isinstance(h, dict)]
            if "updated_at" in data and data["updated_at"]:
                raw_updated = data["updated_at"]
                if isinstance(raw_updated, datetime):
                    updated_at = raw_updated
                elif isinstance(raw_updated, str):
                    try:
                        updated_at = datetime.fromisoformat(raw_updated)
                    except ValueError:
                        pass

        hotspots_out: list[DigitalTwinHotspotResponse] = []
        configured_asset_ids: set[str] = set()

        for raw_h in configured_hotspots:
            asset_id = str(raw_h.get("asset_id", ""))
            if asset_id in asset_map:
                asset = asset_map[asset_id]
                configured_asset_ids.add(asset_id)
                position = _coerce_position(raw_h.get("position"))
                radius = _coerce_float(raw_h.get("radius"), 1.0)
                label = str(raw_h.get("label")) if raw_h.get("label") else asset.name
                hotspots_out.append(
                    DigitalTwinHotspotResponse(
                        id=str(raw_h.get("id", f"hs_{asset.id}")),
                        asset_id=asset.id,
                        asset_name=asset.name,
                        asset_tag=asset.asset_tag,
                        category=asset.category,
                        current_status=asset.current_status,
                        position=position,
                        radius=radius,
                        label=label,
                    )
                )

        # Synthesize default spatial 3D placements for facility assets not explicitly bound yet
        unplaced_assets = [
            asset for asset in facility_assets if asset.id not in configured_asset_ids
        ]
        for index, asset in enumerate(unplaced_assets):
            # Arrange unplaced assets in a spatial ring/grid layout
            col = index % 4
            row = index // 4
            x = (col - 1.5) * 8.0
            z = (row - 1.0) * 8.0
            y = 2.0 if asset.category.casefold() in {"pump", "compressor", "motor"} else 4.0
            hotspots_out.append(
                DigitalTwinHotspotResponse(
                    id=f"hs_{asset.id}",
                    asset_id=asset.id,
                    asset_name=asset.name,
                    asset_tag=asset.asset_tag,
                    category=asset.category,
                    current_status=asset.current_status,
                    position=[x, y, z],
                    radius=1.5,
                    label=asset.name,
                )
            )

        return DigitalTwinSceneResponse(
            facility_id=facility.id,
            facility_name=facility.name,
            model_3d_url=model_3d_url,
            scene_type=scene_type,
            camera_presets=camera_presets,
            hotspots=hotspots_out,
            updated_at=updated_at,
        )

    async def update_facility_3d_scene(
        self,
        scope: CompanyScope,
        facility_id: str,
        request: UpdateDigitalTwinSceneRequest,
        actor_uid: str,
    ) -> DigitalTwinSceneResponse:
        facility = await self._active_facility(scope, facility_id)
        client = self._facilities._client
        doc_ref = client.collection("digital_twin_scenes").document(
            f"{scope.company_id}:{facility_id}"
        )

        now = datetime.now(UTC)
        camera_presets = (
            [p.model_dump() for p in request.camera_presets]
            if request.camera_presets is not None
            else [p.model_dump() for p in DEFAULT_CAMERA_PRESETS]
        )
        hotspots = (
            [h.model_dump() for h in request.hotspots]
            if request.hotspots is not None
            else []
        )

        payload = {
            "facility_id": facility_id,
            "model_3d_url": request.model_3d_url,
            "scene_type": request.scene_type,
            "camera_presets": camera_presets,
            "hotspots": hotspots,
            "updated_at": now.isoformat(),
        }
        await doc_ref.set(payload, merge=True)

        if self._audit:
            await self._audit.audit(
                scope,
                action="digital_twin_scene.updated",
                actor_uid=actor_uid,
                target_type="facility",
                target_id=facility_id,
                metadata={
                    "facility_name": facility.name,
                    "scene_type": request.scene_type,
                    "hotspot_count": len(hotspots),
                },
            )

        return await self.get_facility_3d_scene(scope, facility_id)


def get_facility_management_service() -> FacilityManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return FacilityManagementService(
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        assets=AssetRepository(client, audit),
        companies=CompanyRepository(client, audit),
        audit=audit,
    )

