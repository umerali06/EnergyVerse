import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../assets/asset_widgets.dart';
import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../auth/permissions.dart';
import '../design_system/chart.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../safety/safety_widgets.dart';
import '../permits/permit_widgets.dart';
import '../reports/report_widgets.dart';
import 'dashboard_controller.dart';
import '../sync/sync_engine.dart';
import 'format.dart';
import 'reserved_widgets.dart';
import 'widget_registry.dart';

/// Field Inspector/Technician get a task-focused subset (Total + Critical
/// only -- the two numbers they act on, no full breakdown chart); every
/// other role with assets.read (operations_manager, hse_manager, executive,
/// company_admin, super_admin) sees the full KPI set. A mobile-only layout
/// choice documented in ARCHITECTURE.md's Phase 4.4 section.
const _taskFocusedRoles = {'field_inspector', 'maintenance_technician'};

bool _widgetVisibleForRole(DashboardWidgetSpec spec, String roleKey) {
  if (spec.id != 'assets.condition') return true;
  return !_taskFocusedRoles.contains(roleKey);
}

String _greetingName(String email) {
  final parts = email.split('@').first.split(RegExp(r'[._-]+'));
  return parts
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

/// Role-aware dashboard built ONLY from real data (audit_logs/users/roles
/// per app/api/v1/dashboard.py, plus real asset and safety KPIs from their
/// typed summary routes). The pluggable registry keeps only genuinely unbuilt
/// modules as honest empty states and never renders placeholder numbers.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // InheritedWidget lookups (AuthProvider.of) aren't allowed in initState,
    // so the controller is built here instead — guarded to run only once.
    _controller ??= DashboardController(api: AuthProvider.of(context).api)
      ..start();
    // Idempotent (registerDashboardWidget no-ops on a duplicate id) -- safe
    // to call on every dependency change.
    registerAssetDashboardWidgets();
    registerSafetyDashboardWidgets();
    registerPermitDashboardWidgets();
    registerReportDashboardWidgets();
    registerReservedDashboardWidgets();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final permissions = PermissionProvider.of(context);
    final user = auth.currentUser!;
    final showUsers = permissions.can('users.manage');
    final showRoles = permissions.can('roles.manage');
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    final isOffline = SyncProvider.engineOf(context).connectivity ==
        SyncConnectivity.offline;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('dashboard-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          if (isOffline) const _OfflineBanner(),
          _Header(user: user),
          const SizedBox(height: DsSpacing.s6),
          if (showUsers || showRoles) ...[
            _StatGrid(
                controller: controller,
                showRoles: showRoles,
                showUsers: showUsers),
            const SizedBox(height: DsSpacing.s6),
          ] else ...[
            _AuditOnlyStat(controller: controller),
            const SizedBox(height: DsSpacing.s6),
          ],
          _ActivityChartCard(controller: controller),
          const SizedBox(height: DsSpacing.s6),
          _ActivityFeedCard(controller: controller),
          const SizedBox(height: DsSpacing.s6),
          const _QuickActionsCard(),
          const SizedBox(height: DsSpacing.s6),
          DashboardWidgetGrid(
            subscriptionTier: controller.summary?.subscriptionTier,
            filter: (spec) => _widgetVisibleForRole(spec, user.roleKey),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DsSpacing.s4),
      padding: const EdgeInsets.symmetric(
        horizontal: DsSpacing.s4,
        vertical: DsSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: DsColors.statusWarning.withAlpha(24),
        border: Border.all(color: DsColors.statusWarning.withAlpha(96)),
        borderRadius: BorderRadius.circular(DsRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: DsColors.statusWarning, size: 20),
          const SizedBox(width: DsSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operating Offline',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: DsTypography.sizeBodySmall,
                    color: DsColors.statusWarning,
                  ),
                ),
                Text(
                  'Showing local cached data. Queue items will sync automatically when online.',
                  style: TextStyle(
                    fontSize: DsTypography.sizeCaption,
                    color: context.semantic.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final CurrentUser user;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday', //
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DASHBOARD',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: DsColors.primary400,
                letterSpacing: 2,
              ),
        ),
        const SizedBox(height: DsSpacing.s2),
        Text(
          'Welcome, ${_greetingName(user.email)}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DsSpacing.s3),
        Wrap(
          spacing: DsSpacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppBadge(label: user.roleKey),
            Text(user.companyName,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: DsSpacing.s2),
        Text(
          '${weekdays[now.weekday - 1]}, ${formatCompanyDate(now)}',
          style: TextStyle(
            fontFamily: DsTypography.mono,
            fontSize: DsTypography.sizeBodySmall,
            color: context.semantic.textMuted,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.status,
    required this.value,
    this.icon,
    this.onRetry,
  });

  final String label;
  final LoadStatus status;
  final int? value;
  final IconData? icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppStatCard(
      label: label,
      value: value != null ? '$value' : null,
      loading: status == LoadStatus.loading,
      error: status == LoadStatus.error,
      icon: icon,
      onRetry: onRetry,
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid(
      {required this.controller,
      required this.showUsers,
      required this.showRoles});

  final DashboardController controller;
  final bool showUsers;
  final bool showRoles;

  @override
  Widget build(BuildContext context) {
    final summary = controller.summary;
    final tiles = <Widget>[
      if (showUsers)
        _StatTile(
          label: 'USERS IN COMPANY',
          icon: Icons.people_outline,
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.usersTotal,
        ),
      if (showUsers)
        _StatTile(
          label: 'ACTIVE USERS',
          icon: Icons.how_to_reg_outlined,
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.usersActive,
        ),
      if (showRoles)
        _StatTile(
          label: 'ROLES CONFIGURED',
          icon: Icons.admin_panel_settings_outlined,
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.rolesTotal,
        ),
      _StatTile(
        label: 'AUDIT EVENTS (${controller.window}D)',
        icon: Icons.history_outlined,
        onRetry: controller.retrySummary,
        status: controller.summaryStatus,
        value: summary?.auditEvents,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 600 ? 3 : 2;
        final rows = <Widget>[];
        for (var i = 0; i < tiles.length; i += columns) {
          final chunk = tiles.sublist(i, (i + columns).clamp(0, tiles.length));
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final tile in chunk) ...[
                    Expanded(child: tile),
                    if (tile != chunk.last) const SizedBox(width: DsSpacing.s3),
                  ],
                  if (chunk.length < columns)
                    for (var k = 0; k < columns - chunk.length; k++) ...[
                      const SizedBox(width: DsSpacing.s3),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                ],
              ),
            ),
          );
          if (i + columns < tiles.length) {
            rows.add(const SizedBox(height: DsSpacing.s3));
          }
        }
        return Column(children: rows);
      },
    );
  }
}

class _AuditOnlyStat extends StatelessWidget {
  const _AuditOnlyStat({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return _StatTile(
      label: 'AUDIT EVENTS (${controller.window}D)',
      icon: Icons.history_outlined,
      onRetry: controller.retrySummary,
      status: controller.summaryStatus,
      value: controller.summary?.auditEvents,
    );
  }
}

class _ActivityChartCard extends StatelessWidget {
  const _ActivityChartCard({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final timeZone = AuthProvider.of(context).currentUser?.companyTimezone;
    final points = controller.series
        .map(
          (point) => SeriesPoint(
            label: formatChartDay(point.date.toDateTime(), timeZone: timeZone),
            value: point.count,
          ),
        )
        .toList();
    final allZero =
        points.isNotEmpty && points.every((point) => point.value == 0);
    final status = switch (controller.seriesStatus) {
      LoadStatus.loading => ChartStatus.loading,
      LoadStatus.error => ChartStatus.error,
      LoadStatus.ready => allZero ? ChartStatus.empty : ChartStatus.ready,
    };
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity', style: Theme.of(context).textTheme.titleLarge),
              _WindowSwitcher(controller: controller),
            ],
          ),
          const SizedBox(height: DsSpacing.s4),
          TimeSeriesChart(
            data: points,
            emptyDescription:
                'Activity appears here once events are recorded for this tenant.',
            emptyTitle: 'No activity to chart yet',
            errorDescription:
                "Couldn't load activity data. Check your connection and try again.",
            onRetry: controller.retrySeries,
            status: status,
          ),
        ],
      ),
    );
  }
}

class _WindowSwitcher extends StatelessWidget {
  const _WindowSwitcher({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.semantic.border),
        borderRadius: BorderRadius.circular(DsRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final window in activityWindows)
              _WindowButton(
                selected: window == controller.window,
                label: '${window}d',
                onTap: () => controller.setWindow(window),
              ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton(
      {required this.selected, required this.label, required this.onTap});

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? (Theme.of(context).brightness == Brightness.dark
              ? DsColors.primary400
              : DsColors.primary800)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(DsRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(DsRadius.sm),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: DsSpacing.s3, vertical: DsSpacing.s1),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? DsColors.primary900
                      : Colors.white)
                  : context.semantic.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityFeedCard extends StatelessWidget {
  const _ActivityFeedCard({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent activity',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: DsSpacing.s3),
          if (controller.activityStatus == LoadStatus.loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: DsSpacing.s4),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (controller.activityStatus == LoadStatus.error)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: DsSpacing.s2),
              child: Column(
                children: [
                  const Text(
                    "Couldn't load recent activity. Check your connection and try again.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DsSpacing.s2),
                  TextButton(
                      onPressed: controller.retryActivity,
                      child: const Text('Retry')),
                ],
              ),
            )
          else if (controller.activityItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: DsSpacing.s4),
              child: Text(
                'Activity will appear here as your team uses FEV.',
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            for (final item in controller.activityItems)
              _ActivityRow(key: ValueKey(item.id), item: item),
            if (controller.nextCursor != null)
              Padding(
                padding: const EdgeInsets.only(top: DsSpacing.s2),
                child: AppButton(
                  key: const Key('load-more-activity'),
                  label: 'Load more',
                  loading: controller.loadingMore,
                  onPressed: controller.loadMoreActivity,
                  variant: AppButtonVariant.ghost,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, super.key});

  final DashboardActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsSpacing.s2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconFor(actionIconFor(item.action)),
              size: 18, color: context.semantic.textMuted),
          const SizedBox(width: DsSpacing.s2),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: item.actorName ?? item.actorUid,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' ${describeAction(item.action)} '),
                  TextSpan(
                    text: formatTarget(item.targetType, item.targetId),
                    style: TextStyle(
                      fontFamily: DsTypography.mono,
                      fontSize: DsTypography.sizeCaption,
                      color: context.semantic.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: DsSpacing.s2),
          Text(
            formatRelativeTime(item.createdAt),
            style: TextStyle(
              fontFamily: DsTypography.mono,
              fontSize: DsTypography.sizeCaption,
              color: context.semantic.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionProvider.of(context);
    final actions = <(String, String, String, IconData, bool)>[
      (
        'Scan QR code',
        "Scan an asset's QR label to jump straight to its details.",
        AppRoutes.qrScan,
        Icons.qr_code_scanner_outlined,
        permissions.can('assets.read'),
      ),
      (
        'Users',
        'Invite, edit, and deactivate people in your company.',
        AppRoutes.users,
        Icons.people_outline,
        permissions.can('users.manage'),
      ),
      (
        'Assets demo',
        'See the assets.write permission gate in action.',
        AppRoutes.rbacDemo,
        Icons.inventory_2_outlined,
        permissions.can('assets.write'),
      ),
    ].where((action) => action.$5).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: DsSpacing.s3),
          if (actions.isEmpty)
            Text(
              'No quick actions are available for your role yet.',
              style: TextStyle(color: context.semantic.textMuted),
            )
          else
            for (final (label, description, route, icon, _) in actions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(icon),
                onTap: () => Navigator.of(context).pushNamed(route),
                subtitle: Text(description),
                title: Text(label),
              ),
        ],
      ),
    );
  }
}
