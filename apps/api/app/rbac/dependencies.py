import logging
from collections.abc import Awaitable, Callable, Sequence
from typing import Annotated, Literal

from fastapi import Depends, HTTPException, Request, status

from app.audit.service import AuditService
from app.audit.types import AuditSink
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.models.base import CompanyScope
from app.models.entities import CurrentUser

logger = logging.getLogger(__name__)

PermissionMode = Literal["all", "any"]
RbacDependency = Callable[[Request, CurrentUser, AuditSink], Awaitable[CurrentUser]]


def get_access_denial_audit() -> AuditSink:
    return AuditService(AuditLogRepository())


def _required_keys(keys: Sequence[str]) -> tuple[str, ...]:
    required = tuple(dict.fromkeys(keys))
    if not required or any(not key for key in required):
        raise ValueError("At least one non-empty RBAC key is required")
    return required


async def _audit_denial(
    audit: AuditSink,
    request: Request,
    current_user: CurrentUser,
    *,
    required: Sequence[str],
    missing: Sequence[str],
    mode: PermissionMode,
    gate: str,
) -> None:
    try:
        await audit.audit(
            CompanyScope(company_id=current_user.company_id),
            actor_uid=current_user.uid,
            action="access.denied",
            target_type="route",
            target_id=request.url.path,
            metadata={
                "route": request.url.path,
                "required": list(required),
                "missing": list(missing),
                "mode": mode,
                "gate": gate,
            },
        )
    except Exception:
        logger.exception(
            "Failed to audit denied access for %s on %s",
            current_user.uid,
            request.url.path,
        )


def require_permission(
    *keys: str,
    mode: PermissionMode = "all",
) -> RbacDependency:
    required = _required_keys(keys)
    if mode not in ("all", "any"):
        raise ValueError("Permission mode must be 'all' or 'any'")

    async def enforce(
        request: Request,
        current_user: Annotated[CurrentUser, Depends(get_current_user)],
        audit: Annotated[AuditSink, Depends(get_access_denial_audit)],
    ) -> CurrentUser:
        missing = [key for key in required if key not in current_user.permissions]
        permitted = not missing if mode == "all" else len(missing) < len(required)
        if permitted:
            return current_user

        await _audit_denial(
            audit,
            request,
            current_user,
            required=required,
            missing=missing,
            mode=mode,
            gate="permission",
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "forbidden",
                "required": list(required),
                "mode": mode,
                "missing": missing,
            },
        )

    return enforce


def require_role(*role_keys: str) -> RbacDependency:
    required = _required_keys(role_keys)

    async def enforce(
        request: Request,
        current_user: Annotated[CurrentUser, Depends(get_current_user)],
        audit: Annotated[AuditSink, Depends(get_access_denial_audit)],
    ) -> CurrentUser:
        if current_user.role_key in required:
            return current_user

        missing = list(required)
        await _audit_denial(
            audit,
            request,
            current_user,
            required=required,
            missing=missing,
            mode="any",
            gate="role",
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "forbidden",
                "required": list(required),
                "mode": "any",
                "missing": missing,
            },
        )

    return enforce
