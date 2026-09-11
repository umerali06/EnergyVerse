import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/widget_registry.dart';
import '../design_system/chart.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';

void registerSafetyDashboardWidgets() {
  registerDashboardWidget(
    DashboardWidgetSpec(
      id: 'safety.total',
      title: 'Safety incidents',
      requiredPermission: 'safety.read',
      builder: (_) => const _SafetyTotalTile(),
    ),
  );
  registerDashboardWidget(
    DashboardWidgetSpec(
      id: 'safety.by-type',
      title: 'Safety incidents by type',
      requiredPermission: 'safety.read',
      builder: (_) => const _SafetyByTypeTile(),
    ),
  );
}

class _SafetySummaryFetch extends StatefulWidget {
  const _SafetySummaryFetch({required this.builder});

  final Widget Function(LoadStatus, SafetyDashboardSummary?, VoidCallback)
      builder;

  @override
  State<_SafetySummaryFetch> createState() => _SafetySummaryFetchState();
}

class _SafetySummaryFetchState extends State<_SafetySummaryFetch> {
  static SafetyDashboardSummary? _cachedSafetySummary;

  late LoadStatus _status =
      _cachedSafetySummary != null ? LoadStatus.ready : LoadStatus.loading;
  SafetyDashboardSummary? _data = _cachedSafetySummary;
  var _requestId = 0;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final id = ++_requestId;
    if (_data == null) {
      setState(() => _status = LoadStatus.loading);
    }
    try {
      final result =
          await AuthProvider.of(context).api.getDashboardSafetySummary();
      if (!mounted || id != _requestId) return;
      _cachedSafetySummary = result;
      setState(() {
        _data = result;
        _status = LoadStatus.ready;
      });
    } catch (_) {
      if (mounted && id == _requestId) {
        _cachedSafetySummary = null;
        setState(() {
          _data = null;
          _status = LoadStatus.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(_status, _data, () => unawaited(_load()));
}

class _SafetyTotalTile extends StatelessWidget {
  const _SafetyTotalTile();

  @override
  Widget build(BuildContext context) => _SafetySummaryFetch(
        builder: (status, data, retry) => AppStatCard(
          label: 'SAFETY INCIDENTS',
          value: data != null ? '${data.total}' : null,
          loading: status == LoadStatus.loading,
          error: status == LoadStatus.error,
          icon: Icons.shield_outlined,
          onTap: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.safety, (_) => false),
          onRetry: retry,
        ),
      );
}

class _SafetyByTypeTile extends StatelessWidget {
  const _SafetyByTypeTile();

  @override
  Widget build(BuildContext context) => _SafetySummaryFetch(
        builder: (status, data, retry) {
          final chartStatus = status == LoadStatus.ready && data?.total == 0
              ? ChartStatus.empty
              : switch (status) {
                  LoadStatus.loading => ChartStatus.loading,
                  LoadStatus.error => ChartStatus.error,
                  LoadStatus.ready => ChartStatus.ready,
                };
          return AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Safety incidents by type',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DsSpacing.s4),
              DonutChart(
                data: data?.byCategory
                        .map((item) => DonutSlice(
                            label: _categoryLabel(item.category),
                            value: item.count,
                            color: _categoryColor(item.category)))
                        .toList() ??
                    const [],
                emptyDescription:
                    'Incident types appear here once safety reports are recorded for this tenant.',
                emptyTitle: 'No safety incidents to chart',
                errorDescription:
                    "Couldn't load safety incident data. Check your connection and try again.",
                onRetry: retry,
                status: chartStatus,
              ),
            ]),
          );
        },
      );
}

String _categoryLabel(SafetyCategoryCountCategoryEnum value) => switch (value) {
      SafetyCategoryCountCategoryEnum.nearMiss => 'Near miss',
      SafetyCategoryCountCategoryEnum.unsafeCondition => 'Unsafe condition',
      SafetyCategoryCountCategoryEnum.unsafeBehavior => 'Unsafe behavior',
      SafetyCategoryCountCategoryEnum.fire => 'Fire',
      SafetyCategoryCountCategoryEnum.gasLeak => 'Gas leak',
      SafetyCategoryCountCategoryEnum.chemicalSpill => 'Chemical spill',
      SafetyCategoryCountCategoryEnum.environmentalIncident =>
        'Environmental incident',
      SafetyCategoryCountCategoryEnum.equipmentFailure => 'Equipment failure',
      SafetyCategoryCountCategoryEnum.injury => 'Injury',
      _ => value.name,
    };

Color _categoryColor(SafetyCategoryCountCategoryEnum value) => switch (value) {
      SafetyCategoryCountCategoryEnum.nearMiss => Colors.amber,
      SafetyCategoryCountCategoryEnum.unsafeCondition => Colors.orange,
      SafetyCategoryCountCategoryEnum.unsafeBehavior => Colors.deepOrange,
      SafetyCategoryCountCategoryEnum.fire => Colors.red,
      SafetyCategoryCountCategoryEnum.gasLeak => Colors.purple,
      SafetyCategoryCountCategoryEnum.chemicalSpill => Colors.indigo,
      SafetyCategoryCountCategoryEnum.environmentalIncident => Colors.green,
      SafetyCategoryCountCategoryEnum.equipmentFailure => Colors.blueGrey,
      SafetyCategoryCountCategoryEnum.injury => Colors.pink,
      _ => Colors.grey,
    };
