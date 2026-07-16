import asyncio

from firebase_admin import auth  # type: ignore[import-untyped]

from app.core.firebase import get_firebase_app
from app.core.settings import settings


def _action_settings(
    supplied: auth.ActionCodeSettings | None,
) -> auth.ActionCodeSettings | None:
    if supplied is not None:
        return supplied
    if settings.auth_action_url:
        return auth.ActionCodeSettings(url=settings.auth_action_url)
    return None


def _firebase_app() -> object:
    app = get_firebase_app()
    if app is None:
        raise RuntimeError("Firebase Admin SDK is not available")
    return app


async def generate_email_verification_link(
    email: str,
    action_code_settings: auth.ActionCodeSettings | None = None,
) -> str:
    return await asyncio.to_thread(
        auth.generate_email_verification_link,
        email,
        action_code_settings=_action_settings(action_code_settings),
        app=_firebase_app(),
    )


async def generate_password_reset_link(
    email: str,
    action_code_settings: auth.ActionCodeSettings | None = None,
) -> str:
    return await asyncio.to_thread(
        auth.generate_password_reset_link,
        email,
        action_code_settings=_action_settings(action_code_settings),
        app=_firebase_app(),
    )
