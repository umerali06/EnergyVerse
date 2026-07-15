# FEV Monorepo

Flacron EnergyVerse — enterprise multi-tenant SaaS for field inspection, maintenance, and safety workflows.

## Prerequisites

- Python 3.11+ and [Poetry](https://python-poetry.org/docs/#installation)
- Node.js 20+ and [pnpm](https://pnpm.io/installation)
- Flutter SDK 3.x ([install guide](https://docs.flutter.dev/get-started/install/windows))
- Git

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
poetry run uvicorn app.main:app --reload
# http://localhost:8000
```

### Admin

```powershell
cd apps/admin
pnpm install
pnpm dev
# http://localhost:3000
```

### Mobile

```powershell
cd apps/mobile
flutter pub get
flutter run -d chrome
# or: flutter run -d windows
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
