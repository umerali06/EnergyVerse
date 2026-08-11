import 'dart:async';

import 'package:flutter/foundation.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;
import 'local_work_orders_repository.dart';

/// Offline-first work order directory (list + detail), backed by
/// [LocalWorkOrdersRepository] (Phase 8.2) -- mirrors
/// `InspectionsController`'s shape exactly. `technicianId` defaults to the
/// current user's uid ("My Work Orders") via [setMineOnly]; there is no
/// cursor pagination against the local cache, same rationale as inspections.
class WorkOrdersController extends ChangeNotifier {
  WorkOrdersController({
    required LocalWorkOrdersRepository repository,
    String? initialStatus,
    String? initialTechnicianId,
  })  : _repository = repository,
        status = initialStatus,
        technicianId = initialTechnicianId;

  final LocalWorkOrdersRepository _repository;
  StreamSubscription<List<LocalWorkOrderRecord>>? _subscription;
  int _generation = 0;
  bool _disposed = false;

  LoadStatus listStatus = LoadStatus.loading;
  List<LocalWorkOrderRecord> items = const [];

  String? status;
  String? technicianId;

  Future<void> start() => _load();

  Future<void> retry() => _load();

  Future<void> setStatusFilter(String? value) async {
    status = value;
    await _load();
  }

  Future<void> setTechnicianFilter(String? value) async {
    technicianId = value;
    await _load();
  }

  /// Fire-and-forget cancels the previous subscription (never awaited --
  /// same rationale as `InspectionsController._load`'s doc comment) and uses
  /// a generation counter to ignore any stale subscription's late emissions.
  Future<void> _load() async {
    final generation = ++_generation;
    unawaited(_subscription?.cancel());
    listStatus = LoadStatus.loading;
    items = const [];
    _notify();
    _subscription = _repository
        .watchWorkOrders(status: status, technicianId: technicianId)
        .listen((records) {
      if (generation != _generation) return;
      items = records;
      listStatus = LoadStatus.ready;
      _notify();
    }, onError: (_) {
      if (generation != _generation) return;
      listStatus = LoadStatus.error;
      _notify();
    });
    unawaited(_repository.refreshFromNetwork(
        status: status, technicianId: technicianId));
  }

  Stream<LocalWorkOrderRecord?> watchWorkOrder(String workOrderId) =>
      _repository.watchWorkOrder(workOrderId);

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
