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
