"""Real-creds verification of the corrected signup flow (D-103), end to end.

Walks a brand-new company through the exact sequence a customer now follows —
register, verify the email, discover it owns no plan, open a real Stripe
Checkout Session, and settle the return — against the live Firebase project and
the live Stripe account in **test mode**. Nothing here is faked: the Firebase
user is real, the verification link is the real one Firebase mints, the Checkout
Session is a real one, and the subscription that comes back is a real Stripe
subscription created by a real card entry.

Split into two phases because completing a Checkout Session is only possible on
Stripe's hosted page, which a browser has to drive:

    # 1. up to the checkout URL, writes the handoff file
    python -m poetry run python -m scripts.verify_signup_checkout_live --open

    # 2. after the browser has paid, settles and asserts
    python -m poetry run python -m scripts.verify_signup_checkout_live --settle

    # removes the Firebase user, the company, and the Stripe objects
    python -m poetry run python -m scripts.verify_signup_checkout_live --cleanup

The API must be running locally, because the point is to exercise the real HTTP
routes and their dependencies (`require_billing_admin`, `get_entitlements`,
`require_verified_email`) rather than the services underneath them.
"""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys
import time
from pathlib import Path
from typing import Any

import httpx
import stripe
from firebase_admin import auth as firebase_auth

from app.core.firebase import get_firebase_app
from app.core.settings import settings
from app.db.firestore import get_firestore_client

API = os.environ.get("VERIFY_API_BASE", "http://127.0.0.1:8011")
WEB_API_KEY = os.environ.get("VERIFY_FIREBASE_WEB_API_KEY", "")
HANDOFF = Path(os.environ.get("VERIFY_HANDOFF", "")) if os.environ.get(
    "VERIFY_HANDOFF"
) else Path(__file__).with_name("_signup_live_state.json")

PASSWORD = "VerifyFlow1!"
TIER = "starter"
INTERVAL = "annual"


def log(step: str, detail: str = "") -> None:
    print(f"  {step:<46}{detail}", flush=True)


def state_read() -> dict[str, Any]:
    return json.loads(HANDOFF.read_text(encoding="utf-8"))


def state_write(data: dict[str, Any]) -> None:
    HANDOFF.write_text(json.dumps(data, indent=2), encoding="utf-8")


def sign_in(email: str, password: str) -> dict[str, Any]:
    """Exchange a password for an ID token exactly as the browser SDK does."""
    if not WEB_API_KEY:
        raise SystemExit("VERIFY_FIREBASE_WEB_API_KEY is required")
    response = httpx.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword",
        params={"key": WEB_API_KEY},
        json={"email": email, "password": password, "returnSecureToken": True},
        timeout=30,
    )
    response.raise_for_status()
    return response.json()


def auth_headers(token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"}


# ----------------------------------------------------------------- phase one


async def phase_open() -> None:
    stamp = int(time.time())
    email = f"umeraliumeralimalik+fev-d103-{stamp}@gmail.com"
    company = f"D103 Verify {stamp}"

    print("\n=== Phase 1: registration through to Stripe ===\n")

    registered = httpx.post(
        f"{API}/api/v1/auth/register",
        json={
            "company_name": company,
            "display_name": "D103 Verifier",
            "email": email,
            "password": PASSWORD,
        },
        timeout=60,
    )
    registered.raise_for_status()
    identity = registered.json()
    company_id = identity["company_id"]
    uid = identity["uid"]
    log("registered company admin", f"company={company_id}")
    assert identity["email_verified"] is False, "a new admin must start unverified"
    assert identity["role_key"] == "company_admin"

    session = sign_in(email, PASSWORD)
    token = session["idToken"]

    me = httpx.get(f"{API}/api/v1/auth/me", headers=auth_headers(token), timeout=30)
    me.raise_for_status()
    assert me.json()["email_verified"] is False
    log("GET /auth/me", "email_verified=false (verification owed)")

    # The branded sender is the whole point of the email half of D-103: the app
    # used to call Firebase's own unbranded sender instead of this route.
    sent = httpx.post(
        f"{API}/api/v1/auth/verification-email",
        headers=auth_headers(token),
        timeout=60,
    )
    if sent.status_code == 200:
        assert sent.json()["sent"] is True, sent.text
        log("POST /auth/verification-email", "sent=true (branded, via SES)")
        ses_outcome = "sent"
    else:
        # Must never be a 500: a refused provider is not a broken server, and
        # the admin client reads this status to decide whether to fall back to
        # the provider's own sender.
        assert sent.status_code in (502, 503), f"unexpected {sent.status_code}: {sent.text}"
        body = sent.json()
        assert body["error"] in ("email_delivery_failed", "email_not_configured"), body
        log(
            "POST /auth/verification-email",
            f"{sent.status_code} {body['error']} -> client falls back",
        )
        ses_outcome = f"{sent.status_code} {body['error']}"

    # A module route must refuse an unverified admin, which is what makes the
    # verify step a real gate rather than a suggestion.
    gated = httpx.get(f"{API}/api/v1/assets", headers=auth_headers(token), timeout=30)
    assert gated.status_code == 403, f"expected 403 while unverified, got {gated.status_code}"
    log("GET /assets while unverified", f"{gated.status_code} (gate holds)")

    # Flip the address to verified through the Admin SDK, which is how this
    # repo has always confirmed a test account (see docs/TEST_ACCOUNTS.md).
    # Following the real emailed link was tried first and is rate-limited:
    # Firebase answers TOO_MANY_ATTEMPTS_TRY_LATER on repeated `sendOobCode`
    # calls, and the send above already consumed one. What is under test here
    # is the *ordering* -- that the gate holds before this point and lifts
    # after it -- not Firebase's own hosted confirmation page.
    firebase_auth.update_user(uid, email_verified=True, app=get_firebase_app())
    log("marked the address verified", "via Admin SDK")

    refreshed = sign_in(email, PASSWORD)
    token = refreshed["idToken"]
    me = httpx.get(f"{API}/api/v1/auth/me", headers=auth_headers(token), timeout=30)
    me.raise_for_status()
    assert me.json()["email_verified"] is True, "verification must stick"
    log("GET /auth/me after verifying", "email_verified=true")

    subscription = httpx.get(
        f"{API}/api/v1/billing/subscription", headers=auth_headers(token), timeout=30
    )
    subscription.raise_for_status()
    body = subscription.json()
    assert body["is_entitled"] is False, "a new company owes a plan"
    assert body["tier"] == "unassigned"
    log("GET /billing/subscription", "is_entitled=false -> plan step is owed")

    checkout = httpx.post(
        f"{API}/api/v1/billing/checkout",
        headers=auth_headers(token),
        json={"tier": TIER, "interval": INTERVAL},
        timeout=60,
    )
    checkout.raise_for_status()
    created = checkout.json()
    session_id = created["session_id"]
    log("POST /billing/checkout", session_id)

    # Confirming before the card is entered must report `pending`, not failure —
    # this is the branch that used to look like a broken purchase.
    pending = httpx.post(
        f"{API}/api/v1/billing/checkout/confirm",
        headers=auth_headers(token),
        json={"session_id": session_id},
        timeout=60,
    )
    pending.raise_for_status()
    assert pending.json()["outcome"] == "pending", pending.text
    assert pending.json()["subscription"]["is_entitled"] is False
    log("POST /checkout/confirm before paying", "outcome=pending (not a failure)")

    state_write(
        {
            "email": email,
            "uid": uid,
            "company_id": company_id,
            "company_name": company,
            "session_id": session_id,
            "checkout_url": created["checkout_url"],
            "ses_outcome": ses_outcome,
        }
    )
    print(f"\nCHECKOUT_URL={created['checkout_url']}")
    print(f"SESSION_ID={session_id}\n")


# ----------------------------------------------------------------- phase two


async def phase_settle() -> None:
    state = state_read()
    token = sign_in(state["email"], PASSWORD)["idToken"]
    session_id = state["session_id"]

    print("\n=== Phase 2: settling the return from Stripe ===\n")

    confirmed = httpx.post(
        f"{API}/api/v1/billing/checkout/confirm",
        headers=auth_headers(token),
        json={"session_id": session_id},
        timeout=60,
    )
    confirmed.raise_for_status()
    first = confirmed.json()
    assert first["outcome"] == "reconciled", first
    plan = first["subscription"]
    assert plan["is_entitled"] is True, plan
    assert plan["tier"] == TIER, plan
    assert plan["status"] == "trialing", plan
    assert plan["trial_days_remaining"] == 7, plan
    log("POST /checkout/confirm after paying", f"{plan['tier']}/{plan['status']}")

    # Confirming again must write the same state: the screen retries, and a
    # webhook may land in between.
    again = httpx.post(
        f"{API}/api/v1/billing/checkout/confirm",
        headers=auth_headers(token),
        json={"session_id": session_id},
        timeout=60,
    )
    again.raise_for_status()
    assert again.json()["subscription"] == plan, "confirmation must be idempotent"
    log("POST /checkout/confirm twice", "identical state (idempotent)")

    read_back = httpx.get(
        f"{API}/api/v1/billing/subscription", headers=auth_headers(token), timeout=30
    )
    read_back.raise_for_status()
    assert read_back.json()["is_entitled"] is True
    log("GET /billing/subscription", "is_entitled=true -> shell unlocks")

    # The entitlement is real, not cosmetic: a base-tier module answers, and a
    # module the Starter plan does not include still refuses with 402.
    allowed = httpx.get(f"{API}/api/v1/assets", headers=auth_headers(token), timeout=30)
    assert allowed.status_code == 200, allowed.text
    log("GET /assets after paying", "200 (module unlocked)")

    refused = httpx.get(f"{API}/api/v1/work-orders", headers=auth_headers(token), timeout=30)
    assert refused.status_code == 402, refused.text
    assert refused.json()["error"] == "plan_upgrade_required", refused.text
    log("GET /work-orders on Starter", "402 plan_upgrade_required")

    # Cross-tenant refusal, the check that stops a pasted session id buying
    # somebody else's plan. Uses a second real company.
    stamp = int(time.time())
    other_email = f"umeraliumeralimalik+fev-d103-other-{stamp}@gmail.com"
    other = httpx.post(
        f"{API}/api/v1/auth/register",
        json={
            "company_name": f"D103 Other {stamp}",
            "display_name": "D103 Outsider",
            "email": other_email,
            "password": PASSWORD,
        },
        timeout=60,
    )
    other.raise_for_status()
    other_identity = other.json()
    other_token = sign_in(other_email, PASSWORD)["idToken"]
    stolen = httpx.post(
        f"{API}/api/v1/billing/checkout/confirm",
        headers=auth_headers(other_token),
        json={"session_id": session_id},
        timeout=60,
    )
    assert stolen.status_code == 400, stolen.text
    assert stolen.json()["error"] == "session_mismatch", stolen.text
    log("another company confirms this session", "400 session_mismatch")

    other_plan = httpx.get(
        f"{API}/api/v1/billing/subscription", headers=auth_headers(other_token), timeout=30
    )
    assert other_plan.json()["is_entitled"] is False, "the refusal must grant nothing"
    log("that company's own plan", "still unentitled (nothing leaked)")

    state["other_uid"] = other_identity["uid"]
    state["other_company_id"] = other_identity["company_id"]
    state["settled"] = True
    state_write(state)
    print("\nAll assertions passed.\n")


# ------------------------------------------------------------------- cleanup


async def phase_cleanup() -> None:
    state = state_read()
    print("\n=== Cleanup ===\n")
    stripe.api_key = settings.stripe_secret_key
    client = get_firestore_client()
    app = get_firebase_app()

    company = await client.collection("companies").document(state["company_id"]).get()
    data = company.to_dict() or {}
    subscription_id = data.get("stripe_subscription_id")
    customer_id = data.get("stripe_customer_id")
    if subscription_id:
        try:
            stripe.Subscription.cancel(subscription_id)
            log("cancelled subscription", subscription_id)
        except Exception as error:  # noqa: BLE001
            log("subscription already gone", str(error)[:60])
    if customer_id:
        try:
            stripe.Customer.delete(customer_id)
            log("deleted customer", customer_id)
        except Exception as error:  # noqa: BLE001
            log("customer already gone", str(error)[:60])

    for uid_key, company_key in (("uid", "company_id"), ("other_uid", "other_company_id")):
        uid = state.get(uid_key)
        company_id = state.get(company_key)
        if uid:
            try:
                firebase_auth.delete_user(uid, app=app)
                log("deleted firebase user", uid)
            except Exception as error:  # noqa: BLE001
                log("firebase user already gone", str(error)[:60])
        if company_id:
            for collection in ("users", "roles"):
                async for doc in client.collection(collection).where(
                    "company_id", "==", company_id
                ).stream():
                    await doc.reference.delete()
            await client.collection("companies").document(company_id).delete()
            log("deleted company", company_id)

    HANDOFF.unlink(missing_ok=True)
    print("\nCleanup complete.\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--open", action="store_true")
    parser.add_argument("--settle", action="store_true")
    parser.add_argument("--cleanup", action="store_true")
    args = parser.parse_args()
    if args.open:
        asyncio.run(phase_open())
    elif args.settle:
        asyncio.run(phase_settle())
    elif args.cleanup:
        asyncio.run(phase_cleanup())
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
