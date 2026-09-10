from typing import Annotated, Literal

from fastapi import APIRouter, Depends, File, Query, UploadFile

from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import (
    AssignSafetyReportRequest,
    CancelCorrectiveActionRequest,
    CreateCorrectiveActionRequest,
    CreateSafetyReportRequest,
    SafetyReportDeleted,
    SafetyReportDetail,
    SafetyReportListPage,
    TransitionSafetyReportRequest,
    UpdateCorrectiveActionRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.safety_reports.service import (
    SafetyReportService,
    SafetyReportServiceError,
    get_safety_report_service,
)

router = APIRouter(
    prefix="/api/v1/safety-reports", tags=["safety_reports"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.SAFETY_REPORTS))],
)
read_access = require_permission("safety.read")
write_access = require_permission("safety.write")
close_access = require_permission("safety.close")


def _raise(error: SafetyReportServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=SafetyReportListPage,
    operation_id="list_safety_reports",
    responses=error_responses(401, 403, 422, 500),
)
async def list_safety_reports(
    current_user: Annotated[CurrentUser, Depends(read_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
    status: Annotated[str | None, Query(max_length=30)] = None,
    category: Annotated[str | None, Query(max_length=40)] = None,
    severity: Annotated[str | None, Query(max_length=20)] = None,
    reporter_id: Annotated[str | None, Query(max_length=200)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> SafetyReportListPage:
    try:
        return await service.list(
            CompanyScope(company_id=current_user.company_id),
            status,
            category,
            severity,
            reporter_id,
            cursor,
            limit,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.post(
    "",
    response_model=SafetyReportDetail,
    operation_id="create_safety_report",
    responses=error_responses(401, 403, 409, 422, 500),
)
async def create_safety_report(
    request: CreateSafetyReportRequest,
    current_user: Annotated[CurrentUser, Depends(write_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.create(
            CompanyScope(company_id=current_user.company_id), request, current_user.uid
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.get(
    "/{report_id}",
    response_model=SafetyReportDetail,
    operation_id="get_safety_report",
    responses=error_responses(401, 403, 404, 500),
)
async def get_safety_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(read_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.get(CompanyScope(company_id=current_user.company_id), report_id)
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.patch(
    "/{report_id}/assign",
    response_model=SafetyReportDetail,
    operation_id="assign_safety_report",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def assign_safety_report(
    report_id: str,
    request: AssignSafetyReportRequest,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.assign(
            CompanyScope(company_id=current_user.company_id), report_id, request, current_user.uid
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.patch(
    "/{report_id}/transition",
    response_model=SafetyReportDetail,
    operation_id="transition_safety_report",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def transition_safety_report(
    report_id: str,
    request: TransitionSafetyReportRequest,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.transition(
            CompanyScope(company_id=current_user.company_id), report_id, request, current_user.uid
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{report_id}/close",
    response_model=SafetyReportDetail,
    operation_id="close_safety_report",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def close_safety_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.close(
            CompanyScope(company_id=current_user.company_id), report_id, current_user.uid
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.delete(
    "/{report_id}",
    response_model=SafetyReportDeleted,
    operation_id="delete_safety_report",
    responses=error_responses(401, 403, 404, 500),
)
async def delete_safety_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDeleted:
    try:
        return await service.delete(
            CompanyScope(company_id=current_user.company_id), report_id, current_user.uid
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{report_id}/evidence",
    response_model=SafetyReportDetail,
    operation_id="upload_safety_evidence",
    responses=error_responses(401, 403, 404, 409, 413, 422, 500),
)
async def upload_safety_evidence(
    report_id: str,
    kind: Literal["photo", "video"],
    file: Annotated[UploadFile, File()],
    current_user: Annotated[CurrentUser, Depends(write_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.upload_evidence(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            kind,
            file,
            current_user.uid,
            "safety.close" in current_user.permissions,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.delete(
    "/{report_id}/evidence/{evidence_id}",
    response_model=SafetyReportDetail,
    operation_id="delete_safety_evidence",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def delete_safety_evidence(
    report_id: str,
    evidence_id: str,
    current_user: Annotated[CurrentUser, Depends(write_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.delete_evidence(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            evidence_id,
            current_user.uid,
            "safety.close" in current_user.permissions,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{report_id}/corrective-actions",
    response_model=SafetyReportDetail,
    operation_id="create_corrective_action",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def create_corrective_action(
    report_id: str,
    request: CreateCorrectiveActionRequest,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.add_action(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            request,
            current_user.uid,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.patch(
    "/{report_id}/corrective-actions/{action_id}",
    response_model=SafetyReportDetail,
    operation_id="update_corrective_action",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_corrective_action(
    report_id: str,
    action_id: str,
    request: UpdateCorrectiveActionRequest,
    current_user: Annotated[CurrentUser, Depends(read_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.update_action(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            action_id,
            request,
            current_user.uid,
            "safety.close" in current_user.permissions,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise


@router.post(
    "/{report_id}/corrective-actions/{action_id}/cancel",
    response_model=SafetyReportDetail,
    operation_id="cancel_corrective_action",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def cancel_corrective_action(
    report_id: str,
    action_id: str,
    request: CancelCorrectiveActionRequest,
    current_user: Annotated[CurrentUser, Depends(close_access)],
    service: Annotated[SafetyReportService, Depends(get_safety_report_service)],
) -> SafetyReportDetail:
    try:
        return await service.cancel_action(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            action_id,
            request,
            current_user.uid,
        )
    except SafetyReportServiceError as error:
        _raise(error)
        raise
