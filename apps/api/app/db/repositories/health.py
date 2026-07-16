import asyncio
import logging
from typing import Literal

from google.cloud.firestore_v1.async_client import AsyncClient

from app.core.firebase import (
    firebase_credentials_configured,
    get_firebase_app,
    get_firebase_initialization_error,
)
from app.db.firestore import get_firestore_client

logger = logging.getLogger(__name__)

FirestoreStatus = Literal["connected", "unavailable", "unconfigured"]
FIRESTORE_RPC_TIMEOUT_SECONDS = 8.0
FIRESTORE_HEALTH_TIMEOUT_SECONDS = 10.0


class HealthRepository:
    def __init__(self, client: AsyncClient | None = None) -> None:
        self._client = client or get_firestore_client()

    async def ping(self) -> None:
        await (
            self._client.collection("_health")
            .document("ping")
            .get(
                timeout=FIRESTORE_RPC_TIMEOUT_SECONDS,
                retry=None,
            )
        )


async def get_firestore_status() -> FirestoreStatus:
    if not firebase_credentials_configured():
        return "unconfigured"
    if get_firebase_initialization_error() is not None or get_firebase_app() is None:
        return "unavailable"

    try:
        await asyncio.wait_for(
            HealthRepository().ping(),
            timeout=FIRESTORE_HEALTH_TIMEOUT_SECONDS,
        )
    except TimeoutError:
        logger.error("Firestore health check timed out")
        return "unavailable"
    except Exception:
        logger.exception("Firestore health check failed")
        return "unavailable"
    return "connected"
