from firebase_admin import auth  # type: ignore[import-untyped]

from app.auth.links import _action_settings
from app.core.settings import settings


def test_action_settings_use_firebase_default_when_unconfigured(monkeypatch) -> None:
    monkeypatch.setattr(settings, "auth_action_url", None)
    assert _action_settings(None) is None


def test_action_settings_use_optional_environment_url(monkeypatch) -> None:
    monkeypatch.setattr(settings, "auth_action_url", "https://app.example.test/auth/action")
    result = _action_settings(None)
    assert result is not None
    assert result.url == "https://app.example.test/auth/action"


def test_explicit_action_settings_take_precedence(monkeypatch) -> None:
    monkeypatch.setattr(settings, "auth_action_url", "https://environment.example.test")
    supplied = auth.ActionCodeSettings(url="https://explicit.example.test")
    assert _action_settings(supplied) is supplied
