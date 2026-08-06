"""Real-creds Phase 7.8 verification: sign a real inspection to complete it
against the real Firebase project, confirm the persisted signature carries
the server-derived signer identity (never whatever the "client" supplied)
and is bound to the exact revision the inspection completed at, then
demonstrate the pre-completion revision-conflict race -- a signature drawn
against a stale revision is rejected outright (409 `revision_conflict`),
forcing a refresh + re-sign rather than silently completing. Cleans up.

Run with: python -m poetry run python -m scripts.verify_signature_completion
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
from app.inspections.service import InspectionService, InspectionServiceError
from app.models.api import (
    CompleteInspectionRequest,
    CreateInspectionRequest,
    UpdateInspectionRequest,
)
from app.models.base import CompanyScope
from app.storage.service import get_inspection_media_storage
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID

_STROKES = [{"points": [{"x": 0.1, "y": 0.2}, {"x": 0.8, "y": 0.6}, {"x": 0.4, "y": 0.9}]}]

# A spoofed signer -- proves the server ignores it entirely (identity always
# comes from `actor_uid`/`actor_role_key`, never the request body).
_SPOOFED_SIGNER = {"signer_uid": "attacker-uid", "signer_name": "Not The Real Signer"}


async def main() -> None:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    service = InspectionService(
        inspections=InspectionRepository(client, audit),
        assets=AssetRepository(client, audit),
        checklist_templates=ChecklistTemplateRepository(client, audit),
        users=UserRepository(client, audit),
        storage=get_inspection_media_storage(),
    )
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    users = UserRepository(client)
    # The placeholder seed uid (`FIELD_INSPECTOR_UID`) only exists until a
    # real-creds auth session migrates it to a real Firebase-issued uid (see
    # `UserRepository.migrate_seed_user_id`) -- a prior session's real-creds
    # work already did this on this project, so `complete_inspection`'s
    # signer lookup needs the CURRENT real uid, not the placeholder.
    field_inspector = next(
        (u for u in await users.list(scope) if u.email == "field_inspector@acme.example.invalid"),
        None,
    )
    assert field_inspector is not None, "seeded field_inspector user was not found"
    actor_uid = field_inspector.id
    actor_role_key = "field_inspector"
    print(f"resolved field_inspector real uid: {actor_uid}")

    created_inspection_ids: list[str] = []
    try:
        # --- 1: sign a real inspection, confirm server-derived identity + revision binding
        inspection_id = str(uuid4())
        created, _ = await service.create_draft(
            scope,
            CreateInspectionRequest(
                id=inspection_id,
                asset_id=ASSET_FEED_PUMP_ID,
                inspection_type="ad_hoc",
                client_created_at=datetime.now(UTC),
            ),
            actor_uid,
        )
        created_inspection_ids.append(inspection_id)
        print(f"created inspection {inspection_id} at revision={created.revision}")

        request_payload = CompleteInspectionRequest.model_validate(
            {
                "strokes": _STROKES,
                "expected_revision": created.revision,
                **_SPOOFED_SIGNER,  # extra fields -- pydantic silently ignores them
            }
        )
        completed = await service.complete_inspection(
            scope, inspection_id, request_payload, actor_uid, actor_role_key
        )
        assert completed.signature is not None
        assert completed.signature.signer_uid == actor_uid, (
            f"expected signer_uid={actor_uid!r}, got {completed.signature.signer_uid!r} "
            "(spoofed client value must be ignored)"
        )
        assert completed.signature.signer_name == "Acme Field Inspector", (
            f"expected signer_name='Acme Field Inspector', "
            f"got {completed.signature.signer_name!r}"
        )
        assert completed.signature.signer_role == actor_role_key
        assert completed.signature.inspection_revision == completed.revision, (
            f"expected signature bound to final revision {completed.revision}, "
            f"got {completed.signature.inspection_revision}"
        )
        print(
            "PASS: signature persisted with server-derived identity "
            f"(signer={completed.signature.signer_name!r}, "
            f"role={completed.signature.signer_role!r}) "
            f"bound to revision {completed.signature.inspection_revision}"
        )

        # --- 2: the pre-completion revision-conflict race -- a stale expected_revision
        # (captured before a concurrent edit landed) must be rejected, not silently applied.
        race_id = str(uuid4())
        race_created, _ = await service.create_draft(
            scope,
            CreateInspectionRequest(
                id=race_id,
                asset_id=ASSET_FEED_PUMP_ID,
                inspection_type="ad_hoc",
                client_created_at=datetime.now(UTC),
            ),
            actor_uid,
        )
        created_inspection_ids.append(race_id)
        stale_revision = race_created.revision
        edited = await service.update_inspection(
            scope,
            race_id,
            UpdateInspectionRequest(notes="a concurrent edit lands before the signature syncs"),
            actor_uid,
        )
        assert edited.revision != stale_revision
        print(
            f"inspection {race_id} edited to revision={edited.revision} "
            f"(signature was drawn against stale revision={stale_revision})"
        )

        try:
            await service.complete_inspection(
                scope,
                race_id,
                CompleteInspectionRequest(strokes=_STROKES, expected_revision=stale_revision),
                actor_uid,
                actor_role_key,
            )
            raise AssertionError("expected complete_inspection to reject the stale revision")
        except InspectionServiceError as error:
            assert error.code == "revision_conflict", (
                f"expected 'revision_conflict', got {error.code!r}"
            )
            print(f"PASS: stale signature rejected with 409 {error.code!r} -- {error.message}")

        # Re-sign against the now-current revision succeeds (the actual "re-sign" flow).
        resigned = await service.complete_inspection(
            scope,
            race_id,
            CompleteInspectionRequest(strokes=_STROKES, expected_revision=edited.revision),
            actor_uid,
            actor_role_key,
        )
        assert resigned.signature is not None
        assert resigned.signature.inspection_revision == resigned.revision
        print(
            f"PASS: re-sign against the current revision succeeded "
            f"(revision={resigned.revision})"
        )
    finally:
        for inspection_id in created_inspection_ids:
            try:
                await service.delete_inspection(scope, inspection_id, actor_uid)
                print(f"cleaned up inspection {inspection_id}")
            except Exception as error:  # noqa: BLE001 -- best-effort cleanup
                print(f"warning: failed to clean up inspection {inspection_id}: {error}")


if __name__ == "__main__":
    asyncio.run(main())
