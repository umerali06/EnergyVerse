from firebase_admin import firestore_async  # type: ignore[import-untyped]
from google.cloud.firestore_v1.async_client import AsyncClient

from app.core.firebase import get_firebase_app

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


def reset_firestore_client_for_testing() -> None:
    """Drop the cached async client between isolated test event loops."""
    global _client

    _client = None
    firebase_app = get_firebase_app()
    services = getattr(firebase_app, "_services", None)
    if isinstance(services, dict):
        services.pop("_firestore_async", None)
