from datetime import UTC, datetime

from pydantic import BaseModel, ConfigDict, Field


class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class CompanyScope(StrictModel):
    company_id: str = Field(min_length=1)


class AdminScope(StrictModel):
    """Verified cross-tenant trust context for platform administration (D-006/D-030).

    Constructed ONLY by `app.admin.dependencies.get_admin_scope`, which requires a
    `CurrentUser` that has already passed `require_permission("platform.admin")` --
    never from a client-supplied field. Carries no target company_id; every
    `/api/v1/platform/*` route takes that from its own path parameter.
    """

    acting_uid: str = Field(min_length=1)
    acting_company_id: str = Field(min_length=1)


class TenantDoc(StrictModel):
    company_id: str
    created_at: datetime
    updated_at: datetime
    created_by: str


class GlobalDoc(StrictModel):
    created_at: datetime
    updated_at: datetime


class AppendOnlyDoc(StrictModel):
    created_at: datetime
    actor_uid: str


def utc_now() -> datetime:
    return datetime.now(UTC)


def global_creation_fields(now: datetime | None = None) -> dict[str, object]:
    timestamp = now or utc_now()
    return {"created_at": timestamp, "updated_at": timestamp}


def tenant_creation_fields(
    scope: CompanyScope,
    actor_uid: str,
    now: datetime | None = None,
) -> dict[str, object]:
    return {
        "company_id": scope.company_id,
        "created_by": actor_uid,
        **global_creation_fields(now),
    }
