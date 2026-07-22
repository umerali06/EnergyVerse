import base64
import binascii
from uuid import uuid4

from app.assets.constants import is_valid_asset_category
from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.models.api import (
    AssetDetail,
    AssetHistoryPage,
    AssetListItem,
    AssetListPage,
    CreateAssetRequest,
    UpdateAssetRequest,
)
from app.models.base import CompanyScope
from app.models.entities import Asset, AssetCreate, AssetUpdate

SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at", "asset_tag", "-asset_tag"})


class AssetManagementError(Exception):
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


def _encode_cursor(asset_id: str) -> str:
    return base64.urlsafe_b64encode(asset_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise AssetManagementError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(asset: Asset) -> AssetListItem:
    return AssetListItem(
        id=asset.id,
        facility_id=asset.facility_id,
        area_id=asset.area_id,
        parent_asset_id=asset.parent_asset_id,
        asset_tag=asset.asset_tag,
        qr_code_id=asset.qr_code_id,
        name=asset.name,
        category=asset.category,
        category_other=asset.category_other,
        manufacturer=asset.manufacturer,
        model=asset.model,
        serial_number=asset.serial_number,
        installation_date=asset.installation_date,
        gps_lat=asset.gps_lat,
        gps_lng=asset.gps_lng,
        current_status=asset.current_status,
        created_at=asset.created_at,
        updated_at=asset.updated_at,
    )


def _to_detail(asset: Asset) -> AssetDetail:
    return AssetDetail(
        **_to_list_item(asset).model_dump(),
        description=asset.description,
        photos=asset.photos,
        documents=asset.documents,
        manuals=asset.manuals,
        model_3d_url=asset.model_3d_url,
    )


class AssetManagementService:
    def __init__(
        self,
        *,
        assets: AssetRepository,
        facilities: FacilityRepository,
        areas: AreaRepository,
    ) -> None:
        self._assets = assets
        self._facilities = facilities
        self._areas = areas

    async def _active_asset(self, scope: CompanyScope, asset_id: str) -> Asset:
        asset = await self._assets.get(scope, asset_id)
        if asset is None or asset.deleted_at is not None:
            raise AssetManagementError(404, "asset_not_found", "Asset was not found")
        return asset

    async def _require_active_facility(self, scope: CompanyScope, facility_id: str) -> None:
        facility = await self._facilities.get(scope, facility_id)
        if facility is None or facility.deleted_at is not None:
            raise AssetManagementError(
                404, "facility_not_found", "Facility was not found in this company"
            )

    async def _require_area_in_facility(
        self, scope: CompanyScope, area_id: str, facility_id: str
    ) -> None:
        area = await self._areas.get(scope, area_id)
        if area is None or area.deleted_at is not None:
            raise AssetManagementError(404, "area_not_found", "Area was not found in this company")
        if area.facility_id != facility_id:
            raise AssetManagementError(
                422,
                "area_not_in_facility",
                "Area does not belong to the given facility",
            )

    async def _require_valid_parent(
        self, scope: CompanyScope, parent_asset_id: str, asset_id: str | None
    ) -> None:
        if parent_asset_id == asset_id:
            raise AssetManagementError(
                422, "asset_cannot_parent_itself", "An asset cannot be its own parent"
            )
        parent = await self._assets.get(scope, parent_asset_id)
        if parent is None or parent.deleted_at is not None:
            raise AssetManagementError(
                404, "parent_asset_not_found", "Parent asset was not found in this company"
            )

    def _validate_category(self, category: str, category_other: str | None) -> None:
        if not is_valid_asset_category(category):
            raise AssetManagementError(
                422,
                "invalid_category",
                "Category is not recognized",
                {"category": category},
            )
        if category == "Other" and not (category_other and category_other.strip()):
            raise AssetManagementError(
                422,
                "category_other_required",
                "category_other is required when category is 'Other'",
            )

    async def list_assets(
        self,
        scope: CompanyScope,
        *,
        facility_id: str | None,
        area_id: str | None,
        category: str | None,
        current_status: str | None,
        parent_asset_id: str | None,
        search: str | None,
        sort: str,
        cursor: str | None,
        limit: int,
    ) -> AssetListPage:
        if sort not in SORT_OPTIONS:
            raise AssetManagementError(
                422,
                "invalid_sort",
                "sort must be one of name, -name, created_at, -created_at, "
                "asset_tag, -asset_tag",
            )
        # Push at most one equality filter down to the Firestore-level, indexed
        # query (priority facility_id > category > current_status); any other
        # filter given at the same time is applied in-memory below, over that
        # already-bounded result -- see AssetRepository.query's docstring.
        assets = await self._assets.query(
            scope,
            facility_id=facility_id,
            category=None if facility_id else category,
            current_status=None if (facility_id or category) else current_status,
        )
        assets = [asset for asset in assets if asset.deleted_at is None]
        if facility_id and category:
            assets = [asset for asset in assets if asset.category == category]
        if (facility_id or category) and current_status:
            assets = [asset for asset in assets if asset.current_status == current_status]
        if area_id:
            assets = [asset for asset in assets if asset.area_id == area_id]
        if parent_asset_id:
            assets = [asset for asset in assets if asset.parent_asset_id == parent_asset_id]
        if search and search.strip():
            term = search.strip().casefold()
            assets = [
                asset
                for asset in assets
                if term in asset.name.casefold()
                or term in asset.asset_tag.casefold()
                or (asset.serial_number is not None and term in asset.serial_number.casefold())
            ]

        if sort != "-created_at":
            reverse = sort.startswith("-")
            key = sort.lstrip("-")
            if key == "name":
                assets.sort(key=lambda asset: (asset.name.casefold(), asset.id), reverse=reverse)
            elif key == "asset_tag":
                assets.sort(
                    key=lambda asset: (asset.asset_tag.casefold(), asset.id), reverse=reverse
                )
            else:
                assets.sort(key=lambda asset: (asset.created_at, asset.id), reverse=reverse)

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [asset.id for asset in assets]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(assets)
            assets = assets[start:]

        page = assets[:limit]
        items = [_to_list_item(asset) for asset in page]
        next_cursor = _encode_cursor(page[-1].id) if len(assets) > limit and page else None
        return AssetListPage(items=items, next_cursor=next_cursor)

    async def get_asset(self, scope: CompanyScope, asset_id: str) -> AssetDetail:
        asset = await self._active_asset(scope, asset_id)
        return _to_detail(asset)

    async def get_asset_history(self, scope: CompanyScope, asset_id: str) -> AssetHistoryPage:
        await self._active_asset(scope, asset_id)
        return AssetHistoryPage(items=[])

    async def create_asset(
        self,
        scope: CompanyScope,
        request: CreateAssetRequest,
        actor_uid: str,
    ) -> AssetDetail:
        self._validate_category(request.category, request.category_other)
        await self._require_active_facility(scope, request.facility_id)
        if request.area_id is not None:
            await self._require_area_in_facility(scope, request.area_id, request.facility_id)
        if request.parent_asset_id is not None:
            await self._require_valid_parent(scope, request.parent_asset_id, None)

        asset = await self._assets.create(
            scope,
            AssetCreate(
                id=f"asset_{uuid4().hex}",
                facility_id=request.facility_id,
                area_id=request.area_id,
                parent_asset_id=request.parent_asset_id,
                asset_tag=request.asset_tag.strip(),
                name=" ".join(request.name.split()),
                category=request.category,
                category_other=request.category_other,
                manufacturer=request.manufacturer,
                model=request.model,
                serial_number=request.serial_number,
                installation_date=request.installation_date,
                description=request.description,
                gps_lat=request.gps_lat,
                gps_lng=request.gps_lng,
                current_status=request.current_status,
            ),
            actor_uid,
        )
        return _to_detail(asset)

    async def update_asset(
        self,
        scope: CompanyScope,
        asset_id: str,
        request: UpdateAssetRequest,
        actor_uid: str,
    ) -> AssetDetail:
        current = await self._active_asset(scope, asset_id)
        facility_id = request.facility_id or current.facility_id
        if request.facility_id is not None:
            await self._require_active_facility(scope, request.facility_id)

        if request.area_id is not None:
            await self._require_area_in_facility(scope, request.area_id, facility_id)
        elif request.facility_id is not None and current.area_id is not None:
            # Facility changed but area didn't -- the existing area must still
            # belong to the new facility, or the hierarchy would be broken.
            await self._require_area_in_facility(scope, current.area_id, facility_id)

        if request.parent_asset_id is not None:
            await self._require_valid_parent(scope, request.parent_asset_id, asset_id)

        category = request.category if request.category is not None else current.category
        category_other = (
            request.category_other if request.category_other is not None else current.category_other
        )
        if request.category is not None:
            self._validate_category(category, category_other)

        name = " ".join(request.name.split()) if request.name is not None else None
        asset = await self._assets.update(
            scope,
            asset_id,
            AssetUpdate(
                facility_id=request.facility_id,
                area_id=request.area_id,
                parent_asset_id=request.parent_asset_id,
                asset_tag=request.asset_tag.strip() if request.asset_tag is not None else None,
                name=name,
                category=request.category,
                category_other=request.category_other,
                manufacturer=request.manufacturer,
                model=request.model,
                serial_number=request.serial_number,
                installation_date=request.installation_date,
                description=request.description,
                gps_lat=request.gps_lat,
                gps_lng=request.gps_lng,
                current_status=request.current_status,
            ),
            actor_uid,
        )
        return _to_detail(asset)

    async def delete_asset(self, scope: CompanyScope, asset_id: str, actor_uid: str) -> None:
        await self._active_asset(scope, asset_id)
        await self._assets.soft_delete(scope, asset_id, actor_uid)


def get_asset_management_service() -> AssetManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return AssetManagementService(
        assets=AssetRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
    )
