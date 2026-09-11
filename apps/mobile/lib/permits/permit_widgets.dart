import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/widget_registry.dart';
import '../design_system/primitives.dart';

void registerPermitDashboardWidgets() {
  registerDashboardWidget(DashboardWidgetSpec(
    id: 'permits.active',
    title: 'Active permits',
    requiredPermission: 'permits.read',
    builder: (_) => const _ActivePermitsTile(),
  ));
}

class _ActivePermitsTile extends StatefulWidget {
  const _ActivePermitsTile();

  @override
  State<_ActivePermitsTile> createState() => _ActivePermitsTileState();
}

class _ActivePermitsTileState extends State<_ActivePermitsTile> {
  static PermitDashboardSummary? _cachedPermitSummary;

  late LoadStatus _status =
      _cachedPermitSummary != null ? LoadStatus.ready : LoadStatus.loading;
  PermitDashboardSummary? _data = _cachedPermitSummary;
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
      if (api is! PermitDashboardApiContract) {
        throw const ApiException(
          code: 'permit_dashboard_unavailable',
          message: 'Permit dashboard API is unavailable',
        );
      }
      final result = await (api as PermitDashboardApiContract)
          .getDashboardPermitsSummary();
      if (!mounted || id != _requestId) return;
      _cachedPermitSummary = result;
      setState(() {
        _data = result;
        _status = LoadStatus.ready;
      });
    } catch (_) {
      if (mounted && id == _requestId) {
        _cachedPermitSummary = null;
        setState(() {
          _data = null;
          _status = LoadStatus.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppStatCard(
        label: 'ACTIVE PERMITS',
        value: _data != null ? '${_data!.active}' : null,
        loading: _status == LoadStatus.loading,
        error: _status == LoadStatus.error,
        icon: Icons.assignment_outlined,
        onTap: () => Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.permits, (_) => false),
        onRetry: _load,
      );
}
