import asyncio

from app.db.repositories.assets import AssetRepository
from app.models.base import CompanyScope
from scripts.backfill_qr_codes import backfill_qr_codes
from scripts.seed import ACME_COMPANY_ID, ASSET_FEED_PUMP_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient


def _make_legacy(client: FakeAsyncClient, asset_id: str) -> None:
    """Simulate a pre-4.5 asset that predates create-time qr_code_id
    generation -- the seed script itself now always assigns one."""
    asyncio.run(client.collection("assets").document(asset_id).update({"qr_code_id": None}))


def test_backfill_assigns_missing_codes_and_is_idempotent() -> None:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    _make_legacy(client, ASSET_FEED_PUMP_ID)

    assets = AssetRepository(client)
    scope = CompanyScope(company_id=ACME_COMPANY_ID)

    before = asyncio.run(assets.get(scope, ASSET_FEED_PUMP_ID))
    assert before is not None
    assert before.qr_code_id is None

    assigned = asyncio.run(backfill_qr_codes(client))
    assert ASSET_FEED_PUMP_ID in assigned
    assert assigned[ASSET_FEED_PUMP_ID]

    after = asyncio.run(assets.get(scope, ASSET_FEED_PUMP_ID))
    assert after is not None
    assert after.qr_code_id == assigned[ASSET_FEED_PUMP_ID]

    # Re-running finds nothing left to backfill (idempotent).
    second_run = asyncio.run(backfill_qr_codes(client))
    assert second_run == {}


def test_backfill_never_reuses_a_code_already_in_use() -> None:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))
    _make_legacy(client, ASSET_FEED_PUMP_ID)

    assets = AssetRepository(client)
    existing_codes = {
        asset.qr_code_id
        for asset in asyncio.run(assets.list(CompanyScope(company_id=ACME_COMPANY_ID)))
        if asset.qr_code_id is not None
    }

    assigned = asyncio.run(backfill_qr_codes(client))
    assert assigned[ASSET_FEED_PUMP_ID] not in existing_codes
