"""VR training endpoints.

Reading a module needs `assets.read` -- a trainee is being shown the facility's
real equipment, which is the same information the asset module protects.
Recording progress needs nothing beyond authentication, because progress is
personal and every path filters on the caller's own uid.

The whole router sits behind the `vr_training` entitlement, which the Phase 13
catalog already sells on Enterprise.
"""

from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.auth.dependencies import get_current_user
from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import (
    CompleteTrainingStepRequest,
    TrainingModuleListPage,
    TrainingModuleResponse,
    TrainingProgressListPage,
    TrainingProgressResponse,
    TrainingStepResponse,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser, TrainingModule, TrainingProgress
from app.rbac.dependencies import require_permission
from app.training.service import TrainingService, TrainingServiceError, get_training_service

router = APIRouter(
    prefix="/api/v1/training",
    tags=["training"],
    dependencies=[Depends(require_feature(Feature.VR_TRAINING))],
)

_training_read_access = require_permission("assets.read")


def _raise_api_error(error: TrainingServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.error,
        message=error.message,
    ) from error


def _module_response(module: TrainingModule) -> TrainingModuleResponse:
    return TrainingModuleResponse(
        id=module.id,
        title=module.title,
        kind=module.kind,
        facility_id=module.facility_id,
        description=module.description,
        steps=[
            TrainingStepResponse(
                id=step.id,
                order=step.order,
                title=step.title,
                instruction=step.instruction,
                action=step.action,
                target_asset_id=step.target_asset_id,
                target_position=step.target_position,
                options=list(step.options),
                time_limit_seconds=step.time_limit_seconds,
            )
            for step in sorted(module.steps, key=lambda step: step.order)
        ],
        estimated_minutes=module.estimated_minutes,
        pass_threshold=module.pass_threshold,
    )


def _progress_response(progress: TrainingProgress) -> TrainingProgressResponse:
    return TrainingProgressResponse(
        id=progress.id,
        module_id=progress.module_id,
        status=progress.status,
        completed_step_ids=list(progress.completed_step_ids),
        correct_count=progress.correct_count,
        scored_count=progress.scored_count,
        score=progress.score,
        attempts=progress.attempts,
        started_at=progress.started_at,
        completed_at=progress.completed_at,
    )


@router.get(
    "/modules",
    response_model=TrainingModuleListPage,
    operation_id="list_training_modules",
    responses=error_responses(401, 402, 403, 422, 500),
)
async def list_training_modules(
    current_user: Annotated[CurrentUser, Depends(_training_read_access)],
    service: Annotated[TrainingService, Depends(get_training_service)],
    facility_id: Annotated[str | None, Query(max_length=200)] = None,
    kind: Annotated[str | None, Query(max_length=50)] = None,
) -> TrainingModuleListPage:
    scope = CompanyScope(company_id=current_user.company_id)
    modules = await service.list_modules(scope, facility_id=facility_id, kind=kind)
    return TrainingModuleListPage(items=[_module_response(module) for module in modules])


@router.get(
    "/modules/{module_id}",
    response_model=TrainingModuleResponse,
    operation_id="get_training_module",
    responses=error_responses(401, 402, 403, 404, 500),
)
async def get_training_module(
    module_id: str,
    current_user: Annotated[CurrentUser, Depends(_training_read_access)],
    service: Annotated[TrainingService, Depends(get_training_service)],
) -> TrainingModuleResponse:
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return _module_response(await service.get_module(scope, module_id))
    except TrainingServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/progress",
    response_model=TrainingProgressListPage,
    operation_id="list_training_progress",
    responses=error_responses(401, 402, 403, 422, 500),
)
async def list_training_progress(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[TrainingService, Depends(get_training_service)],
    module_id: Annotated[str | None, Query(max_length=200)] = None,
) -> TrainingProgressListPage:
    """The caller's own training record, newest attempt first."""
    scope = CompanyScope(company_id=current_user.company_id)
    rows = await service.list_progress(scope, current_user.uid, module_id=module_id)
    return TrainingProgressListPage(items=[_progress_response(row) for row in rows])


@router.post(
    "/modules/{module_id}/start",
    response_model=TrainingProgressResponse,
    operation_id="start_training_module",
    responses=error_responses(401, 402, 403, 404, 500),
)
async def start_training_module(
    module_id: str,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[TrainingService, Depends(get_training_service)],
) -> TrainingProgressResponse:
    """Resumes an attempt already in progress rather than discarding it, so a
    dropped headset connection does not lose the run."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return _progress_response(await service.start_module(scope, module_id, current_user.uid))
    except TrainingServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/modules/{module_id}/steps/{step_id}/complete",
    response_model=TrainingProgressResponse,
    operation_id="complete_training_step",
    responses=error_responses(401, 402, 403, 404, 409, 422, 500),
)
async def complete_training_step(
    module_id: str,
    step_id: str,
    request: CompleteTrainingStepRequest,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[TrainingService, Depends(get_training_service)],
) -> TrainingProgressResponse:
    """Idempotent -- replaying a recorded step does not double-count its score."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return _progress_response(
            await service.complete_step(
                scope,
                module_id,
                step_id,
                current_user.uid,
                correct=request.correct,
                selected_option=request.selected_option,
            )
        )
    except TrainingServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/modules/{module_id}/complete",
    response_model=TrainingProgressResponse,
    operation_id="complete_training_module",
    responses=error_responses(401, 402, 403, 404, 409, 500),
)
async def complete_training_module(
    module_id: str,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[TrainingService, Depends(get_training_service)],
) -> TrainingProgressResponse:
    """Scores the attempt and records pass or fail against the module's
    threshold."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        return _progress_response(
            await service.complete_module(scope, module_id, current_user.uid)
        )
    except TrainingServiceError as error:
        _raise_api_error(error)
        raise
