import base64
import binascii
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.facilities import FacilityRepository
from app.models.api import (
    CreateFacilityRequest,
    FacilityDetail,
    FacilityListPage,
    UpdateFacilityRequest,
)
from app.models.base import CompanyScope
from app.models.entities import Facility, FacilityCreate, FacilityUpdate

SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at"})


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
    ) -> None:
        self._facilities = facilities
        self._areas = areas
        self._assets = assets
        self._companies = companies

    async def _active_facility(self, scope: CompanyScope, facility_id: str) -> Facility:
        facility = await self._facilities.get(scope, facility_id)
        if facility is None or facility.deleted_at is not None:
            raise FacilityManagementError(
                404, "facility_not_found", "Facility was not found"
            )
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


def get_facility_management_service() -> FacilityManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return FacilityManagementService(
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        assets=AssetRepository(client, audit),
        companies=CompanyRepository(client, audit),
    )
