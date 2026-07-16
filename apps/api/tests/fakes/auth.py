from dataclasses import dataclass, field
from typing import Any


@dataclass
class FakeAuthUser:
    uid: str
    email: str | None
    display_name: str | None = None
    custom_claims: dict[str, Any] | None = None


@dataclass
class FakeAuthAdmin:
    users: dict[str, FakeAuthUser] = field(default_factory=dict)
    next_uid: int = 1

    async def create_user(
        self,
        *,
        email: str,
        password: str | None,
        display_name: str,
    ) -> FakeAuthUser:
        del password
        if await self.get_user_by_email(email) is not None:
            raise ValueError("Firebase Auth user already exists")
        user = FakeAuthUser(
            uid=f"firebase-uid-{self.next_uid}",
            email=email,
            display_name=display_name,
        )
        self.next_uid += 1
        self.users[user.uid] = user
        return user

    async def get_user(self, uid: str) -> FakeAuthUser:
        return self.users[uid]

    async def get_user_by_email(self, email: str) -> FakeAuthUser | None:
        normalized = email.casefold()
        return next(
            (
                user
                for user in self.users.values()
                if user.email is not None and user.email.casefold() == normalized
            ),
            None,
        )

    async def update_user(
        self,
        uid: str,
        *,
        password: str | None = None,
        display_name: str | None = None,
    ) -> FakeAuthUser:
        del password
        user = self.users[uid]
        if display_name is not None:
            user.display_name = display_name
        return user

    async def set_custom_user_claims(
        self,
        uid: str,
        claims: dict[str, object],
    ) -> None:
        self.users[uid].custom_claims = dict(claims)
