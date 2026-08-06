"""Real-creds Phase 7.6 verification: record (simulate) a real audio file,
upload it to Storage under the inspection-scoped voice/ path against the
real Firebase project, attach it, confirm it lands in `voice_notes[]` and
plays back via its signed URL, link it to a checklist item, detach it, and
clean up.

Run with: python -m poetry run python -m scripts.verify_voice_note_roundtrip
"""

import asyncio
from datetime import UTC, datetime
from uuid import uuid4

import httpx

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.db.repositories.inspections import InspectionRepository
from app.inspections.service import InspectionService
from app.models.api import (
    AttachVoiceNoteRequest,
    CreateInspectionRequest,
    UpdateVoiceNoteRequest,
)
from app.models.base import CompanyScope
from app.storage.service import get_inspection_media_storage
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID, FIELD_INSPECTOR_UID

PROBE_AUDIO_BYTES = b"probe-m4a-bytes-not-real-audio-but-real-object-bytes"


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
    blob_path = storage.voice_object_path(ACME_COMPANY_ID, inspection_id, local_id, "probe.m4a")

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

        bucket = storage._get_bucket()  # noqa: SLF001 -- verification script, not app code
        bucket.blob(blob_path).upload_from_string(PROBE_AUDIO_BYTES, content_type="audio/mp4")
        print(f"uploaded probe voice-note blob to {blob_path}")

        detail = await service.attach_voice_note(
            scope,
            inspection_id,
            AttachVoiceNoteRequest(
                local_id=local_id,
                filename="probe.m4a",
                content_type="audio/mp4",
                size=len(PROBE_AUDIO_BYTES),
                duration_ms=7000,
            ),
            actor_uid,
        )
        assert len(detail.voice_notes) == 1, "expected the voice note to land in voice_notes[]"
        voice_note = detail.voice_notes[0]
        voice_note_id = voice_note.id
        assert voice_note.local_id == local_id
        assert voice_note.duration_ms == 7000
        assert voice_note.checklist_item_id is None
        print(f"attached voice note {voice_note_id}, landed in voice_notes[]")

        response = httpx.get(voice_note.url, timeout=10)
        response.raise_for_status()
        assert response.content == PROBE_AUDIO_BYTES, "signed URL did not serve back the same bytes"
        print("confirmed playback: signed URL served back the exact uploaded bytes")

        refetched = await service.get_inspection(scope, inspection_id)
        assert refetched.voice_notes[0].id == voice_note_id
        print("re-fetched inspection still has the voice note (sync round-trip)")

        detail = await service.update_voice_note(
            scope,
            inspection_id,
            voice_note_id,
            UpdateVoiceNoteRequest(checklist_item_id="vibration_normal"),
            actor_uid,
        )
        assert detail.voice_notes[0].checklist_item_id == "vibration_normal"
        print("linked voice note to checklist item vibration_normal")

        detail = await service.detach_voice_note(scope, inspection_id, voice_note_id, actor_uid)
        assert detail.voice_notes == []
        print("detached voice note")

        print("PASS: voice note real-creds round-trip verified end to end")
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
