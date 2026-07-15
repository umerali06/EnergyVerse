# infra/ci

GitHub Actions CI workflows live at `/.github/workflows/ci.yml` (repo root).

The workflow runs three parallel jobs on every push/PR to main:
- **api**: ruff lint + mypy type-check + pytest
- **admin**: eslint + next build
- **mobile**: flutter analyze
