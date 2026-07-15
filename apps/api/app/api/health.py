from datetime import UTC, datetime
from typing import Annotated, Literal

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.db.repositories.health import FirestoreStatus, get_firestore_status

router = APIRouter()


class HealthResponse(BaseModel):
    service: Literal["fev-api"]
    status: Literal["ok"]
    firestore: FirestoreStatus
    timestamp: datetime


@router.get("/health", response_model=HealthResponse)
async def health(
    firestore_status: Annotated[FirestoreStatus, Depends(get_firestore_status)],
) -> HealthResponse:
    return HealthResponse(
        service="fev-api",
        status="ok",
        firestore=firestore_status,
        timestamp=datetime.now(UTC),
    )
