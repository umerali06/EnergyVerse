# FEV API

FastAPI backend scaffold for Flacron EnergyVerse.

```powershell
poetry install
poetry run uvicorn app.main:app --reload
```

With Firebase Admin credentials configured, seed the Phase 0.4 foundation with:

```powershell
poetry run python -m scripts.seed
```

To migrate only the declared demo users to real Firebase Auth UIDs, set
`SEED_DEMO_PASSWORD` and run:

```powershell
$env:SEED_DEMO_PASSWORD="choose-a-local-dev-password"
poetry run python -m scripts.seed --with-auth-users
```

This mode is idempotent, preserves the seed users' Firestore timestamps, assigns
`company_id`, `role_id`, and `role_key` custom claims, and does not migrate any
non-seed user. `FIREBASE_WEB_API_KEY` is needed only for the real password-login
integration test. `AUTH_ACTION_URL` is optional; when unset, verification and reset
link generation uses Firebase's default behavior.
