import asyncio

from app.db.repositories import health as health_module


def test_firestore_error_becomes_unavailable(monkeypatch) -> None:
    async def failed_read(_) -> None:
        raise RuntimeError("simulated Firestore failure")

    monkeypatch.setattr(health_module, "firebase_credentials_configured", lambda: True)
    monkeypatch.setattr(health_module, "get_firebase_initialization_error", lambda: None)
    monkeypatch.setattr(health_module, "get_firebase_app", lambda: object())
    monkeypatch.setattr(health_module.HealthRepository, "ping", failed_read)

    status = asyncio.run(health_module.get_firestore_status())

    assert status == "unavailable"
