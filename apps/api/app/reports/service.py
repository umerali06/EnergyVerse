import base64
import binascii
from typing import Any, NoReturn

from app.ai.report_client import (
    ReportNarrativeClient,
    ReportNarrativeError,
    get_report_narrative_client,
)
from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.generated_reports import (
    GeneratedReportRepository,
    ReportImmutableError,
    ReportRevisionConflictError,
)
from app.db.repositories.inspections import InspectionRepository
from app.db.repositories.safety_reports import SafetyReportRepository
from app.db.repositories.work_orders import WorkOrderRepository
from app.models.api import (
    CreateGeneratedReportRequest,
    FinalizeGeneratedReportRequest,
    GeneratedReportDeleted,
    GeneratedReportDetail,
    GeneratedReportExportResponse,
    GeneratedReportListItem,
    GeneratedReportListPage,
    RegenerateGeneratedReportRequest,
    ReportDashboardSummary,
    ReportNarrativeResponse,
    UpdateGeneratedReportRequest,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import (
    CurrentUser,
    GeneratedReport,
    GeneratedReportCreate,
    ReportExport,
    ReportNarrative,
)
from app.reports.renderers import CONTENT_TYPES, RENDERERS
from app.storage.service import GeneratedReportStorage

REPORT_LIST_DEFAULT_LIMIT = 25
SOURCE_PERMISSION = {
    "inspection": "inspections.read",
    "maintenance": "work_orders.read",
    "safety": "safety.read",
    "executive_summary": "reports.read",
    "asset_health": "assets.read",
}


class GeneratedReportServiceError(Exception):
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


def _encode_cursor(report_id: str) -> str:
    return base64.urlsafe_b64encode(report_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise GeneratedReportServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(report: GeneratedReport) -> GeneratedReportListItem:
    return GeneratedReportListItem(
        id=report.id,
        report_type=report.report_type,
        source_id=report.source_id,
        title=report.title,
        status=report.status,
        revision=report.revision,
        created_by=report.created_by,
        created_at=report.created_at,
        updated_at=report.updated_at,
        finalized_by=report.finalized_by,
        finalized_at=report.finalized_at,
    )


def _to_detail(report: GeneratedReport) -> GeneratedReportDetail:
    return GeneratedReportDetail(
        **_to_list_item(report).model_dump(),
        source_snapshot=report.source_snapshot,
        source_revision=report.source_revision,
        narrative=ReportNarrativeResponse.model_validate(report.narrative.model_dump()),
        ai_model=report.ai_model,
        finalization_attestation=report.finalization_attestation,
    )


class GeneratedReportService:
    def __init__(
        self,
        *,
        reports: GeneratedReportRepository,
        companies: CompanyRepository,
        assets: AssetRepository,
        inspections: InspectionRepository,
        work_orders: WorkOrderRepository,
        safety_reports: SafetyReportRepository,
        narrative_client: ReportNarrativeClient,
        storage: GeneratedReportStorage,
    ) -> None:
        self._reports = reports
        self._companies = companies
        self._assets = assets
        self._inspections = inspections
        self._work_orders = work_orders
        self._safety_reports = safety_reports
        self._narrative_client = narrative_client
        self._storage = storage

    async def get_dashboard_summary(self, scope: CompanyScope) -> ReportDashboardSummary:
        reports = await self._reports.query(scope)
        active = [r for r in reports if r.deleted_at is None]
        drafts = sum(1 for r in active if r.status == "draft")
        finalized = sum(1 for r in active if r.status == "finalized")
        return ReportDashboardSummary(
            total=len(active),
            drafts=drafts,
            finalized=finalized,
        )

    async def list_reports(
        self,
        scope: CompanyScope,
        *,
        report_type: str | None,
        status: str | None,
        cursor: str | None,
        limit: int = REPORT_LIST_DEFAULT_LIMIT,
    ) -> GeneratedReportListPage:
        reports = [
            item
            for item in await self._reports.query(scope, report_type=report_type, status=status)
            if item.deleted_at is None
            and (report_type is None or item.report_type == report_type)
            and (status is None or item.status == status)
        ]
        start = 0
        if cursor:
            cursor_id = _decode_cursor(cursor)
            try:
                start = (
                    next(index for index, item in enumerate(reports) if item.id == cursor_id) + 1
                )
            except StopIteration as error:
                raise GeneratedReportServiceError(
                    422, "invalid_cursor", "Cursor does not reference this result set"
                ) from error
        page = reports[start : start + limit]
        next_cursor = _encode_cursor(page[-1].id) if page and start + limit < len(reports) else None
        return GeneratedReportListPage(
            items=[_to_list_item(item) for item in page], next_cursor=next_cursor
        )

    async def get_report(self, scope: CompanyScope, report_id: str) -> GeneratedReportDetail:
        return _to_detail(await self._active_report(scope, report_id))

    async def create_report(
        self, scope: CompanyScope, request: CreateGeneratedReportRequest, user: CurrentUser
    ) -> GeneratedReportDetail:
        required = SOURCE_PERMISSION[request.report_type]
        if required not in user.permissions:
            raise GeneratedReportServiceError(
                403,
                "source_permission_required",
                f"Generating this report requires '{required}'",
                {"required": required},
            )
        requires_source = request.report_type != "executive_summary"
        if requires_source != (request.source_id is not None):
            raise GeneratedReportServiceError(
                422,
                "invalid_report_source",
                "source_id is required for source reports and forbidden for executive summaries",
            )
        snapshot, source_revision, default_title = await self._assemble_snapshot(
            scope, request.report_type, request.source_id
        )
        try:
            narrative = await self._narrative_client.generate(request.report_type, snapshot)
        except ReportNarrativeError as error:
            raise GeneratedReportServiceError(
                502, "report_generation_failed", "AI report narrative generation failed"
            ) from error
        payload = GeneratedReportCreate(
            id=request.id,
            report_type=request.report_type,
            source_id=request.source_id,
            title=request.title or default_title,
            source_snapshot=snapshot,
            source_revision=source_revision,
            narrative=narrative,
            ai_model=self._narrative_client.model_name,
        )
        try:
            return _to_detail(await self._reports.create(scope, payload, user.uid))
        except ValueError as error:
            raise GeneratedReportServiceError(
                409, "generated_report_exists", "A generated report with this ID already exists"
            ) from error
        except PermissionError as error:
            raise GeneratedReportServiceError(
                404, "generated_report_not_found", "Generated report was not found"
            ) from error

    async def update_report(
        self,
        scope: CompanyScope,
        report_id: str,
        request: UpdateGeneratedReportRequest,
        actor_uid: str,
    ) -> GeneratedReportDetail:
        current = await self._active_report(scope, report_id)
        narrative = ReportNarrative(
            summary=request.summary or current.narrative.summary,
            findings=(
                request.findings if request.findings is not None else current.narrative.findings
            ),
            recommendations=(
                request.recommendations
                if request.recommendations is not None
                else current.narrative.recommendations
            ),
            risk_score=(
                request.risk_score
                if request.risk_score is not None
                else current.narrative.risk_score
            ),
        )
        try:
            updated = await self._reports.update_draft(
                scope,
                report_id,
                title=request.title,
                narrative=narrative,
                expected_revision=request.expected_revision,
                actor_uid=actor_uid,
            )
        except (ReportRevisionConflictError, ReportImmutableError) as error:
            self._raise_conflict(error)
        return _to_detail(updated)

    async def finalize_report(
        self,
        scope: CompanyScope,
        report_id: str,
        request: FinalizeGeneratedReportRequest,
        actor_uid: str,
    ) -> GeneratedReportDetail:
        current = await self._active_report(scope, report_id)
        if current.report_type == "inspection":
            analyses = current.source_snapshot.get("source", {}).get("ai_analysis", [])
            if any(not item.get("reviewed", False) for item in analyses):
                raise GeneratedReportServiceError(
                    409,
                    "unreviewed_ai_findings",
                    "Every included inspection AI analysis must be reviewed before finalization",
                )
        try:
            finalized = await self._reports.finalize(
                scope,
                report_id,
                expected_revision=request.expected_revision,
                actor_uid=actor_uid,
            )
        except (ReportRevisionConflictError, ReportImmutableError) as error:
            self._raise_conflict(error)
        return _to_detail(finalized)

    async def regenerate_report(
        self,
        scope: CompanyScope,
        report_id: str,
        request: RegenerateGeneratedReportRequest,
        user: CurrentUser,
    ) -> GeneratedReportDetail:
        current = await self._active_report(scope, report_id)
        required = SOURCE_PERMISSION[current.report_type]
        if required not in user.permissions:
            raise GeneratedReportServiceError(
                403,
                "source_permission_required",
                f"Regenerating this report requires '{required}'",
                {"required": required},
            )
        snapshot, source_revision, _ = await self._assemble_snapshot(
            scope, current.report_type, current.source_id
        )
        try:
            narrative = await self._narrative_client.generate(current.report_type, snapshot)
        except ReportNarrativeError as error:
            raise GeneratedReportServiceError(
                502, "report_generation_failed", "AI report narrative generation failed"
            ) from error
        try:
            regenerated = await self._reports.regenerate(
                scope,
                report_id,
                source_snapshot=snapshot,
                source_revision=source_revision,
                narrative=narrative,
                ai_model=self._narrative_client.model_name,
                expected_revision=request.expected_revision,
                actor_uid=user.uid,
            )
        except (ReportRevisionConflictError, ReportImmutableError) as error:
            self._raise_conflict(error)
        return _to_detail(regenerated)

    async def delete_report(
        self, scope: CompanyScope, report_id: str, actor_uid: str
    ) -> GeneratedReportDeleted:
        await self._active_report(scope, report_id)
        try:
            await self._reports.soft_delete_draft(scope, report_id, actor_uid)
        except ReportImmutableError as error:
            self._raise_conflict(error)
        return GeneratedReportDeleted(id=report_id)

    async def export_report(
        self, scope: CompanyScope, report_id: str, export_format: str, actor_uid: str
    ) -> GeneratedReportExportResponse:
        report = await self._active_report(scope, report_id)
        if report.status != "finalized":
            raise GeneratedReportServiceError(
                409, "report_not_finalized", "Only finalized reports can be exported"
            )
        renderer = RENDERERS.get(export_format)
        if renderer is None:
            raise GeneratedReportServiceError(
                422, "unsupported_export_format", "Format must be pdf, docx, or xlsx"
            )
        data = renderer(report)
        filename = f"{report.id}.{export_format}"
        content_type = CONTENT_TYPES[export_format]
        path = self._storage.upload(scope.company_id, report.id, filename, data, content_type)
        item = ReportExport(
            format=export_format,
            path=path,
            filename=filename,
            content_type=content_type,
            size=len(data),
            generated_by=actor_uid,
            generated_at=utc_now(),
        )
        await self._reports.record_export(scope, report.id, item, actor_uid)
        return GeneratedReportExportResponse(
            report_id=report.id,
            **item.model_dump(exclude={"path"}),
            url=self._storage.signed_url_for(path),
        )

    async def _active_report(self, scope: CompanyScope, report_id: str) -> GeneratedReport:
        report = await self._reports.get(scope, report_id)
        if report is None or report.deleted_at is not None:
            raise GeneratedReportServiceError(
                404, "generated_report_not_found", "Generated report was not found"
            )
        return report

    def _raise_conflict(self, error: Exception) -> None:
        current = error.current  # type: ignore[attr-defined]
        if isinstance(error, ReportRevisionConflictError):
            raise GeneratedReportServiceError(
                409,
                "revision_conflict",
                "Generated report was modified since you last loaded it",
                {"current_revision": current.revision},
            ) from error
        raise GeneratedReportServiceError(
            409, "finalized_report_immutable", "Finalized reports are immutable"
        ) from error

    async def _assemble_snapshot(
        self, scope: CompanyScope, report_type: str, source_id: str | None
    ) -> tuple[dict[str, Any], int | None, str]:
        company = await self._companies.get(scope)
        if company is None:
            raise GeneratedReportServiceError(404, "company_not_found", "Company was not found")
        company_snapshot = company.model_dump(mode="json")

        if report_type == "inspection":
            inspection = await self._inspections.get(scope, source_id or "")
            if inspection is None or inspection.deleted_at is not None:
                self._source_not_found("inspection")
            return (
                {"company": company_snapshot, "source": inspection.model_dump(mode="json")},
                inspection.revision,
                f"Inspection Report — {inspection.title or inspection.id}",
            )
        if report_type == "maintenance":
            work_order = await self._work_orders.get(scope, source_id or "")
            if work_order is None or work_order.deleted_at is not None:
                self._source_not_found("work order")
            return (
                {"company": company_snapshot, "source": work_order.model_dump(mode="json")},
                work_order.revision,
                f"Maintenance Report — {work_order.title}",
            )
        if report_type == "safety":
            safety_report = await self._safety_reports.get(scope, source_id or "")
            if safety_report is None or safety_report.deleted_at is not None:
                self._source_not_found("safety report")
            return (
                {"company": company_snapshot, "source": safety_report.model_dump(mode="json")},
                safety_report.revision,
                f"Safety Report — {safety_report.title}",
            )
        if report_type == "asset_health":
            asset = await self._assets.get(scope, source_id or "")
            if asset is None or asset.deleted_at is not None:
                self._source_not_found("asset")
            inspections = await self._inspections.query(scope, asset_id=asset.id)
            work_orders = await self._work_orders.query(scope, asset_id=asset.id)
            return (
                {
                    "company": company_snapshot,
                    "source": asset.model_dump(mode="json"),
                    "inspections": [
                        item.model_dump(mode="json")
                        for item in inspections
                        if item.deleted_at is None
                    ],
                    "work_orders": [
                        item.model_dump(mode="json")
                        for item in work_orders
                        if item.deleted_at is None
                    ],
                },
                None,
                f"Asset Health Report — {asset.name}",
            )

        assets = await self._assets.query(
            scope, facility_id=None, category=None, current_status=None
        )
        inspections = await self._inspections.query(scope)
        work_orders = await self._work_orders.query(scope)
        safety_reports = await self._safety_reports.query(scope)
        active_assets = [item for item in assets if item.deleted_at is None]
        active_inspections = [item for item in inspections if item.deleted_at is None]
        active_work_orders = [item for item in work_orders if item.deleted_at is None]
        active_safety = [item for item in safety_reports if item.deleted_at is None]
        return (
            {
                "company": company_snapshot,
                "metrics": {
                    "total_assets": len(active_assets),
                    "critical_assets": sum(
                        item.current_status == "Critical" for item in active_assets
                    ),
                    "completed_inspections": sum(
                        item.status == "completed" for item in active_inspections
                    ),
                    "open_work_orders": sum(
                        item.status not in {"closed", "cancelled"} for item in active_work_orders
                    ),
                    "active_safety_incidents": sum(
                        item.status not in {"closed", "cancelled"} for item in active_safety
                    ),
                },
            },
            None,
            "Executive Summary",
        )

    def _source_not_found(self, source_name: str) -> NoReturn:
        raise GeneratedReportServiceError(
            404, "report_source_not_found", f"The requested {source_name} was not found"
        )


def get_generated_report_service() -> GeneratedReportService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return GeneratedReportService(
        reports=GeneratedReportRepository(client, audit),
        companies=CompanyRepository(client, audit),
        assets=AssetRepository(client, audit),
        inspections=InspectionRepository(client, audit),
        work_orders=WorkOrderRepository(client, audit),
        safety_reports=SafetyReportRepository(client, audit),
        narrative_client=get_report_narrative_client(),
        storage=GeneratedReportStorage(),
    )
