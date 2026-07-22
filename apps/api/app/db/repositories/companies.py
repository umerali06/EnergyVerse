from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.firestore import get_firestore_client
from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS
from app.models.base import CompanyScope, global_creation_fields, utc_now
from app.models.entities import Company, CompanyCreate, CompanyUpdate


class CompanyRepository:
    collection_name = "companies"

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        self._client = client or get_firestore_client()
        self._audit = audit

    async def list_all(self) -> list[Company]:
        """Unscoped read of every tenant -- platform administration only (D-030).

        Modeled on `PermissionRepository.list()`, the only other collection this
        codebase reads in full with no `company_id` filter: `companies` is itself
        the tenant-root collection, so there is no scope to filter by.
        """
        companies = []
        async for snapshot in self._client.collection(self.collection_name).stream(
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS
        ):
            data = snapshot.to_dict()
            if data is not None:
                companies.append(Company.model_validate(data))
        return companies

    async def get(self, scope: CompanyScope) -> Company | None:
        snapshot = (
            await self._client.collection(self.collection_name)
            .document(scope.company_id)
            .get(timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS, retry=None)
        )
        if not snapshot.exists:
            return None
        data = snapshot.to_dict()
        if data is None or data.get("id") != scope.company_id:
            return None
        return Company.model_validate(data)

    async def create(self, payload: CompanyCreate, actor_uid: str) -> Company:
        scope = CompanyScope(company_id=payload.id)
        reference = self._client.collection(self.collection_name).document(payload.id)
        if (
            await reference.get(
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        ).exists:
            raise ValueError("company already exists")
        company = Company.model_validate(
            {
                **payload.model_dump(),
                **global_creation_fields(),
                "created_by": actor_uid,
            }
        )
        await reference.set(
            company.model_dump(),
            timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
            retry=None,
        )
        if self._audit is not None:
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action="company.created",
                target_type="company",
                target_id=company.id,
                metadata={"after": company.model_dump(mode="json")},
            )
        return company

    async def update(
        self,
        scope: CompanyScope,
        payload: CompanyUpdate,
        actor_uid: str,
    ) -> Company:
        current = await self.get(scope)
        if current is None:
            raise LookupError("company not found")
        # exclude_unset (not without_none) so an explicitly-null field (e.g.
        # clearing industry/contact info) actually clears it, while a field
        # absent from the request stays untouched -- the two are otherwise
        # indistinguishable once collapsed to None.
        company = Company.model_validate(
            {
                **current.model_dump(),
                **payload.model_dump(exclude_unset=True),
                "updated_at": utc_now(),
            }
        )
        await (
            self._client.collection(self.collection_name)
            .document(scope.company_id)
            .set(
                company.model_dump(),
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        )
        if self._audit is not None:
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action="company.updated",
                target_type="company",
                target_id=company.id,
                metadata={
                    "before": current.model_dump(mode="json"),
                    "after": company.model_dump(mode="json"),
                },
            )
        return company

    async def set_logo_path(
        self,
        scope: CompanyScope,
        logo_path: str | None,
        actor_uid: str,
    ) -> Company:
        current = await self.get(scope)
        if current is None:
            raise LookupError("company not found")
        company = Company.model_validate(
            {
                **current.model_dump(),
                "logo_path": logo_path,
                "updated_at": utc_now(),
            }
        )
        await (
            self._client.collection(self.collection_name)
            .document(scope.company_id)
            .set(
                company.model_dump(),
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        )
        if self._audit is not None:
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action="company.logo_updated" if logo_path else "company.logo_removed",
                target_type="company",
                target_id=company.id,
                metadata={
                    "before": current.model_dump(mode="json"),
                    "after": company.model_dump(mode="json"),
                },
            )
        return company

    async def delete(self, scope: CompanyScope, actor_uid: str) -> None:
        current = await self.get(scope)
        if current is None:
            raise LookupError("company not found")
        await (
            self._client.collection(self.collection_name)
            .document(scope.company_id)
            .delete(
                timeout=FIRESTORE_OPERATION_TIMEOUT_SECONDS,
                retry=None,
            )
        )
        if self._audit is not None:
            await self._audit.audit(
                scope,
                actor_uid=actor_uid,
                action="company.deleted",
                target_type="company",
                target_id=current.id,
                metadata={"before": current.model_dump(mode="json")},
            )
