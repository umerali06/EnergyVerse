from typing import Annotated

from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.models.api import error_responses
from app.models.entities import CurrentUser

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])


@router.get(
    "/me",
    response_model=CurrentUser,
    operation_id="get_current_user",
    responses=error_responses(401, 403, 422, 500),
)
async def me(current_user: Annotated[CurrentUser, Depends(get_current_user)]) -> CurrentUser:
    return current_user
