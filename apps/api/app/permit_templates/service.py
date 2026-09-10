import base64
import binascii
from uuid import uuid4

from app.audit.service import AuditService
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.permit_templates import (
    PermitTemplateRepository,
    PermitTemplateVersionConflictError,
)
from app.db.repositories.roles import RoleRepository
from app.models.api import (
    CreatePermitTemplateRequest,
    PermitApprovalTemplateStepInput,
    PermitApprovalTemplateStepResponse,
    PermitChecklistTemplateItemInput,
    PermitChecklistTemplateItemResponse,
    PermitTemplateDeleted,
    PermitTemplateDetail,
    PermitTemplateListItem,
    PermitTemplateListPage,
    UpdatePermitTemplateRequest,
)
from app.models.base import CompanyScope
from app.models.entities import (
    PermitApprovalTemplateStep,
    PermitChecklistTemplateItem,
    PermitTemplate,
    PermitTemplateCreate,
)


class PermitTemplateServiceError(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict[str, object] | None = None,
    ) -> None:
        super().__init__(message)
        self.status_code, self.code, self.message, self.details = (
            status_code,
            code,
            message,
            details,
        )


def _encode_cursor(template_id: str) -> str:
    return base64.urlsafe_b64encode(template_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise PermitTemplateServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _item(template: PermitTemplate) -> PermitTemplateListItem:
    return PermitTemplateListItem(
        id=template.id,
        name=template.name,
        permit_type=template.permit_type,
        version=template.version,
        created_at=template.created_at,
        updated_at=template.updated_at,
    )


def _detail(template: PermitTemplate) -> PermitTemplateDetail:
    return PermitTemplateDetail(
        **_item(template).model_dump(),
        description=template.description,
        checklist_items=[
            PermitChecklistTemplateItemResponse(**row.model_dump())
            for row in template.checklist_items
        ],
        approval_steps=[
            PermitApprovalTemplateStepResponse(**row.model_dump())
            for row in template.approval_steps
        ],
    )


class PermitTemplateService:
    def __init__(self, templates: PermitTemplateRepository, roles: RoleRepository) -> None:
        self._templates = templates
        self._roles = roles

    async def _active(self, scope: CompanyScope, template_id: str) -> PermitTemplate:
        template = await self._templates.get(scope, template_id)
        if template is None or template.deleted_at is not None:
            raise PermitTemplateServiceError(
                404, "permit_template_not_found", "Permit template was not found"
            )
        return template

    @staticmethod
    def _checklist(
        items: list[PermitChecklistTemplateItemInput],
    ) -> list[PermitChecklistTemplateItem]:
        seen: set[str] = set()
        result: list[PermitChecklistTemplateItem] = []
        for row in items:
            item_id = row.id or f"item_{uuid4().hex[:12]}"
            if item_id in seen:
                raise PermitTemplateServiceError(
                    422, "duplicate_checklist_item_id", "Checklist item IDs must be unique"
                )
            seen.add(item_id)
            result.append(PermitChecklistTemplateItem(id=item_id, **row.model_dump(exclude={"id"})))
        return result

    async def _approvals(
        self, scope: CompanyScope, steps: list[PermitApprovalTemplateStepInput]
    ) -> list[PermitApprovalTemplateStep]:
        seen_ids: set[str] = set()
        result: list[PermitApprovalTemplateStep] = []
        for row in steps:
            step_id = row.id or f"step_{uuid4().hex[:12]}"
            if step_id in seen_ids:
                raise PermitTemplateServiceError(
                    422, "duplicate_approval_step_id", "Approval step IDs must be unique"
                )
            seen_ids.add(step_id)
            role = await self._roles.get(scope, row.approver_role_id)
            if role is None:
                raise PermitTemplateServiceError(
                    422,
                    "approver_role_not_found",
                    "Approval role was not found in this company",
                    {"role_id": row.approver_role_id},
                )
            result.append(
                PermitApprovalTemplateStep(
                    id=step_id,
                    label=row.label,
                    approver_role_id=role.id,
                    required=row.required,
                )
            )
        return result

    async def list(
        self,
        scope: CompanyScope,
        permit_type: str | None,
        cursor: str | None,
        limit: int,
    ) -> PermitTemplateListPage:
        templates = [row for row in await self._templates.list(scope) if row.deleted_at is None]
        if permit_type:
            templates = [row for row in templates if row.permit_type == permit_type]
        templates.sort(key=lambda row: (row.name.casefold(), row.id))
        if cursor:
            cursor_id = _decode_cursor(cursor)
            ids = [row.id for row in templates]
            templates = templates[ids.index(cursor_id) + 1 :] if cursor_id in ids else []
        page = templates[:limit]
        return PermitTemplateListPage(
            items=[_item(row) for row in page],
            next_cursor=_encode_cursor(page[-1].id) if len(templates) > limit and page else None,
        )

    async def get(self, scope: CompanyScope, template_id: str) -> PermitTemplateDetail:
        return _detail(await self._active(scope, template_id))

    async def create(
        self, scope: CompanyScope, request: CreatePermitTemplateRequest, actor_uid: str
    ) -> PermitTemplateDetail:
        template = await self._templates.create(
            scope,
            PermitTemplateCreate(
                id=f"permit_template_{uuid4().hex}",
                name=" ".join(request.name.split()),
                permit_type=request.permit_type,
                description=request.description,
                checklist_items=self._checklist(request.checklist_items),
                approval_steps=await self._approvals(scope, request.approval_steps),
            ),
            actor_uid,
        )
        return _detail(template)

    async def update(
        self,
        scope: CompanyScope,
        template_id: str,
        request: UpdatePermitTemplateRequest,
        actor_uid: str,
    ) -> PermitTemplateDetail:
        await self._active(scope, template_id)
        changes = request.model_dump(exclude_unset=True)
        changes.pop("expected_version")
        if request.name is not None:
            changes["name"] = " ".join(request.name.split())
        if request.checklist_items is not None:
            changes["checklist_items"] = [
                row.model_dump() for row in self._checklist(request.checklist_items)
            ]
        if request.approval_steps is not None:
            changes["approval_steps"] = [
                row.model_dump() for row in await self._approvals(scope, request.approval_steps)
            ]
        try:
            updated = await self._templates.update(
                scope, template_id, changes, actor_uid, request.expected_version
            )
        except PermitTemplateVersionConflictError as error:
            raise PermitTemplateServiceError(
                409,
                "permit_template_version_conflict",
                "Permit template changed since it was loaded",
                {"current_version": error.current.version},
            ) from error
        return _detail(updated)

    async def delete(
        self, scope: CompanyScope, template_id: str, actor_uid: str
    ) -> PermitTemplateDeleted:
        await self._active(scope, template_id)
        await self._templates.soft_delete(scope, template_id, actor_uid)
        return PermitTemplateDeleted(id=template_id)


def get_permit_template_service() -> PermitTemplateService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return PermitTemplateService(
        PermitTemplateRepository(client, audit), RoleRepository(client, audit)
    )
