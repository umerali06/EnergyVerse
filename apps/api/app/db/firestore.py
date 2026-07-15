import asyncio
import logging
from typing import Literal

from firebase_admin import firestore_async  # type: ignore[import-untyped]
from google.cloud.firestore_v1.async_client import AsyncClient

from app.core.firebase import (
    firebase_credentials_configured,
    get_firebase_app,
    get_firebase_initialization_error,
)

logger = logging.getLogger(__name__)

FirestoreStatus = Literal["connected", "unavailable", "unconfigured"]
FIRESTORE_RPC_TIMEOUT_SECONDS = 8.0
FIRESTORE_HEALTH_TIMEOUT_SECONDS = 10.0

_client: AsyncClient | None = None


def get_firestore_client() -> AsyncClient:
    """Return the process-wide Firestore client, creating it only when first used."""
    global _client

    if _client is None:
        firebase_app = get_firebase_app()
        if firebase_app is None:
            raise RuntimeError("Firebase Admin SDK is not available")
        _client = firestore_async.client(app=firebase_app)
    return _client


async def _read_health_document() -> None:
    client = get_firestore_client()
    await client.collection("_health").document("ping").get(
        timeout=FIRESTORE_RPC_TIMEOUT_SECONDS,
        retry=None,
    )


async def get_firestore_status() -> FirestoreStatus:
    """Perform a bounded Firestore read without propagating service failures."""
    if not firebase_credentials_configured():
        return "unconfigured"

    if get_firebase_initialization_error() is not None or get_firebase_app() is None:
        return "unavailable"

    try:
        await asyncio.wait_for(
            _read_health_document(),
            timeout=FIRESTORE_HEALTH_TIMEOUT_SECONDS,
        )
    except TimeoutError:
        logger.error("Firestore health check timed out")
        return "unavailable"
    except Exception:
        logger.exception("Firestore health check failed")
        return "unavailable"

    return "connected"
