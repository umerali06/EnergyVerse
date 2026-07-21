import json
from pathlib import Path

from scripts.export_openapi import export_openapi

EXPECTED_OPERATIONS = {
    "get_dashboard_summary",
    "get_dashboard_activity",
    "get_dashboard_activity_series",
    "get_root",
    "get_health",
    "get_current_user",
    "register_company_admin",
    "rbac_demo_single_permission",
    "rbac_demo_all_permissions",
    "rbac_demo_any_permission",
    "list_users",
    "get_user",
    "invite_user",
    "update_user",
    "set_user_status",
    "list_roles",
}


def test_export_openapi_contains_stable_operation_ids(tmp_path: Path) -> None:
    output = tmp_path / "openapi.json"
    schema = export_openapi(output)
    written = json.loads(output.read_text(encoding="utf-8"))

    assert written == schema
    operation_ids = {
        operation["operationId"]
        for path in written["paths"].values()
        for operation in path.values()
        if isinstance(operation, dict) and "operationId" in operation
    }
    assert operation_ids == EXPECTED_OPERATIONS
    assert written["openapi"].startswith("3.")
    assert "ErrorEnvelope" in written["components"]["schemas"]


def test_every_operation_has_tags_and_typed_success_response(tmp_path: Path) -> None:
    schema = export_openapi(tmp_path / "openapi.json")
    for path in schema["paths"].values():
        for operation in path.values():
            if not isinstance(operation, dict) or "operationId" not in operation:
                continue
            assert operation["tags"]
            success_code = next(
                code for code in operation["responses"] if str(code).startswith("2")
            )
            success = operation["responses"][success_code]["content"]["application/json"]
            assert "$ref" in success["schema"]
