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
  contracts/    OpenAPI specs + generated clients (0.8+)
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
```

### Mobile

```powershell
cd apps/mobile
flutter pub get
flutter run -d chrome --web-port 8080 --dart-define=API_BASE_URL=http://localhost:8000
# Windows desktop alternative:
# flutter run -d windows --dart-define=API_BASE_URL=http://localhost:8000
```

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
pnpm build
```

### Mobile

```powershell
cd apps/mobile
flutter analyze
```
