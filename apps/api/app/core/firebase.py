import base64
import json
import logging
from typing import Any

import firebase_admin  # type: ignore[import-untyped]
from firebase_admin import App, credentials

from app.core.settings import settings

logger = logging.getLogger(__name__)

_initialization_attempted = False
_firebase_app: App | None = None
_initialization_error: Exception | None = None


def firebase_credentials_configured() -> bool:
    """Report whether either supported credential source was configured."""
    return settings.firebase_credentials_configured


def _credential_from_base64(value: str) -> credentials.Certificate:
    decoded = base64.b64decode(value, validate=True)
    credential_info: Any = json.loads(decoded.decode("utf-8"))
    if not isinstance(credential_info, dict):
        raise ValueError("Firebase credentials must decode to a JSON object")
    return credentials.Certificate(credential_info)


def initialize_firebase() -> App | None:
    """Initialize the Firebase Admin SDK at most once for this process."""
    global _firebase_app, _initialization_attempted, _initialization_error

    if _initialization_attempted:
        return _firebase_app

    _initialization_attempted = True
    if not firebase_credentials_configured():
        logger.info("Firebase credentials are not configured")
        return None

    try:
        if settings.firebase_credentials_b64:
            credential = _credential_from_base64(settings.firebase_credentials_b64)
        elif settings.google_application_credentials:
            credential = credentials.Certificate(settings.google_application_credentials)
        else:  # Defensive: credential presence was checked above.
            return None

        options = (
            {"projectId": settings.firebase_project_id}
            if settings.firebase_project_id
            else None
        )
        _firebase_app = firebase_admin.initialize_app(credential, options)
        logger.info("Firebase Admin SDK initialized")
    except Exception as error:  # The API must remain available if Firebase cannot start.
        _initialization_error = error
        logger.exception("Firebase Admin SDK initialization failed")

    return _firebase_app


def get_firebase_app() -> App | None:
    if not _initialization_attempted:
        return initialize_firebase()
    return _firebase_app


def get_firebase_initialization_error() -> Exception | None:
    return _initialization_error
