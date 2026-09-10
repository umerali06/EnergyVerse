import json
from pathlib import Path

from scripts.export_openapi import export_openapi

EXPECTED_OPERATIONS = {
    "get_dashboard_summary",
    "get_dashboard_activity",
    "get_dashboard_activity_series",
    "get_dashboard_assets_summary",
    "get_dashboard_safety_summary",
    "get_dashboard_permits_summary",
    "get_dashboard_reports_summary",
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
    "get_role",
    "create_role",
    "update_role",
    "delete_role",
    "list_permission_catalog",
    "list_facilities",
    "get_facility",
    "create_facility",
    "update_facility",
    "delete_facility",
    "list_areas",
    "get_area",
    "create_area",
    "update_area",
    "delete_area",
    "list_assets",
    "get_asset",
    "get_asset_history",
    "create_asset",
    "update_asset",
    "delete_asset",
    "upload_asset_media",
    "delete_asset_media",
    "get_asset_qr_label",
    "resolve_qr_code",
    "list_inspections",
    "get_inspection",
    "create_inspection",
    "update_inspection",
    "delete_inspection",
    "assign_inspection_checklist_template",
    "start_inspection",
    "complete_inspection",
    "cancel_inspection",
    "attach_inspection_media",
    "update_inspection_media",
    "detach_inspection_media",
    "attach_inspection_voice_note",
    "update_inspection_voice_note",
    "detach_inspection_voice_note",
    "create_inspection_annotation",
    "update_inspection_annotation",
    "delete_inspection_annotation",
    "create_inspection_ar_measurement",
    "update_inspection_ar_measurement",
    "delete_inspection_ar_measurement",
    "analyze_inspection_media",
    "review_inspection_ai_analysis",
    "list_checklist_templates",
    "get_checklist_template",
    "create_checklist_template",
    "create_permit_template",
    "create_permit",
    "delete_permit_template",
    "delete_permit",
    "decide_permit_approval",
    "get_permit_template",
    "get_permit",
    "list_permit_templates",
    "list_permits",
    "update_permit_template",
    "update_permit",
    "update_checklist_template",
    "delete_checklist_template",
    "get_company",
    "update_company",
    "upload_company_logo",
    "remove_company_logo",
    "list_audit_logs",
    "get_audit_log_facets",
    "export_audit_logs",
    "list_platform_companies",
    "get_platform_company",
    "update_platform_company_status",
    "update_platform_company",
    "get_platform_stats",
    "list_work_orders",
    "create_work_order",
    "get_work_order",
    "assign_work_order",
    "accept_work_order",
    "acknowledge_permit",
    "activate_permit",
    "submit_work_order_for_review",
    "submit_permit",
    "suspend_permit",
    "resume_permit",
    "revoke_permit",
    "close_permit",
    "close_work_order",
    "cancel_work_order",
    "delete_work_order",
    "list_safety_reports",
    "create_safety_report",
    "get_safety_report",
    "assign_safety_report",
    "transition_safety_report",
    "close_safety_report",
    "delete_safety_report",
    "upload_safety_evidence",
    "delete_safety_evidence",
    "create_corrective_action",
    "update_corrective_action",
    "cancel_corrective_action",
    "list_generated_reports",
    "generate_report",
    "get_generated_report",
    "update_generated_report",
    "regenerate_generated_report",
    "finalize_generated_report",
    "delete_generated_report",
    "export_generated_report",
    "get_facility_3d_scene",
    "update_facility_3d_scene",
    "list_documents",
    "create_document",
    "get_document",
    "update_document",
    "delete_document",
    # Notifications. Gated on authentication alone -- a notification is
    # addressed to one user, so there is no permission or plan feature to
    # check beyond being signed in.
    "list_notifications",
    "mark_notification_read",
    "mark_all_notifications_read",
    "register_notification_device",
    "unregister_notification_device",
    # VR training. Reading a module needs assets.read (it exposes the
    # facility's real equipment); recording progress needs only a signed-in
    # user, since progress is personal. The whole router sits behind the
    # vr_training entitlement.
    "list_training_modules",
    "get_training_module",
    "list_training_progress",
    "start_training_module",
    "complete_training_step",
    "complete_training_module",
    # Phase 13 billing. `stripe_webhook` is deliberately absent: it is
    # `include_in_schema=False`, since it is Stripe's contract, not a client's.
    "get_billing_catalog",
    "get_subscription",
    "create_checkout_session",
}

# CSV export is intentionally not JSON-typed (D-019/3.4: streamed compliance
# export, not a resource representation) — excluded from the JSON-schema check.
CSV_OPERATIONS = {"export_audit_logs"}


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
            content = operation["responses"][success_code]["content"]
            if operation["operationId"] in CSV_OPERATIONS:
                assert "text/csv" in content
                continue
            success = content["application/json"]
            assert "$ref" in success["schema"]
