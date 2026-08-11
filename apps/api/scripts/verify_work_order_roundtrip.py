"""Real-creds Phase 8.1 verification: create a work order against the real
Firebase project, walk it through assign -> accept -> submit-for-review ->
close, confirming the technician self-accept/self-submit check enforces
correctly against real Firestore data, then cancel a second work order and
clean both up.

The close-permission split (`work_orders.close` vs `work_orders.write`) is an
HTTP-route-dependency concern (`require_permission`), not something a
service-layer script can exercise -- that's already covered by
`tests/test_work_orders.py`'s `test_close_by_technician_is_forbidden` and
`test_close_requires_dedicated_permission_not_write` against a real
`TestClient` request.

Run with: python -m poetry run python -m scripts.verify_work_order_roundtrip
"""

import asyncio
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.work_orders import WorkOrderRepository
from app.models.api import (
    AssignWorkOrderRequest,
    CreateWorkOrderRequest,
    SubmitWorkOrderForReviewRequest,
)
from app.models.base import CompanyScope
from app.work_orders.service import WorkOrderService, WorkOrderServiceError
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID, MAINTENANCE_TECHNICIAN_UID

SUPERVISOR_UID = "demo-acme-operations_manager"


async def main() -> None:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    service = WorkOrderService(
        work_orders=WorkOrderRepository(client, audit),
        assets=AssetRepository(client, audit),
    )
    scope = CompanyScope(company_id=ACME_COMPANY_ID)

    work_order_id = str(uuid4())
    second_id = str(uuid4())

    try:
        detail = await service.create_work_order(
            scope,
            CreateWorkOrderRequest(
                id=work_order_id,
                asset_id=ASSET_FEED_PUMP_ID,
                title="Real-creds verification work order",
                priority="high",
            ),
            SUPERVISOR_UID,
        )
        assert detail.status == "open"
        print(f"created work order {work_order_id}")

        detail = await service.assign_work_order(
            scope,
            work_order_id,
            AssignWorkOrderRequest(technician_id=MAINTENANCE_TECHNICIAN_UID),
            SUPERVISOR_UID,
        )
        assert detail.status == "assigned"
        assert detail.technician_id == MAINTENANCE_TECHNICIAN_UID
        print("assigned to maintenance technician")

        try:
            await service.accept_work_order(scope, work_order_id, SUPERVISOR_UID)
            raise AssertionError("expected supervisor accept to be forbidden")
        except WorkOrderServiceError as error:
            assert error.code == "not_assigned_technician"
            print("confirmed: supervisor cannot accept on the technician's behalf")

        detail = await service.accept_work_order(scope, work_order_id, MAINTENANCE_TECHNICIAN_UID)
        assert detail.status == "in_progress"
        print("technician accepted, status is in_progress")

        detail = await service.submit_work_order_for_review(
            scope,
            work_order_id,
            SubmitWorkOrderForReviewRequest(
                completion_notes="Replaced seal, verified no leaks.",
                labor_hours=2.0,
                materials_used=["Gasket kit"],
            ),
            MAINTENANCE_TECHNICIAN_UID,
        )
        assert detail.status == "pending_review"
        print("technician submitted for review")

        detail = await service.close_work_order(scope, work_order_id, SUPERVISOR_UID)
        assert detail.status == "closed"
        assert detail.closed_by == SUPERVISOR_UID
        print("supervisor closed the work order")

        second = await service.create_work_order(
            scope,
            CreateWorkOrderRequest(
                id=second_id,
                asset_id=ASSET_FEED_PUMP_ID,
                title="Real-creds verification cancel path",
            ),
            SUPERVISOR_UID,
        )
        assert second.status == "open"
        cancelled = await service.cancel_work_order(scope, second_id, SUPERVISOR_UID)
        assert cancelled.status == "cancelled"
        print("created and cancelled a second work order")

        print("PASS: work order lifecycle real-creds round-trip verified end to end")
    finally:
        for cleanup_id in (work_order_id, second_id):
            try:
                await service.delete_work_order(scope, cleanup_id, SUPERVISOR_UID)
                print(f"cleaned up work order {cleanup_id}")
            except Exception as error:  # noqa: BLE001 -- best-effort cleanup
                print(f"warning: failed to clean up work order {cleanup_id}: {error}")


if __name__ == "__main__":
    asyncio.run(main())
