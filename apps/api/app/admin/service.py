import asyncio
import base64
import binascii
from datetime import timedelta

from app.audit.service import AuditService
from app.audit.types import AuditSink
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.api import (
    PlatformCompanyDetail,
    PlatformCompanyPage,
    PlatformCompanySummary,
    PlatformStats,
)
from app.models.base import AdminScope, CompanyScope, utc_now
from app.models.entities import Company, CompanyUpdate

# Reserved pseudo-tenant id for the platform-wide audit trail (D-030). Nothing in
# `companies` is ever created with this id; `AuditLogRepository` never dereferences
# `companies`, so this is safe with zero repository changes -- confirmed by reading
# `AuditLogRepository.append`, which only checks `event.company_id == scope.company_id`.
PLATFORM_AUDIT_COMPANY_ID = "__platform__"

RECENT_SIGNUP_WINDOW_DAYS = 30


class AdminServiceError(Exception):
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


def _encode_cursor(company_id: str) -> str:
    return base64.urlsafe_b64encode(company_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise AdminServiceError(422, "invalid_cursor", "Cursor is not valid") from error


class AdminCompanyService:
    def __init__(
        self,
        *,
        companies: CompanyRepository,
        users: UserRepository,
        roles: RoleRepository,
        audit: AuditSink,
    ) -> None:
        self._companies = companies
        self._users = users
        self._roles = roles
        self._audit = audit

    def _to_summary(self, company: Company, users_total: int) -> PlatformCompanySummary:
        return PlatformCompanySummary(
            id=company.id,
            name=company.name,
            status=company.status,
            subscription_tier=company.subscription_tier,
            users_total=users_total,
            created_at=company.created_at,
        )

    async def _to_detail(self, company: Company) -> PlatformCompanyDetail:
        scope = CompanyScope(company_id=company.id)
        users, roles = await asyncio.gather(self._users.list(scope), self._roles.list(scope))
        return PlatformCompanyDetail(
            id=company.id,
            name=company.name,
            status=company.status,
            subscription_tier=company.subscription_tier,
            users_total=len(users),
            created_at=company.created_at,
            industry=company.industry,
            contact_email=company.contact_email,
            roles_total=len(roles),
        )

    async def _require_company(self, company_id: str) -> Company:
        company = await self._companies.get(CompanyScope(company_id=company_id))
        if company is None:
            raise AdminServiceError(404, "company_not_found", "Company was not found")
        return company

    async def list_companies(self, *, cursor: str | None, limit: int) -> PlatformCompanyPage:
        companies = await self._companies.list_all()
        companies.sort(key=lambda company: (company.created_at, company.id), reverse=True)

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [company.id for company in companies]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(companies)
            companies = companies[start:]

        page = companies[:limit]
        counts = await asyncio.gather(
            *(self._users.list(CompanyScope(company_id=company.id)) for company in page)
        )
        items = [
            self._to_summary(company, len(users))
            for company, users in zip(page, counts, strict=True)
        ]
        next_cursor = (
            _encode_cursor(page[-1].id) if len(companies) > limit and page else None
        )
        return PlatformCompanyPage(items=items, next_cursor=next_cursor)

    async def get_company(self, company_id: str) -> PlatformCompanyDetail:
        company = await self._require_company(company_id)
        return await self._to_detail(company)

    async def _dual_audit(
        self,
        admin_scope: AdminScope,
        *,
        company_id: str,
        target_action: str,
        before: Company,
        after: Company,
    ) -> None:
        # 1) The target tenant's own trail -- so that tenant sees the external action.
        await self._audit.audit(
            CompanyScope(company_id=company_id),
            actor_uid=admin_scope.acting_uid,
            action=target_action,
            target_type="company",
            target_id=company_id,
            metadata={
                "before": before.model_dump(mode="json"),
                "after": after.model_dump(mode="json"),
                "cross_tenant": True,
                "acting_company_id": admin_scope.acting_company_id,
            },
        )
        # 2) The platform-wide trail -- queryable via the same AuditLogRepository
        # methods with zero new query code, since it's just another CompanyScope.
        await self._audit.audit(
            CompanyScope(company_id=PLATFORM_AUDIT_COMPANY_ID),
            actor_uid=admin_scope.acting_uid,
            action=f"platform.{target_action}",
            target_type="company",
            target_id=company_id,
            metadata={
                "before": before.model_dump(mode="json"),
                "after": after.model_dump(mode="json"),
            },
        )

    async def update_status(
        self,
        admin_scope: AdminScope,
        company_id: str,
        new_status: str,
    ) -> PlatformCompanyDetail:
        before = await self._require_company(company_id)
        if before.status == new_status:
            raise AdminServiceError(
                409,
                "status_unchanged",
                f"Company is already {new_status}",
            )
        scope = CompanyScope(company_id=company_id)
        after = await self._companies.update(
            scope, CompanyUpdate(status=new_status), admin_scope.acting_uid
        )
        target_action = "company.suspended" if new_status == "suspended" else "company.reactivated"
        await self._dual_audit(
            admin_scope,
            company_id=company_id,
            target_action=target_action,
            before=before,
            after=after,
        )
        return await self._to_detail(after)

    async def update_subscription_tier(
        self,
        admin_scope: AdminScope,
        company_id: str,
        subscription_tier: str,
    ) -> PlatformCompanyDetail:
        before = await self._require_company(company_id)
        scope = CompanyScope(company_id=company_id)
        after = await self._companies.update(
            scope, CompanyUpdate(subscription_tier=subscription_tier), admin_scope.acting_uid
        )
        await self._dual_audit(
            admin_scope,
            company_id=company_id,
            target_action="company.subscription_tier_changed",
            before=before,
            after=after,
        )
        return await self._to_detail(after)

    async def get_stats(self) -> PlatformStats:
        companies = await self._companies.list_all()
        counts = await asyncio.gather(
            *(self._users.list(CompanyScope(company_id=company.id)) for company in companies)
        )
        now = utc_now()
        window_start = now - timedelta(days=RECENT_SIGNUP_WINDOW_DAYS)
        return PlatformStats(
            total_companies=len(companies),
            total_users=sum(len(users) for users in counts),
            active_tenants=sum(1 for company in companies if company.status == "active"),
            recent_signups=sum(1 for company in companies if company.created_at >= window_start),
            window_days=RECENT_SIGNUP_WINDOW_DAYS,
        )


def get_admin_company_service() -> AdminCompanyService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return AdminCompanyService(
        companies=CompanyRepository(client, audit=None),
        users=UserRepository(client),
        roles=RoleRepository(client),
        audit=audit,
    )
