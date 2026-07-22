import base64
import binascii
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.models.api import AreaDetail, AreaListPage, CreateAreaRequest, UpdateAreaRequest
from app.models.base import CompanyScope
from app.models.entities import Area, AreaCreate, AreaUpdate

SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at"})


class AreaManagementError(Exception):
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


def _encode_cursor(area_id: str) -> str:
    return base64.urlsafe_b64encode(area_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise AreaManagementError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_detail(area: Area) -> AreaDetail:
    return AreaDetail(
        id=area.id,
        facility_id=area.facility_id,
        name=area.name,
        code=area.code,
        description=area.description,
        created_at=area.created_at,
        updated_at=area.updated_at,
    )


class AreaManagementService:
    def __init__(
        self,
        *,
        areas: AreaRepository,
        facilities: FacilityRepository,
        assets: AssetRepository,
    ) -> None:
        self._areas = areas
        self._facilities = facilities
        self._assets = assets

    async def _active_area(self, scope: CompanyScope, area_id: str) -> Area:
        area = await self._areas.get(scope, area_id)
        if area is None or area.deleted_at is not None:
            raise AreaManagementError(404, "area_not_found", "Area was not found")
        return area

    async def _require_active_facility(self, scope: CompanyScope, facility_id: str) -> None:
        facility = await self._facilities.get(scope, facility_id)
        if facility is None or facility.deleted_at is not None:
            raise AreaManagementError(
                404, "facility_not_found", "Facility was not found in this company"
            )

    async def list_areas(
        self,
        scope: CompanyScope,
        *,
        facility_id: str | None,
        search: str | None,
        sort: str,
        cursor: str | None,
        limit: int,
    ) -> AreaListPage:
        if sort not in SORT_OPTIONS:
            raise AreaManagementError(
                422,
                "invalid_sort",
                "sort must be one of name, -name, created_at, -created_at",
            )
        areas = [area for area in await self._areas.list(scope) if area.deleted_at is None]
        if facility_id:
            areas = [area for area in areas if area.facility_id == facility_id]
        if search and search.strip():
            term = search.strip().casefold()
            areas = [area for area in areas if term in area.name.casefold()]

        reverse = sort.startswith("-")
        key = sort.lstrip("-")
        if key == "name":
            areas.sort(key=lambda area: (area.name.casefold(), area.id), reverse=reverse)
        else:
            areas.sort(key=lambda area: (area.created_at, area.id), reverse=reverse)

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [area.id for area in areas]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(areas)
            areas = areas[start:]

        page = areas[:limit]
        items = [_to_detail(area) for area in page]
        next_cursor = _encode_cursor(page[-1].id) if len(areas) > limit and page else None
        return AreaListPage(items=items, next_cursor=next_cursor)

    async def get_area(self, scope: CompanyScope, area_id: str) -> AreaDetail:
        area = await self._active_area(scope, area_id)
        return _to_detail(area)

    async def create_area(
        self,
        scope: CompanyScope,
        request: CreateAreaRequest,
        actor_uid: str,
    ) -> AreaDetail:
        await self._require_active_facility(scope, request.facility_id)
        area = await self._areas.create(
            scope,
            AreaCreate(
                id=f"area_{uuid4().hex}",
                facility_id=request.facility_id,
                name=" ".join(request.name.split()),
                code=request.code,
                description=request.description,
            ),
            actor_uid,
        )
        return _to_detail(area)

    async def update_area(
        self,
        scope: CompanyScope,
        area_id: str,
        request: UpdateAreaRequest,
        actor_uid: str,
    ) -> AreaDetail:
        await self._active_area(scope, area_id)
        name = " ".join(request.name.split()) if request.name is not None else None
        area = await self._areas.update(
            scope,
            area_id,
            AreaUpdate(name=name, code=request.code, description=request.description),
            actor_uid,
        )
        return _to_detail(area)

    async def delete_area(self, scope: CompanyScope, area_id: str, actor_uid: str) -> None:
        await self._active_area(scope, area_id)
        assets = [asset for asset in await self._assets.list(scope) if asset.deleted_at is None]
        child_assets = [asset for asset in assets if asset.area_id == area_id]
        if child_assets:
            raise AreaManagementError(
                409,
                "area_has_children",
                "Area still has assets and must be emptied first",
                {"asset_count": len(child_assets)},
            )
        await self._areas.soft_delete(scope, area_id, actor_uid)


def get_area_management_service() -> AreaManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return AreaManagementService(
        areas=AreaRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        assets=AssetRepository(client, audit),
    )
