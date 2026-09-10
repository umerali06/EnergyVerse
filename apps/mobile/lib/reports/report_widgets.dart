import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/widget_registry.dart';
import '../design_system/primitives.dart';

void registerReportDashboardWidgets() {
  registerDashboardWidget(DashboardWidgetSpec(
    id: 'reports.total',
    title: 'Reports generated',
    requiredPermission: 'reports.read',
    builder: (_) => const _ReportsGeneratedTile(),
  ));
}

class _ReportsGeneratedTile extends StatefulWidget {
  const _ReportsGeneratedTile();

  @override
  State<_ReportsGeneratedTile> createState() => _ReportsGeneratedTileState();
}

class _ReportsGeneratedTileState extends State<_ReportsGeneratedTile> {
  static ReportDashboardSummary? _cachedReportSummary;

  late LoadStatus _status =
      _cachedReportSummary != null ? LoadStatus.ready : LoadStatus.loading;
  ReportDashboardSummary? _data = _cachedReportSummary;
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
      final api = AuthProvider.of(context).api;
      if (api is! ReportDashboardApiContract) {
        throw const ApiException(
          code: 'report_dashboard_unavailable',
          message: 'Report dashboard API is unavailable',
        );
      }
      final result = await (api as ReportDashboardApiContract)
          .getDashboardReportsSummary();
      if (!mounted || id != _requestId) return;
      _cachedReportSummary = result;
      setState(() {
        _data = result;
        _status = LoadStatus.ready;
      });
    } catch (_) {
      if (mounted && id == _requestId) {
        _cachedReportSummary = null;
        setState(() {
          _data = null;
          _status = LoadStatus.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppStatCard(
        label: 'REPORTS GENERATED',
        value: _data != null ? '${_data!.total}' : null,
        loading: _status == LoadStatus.loading,
        error: _status == LoadStatus.error,
        icon: Icons.analytics_outlined,
        onTap: () => Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.reports, (_) => false),
        onRetry: _load,
      );
}
