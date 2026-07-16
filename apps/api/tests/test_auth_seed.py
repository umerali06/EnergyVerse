import asyncio

from app.models.base import CompanyScope
from scripts.seed import ACME_COMPANY_ID, DEMO_USERS, run_seed
from tests.fakes.auth import FakeAuthAdmin
from tests.fakes.firestore import FakeAsyncClient


def test_auth_seed_migrates_demo_uids_and_is_idempotent() -> None:
    firestore = FakeAsyncClient()
    admin = FakeAuthAdmin()
    asyncio.run(run_seed(firestore))
    original = firestore.documents("users")["demo-acme-executive"]

    first = asyncio.run(
        run_seed(
            firestore,
            with_auth_users=True,
            demo_password="ValidPass123!",
            auth_admin=admin,
        )
    )
    second = asyncio.run(
        run_seed(
            firestore,
            with_auth_users=True,
            demo_password="ValidPass123!",
            auth_admin=admin,
        )
    )

    assert first == second
    assert first.users == len(DEMO_USERS)
    documents = firestore.documents("users")
    assert all(user.placeholder_uid not in documents for user in DEMO_USERS)
    executive = asyncio.run(admin.get_user_by_email("executive@acme.example.invalid"))
    assert executive is not None
    migrated = documents[executive.uid]
    assert migrated["created_at"] == original["created_at"]
    assert migrated["updated_at"] == original["updated_at"]
    assert migrated["created_by"] == original["created_by"]
    migration_audits = [
        entry
        for entry in firestore.documents("audit_logs").values()
        if entry["action"] == "user.migrated_to_auth_uid"
    ]
    assert len(migration_audits) == len(DEMO_USERS)


def test_auth_seed_recovers_real_uid_plus_placeholder_partial_run() -> None:
    firestore = FakeAsyncClient()
    admin = FakeAuthAdmin()
    asyncio.run(
        run_seed(
            firestore,
            with_auth_users=True,
            demo_password="ValidPass123!",
            auth_admin=admin,
        )
    )
    demo = DEMO_USERS[0]
    real_user = asyncio.run(admin.get_user_by_email(demo.email))
    assert real_user is not None
    real_document = firestore.documents("users")[real_user.uid]
    firestore._store["users"][demo.placeholder_uid] = {
        **real_document,
        "id": demo.placeholder_uid,
    }

    counts = asyncio.run(
        run_seed(
            firestore,
            with_auth_users=True,
            demo_password="ValidPass123!",
            auth_admin=admin,
        )
    )
    assert counts.users == len(DEMO_USERS)
    assert demo.placeholder_uid not in firestore.documents("users")
    assert firestore.documents("users")[real_user.uid] == real_document


def test_seed_without_auth_does_not_recreate_migrated_placeholders() -> None:
    firestore = FakeAsyncClient()
    admin = FakeAuthAdmin()
    asyncio.run(
        run_seed(
            firestore,
            with_auth_users=True,
            demo_password="ValidPass123!",
            auth_admin=admin,
        )
    )
    counts = asyncio.run(run_seed(firestore))
    assert counts.users == len(DEMO_USERS)
    assert all(demo.placeholder_uid not in firestore.documents("users") for demo in DEMO_USERS)
    assert (
        len(
            [
                user
                for user in firestore.documents("users").values()
                if user["company_id"] == CompanyScope(company_id=ACME_COMPANY_ID).company_id
            ]
        )
        == 7
    )
