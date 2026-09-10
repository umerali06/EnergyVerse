"""VR training modules and per-trainee progress.

Modules are guided scenarios bound to a real facility's 3D scene, so a trainee
learns the equipment their site actually has rather than a fabricated mock-up.
The five kinds map to the competencies the requirements name: facility
exploration, equipment-location learning, safety procedures, emergency drills
and maintenance simulations.

Scoring is deliberately narrow. Only `locate`, `sequence` and `choose` steps
are scored, because only those can be answered wrongly; `observe` and
`acknowledge` steps are progress markers. A module passes when the share of
scored steps answered correctly reaches its `pass_threshold`, which makes a
completion record defensible as evidence of competency rather than of
attendance.

Reading progress is personal, like notifications: the service filters on
`user_id == actor_uid`, so no new RBAC permission gates a trainee reading
their own record.
"""

import logging
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.training import TrainingModuleRepository, TrainingProgressRepository
from app.models.base import CompanyScope, utc_now
from app.models.entities import TrainingModule, TrainingProgress, TrainingProgressCreate

logger = logging.getLogger(__name__)

# Steps a trainee can get wrong. Everything else advances progress but does not
# contribute to the score, so an attentive trainee is not penalised for a
# module that is mostly narration.
SCORED_ACTIONS = frozenset({"locate", "sequence", "choose"})


class TrainingServiceError(Exception):
    def __init__(self, status_code: int, error: str, message: str) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.error = error
        self.message = message


class TrainingService:
    def __init__(
        self,
        *,
        modules: TrainingModuleRepository,
        progress: TrainingProgressRepository,
    ) -> None:
        self._modules = modules
        self._progress = progress

    async def list_modules(
        self, scope: CompanyScope, *, facility_id: str | None = None, kind: str | None = None
    ) -> list[TrainingModule]:
        return await self._modules.query(scope, facility_id=facility_id, kind=kind)

    async def get_module(self, scope: CompanyScope, module_id: str) -> TrainingModule:
        module = await self._modules.get(scope, module_id)
        if module is None or module.deleted_at is not None:
            raise TrainingServiceError(
                404, "training_module_not_found", "No training module with that id exists"
            )
        return module

    async def list_progress(
        self, scope: CompanyScope, user_id: str, *, module_id: str | None = None
    ) -> list[TrainingProgress]:
        return await self._progress.list_for_user(scope, user_id, module_id=module_id)

    async def start_module(
        self, scope: CompanyScope, module_id: str, actor_uid: str
    ) -> TrainingProgress:
        """Begin (or restart) a module.

        A completed module can be retaken -- competency lapses -- so a restart
        opens a fresh attempt rather than reopening the old record, keeping the
        earlier result intact as history. An already in-progress attempt is
        returned as-is so a dropped headset connection resumes instead of
        losing the run.
        """
        await self.get_module(scope, module_id)
        existing = await self._progress.list_for_user(scope, actor_uid, module_id=module_id)
        in_progress = next((row for row in existing if row.status == "in_progress"), None)
        if in_progress is not None:
            return in_progress

        return await self._progress.create(
            scope,
            TrainingProgressCreate(
                id=f"training_progress_{uuid4().hex}",
                module_id=module_id,
                user_id=actor_uid,
                started_at=utc_now(),
                attempts=len(existing) + 1,
            ),
            actor_uid,
        )

    async def complete_step(
        self,
        scope: CompanyScope,
        module_id: str,
        step_id: str,
        actor_uid: str,
        *,
        correct: bool | None = None,
        selected_option: str | None = None,
    ) -> TrainingProgress:
        """Record one step.

        Idempotent: replaying a step already recorded is a no-op rather than
        double-counting its score, because a headset that reconnects mid-module
        may resend the last step it managed to report.
        """
        module = await self.get_module(scope, module_id)
        step = next((candidate for candidate in module.steps if candidate.id == step_id), None)
        if step is None:
            raise TrainingServiceError(
                404, "training_step_not_found", "No step with that id exists on this module"
            )

        progress = await self._active_progress(scope, module_id, actor_uid)
        if step_id in progress.completed_step_ids:
            return progress

        values: dict[str, object] = {
            "completed_step_ids": [*progress.completed_step_ids, step_id],
        }
        if step.action in SCORED_ACTIONS:
            if step.action == "choose":
                # The answer never leaves the server, so the client sends what
                # was picked and the comparison happens here. A client-supplied
                # `correct` is ignored for these -- trusting it would make every
                # multiple-choice step trivially passable.
                was_correct = (
                    selected_option is not None and selected_option == step.correct_option
                )
            else:
                was_correct = bool(correct)
            values["scored_count"] = progress.scored_count + 1
            if was_correct:
                values["correct_count"] = progress.correct_count + 1

        updated = await self._progress.update_progress(scope, progress.id, values, actor_uid)
        if updated is None:
            raise TrainingServiceError(
                404, "training_progress_not_found", "No training progress record was found"
            )
        return updated

    async def complete_module(
        self, scope: CompanyScope, module_id: str, actor_uid: str
    ) -> TrainingProgress:
        """Finalize an attempt and decide pass or fail.

        A module with no scored steps -- pure exploration -- passes on
        completion: there is nothing to answer wrongly, and the evidence being
        recorded is that the trainee walked the facility.
        """
        module = await self.get_module(scope, module_id)
        progress = await self._active_progress(scope, module_id, actor_uid)

        score = (
            round(progress.correct_count * 100 / progress.scored_count)
            if progress.scored_count
            else 100
        )
        passed = score >= module.pass_threshold
        updated = await self._progress.update_progress(
            scope,
            progress.id,
            {
                "status": "completed" if passed else "failed",
                "score": score,
                "completed_at": utc_now(),
            },
            actor_uid,
        )
        if updated is None:
            raise TrainingServiceError(
                404, "training_progress_not_found", "No training progress record was found"
            )
        return updated

    async def _active_progress(
        self, scope: CompanyScope, module_id: str, actor_uid: str
    ) -> TrainingProgress:
        rows = await self._progress.list_for_user(scope, actor_uid, module_id=module_id)
        active = next((row for row in rows if row.status == "in_progress"), None)
        if active is None:
            raise TrainingServiceError(
                409,
                "training_not_started",
                "Start the module before recording progress against it",
            )
        return active


def get_training_service() -> TrainingService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return TrainingService(
        modules=TrainingModuleRepository(client, audit),
        progress=TrainingProgressRepository(client, audit),
    )
