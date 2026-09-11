"""Shared test setup.

Phase 13 put an entitlement gate on every module router, so a request now
resolves the caller's company to decide whether its plan includes the module.
Without an override that reaches Firestore, which the suite does not have — so
by default every test runs as a fully-entitled Enterprise tenant.

That default is deliberate: the vast majority of these tests are about
permissions, validation, and domain rules, and should not have to think about
billing. The tests that *are* about the gate (`test_billing_entitlements.py`)
override it with a narrower plan and assert the 402.
"""

from collections.abc import Iterator
from datetime import UTC, datetime

import pytest

from app.billing.dependencies import get_entitlements
from app.billing.entitlements import Entitlements, resolve_entitlements
from app.billing.plans import PlanTier
from app.main import app
from app.models.entities import Company


def entitlements_for(tier: PlanTier, *, status: str = "active") -> Entitlements:
    """Resolve entitlements the way production does, without a database.

    Deliberately routes through `resolve_entitlements` rather than constructing
    `Entitlements` directly: an earlier version of this helper handed out the
    plan's features regardless of status, which made a cancelled company look
    entitled and would have hidden a real regression.
    """
    now = datetime(2026, 9, 10, tzinfo=UTC)
    return resolve_entitlements(
        Company(
            id="test-company",
            name="Test Company",
            status="active",
            subscription_tier=tier.value,
            subscription_status=status,
            created_at=now,
            updated_at=now,
        )
    )


@pytest.fixture(autouse=True)
def entitled_company() -> Iterator[None]:
    """Every test is an entitled Enterprise tenant unless it says otherwise."""
    app.dependency_overrides[get_entitlements] = lambda: entitlements_for(
        PlanTier.ENTERPRISE
    )
    yield
    app.dependency_overrides.pop(get_entitlements, None)
