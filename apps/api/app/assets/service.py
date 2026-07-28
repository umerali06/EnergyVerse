import asyncio
import base64
import binascii
from pathlib import Path
from typing import Literal
from uuid import uuid4

from fastapi import UploadFile

from app.assets.constants import ASSET_CATEGORIES, is_valid_asset_category
from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.models.api import (
    AssetCategoryCount,
    AssetDashboardSummary,
    AssetDetail,
    AssetFacilityCount,
    AssetHistoryPage,
    AssetListItem,
    AssetListPage,
    AssetMediaResponse,
    CreateAssetRequest,
    UpdateAssetRequest,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import Asset, AssetCreate, AssetMedia, AssetUpdate
from app.storage.service import AssetMediaStorage, get_asset_media_storage

SORT_OPTIONS = frozenset({"name", "-name", "created_at", "-created_at", "asset_tag", "-asset_tag"})
MEDIA_RULES: dict[str, tuple[frozenset[str], int]] = {
    "photo": (frozenset({"image/jpeg", "image/png", "image/webp", "image/heic"}), 10 * 1024 * 1024),
    "document": (
        frozenset({
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "image/jpeg",
            "image/png",
            "image/webp",
        }),
        25 * 1024 * 1024,
    ),
    "manual": (
        frozenset({
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        }),
        50 * 1024 * 1024,
    ),
}


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


def _media_response(media: AssetMedia, storage: AssetMediaStorage) -> AssetMediaResponse:
    return AssetMediaResponse(
        **media.model_dump(exclude={"path"}),
        url=storage.signed_url_for(media.path),
    )


def _to_detail(asset: Asset, storage: AssetMediaStorage) -> AssetDetail:
    return AssetDetail(
        **_to_list_item(asset).model_dump(),
        description=asset.description,
        photos=[_media_response(media, storage) for media in asset.photos],
        documents=[_media_response(media, storage) for media in asset.documents],
        manuals=[_media_response(media, storage) for media in asset.manuals],
        model_3d_url=asset.model_3d_url,
    )


class AssetManagementService:
    def __init__(
        self,
        *,
        assets: AssetRepository,
        facilities: FacilityRepository,
        areas: AreaRepository,
        storage: AssetMediaStorage | None = None,
    ) -> None:
        self._assets = assets
        self._facilities = facilities
        self._areas = areas
        self._storage = storage or get_asset_media_storage()

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
        ancestor = parent
        visited: set[str] = set()
        while ancestor.parent_asset_id is not None:
            if ancestor.id in visited:
                raise AssetManagementError(
                    422, "asset_parent_cycle", "Asset hierarchy contains a cycle"
                )
            visited.add(ancestor.id)
            if ancestor.parent_asset_id == asset_id:
                raise AssetManagementError(
                    422, "asset_parent_cycle", "Parent selection would create a cycle"
                )
            next_ancestor = await self._assets.get(scope, ancestor.parent_asset_id)
            if next_ancestor is None or next_ancestor.deleted_at is not None:
                break
            ancestor = next_ancestor

    async def _require_unique_tag(
        self, scope: CompanyScope, asset_tag: str, *, excluding_id: str | None = None
    ) -> None:
        normalized = asset_tag.strip().casefold()
        for asset in await self._assets.list(scope):
            if (
                asset.deleted_at is None
                and asset.id != excluding_id
                and asset.asset_tag.strip().casefold() == normalized
            ):
                raise AssetManagementError(
                    409,
                    "asset_tag_conflict",
                    "Asset tag already exists in this company",
                    {"asset_tag": asset_tag.strip()},
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

    def _validate_gps(self, gps_lat: float | None, gps_lng: float | None) -> None:
        if (gps_lat is None) != (gps_lng is None):
            raise AssetManagementError(
                422, "incomplete_gps", "Latitude and longitude must be provided together"
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
        return _to_detail(asset, self._storage)

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
        self._validate_gps(request.gps_lat, request.gps_lng)
        await self._require_unique_tag(scope, request.asset_tag)
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
        return _to_detail(asset, self._storage)

    async def update_asset(
        self,
        scope: CompanyScope,
        asset_id: str,
        request: UpdateAssetRequest,
        actor_uid: str,
    ) -> AssetDetail:
        current = await self._active_asset(scope, asset_id)
        provided = request.model_dump(exclude_unset=True)
        for required_field in (
            "facility_id",
            "asset_tag",
            "name",
            "category",
            "current_status",
        ):
            if required_field in provided and provided[required_field] is None:
                raise AssetManagementError(
                    422,
                    "required_field_cannot_be_cleared",
                    f"{required_field} cannot be cleared",
                    {"field": required_field},
                )
        if "asset_tag" in provided and request.asset_tag is not None:
            await self._require_unique_tag(scope, request.asset_tag, excluding_id=asset_id)
        facility_id = request.facility_id or current.facility_id
        if "facility_id" in provided and request.facility_id is not None:
            await self._require_active_facility(scope, request.facility_id)

        if "area_id" in provided and request.area_id is not None:
            await self._require_area_in_facility(scope, request.area_id, facility_id)
        elif (
            "facility_id" in provided
            and "area_id" not in provided
            and current.area_id is not None
        ):
            # Facility changed but area didn't -- the existing area must still
            # belong to the new facility, or the hierarchy would be broken.
            await self._require_area_in_facility(scope, current.area_id, facility_id)

        if "parent_asset_id" in provided and request.parent_asset_id is not None:
            await self._require_valid_parent(scope, request.parent_asset_id, asset_id)

        category: str = request.category if request.category is not None else current.category
        category_other = (
            request.category_other if "category_other" in provided else current.category_other
        )
        if "category" in provided or "category_other" in provided:
            self._validate_category(category, category_other)

        gps_lat = request.gps_lat if "gps_lat" in provided else current.gps_lat
        gps_lng = request.gps_lng if "gps_lng" in provided else current.gps_lng
        self._validate_gps(gps_lat, gps_lng)

        if request.name is not None:
            provided["name"] = " ".join(request.name.split())
        if request.asset_tag is not None:
            provided["asset_tag"] = request.asset_tag.strip()
        asset = await self._assets.update(
            scope,
            asset_id,
            AssetUpdate(**provided),
            actor_uid,
        )
        return _to_detail(asset, self._storage)

    async def upload_media(
        self,
        scope: CompanyScope,
        asset_id: str,
        kind: Literal["photo", "document", "manual"],
        file: UploadFile,
        actor_uid: str,
    ) -> AssetDetail:
        await self._active_asset(scope, asset_id)
        allowed_types, max_bytes = MEDIA_RULES[kind]
        content_type = file.content_type or ""
        if content_type not in allowed_types:
            raise AssetManagementError(
                422, "invalid_media_type", f"File type is not allowed for {kind}s",
                {"content_type": content_type, "allowed_types": sorted(allowed_types)},
            )
        data = await file.read(max_bytes + 1)
        if not data:
            raise AssetManagementError(422, "empty_media", "Uploaded file is empty")
        if len(data) > max_bytes:
            raise AssetManagementError(
                413, "media_too_large", f"{kind.title()} exceeds the size limit",
                {"max_bytes": max_bytes},
            )
        filename = Path(file.filename or "upload").name
        path = self._storage.upload(
            scope.company_id, asset_id, kind, filename, data, content_type
        )
        media = AssetMedia(
            id=f"media_{uuid4().hex}",
            path=path,
            filename=filename,
            kind=kind,
            content_type=content_type,
            size=len(data),
            uploaded_by=actor_uid,
            uploaded_at=utc_now(),
        )
        try:
            asset = await self._assets.append_media(scope, asset_id, media, actor_uid)
        except Exception:
            self._storage.delete(path)
            raise
        return _to_detail(asset, self._storage)

    async def delete_media(
        self, scope: CompanyScope, asset_id: str, media_id: str, actor_uid: str
    ) -> AssetDetail:
        current = await self._active_asset(scope, asset_id)
        media = next(
            (
                item
                for item in [*current.photos, *current.documents, *current.manuals]
                if item.id == media_id
            ),
            None,
        )
        if media is None:
            raise AssetManagementError(404, "asset_media_not_found", "Asset media was not found")
        self._storage.delete(media.path)
        asset = await self._assets.remove_media(scope, asset_id, media, actor_uid)
        return _to_detail(asset, self._storage)

    async def delete_asset(self, scope: CompanyScope, asset_id: str, actor_uid: str) -> None:
        await self._active_asset(scope, asset_id)
        await self._assets.soft_delete(scope, asset_id, actor_uid)

    async def get_dashboard_summary(self, scope: CompanyScope) -> AssetDashboardSummary:
        """Every number here comes from a Firestore `count()` aggregation
        query (see `AssetRepository.count` / D-039) -- no asset document is
        ever downloaded to produce these KPIs. Category has a fixed, small
        catalog and facility count per tenant is small, so a bounded fan-out
        of cheap count queries stays fast without a full collection scan.
        """
        all_facilities = await self._facilities.list(scope)
        facilities = [facility for facility in all_facilities if facility.deleted_at is None]
        results = await asyncio.gather(
            self._assets.count(scope),
            self._assets.count(scope, current_status="Healthy"),
            self._assets.count(scope, current_status="Warning"),
            self._assets.count(scope, current_status="Critical"),
            *(self._assets.count(scope, category=category) for category in ASSET_CATEGORIES),
            *(self._assets.count(scope, facility_id=facility.id) for facility in facilities),
        )
        total, healthy, warning, critical = results[:4]
        category_counts = results[4 : 4 + len(ASSET_CATEGORIES)]
        facility_counts = results[4 + len(ASSET_CATEGORIES) :]

        return AssetDashboardSummary(
            total=total,
            healthy=healthy,
            warning=warning,
            critical=critical,
            by_category=[
                AssetCategoryCount(category=category, count=count)
                for category, count in zip(ASSET_CATEGORIES, category_counts, strict=True)
            ],
            by_facility=[
                AssetFacilityCount(
                    facility_id=facility.id, facility_name=facility.name, count=count
                )
                for facility, count in zip(facilities, facility_counts, strict=True)
            ],
        )


def get_asset_management_service() -> AssetManagementService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return AssetManagementService(
        assets=AssetRepository(client, audit),
        facilities=FacilityRepository(client, audit),
        areas=AreaRepository(client, audit),
        storage=get_asset_media_storage(),
    )
