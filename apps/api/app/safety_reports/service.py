import asyncio
import base64
import binascii
from collections.abc import Awaitable
from pathlib import Path
from uuid import uuid4

from fastapi import UploadFile

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.safety_reports import (
    SafetyReportInvalidTransitionError,
    SafetyReportRepository,
    SafetyReportRevisionConflictError,
)
from app.db.repositories.users import UserRepository
from app.models.api import (
    AssignSafetyReportRequest,
    CancelCorrectiveActionRequest,
    CorrectiveActionResponse,
    CreateCorrectiveActionRequest,
    CreateSafetyReportRequest,
    SafetyCategoryCount,
    SafetyDashboardSummary,
    SafetyEvidenceResponse,
    SafetyReportDeleted,
    SafetyReportDetail,
    SafetyReportListItem,
    SafetyReportListPage,
    TransitionSafetyReportRequest,
    UpdateCorrectiveActionRequest,
)
from app.models.base import CompanyScope, utc_now
from app.models.entities import CorrectiveAction, SafetyEvidence, SafetyReport, SafetyReportCreate
from app.safety_reports.constants import SAFETY_CATEGORIES
from app.storage.service import SafetyEvidenceStorage

EVIDENCE_RULES = {
    "photo": (
        {"image/jpeg", "image/png", "image/webp", "image/heic"},
        10 * 1024 * 1024,
    ),
    "video": ({"video/mp4", "video/quicktime", "video/webm"}, 250 * 1024 * 1024),
}


class SafetyReportServiceError(Exception):
    def __init__(
        self, status_code: int, code: str, message: str, details: dict[str, object] | None = None
    ) -> None:
        self.status_code, self.code, self.message, self.details = (
            status_code,
            code,
            message,
            details,
        )


def _item(report: SafetyReport) -> SafetyReportListItem:
    return SafetyReportListItem(**report.model_dump(include=set(SafetyReportListItem.model_fields)))


def _detail(report: SafetyReport, storage: SafetyEvidenceStorage) -> SafetyReportDetail:
    values = report.model_dump(include=set(SafetyReportDetail.model_fields))
    values["evidence"] = [
        SafetyEvidenceResponse(
            **item.model_dump(exclude={"path"}), url=storage.signed_url_for(item.path)
        )
        for item in report.evidence
    ]
    values["corrective_actions"] = [
        CorrectiveActionResponse(**item.model_dump()) for item in report.corrective_actions
    ]
    return SafetyReportDetail(**values)


class SafetyReportService:
    def __init__(
        self,
        reports: SafetyReportRepository,
        users: UserRepository,
        storage: SafetyEvidenceStorage,
    ) -> None:
        self._reports = reports
        self._users = users
        self._storage = storage

    async def get_dashboard_summary(self, scope: CompanyScope) -> SafetyDashboardSummary:
        counts = await asyncio.gather(
            self._reports.count(scope),
            *(self._reports.count(scope, category=category) for category in SAFETY_CATEGORIES),
        )
        return SafetyDashboardSummary(
            total=counts[0],
            by_category=[
                SafetyCategoryCount(category=category, count=count)
                for category, count in zip(SAFETY_CATEGORIES, counts[1:], strict=True)
            ],
        )

    async def create(
        self, scope: CompanyScope, request: CreateSafetyReportRequest, actor_uid: str
    ) -> SafetyReportDetail:
        payload = SafetyReportCreate(**request.model_dump(), reporter_id=actor_uid)
        try:
            return _detail(await self._reports.create(scope, payload, actor_uid), self._storage)
        except (ValueError, PermissionError) as error:
            raise SafetyReportServiceError(
                409, "safety_report_id_conflict", "A safety report with this ID already exists"
            ) from error

    async def list(
        self,
        scope: CompanyScope,
        status: str | None,
        category: str | None,
        severity: str | None,
        reporter_id: str | None,
        cursor: str | None,
        limit: int,
    ) -> SafetyReportListPage:
        reports = [
            r
            for r in await self._reports.query(
                scope, status=status, category=None if status else category
            )
            if r.deleted_at is None
        ]
        if status and category:
            reports = [r for r in reports if r.category == category]
        if severity:
            reports = [r for r in reports if r.severity == severity]
        if reporter_id:
            reports = [r for r in reports if r.reporter_id == reporter_id]
        if cursor:
            try:
                last_id = base64.urlsafe_b64decode(cursor.encode()).decode()
            except (ValueError, binascii.Error, UnicodeDecodeError) as error:
                raise SafetyReportServiceError(
                    422, "invalid_cursor", "Cursor is not valid"
                ) from error
            ids = [r.id for r in reports]
            reports = reports[ids.index(last_id) + 1 :] if last_id in ids else []
        page = reports[:limit]
        next_cursor = (
            base64.urlsafe_b64encode(page[-1].id.encode()).decode()
            if len(reports) > limit and page
            else None
        )
        return SafetyReportListPage(items=[_item(r) for r in page], next_cursor=next_cursor)

    async def get(self, scope: CompanyScope, report_id: str) -> SafetyReportDetail:
        report = await self._reports.get(scope, report_id)
        if report is None or report.deleted_at is not None:
            raise SafetyReportServiceError(
                404, "safety_report_not_found", "Safety report was not found"
            )
        return _detail(report, self._storage)

    async def assign(
        self,
        scope: CompanyScope,
        report_id: str,
        request: AssignSafetyReportRequest,
        actor_uid: str,
    ) -> SafetyReportDetail:
        return _detail(
            await self._mutate(
                self._reports.assign(
                    scope, report_id, request.manager_id, actor_uid, request.expected_revision
                )
            ),
            self._storage,
        )

    async def transition(
        self,
        scope: CompanyScope,
        report_id: str,
        request: TransitionSafetyReportRequest,
        actor_uid: str,
    ) -> SafetyReportDetail:
        return _detail(
            await self._mutate(
                self._reports.transition(
                    scope, report_id, request.status, actor_uid, request.expected_revision
                )
            ),
            self._storage,
        )

    async def close(
        self, scope: CompanyScope, report_id: str, actor_uid: str
    ) -> SafetyReportDetail:
        return _detail(
            await self._mutate(self._reports.close(scope, report_id, actor_uid)), self._storage
        )

    async def delete(
        self, scope: CompanyScope, report_id: str, actor_uid: str
    ) -> SafetyReportDeleted:
        await self._mutate(self._reports.soft_delete(scope, report_id, actor_uid))
        return SafetyReportDeleted(id=report_id)

    async def upload_evidence(
        self,
        scope: CompanyScope,
        report_id: str,
        kind: str,
        file: UploadFile,
        actor_uid: str,
        can_manage: bool,
    ) -> SafetyReportDetail:
        report = await self._active(scope, report_id)
        if report.reporter_id != actor_uid and not can_manage:
            raise SafetyReportServiceError(
                403, "not_reporter", "Only the reporter or HSE management can add evidence"
            )
        if kind not in EVIDENCE_RULES:
            raise SafetyReportServiceError(
                422, "invalid_evidence_kind", "Evidence kind is not supported"
            )
        allowed_types, max_bytes = EVIDENCE_RULES[kind]
        content_type = file.content_type or ""
        if content_type not in allowed_types:
            raise SafetyReportServiceError(
                422,
                "invalid_evidence_type",
                "Evidence file type is not allowed",
                {"allowed_types": sorted(allowed_types)},
            )
        data = await file.read(max_bytes + 1)
        if not data:
            raise SafetyReportServiceError(422, "empty_evidence", "Uploaded evidence is empty")
        if len(data) > max_bytes:
            raise SafetyReportServiceError(
                413,
                "evidence_too_large",
                "Evidence exceeds the size limit",
                {"max_bytes": max_bytes},
            )
        filename = Path(file.filename or "evidence").name
        path = self._storage.upload(scope.company_id, report_id, filename, data, content_type)
        evidence = SafetyEvidence(
            id=f"evidence_{uuid4().hex}",
            path=path,
            filename=filename,
            kind=kind,
            content_type=content_type,
            size=len(data),
            uploaded_by=actor_uid,
            uploaded_at=utc_now(),
        )
        try:
            updated = await self._mutate(
                self._reports.append_evidence(scope, report_id, evidence, actor_uid)
            )
        except Exception:
            self._storage.delete(path)
            raise
        return _detail(updated, self._storage)

    async def delete_evidence(
        self,
        scope: CompanyScope,
        report_id: str,
        evidence_id: str,
        actor_uid: str,
        can_manage: bool,
    ) -> SafetyReportDetail:
        report = await self._active(scope, report_id)
        evidence = next((item for item in report.evidence if item.id == evidence_id), None)
        if evidence is None:
            raise SafetyReportServiceError(
                404, "safety_evidence_not_found", "Safety evidence was not found"
            )
        if evidence.uploaded_by != actor_uid and not can_manage:
            raise SafetyReportServiceError(
                403, "not_evidence_owner", "Only the uploader or HSE management can remove evidence"
            )
        updated, removed = await self._remove_evidence(scope, report_id, evidence_id, actor_uid)
        self._storage.delete(removed.path)
        return _detail(updated, self._storage)

    async def add_action(
        self,
        scope: CompanyScope,
        report_id: str,
        request: CreateCorrectiveActionRequest,
        actor_uid: str,
    ) -> SafetyReportDetail:
        await self._active(scope, report_id)
        assignee = await self._users.get(scope, request.assignee_id)
        if assignee is None or assignee.status != "active":
            raise SafetyReportServiceError(
                404, "assignee_not_found", "Corrective-action assignee was not found"
            )
        now = utc_now()
        action = CorrectiveAction(
            **request.model_dump(), created_by=actor_uid, created_at=now, updated_at=now
        )
        try:
            updated = await self._mutate(
                self._reports.add_action(scope, report_id, action, actor_uid)
            )
        except ValueError as error:
            raise SafetyReportServiceError(
                409,
                "corrective_action_id_conflict",
                "A corrective action with this ID already exists",
            ) from error
        return _detail(updated, self._storage)

    async def update_action(
        self,
        scope: CompanyScope,
        report_id: str,
        action_id: str,
        request: UpdateCorrectiveActionRequest,
        actor_uid: str,
        can_manage: bool,
    ) -> SafetyReportDetail:
        report = await self._active(scope, report_id)
        action = next((item for item in report.corrective_actions if item.id == action_id), None)
        if action is None:
            raise SafetyReportServiceError(
                404, "corrective_action_not_found", "Corrective action was not found"
            )
        if action.assignee_id != actor_uid and not can_manage:
            raise SafetyReportServiceError(
                403,
                "not_action_assignee",
                "Only the assignee or HSE management can update this action",
            )
        if request.status == "completed" and not request.completion_notes:
            raise SafetyReportServiceError(
                422, "completion_notes_required", "Completion notes are required"
            )
        updated = await self._mutate(
            self._reports.update_action(
                scope, report_id, action_id, request.status, request.completion_notes, actor_uid
            )
        )
        return _detail(updated, self._storage)

    async def cancel_action(
        self,
        scope: CompanyScope,
        report_id: str,
        action_id: str,
        request: CancelCorrectiveActionRequest,
        actor_uid: str,
    ) -> SafetyReportDetail:
        updated = await self._mutate(
            self._reports.cancel_action(scope, report_id, action_id, request.reason, actor_uid)
        )
        return _detail(updated, self._storage)

    async def _active(self, scope: CompanyScope, report_id: str) -> SafetyReport:
        report = await self._reports.get(scope, report_id)
        if report is None or report.deleted_at is not None:
            raise SafetyReportServiceError(
                404, "safety_report_not_found", "Safety report was not found"
            )
        return report

    async def _remove_evidence(
        self, scope: CompanyScope, report_id: str, evidence_id: str, actor_uid: str
    ) -> tuple[SafetyReport, SafetyEvidence]:
        try:
            return await self._reports.remove_evidence(scope, report_id, evidence_id, actor_uid)
        except LookupError as error:
            raise SafetyReportServiceError(
                404, "safety_evidence_not_found", "Safety evidence was not found"
            ) from error
        except SafetyReportInvalidTransitionError as error:
            raise SafetyReportServiceError(
                409,
                "invalid_transition",
                f"Safety report cannot be changed from status '{error.current.status}'",
            ) from error

    async def _mutate(self, operation: Awaitable[SafetyReport]) -> SafetyReport:
        try:
            return await operation
        except LookupError as error:
            raise SafetyReportServiceError(
                404, "safety_report_not_found", "Safety report was not found"
            ) from error
        except SafetyReportRevisionConflictError as error:
            raise SafetyReportServiceError(
                409,
                "revision_conflict",
                "Safety report was modified since you last loaded it",
                {"current_revision": error.current.revision},
            ) from error
        except SafetyReportInvalidTransitionError as error:
            raise SafetyReportServiceError(
                409,
                "invalid_transition",
                f"Safety report cannot transition from status '{error.current.status}'",
            ) from error


def get_safety_report_service() -> SafetyReportService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return SafetyReportService(
        SafetyReportRepository(client, audit),
        UserRepository(client, audit),
        SafetyEvidenceStorage(),
    )
