from google.cloud.firestore_v1 import FieldFilter

from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS, TenantRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import CorrectiveAction, SafetyEvidence, SafetyReport, SafetyReportCreate

SAFETY_REPORT_QUERY_CAP = 5000


class SafetyReportRevisionConflictError(Exception):
    def __init__(self, current: SafetyReport) -> None:
        self.current = current


class SafetyReportInvalidTransitionError(Exception):
    def __init__(self, current: SafetyReport) -> None:
        self.current = current


class SafetyReportRepository(TenantRepository[SafetyReport]):
    collection_name = "safety_reports"
    target_type = "safety_report"
    model_type = SafetyReport

    async def create(
        self, scope: CompanyScope, payload: SafetyReportCreate, actor_uid: str
    ) -> SafetyReport:
        return await self._create(scope, payload.id, payload.model_dump(), actor_uid)

    async def count(self, scope: CompanyScope, *, category: str | None = None) -> int:
        """Count active tenant reports without downloading report documents."""
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        query = query.where(filter=FieldFilter("deleted_at", "==", None))
        if category is not None:
            query = query.where(filter=FieldFilter("category", "==", category))
        result = await query.count().get(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None)
        return int(result[0][0].value)

    async def query(
        self, scope: CompanyScope, *, status: str | None = None, category: str | None = None
    ) -> list[SafetyReport]:
        query = self._collection.where(filter=FieldFilter("company_id", "==", scope.company_id))
        if status is not None:
            query = query.where(filter=FieldFilter("status", "==", status))
        elif category is not None:
            query = query.where(filter=FieldFilter("category", "==", category))
        query = query.order_by("created_at", direction="DESCENDING")
        results: list[SafetyReport] = []
        async for snapshot in query.stream(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS):
            data = snapshot.to_dict()
            if data is not None and data.get("company_id") == scope.company_id:
                results.append(self.model_type.model_validate(data))
            if len(results) >= SAFETY_REPORT_QUERY_CAP:
                break
        return results

    async def assign(
        self,
        scope: CompanyScope,
        report_id: str,
        manager_id: str,
        actor_uid: str,
        expected_revision: int | None,
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, expected_revision)
        if current.status in {"closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        return await self._write(
            scope,
            current,
            actor_uid,
            "assigned",
            {"assigned_manager_id": manager_id, "assigned_at": utc_now()},
        )

    async def transition(
        self,
        scope: CompanyScope,
        report_id: str,
        next_status: str,
        actor_uid: str,
        expected_revision: int | None,
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, expected_revision)
        allowed = {
            "reported": {"under_review", "cancelled"},
            "under_review": {"corrective_action", "cancelled"},
            "corrective_action": {"resolved", "cancelled"},
        }
        if next_status not in allowed.get(current.status, set()):
            raise SafetyReportInvalidTransitionError(current)
        if next_status == "resolved" and (
            not current.corrective_actions
            or any(
                action.status not in {"completed", "cancelled"}
                for action in current.corrective_actions
            )
        ):
            raise SafetyReportInvalidTransitionError(current)
        extras: dict[str, object] = {"status": next_status}
        if next_status == "resolved":
            extras["resolved_at"] = utc_now()
        if next_status == "cancelled":
            extras["cancelled_at"] = utc_now()
        return await self._write(scope, current, actor_uid, next_status, extras)

    async def close(self, scope: CompanyScope, report_id: str, actor_uid: str) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        if current.status != "resolved":
            raise SafetyReportInvalidTransitionError(current)
        return await self._write(
            scope,
            current,
            actor_uid,
            "closed",
            {"status": "closed", "closed_at": utc_now(), "closed_by": actor_uid},
        )

    async def soft_delete(
        self, scope: CompanyScope, report_id: str, actor_uid: str
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        return await self._write(scope, current, actor_uid, "deleted", {"deleted_at": utc_now()})

    async def append_evidence(
        self, scope: CompanyScope, report_id: str, evidence: SafetyEvidence, actor_uid: str
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        if current.status in {"closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        return await self._write(
            scope,
            current,
            actor_uid,
            "evidence_added",
            {"evidence": [*current.evidence, evidence]},
        )

    async def remove_evidence(
        self, scope: CompanyScope, report_id: str, evidence_id: str, actor_uid: str
    ) -> tuple[SafetyReport, SafetyEvidence]:
        current = await self._checked(scope, report_id, None)
        if current.status in {"closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        evidence = next((item for item in current.evidence if item.id == evidence_id), None)
        if evidence is None:
            raise LookupError("safety evidence not found")
        updated = await self._write(
            scope,
            current,
            actor_uid,
            "evidence_removed",
            {"evidence": [item for item in current.evidence if item.id != evidence_id]},
        )
        return updated, evidence

    async def add_action(
        self, scope: CompanyScope, report_id: str, action: CorrectiveAction, actor_uid: str
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        if current.status in {"resolved", "closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        if any(item.id == action.id for item in current.corrective_actions):
            raise ValueError("corrective action id already exists")
        return await self._write(
            scope,
            current,
            actor_uid,
            "corrective_action_added",
            {"corrective_actions": [*current.corrective_actions, action]},
        )

    async def update_action(
        self,
        scope: CompanyScope,
        report_id: str,
        action_id: str,
        status: str,
        completion_notes: str | None,
        actor_uid: str,
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        if current.status in {"resolved", "closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        action = next((item for item in current.corrective_actions if item.id == action_id), None)
        if action is None:
            raise LookupError("corrective action not found")
        allowed = {"open": {"in_progress", "completed"}, "in_progress": {"completed"}}
        if status not in allowed.get(action.status, set()):
            raise SafetyReportInvalidTransitionError(current)
        now = utc_now()
        replacement = action.model_copy(
            update={
                "status": status,
                "completion_notes": completion_notes,
                "started_at": now if status == "in_progress" else action.started_at,
                "completed_at": now if status == "completed" else None,
                "completed_by": actor_uid if status == "completed" else None,
                "updated_at": now,
            }
        )
        return await self._write(
            scope,
            current,
            actor_uid,
            "corrective_action_updated",
            {
                "corrective_actions": [
                    replacement if item.id == action_id else item
                    for item in current.corrective_actions
                ]
            },
        )

    async def cancel_action(
        self, scope: CompanyScope, report_id: str, action_id: str, reason: str, actor_uid: str
    ) -> SafetyReport:
        current = await self._checked(scope, report_id, None)
        if current.status in {"resolved", "closed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        action = next((item for item in current.corrective_actions if item.id == action_id), None)
        if action is None:
            raise LookupError("corrective action not found")
        if action.status in {"completed", "cancelled"}:
            raise SafetyReportInvalidTransitionError(current)
        now = utc_now()
        replacement = action.model_copy(
            update={
                "status": "cancelled",
                "cancellation_reason": reason,
                "cancelled_at": now,
                "cancelled_by": actor_uid,
                "updated_at": now,
            }
        )
        return await self._write(
            scope,
            current,
            actor_uid,
            "corrective_action_cancelled",
            {
                "corrective_actions": [
                    replacement if item.id == action_id else item
                    for item in current.corrective_actions
                ]
            },
        )

    async def _checked(
        self, scope: CompanyScope, report_id: str, expected_revision: int | None
    ) -> SafetyReport:
        current = await self.get(scope, report_id)
        if current is None or current.deleted_at is not None:
            raise LookupError("safety report not found")
        if expected_revision is not None and current.revision != expected_revision:
            raise SafetyReportRevisionConflictError(current)
        return current

    async def _write(
        self,
        scope: CompanyScope,
        current: SafetyReport,
        actor_uid: str,
        action: str,
        changes: dict[str, object],
    ) -> SafetyReport:
        data = {
            **current.model_dump(),
            **changes,
            "revision": current.revision + 1,
            "updated_at": utc_now(),
        }
        model = self.model_type.model_validate(data)
        await self._collection.document(current.id).set(
            model.model_dump(), timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None
        )
        await self._write_audit(
            scope,
            actor_uid=actor_uid,
            action=f"safety_report.{action}",
            target_id=current.id,
            metadata={
                "before": current.model_dump(mode="json"),
                "after": model.model_dump(mode="json"),
            },
        )
        return model
