# Extensible per the client spec's dev-note philosophy -- adding a category here
# never requires a schema migration, since `Asset.category` is a plain `str`.
ASSET_CATEGORIES: tuple[str, ...] = (
    "Pumps",
    "Compressors",
    "Pipelines",
    "Tanks",
    "Motors",
    "Valves",
    "Electrical Panels",
    "Generators",
    "Transformers",
    "Wellheads",
    "Other",
)


def is_valid_asset_category(value: str) -> bool:
    return value in ASSET_CATEGORIES
