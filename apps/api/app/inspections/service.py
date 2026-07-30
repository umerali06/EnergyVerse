import base64
import binascii
from datetime import datetime
from uuid import UUID

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
    CreateInspectionRequest,
    InspectionDetail,
    InspectionListItem,
    InspectionListPage,
    UpdateInspectionRequest,
)
from app.models.api import (
    ChecklistResponse as ApiChecklistResponse,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    Asset,
    ChecklistResponse,
    ChecklistTemplate,
    Inspection,
    InspectionCreate,
)

TERMINAL_STATUSES = frozenset({"completed", "cancelled"})


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


def _to_detail(inspection: Inspection) -> InspectionDetail:
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
        media=inspection.media,
        annotations=inspection.annotations,
        voice_notes=inspection.voice_notes,
        readings=inspection.readings,
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
    ) -> None:
        self._inspections = inspections
        self._assets = assets
        self._templates = checklist_templates

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
        return _to_detail(inspection), created

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
        return _to_detail(inspection)

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
            provided["checklist_responses"] = self._validate_responses(
                current, request.checklist_responses, actor_uid
            )

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
        return _to_detail(updated)

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
        return _to_detail(updated)

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
        return _to_detail(updated)

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
        return _to_detail(updated)

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
        return _to_detail(updated)

    async def delete_inspection(
        self, scope: CompanyScope, inspection_id: str, actor_uid: str
    ) -> None:
        await self._active_inspection(scope, inspection_id)
        await self._inspections.soft_delete(scope, inspection_id, actor_uid)


def get_inspection_service() -> InspectionService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
    )
