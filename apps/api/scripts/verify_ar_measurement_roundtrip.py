"""Real-creds Phase 7.9 verification: create a manual and an AR dimension
measurement against the real Firebase project, confirm they persist and
re-render correctly (including the AR measurement's screenshot reference),
edit one, delete it, and clean up.

Run with: python -m poetry run python -m scripts.verify_ar_measurement_roundtrip
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
from app.db.repositories.users import UserRepository
from app.inspections.service import InspectionService
from app.models.api import (
    AttachInspectionMediaRequest,
    CreateArMeasurementRequest,
    CreateInspectionRequest,
    UpdateArMeasurementRequest,
)
from app.models.base import CompanyScope
from app.storage.service import get_inspection_media_storage
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID, FIELD_INSPECTOR_UID


async def main() -> None:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    storage = get_inspection_media_storage()
    service = InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
        users=UserRepository(client, audit),
        storage=storage,
    )
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    actor_uid = FIELD_INSPECTOR_UID

    inspection_id = str(uuid4())
    local_id = uuid4().hex
    manual_id = uuid4().hex
    ar_id = uuid4().hex
    blob_path = storage.object_path(ACME_COMPANY_ID, inspection_id, local_id, "screenshot.png")

    try:
        detail, created = await service.create_draft(
            scope,
            CreateInspectionRequest(
                id=inspection_id,
                asset_id=ASSET_FEED_PUMP_ID,
                inspection_type="ad_hoc",
                client_created_at=datetime.now(UTC),
            ),
            actor_uid,
        )
        assert created, "expected a fresh draft"
        print(f"created inspection {inspection_id}")

        detail = await service.create_ar_measurement(
            scope,
            inspection_id,
            CreateArMeasurementRequest(
                id=manual_id,
                method="manual",
                distance_meters=1.25,
                label="Flange gap",
                note="Real-creds round-trip probe",
            ),
            actor_uid,
        )
        manual_measurement = detail.ar_measurements[0]
        assert manual_measurement.method == "manual"
        assert manual_measurement.distance_meters == 1.25
        assert manual_measurement.media_local_id is None
        print(f"created manual measurement {manual_id}")

        bucket = storage._get_bucket()  # noqa: SLF001 -- verification script, not app code
        bucket.blob(blob_path).upload_from_string(b"probe-png-bytes", content_type="image/png")
        print(f"uploaded probe screenshot blob to {blob_path}")

        detail = await service.attach_media(
            scope,
            inspection_id,
            AttachInspectionMediaRequest(
                local_id=local_id,
                filename="screenshot.png",
                kind="photo",
                content_type="image/png",
                size=len(b"probe-png-bytes"),
                captured_at=datetime.now(UTC),
            ),
            actor_uid,
        )
        print(f"attached screenshot, {len(detail.media)} media item(s)")

        detail = await service.create_ar_measurement(
            scope,
            inspection_id,
            CreateArMeasurementRequest(
                id=ar_id,
                method="ar",
                distance_meters=0.42,
                media_local_id=local_id,
            ),
            actor_uid,
        )
        ar_measurement = next(m for m in detail.ar_measurements if m.id == ar_id)
        assert ar_measurement.method == "ar"
        assert ar_measurement.media_local_id == local_id
        assert ar_measurement.points == []
        print(f"created AR measurement {ar_id} referencing the screenshot")

        refetched = await service.get_inspection(scope, inspection_id)
        assert len(refetched.ar_measurements) == 2
        refetched_ar = next(m for m in refetched.ar_measurements if m.id == ar_id)
        assert refetched_ar.distance_meters == 0.42
        assert refetched_ar.media_local_id == local_id
        print("re-fetched inspection still has both measurements correctly (sync round-trip)")

        detail = await service.update_ar_measurement(
            scope,
            inspection_id,
            manual_id,
            UpdateArMeasurementRequest(note="Re-checked by verification script"),
            actor_uid,
        )
        updated_manual = next(m for m in detail.ar_measurements if m.id == manual_id)
        assert updated_manual.note == "Re-checked by verification script"
        assert updated_manual.distance_meters == 1.25  # untouched field preserved
        print("updated manual measurement note, distance preserved")

        detail = await service.delete_ar_measurement(scope, inspection_id, ar_id, actor_uid)
        assert len(detail.ar_measurements) == 1
        assert detail.ar_measurements[0].id == manual_id
        print("deleted AR measurement, manual measurement survives")

        print("PASS: AR/manual measurement real-creds round-trip verified end to end")
    finally:
        try:
            bucket = storage._get_bucket()  # noqa: SLF001
            blob = bucket.blob(blob_path)
            if blob.exists():
                blob.delete()
                print(f"cleaned up probe blob {blob_path}")
        except Exception as error:  # noqa: BLE001 -- best-effort cleanup
            print(f"warning: failed to clean up probe blob: {error}")
        try:
            await service.delete_inspection(scope, inspection_id, actor_uid)
            print(f"cleaned up inspection {inspection_id}")
        except Exception as error:  # noqa: BLE001 -- best-effort cleanup
            print(f"warning: failed to clean up inspection: {error}")


if __name__ == "__main__":
    asyncio.run(main())
