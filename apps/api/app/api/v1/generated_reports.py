from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.billing.dependencies import require_feature
from app.billing.plans import Feature
from app.core.errors import ApiError
from app.models.api import (
    CreateGeneratedReportRequest,
    FinalizeGeneratedReportRequest,
    GeneratedReportDeleted,
    GeneratedReportDetail,
    GeneratedReportExportResponse,
    GeneratedReportListPage,
    RegenerateGeneratedReportRequest,
    UpdateGeneratedReportRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.dependencies import require_permission
from app.reports.service import (
    GeneratedReportService,
    GeneratedReportServiceError,
    get_generated_report_service,
)

router = APIRouter(
    prefix="/api/v1/reports", tags=["generated_reports"],
    # Entitlement gate (D-090): the company's plan must include this
    # module. Stacks with each route's own require_permission -- the
    # person may be allowed while the tenant has not paid for it.
    dependencies=[Depends(require_feature(Feature.REPORTS))],
)

_read_access = require_permission("reports.read")
_generate_access = require_permission("reports.generate")


def _raise_api_error(error: GeneratedReportServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.code,
        message=error.message,
        details=error.details,
    ) from error


@router.get(
    "",
    response_model=GeneratedReportListPage,
    operation_id="list_generated_reports",
    responses=error_responses(401, 403, 422, 500),
)
async def list_generated_reports(
    current_user: Annotated[CurrentUser, Depends(_read_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
    report_type: Annotated[str | None, Query(max_length=30)] = None,
    status: Annotated[str | None, Query(max_length=20)] = None,
    cursor: Annotated[str | None, Query(max_length=500)] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 25,
) -> GeneratedReportListPage:
    try:
        return await service.list_reports(
            CompanyScope(company_id=current_user.company_id),
            report_type=report_type,
            status=status,
            cursor=cursor,
            limit=limit,
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/generate",
    response_model=GeneratedReportDetail,
    operation_id="generate_report",
    responses=error_responses(401, 403, 404, 409, 422, 500, 502),
)
async def generate_report(
    request: CreateGeneratedReportRequest,
    current_user: Annotated[CurrentUser, Depends(_generate_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDetail:
    try:
        return await service.create_report(
            CompanyScope(company_id=current_user.company_id), request, current_user
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.get(
    "/{report_id}",
    response_model=GeneratedReportDetail,
    operation_id="get_generated_report",
    responses=error_responses(401, 403, 404, 500),
)
async def get_generated_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(_read_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDetail:
    try:
        return await service.get_report(CompanyScope(company_id=current_user.company_id), report_id)
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.patch(
    "/{report_id}",
    response_model=GeneratedReportDetail,
    operation_id="update_generated_report",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def update_generated_report(
    report_id: str,
    request: UpdateGeneratedReportRequest,
    current_user: Annotated[CurrentUser, Depends(_generate_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDetail:
    try:
        return await service.update_report(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            request,
            current_user.uid,
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{report_id}/regenerate",
    response_model=GeneratedReportDetail,
    operation_id="regenerate_generated_report",
    responses=error_responses(401, 403, 404, 409, 422, 500, 502),
)
async def regenerate_generated_report(
    report_id: str,
    request: RegenerateGeneratedReportRequest,
    current_user: Annotated[CurrentUser, Depends(_generate_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDetail:
    try:
        return await service.regenerate_report(
            CompanyScope(company_id=current_user.company_id), report_id, request, current_user
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{report_id}/finalize",
    response_model=GeneratedReportDetail,
    operation_id="finalize_generated_report",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def finalize_generated_report(
    report_id: str,
    request: FinalizeGeneratedReportRequest,
    current_user: Annotated[CurrentUser, Depends(_generate_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDetail:
    try:
        return await service.finalize_report(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            request,
            current_user.uid,
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.delete(
    "/{report_id}",
    response_model=GeneratedReportDeleted,
    operation_id="delete_generated_report",
    responses=error_responses(401, 403, 404, 409, 500),
)
async def delete_generated_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(_generate_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
) -> GeneratedReportDeleted:
    try:
        return await service.delete_report(
            CompanyScope(company_id=current_user.company_id), report_id, current_user.uid
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise


@router.post(
    "/{report_id}/export",
    response_model=GeneratedReportExportResponse,
    operation_id="export_generated_report",
    responses=error_responses(401, 403, 404, 409, 422, 500),
)
async def export_generated_report(
    report_id: str,
    current_user: Annotated[CurrentUser, Depends(_read_access)],
    service: Annotated[GeneratedReportService, Depends(get_generated_report_service)],
    format: Annotated[str, Query(max_length=10)],
) -> GeneratedReportExportResponse:
    try:
        return await service.export_report(
            CompanyScope(company_id=current_user.company_id),
            report_id,
            format,
            current_user.uid,
        )
    except GeneratedReportServiceError as error:
        _raise_api_error(error)
        raise
