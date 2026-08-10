from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    app_name: str = "FEV API"
    debug: bool = Field(default=False, validation_alias="FEV_DEBUG")
    firebase_project_id: str | None = None
    firebase_credentials_b64: str | None = None
    google_application_credentials: str | None = None
    firebase_web_api_key: str | None = None
    firebase_storage_bucket: str | None = None
    seed_demo_password: str | None = None
    auth_action_url: str | None = None
    # Phase 7.10 AI photo analysis (Claude vision). No key configured means
    # `/analyze` routes fail closed with a clear 503, never a silent no-op.
    anthropic_api_key: str | None = None
    ai_vision_model: str = "claude-sonnet-5"
    # Base URL the QR deep-link payload is built from (`{app_base_url}/qr/{code}`).
    # Defaults to the admin app's own local dev origin; set to the real deployed
    # origin in production so scanned codes resolve there.
    app_base_url: str = "http://localhost:3000"
    cors_origins: tuple[str, ...] = (
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:8080",
        "http://127.0.0.1:8080",
    )

    @property
    def firebase_credentials_configured(self) -> bool:
        return bool(self.firebase_credentials_b64 or self.google_application_credentials)


settings = Settings()
