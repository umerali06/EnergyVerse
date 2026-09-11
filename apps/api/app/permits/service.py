import base64
import binascii
from datetime import UTC, datetime, timedelta
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.areas import AreaRepository
from app.db.repositories.assets import AssetRepository
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.facilities import FacilityRepository
from app.db.repositories.permit_templates import PermitTemplateRepository
from app.db.repositories.permits import PermitRepository, PermitRevisionConflictError
from app.db.repositories.users import UserRepository
from app.models.api import (
    AcknowledgePermitRequest,
    ActivatePermitRequest,
    ClosePermitRequest,
    ControlPermitRequest,
    CreatePermitRequest,
    DecidePermitApprovalRequest,
    PermitApprovalSnapshotResponse,
    PermitChecklistSnapshotResponse,
    PermitDashboardSummary,
    PermitDeleted,
    PermitDetail,
    PermitListItem,
    PermitListPage,
    PermitRiskAssessmentInput,
    PermitRiskAssessmentResponse,
    ResumePermitRequest,
    SubmitPermitRequest,
    UpdatePermitRequest,
)
from app.models.base import CompanyScope
from app.models.entities import (
    Permit,
    PermitApprovalSnapshotStep,
    PermitChecklistSnapshotItem,
    PermitCreate,
    PermitDigitalSignature,
    PermitRiskAssessmentItem,
    PermitRiskBand,
    PermitWorkerAcknowledgement,
)


class PermitServiceError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code, self.code, self.message, self.details = (
            status_code,
            code,
            message,
            details,
        )


def _encode_cursor(permit_id: str) -> str:
    return base64.urlsafe_b64encode(permit_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise PermitServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _band(score: int) -> PermitRiskBand:
    if score <= 4:
        return "low"
    if score <= 9:
        return "medium"
    if score <= 16:
        return "high"
    return "critical"


_RISK_ORDER: dict[PermitRiskBand, int] = {
    "low": 0,
    "medium": 1,
    "high": 2,
    "critical": 3,
}


def _highest_risk(permit: Permit) -> PermitRiskBand:
    return max(
        (item.residual_band for item in permit.risk_assessment),
        key=lambda value: _RISK_ORDER[value],
    )


def _list_item(permit: Permit) -> PermitListItem:
    return PermitListItem(
        id=permit.id,
        permit_number=permit.permit_number,
        title=permit.title,
        permit_type=permit.permit_type,
        status=permit.status,
        facility_id=permit.facility_id,
        valid_from=permit.valid_from,
        valid_until=permit.valid_until,
        worker_count=len(permit.worker_ids),
        highest_residual_risk=_highest_risk(permit),
        revision=permit.revision,
        created_at=permit.created_at,
        updated_at=permit.updated_at,
    )


def _detail(permit: Permit) -> PermitDetail:
    return PermitDetail(
        **_list_item(permit).model_dump(),
        description=permit.description,
        area_id=permit.area_id,
        asset_id=permit.asset_id,
        template_id=permit.template_id,
        template_name=permit.template_name,
        template_version=permit.template_version,
        checklist_snapshot=[
            PermitChecklistSnapshotResponse(**row.model_dump()) for row in permit.checklist_snapshot
        ],
        approval_snapshot=[
            PermitApprovalSnapshotResponse(**row.model_dump()) for row in permit.approval_snapshot
        ],
        risk_assessment=[
            PermitRiskAssessmentResponse(**row.model_dump()) for row in permit.risk_assessment
        ],
        worker_ids=permit.worker_ids,
        issuer_signature=(
            None if permit.issuer_signature is None else permit.issuer_signature.model_dump()
        ),
        submitted_at=permit.submitted_at,
        worker_acknowledgements=[row.model_dump() for row in permit.worker_acknowledgements],
        activated_by=permit.activated_by,
        activated_at=permit.activated_at,
        suspended_by=permit.suspended_by,
        suspended_at=permit.suspended_at,
        suspension_reason=permit.suspension_reason,
        revoked_by=permit.revoked_by,
        revoked_at=permit.revoked_at,
        revocation_reason=permit.revocation_reason,
        closed_by=permit.closed_by,
        closed_at=permit.closed_at,
        closeout_notes=permit.closeout_notes,
        expired_at=permit.expired_at,
    )


class PermitService:
    def __init__(
        self,
        permits: PermitRepository,
        templates: PermitTemplateRepository,
        users: UserRepository,
        facilities: FacilityRepository,
        areas: AreaRepository,
        assets: AssetRepository,
    ) -> None:
        self._permits = permits
        self._templates = templates
        self._users = users
        self._facilities = facilities
        self._areas = areas
        self._assets = assets

    async def _active(self, scope: CompanyScope, permit_id: str) -> Permit:
        permit = await self._permits.get(scope, permit_id)
        if permit is None or permit.deleted_at is not None:
            raise PermitServiceError(404, "permit_not_found", "Permit was not found")
        return await self._expire_if_due(scope, permit)

    async def _expire_if_due(self, scope: CompanyScope, permit: Permit) -> Permit:
        expirable = {"pending_approval", "pending_signatures", "active", "suspended"}
        now = datetime.now(UTC)
        if permit.status not in expirable or permit.valid_until > now:
            return permit
        try:
            return await self._permits.transition(
                scope,
                permit.id,
                expected_revision=permit.revision,
                expected_status=permit.status,
                next_status="expired",
                changes={"expired_at": now},
                actor_uid="system:permit-expiry",
                action="expired",
            )
        except (PermitRevisionConflictError, ValueError):
            refreshed = await self._permits.get(scope, permit.id)
            return refreshed if refreshed is not None else permit

    @staticmethod
    def _validity(valid_from: datetime, valid_until: datetime) -> None:
        if valid_from.tzinfo is None or valid_until.tzinfo is None:
            raise PermitServiceError(
                422, "timezone_required", "Permit validity timestamps must include a timezone"
            )
        if valid_until <= valid_from:
            raise PermitServiceError(
                422, "invalid_validity_window", "valid_until must be after valid_from"
            )

    @staticmethod
    def _risks(rows: list[PermitRiskAssessmentInput]) -> list[PermitRiskAssessmentItem]:
        seen: set[str] = set()
        result: list[PermitRiskAssessmentItem] = []
        for row in rows:
            risk_id = row.id or f"risk_{uuid4().hex[:12]}"
            if risk_id in seen:
                raise PermitServiceError(
                    422, "duplicate_risk_id", "Risk assessment item IDs must be unique"
                )
            seen.add(risk_id)
            initial_score = row.initial_likelihood * row.initial_severity
            residual_score = row.residual_likelihood * row.residual_severity
            if residual_score > initial_score:
                raise PermitServiceError(
                    422,
                    "residual_risk_increased",
                    "Residual risk cannot exceed initial risk",
                    {"risk_id": risk_id},
                )
            result.append(
                PermitRiskAssessmentItem(
                    id=risk_id,
                    **row.model_dump(exclude={"id"}),
                    initial_score=initial_score,
                    initial_band=_band(initial_score),
                    residual_score=residual_score,
                    residual_band=_band(residual_score),
                )
            )
        return result

    async def _workers(self, scope: CompanyScope, worker_ids: list[str]) -> list[str]:
        if len(set(worker_ids)) != len(worker_ids):
            raise PermitServiceError(422, "duplicate_worker", "Worker IDs must be unique")
        for worker_id in worker_ids:
            user = await self._users.get(scope, worker_id)
            if user is None or user.status != "active":
                raise PermitServiceError(
                    422,
                    "worker_not_found",
                    "An assigned worker was not found or is inactive in this company",
                    {"worker_id": worker_id},
                )
        return worker_ids

    async def _location(
        self,
        scope: CompanyScope,
        facility_id: str,
        area_id: str | None,
        asset_id: str | None,
    ) -> None:
        facility = await self._facilities.get(scope, facility_id)
        if facility is None or facility.deleted_at is not None:
            raise PermitServiceError(422, "facility_not_found", "Facility was not found")
        if area_id:
            area = await self._areas.get(scope, area_id)
            if area is None or area.deleted_at is not None or area.facility_id != facility_id:
                raise PermitServiceError(
                    422, "area_not_found", "Area was not found in the selected facility"
                )
        if asset_id:
            asset = await self._assets.get(scope, asset_id)
            if asset is None or asset.deleted_at is not None or asset.facility_id != facility_id:
                raise PermitServiceError(
                    422, "asset_not_found", "Asset was not found in the selected facility"
                )
            if area_id and asset.area_id != area_id:
                raise PermitServiceError(
                    422, "asset_area_mismatch", "Asset does not belong to the selected area"
                )

    async def list(
        self,
        scope: CompanyScope,
        permit_type: str | None,
        facility_id: str | None,
        worker_id: str | None,
        cursor: str | None,
        limit: int,
    ) -> PermitListPage:
        permits = [
            await self._expire_if_due(scope, row)
            for row in await self._permits.list(scope)
            if row.deleted_at is None
        ]
        if permit_type:
            permits = [row for row in permits if row.permit_type == permit_type]
        if facility_id:
            permits = [row for row in permits if row.facility_id == facility_id]
        if worker_id:
            permits = [row for row in permits if worker_id in row.worker_ids]
        permits.sort(key=lambda row: (row.created_at, row.id), reverse=True)
        if cursor:
            cursor_id = _decode_cursor(cursor)
            ids = [row.id for row in permits]
            permits = permits[ids.index(cursor_id) + 1 :] if cursor_id in ids else []
        page = permits[:limit]
        return PermitListPage(
            items=[_list_item(row) for row in page],
            next_cursor=_encode_cursor(page[-1].id) if len(permits) > limit and page else None,
        )

    async def reconcile_expired(self, scope: CompanyScope) -> int:
        changed = 0
        for permit in await self._permits.list(scope):
            if permit.deleted_at is not None:
                continue
            reconciled = await self._expire_if_due(scope, permit)
            if reconciled.status == "expired" and permit.status != "expired":
                changed += 1
        return changed

    async def get_dashboard_summary(self, scope: CompanyScope) -> PermitDashboardSummary:
        """Return the authoritative active count after reconciling due permits."""
        permits = [
            await self._expire_if_due(scope, row)
            for row in await self._permits.list(scope)
            if row.deleted_at is None
        ]
        return PermitDashboardSummary(
            active=sum(1 for permit in permits if permit.status == "active")
        )

    async def get(self, scope: CompanyScope, permit_id: str) -> PermitDetail:
        return _detail(await self._active(scope, permit_id))

    async def create(
        self, scope: CompanyScope, request: CreatePermitRequest, actor_uid: str
    ) -> PermitDetail:
        self._validity(request.valid_from, request.valid_until)
        await self._location(scope, request.facility_id, request.area_id, request.asset_id)
        workers = await self._workers(scope, request.worker_ids)
        template = await self._templates.get(scope, request.template_id)
        if template is None or template.deleted_at is not None:
            raise PermitServiceError(
                422, "permit_template_not_found", "Permit template was not found"
            )
        if template.permit_type != request.permit_type:
            raise PermitServiceError(
                422,
                "permit_template_type_mismatch",
                "Permit template type does not match the permit type",
            )
        permit_id = f"permit_{uuid4().hex}"
        now = datetime.now(UTC)
        permit = await self._permits.create(
            scope,
            PermitCreate(
                id=permit_id,
                permit_number=f"PTW-{now:%Y%m%d}-{permit_id[-8:].upper()}",
                title=" ".join(request.title.split()),
                description=request.description.strip(),
                permit_type=request.permit_type,
                facility_id=request.facility_id,
                area_id=request.area_id,
                asset_id=request.asset_id,
                valid_from=request.valid_from,
                valid_until=request.valid_until,
                template_id=template.id,
                template_name=template.name,
                template_version=template.version,
                checklist_snapshot=[
                    PermitChecklistSnapshotItem(
                        id=f"check_{uuid4().hex[:12]}",
                        template_item_id=row.id,
                        label=row.label,
                        required=row.required,
                        help_text=row.help_text,
                    )
                    for row in template.checklist_items
                ],
                approval_snapshot=[
                    PermitApprovalSnapshotStep(
                        id=f"approval_{uuid4().hex[:12]}",
                        template_step_id=row.id,
                        label=row.label,
                        approver_role_id=row.approver_role_id,
                        required=row.required,
                    )
                    for row in template.approval_steps
                ],
                risk_assessment=self._risks(request.risk_assessment),
                worker_ids=workers,
            ),
            actor_uid,
        )
        return _detail(permit)

    async def update(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: UpdatePermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "draft":
            raise PermitServiceError(
                409,
                "permit_not_editable",
                "Only a draft permit can be edited",
                {"current_status": current.status},
            )
        valid_from = request.valid_from or current.valid_from
        valid_until = request.valid_until or current.valid_until
        self._validity(valid_from, valid_until)
        changes = request.model_dump(exclude_unset=True)
        changes.pop("expected_revision")
        if request.title is not None:
            changes["title"] = " ".join(request.title.split())
        if request.description is not None:
            changes["description"] = request.description.strip()
        if request.risk_assessment is not None:
            changes["risk_assessment"] = [
                row.model_dump() for row in self._risks(request.risk_assessment)
            ]
        if request.worker_ids is not None:
            changes["worker_ids"] = await self._workers(scope, request.worker_ids)
        try:
            return _detail(
                await self._permits.update(
                    scope, permit_id, changes, actor_uid, request.expected_revision
                )
            )
        except PermitRevisionConflictError as error:
            raise PermitServiceError(
                409,
                "permit_revision_conflict",
                "Permit changed since it was loaded",
                {"current_revision": error.current.revision},
            ) from error

    async def delete(self, scope: CompanyScope, permit_id: str, actor_uid: str) -> PermitDeleted:
        current = await self._active(scope, permit_id)
        if current.status != "draft":
            raise PermitServiceError(
                409,
                "permit_not_deletable",
                "Only a draft permit can be deleted",
                {"current_status": current.status},
            )
        await self._permits.soft_delete(scope, permit_id, actor_uid)
        return PermitDeleted(id=permit_id)

    @staticmethod
    def _revision_conflict(error: PermitRevisionConflictError) -> PermitServiceError:
        return PermitServiceError(
            409,
            "permit_revision_conflict",
            "Permit changed since it was loaded",
            {"current_revision": error.current.revision},
        )

    async def submit(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: SubmitPermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "draft":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Only a draft permit can be submitted",
                {"current_status": current.status},
            )
        if current.valid_until <= datetime.now(UTC):
            raise PermitServiceError(
                422, "permit_validity_expired", "Permit validity must end in the future"
            )
        blocking = [
            row.id for row in current.risk_assessment if row.residual_band in {"high", "critical"}
        ]
        if blocking:
            raise PermitServiceError(
                422,
                "residual_risk_too_high",
                "High or Critical residual risk must be reduced before submission",
                {"risk_ids": blocking},
            )
        completed_ids = request.completed_checklist_item_ids
        if len(set(completed_ids)) != len(completed_ids):
            raise PermitServiceError(
                422, "duplicate_checklist_confirmation", "Checklist confirmations must be unique"
            )
        known = {row.id for row in current.checklist_snapshot}
        unknown = sorted(set(completed_ids) - known)
        if unknown:
            raise PermitServiceError(
                422,
                "unknown_checklist_item",
                "A checklist confirmation does not belong to this permit",
                {"item_ids": unknown},
            )
        missing = [
            row.id
            for row in current.checklist_snapshot
            if row.required and row.id not in completed_ids
        ]
        if missing:
            raise PermitServiceError(
                422,
                "permit_checklist_incomplete",
                "Every required checklist item must be confirmed before submission",
                {"item_ids": missing},
            )
        now = datetime.now(UTC)
        checklist = [
            row.model_copy(
                update={
                    "completed": row.id in completed_ids,
                    "completed_by": actor_uid if row.id in completed_ids else None,
                    "completed_at": now if row.id in completed_ids else None,
                }
            )
            for row in current.checklist_snapshot
        ]
        approvals = [
            row.model_copy(
                update={
                    "status": "pending",
                    "signed_by": None,
                    "signed_at": None,
                    "rejection_reason": None,
                }
            )
            for row in current.approval_snapshot
        ]
        try:
            result = await self._permits.transition(
                scope,
                permit_id,
                expected_revision=request.expected_revision,
                expected_status="draft",
                next_status="pending_approval",
                changes={
                    "checklist_snapshot": [row.model_dump() for row in checklist],
                    "approval_snapshot": [row.model_dump() for row in approvals],
                    "issuer_signature": PermitDigitalSignature(
                        signer_id=actor_uid,
                        signed_at=now,
                        meaning="I confirm this permit is complete and ready for authorization.",
                    ).model_dump(),
                    "submitted_at": now,
                },
                actor_uid=actor_uid,
                action="submitted",
            )
        except PermitRevisionConflictError as error:
            raise self._revision_conflict(error) from error
        except ValueError as error:
            raise PermitServiceError(
                409, "invalid_permit_transition", "Permit is no longer a draft"
            ) from error
        return _detail(result)

    async def decide_approval(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: DecidePermitApprovalRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "pending_approval":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Permit is not awaiting approval",
                {"current_status": current.status},
            )
        if request.decision == "reject" and request.rejection_reason is None:
            raise PermitServiceError(
                422, "rejection_reason_required", "A rejection reason is required"
            )
        actor = await self._users.get(scope, actor_uid)
        if actor is None or actor.status != "active":
            raise PermitServiceError(403, "approver_unavailable", "Approver is unavailable")
        next_index = next(
            (
                index
                for index, row in enumerate(current.approval_snapshot)
                if row.required and row.status == "pending"
            ),
            None,
        )
        if next_index is None:
            raise PermitServiceError(409, "approval_chain_complete", "Approval chain is complete")
        step = current.approval_snapshot[next_index]
        if actor.role_id != step.approver_role_id:
            raise PermitServiceError(
                403,
                "approval_step_role_mismatch",
                "The current approval step requires a different role",
                {"approver_role_id": step.approver_role_id},
            )
        now = datetime.now(UTC)
        approvals = list(current.approval_snapshot)
        approvals[next_index] = step.model_copy(
            update={
                "status": "approved" if request.decision == "approve" else "rejected",
                "signed_by": actor_uid,
                "signed_at": now,
                "rejection_reason": request.rejection_reason,
            }
        )
        next_status = (
            "draft"
            if request.decision == "reject"
            else (
                "pending_approval"
                if any(row.required and row.status == "pending" for row in approvals)
                else "pending_signatures"
            )
        )
        try:
            result = await self._permits.transition(
                scope,
                permit_id,
                expected_revision=request.expected_revision,
                expected_status="pending_approval",
                next_status=next_status,
                changes={"approval_snapshot": [row.model_dump() for row in approvals]},
                actor_uid=actor_uid,
                action="approved" if request.decision == "approve" else "rejected",
            )
        except PermitRevisionConflictError as error:
            raise self._revision_conflict(error) from error
        except ValueError as error:
            raise PermitServiceError(
                409, "invalid_permit_transition", "Permit is no longer awaiting approval"
            ) from error
        return _detail(result)

    async def acknowledge(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: AcknowledgePermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        duplicate = next(
            (
                row
                for row in current.worker_acknowledgements
                if row.client_mutation_id == request.client_mutation_id
            ),
            None,
        )
        if duplicate is not None:
            if duplicate.worker_id != actor_uid:
                raise PermitServiceError(
                    409,
                    "acknowledgement_id_conflict",
                    "Acknowledgement mutation ID belongs to another worker",
                )
            return _detail(current)
        existing = next(
            (row for row in current.worker_acknowledgements if row.worker_id == actor_uid), None
        )
        if existing is not None:
            return _detail(current)
        if current.status != "pending_signatures":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Permit is not awaiting worker signatures",
                {"current_status": current.status},
            )
        if actor_uid not in current.worker_ids:
            raise PermitServiceError(
                403, "worker_not_assigned", "Only an assigned worker may acknowledge this permit"
            )
        if request.client_signed_at.tzinfo is None:
            raise PermitServiceError(
                422, "timezone_required", "client_signed_at must include a timezone"
            )
        now = datetime.now(UTC)
        signed_at = request.client_signed_at.astimezone(UTC)
        approval_times = [
            row.signed_at
            for row in current.approval_snapshot
            if row.required and row.signed_at is not None
        ]
        approval_completed_at = max(approval_times) if approval_times else current.submitted_at
        if approval_completed_at is None or signed_at < approval_completed_at:
            raise PermitServiceError(
                422,
                "acknowledgement_predates_approval",
                "Worker acknowledgement must occur after permit approval",
            )
        if signed_at > now + timedelta(minutes=5):
            raise PermitServiceError(
                422,
                "client_signature_in_future",
                "client_signed_at cannot be more than five minutes in the future",
            )
        acknowledgement = PermitWorkerAcknowledgement(
            worker_id=actor_uid,
            client_mutation_id=request.client_mutation_id,
            client_signed_at=signed_at,
            received_at=now,
            signed_at=now,
            device_id=request.device_id,
            meaning="I understand the hazards, controls, and conditions of this permit.",
        )
        try:
            result = await self._permits.transition(
                scope,
                permit_id,
                expected_revision=request.expected_revision,
                expected_status="pending_signatures",
                next_status="pending_signatures",
                changes={
                    "worker_acknowledgements": [
                        *[row.model_dump() for row in current.worker_acknowledgements],
                        acknowledgement.model_dump(),
                    ]
                },
                actor_uid=actor_uid,
                action="worker_acknowledged",
            )
        except PermitRevisionConflictError as error:
            raise self._revision_conflict(error) from error
        except ValueError as error:
            raise PermitServiceError(
                409, "invalid_permit_transition", "Permit is no longer awaiting signatures"
            ) from error
        return _detail(result)

    async def activate(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: ActivatePermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "pending_signatures":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Permit is not ready for activation",
                {"current_status": current.status},
            )
        acknowledged = {row.worker_id for row in current.worker_acknowledgements}
        missing = [worker_id for worker_id in current.worker_ids if worker_id not in acknowledged]
        if missing:
            raise PermitServiceError(
                422,
                "worker_acknowledgements_incomplete",
                "Every assigned worker must acknowledge before activation",
                {"worker_ids": missing},
            )
        now = datetime.now(UTC)
        if now < current.valid_from:
            raise PermitServiceError(
                422, "permit_not_yet_valid", "Permit validity window has not started"
            )
        if now >= current.valid_until:
            raise PermitServiceError(422, "permit_validity_expired", "Permit validity has expired")
        try:
            result = await self._permits.transition(
                scope,
                permit_id,
                expected_revision=request.expected_revision,
                expected_status="pending_signatures",
                next_status="active",
                changes={"activated_by": actor_uid, "activated_at": now},
                actor_uid=actor_uid,
                action="activated",
            )
        except PermitRevisionConflictError as error:
            raise self._revision_conflict(error) from error
        except ValueError as error:
            raise PermitServiceError(
                409, "invalid_permit_transition", "Permit is no longer ready for activation"
            ) from error
        return _detail(result)

    async def suspend(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: ControlPermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "active":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Only an active permit can be suspended",
                {"current_status": current.status},
            )
        now = datetime.now(UTC)
        return _detail(
            await self._controlled_transition(
                scope,
                current,
                request.expected_revision,
                "suspended",
                {
                    "suspended_by": actor_uid,
                    "suspended_at": now,
                    "suspension_reason": request.reason.strip(),
                },
                actor_uid,
                "suspended",
            )
        )

    async def resume(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: ResumePermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "suspended":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Only a suspended permit can be resumed",
                {"current_status": current.status},
            )
        now = datetime.now(UTC)
        if now >= current.valid_until:
            raise PermitServiceError(422, "permit_validity_expired", "Permit validity has expired")
        return _detail(
            await self._controlled_transition(
                scope,
                current,
                request.expected_revision,
                "active",
                {
                    "suspended_by": None,
                    "suspended_at": None,
                    "suspension_reason": None,
                },
                actor_uid,
                "resumed",
            )
        )

    async def revoke(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: ControlPermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        allowed = {"pending_approval", "pending_signatures", "active", "suspended"}
        if current.status not in allowed:
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Permit cannot be revoked from its current status",
                {"current_status": current.status},
            )
        now = datetime.now(UTC)
        return _detail(
            await self._controlled_transition(
                scope,
                current,
                request.expected_revision,
                "revoked",
                {
                    "revoked_by": actor_uid,
                    "revoked_at": now,
                    "revocation_reason": request.reason.strip(),
                },
                actor_uid,
                "revoked",
            )
        )

    async def close(
        self,
        scope: CompanyScope,
        permit_id: str,
        request: ClosePermitRequest,
        actor_uid: str,
    ) -> PermitDetail:
        current = await self._active(scope, permit_id)
        if current.status != "active":
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Only an active permit can be closed",
                {"current_status": current.status},
            )
        now = datetime.now(UTC)
        return _detail(
            await self._controlled_transition(
                scope,
                current,
                request.expected_revision,
                "closed",
                {
                    "closed_by": actor_uid,
                    "closed_at": now,
                    "closeout_notes": request.closeout_notes.strip(),
                },
                actor_uid,
                "closed",
            )
        )

    async def _controlled_transition(
        self,
        scope: CompanyScope,
        current: Permit,
        expected_revision: int,
        next_status: str,
        changes: dict[str, object],
        actor_uid: str,
        action: str,
    ) -> Permit:
        try:
            return await self._permits.transition(
                scope,
                current.id,
                expected_revision=expected_revision,
                expected_status=current.status,
                next_status=next_status,
                changes=changes,
                actor_uid=actor_uid,
                action=action,
            )
        except PermitRevisionConflictError as error:
            raise self._revision_conflict(error) from error
        except ValueError as error:
            raise PermitServiceError(
                409,
                "invalid_permit_transition",
                "Permit status changed before the transition completed",
            ) from error


def get_permit_service() -> PermitService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return PermitService(
        PermitRepository(client, audit),
        PermitTemplateRepository(client, audit),
        UserRepository(client, audit),
        FacilityRepository(client, audit),
        AreaRepository(client, audit),
        AssetRepository(client, audit),
    )
