import asyncio
from collections.abc import Mapping
from typing import Any, Protocol

from firebase_admin import auth  # type: ignore[import-untyped]

from app.core.firebase import get_firebase_app

TOKEN_CLOCK_SKEW_SECONDS = 30


class TokenVerificationError(Exception):
    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code


class TokenVerifier(Protocol):
    async def verify(self, token: str) -> Mapping[str, Any]: ...


class FirebaseTokenVerifier:
    async def verify(self, token: str) -> Mapping[str, Any]:
        app = get_firebase_app()
        if app is None:
            raise TokenVerificationError(
                "auth_unavailable",
                "Authentication service is unavailable",
            )
        try:
            # check_revoked=True adds a live lookup against Firebase's servers on
            # every request. For a user created moments earlier that lookup can
            # hit an eventually-consistent read path and report a perfectly valid,
            # freshly-minted token as invalid (reproduced: same token fails, then
            # succeeds unchanged ~5s later). get_current_user already re-checks
            # user.status against our own DB on every request, so a
            # disabled/deleted account is still blocked without this race.
            decoded: Mapping[str, Any] = await asyncio.to_thread(
                auth.verify_id_token,
                token,
                app=app,
                clock_skew_seconds=TOKEN_CLOCK_SKEW_SECONDS,
            )
            return decoded
        except auth.ExpiredIdTokenError as error:
            raise TokenVerificationError("token_expired", "Token has expired") from error
        except (auth.InvalidIdTokenError, auth.UserDisabledError) as error:
            raise TokenVerificationError("invalid_token", "Token is invalid") from error
        except Exception as error:
            raise TokenVerificationError(
                "token_verification_failed",
                "Token could not be verified",
            ) from error


def get_token_verifier() -> TokenVerifier:
    return FirebaseTokenVerifier()
