import base64
import binascii
from datetime import datetime
from uuid import UUID, uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.inspections import (
    InspectionRepository,
    InvalidTransitionError,
    RevisionConflictError,
)
from app.models.api import (
    AssignChecklistTemplateRequest,
    AttachInspectionMediaRequest,
    AttachVoiceNoteRequest,
    CreateAnnotationRequest,
    CreateInspectionRequest,
    InspectionDetail,
    InspectionListItem,
    InspectionListPage,
    InspectionMediaResponse,
    UpdateAnnotationRequest,
    UpdateInspectionMediaRequest,
    UpdateInspectionRequest,
    UpdateVoiceNoteRequest,
    VoiceNoteResponse,
)
from app.models.api import (
    ChecklistResponse as ApiChecklistResponse,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    Annotation,
    Asset,
    ChecklistResponse,
    ChecklistTemplate,
    Inspection,
    InspectionCreate,
    InspectionMedia,
    Readings,
    VoiceNote,
)
from app.storage.service import InspectionMediaStorage, get_inspection_media_storage

TERMINAL_STATUSES = frozenset({"completed", "cancelled"})

# Maps a completed inspection's manually-recorded condition (spec section 9,
# Phase 7.7) onto the asset's 3-state `current_status` (4.1), which drives
# the 4.4 dashboard's "Critical Assets" KPI. Derived on every completion from
# the most recent completed inspection's condition, per the phase brief.
READINGS_CONDITION_TO_ASSET_STATUS: dict[str, str] = {
    "Excellent": "Healthy",
    "Good": "Healthy",
    "Fair": "Warning",
    "Poor": "Warning",
    "Critical": "Critical",
}

INSPECTION_MEDIA_RULES: dict[str, tuple[frozenset[str], int]] = {
    "photo": (frozenset({"image/jpeg", "image/png", "image/webp", "image/heic"}), 15 * 1024 * 1024),
    "video": (frozenset({"video/mp4", "video/quicktime"}), 500 * 1024 * 1024),
}

# Voice notes are recorded client-side as AAC/M4A (D-0xx, Phase 7.6) --
# compact enough for field connectivity while staying near-universal on both
# iOS and Android. `audio/mp4`/`audio/x-m4a` cover the content-type strings
# different recorder plugins/OSes report for the same AAC-in-M4A-container
# format. 20MB comfortably covers 10 minutes of AAC even at a generous
# encoder bitrate (10 min at 128kbps ~= 9.6MB).
INSPECTION_VOICE_NOTE_ALLOWED_TYPES = frozenset(
    {"audio/mp4", "audio/m4a", "audio/x-m4a", "audio/aac"}
)
INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES = 20 * 1024 * 1024
INSPECTION_VOICE_NOTE_MAX_DURATION_MS = 10 * 60 * 1000


class InspectionServiceError(Exception):
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


def _encode_cursor(inspection_id: str) -> str:
    return base64.urlsafe_b64encode(inspection_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise InspectionServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(inspection: Inspection) -> InspectionListItem:
    return InspectionListItem(
        id=inspection.id,
        asset_id=inspection.asset_id,
        facility_id=inspection.facility_id,
        area_id=inspection.area_id,
        inspector_id=inspection.inspector_id,
        status=inspection.status,
        inspection_type=inspection.inspection_type,
        title=inspection.title,
        checklist_template_id=inspection.checklist_template_id,
        started_at=inspection.started_at,
        completed_at=inspection.completed_at,
        revision=inspection.revision,
        created_at=inspection.created_at,
        updated_at=inspection.updated_at,
    )


def _media_response(
    media: InspectionMedia, storage: InspectionMediaStorage
) -> InspectionMediaResponse:
    return InspectionMediaResponse(
        **media.model_dump(exclude={"path"}),
        url=storage.signed_url_for(media.path),
    )


def _voice_note_response(
    voice_note: VoiceNote, storage: InspectionMediaStorage
) -> VoiceNoteResponse:
    return VoiceNoteResponse(
        **voice_note.model_dump(exclude={"path"}),
        url=storage.signed_url_for(voice_note.path),
    )


def _to_detail(inspection: Inspection, storage: InspectionMediaStorage) -> InspectionDetail:
    return InspectionDetail(
        **_to_list_item(inspection).model_dump(),
        notes=inspection.notes,
        checklist_template_version=inspection.checklist_template_version,
        checklist_items_snapshot=[
            item.model_dump() for item in inspection.checklist_items_snapshot
        ],
        checklist_responses=[
            response.model_dump() for response in inspection.checklist_responses
        ],
        gps_lat=inspection.gps_lat,
        gps_lng=inspection.gps_lng,
        client_created_at=inspection.client_created_at,
        device_id=inspection.device_id,
        origin=inspection.origin,
        media=[_media_response(media, storage) for media in inspection.media],
        annotations=[annotation.model_dump() for annotation in inspection.annotations],
        voice_notes=[
            _voice_note_response(voice_note, storage) for voice_note in inspection.voice_notes
        ],
        readings=inspection.readings.model_dump() if inspection.readings is not None else None,
        ar_measurements=inspection.ar_measurements,
        ai_analysis=inspection.ai_analysis,
        signature=inspection.signature,
    )


class InspectionService:
    def __init__(
        self,
        *,
        inspections: InspectionRepository,
        assets: AssetRepository,
        checklist_templates: ChecklistTemplateRepository,
        storage: InspectionMediaStorage | None = None,
    ) -> None:
        self._inspections = inspections
        self._assets = assets
        self._templates = checklist_templates
        self._storage = storage or get_inspection_media_storage()

    async def _active_asset(self, scope: CompanyScope, asset_id: str) -> Asset:
        asset = await self._assets.get(scope, asset_id)
        if asset is None or asset.deleted_at is not None:
            raise InspectionServiceError(404, "asset_not_found", "Asset was not found")
        return asset

    async def _active_inspection(self, scope: CompanyScope, inspection_id: str) -> Inspection:
        inspection = await self._inspections.get(scope, inspection_id)
        if inspection is None or inspection.deleted_at is not None:
            raise InspectionServiceError(404, "inspection_not_found", "Inspection was not found")
        return inspection

    async def _active_template(self, scope: CompanyScope, template_id: str) -> ChecklistTemplate:
        template = await self._templates.get(scope, template_id)
        if template is None or template.deleted_at is not None:
            raise InspectionServiceError(
                404, "checklist_template_not_found", "Checklist template was not found"
            )
        return template

    def _validate_gps(self, gps_lat: float | None, gps_lng: float | None) -> None:
        if (gps_lat is None) != (gps_lng is None):
            raise InspectionServiceError(
                422, "incomplete_gps", "Latitude and longitude must be provided together"
            )

    async def create_draft(
        self,
        scope: CompanyScope,
        request: CreateInspectionRequest,
        actor_uid: str,
    ) -> tuple[InspectionDetail, bool]:
        try:
            normalized_id = str(UUID(request.id))
        except ValueError as error:
            raise InspectionServiceError(
                422, "invalid_inspection_id", "id must be a valid UUID"
            ) from error
        self._validate_gps(request.gps_lat, request.gps_lng)
        asset = await self._active_asset(scope, request.asset_id)

        payload = InspectionCreate(
            id=normalized_id,
            asset_id=asset.id,
            facility_id=asset.facility_id,
            area_id=asset.area_id,
            inspector_id=actor_uid,
            status="draft",
            inspection_type=request.inspection_type,
            title=request.title,
            notes=request.notes,
            gps_lat=request.gps_lat,
            gps_lng=request.gps_lng,
            client_created_at=request.client_created_at,
            device_id=request.device_id,
            origin=request.origin,
        )
        try:
            inspection, created = await self._inspections.upsert_draft(scope, payload, actor_uid)
        except PermissionError as error:
            raise InspectionServiceError(
                409, "inspection_id_conflict", "Inspection ID belongs to another company"
            ) from error
        except ValueError as error:
            raise InspectionServiceError(
                409,
                "inspection_id_conflict",
                "An inspection with this ID already exists with different data",
            ) from error
        return _to_detail(inspection, self._storage), created

    async def list_inspections(
        self,
        scope: CompanyScope,
        *,
        asset_id: str | None,
        facility_id: str | None,
        status: str | None,
        inspector_id: str | None,
        from_date: datetime | None,
        to_date: datetime | None,
        cursor: str | None,
        limit: int,
    ) -> InspectionListPage:
        # Push at most one equality filter down to Firestore (priority
        # asset_id > facility_id > status); everything else is filtered
        # in-memory over that bounded result -- mirrors AssetManagementService.
        inspections = await self._inspections.query(
            scope,
            asset_id=asset_id,
            facility_id=None if asset_id else facility_id,
            status=None if (asset_id or facility_id) else status,
        )
        inspections = [inspection for inspection in inspections if inspection.deleted_at is None]
        if asset_id and facility_id:
            inspections = [i for i in inspections if i.facility_id == facility_id]
        if (asset_id or facility_id) and status:
            inspections = [i for i in inspections if i.status == status]
        if inspector_id:
            inspections = [i for i in inspections if i.inspector_id == inspector_id]
        if from_date:
            inspections = [i for i in inspections if i.created_at >= from_date]
        if to_date:
            inspections = [i for i in inspections if i.created_at <= to_date]

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [inspection.id for inspection in inspections]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(inspections)
            inspections = inspections[start:]

        page = inspections[:limit]
        items = [_to_list_item(inspection) for inspection in page]
        next_cursor = _encode_cursor(page[-1].id) if len(inspections) > limit and page else None
        return InspectionListPage(items=items, next_cursor=next_cursor)

    async def get_inspection(self, scope: CompanyScope, inspection_id: str) -> InspectionDetail:
        inspection = await self._active_inspection(scope, inspection_id)
        return _to_detail(inspection, self._storage)

    def _value_matches_type(
        self, value: object, item_type: str, options: list[str] | None
    ) -> bool:
        if item_type == "boolean":
            return isinstance(value, bool)
        if item_type == "numeric":
            return isinstance(value, int | float) and not isinstance(value, bool)
        if item_type == "text":
            return isinstance(value, str)
        if item_type == "select":
            return isinstance(value, str) and (not options or value in options)
        return False

    def _validate_responses(
        self,
        inspection: Inspection,
        responses: list[ApiChecklistResponse],
        actor_uid: str,
    ) -> list[dict[str, object]]:
        snapshot_by_id = {item.id: item for item in inspection.checklist_items_snapshot}
        seen: set[str] = set()
        now = utc_now()
        stamped: list[dict[str, object]] = []
        for response in responses:
            if response.item_id in seen:
                raise InspectionServiceError(
                    422,
                    "checklist_response_invalid",
                    "Duplicate item_id in checklist_responses",
                    {"item_id": response.item_id},
                )
            seen.add(response.item_id)
            item = snapshot_by_id.get(response.item_id)
            if item is None:
                raise InspectionServiceError(
                    422,
                    "checklist_response_invalid",
                    "item_id is not part of the assigned checklist",
                    {"item_id": response.item_id},
                )
            if response.value is not None and not self._value_matches_type(
                response.value, item.item_type, item.options
            ):
                raise InspectionServiceError(
                    422,
                    "checklist_response_invalid",
                    "value does not match the item's type",
                    {"item_id": response.item_id, "item_type": item.item_type},
                )
            stamped.append(
                ChecklistResponse(
                    item_id=response.item_id,
                    value=response.value,
                    note=response.note,
                    answered_at=now,
                    answered_by=actor_uid,
                ).model_dump()
            )
        return stamped

    @staticmethod
    def _merge_checklist_responses(
        existing: list[ChecklistResponse], incoming: list[dict[str, object]]
    ) -> list[dict[str, object]]:
        """Upserts `incoming` (already-validated, server-stamped responses for the
        item_ids present in this PATCH) over `existing` by item_id, so a client can
        autosave one item at a time without erasing every other already-answered
        item -- a whole-array replace would otherwise do exactly that."""
        merged: dict[str, dict[str, object]] = {
            response.item_id: response.model_dump() for response in existing
        }
        for response in incoming:
            merged[str(response["item_id"])] = response
        return list(merged.values())

    async def update_inspection(
        self,
        scope: CompanyScope,
        inspection_id: str,
        request: UpdateInspectionRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        current = await self._active_inspection(scope, inspection_id)
        if current.status in TERMINAL_STATUSES:
            raise InspectionServiceError(
                409, "inspection_locked", "Inspection is locked and cannot be edited"
            )
        provided = request.model_dump(exclude_unset=True, exclude={"expected_revision"})
        if "gps_lat" in provided or "gps_lng" in provided:
            gps_lat = request.gps_lat if "gps_lat" in provided else current.gps_lat
            gps_lng = request.gps_lng if "gps_lng" in provided else current.gps_lng
            self._validate_gps(gps_lat, gps_lng)
        if request.checklist_responses is not None:
            stamped = self._validate_responses(
                current, request.checklist_responses, actor_uid
            )
            provided["checklist_responses"] = self._merge_checklist_responses(
                current.checklist_responses, stamped
            )
        if request.readings is not None:
            provided["readings"] = Readings(
                **request.readings.model_dump(),
                recorded_at=utc_now(),
                recorded_by=actor_uid,
            ).model_dump()

        try:
            updated = await self._inspections.update(
                scope,
                inspection_id,
                provided,
                actor_uid,
                expected_revision=request.expected_revision,
            )
        except RevisionConflictError as error:
            raise InspectionServiceError(
                409,
                "revision_conflict",
                "Inspection was modified since expected_revision",
                {
                    "expected_revision": request.expected_revision,
                    "current_revision": error.current.revision,
                },
            ) from error
        return _to_detail(updated, self._storage)

    async def assign_checklist_template(
        self,
        scope: CompanyScope,
        inspection_id: str,
        request: AssignChecklistTemplateRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        current = await self._active_inspection(scope, inspection_id)
        if current.status in TERMINAL_STATUSES:
            raise InspectionServiceError(
                409, "inspection_locked", "Inspection is locked and cannot be edited"
            )
        template = await self._active_template(scope, request.checklist_template_id)
        asset = await self._active_asset(scope, current.asset_id)
        if template.category not in ("Generic", asset.category):
            raise InspectionServiceError(
                422,
                "checklist_template_category_mismatch",
                "Template category does not match the asset's category",
                {"template_category": template.category, "asset_category": asset.category},
            )
        try:
            updated = await self._inspections.assign_checklist_template(
                scope,
                inspection_id,
                template_id=template.id,
                template_version=template.version,
                snapshot_items=template.items,
                actor_uid=actor_uid,
                expected_revision=request.expected_revision,
            )
        except RevisionConflictError as error:
            raise InspectionServiceError(
                409,
                "revision_conflict",
                "Inspection was modified since expected_revision",
                {
                    "expected_revision": request.expected_revision,
                    "current_revision": error.current.revision,
                },
            ) from error
        return _to_detail(updated, self._storage)

    async def start_inspection(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> InspectionDetail:
        await self._active_inspection(scope, inspection_id)
        try:
            updated = await self._inspections.apply_lifecycle(
                scope,
                inspection_id,
                actor_uid,
                expected_statuses=frozenset({"draft"}),
                next_status="in_progress",
                extra_fields={"started_at": utc_now()},
                action="started",
            )
        except InvalidTransitionError as error:
            raise InspectionServiceError(
                409,
                "invalid_transition",
                f"Inspection cannot start from status '{error.current.status}'",
            ) from error
        return _to_detail(updated, self._storage)

    @staticmethod
    def _has_answer(inspection: Inspection, item_id: str) -> bool:
        for response in inspection.checklist_responses:
            if response.item_id == item_id:
                return response.value is not None and response.value != ""
        return False

    async def complete_inspection(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> InspectionDetail:
        current = await self._active_inspection(scope, inspection_id)
        if current.status not in ({"draft", "in_progress"}):
            raise InspectionServiceError(
                409,
                "invalid_transition",
                f"Inspection cannot complete from status '{current.status}'",
            )
        missing = [
            item.id
            for item in current.checklist_items_snapshot
            if item.required and not self._has_answer(current, item.id)
        ]
        if missing:
            raise InspectionServiceError(
                422,
                "checklist_incomplete",
                "Required checklist items are unanswered",
                {"missing_item_ids": missing},
            )
        try:
            updated = await self._inspections.apply_lifecycle(
                scope,
                inspection_id,
                actor_uid,
                expected_statuses=frozenset({"draft", "in_progress"}),
                next_status="completed",
                extra_fields={"completed_at": utc_now()},
                action="completed",
            )
        except InvalidTransitionError as error:
            raise InspectionServiceError(
                409,
                "invalid_transition",
                f"Inspection cannot complete from status '{error.current.status}'",
            ) from error
        if updated.readings is not None:
            new_status = READINGS_CONDITION_TO_ASSET_STATUS[updated.readings.condition]
            await self._assets.roll_up_status_from_inspection(
                scope,
                updated.asset_id,
                new_status=new_status,
                inspection_id=inspection_id,
                actor_uid=actor_uid,
            )
        return _to_detail(updated, self._storage)

    async def cancel_inspection(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> InspectionDetail:
        await self._active_inspection(scope, inspection_id)
        try:
            updated = await self._inspections.apply_lifecycle(
                scope,
                inspection_id,
                actor_uid,
                expected_statuses=frozenset({"draft", "in_progress"}),
                next_status="cancelled",
                extra_fields={},
                action="cancelled",
            )
        except InvalidTransitionError as error:
            raise InspectionServiceError(
                409,
                "invalid_transition",
                f"Inspection cannot cancel from status '{error.current.status}'",
            ) from error
        return _to_detail(updated, self._storage)

    async def delete_inspection(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> None:
        await self._active_inspection(scope, inspection_id)
        await self._inspections.soft_delete(scope, inspection_id, actor_uid)

    async def attach_media(
        self,
        scope: CompanyScope,
        inspection_id: str,
        request: AttachInspectionMediaRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        """Registers a reference to media the mobile client already uploaded
        directly to Storage (Phase 7.4) -- this never receives bytes. Bypasses
        `expected_revision` entirely by design, so heavy media traffic can
        never collide with the checklist-autosave revision protocol."""
        current = await self._active_inspection(scope, inspection_id)

        existing = next((m for m in current.media if m.local_id == request.local_id), None)
        if existing is not None:
            if (
                existing.filename == request.filename
                and existing.kind == request.kind
                and existing.content_type == request.content_type
                and existing.size == request.size
            ):
                return _to_detail(current, self._storage)
            raise InspectionServiceError(
                409,
                "media_reference_conflict",
                "A different media reference already exists for this local_id",
                {"local_id": request.local_id},
            )

        expected_path = self._storage.object_path(
            scope.company_id, inspection_id, request.local_id, request.filename
        )
        exists, storage_size, storage_content_type = self._storage.verify_uploaded(expected_path)
        if not exists:
            raise InspectionServiceError(
                422,
                "media_not_uploaded",
                "Upload the file to Storage before registering it",
                {"path": expected_path},
            )

        allowed_types, max_size = INSPECTION_MEDIA_RULES[request.kind]
        if storage_content_type not in allowed_types:
            raise InspectionServiceError(
                422,
                "media_content_type_invalid",
                "Uploaded content type is not allowed for this kind",
                {"content_type": storage_content_type, "kind": request.kind},
            )
        if storage_size is not None and storage_size > max_size:
            raise InspectionServiceError(
                413,
                "media_too_large",
                "Uploaded file exceeds the allowed size for this kind",
                {"size": storage_size, "max_size": max_size, "kind": request.kind},
            )

        media = InspectionMedia(
            id=f"media_{uuid4().hex}",
            local_id=request.local_id,
            path=expected_path,
            kind=request.kind,
            filename=request.filename,
            content_type=storage_content_type or request.content_type,
            size=storage_size if storage_size is not None else request.size,
            gps_lat=request.gps_lat,
            gps_lng=request.gps_lng,
            captured_at=request.captured_at,
            checklist_item_id=request.checklist_item_id,
            before_after_tag=request.before_after_tag,
            uploaded_by=actor_uid,
            uploaded_at=utc_now(),
        )
        updated = await self._inspections.append_media(scope, inspection_id, media, actor_uid)
        return _to_detail(updated, self._storage)

    async def update_media(
        self,
        scope: CompanyScope,
        inspection_id: str,
        media_id: str,
        request: UpdateInspectionMediaRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        await self._active_inspection(scope, inspection_id)
        updated = await self._inspections.update_media(
            scope,
            inspection_id,
            media_id,
            checklist_item_id=request.checklist_item_id,
            before_after_tag=request.before_after_tag,
            actor_uid=actor_uid,
        )
        return _to_detail(updated, self._storage)

    async def detach_media(
        self, scope: CompanyScope, inspection_id: str, media_id: str, actor_uid: str
    ) -> InspectionDetail:
        """Idempotent on an already-detached `media_id` (deliberate deviation
        from the asset media pattern) since detach replays via the mobile
        outbox at-least-once. Never deletes the Storage object -- the backend
        never touches media bytes under the direct-upload design; an orphaned
        blob after a detach is an accepted gap this phase."""
        current = await self._active_inspection(scope, inspection_id)
        media = next((m for m in current.media if m.id == media_id), None)
        if media is None:
            return _to_detail(current, self._storage)
        updated = await self._inspections.remove_media(scope, inspection_id, media, actor_uid)
        return _to_detail(updated, self._storage)

    async def attach_voice_note(
        self,
        scope: CompanyScope,
        inspection_id: str,
        request: AttachVoiceNoteRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        """Registers a reference to a voice-note recording the mobile client
        already uploaded directly to Storage via the same 7.4 media queue/
        worker (Phase 7.6) -- this never receives bytes. Mirrors
        `attach_media` field-for-field, minus `kind`/GPS/before-after-tag
        (voice notes have none of those) plus `duration_ms`."""
        current = await self._active_inspection(scope, inspection_id)

        existing = next(
            (v for v in current.voice_notes if v.local_id == request.local_id), None
        )
        if existing is not None:
            if (
                existing.filename == request.filename
                and existing.content_type == request.content_type
                and existing.size == request.size
                and existing.duration_ms == request.duration_ms
            ):
                return _to_detail(current, self._storage)
            raise InspectionServiceError(
                409,
                "voice_note_reference_conflict",
                "A different voice note reference already exists for this local_id",
                {"local_id": request.local_id},
            )

        expected_path = self._storage.voice_object_path(
            scope.company_id, inspection_id, request.local_id, request.filename
        )
        exists, storage_size, storage_content_type = self._storage.verify_uploaded(expected_path)
        if not exists:
            raise InspectionServiceError(
                422,
                "voice_note_not_uploaded",
                "Upload the file to Storage before registering it",
                {"path": expected_path},
            )

        if storage_content_type not in INSPECTION_VOICE_NOTE_ALLOWED_TYPES:
            raise InspectionServiceError(
                422,
                "voice_note_content_type_invalid",
                "Uploaded content type is not allowed for voice notes",
                {"content_type": storage_content_type},
            )
        if storage_size is not None and storage_size > INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES:
            raise InspectionServiceError(
                413,
                "voice_note_too_large",
                "Uploaded file exceeds the allowed size for voice notes",
                {"size": storage_size, "max_size": INSPECTION_VOICE_NOTE_MAX_SIZE_BYTES},
            )
        if request.duration_ms > INSPECTION_VOICE_NOTE_MAX_DURATION_MS:
            raise InspectionServiceError(
                422,
                "voice_note_too_long",
                "Voice note exceeds the maximum allowed duration",
                {
                    "duration_ms": request.duration_ms,
                    "max_duration_ms": INSPECTION_VOICE_NOTE_MAX_DURATION_MS,
                },
            )

        voice_note = VoiceNote(
            id=f"voice_{uuid4().hex}",
            local_id=request.local_id,
            path=expected_path,
            filename=request.filename,
            content_type=storage_content_type or request.content_type,
            size=storage_size if storage_size is not None else request.size,
            duration_ms=request.duration_ms,
            checklist_item_id=request.checklist_item_id,
            uploaded_by=actor_uid,
            uploaded_at=utc_now(),
        )
        updated = await self._inspections.append_voice_note(
            scope, inspection_id, voice_note, actor_uid
        )
        return _to_detail(updated, self._storage)

    async def update_voice_note(
        self,
        scope: CompanyScope,
        inspection_id: str,
        voice_note_id: str,
        request: UpdateVoiceNoteRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        await self._active_inspection(scope, inspection_id)
        updated = await self._inspections.update_voice_note(
            scope,
            inspection_id,
            voice_note_id,
            checklist_item_id=request.checklist_item_id,
            actor_uid=actor_uid,
        )
        return _to_detail(updated, self._storage)

    async def detach_voice_note(
        self, scope: CompanyScope, inspection_id: str, voice_note_id: str, actor_uid: str
    ) -> InspectionDetail:
        """Idempotent on an already-detached `voice_note_id` -- the mobile
        outbox replays this call at-least-once, mirrors `detach_media`.
        Never deletes the Storage object, same direct-upload rationale."""
        current = await self._active_inspection(scope, inspection_id)
        voice_note = next((v for v in current.voice_notes if v.id == voice_note_id), None)
        if voice_note is None:
            return _to_detail(current, self._storage)
        updated = await self._inspections.remove_voice_note(
            scope, inspection_id, voice_note, actor_uid
        )
        return _to_detail(updated, self._storage)

    async def create_annotation(
        self,
        scope: CompanyScope,
        inspection_id: str,
        request: CreateAnnotationRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        """Idempotent by client-generated `id` (offline-safe, mirrors
        `attach_media`'s by-`local_id` dedup): a byte-identical resubmit from
        the mobile outbox's at-least-once replay is a no-op. Bypasses
        `expected_revision` entirely, same rationale as media -- annotation
        traffic must never collide with the checklist-autosave revision
        protocol."""
        current = await self._active_inspection(scope, inspection_id)

        if not any(m.local_id == request.media_local_id for m in current.media):
            raise InspectionServiceError(
                404,
                "media_not_found",
                "Annotation references a media item that does not exist on this inspection",
                {"media_local_id": request.media_local_id},
            )

        existing = next((a for a in current.annotations if a.id == request.id), None)
        if existing is not None:
            if (
                existing.media_local_id == request.media_local_id
                and existing.shape == request.shape
                and [p.model_dump() for p in existing.points]
                == [p.model_dump() for p in request.points]
                and existing.color == request.color
                and existing.damage_type == request.damage_type
                and existing.note == request.note
            ):
                return _to_detail(current, self._storage)
            raise InspectionServiceError(
                409,
                "annotation_conflict",
                "A different annotation already exists for this id",
                {"id": request.id},
            )

        annotation = Annotation(
            id=request.id,
            media_local_id=request.media_local_id,
            shape=request.shape,
            points=[p.model_dump() for p in request.points],
            color=request.color,
            damage_type=request.damage_type,
            note=request.note,
            source="manual",
            confidence=None,
            created_by=actor_uid,
            created_at=utc_now(),
        )
        updated = await self._inspections.append_annotation(
            scope, inspection_id, annotation, actor_uid
        )
        return _to_detail(updated, self._storage)

    async def update_annotation(
        self,
        scope: CompanyScope,
        inspection_id: str,
        annotation_id: str,
        request: UpdateAnnotationRequest,
        actor_uid: str,
    ) -> InspectionDetail:
        """Idempotent-on-missing, same posture as `update_media`."""
        await self._active_inspection(scope, inspection_id)
        changes = request.model_dump(exclude_unset=True)
        updated = await self._inspections.update_annotation(
            scope,
            inspection_id,
            annotation_id,
            changes=changes,
            actor_uid=actor_uid,
        )
        return _to_detail(updated, self._storage)

    async def delete_annotation(
        self, scope: CompanyScope, inspection_id: str, annotation_id: str, actor_uid: str
    ) -> InspectionDetail:
        """Idempotent on an already-deleted `annotation_id` -- the mobile
        outbox replays this call at-least-once, mirrors `detach_media`."""
        current = await self._active_inspection(scope, inspection_id)
        annotation = next((a for a in current.annotations if a.id == annotation_id), None)
        if annotation is None:
            return _to_detail(current, self._storage)
        updated = await self._inspections.remove_annotation(
            scope, inspection_id, annotation, actor_uid
        )
        return _to_detail(updated, self._storage)


def get_inspection_service() -> InspectionService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
        storage=get_inspection_media_storage(),
    )
