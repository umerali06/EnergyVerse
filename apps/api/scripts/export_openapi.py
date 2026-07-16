import json
from pathlib import Path
from typing import Any

from app.main import app

REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
DEFAULT_OUTPUT = REPOSITORY_ROOT / "packages" / "contracts" / "openapi.json"


def export_openapi(output: Path = DEFAULT_OUTPUT) -> dict[str, Any]:
    schema = app.openapi()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(schema, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return schema


if __name__ == "__main__":
    written = export_openapi()
    print(f"Exported OpenAPI {written['openapi']} to {DEFAULT_OUTPUT}")
