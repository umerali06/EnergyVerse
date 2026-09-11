"""Reconcile companies against Stripe when a webhook was missed.

A webhook can be missed for ordinary reasons: `stripe listen` was not running
during local checkout, the API was down, or a delivery exhausted its retries.
The tenant has paid, Stripe knows, and only our copy is stale — so recovery is
a read from Stripe plus the same reconciliation the webhook performs, never a
re-charge.

    poetry run python -m scripts.stripe_resync --company cmp_abc123
    poetry run python -m scripts.stripe_resync --all-incomplete
    poetry run python -m scripts.stripe_resync --all-incomplete --dry-run

Matching is by the `fev_company_id` we stamp on every subscription at checkout,
so a subscription belonging to another product in the same Stripe account is
never picked up.
"""

from __future__ import annotations

import argparse
import asyncio
import sys
from dataclasses import dataclass

import stripe

from app.audit.service import AuditService
from app.billing.service import SubscriptionService
from app.billing.stripe_gateway import get_stripe_gateway, snapshot_from_subscription
from app.core.settings import settings
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.models.base import CompanyScope

#: Statuses worth adopting. A subscription Stripe has already finished with
#: tells us nothing useful about current access.
ADOPTABLE = {"trialing", "active", "past_due", "unpaid", "canceled"}


@dataclass(frozen=True)
class Candidate:
    company_id: str
    subscription_id: str
    status: str
    tier: str | None


def find_subscriptions(company_id: str | None) -> list[Candidate]:
    """Scan Stripe subscriptions and keep the ones carrying our metadata."""
    stripe.api_key = settings.stripe_secret_key
    found: list[Candidate] = []
    # `search` needs an index that may lag by a minute, so a bounded list scan
    # is more reliable right after a checkout.
    for subscription in stripe.Subscription.list(
        limit=100, status="all"
    ).auto_paging_iter():
        payload = subscription.to_dict()
        metadata = dict(payload.get("metadata") or {})
        owner = metadata.get("fev_company_id")
        if not owner:
            continue
        if company_id is not None and owner != company_id:
            continue
        if payload.get("status") not in ADOPTABLE:
            continue
        snapshot = snapshot_from_subscription(payload)
        found.append(
            Candidate(
                company_id=owner,
                subscription_id=snapshot.subscription_id,
                status=snapshot.status,
                tier=snapshot.tier.value if snapshot.tier else None,
            )
        )
    return found


async def incomplete_company_ids() -> list[str]:
    client = get_firestore_client()
    ids: list[str] = []
    async for document in client.collection("companies").stream():
        values = document.to_dict() or {}
        if values.get("subscription_status") in (None, "incomplete"):
            ids.append(document.id)
    return ids


async def resync(company_ids: list[str] | None, *, dry_run: bool) -> int:
    if not settings.stripe_configured:
        print("STRIPE_SECRET_KEY is not set.", file=sys.stderr)
        return 1

    targets: set[str] | None = set(company_ids) if company_ids else None
    candidates = [
        candidate
        for candidate in find_subscriptions(None)
        if targets is None or candidate.company_id in targets
    ]
    if not candidates:
        print("No Stripe subscription carries fev_company_id for the selection.")
        return 0

    service = SubscriptionService(
        gateway=get_stripe_gateway(),
        companies=CompanyRepository(),
        audit=AuditService(AuditLogRepository()),
    )
    companies = CompanyRepository()

    applied = 0
    for candidate in candidates:
        scope = CompanyScope(company_id=candidate.company_id)
        before = await companies.get(scope)
        if before is None:
            print(f"  skip    {candidate.company_id}  (no such company)")
            continue
        arrow = (
            f"{before.subscription_tier}/{before.subscription_status}"
            f" -> {candidate.tier or before.subscription_tier}/{candidate.status}"
        )
        if dry_run:
            print(f"  would   {candidate.company_id}  {arrow}")
            continue

        # The same path the webhook takes, so a resync cannot diverge from a
        # normal delivery: it re-reads the live subscription and writes that.
        outcome = await service.reconcile_event(
            {
                "id": f"resync_{candidate.subscription_id}",
                "type": "customer.subscription.updated",
                "data": {
                    "object": {
                        "object": "subscription",
                        "id": candidate.subscription_id,
                        "metadata": {"fev_company_id": candidate.company_id},
                    }
                },
            }
        )
        print(f"  {outcome:<8}{candidate.company_id}  {arrow}")
        applied += 1

    print(f"\n{applied} company(ies) reconciled{' (dry run: none)' if dry_run else ''}.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--company", action="append", help="company id (repeatable)")
    parser.add_argument(
        "--all-incomplete",
        action="store_true",
        help="every company still sitting at incomplete",
    )
    parser.add_argument("--dry-run", action="store_true")
    arguments = parser.parse_args()

    if not arguments.company and not arguments.all_incomplete:
        parser.error("pass --company or --all-incomplete")

    mode = "TEST" if str(settings.stripe_secret_key).startswith("sk_test_") else "LIVE"
    print(f"Stripe mode: {mode}\n")

    async def run() -> int:
        # One event loop for the whole run: the async Firestore client binds to
        # the loop it is first used on, so a second asyncio.run would hand it a
        # closed loop.
        company_ids = list(arguments.company or [])
        if arguments.all_incomplete:
            company_ids += await incomplete_company_ids()
        return await resync(company_ids, dry_run=arguments.dry_run)

    return asyncio.run(run())


if __name__ == "__main__":
    raise SystemExit(main())
