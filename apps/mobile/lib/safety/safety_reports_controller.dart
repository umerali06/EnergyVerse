import 'dart:async';

import 'package:flutter/foundation.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;
import 'local_safety_reports_repository.dart';

class SafetyReportsController extends ChangeNotifier {
  static List<LocalSafetyReportRecord>? _staticCachedItems;

  SafetyReportsController({required LocalSafetyReportsRepository repository})
      : _repository = repository {
    if (_staticCachedItems != null) {
      items = _staticCachedItems!;
      status = LoadStatus.ready;
    }
  }

  final LocalSafetyReportsRepository _repository;
  StreamSubscription<List<LocalSafetyReportRecord>>? _subscription;
  bool _disposed = false;
  int _generation = 0;

  late LoadStatus status =
      _staticCachedItems != null ? LoadStatus.ready : LoadStatus.loading;
  List<LocalSafetyReportRecord> items = _staticCachedItems ?? const [];
  String? statusFilter;
  String? severityFilter;

  Future<void> start() => _load();
  Future<void> retry() => _load();

  Future<void> setStatusFilter(String? value) async {
    statusFilter = value;
    await _load();
  }

  Future<void> setSeverityFilter(String? value) async {
    severityFilter = value;
    await _load();
  }

  Future<void> _load() async {
    final generation = ++_generation;
    unawaited(_subscription?.cancel());
    if (items.isEmpty) {
      status = LoadStatus.loading;
      _notify();
    }
    _subscription = _repository
        .watchReports(status: statusFilter, severity: severityFilter)
        .listen((records) {
      if (generation != _generation) return;
      items = records;
      _staticCachedItems = records;
      status = LoadStatus.ready;
      _notify();
    }, onError: (_) {
      if (generation != _generation) return;
      if (items.isEmpty) {
        status = LoadStatus.error;
      }
      _notify();
    });
    unawaited(_repository.refreshFromNetwork(
      status: statusFilter,
      severity: severityFilter,
    ));
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
