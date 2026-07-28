import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/widget_registry.dart';
import '../design_system/chart.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';

/// The first three real registered dashboard widgets (Phase 4.4). Each
/// fetches independently rather than sharing one instance -- a pluggable
/// widget is self-contained by design, so one widget's failure can never be
/// entangled with another's. The endpoint itself is cheap (Firestore
/// count() aggregation, see D-039), so the extra requests are not a real
/// cost. Mirrors apps/admin/src/assets/asset-widgets.tsx.
void registerAssetDashboardWidgets() {
  registerDashboardWidget(
    DashboardWidgetSpec(
      id: 'assets.total',
      title: 'Total assets',
      requiredPermission: 'assets.read',
      builder: (context) => const _AssetStatTile(
        label: 'TOTAL ASSETS',
        valueOf: _totalOf,
        route: null,
      ),
    ),
  );
  registerDashboardWidget(
    DashboardWidgetSpec(
      id: 'assets.critical',
      title: 'Critical assets',
      requiredPermission: 'assets.read',
      builder: (context) => const _AssetStatTile(
        label: 'CRITICAL ASSETS',
        valueOf: _criticalOf,
        route: 'Critical',
        emphasis: true,
      ),
    ),
  );
  registerDashboardWidget(
    DashboardWidgetSpec(
      id: 'assets.condition',
      title: 'Asset condition',
      requiredPermission: 'assets.read',
      builder: (context) => const _AssetConditionTile(),
    ),
  );
}

int _totalOf(AssetDashboardSummary summary) => summary.total;
int _criticalOf(AssetDashboardSummary summary) => summary.critical;

/// Fetches the real asset KPI summary once per widget instance.
class _AssetSummaryFetch extends StatefulWidget {
  const _AssetSummaryFetch({required this.builder});

  final Widget Function(
    BuildContext context,
    LoadStatus status,
    AssetDashboardSummary? data,
    VoidCallback retry,
  )
  builder;

  @override
  State<_AssetSummaryFetch> createState() => _AssetSummaryFetchState();
}

class _AssetSummaryFetchState extends State<_AssetSummaryFetch> {
  LoadStatus _status = LoadStatus.loading;
  AssetDashboardSummary? _data;
  int _requestId = 0;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() => _status = LoadStatus.loading);
    try {
      final api = AuthProvider.of(context).api;
      final result = await api.getDashboardAssetsSummary();
      if (requestId != _requestId || !mounted) return;
      setState(() {
        _data = result;
        _status = LoadStatus.ready;
      });
    } catch (_) {
      if (requestId != _requestId || !mounted) return;
      setState(() => _status = LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _status, _data, () => unawaited(_load()));
}

class _AssetStatTile extends StatelessWidget {
  const _AssetStatTile({
    required this.label,
    required this.valueOf,
    required this.route,
    this.emphasis = false,
  });

  final String label;
  final int Function(AssetDashboardSummary summary) valueOf;
  final String? route;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return _AssetSummaryFetch(
      builder: (context, status, data, retry) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final valueColor = emphasis
            ? (dark ? DsColors.statusSoftCritical : DsColors.statusStrongCritical)
            : null;
        return InkWell(
          onTap: status == LoadStatus.ready
              ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.assets,
                    (_) => false,
                    arguments: route,
                  )
              : null,
          child: AppCard(
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
                  TextButton(onPressed: retry, child: const Text('Retry'))
                else
                  Text(
                    '${valueOf(data!)}',
                    style: TextStyle(
                      fontFamily: DsTypography.mono,
                      fontSize: DsTypography.sizeH2,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AssetConditionTile extends StatelessWidget {
  const _AssetConditionTile();

  @override
  Widget build(BuildContext context) {
    return _AssetSummaryFetch(
      builder: (context, status, data, retry) {
        final chartStatus = status == LoadStatus.ready && data != null && data.total == 0
            ? ChartStatus.empty
            : switch (status) {
                LoadStatus.loading => ChartStatus.loading,
                LoadStatus.error => ChartStatus.error,
                LoadStatus.ready => ChartStatus.ready,
              };
        final slices = data == null
            ? const <DonutSlice>[]
            : [
                DonutSlice(label: 'Healthy', value: data.healthy, color: DsColors.statusSuccess),
                DonutSlice(label: 'Warning', value: data.warning, color: DsColors.statusWarning),
                DonutSlice(label: 'Critical', value: data.critical, color: DsColors.statusCritical),
              ];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asset condition', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DsSpacing.s4),
              DonutChart(
                data: slices,
                emptyDescription: 'Asset condition appears here once assets are recorded for this tenant.',
                emptyTitle: 'No assets to chart yet',
                errorDescription: "Couldn't load asset condition data. Check your connection and try again.",
                onRetry: retry,
                status: chartStatus,
              ),
            ],
          ),
        );
      },
    );
  }
}
