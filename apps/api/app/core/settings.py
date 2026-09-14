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
    # Transactional email (AWS SES). Unset in local/CI environments, where the
    # notification service falls back to logging the message rather than
    # failing the action that triggered it.
    aws_region: str | None = None
    aws_access_key_id: str | None = None
    aws_secret_access_key: str | None = None
    ses_from_email: str | None = None
    ses_from_name: str = "Flacron Energy"
    ses_reply_to: str | None = None
    # Push delivery uses the Firebase Admin SDK's own credentials, so it needs
    # no separate key -- this only gates it off for local runs.
    push_notifications_enabled: bool = True
    cors_origins: tuple[str, ...] = (
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:8080",
        "http://127.0.0.1:8080",
    )
    # Allow all localhost/127.0.0.1 origins in dev (Flutter web uses random ports).
    # In production, set CORS_ALLOW_ALL_LOCALHOST=false and rely on cors_origins above.
    cors_allow_all_localhost: bool = Field(
        default=True, validation_alias="CORS_ALLOW_ALL_LOCALHOST"
    )
    # Phase 13 subscriptions. No secret key configured means every billing
    # route fails closed with a 503 rather than silently pretending to charge.
    stripe_secret_key: str | None = None
    stripe_publishable_key: str | None = None
    # Verifies the signature on every inbound webhook. Absent means the webhook
    # route rejects everything -- an unverified billing event must never be
    # trusted, since it can grant a paid tier.
    stripe_webhook_secret: str | None = None
    # Where Stripe returns the browser after checkout. Points at the admin app,
    # which reconciles and then sends the new admin into the dashboard.
    stripe_success_path: str = "/signup/complete"
    # Cancelling returns to the plan picker, not to registration: by this point
    # the account already exists, and `/signup` would only bounce off its
    # already-signed-in guard.
    stripe_cancel_path: str = "/signup/plan"

    @property
    def stripe_configured(self) -> bool:
        return bool(self.stripe_secret_key)

    @property
    def ses_configured(self) -> bool:
        return bool(self.aws_access_key_id and self.aws_secret_access_key and self.ses_from_email)

    @property
    def firebase_credentials_configured(self) -> bool:
        return bool(self.firebase_credentials_b64 or self.google_application_credentials)


settings = Settings()
