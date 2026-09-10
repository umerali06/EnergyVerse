"""Personal notification endpoints.

Deliberately gated on authentication alone rather than a new RBAC permission.
A notification is addressed to one user, and every path here filters on
`user_id == current_user.uid`, so there is nothing a permission could usefully
add -- the same posture as `/auth/me`.

There is no `require_feature` gate either: notifications are part of the
platform rather than a purchasable module, and a tenant on any plan still needs
to be told when work is assigned to them.
"""

from typing import Annotated

from fastapi import APIRouter, Depends, Query

from app.auth.dependencies import get_current_user
from app.core.errors import ApiError
from app.models.api import (
    DeviceRegistered,
    DeviceUnregistered,
    NotificationListPage,
    NotificationRead,
    NotificationResponse,
    NotificationsAllRead,
    RegisterDeviceRequest,
    error_responses,
)
from app.models.base import CompanyScope
from app.models.entities import CurrentUser, Notification
from app.notifications.service import (
    NotificationService,
    NotificationServiceError,
    get_notification_service,
)

router = APIRouter(prefix="/api/v1/notifications", tags=["notifications"])


def _raise_api_error(error: NotificationServiceError) -> None:
    raise ApiError(
        status_code=error.status_code,
        error=error.error,
        message=error.message,
    ) from error


def _to_response(notification: Notification) -> NotificationResponse:
    return NotificationResponse(
        id=notification.id,
        event=notification.event,
        title=notification.title,
        body=notification.body,
        target_type=notification.target_type,
        target_id=notification.target_id,
        metadata=notification.metadata,
        delivered_channels=list(notification.delivered_channels),
        read_at=notification.read_at,
        created_at=notification.created_at,
    )


@router.get(
    "",
    response_model=NotificationListPage,
    operation_id="list_notifications",
    responses=error_responses(401, 403, 422, 500),
)
async def list_notifications(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[NotificationService, Depends(get_notification_service)],
    unread_only: Annotated[bool, Query()] = False,
) -> NotificationListPage:
    """The caller's own notifications, newest first, with an unread count.

    The count is always over everything unread, not just the returned page, so
    the bell badge stays correct under `unread_only`.
    """
    scope = CompanyScope(company_id=current_user.company_id)
    items = await service.list_for_user(scope, current_user.uid, unread_only=unread_only)
    unread = await service.unread_count(scope, current_user.uid)
    return NotificationListPage(
        items=[_to_response(item) for item in items],
        unread_count=unread,
    )


@router.post(
    "/{notification_id}/read",
    response_model=NotificationRead,
    operation_id="mark_notification_read",
    responses=error_responses(401, 403, 404, 422, 500),
)
async def mark_notification_read(
    notification_id: str,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[NotificationService, Depends(get_notification_service)],
) -> NotificationRead:
    """Idempotent -- re-reading keeps the original timestamp."""
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        updated = await service.mark_read(scope, notification_id, current_user.uid)
    except NotificationServiceError as error:
        _raise_api_error(error)
        raise
    return NotificationRead(id=updated.id, read_at=updated.read_at)


@router.post(
    "/read-all",
    response_model=NotificationsAllRead,
    operation_id="mark_all_notifications_read",
    responses=error_responses(401, 403, 422, 500),
)
async def mark_all_notifications_read(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[NotificationService, Depends(get_notification_service)],
) -> NotificationsAllRead:
    scope = CompanyScope(company_id=current_user.company_id)
    return NotificationsAllRead(marked=await service.mark_all_read(scope, current_user.uid))


@router.post(
    "/devices",
    response_model=DeviceRegistered,
    operation_id="register_notification_device",
    responses=error_responses(401, 403, 422, 500),
)
async def register_notification_device(
    request: RegisterDeviceRequest,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[NotificationService, Depends(get_notification_service)],
) -> DeviceRegistered:
    """Register this device's FCM token for push.

    Re-registering an existing token reassigns it to the caller: a shared site
    tablet passed between people must not keep pushing the previous user's
    alerts to whoever is holding it now.
    """
    scope = CompanyScope(company_id=current_user.company_id)
    try:
        await service.register_device(
            scope,
            user_id=current_user.uid,
            token=request.token,
            platform=request.platform,
        )
    except NotificationServiceError as error:
        _raise_api_error(error)
        raise
    return DeviceRegistered(registered=True)


@router.delete(
    "/devices/{token}",
    response_model=DeviceUnregistered,
    operation_id="unregister_notification_device",
    responses=error_responses(401, 403, 422, 500),
)
async def unregister_notification_device(
    token: str,
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
    service: Annotated[NotificationService, Depends(get_notification_service)],
) -> DeviceUnregistered:
    """Called on sign-out so a shared device stops receiving the caller's push."""
    scope = CompanyScope(company_id=current_user.company_id)
    await service.unregister_device(scope, token)
    return DeviceUnregistered(unregistered=True)
