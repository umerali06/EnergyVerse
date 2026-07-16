import asyncio
from collections.abc import Mapping
from typing import Any, Protocol

from firebase_admin import auth  # type: ignore[import-untyped]

from app.core.firebase import get_firebase_app


class AuthUser(Protocol):
    uid: str
    email: str | None
    custom_claims: Mapping[str, Any] | None


class AuthAdmin(Protocol):
    async def create_user(
        self,
        *,
        email: str,
        password: str | None,
        display_name: str,
    ) -> AuthUser: ...

    async def get_user(self, uid: str) -> AuthUser: ...

    async def get_user_by_email(self, email: str) -> AuthUser | None: ...

    async def update_user(
        self,
        uid: str,
        *,
        password: str | None = None,
        display_name: str | None = None,
    ) -> AuthUser: ...

    async def set_custom_user_claims(
        self,
        uid: str,
        claims: Mapping[str, object],
    ) -> None: ...


class FirebaseAuthAdmin:
    @staticmethod
    def _app() -> Any:
        app = get_firebase_app()
        if app is None:
            raise RuntimeError("Firebase Admin SDK is not available")
        return app

    async def create_user(
        self,
        *,
        email: str,
        password: str | None,
        display_name: str,
    ) -> AuthUser:
        values: dict[str, object] = {
            "email": email,
            "display_name": display_name,
            "email_verified": False,
            "disabled": False,
        }
        if password is not None:
            values["password"] = password
        return await asyncio.to_thread(auth.create_user, app=self._app(), **values)

    async def get_user(self, uid: str) -> AuthUser:
        return await asyncio.to_thread(auth.get_user, uid, app=self._app())

    async def get_user_by_email(self, email: str) -> AuthUser | None:
        try:
            return await asyncio.to_thread(
                auth.get_user_by_email,
                email,
                app=self._app(),
            )
        except auth.UserNotFoundError:
            return None

    async def update_user(
        self,
        uid: str,
        *,
        password: str | None = None,
        display_name: str | None = None,
    ) -> AuthUser:
        values: dict[str, object] = {}
        if password is not None:
            values["password"] = password
        if display_name is not None:
            values["display_name"] = display_name
        return await asyncio.to_thread(
            auth.update_user,
            uid,
            app=self._app(),
            **values,
        )

    async def set_custom_user_claims(
        self,
        uid: str,
        claims: Mapping[str, object],
    ) -> None:
        await asyncio.to_thread(
            auth.set_custom_user_claims,
            uid,
            dict(claims),
            app=self._app(),
        )


def get_auth_admin() -> AuthAdmin:
    return FirebaseAuthAdmin()
