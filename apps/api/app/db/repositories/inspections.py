from google.cloud.firestore_v1 import ArrayRemove, ArrayUnion, FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, tenant_creation_fields, utc_now
from app.models.entities import (
    Annotation,
    ChecklistTemplateItem,
    Inspection,
    InspectionCreate,
    InspectionMedia,
)

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

    async def append_media(
        self, scope: CompanyScope, inspection_id: str, media: InspectionMedia, actor_uid: str
    ) -> Inspection:
        """No `expected_revision`/revision bump by design (D-0xx, Phase 7.4):
        media traffic must never collide with the checklist-autosave revision
        protocol. Mirrors `AssetRepository.append_media`'s ArrayUnion pattern."""
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        await self._collection.document(inspection_id).update(
            {"media": ArrayUnion([media.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.media_attached",
            target_id=inspection_id,
            metadata={"media": media.model_dump(mode="json")},
        )
        return updated

    async def remove_media(
        self, scope: CompanyScope, inspection_id: str, media: InspectionMedia, actor_uid: str
    ) -> Inspection:
        """Idempotent: an already-removed `media` entry is a harmless
        ArrayRemove no-op, since detach replays via the mobile outbox
        at-least-once (unlike `AssetRepository.remove_media`'s sibling)."""
        await self._collection.document(inspection_id).update(
            {"media": ArrayRemove([media.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        if updated is None:
            raise LookupError("inspection not found in company scope")
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.media_detached",
            target_id=inspection_id,
            metadata={"media": media.model_dump(mode="json")},
        )
        return updated

    async def update_media(
        self,
        scope: CompanyScope,
        inspection_id: str,
        media_id: str,
        *,
        checklist_item_id: str | None,
        before_after_tag: str | None,
        actor_uid: str,
    ) -> Inspection:
        """Idempotent-on-missing (same at-least-once posture as attach/detach):
        if `media_id` is no longer present, returns the current record
        unchanged rather than raising. No revision involvement, same as
        `append_media`/`remove_media`."""
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        existing = next((m for m in current.media if m.id == media_id), None)
        if existing is None:
            return current

        new_checklist_item_id = (
            checklist_item_id if checklist_item_id is not None else existing.checklist_item_id
        )
        new_before_after_tag = (
            before_after_tag if before_after_tag is not None else existing.before_after_tag
        )
        updated_media = existing.model_copy(
            update={
                "checklist_item_id": new_checklist_item_id,
                "before_after_tag": new_before_after_tag,
            }
        )
        new_media_list = [updated_media if m.id == media_id else m for m in current.media]
        await self._collection.document(inspection_id).update(
            {
                "media": [m.model_dump() for m in new_media_list],
                "updated_at": utc_now(),
            },
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.media_edited",
            target_id=inspection_id,
            metadata={"media": updated_media.model_dump(mode="json")},
        )
        return updated

    async def append_annotation(
        self, scope: CompanyScope, inspection_id: str, annotation: Annotation, actor_uid: str
    ) -> Inspection:
        """Mirrors `append_media`: no `expected_revision`/revision bump by
        design -- annotation traffic is per-photo overlay metadata and must
        never collide with the checklist-autosave revision protocol."""
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        await self._collection.document(inspection_id).update(
            {"annotations": ArrayUnion([annotation.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.annotation_added",
            target_id=inspection_id,
            metadata={"annotation": annotation.model_dump(mode="json")},
        )
        return updated

    async def update_annotation(
        self,
        scope: CompanyScope,
        inspection_id: str,
        annotation_id: str,
        *,
        changes: dict[str, object],
        actor_uid: str,
    ) -> Inspection:
        """Idempotent-on-missing, same posture as `update_media`: if
        `annotation_id` is no longer present, returns the current record
        unchanged rather than raising."""
        current = await self.get(scope, inspection_id)
        if current is None:
            raise LookupError("inspection not found in company scope")
        existing = next((a for a in current.annotations if a.id == annotation_id), None)
        if existing is None:
            return current

        updated_annotation = Annotation.model_validate({**existing.model_dump(), **changes})
        new_annotations = [
            updated_annotation if a.id == annotation_id else a for a in current.annotations
        ]
        await self._collection.document(inspection_id).update(
            {
                "annotations": [a.model_dump() for a in new_annotations],
                "updated_at": utc_now(),
            },
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        assert updated is not None
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.annotation_edited",
            target_id=inspection_id,
            metadata={"annotation": updated_annotation.model_dump(mode="json")},
        )
        return updated

    async def remove_annotation(
        self, scope: CompanyScope, inspection_id: str, annotation: Annotation, actor_uid: str
    ) -> Inspection:
        """Idempotent: an already-removed `annotation` entry is a harmless
        ArrayRemove no-op, since delete replays via the mobile outbox
        at-least-once (mirrors `remove_media`)."""
        await self._collection.document(inspection_id).update(
            {"annotations": ArrayRemove([annotation.model_dump()]), "updated_at": utc_now()},
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        updated = await self.get(scope, inspection_id)
        if updated is None:
            raise LookupError("inspection not found in company scope")
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="inspection.annotation_removed",
            target_id=inspection_id,
            metadata={"annotation": annotation.model_dump(mode="json")},
        )
        return updated

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
