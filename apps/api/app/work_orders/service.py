import base64
import binascii

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.work_orders import (
    InvalidTransitionError,
    RevisionConflictError,
    WorkOrderRepository,
)
from app.models.api import (
    AssignWorkOrderRequest,
    CreateWorkOrderRequest,
    SubmitWorkOrderForReviewRequest,
    WorkOrderDeleted,
    WorkOrderDetail,
    WorkOrderListItem,
    WorkOrderListPage,
)
from app.models.base import CompanyScope
from app.models.entities import WorkOrder, WorkOrderCreate

WORK_ORDER_LIST_DEFAULT_LIMIT = 25


class WorkOrderServiceError(Exception):
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


def _encode_cursor(work_order_id: str) -> str:
    return base64.urlsafe_b64encode(work_order_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise WorkOrderServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(work_order: WorkOrder) -> WorkOrderListItem:
    return WorkOrderListItem(
        id=work_order.id,
        asset_id=work_order.asset_id,
        facility_id=work_order.facility_id,
        title=work_order.title,
        priority=work_order.priority,
        status=work_order.status,
        technician_id=work_order.technician_id,
        due_date=work_order.due_date,
        revision=work_order.revision,
        created_at=work_order.created_at,
        updated_at=work_order.updated_at,
    )


def _to_detail(work_order: WorkOrder) -> WorkOrderDetail:
    return WorkOrderDetail(
        **_to_list_item(work_order).model_dump(),
        description=work_order.description,
        source_inspection_id=work_order.source_inspection_id,
        assigned_by=work_order.assigned_by,
        assigned_at=work_order.assigned_at,
        accepted_at=work_order.accepted_at,
        labor_hours=work_order.labor_hours,
        materials_used=work_order.materials_used,
        completion_notes=work_order.completion_notes,
        submitted_at=work_order.submitted_at,
        closed_by=work_order.closed_by,
        closed_at=work_order.closed_at,
        cancelled_at=work_order.cancelled_at,
        created_by=work_order.created_by,
    )


class WorkOrderService:
    def __init__(
        self,
        *,
        work_orders: WorkOrderRepository,
        assets: AssetRepository,
    ) -> None:
        self._work_orders = work_orders
        self._assets = assets

    async def _active_work_order(
        self, scope: CompanyScope, work_order_id: str
    ) -> WorkOrder:
        work_order = await self._work_orders.get(scope, work_order_id)
        if work_order is None or work_order.deleted_at is not None:
            raise WorkOrderServiceError(
                404, "work_order_not_found", "Work order was not found"
            )
        return work_order

    async def create_work_order(
        self,
        scope: CompanyScope,
        request: CreateWorkOrderRequest,
        actor_uid: str,
    ) -> WorkOrderDetail:
        asset = await self._assets.get(scope, request.asset_id)
        if asset is None or asset.deleted_at is not None:
            raise WorkOrderServiceError(404, "asset_not_found", "Asset was not found")

        payload = WorkOrderCreate(
            id=request.id,
            asset_id=asset.id,
            facility_id=asset.facility_id,
            title=request.title,
            description=request.description,
            priority=request.priority,
            due_date=request.due_date,
            source_inspection_id=request.source_inspection_id,
        )
        try:
            work_order = await self._work_orders.create(scope, payload, actor_uid)
        except ValueError as error:
            raise WorkOrderServiceError(
                409, "work_order_id_conflict", "A work order with this ID already exists"
            ) from error
        except PermissionError as error:
            raise WorkOrderServiceError(
                409, "work_order_id_conflict", "Work order ID belongs to another company"
            ) from error
        return _to_detail(work_order)

    async def list_work_orders(
        self,
        scope: CompanyScope,
        *,
        asset_id: str | None,
        facility_id: str | None,
        status: str | None,
        technician_id: str | None,
        cursor: str | None,
        limit: int,
    ) -> WorkOrderListPage:
        # Push at most one equality filter down to Firestore (priority
        # asset_id > facility_id > status); everything else is filtered
        # in-memory over that bounded result -- mirrors
        # `InspectionService.list_inspections`.
        work_orders = await self._work_orders.query(
            scope,
            asset_id=asset_id,
            facility_id=None if asset_id else facility_id,
            status=None if (asset_id or facility_id) else status,
        )
        work_orders = [w for w in work_orders if w.deleted_at is None]
        if asset_id and facility_id:
            work_orders = [w for w in work_orders if w.facility_id == facility_id]
        if (asset_id or facility_id) and status:
            work_orders = [w for w in work_orders if w.status == status]
        if technician_id:
            work_orders = [w for w in work_orders if w.technician_id == technician_id]

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [work_order.id for work_order in work_orders]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(work_orders)
            work_orders = work_orders[start:]

        page = work_orders[:limit]
        items = [_to_list_item(work_order) for work_order in page]
        next_cursor = _encode_cursor(page[-1].id) if len(work_orders) > limit and page else None
        return WorkOrderListPage(items=items, next_cursor=next_cursor)

    async def get_work_order(
        self, scope: CompanyScope, work_order_id: str
    ) -> WorkOrderDetail:
        work_order = await self._active_work_order(scope, work_order_id)
        return _to_detail(work_order)

    async def assign_work_order(
        self,
        scope: CompanyScope,
        work_order_id: str,
        request: AssignWorkOrderRequest,
        actor_uid: str,
    ) -> WorkOrderDetail:
        await self._active_work_order(scope, work_order_id)
        try:
            work_order = await self._work_orders.assign(
                scope,
                work_order_id,
                technician_id=request.technician_id,
                due_date=request.due_date,
                actor_uid=actor_uid,
                expected_revision=request.expected_revision,
            )
        except RevisionConflictError as error:
            raise WorkOrderServiceError(
                409,
                "revision_conflict",
                "Work order was modified since you last loaded it",
                {"current_revision": error.current.revision},
            ) from error
        except InvalidTransitionError as error:
            raise WorkOrderServiceError(
                409,
                "invalid_transition",
                f"Work order cannot be assigned from status '{error.current.status}'",
            ) from error
        return _to_detail(work_order)

    async def accept_work_order(
        self, scope: CompanyScope, work_order_id: str, actor_uid: str
    ) -> WorkOrderDetail:
        """Only the assigned technician can accept their own work order
        (D-066) -- "Accept Task" is a personal acknowledgment, not a
        supervisory action, so even a `company_admin`/`operations_manager`
        cannot accept on a technician's behalf."""
        current = await self._active_work_order(scope, work_order_id)
        if current.technician_id != actor_uid:
            raise WorkOrderServiceError(
                403,
                "not_assigned_technician",
                "Only the assigned technician can accept this work order",
            )
        try:
            work_order = await self._work_orders.accept(scope, work_order_id, actor_uid)
        except InvalidTransitionError as error:
            raise WorkOrderServiceError(
                409,
                "invalid_transition",
                f"Work order cannot be accepted from status '{error.current.status}'",
            ) from error
        return _to_detail(work_order)

    async def submit_work_order_for_review(
        self,
        scope: CompanyScope,
        work_order_id: str,
        request: SubmitWorkOrderForReviewRequest,
        actor_uid: str,
    ) -> WorkOrderDetail:
        """Same self-only posture as `accept_work_order` -- the assigned
        technician submits their own repair for review."""
        current = await self._active_work_order(scope, work_order_id)
        if current.technician_id != actor_uid:
            raise WorkOrderServiceError(
                403,
                "not_assigned_technician",
                "Only the assigned technician can submit this work order for review",
            )
        try:
            work_order = await self._work_orders.submit_for_review(
                scope,
                work_order_id,
                completion_notes=request.completion_notes,
                labor_hours=request.labor_hours,
                materials_used=request.materials_used,
                actor_uid=actor_uid,
                expected_revision=request.expected_revision,
            )
        except RevisionConflictError as error:
            raise WorkOrderServiceError(
                409,
                "revision_conflict",
                "Work order was modified since you last loaded it",
                {"current_revision": error.current.revision},
            ) from error
        except InvalidTransitionError as error:
            raise WorkOrderServiceError(
                409,
                "invalid_transition",
                "Work order cannot be submitted for review from status "
                f"'{error.current.status}'",
            ) from error
        return _to_detail(work_order)

    async def close_work_order(
        self, scope: CompanyScope, work_order_id: str, actor_uid: str
    ) -> WorkOrderDetail:
        """Requires `work_orders.close` at the route layer (D-066) -- the
        assigned technician (who only ever holds `work_orders.write`)
        cannot reach this method's route at all."""
        await self._active_work_order(scope, work_order_id)
        try:
            work_order = await self._work_orders.close(scope, work_order_id, actor_uid)
        except InvalidTransitionError as error:
            raise WorkOrderServiceError(
                409,
                "invalid_transition",
                f"Work order cannot be closed from status '{error.current.status}'",
            ) from error
        return _to_detail(work_order)

    async def cancel_work_order(
        self, scope: CompanyScope, work_order_id: str, actor_uid: str
    ) -> WorkOrderDetail:
        await self._active_work_order(scope, work_order_id)
        try:
            work_order = await self._work_orders.cancel(scope, work_order_id, actor_uid)
        except InvalidTransitionError as error:
            raise WorkOrderServiceError(
                409,
                "invalid_transition",
                f"Work order cannot be cancelled from status '{error.current.status}'",
            ) from error
        return _to_detail(work_order)

    async def delete_work_order(
        self, scope: CompanyScope, work_order_id: str, actor_uid: str
    ) -> WorkOrderDeleted:
        await self._active_work_order(scope, work_order_id)
        await self._work_orders.soft_delete(scope, work_order_id, actor_uid)
        return WorkOrderDeleted(id=work_order_id)


def get_work_order_service() -> WorkOrderService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return WorkOrderService(
        work_orders=WorkOrderRepository(client, audit),
        assets=AssetRepository(client, audit),
    )
