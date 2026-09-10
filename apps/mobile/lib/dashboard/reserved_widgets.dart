import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'widget_registry.dart';

/// Honest empty-state widgets for modules that don't exist yet (Work
/// Orders). Mirrors
/// apps/admin/src/dashboard/reserved-widgets.tsx -- when a future phase
/// builds one of these modules, it deletes that module's entry here and
/// registers its own real widget the same way `asset_widgets.dart` does.
const _reservedModules = <(String, String, String, String)>[
  (
    'reserved.work-orders',
    'Work Orders',
    'work_orders.read',
    'Work order metrics appear once the Work Orders module is enabled.',
  ),
];

void registerReservedDashboardWidgets() {
  for (final (id, label, permission, copy) in _reservedModules) {
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: id,
        title: label,
        requiredPermission: permission,
        builder: (context) => AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: DsSpacing.s1),
              Text(copy,
                  style: TextStyle(
                      color: context.semantic.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
