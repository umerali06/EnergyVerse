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
    seed_demo_password: str | None = None
    auth_action_url: str | None = None
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
