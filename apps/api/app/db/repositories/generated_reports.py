from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    GeneratedReport,
    GeneratedReportCreate,
    ReportExport,
    ReportNarrative,
)

GENERATED_REPORT_QUERY_CAP = 5000


class ReportRevisionConflictError(Exception):
    def __init__(self, current: GeneratedReport) -> None:
        self.current = current


class ReportImmutableError(Exception):
    def __init__(self, current: GeneratedReport) -> None:
        self.current = current


class GeneratedReportRepository(TenantRepository[GeneratedReport]):
    collection_name = "generated_reports"
    target_type = "generated_report"
    model_type = GeneratedReport

    async def create(
        self, scope: CompanyScope, payload: GeneratedReportCreate, actor_uid: str
    ) -> GeneratedReport:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def query(
        self,
        scope: CompanyScope,
        *,
        report_type: str | None = None,
        status: str | None = None,
    ) -> list[GeneratedReport]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if report_type is not None:
            query = query.where(filter=FieldFilter("report_type", "==", report_type))
        elif status is not None:
            query = query.where(filter=FieldFilter("status", "==", status))
        results: list[GeneratedReport] = []
        try:
            ordered_query = query.order_by("created_at", direction="DESCENDING")
            async for snapshot in ordered_query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
                data = snapshot.to_dict()
                if data is not None and data.get("company_id") == scope.company_id:
                    results.append(self.model_type.model_validate(data))
                if len(results) >= GENERATED_REPORT_QUERY_CAP:
                    break
        except Exception:
            results.clear()
            async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
                data = snapshot.to_dict()
                if data is not None and data.get("company_id") == scope.company_id:
                    results.append(self.model_type.model_validate(data))
                if len(results) >= GENERATED_REPORT_QUERY_CAP:
                    break
            results.sort(key=lambda r: r.created_at, reverse=True)
        return results

    async def update_draft(
        self,
        scope: CompanyScope,
        report_id: str,
        *,
        title: str | None,
        narrative: ReportNarrative,
        expected_revision: int,
        actor_uid: str,
    ) -> GeneratedReport:
        current = await self._checked_draft(scope, report_id, expected_revision)
        now = utc_now()
        model = self.model_type.model_validate(
            {
                **current.model_dump(),
                "title": title if title is not None else current.title,
                "narrative": narrative.model_dump(),
                "revision": current.revision + 1,
                "updated_at": now,
            }
        )
        return await self._write(scope, current, model, actor_uid, "updated")

    async def finalize(
        self,
        scope: CompanyScope,
        report_id: str,
        *,
        expected_revision: int,
        actor_uid: str,
    ) -> GeneratedReport:
        current = await self._checked_draft(scope, report_id, expected_revision)
        now = utc_now()
        model = self.model_type.model_validate(
            {
                **current.model_dump(),
                "status": "finalized",
                "finalized_by": actor_uid,
                "finalized_at": now,
                "finalization_attestation": True,
                "revision": current.revision + 1,
                "updated_at": now,
            }
        )
        return await self._write(scope, current, model, actor_uid, "finalized")

    async def regenerate(
        self,
        scope: CompanyScope,
        report_id: str,
        *,
        source_snapshot: dict[str, object],
        source_revision: int | None,
        narrative: ReportNarrative,
        ai_model: str,
        expected_revision: int,
        actor_uid: str,
    ) -> GeneratedReport:
        current = await self._checked_draft(scope, report_id, expected_revision)
        model = self.model_type.model_validate(
            {
                **current.model_dump(),
                "source_snapshot": source_snapshot,
                "source_revision": source_revision,
                "narrative": narrative.model_dump(),
                "ai_model": ai_model,
                "revision": current.revision + 1,
                "updated_at": utc_now(),
            }
        )
        return await self._write(scope, current, model, actor_uid, "regenerated")

    async def record_export(
        self, scope: CompanyScope, report_id: str, item: ReportExport, actor_uid: str
    ) -> GeneratedReport:
        current = await self.get(scope, report_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("generated report not found in company scope")
        if current.status != "finalized":
            raise ReportImmutableError(current)
        exports = [existing for existing in current.exports if existing.format != item.format]
        exports.append(item)
        model = self.model_type.model_validate(
            {**current.model_dump(), "exports": exports, "updated_at": utc_now()}
        )
        return await self._write(scope, current, model, actor_uid, "exported")

    async def soft_delete_draft(
        self, scope: CompanyScope, report_id: str, actor_uid: str
    ) -> GeneratedReport:
        current = await self._checked_draft(scope, report_id, None)
        now = utc_now()
        model = self.model_type.model_validate(
            {
                **current.model_dump(),
                "deleted_at": now,
                "updated_at": now,
                "revision": current.revision + 1,
            }
        )
        return await self._write(scope, current, model, actor_uid, "deleted")

    async def _checked_draft(
        self, scope: CompanyScope, report_id: str, expected_revision: int | None
    ) -> GeneratedReport:
        current = await self.get(scope, report_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("generated report not found in company scope")
        if expected_revision is not None and current.revision != expected_revision:
            raise ReportRevisionConflictError(current)
        if current.status != "draft":
            raise ReportImmutableError(current)
        return current

    async def _write(
        self,
        scope: CompanyScope,
        current: GeneratedReport,
        model: GeneratedReport,
        actor_uid: str,
        action: str,
    ) -> GeneratedReport:
        await self._collection.document(current.id).set(
            model.model_dump(), timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"generated_report.{action}",
            target_id=current.id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model
