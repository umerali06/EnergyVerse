import base64
import binascii
from uuid import uuid4

from app.audit.service import AuditService
from app.checklists.constants import is_valid_checklist_template_category
from app.db.firestore import get_firestore_client
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.checklist_templates import ChecklistTemplateRepository
from app.models.api import (
    ChecklistTemplateDetail,
    ChecklistTemplateItemInput,
    ChecklistTemplateListItem,
    ChecklistTemplateListPage,
    CreateChecklistTemplateRequest,
    UpdateChecklistTemplateRequest,
)
from app.models.base import CompanyScope
from app.models.entities import ChecklistTemplate, ChecklistTemplateCreate, ChecklistTemplateItem


class ChecklistTemplateServiceError(Exception):
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


def _encode_cursor(template_id: str) -> str:
    return base64.urlsafe_b64encode(template_id.encode()).decode()


def _decode_cursor(cursor: str) -> str:
    try:
        return base64.urlsafe_b64decode(cursor.encode()).decode()
    except (ValueError, binascii.Error, UnicodeDecodeError) as error:
        raise ChecklistTemplateServiceError(422, "invalid_cursor", "Cursor is not valid") from error


def _to_list_item(template: ChecklistTemplate) -> ChecklistTemplateListItem:
    return ChecklistTemplateListItem(
        id=template.id,
        name=template.name,
        category=template.category,
        version=template.version,
        created_at=template.created_at,
        updated_at=template.updated_at,
    )


def _to_detail(template: ChecklistTemplate) -> ChecklistTemplateDetail:
    return ChecklistTemplateDetail(
        **_to_list_item(template).model_dump(),
        description=template.description,
        items=[item.model_dump() for item in template.items],
    )


class ChecklistTemplateService:
    def __init__(self, *, templates: ChecklistTemplateRepository) -> None:
        self._templates = templates

    async def _active_template(self, scope: CompanyScope, template_id: str) -> ChecklistTemplate:
        template = await self._templates.get(scope, template_id)
        if template is None or template.deleted_at is not None:
            raise ChecklistTemplateServiceError(
                404, "checklist_template_not_found", "Checklist template was not found"
            )
        return template

    def _validate_items(
        self, items: list[ChecklistTemplateItemInput]
    ) -> list[ChecklistTemplateItem]:
        seen: set[str] = set()
        validated: list[ChecklistTemplateItem] = []
        for item in items:
            item_id = item.id or f"item_{uuid4().hex[:12]}"
            if item_id in seen:
                raise ChecklistTemplateServiceError(
                    422,
                    "duplicate_item_id",
                    "Checklist items must have unique ids",
                    {"id": item_id},
                )
            seen.add(item_id)
            if item.item_type == "select" and not item.options:
                raise ChecklistTemplateServiceError(
                    422,
                    "select_options_required",
                    "select items require a non-empty options list",
                    {"id": item_id},
                )
            if item.item_type != "select" and item.options:
                raise ChecklistTemplateServiceError(
                    422,
                    "options_not_allowed",
                    "options is only valid for select items",
                    {"id": item_id},
                )
            validated.append(
                ChecklistTemplateItem(
                    id=item_id,
                    label=item.label,
                    item_type=item.item_type,
                    required=item.required,
                    options=item.options,
                    help_text=item.help_text,
                )
            )
        return validated

    def _validate_category(self, category: str) -> None:
        if not is_valid_checklist_template_category(category):
            raise ChecklistTemplateServiceError(
                422, "invalid_category", "Category is not recognized", {"category": category}
            )

    async def list_templates(
        self,
        scope: CompanyScope,
        *,
        category: str | None,
        cursor: str | None,
        limit: int,
    ) -> ChecklistTemplateListPage:
        all_templates = await self._templates.list(scope)
        templates = [template for template in all_templates if template.deleted_at is None]
        if category:
            templates = [template for template in templates if template.category == category]
        templates.sort(key=lambda template: (template.name.casefold(), template.id))

        if cursor:
            last_id = _decode_cursor(cursor)
            ids = [template.id for template in templates]
            try:
                start = ids.index(last_id) + 1
            except ValueError:
                start = len(templates)
            templates = templates[start:]

        page = templates[:limit]
        items = [_to_list_item(template) for template in page]
        next_cursor = _encode_cursor(page[-1].id) if len(templates) > limit and page else None
        return ChecklistTemplateListPage(items=items, next_cursor=next_cursor)

    async def get_template(self, scope: CompanyScope, template_id: str) -> ChecklistTemplateDetail:
        template = await self._active_template(scope, template_id)
        return _to_detail(template)

    async def create_template(
        self,
        scope: CompanyScope,
        request: CreateChecklistTemplateRequest,
        actor_uid: str,
    ) -> ChecklistTemplateDetail:
        self._validate_category(request.category)
        items = self._validate_items(request.items)
        template = await self._templates.create(
            scope,
            ChecklistTemplateCreate(
                id=f"checklist_template_{uuid4().hex}",
                name=" ".join(request.name.split()),
                category=request.category,
                description=request.description,
                items=items,
            ),
            actor_uid,
        )
        return _to_detail(template)

    async def update_template(
        self,
        scope: CompanyScope,
        template_id: str,
        request: UpdateChecklistTemplateRequest,
        actor_uid: str,
    ) -> ChecklistTemplateDetail:
        await self._active_template(scope, template_id)
        provided = request.model_dump(exclude_unset=True)
        if "category" in provided and request.category is not None:
            self._validate_category(request.category)
        if "items" in provided and request.items is not None:
            provided["items"] = [item.model_dump() for item in self._validate_items(request.items)]
        if "name" in provided and request.name is not None:
            provided["name"] = " ".join(request.name.split())
        template = await self._templates.update(scope, template_id, provided, actor_uid)
        return _to_detail(template)

    async def delete_template(self, scope: CompanyScope, template_id: str, actor_uid: str) -> None:
        await self._active_template(scope, template_id)
        await self._templates.soft_delete(scope, template_id, actor_uid)


def get_checklist_template_service() -> ChecklistTemplateService:
    client = get_firestore_client()
    audit = AuditService(AuditLogRepository(client))
    return ChecklistTemplateService(templates=ChecklistTemplateRepository(client, audit))
