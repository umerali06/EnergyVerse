from google.cloud.firestore_v1 import ArrayRemove, ArrayUnion, FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import Asset, AssetCreate, AssetMedia, AssetUpdate

# Backstop against an unbounded tenant, matching the D-019/3.4 in-memory read-cap
# convention -- the Firestore query itself is already bounded by company_id plus
# at most one equality filter, but this guards the worst case (no filter at all).
ASSET_QUERY_CAP = 5000


class AssetRepository(TenantRepository[Asset]):
    collection_name = "assets"
    target_type = "asset"
    model_type = Asset

    async def create(
        self,
        scope: CompanyScope,
        payload: AssetCreate,
        actor_uid: str,
    ) -> Asset:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def update(
        self,
        scope: CompanyScope,
        asset_id: str,
        payload: AssetUpdate,
        actor_uid: str,
    ) -> Asset:
        return await self._update(
            scope,
            asset_id,
            payload.model_dump(exclude_unset=True),
            actor_uid,
        )

    async def soft_delete(self, scope: CompanyScope, asset_id: str, actor_uid: str) -> Asset:
        return await self._soft_delete(scope, asset_id, actor_uid)

    async def get_by_qr_code(self, code: str) -> Asset | None:
        """Cross-tenant lookup by the opaque `qr_code_id` -- the scanning
        user's company isn't known from the code alone, so this deliberately
        bypasses `CompanyScope`; the caller (service layer) is responsible
        for rejecting a match that belongs to a different company."""
        query = self._collection.where(filter=FieldFilter("qr_code_id", "==", code))
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None:
                return self.model_type.model_validate(data)
        return None

    async def list_missing_qr_codes(self) -> list[Asset]:
        """Every active asset (any company) without a `qr_code_id` yet --
        used by the one-time backfill script for assets created before
        Phase 4.5 started generating one at creation time."""
        query = self._collection.where(filter=FieldFilter("qr_code_id", "==", None))
        query = query.where(filter=FieldFilter("deleted_at", "==", None))
        documents = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None:
                documents.append(self.model_type.model_validate(data))
        return documents

    async def backfill_qr_code(
        self, scope: CompanyScope, asset_id: str, qr_code_id: str, actor_uid: str
    ) -> Asset:
        await self._collection.document(asset_id).update(
            {"qr_code_id": qr_code_id, "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, asset_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="asset.qr_backfilled",
            target_id=asset_id,
            metadata={"qr_code_id": qr_code_id},
        )
        return updated

    async def record_scan(self, scope: CompanyScope, asset_id: str, actor_uid: str) -> None:
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="asset.qr_scanned",
            target_id=asset_id,
            metadata={},
        )

    async def append_media(
        self, scope: CompanyScope, asset_id: str, media: AssetMedia, actor_uid: str
    ) -> Asset:
        current = await self.get(scope, asset_id)
        if current is None:
            raise LookupError("asset not found in company scope")
        field = f"{media.kind}s" if media.kind != "manual" else "manuals"
        await self._collection.document(asset_id).update(
            {field: ArrayUnion([media.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, asset_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="asset.media_uploaded",
            target_id=asset_id,
            metadata={"media": media.model_dump(mode="json")},
        )
        return updated

    async def remove_media(
        self, scope: CompanyScope, asset_id: str, media: AssetMedia, actor_uid: str
    ) -> Asset:
        field = f"{media.kind}s" if media.kind != "manual" else "manuals"
        await self._collection.document(asset_id).update(
            {field: ArrayRemove([media.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, asset_id)
        if updated is None:
            raise LookupError("asset not found in company scope")
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="asset.media_deleted",
            target_id=asset_id,
            metadata={"media": media.model_dump(mode="json")},
        )
        return updated

    async def count(
        self,
        scope: CompanyScope,
        *,
        facility_id: str | None = None,
        category: str | None = None,
        current_status: str | None = None,
    ) -> int:
        """Firestore `count()` aggregation -- billed per ~1000 matched docs
        (minimum 1), never downloads a document. Every filter here (including
        `deleted_at == None`) is a plain equality filter, so this needs no
        composite index: Firestore only requires one when a range/inequality
        filter is combined with another filter or an `order_by` (see D-039).
        """
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        query = query.where(filter=FieldFilter("deleted_at", "==", None))
        if facility_id is not None:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        if category is not None:
            query = query.where(filter=FieldFilter("category", "==", category))
        if current_status is not None:
            query = query.where(filter=FieldFilter("current_status", "==", current_status))
        result = await query.count().get(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None)
        return int(result[0][0].value)

    async def query(
        self,
        scope: CompanyScope,
        *,
        facility_id: str | None,
        category: str | None,
        current_status: str | None,
    ) -> list[Asset]:
        """One Firestore-level bounded read: company_id plus at most one equality
        filter (priority facility_id > category > current_status), ordered by
        created_at desc. The three composite indexes this needs are committed in
        firestore.indexes.json. Any other filter/sort/search the caller wants is
        applied in-memory by the service over this already-bounded result, per the
        D-019/D-029 bounded-read-plus-in-memory-filter precedent.
        """
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if facility_id is not None:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        elif category is not None:
            query = query.where(filter=FieldFilter("category", "==", category))
        elif current_status is not None:
            query = query.where(filter=FieldFilter("current_status", "==", current_status))
        query = query.order_by("created_at", direction="DESCENDING")

        documents = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                documents.append(self.model_type.model_validate(data))
            if len(documents) >= ASSET_QUERY_CAP:
                break
        return documents
