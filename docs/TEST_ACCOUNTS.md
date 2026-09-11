# FEV Test Accounts

Demo logins for local testing of the admin panel (Next.js) and the field app
(Flutter web / mobile). All of them are created by
`apps/api/scripts/seed.py --with-auth-users` against the dev Firebase project.

Run instructions live in [RUNNING_LOCALLY.md](RUNNING_LOCALLY.md).

---

## Password

Every seeded account below uses the **same** password — the value of
`SEED_DEMO_PASSWORD` in `apps/api/.env` (not repeated here on purpose, so this
file stays safe to commit). Print it with:

```powershell
Select-String -Path apps\api\.env -Pattern '^SEED_DEMO_PASSWORD='
```

To change it for every demo account at once, edit that value and re-run:

```powershell
cd apps\api ; poetry run python -m scripts.seed --with-auth-users
```

---

## Accounts

Tenant **Acme Energy** (`acme-energy`) — this is the tenant with all the demo
facilities, areas, assets, inspections, permits, work orders, and documents.

| # | Email | Role | Perms | Best used for |
| --- | --- | --- | --- | --- |
| 1 | `super_admin@acme.example.invalid` | Super Admin | 28 | Everything, incl. `platform.admin` (Platform section) |
| 2 | `company_admin@acme.example.invalid` | Company Admin | 27 | **Default admin-panel login.** Everything except platform admin |
| 3 | `operations_manager@acme.example.invalid` | Operations Manager | 20 | Facilities/areas/assets/checklists CRUD, permit approve, work-order close |
| 4 | `field_inspector@acme.example.invalid` | Field Inspector | 14 | **Default mobile login.** Run inspections, safety reports, generate reports |
| 5 | `maintenance_technician@acme.example.invalid` | Maintenance Technician | 11 | Work-order execution (accept/update); read-only elsewhere |
| 6 | `hse_manager@acme.example.invalid` | HSE Manager | 17 | Permits write/approve, safety write/close, audit log |
| 7 | `executive@acme.example.invalid` | Executive | 11 | Read-only oversight + audit log — good for testing 403 paths |

Tenant **Beta Utilities** (`beta-utilities`) — separate tenant, used to prove
multi-tenant isolation (it should show **none** of Acme's data):

| # | Email | Role | Perms |
| --- | --- | --- | --- |
| 8 | `company_admin@beta.example.invalid` | Company Admin | 27 |

All eight were verified end-to-end on 2026-09-06: Firebase password sign-in →
`GET /api/v1/auth/me` (correct `role_key`, `email_verified: true`, permission
count as above) → `GET /api/v1/dashboard/summary` → 200.

---

## Email verification

The seed creates Firebase Auth users with `email_verified: false`, and every
protected API route sits behind `require_verified_email` — so an unverified
account can sign in but gets `403 email_unverified` on everything, and the
clients park it on the verify-email screen.

The `@*.example.invalid` domains can never receive a verification email, so all
eight accounts above have been marked verified directly through the Admin SDK.
**After a fresh `--with-auth-users` seed on a new Firebase project, redo this**,
either in Firebase Console → Authentication → user → "Mark email as verified",
or with:

```powershell
cd apps\api
poetry run python -c @'
from app.core.firebase import get_firebase_app
from firebase_admin import auth
app = get_firebase_app()
for e in [
    "super_admin@acme.example.invalid",
    "company_admin@acme.example.invalid",
    "operations_manager@acme.example.invalid",
    "field_inspector@acme.example.invalid",
    "maintenance_technician@acme.example.invalid",
    "hse_manager@acme.example.invalid",
    "executive@acme.example.invalid",
    "company_admin@beta.example.invalid",
]:
    u = auth.get_user_by_email(e, app=app)
    if not u.email_verified:
        auth.update_user(u.uid, email_verified=True, app=app)
        print("verified:", e)
'@
```

---

## Suggested test matrix

| Scenario | Admin panel | Field app |
| --- | --- | --- |
| Happy path, full access | `company_admin@acme` | — |
| Field workflow (inspections, photos, readings, signature, offline) | — | `field_inspector@acme` |
| Work-order execution | `operations_manager@acme` creates/assigns | `maintenance_technician@acme` accepts/updates |
| Permit approval | `hse_manager@acme` | `field_inspector@acme` raises |
| RBAC / 403 rendering | `executive@acme` (try any write action) | `field_inspector@acme` on `/rbac-demo` |
| Platform-only section | `super_admin@acme` (only role with `platform.admin`) | — |
| Multi-tenant isolation | `company_admin@beta` — must see zero Acme records | — |

Client-side route guards are UX only; the API's `require_permission` stays
authoritative, so a denied action returns a real 403 envelope as well as the
branded 403 page.

---

## Non-seed accounts in the dev Firebase project

These exist from earlier real-signup tests and are **not** part of the seed —
their passwords are not managed here, and each one owns its own throwaway
tenant (`cmp_…`), so they show an empty app:

- `umerali7454@gmail.com`
- `umeraliumeralimalik+fev-...@gmail.com`
- `repro.test.*@example.com` (2 accounts)

Safe to ignore, or delete from Firebase Console → Authentication to keep the
user list clean.

---

## Creating a brand-new tenant by hand

To test the self-service signup flow instead of the seed, use the admin panel's
sign-up screen with a **real, fresh** inbox (a Gmail `+alias` works). That path
creates a new company, installs the seven system roles, and makes you its
`company_admin` — and it does send a real verification email, so a working
mailbox is required.
