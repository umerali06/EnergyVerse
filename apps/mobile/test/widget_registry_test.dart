import 'package:fev_mobile/auth/permissions.dart';
import 'package:fev_mobile/dashboard/widget_registry.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(List<String> permissions, Widget child) {
  return MaterialApp(
    theme: AppThemes.light,
    home: PermissionProvider(
      controller: PermissionController(initialPermissions: permissions),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(resetDashboardWidgetRegistryForTests);

  testWidgets('filters registered widgets by the viewer\'s permission, table-driven across roles', (
    tester,
  ) async {
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.assets',
        title: 'Assets widget',
        requiredPermission: 'assets.read',
        builder: (context) => const Text('assets widget content'),
      ),
    );
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.work-orders',
        title: 'Work orders widget',
        requiredPermission: 'work_orders.read',
        builder: (context) => const Text('work orders widget content'),
      ),
    );

    final cases = <(List<String>, List<String>, List<String>)>[
      (
        ['assets.read'],
        ['assets widget content'],
        ['work orders widget content'],
      ),
      (
        ['work_orders.read'],
        ['work orders widget content'],
        ['assets widget content'],
      ),
      (
        <String>[],
        <String>[],
        ['assets widget content', 'work orders widget content'],
      ),
    ];

    for (final (permissions, visible, hidden) in cases) {
      await tester.pumpWidget(
        _wrap(permissions, const DashboardWidgetGrid()),
      );
      for (final text in visible) {
        expect(find.text(text), findsOneWidget);
      }
      for (final text in hidden) {
        expect(find.text(text), findsNothing);
      }
    }
  });

  testWidgets('renders nothing when no registered widget is permitted', (tester) async {
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.gated',
        title: 'Gated widget',
        requiredPermission: 'work_orders.read',
        builder: (context) => const Text('gated content'),
      ),
    );
    await tester.pumpWidget(_wrap(['assets.read'], const DashboardWidgetGrid()));
    expect(find.byKey(const Key('dashboard-widget-grid')), findsNothing);
  });

  testWidgets('gates a widget by minimum subscription tier', (tester) async {
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.enterprise-only',
        title: 'Enterprise widget',
        requiredPermission: 'assets.read',
        minTier: 'enterprise',
        builder: (context) => const Text('enterprise-only content'),
      ),
    );

    await tester.pumpWidget(
      _wrap(['assets.read'], const DashboardWidgetGrid(subscriptionTier: 'starter')),
    );
    expect(find.text('enterprise-only content'), findsNothing);

    await tester.pumpWidget(
      _wrap(['assets.read'], const DashboardWidgetGrid(subscriptionTier: 'enterprise')),
    );
    expect(find.text('enterprise-only content'), findsOneWidget);
  });

  testWidgets('isolates a widget that throws during build, without breaking its siblings', (
    tester,
  ) async {
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.throwing',
        title: 'Broken widget',
        requiredPermission: 'assets.read',
        builder: (context) => throw Exception('widget blew up'),
      ),
    );
    registerDashboardWidget(
      DashboardWidgetSpec(
        id: 'test.healthy',
        title: 'Healthy widget',
        requiredPermission: 'assets.read',
        builder: (context) => const Text('healthy widget content'),
      ),
    );

    await tester.pumpWidget(_wrap(['assets.read'], const DashboardWidgetGrid()));

    expect(find.text("Couldn't load this widget."), findsOneWidget);
    expect(find.text('healthy widget content'), findsOneWidget);
  });
}
