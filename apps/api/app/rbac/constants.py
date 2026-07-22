from dataclasses import dataclass


@dataclass(frozen=True)
class PermissionTemplate:
    key: str
    group: str
    description: str


@dataclass(frozen=True)
class SystemRoleTemplate:
    key: str
    name: str
    description: str
    permission_keys: frozenset[str]


PERMISSION_CATALOG = (
    PermissionTemplate("assets.read", "assets", "View assets"),
    PermissionTemplate("assets.write", "assets", "Create and update assets"),
    PermissionTemplate("inspections.read", "inspections", "View inspections"),
    PermissionTemplate("inspections.write", "inspections", "Create and update inspections"),
    PermissionTemplate("permits.read", "permits", "View permits"),
    PermissionTemplate("permits.approve", "permits", "Approve permits"),
    PermissionTemplate("work_orders.read", "work_orders", "View work orders"),
    PermissionTemplate("work_orders.write", "work_orders", "Create and update work orders"),
    PermissionTemplate("reports.read", "reports", "View reports"),
    PermissionTemplate("reports.generate", "reports", "Generate reports"),
    PermissionTemplate("safety.read", "safety", "View safety records"),
    PermissionTemplate("safety.write", "safety", "Create and update safety records"),
    PermissionTemplate("users.manage", "users", "Manage company users"),
    PermissionTemplate("roles.manage", "roles", "Manage company roles"),
    PermissionTemplate("company.settings", "company", "Manage company settings"),
    PermissionTemplate("audit.read", "audit", "View the company audit trail"),
    PermissionTemplate("platform.admin", "platform", "Administer the FEV platform"),
)

ALL_PERMISSION_KEYS = frozenset(permission.key for permission in PERMISSION_CATALOG)

SYSTEM_ROLE_TEMPLATES = {
    "super_admin": SystemRoleTemplate(
        key="super_admin",
        name="Super Admin",
        description="Full platform and company administration",
        permission_keys=ALL_PERMISSION_KEYS,
    ),
    "company_admin": SystemRoleTemplate(
        key="company_admin",
        name="Company Admin",
        description="Full administration within one company",
        permission_keys=ALL_PERMISSION_KEYS - {"platform.admin"},
    ),
    "operations_manager": SystemRoleTemplate(
        key="operations_manager",
        name="Operations Manager",
        description="Manage company operations and operational reporting",
        permission_keys=frozenset(
            {
                "assets.read",
                "assets.write",
                "inspections.read",
                "permits.read",
                "work_orders.read",
                "work_orders.write",
                "reports.read",
                "reports.generate",
                "safety.read",
            }
        ),
    ),
    "field_inspector": SystemRoleTemplate(
        key="field_inspector",
        name="Field Inspector",
        description="Perform inspections and field safety work",
        permission_keys=frozenset(
            {
                "assets.read",
                "inspections.read",
                "inspections.write",
                "permits.read",
                "work_orders.read",
                "reports.read",
                "reports.generate",
                "safety.read",
                "safety.write",
            }
        ),
    ),
    "maintenance_technician": SystemRoleTemplate(
        key="maintenance_technician",
        name="Maintenance Technician",
        description="Perform and update maintenance work",
        permission_keys=frozenset(
            {
                "assets.read",
                "inspections.read",
                "permits.read",
                "work_orders.read",
                "work_orders.write",
                "reports.read",
                "safety.read",
            }
        ),
    ),
    "hse_manager": SystemRoleTemplate(
        key="hse_manager",
        name="HSE Manager",
        description="Manage health, safety, and environmental oversight",
        permission_keys=frozenset(
            {
                "assets.read",
                "inspections.read",
                "permits.read",
                "permits.approve",
                "work_orders.read",
                "reports.read",
                "reports.generate",
                "safety.read",
                "safety.write",
                "audit.read",
            }
        ),
    ),
    "executive": SystemRoleTemplate(
        key="executive",
        name="Executive",
        description="Read-only operational oversight",
        permission_keys=frozenset(
            {
                "assets.read",
                "inspections.read",
                "permits.read",
                "work_orders.read",
                "reports.read",
                "safety.read",
                "audit.read",
            }
        ),
    ),
}
