import asyncio

from app.db import firestore as firestore_module


def test_firestore_error_becomes_unavailable(monkeypatch) -> None:
    async def failed_read() -> None:
        raise RuntimeError("simulated Firestore failure")

    monkeypatch.setattr(firestore_module, "firebase_credentials_configured", lambda: True)
    monkeypatch.setattr(firestore_module, "get_firebase_initialization_error", lambda: None)
    monkeypatch.setattr(firestore_module, "get_firebase_app", lambda: object())
    monkeypatch.setattr(firestore_module, "_read_health_document", failed_read)

    status = asyncio.run(firestore_module.get_firestore_status())

    assert status == "unavailable"
