from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, tenant_creation_fields, utc_now
from app.models.entities import ChecklistTemplateItem, Inspection, InspectionCreate

# Matches the D-019/3.4/4.1 in-memory read-cap convention -- the Firestore
# query itself is already bounded by company_id plus at most one equality
# filter, but this guards the worst case (no filter at all).
INSPECTION_QUERY_CAP = 5000

IDENTITY_FIELDS = (
    "asset_id",
    "inspection_type",
    "title",
    "notes",
    "gps_lat",
    "gps_lng",
    "client_created_at",
    "device_id",
    "origin",
)


class RevisionConflictError(Exception):
    def __init__(self, current: Inspection) -> None:
        super().__init__("Inspection revision does not match the current record")
        self.current = current


class InvalidTransitionError(Exception):
    def __init__(self, current: Inspection) -> None:
        super().__init__(f"Inspection cannot transition from status '{current.status}'")
        self.current = current


class InspectionRepository(TenantRepository[Inspection]):
    collection_name = "inspections"
    target_type = "inspection"
    model_type = Inspection

    async def upsert_draft(
        self,
        scope: CompanyScope,
        payload: InspectionCreate,
        actor_uid: str,
    ) -> tuple[Inspection, bool]:
        """Idempotent create keyed by the client-generated id (D-0xx sync
        contract): a byte-identical resubmit is a true no-op (same record,
        same revision, no audit entry); a resubmit with different identity
        fields conflicts; a fresh id creates normally at revision 1."""
        reference = self._collection.document(payload.id)
        existing = await reference.get(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        if existing.exists:
            existing_data = existing.to_dict() or {}
            if existing_data.get("company_id") != scope.company_id:
                raise PermissionError("Inspection ID belongs to another company")
            current = self.model_type.model_validate(existing_data)
            payload_values = payload.model_dump()
            if all(
                getattr(current, field) == payload_values[field] for field in IDENTITY_FIELDS
            ):
                return current, False
            raise ValueError("inspection already exists with different data")

        data = {
            **payload.model_dump(),
            "revision": 1,
            **tenant_creation_fields(scope, actor_uid),
        }
        model = self.model_type.model_validate(data)
        await reference.set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.created",
            target_id=payload.id,
            metadata={"after": model.model_dump(mode="json")},
        )
        return model, True

    async def update(
        self,
        scope: CompanyScope,
        inspection_id: str,
        changes: dict[str, object],
        actor_uid: str,
        *,
        expected_revision: int | None,
    ) -> Inspection:
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        if expected_revision is not None and expected_revision != current.revision:
            raise RevisionConflictError(current)

        protected = {"id", "company_id", "created_at", "created_by", "updated_at", "revision"}
        applied = {key: value for key, value in changes.items() if key not in protected}
        merged = {**current.model_dump(), **applied}
        if merged == current.model_dump():
            return current

        merged["revision"] = current.revision + 1
        merged["updated_at"] = utc_now()
        model = self.model_type.model_validate(merged)
        await self._collection.document(inspection_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.updated",
            target_id=inspection_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def soft_delete(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> Inspection:
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        now = utc_now()
        data = {
            **current.model_dump(),
            "deleted_at": now,
            "updated_at": now,
            "revision": current.revision + 1,
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(inspection_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.deleted",
            target_id=inspection_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def apply_lifecycle(
        self,
        scope: CompanyScope,
        inspection_id: str,
        actor_uid: str,
        *,
        expected_statuses: frozenset[str],
        next_status: str,
        extra_fields: dict[str, object],
        action: str,
    ) -> Inspection:
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        if current.deleted_at is not None or current.status not in expected_statuses:
            raise InvalidTransitionError(current)

        data = {
            **current.model_dump(),
            **extra_fields,
            "status": next_status,
            "revision": current.revision + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(inspection_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"inspection.{action}",
            target_id=inspection_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def assign_checklist_template(
        self,
        scope: CompanyScope,
        inspection_id: str,
        *,
        template_id: str,
        template_version: int,
        snapshot_items: list[ChecklistTemplateItem],
        actor_uid: str,
        expected_revision: int | None = None,
    ) -> Inspection:
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        if expected_revision is not None and expected_revision != current.revision:
            raise RevisionConflictError(current)
        data = {
            **current.model_dump(),
            "checklist_template_id": template_id,
            "checklist_template_version": template_version,
            "checklist_items_snapshot": [item.model_dump() for item in snapshot_items],
            "checklist_responses": [],
            "revision": current.revision + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(inspection_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.checklist_template_assigned",
            target_id=inspection_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def query(
        self,
        scope: CompanyScope,
        *,
        asset_id: str | None = None,
        facility_id: str | None = None,
        status: str | None = None,
    ) -> list[Inspection]:
        """One Firestore-level bounded read: company_id plus at most one
        equality filter (priority asset_id > facility_id > status), ordered
        by created_at desc -- mirrors `AssetRepository.query` (D-019/D-029).
        Any other filter (inspector_id, date range) is applied in-memory by
        the service over this already-bounded result.
        """
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if asset_id is not None:
            query = query.where(filter=FieldFilter("asset_id", "==", asset_id))
        elif facility_id is not None:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        elif status is not None:
            query = query.where(filter=FieldFilter("status", "==", status))
        query = query.order_by("created_at", direction="DESCENDING")

        documents = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                documents.append(self.model_type.model_validate(data))
            if len(documents) >= INSPECTION_QUERY_CAP:
                break
        return documents
