"""Create or update the Stripe Products and Prices for every published plan.

Idempotent: Products use a deterministic id (`fev_operations`) and Prices are
addressed by lookup key (`fev_operations_annual`), so re-running reconciles
rather than duplicating. Stripe Prices are immutable, so a changed amount means
the old Price is archived and a new one created carrying the same lookup key —
existing subscriptions keep billing on the archived Price until they are
migrated, which is Stripe's intended behaviour and why nothing here deletes.

    poetry run python -m scripts.stripe_sync            # apply
    poetry run python -m scripts.stripe_sync --dry-run  # show the diff only

Reads `STRIPE_SECRET_KEY` from the environment. The key's mode decides which
Stripe account this writes to; the amounts always come from
`app.billing.plans`, so what is charged cannot drift from what is published.
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass

import stripe

from app.billing.plans import PLANS, TIER_ORDER, BillingInterval, Plan
from app.billing.stripe_gateway import price_lookup_key, product_lookup_id
from app.core.settings import settings

STRIPE_INTERVAL = {
    BillingInterval.MONTHLY: "month",
    BillingInterval.ANNUAL: "year",
}


@dataclass
class Change:
    action: str
    target: str
    detail: str

    def __str__(self) -> str:
        return f"  {self.action:<8} {self.target:<28} {self.detail}"


def ensure_product(plan: Plan, *, dry_run: bool) -> list[Change]:
    product_id = product_lookup_id(plan.tier)
    description = (
        f"{plan.audience}. "
        f"{_quota_text(plan)}. {plan.support}."
    )
    try:
        # The SDK returns StripeObject, which is not a dict; normalise at the
        # boundary so the rest of this script works on plain values.
        existing = stripe.Product.retrieve(product_id).to_dict()
    except stripe.InvalidRequestError:
        existing = None

    if existing is None:
        if not dry_run:
            stripe.Product.create(
                id=product_id,
                name=f"Flacron EnergyVerse — {plan.name}",
                description=description,
                metadata={"fev_tier": plan.tier.value},
            )
        return [Change("create", product_id, plan.name)]

    if existing.get("description") != description or existing.get("active") is False:
        if not dry_run:
            stripe.Product.modify(product_id, description=description, active=True)
        return [Change("update", product_id, "description")]
    return []


def _quota_text(plan: Plan) -> str:
    quotas = plan.quotas
    if quotas.facilities is None:
        facilities = "Unlimited facilities"
    elif quotas.facilities == 1:
        facilities = "1 facility"
    else:
        facilities = f"{quotas.facilities} facilities"
    assets = "unlimited assets" if quotas.assets is None else f"up to {quotas.assets:,} assets"
    seats = "unlimited seats" if quotas.seats is None else f"up to {quotas.seats} seats"
    return f"{facilities}, {assets}, {seats}"


def ensure_price(
    plan: Plan,
    interval: BillingInterval,
    *,
    dry_run: bool,
) -> list[Change]:
    key = price_lookup_key(plan.tier, interval)
    amount = plan.price_cents(interval)
    found = stripe.Price.list(lookup_keys=[key], active=True, limit=1)
    current = found.data[0].to_dict() if found.data else None

    if current is not None:
        matches = (
            current.get("unit_amount") == amount
            and (current.get("recurring") or {}).get("interval") == STRIPE_INTERVAL[interval]
        )
        if matches:
            return []
        # Prices are immutable: archive and recreate under the same lookup key.
        if not dry_run:
            # Passing lookup_key=None frees the key so the replacement price can
            # claim it. Stripe supports this; its stubs declare the parameter str.
            stripe.Price.modify(
                current["id"],
                active=False,
                lookup_key=None,  # type: ignore[arg-type]
            )
        changes = [
            Change(
                "archive",
                key,
                f"{current.get('unit_amount')} -> {amount}",
            )
        ]
    else:
        changes = []

    if not dry_run:
        stripe.Price.create(
            product=product_lookup_id(plan.tier),
            currency="usd",
            unit_amount=amount,
            recurring={"interval": STRIPE_INTERVAL[interval]},
            lookup_key=key,
            transfer_lookup_key=True,
            nickname=f"{plan.name} ({interval.value})",
            metadata={
                "fev_tier": plan.tier.value,
                "fev_interval": interval.value,
            },
        )
    changes.append(Change("create", key, f"${amount / 100:,.2f} / {STRIPE_INTERVAL[interval]}"))
    return changes


def sync(*, dry_run: bool) -> int:
    if not settings.stripe_configured:
        print("STRIPE_SECRET_KEY is not set — nothing to do.", file=sys.stderr)
        return 1
    stripe.api_key = settings.stripe_secret_key
    mode = "TEST" if str(settings.stripe_secret_key).startswith("sk_test_") else "LIVE"
    print(f"Stripe mode: {mode}{'  (dry run)' if dry_run else ''}\n")

    changes: list[Change] = []
    for tier in TIER_ORDER:
        plan = PLANS[tier]
        print(f"{plan.name} ({tier.value})")
        tier_changes = ensure_product(plan, dry_run=dry_run)
        for interval in (BillingInterval.MONTHLY, BillingInterval.ANNUAL):
            tier_changes += ensure_price(plan, interval, dry_run=dry_run)
        if tier_changes:
            for change in tier_changes:
                print(change)
        else:
            print("  up to date")
        changes += tier_changes

    print(f"\n{len(changes)} change(s){' would be applied' if dry_run else ' applied'}.")
    return 0


def verify() -> int:
    """Read back every lookup key and confirm the amount matches the catalog."""
    stripe.api_key = settings.stripe_secret_key
    failures = 0
    print("Verifying every published price resolves to the catalogued amount:\n")
    for tier in TIER_ORDER:
        plan = PLANS[tier]
        for interval in (BillingInterval.MONTHLY, BillingInterval.ANNUAL):
            key = price_lookup_key(tier, interval)
            found = stripe.Price.list(lookup_keys=[key], active=True, limit=1)
            data = [item.to_dict() for item in found.data]
            expected = plan.price_cents(interval)
            if not data:
                print(f"  MISSING  {key}")
                failures += 1
                continue
            price = data[0]
            actual = price.get("unit_amount")
            recurring = (price.get("recurring") or {}).get("interval")
            ok = actual == expected and recurring == STRIPE_INTERVAL[interval]
            status = "ok     " if ok else "MISMATCH"
            if not ok:
                failures += 1
            print(
                f"  {status} {key:<28} {price['id']}  "
                f"${(actual or 0) / 100:,.2f}/{recurring}  (expected ${expected / 100:,.2f})"
            )
    print(f"\n{failures} problem(s).")
    return 1 if failures else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="show changes without applying")
    parser.add_argument("--verify", action="store_true", help="read back and check amounts")
    arguments = parser.parse_args()
    if arguments.verify:
        return verify()
    return sync(dry_run=arguments.dry_run)


if __name__ == "__main__":
    raise SystemExit(main())
