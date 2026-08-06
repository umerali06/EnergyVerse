"""Real-creds Phase 7.7 verification: log manual status readings on a real
inspection against the real Firebase project, complete it with a Critical
condition, confirm the asset's `current_status` rolls up to Critical and the
4.4 dashboard's Critical-Assets `count()` query reflects it, then verify the
Healthy mapping restores the asset to its original status. Cleans up.

Run with: python -m poetry run python -m scripts.verify_readings_rollup
"""

import asyncio
from datetime import UTC, datetime
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.inspections import InspectionRepository
from app.inspections.service import InspectionService
from app.models.api import CreateInspectionRequest, ReadingsInput, UpdateInspectionRequest
from app.models.base import CompanyScope
from app.storage.service import get_inspection_media_storage
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID, FIELD_INSPECTOR_UID

# Condition that maps back onto each starting asset status (spec section 9 ->
# 4.1 rollup mapping), used to restore the real asset to whatever status it
# already had before this script ran.
_RESTORE_CONDITION = {"Healthy": "Good", "Warning": "Poor", "Critical": "Critical"}


async def _complete_with_condition(
    service: InspectionService, scope: CompanyScope, actor_uid: str, condition: str
) -> str:
    inspection_id = str(uuid4())
    await service.create_draft(
        scope,
        CreateInspectionRequest(
            id=inspection_id,
            asset_id=ASSET_FEED_PUMP_ID,
            inspection_type="ad_hoc",
            client_created_at=datetime.now(UTC),
        ),
        actor_uid,
    )
    await service.update_inspection(
        scope,
        inspection_id,
        UpdateInspectionRequest(readings=ReadingsInput(condition=condition)),
        actor_uid,
    )
    await service.complete_inspection(scope, inspection_id, actor_uid)
    return inspection_id


async def main() -> None:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    assets = AssetRepository(client, audit)
    service = InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=assets,
        checklist_templates=ChecklistTemplateRepository(client, audit),
        storage=get_inspection_media_storage(),
    )
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    actor_uid = FIELD_INSPECTOR_UID

    created_inspection_ids: list[str] = []
    try:
        original_asset = await assets.get(scope, ASSET_FEED_PUMP_ID)
        assert original_asset is not None
        original_status = original_asset.current_status
        print(f"asset {ASSET_FEED_PUMP_ID} starts at current_status={original_status!r}")

        critical_before = await assets.count(scope, current_status="Critical")
        print(f"dashboard Critical-Assets count before: {critical_before}")

        inspection_id = await _complete_with_condition(service, scope, actor_uid, "Critical")
        created_inspection_ids.append(inspection_id)
        print(f"completed inspection {inspection_id} with condition=Critical")

        rolled_up_asset = await assets.get(scope, ASSET_FEED_PUMP_ID)
        assert rolled_up_asset is not None
        assert rolled_up_asset.current_status == "Critical", (
            f"expected current_status=Critical, got {rolled_up_asset.current_status!r}"
        )
        print("PASS: asset.current_status rolled up to Critical")

        critical_after = await assets.count(scope, current_status="Critical")
        assert critical_after == critical_before + 1, (
            f"expected Critical-Assets count to increase by 1, "
            f"was {critical_before}, now {critical_after}"
        )
        print(f"PASS: dashboard Critical-Assets count reflects it ({critical_after})")

        restore_condition = _RESTORE_CONDITION[original_status]
        restore_id = await _complete_with_condition(
            service, scope, actor_uid, restore_condition
        )
        created_inspection_ids.append(restore_id)
        print(
            f"completed inspection {restore_id} with condition={restore_condition!r} "
            "to restore the original mapping"
        )

        restored_asset = await assets.get(scope, ASSET_FEED_PUMP_ID)
        assert restored_asset is not None
        assert restored_asset.current_status == original_status, (
            f"expected current_status back to {original_status!r}, "
            f"got {restored_asset.current_status!r}"
        )
        print(f"PASS: asset.current_status restored to {original_status!r}")

        critical_restored = await assets.count(scope, current_status="Critical")
        assert critical_restored == critical_before, (
            f"expected Critical-Assets count back to {critical_before}, "
            f"got {critical_restored}"
        )
        print(f"PASS: dashboard Critical-Assets count restored ({critical_restored})")

        print("PASS: readings -> asset-health rollup -> dashboard KPI verified end to end")
    finally:
        for inspection_id in created_inspection_ids:
            try:
                await service.delete_inspection(scope, inspection_id, actor_uid)
                print(f"cleaned up inspection {inspection_id}")
            except Exception as error:  # noqa: BLE001 -- best-effort cleanup
                print(f"warning: failed to clean up inspection {inspection_id}: {error}")


if __name__ == "__main__":
    asyncio.run(main())
