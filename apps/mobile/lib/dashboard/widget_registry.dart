import 'package:flutter/material.dart';

import '../auth/permissions.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';

/// The pluggable dashboard KPI widget framework (Phase 4.4, resolving the
/// 2.3 deferral). A module registers a widget once via [registerDashboardWidget]
/// -- [DashboardWidgetGrid] discovers it, gates it by permission (and tier,
/// once a future widget sets [minTier]), and isolates its failures so one bad
/// widget never blanks the rest of the dashboard. Mirrors the admin
/// implementation in apps/admin/src/dashboard/widget-registry.tsx -- see
/// ARCHITECTURE.md's Phase 4.4 section for the "how to add a widget"
/// contract.

// Mirrors SUBSCRIPTION_TIERS in apps/api/app/models/api.py -- a small local
// constant since no widget sets `minTier` yet; this is the hook, real
// enforcement lands in the billing phase.
const subscriptionTiers = ['demo', 'starter', 'professional', 'enterprise'];

bool _tierMeetsMinimum(String? currentTier, String? minTier) {
  if (minTier == null) return true;
  if (currentTier == null) return false;
  final currentIndex = subscriptionTiers.indexOf(currentTier);
  final minIndex = subscriptionTiers.indexOf(minTier);
  return currentIndex != -1 && currentIndex >= minIndex;
}

class DashboardWidgetSpec {
  const DashboardWidgetSpec({
    required this.id,
    required this.title,
    required this.requiredPermission,
    required this.builder,
    this.minTier,
  });

  final String id;
  final String title;
  final String requiredPermission;
  final String? minTier;
  final WidgetBuilder builder;
}

final List<DashboardWidgetSpec> _registry = [];

/// Modules call this once at import/registration time. Registering the same
/// id twice is a no-op.
void registerDashboardWidget(DashboardWidgetSpec spec) {
  if (_registry.any((existing) => existing.id == spec.id)) return;
  _registry.add(spec);
}

/// Test-only: clears the registry so each test starts from a known state.
void resetDashboardWidgetRegistryForTests() {
  _registry.clear();
}

List<DashboardWidgetSpec> registeredDashboardWidgets() => List.unmodifiable(_registry);

/// One widget throwing during build must not blank the rest of the
/// dashboard -- each widget gets its own boundary via [ErrorWidget.builder]
/// scoped to this subtree through a [Builder] + try/catch at build time.
class _WidgetBoundary extends StatelessWidget {
  const _WidgetBoundary({required this.title, required this.builder});

  final String title;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    try {
      return builder(context);
    } catch (_) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: DsTypography.mono,
                fontSize: DsTypography.sizeCaption,
                color: context.semantic.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: DsSpacing.s2),
            Text(
              "Couldn't load this widget.",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: DsColors.statusStrongCritical,
              ),
            ),
          ],
        ),
      );
    }
  }
}

/// Filters the registered widgets by permission + tier and renders each in
/// its own failure boundary, filtered/subset controlled by [filter] (e.g.
/// the mobile role-based task-focused vs full KPI subset).
class DashboardWidgetGrid extends StatelessWidget {
  const DashboardWidgetGrid({this.subscriptionTier, this.filter, super.key});

  final String? subscriptionTier;
  final bool Function(DashboardWidgetSpec spec)? filter;

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionProvider.of(context);
    final widgets = registeredDashboardWidgets()
        .where((spec) => permissions.can(spec.requiredPermission))
        .where((spec) => _tierMeetsMinimum(subscriptionTier, spec.minTier))
        .where((spec) => filter?.call(spec) ?? true)
        .toList();
    if (widgets.isEmpty) return const SizedBox.shrink();
    return Column(
      key: const Key('dashboard-widget-grid'),
      children: [
        for (final spec in widgets) ...[
          _WidgetBoundary(title: spec.title, builder: spec.builder),
          if (spec != widgets.last) const SizedBox(height: DsSpacing.s3),
        ],
      ],
    );
  }
}
