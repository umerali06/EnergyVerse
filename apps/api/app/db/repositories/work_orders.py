from datetime import datetime

from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import WorkOrder, WorkOrderCreate

# Matches the D-019/3.4/4.1/7.1 in-memory read-cap convention -- the
# Firestore query itself is already bounded by company_id plus at most one
# equality filter, but this guards the worst case (no filter at all).
WORK_ORDER_QUERY_CAP = 5000


class RevisionConflictError(Exception):
    def __init__(self, current: WorkOrder) -> None:
        super().__init__("Work order revision does not match the current record")
        self.current = current


class InvalidTransitionError(Exception):
    def __init__(self, current: WorkOrder) -> None:
        super().__init__(f"Work order cannot transition from status '{current.status}'")
        self.current = current


class WorkOrderRepository(TenantRepository[WorkOrder]):
    collection_name = "work_orders"
    target_type = "work_order"
    model_type = WorkOrder

    async def create(
        self, scope: CompanyScope, payload: WorkOrderCreate, actor_uid: str
    ) -> WorkOrder:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def query(
        self,
        scope: CompanyScope,
        *,
        asset_id: str | None = None,
        facility_id: str | None = None,
        status: str | None = None,
    ) -> list[WorkOrder]:
        """One Firestore-level bounded read: company_id plus at most one
        equality filter (priority asset_id > facility_id > status), ordered
        by created_at desc -- mirrors `InspectionRepository.query`. Any
        other filter (technician_id, date range) is applied in-memory by the
        service over this already-bounded result."""
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if asset_id is not None:
            query = query.where(filter=FieldFilter("asset_id", "==", asset_id))
        elif facility_id is not None:
            query = query.where(filter=FieldFilter("facility_id", "==", facility_id))
        elif status is not None:
            query = query.where(filter=FieldFilter("status", "==", status))
        query = query.order_by("created_at", direction="DESCENDING")

        results = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                results.append(self.model_type.model_validate(data))
            if len(results) >= WORK_ORDER_QUERY_CAP:
                break
        return results

    async def soft_delete(
        self, scope: CompanyScope, work_order_id: str, actor_uid: str
    ) -> WorkOrder:
        current = await self.get(scope, work_order_id)
        if current is None:
            raise LookupError("work order not found in company scope")
        now = utc_now()
        data = {
            **current.model_dump(),
            "deleted_at": now,
            "updated_at": now,
            "revision": current.revision + 1,
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(work_order_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action="work_order.deleted",
            target_id=work_order_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def _apply_lifecycle(
        self,
        scope: CompanyScope,
        work_order_id: str,
        actor_uid: str,
        *,
        expected_statuses: frozenset[str],
        next_status: str,
        extra_fields: dict[str, object],
        action: str,
        expected_revision: int | None = None,
    ) -> WorkOrder:
        current = await self.get(scope, work_order_id)
        if current is None:
            raise LookupError("work order not found in company scope")
        if expected_revision is not None and expected_revision != current.revision:
            raise RevisionConflictError(current)
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
        await self._collection.document(work_order_id).set(
            model.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"work_order.{action}",
            target_id=work_order_id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model

    async def assign(
        self,
        scope: CompanyScope,
        work_order_id: str,
        *,
        technician_id: str,
        due_date: datetime | None,
        actor_uid: str,
        expected_revision: int | None,
    ) -> WorkOrder:
        return await self._apply_lifecycle(
            scope,
            work_order_id,
            actor_uid,
            expected_statuses=frozenset({"open", "assigned"}),
            next_status="assigned",
            extra_fields={
                "technician_id": technician_id,
                "assigned_by": actor_uid,
                "assigned_at": utc_now(),
                "due_date": due_date,
            },
            action="assigned",
            expected_revision=expected_revision,
        )

    async def accept(self, scope: CompanyScope, work_order_id: str, actor_uid: str) -> WorkOrder:
        return await self._apply_lifecycle(
            scope,
            work_order_id,
            actor_uid,
            expected_statuses=frozenset({"assigned"}),
            next_status="in_progress",
            extra_fields={"accepted_at": utc_now()},
            action="accepted",
        )

    async def submit_for_review(
        self,
        scope: CompanyScope,
        work_order_id: str,
        *,
        completion_notes: str,
        labor_hours: float | None,
        materials_used: list[str],
        actor_uid: str,
        expected_revision: int | None,
    ) -> WorkOrder:
        return await self._apply_lifecycle(
            scope,
            work_order_id,
            actor_uid,
            expected_statuses=frozenset({"in_progress"}),
            next_status="pending_review",
            extra_fields={
                "completion_notes": completion_notes,
                "labor_hours": labor_hours,
                "materials_used": materials_used,
                "submitted_at": utc_now(),
            },
            action="submitted_for_review",
            expected_revision=expected_revision,
        )

    async def close(self, scope: CompanyScope, work_order_id: str, actor_uid: str) -> WorkOrder:
        return await self._apply_lifecycle(
            scope,
            work_order_id,
            actor_uid,
            expected_statuses=frozenset({"pending_review"}),
            next_status="closed",
            extra_fields={"closed_by": actor_uid, "closed_at": utc_now()},
            action="closed",
        )

    async def cancel(self, scope: CompanyScope, work_order_id: str, actor_uid: str) -> WorkOrder:
        return await self._apply_lifecycle(
            scope,
            work_order_id,
            actor_uid,
            expected_statuses=frozenset({"open", "assigned", "in_progress", "pending_review"}),
            next_status="cancelled",
            extra_fields={"cancelled_at": utc_now()},
            action="cancelled",
        )
