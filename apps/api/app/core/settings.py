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
    aws_region: str | None = None
    aws_access_key_id: str | None = None
    aws_secret_access_key: str | None = None
    ses_from_email: str | None = None
    ses_from_name: str | None = None
    ses_reply_to: str | None = None
    cors_origins: tuple[str, ...] = (
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:8080",
        "http://127.0.0.1:8080",
    )

    @property
    def firebase_credentials_configured(self) -> bool:
        return bool(self.firebase_credentials_b64 or self.google_application_credentials)

    @property
    def ses_configured(self) -> bool:
        return bool(
            self.aws_access_key_id and self.aws_secret_access_key and self.ses_from_email
        )


settings = Settings()
