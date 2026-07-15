from datetime import UTC, datetime

from pydantic import BaseModel, ConfigDict, Field


class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class CompanyScope(StrictModel):
    company_id: str = Field(min_length=1)


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
