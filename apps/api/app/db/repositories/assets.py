from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope
from app.models.entities import Asset, AssetCreate, AssetUpdate, without_none

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
            without_none(payload.model_dump()),
            actor_uid,
        )

    async def soft_delete(self, scope: CompanyScope, asset_id: str, actor_uid: str) -> Asset:
        return await self._soft_delete(scope, asset_id, actor_uid)

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
