"""Real-creds Phase 7.5 verification: create an inspection photo annotation
against the real Firebase project, confirm it persists and re-renders with
correct normalized coordinates, edit it, delete it, and clean up.

Run with: python -m poetry run python -m scripts.verify_annotation_roundtrip
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
from app.models.api import (
    AttachInspectionMediaRequest,
    CreateAnnotationRequest,
    UpdateAnnotationRequest,
)
from app.models.api import AnnotationPointInput as ApiPoint
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
        storage=storage,
    )
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    actor_uid = FIELD_INSPECTOR_UID

    inspection_id = str(uuid4())
    local_id = uuid4().hex
    annotation_id = uuid4().hex
    blob_path = storage.object_path(ACME_COMPANY_ID, inspection_id, local_id, "probe.jpg")

    try:
        from app.models.api import CreateInspectionRequest

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

        bucket = storage._get_bucket()  # noqa: SLF001 -- verification script, not app code
        bucket.blob(blob_path).upload_from_string(b"probe-jpeg-bytes", content_type="image/jpeg")
        print(f"uploaded probe blob to {blob_path}")

        detail = await service.attach_media(
            scope,
            inspection_id,
            AttachInspectionMediaRequest(
                local_id=local_id,
                filename="probe.jpg",
                kind="photo",
                content_type="image/jpeg",
                size=len(b"probe-jpeg-bytes"),
                captured_at=datetime.now(UTC),
            ),
            actor_uid,
        )
        print(f"attached media, {len(detail.media)} media item(s)")

        detail = await service.create_annotation(
            scope,
            inspection_id,
            CreateAnnotationRequest(
                id=annotation_id,
                media_local_id=local_id,
                shape="rectangle",
                points=[ApiPoint(x=0.125, y=0.25), ApiPoint(x=0.625, y=0.75)],
                color="#C1123F",
                damage_type="corrosion",
                note="Real-creds round-trip probe",
            ),
            actor_uid,
        )
        annotation = detail.annotations[0]
        assert annotation.id == annotation_id
        assert annotation.points[0].x == 0.125
        assert annotation.points[0].y == 0.25
        assert annotation.points[1].x == 0.625
        assert annotation.points[1].y == 0.75
        assert annotation.damage_type == "corrosion"
        print(f"created annotation {annotation_id} with correct normalized coordinates")

        refetched = await service.get_inspection(scope, inspection_id)
        refetched_annotation = refetched.annotations[0]
        assert refetched_annotation.points[0].x == 0.125
        assert refetched_annotation.points[1].y == 0.75
        print("re-fetched inspection still has correct coordinates (sync round-trip)")

        detail = await service.update_annotation(
            scope,
            inspection_id,
            annotation_id,
            UpdateAnnotationRequest(damage_type="crack", note="Updated by verification script"),
            actor_uid,
        )
        updated_annotation = detail.annotations[0]
        assert updated_annotation.damage_type == "crack"
        assert updated_annotation.note == "Updated by verification script"
        assert updated_annotation.color == "#C1123F"  # untouched field preserved
        print("updated annotation damage_type/note, other fields preserved")

        detail = await service.delete_annotation(scope, inspection_id, annotation_id, actor_uid)
        assert detail.annotations == []
        print("deleted annotation")

        print("PASS: annotation real-creds round-trip verified end to end")
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
