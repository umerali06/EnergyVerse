from google.cloud.firestore_v1.async_client import AsyncClient

from app.audit.types import AuditSink
from app.db.firestore import get_firestore_client
from app.db.repositories.base import FIRESTORE_OPERATION_TIMEOUT_SECONDS
from app.models.base import CompanyScope, global_creation_fields, utc_now
from app.models.entities import Company, CompanyCreate, CompanyUpdate, without_none


class CompanyRepository:
    collection_name = "companies"

    def __init__(
        self,
        client: AsyncClient | None = None,
        audit: AuditSink | None = None,
    ) -> None:
        self._client = client or get_firestore_client()
        self._audit = audit

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
        company = Company.model_validate(
            {
                **current.model_dump(),
                **without_none(payload.model_dump()),
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
