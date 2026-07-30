import 'dart:async';

import 'package:flutter/foundation.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;
import 'local_inspections_repository.dart';

/// Offline-first inspection directory (list + detail), backed by
/// [LocalInspectionsRepository] (Phase 7.2). `initialAssetId`/`initialStatus`
/// seed the filters once at construction -- they are not kept in sync with
/// the route afterward. There is no cursor pagination against the local
/// cache (that's a server-list concept); the list shows everything this
/// device currently has cached for the given filters.
class InspectionsController extends ChangeNotifier {
  InspectionsController({
    required LocalInspectionsRepository repository,
    String? initialAssetId,
    String? initialStatus,
  }) : _repository = repository,
       assetId = initialAssetId,
       status = initialStatus;

  final LocalInspectionsRepository _repository;
  StreamSubscription<List<LocalInspectionRecord>>? _subscription;
  int _generation = 0;
  bool _disposed = false;

  LoadStatus listStatus = LoadStatus.loading;
  List<LocalInspectionRecord> items = const [];

  String? assetId;
  String? status;

  Future<void> start() => _load();

  Future<void> retry() => _load();

  Future<void> setStatusFilter(String? value) async {
    status = value;
    await _load();
  }

  /// Fire-and-forget cancels the previous subscription (never awaited --
  /// Drift's stream cancellation schedules an internal timer that only
  /// resolves once real time elapses, which would otherwise stall this
  /// whole method under `flutter_test`'s fake clock) and instead uses a
  /// generation counter to ignore any stale subscription's late emissions.
  Future<void> _load() async {
    final generation = ++_generation;
    unawaited(_subscription?.cancel());
    listStatus = LoadStatus.loading;
    items = const [];
    _notify();
    _subscription = _repository
        .watchInspections(assetId: assetId, status: status)
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
    unawaited(_repository.refreshFromNetwork(assetId: assetId, status: status));
  }

  Stream<LocalInspectionRecord?> watchInspection(String inspectionId) =>
      _repository.watchInspection(inspectionId);

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
