# FEV Monorepo

Flacron EnergyVerse — enterprise multi-tenant SaaS for field inspection, maintenance, and safety workflows.

## Prerequisites

- Python 3.11+ and [Poetry](https://python-poetry.org/docs/#installation)
- Node.js 20+ and [pnpm](https://pnpm.io/installation)
- Flutter SDK 3.x ([install guide](https://docs.flutter.dev/get-started/install/windows))
- Git
- A Firebase project and service-account JSON for real Firestore health checks

## Project Structure

```
apps/
  api/          FastAPI backend (Poetry)
  admin/        Next.js admin dashboard (pnpm)
  mobile/       Flutter field app
packages/
  contracts/    Committed OpenAPI spec + generated TypeScript/Dart clients
  design-tokens/ Framework-neutral visual and motion token source
infra/
  ci/           GitHub Actions workflows
  firebase/     Firebase configuration (0.3+)
```

## Quick Start (PowerShell)

### API

```powershell
cd apps/api
poetry install
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
$env:FIREBASE_PROJECT_ID="your-firebase-project-id"
$env:FIREBASE_WEB_API_KEY="your-firebase-web-api-key" # real login test only
$env:SEED_DEMO_PASSWORD="choose-a-local-dev-password" # auth demo seed/test only
# Optional until Phase 1 provides verification/reset pages:
$env:AUTH_ACTION_URL="https://app.example.com/auth/action"
poetry run uvicorn app.main:app --reload
# http://localhost:8000/health
```

With no credentials, `/health` remains HTTP 200 and reports Firestore as
`unconfigured`. With credentials, it performs a timeout-bounded read of
`_health/ping`; the document does not need to exist.

For CI or deployment, provide the service-account JSON as base64 instead of a
filesystem path:

```powershell
$json = Get-Content -LiteralPath "C:\path\to\service-account.json" -Raw
$bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
$env:FIREBASE_CREDENTIALS_B64 = [Convert]::ToBase64String($bytes)
$env:FIREBASE_PROJECT_ID="your-firebase-project-id"
Remove-Item Env:GOOGLE_APPLICATION_CREDENTIALS -ErrorAction SilentlyContinue
```

If both credential variables are present, `FIREBASE_CREDENTIALS_B64` takes
precedence. Never commit a service-account JSON or its base64 representation.

### Admin

```powershell
cd apps/admin
pnpm install
$env:NEXT_PUBLIC_API_BASE_URL="http://localhost:8000"
pnpm dev
# http://localhost:3000
# Development-only primitive showcase: http://localhost:3000/design-system
```

### Mobile

```powershell
cd apps/mobile
flutter pub get
flutter run -d chrome --web-port 8080 --dart-define=API_BASE_URL=http://localhost:8000
# Development-only primitive showcase:
# flutter run -d chrome --web-port 8080 --route=/design-system
# Windows desktop alternative:
# flutter run -d windows --dart-define=API_BASE_URL=http://localhost:8000
```

### Seed the data foundation and optional Phase 0.5 Auth users

The seed is idempotent and creates only the permission catalog, two demo companies,
their system roles/mappings, and demo users. Set the Firebase Admin variables shown
above, then run:

```powershell
cd apps/api
poetry run python -m scripts.seed
```

Re-running the command reconciles the same deterministic document IDs without
creating duplicates. Placeholder Firebase UIDs use the `demo-` prefix and are data
foundation records only; no authentication accounts or flows are created.

To provision the same declared demo users in Firebase Authentication, migrate their
Firestore document IDs to the real Firebase UIDs, and set their custom claims:

```powershell
cd apps/api
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
$env:FIREBASE_PROJECT_ID="your-firebase-project-id"
$env:SEED_DEMO_PASSWORD="choose-a-local-dev-password"
poetry run python -m scripts.seed --with-auth-users
```

Re-running is safe and retains one user per seeded role. The migration applies only
to the seed's fixed demo-user list. For the local real-token test, also set
`FIREBASE_WEB_API_KEY`; the test signs in via Firebase Identity Toolkit using the
demo email/password. `AUTH_ACTION_URL` is optional: when unset, verification/reset
link wrappers use Firebase defaults; Phase 1 can set it when auth pages exist.

## Tooling

### API

```powershell
cd apps/api
poetry run ruff check .
poetry run mypy .
poetry run pytest
```

### Admin

```powershell
cd apps/admin
pnpm lint
pnpm test
pnpm build
```

### Mobile

```powershell
cd apps/mobile
flutter analyze
flutter test
flutter build web
```

## Shared design system

Visual and motion values are edited only in
`packages/design-tokens/tokens.json`. Regenerate committed Next.js and Flutter
bindings after a token change:

```powershell
node packages/design-tokens/scripts/generate.mjs
```

Dark mode is the default in both clients, light mode is persisted locally, and
both clients honor the operating system's reduced-animation preference. All
future screens must be composed from the shared tokens and reusable primitives;
feature-local copies of colors, spacing, typography, or motion values are not
allowed.

## API contract regeneration

FastAPI success resources are returned directly. Future list responses use
`{ "items": [...], "next_cursor": string | null }`; cursors are opaque, `null`
means no more pages, and totals are not included by default. Every failure uses
the unified `{ error, message, details?, request_id }` envelope and echoes the
request ID in `X-Request-ID`.

After changing an API route or model, export and regenerate both pinned clients:

```powershell
cd apps/api
python -m poetry run python -m scripts.export_openapi
cd ..\..\packages\contracts
corepack pnpm install --frozen-lockfile
.\scripts\gen-clients.ps1
cd ..\..
git diff --exit-code -- packages/contracts
```

Admin and mobile application code must call their typed API wrappers, which use
the generated clients. Direct feature-level `fetch`, `http`, or raw Dio calls are
not allowed.

## Phase 1.1 Firebase client login

The backend continues to use Admin credentials. Browser/mobile login uses the
Firebase client SDK and the registered web-app identifiers; do not place a service
account JSON or `FIREBASE_CREDENTIALS_B64` in either client.

For Next.js, copy `apps/admin/.env.example` to `.env.local` and set:

```powershell
cd apps\admin
Copy-Item .env.example .env.local
$env:NEXT_PUBLIC_API_BASE_URL="http://localhost:8000"
$env:NEXT_PUBLIC_FIREBASE_API_KEY="<firebase-web-api-key>"
$env:NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="<project>.firebaseapp.com"
$env:NEXT_PUBLIC_FIREBASE_PROJECT_ID="<project-id>"
$env:NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="<storage-bucket>"
$env:NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="<sender-id>"
$env:NEXT_PUBLIC_FIREBASE_APP_ID="<firebase-web-app-id>"
corepack pnpm dev
```

For Flutter web, pass the same registered web-app values at compile time:

```powershell
cd apps\mobile
flutter run -d chrome `
  --dart-define=API_BASE_URL=http://localhost:8000 `
  --dart-define=FIREBASE_API_KEY=<firebase-web-api-key> `
  --dart-define=FIREBASE_AUTH_DOMAIN=<project>.firebaseapp.com `
  --dart-define=FIREBASE_PROJECT_ID=<project-id> `
  --dart-define=FIREBASE_STORAGE_BUCKET=<storage-bucket> `
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=<sender-id> `
  --dart-define=FIREBASE_APP_ID=<firebase-web-app-id>
```

Firebase Auth persists browser sessions locally by default. On restore, both
clients mint the current ID token and resolve the authoritative identity and
permissions through `/api/v1/auth/me`. Native Android/iOS builds will add
`google-services.json` and `GoogleService-Info.plist` in their platform setup task;
those native files are intentionally not required for this web-targeted slice.
