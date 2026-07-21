import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../auth/permissions.dart';
import '../design_system/chart.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'dashboard_controller.dart';
import 'format.dart';

String _greetingName(String email) {
  final parts = email.split('@').first.split(RegExp(r'[._-]+'));
  return parts
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

/// Role-aware dashboard built ONLY from real audit_logs/users/roles data
/// (see app/api/v1/dashboard.py). Assets/work-orders/permits/incidents don't
/// exist yet (Phases 4/10/11) — the reserved-KPI section below shows an
/// honest empty state for those, never a placeholder number.
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
    _controller ??= DashboardController(api: AuthProvider.of(context).api)..start();
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

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('dashboard-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          _Header(user: user),
          const SizedBox(height: DsSpacing.s6),
          if (showUsers || showRoles) ...[
            _StatGrid(controller: controller, showRoles: showRoles, showUsers: showUsers),
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
          const _ReservedKpiRegion(),
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
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', //
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
            Text(user.companyName, style: Theme.of(context).textTheme.bodySmall),
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
  const _StatTile({required this.label, required this.status, required this.value, this.onRetry});

  final String label;
  final LoadStatus status;
  final int? value;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: DsTypography.mono,
              fontSize: DsTypography.sizeCaption,
              color: context.semantic.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: DsSpacing.s2),
          if (status == LoadStatus.loading)
            const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (status == LoadStatus.error)
            TextButton(onPressed: onRetry, child: const Text('Retry'))
          else
            Text(
              '$value',
              style: TextStyle(
                fontFamily: DsTypography.mono,
                fontSize: DsTypography.sizeH2,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.controller, required this.showUsers, required this.showRoles});

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
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.usersTotal,
        ),
      if (showUsers)
        _StatTile(
          label: 'ACTIVE USERS',
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.usersActive,
        ),
      if (showRoles)
        _StatTile(
          label: 'ROLES CONFIGURED',
          onRetry: controller.retrySummary,
          status: controller.summaryStatus,
          value: summary?.rolesTotal,
        ),
      _StatTile(
        label: 'AUDIT EVENTS (${controller.window}D)',
        onRetry: controller.retrySummary,
        status: controller.summaryStatus,
        value: summary?.auditEvents,
      ),
    ];
    // A plain Row/Column grid, not GridView: GridView carries its own
    // Scrollable/Viewport even with shrinkWrap+NeverScrollableScrollPhysics,
    // which needlessly nests a second scrollable inside the page ListView.
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final rowTiles = tiles.sublist(i, (i + 2).clamp(0, tiles.length));
      rows.add(
        Row(
          children: [
            for (final tile in rowTiles) ...[
              Expanded(child: tile),
              if (tile != rowTiles.last) const SizedBox(width: DsSpacing.s3),
            ],
            if (rowTiles.length == 1) const Spacer(),
          ],
        ),
      );
      if (i + 2 < tiles.length) rows.add(const SizedBox(height: DsSpacing.s3));
    }
    return Column(children: rows);
  }
}

class _AuditOnlyStat extends StatelessWidget {
  const _AuditOnlyStat({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return _StatTile(
      label: 'AUDIT EVENTS (${controller.window}D)',
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
    final points = controller.series
        .map((point) => SeriesPoint(label: formatChartDay(point.date.toDateTime()), value: point.count))
        .toList();
    final allZero = points.isNotEmpty && points.every((point) => point.value == 0);
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
            emptyDescription: 'Activity appears here once events are recorded for this tenant.',
            emptyTitle: 'No activity to chart yet',
            errorDescription: "Couldn't load activity data. Check your connection and try again.",
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
  const _WindowButton({required this.selected, required this.label, required this.onTap});

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
          padding: const EdgeInsets.symmetric(horizontal: DsSpacing.s3, vertical: DsSpacing.s1),
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
          Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
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
                  TextButton(onPressed: controller.retryActivity, child: const Text('Retry')),
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
          Icon(iconFor(actionIconFor(item.action)), size: 18, color: context.semantic.textMuted),
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

const _reservedKpiModules = <(String, String, String)>[
  ('Assets', 'assets.read', 'Asset metrics appear once the Assets module is enabled.'),
  (
    'Work Orders',
    'work_orders.read',
    'Work order metrics appear once the Work Orders module is enabled.',
  ),
  ('Permits', 'permits.read', 'Permit metrics appear once the Permits module is enabled.'),
  (
    'Safety & Incidents',
    'safety.read',
    'Safety and incident metrics appear once the Safety module is enabled.',
  ),
];

/// The visual contract 2.3's pluggable KPI framework will fill in. Every
/// tile is an honest empty state — never a placeholder number.
class _ReservedKpiRegion extends StatelessWidget {
  const _ReservedKpiRegion();

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionProvider.of(context);
    final modules = _reservedKpiModules.where((module) => permissions.can(module.$2)).toList();
    if (modules.isEmpty) return const SizedBox.shrink();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('On the roadmap', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: DsSpacing.s3),
          for (final (label, _, copy) in modules)
            Container(
              margin: const EdgeInsets.only(bottom: DsSpacing.s2),
              padding: const EdgeInsets.all(DsSpacing.s3),
              decoration: BoxDecoration(
                border: Border.all(color: context.semantic.border, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(DsRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: DsSpacing.s1),
                  Text(copy, style: TextStyle(color: context.semantic.textMuted, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
