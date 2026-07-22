import logging

from fastapi import UploadFile

from app.audit.service import AuditService
from app.audit.types import AuditSink
from app.company.constants import is_valid_industry, is_valid_locale, is_valid_timezone
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import CompanyProfile, UpdateCompanyRequest
from app.models.base import CompanyScope
from app.models.entities import Company, CompanyUpdate
from app.storage.service import CompanyLogoStorage, get_company_logo_storage

logger = logging.getLogger(__name__)

MAX_LOGO_BYTES = 5 * 1024 * 1024
ALLOWED_LOGO_CONTENT_TYPES = frozenset({"image/png", "image/jpeg", "image/webp"})


class CompanyProfileError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.code = code
        self.message = message
        self.details = details


class CompanyProfileService:
    def __init__(
        self,
        *,
        companies: CompanyRepository,
        users: UserRepository,
        roles: RoleRepository,
        storage: CompanyLogoStorage,
        audit: AuditSink,
    ) -> None:
        self._companies = companies
        self._users = users
        self._roles = roles
        self._storage = storage
        self._audit = audit

    async def _require_company(self, scope: CompanyScope) -> Company:
        company = await self._companies.get(scope)
        if company is None:
            raise CompanyProfileError(404, "company_not_found", "Company was not found")
        return company

    async def _to_profile(self, company: Company, scope: CompanyScope) -> CompanyProfile:
        users = await self._users.list(scope)
        roles = await self._roles.list(scope)
        logo_url: str | None = None
        if company.logo_path:
            try:
                logo_url = self._storage.signed_url_for(company.logo_path)
            except Exception:
                logger.exception(
                    "Failed to generate signed URL for company %s logo", company.id
                )
        return CompanyProfile(
            id=company.id,
            name=company.name,
            industry=company.industry,
            timezone=company.timezone,
            locale=company.locale,
            contact_email=company.contact_email,
            contact_phone=company.contact_phone,
            subscription_tier=company.subscription_tier,
            logo_url=logo_url,
            created_at=company.created_at,
            users_total=len(users),
            roles_total=len(roles),
        )

    async def get_profile(self, scope: CompanyScope) -> CompanyProfile:
        company = await self._require_company(scope)
        return await self._to_profile(company, scope)

    def _validate_request(self, request: UpdateCompanyRequest) -> None:
        # `model_fields_set` (not "is not None") distinguishes "field absent
        # from the request" from "field explicitly sent as null" -- only the
        # latter needs a clear-vs-required check.
        provided = request.model_fields_set
        if "name" in provided and request.name is None:
            raise CompanyProfileError(422, "invalid_name", "Company name cannot be cleared")
        if "industry" in provided and request.industry is not None:
            if not is_valid_industry(request.industry):
                raise CompanyProfileError(
                    422,
                    "invalid_industry",
                    "Industry is not recognized",
                    {"industry": request.industry},
                )
        if "timezone" in provided:
            if request.timezone is None:
                raise CompanyProfileError(422, "invalid_timezone", "Timezone cannot be cleared")
            if not is_valid_timezone(request.timezone):
                raise CompanyProfileError(
                    422,
                    "invalid_timezone",
                    "Timezone is not a recognized IANA zone",
                    {"timezone": request.timezone},
                )
        if "locale" in provided:
            if request.locale is None:
                raise CompanyProfileError(422, "invalid_locale", "Locale cannot be cleared")
            if not is_valid_locale(request.locale):
                raise CompanyProfileError(
                    422,
                    "invalid_locale",
                    "Locale is not a recognized BCP-47 tag",
                    {"locale": request.locale},
                )

    async def update_profile(
        self,
        scope: CompanyScope,
        request: UpdateCompanyRequest,
        actor_uid: str,
    ) -> CompanyProfile:
        await self._require_company(scope)
        self._validate_request(request)
        provided = request.model_dump(exclude_unset=True)
        if provided.get("name") is not None:
            provided["name"] = " ".join(provided["name"].split())
        update = CompanyUpdate(**provided)
        company = await self._companies.update(scope, update, actor_uid)
        return await self._to_profile(company, scope)

    async def upload_logo(
        self,
        scope: CompanyScope,
        file: UploadFile,
        actor_uid: str,
    ) -> CompanyProfile:
        await self._require_company(scope)
        content_type = file.content_type or ""
        if content_type not in ALLOWED_LOGO_CONTENT_TYPES:
            raise CompanyProfileError(
                422,
                "invalid_logo_type",
                "Logo must be PNG, JPEG, or WEBP",
                {"content_type": content_type},
            )
        data = await file.read()
        if not data:
            raise CompanyProfileError(422, "invalid_logo_type", "Logo file is empty")
        if len(data) > MAX_LOGO_BYTES:
            raise CompanyProfileError(
                422,
                "logo_too_large",
                "Logo must be 5 MB or smaller",
                {"max_bytes": MAX_LOGO_BYTES},
            )
        path = self._storage.upload(scope.company_id, data, content_type)
        updated = await self._companies.set_logo_path(scope, path, actor_uid)
        return await self._to_profile(updated, scope)

    async def remove_logo(self, scope: CompanyScope, actor_uid: str) -> CompanyProfile:
        company = await self._require_company(scope)
        if company.logo_path:
            self._storage.delete(company.logo_path)
        updated = await self._companies.set_logo_path(scope, None, actor_uid)
        return await self._to_profile(updated, scope)


def get_company_profile_service() -> CompanyProfileService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return CompanyProfileService(
        companies=CompanyRepository(client, audit),
        users=UserRepository(client),
        roles=RoleRepository(client),
        storage=get_company_logo_storage(),
        audit=audit,
    )
