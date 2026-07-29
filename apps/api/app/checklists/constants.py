from app.assets.constants import ASSET_CATEGORIES

# "Generic" applies to any asset category; the rest mirror the asset category
# catalog so a template can be scoped to exactly the assets it was written for.
CHECKLIST_TEMPLATE_CATEGORIES: tuple[str, ...] = ("Generic", *ASSET_CATEGORIES)

CHECKLIST_ITEM_TYPES: tuple[str, ...] = ("boolean", "numeric", "text", "select")


def is_valid_checklist_template_category(value: str) -> bool:
    return value in CHECKLIST_TEMPLATE_CATEGORIES
