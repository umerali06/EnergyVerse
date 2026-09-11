import asyncio

from app.db.repositories.inspections import InspectionRepository
from app.models.base import CompanyScope
from scripts.backfill_inspection_titles import backfill_inspection_titles
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient


def _untitle(client: FakeAsyncClient, inspection_id: str) -> None:
    """Simulate an inspection created before the service derived a title.

    The seed script itself always supplies one, so a legacy record has to be
    reproduced by clearing the field.
    """
    asyncio.run(client.collection("inspections").document(inspection_id).update({"title": None}))


def _seed_and_untitle() -> tuple[FakeAsyncClient, str]:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    inspections = InspectionRepository(client)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)
    seeded = asyncio.run(inspections.list(scope))
    assert seeded, "seed produced no inspections to exercise the backfill against"
    target = seeded[0].id
    _untitle(client, target)
    return client, target


def test_backfill_names_untitled_inspections_after_their_asset() -> None:
    client, target = _seed_and_untitle()
    inspections = InspectionRepository(client)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)

    before = asyncio.run(inspections.get(scope, target))
    assert before is not None
    assert before.title is None

    titled = asyncio.run(backfill_inspection_titles(client))
    assert target in titled

    after = asyncio.run(inspections.get(scope, target))
    assert after is not None
    assert after.title == titled[target]
    # The derived title carries the inspection type and the asset's real name,
    # which is what a reviewer scans for -- never the literal "Untitled".
    assert after.title is not None and "inspection" in after.title.casefold()
    assert "Untitled" not in after.title

    # Re-running finds nothing left to backfill (idempotent).
    assert asyncio.run(backfill_inspection_titles(client)) == {}


def test_backfill_does_not_bump_revision() -> None:
    client, target = _seed_and_untitle()
    inspections = InspectionRepository(client)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)

    before = asyncio.run(inspections.get(scope, target))
    assert before is not None

    asyncio.run(backfill_inspection_titles(client))

    after = asyncio.run(inspections.get(scope, target))
    assert after is not None
    # A backfill is not a user edit: bumping the revision would force every
    # offline client holding a concurrency token into a spurious conflict.
    assert after.revision == before.revision


def test_dry_run_reports_without_writing() -> None:
    client, target = _seed_and_untitle()
    inspections = InspectionRepository(client)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)

    planned = asyncio.run(backfill_inspection_titles(client, dry_run=True))
    assert target in planned

    unchanged = asyncio.run(inspections.get(scope, target))
    assert unchanged is not None
    assert unchanged.title is None
