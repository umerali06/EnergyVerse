import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import '../sync/sync_engine.dart'
    show ConnectivityCheck, ConnectivityStreamFactory, SyncConnectivity;
import 'local_work_orders_repository.dart';

/// Drives the [WorkOrderOutbox] drain loop against
/// [LocalWorkOrdersRepository] -- a structural mirror of `SyncEngine`
/// (`sync/sync_engine.dart`), kept as its own separate class rather than
/// genericizing that one, for the same reason `WorkOrderOutbox` is its own
/// table: an unrelated domain entity with a much smaller mutation set (only
/// `accept`/`submitForReview`), not worth the risk of an invasive refactor
/// of the working, well-tested inspections engine.
class WorkOrderSyncEngine extends ChangeNotifier {
  WorkOrderSyncEngine({
    required LocalWorkOrdersRepository repository,
    required ApiContract api,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
    Duration connectivityDebounce = const Duration(milliseconds: 500),
  })  : _repository = repository,
        _api = api,
        _now = now ?? DateTime.now,
        _connectivityDebounce = connectivityDebounce {
    final streamFactory = connectivityStreamFactory ??
        (() => Connectivity().onConnectivityChanged);
    _connectivitySubscription = streamFactory().listen(_onConnectivityEvent);
    _periodicTimer = Timer.periodic(periodicInterval, (_) {
      if (_connectivity != SyncConnectivity.offline) kick();
    });
    unawaited(
      (checkConnectivity ?? Connectivity().checkConnectivity)()
          .then(_onConnectivityEvent),
    );
    _repository.addListener(_recomputePendingOutboxCount);
    unawaited(_recomputePendingOutboxCount());
  }

  final LocalWorkOrdersRepository _repository;
  final ApiContract _api;
  final Duration _connectivityDebounce;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  late final Timer _periodicTimer;
  Timer? _debounceTimer;
  bool _disposed = false;
  final DateTime Function() _now;

  Future<void> _recomputePendingOutboxCount() async {
    final count = await _repository.outboxCount();
    if (_disposed) return;
    pendingOutboxCount = count;
    _notify();
  }

  SyncConnectivity _connectivity = SyncConnectivity.unknown;
  SyncConnectivity get connectivity => _connectivity;

  int pendingOutboxCount = 0;

  bool _draining = false;
  bool get isDraining => _draining;
  bool _rerunKick = false;
  bool _rerunSyncNow = false;

  void _onConnectivityEvent(List<ConnectivityResult> results) {
    if (_disposed) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_connectivityDebounce, () {
      if (_disposed) return;
      final online = results.any((result) => result != ConnectivityResult.none);
      final next = online ? SyncConnectivity.online : SyncConnectivity.offline;
      final changed = next != _connectivity;
      _connectivity = next;
      if (changed) _notify();
      if (online) kick();
    });
  }

  void kick() {
    if (_draining) {
      _rerunKick = true;
      return;
    }
    unawaited(_runDrain(bypassBackoff: false));
  }

  Future<void> syncNow() {
    if (_draining) {
      _rerunSyncNow = true;
      return Future.value();
    }
    return _runDrain(bypassBackoff: true);
  }

  Future<void> _runDrain({required bool bypassBackoff}) async {
    _draining = true;
    _notify();
    try {
      var bypass = bypassBackoff;
      while (true) {
        final items = await _repository.queueForDrain(
            now: _now().toUtc(), bypassBackoff: bypass);
        for (final item in items) {
          final keepDraining = await _replay(item);
          if (!keepDraining) break;
        }
        if (_rerunSyncNow) {
          bypass = true;
          _rerunSyncNow = false;
          _rerunKick = false;
          continue;
        }
        if (_rerunKick) {
          bypass = false;
          _rerunKick = false;
          continue;
        }
        break;
      }
    } finally {
      _draining = false;
      _notify();
    }
  }

  Future<bool> _replay(WorkOrderOutboxItemRecord item) async {
    try {
      final detail = await _dispatch(item);
      await _repository.applyMutationSuccess(item: item, server: detail);
      return true;
    } on ApiException catch (error) {
      return _handleError(item, error);
    }
  }

  Future<WorkOrderDetail> _dispatch(WorkOrderOutboxItemRecord item) {
    switch (item.mutationType) {
      case WorkOrderOutboxMutationType.accept:
        return _api.acceptWorkOrder(item.workOrderId);
      case WorkOrderOutboxMutationType.submitForReview:
        final payload = jsonDecode(item.row.payload) as Map<String, dynamic>;
        final request = standardSerializers.deserializeWith(
          SubmitWorkOrderForReviewRequest.serializer,
          payload,
        )!;
        return _api.submitWorkOrderForReview(item.workOrderId, request);
    }
  }

  Future<bool> _handleError(
      WorkOrderOutboxItemRecord item, ApiException error) async {
    if (error.code == 'network_error' || error.code == 'request_cancelled') {
      await _repository.markTransientFailure(
        item,
        message: error.message,
        nextAttemptAt: _now().toUtc().add(_backoffFor(item.attempts)),
      );
      return false;
    }
    if (error.code == 'revision_conflict' ||
        error.code == 'invalid_transition') {
      return _handleConflictOrInvalidTransition(item, error);
    }
    await _repository.markPermanentError(item, message: error.message);
    return true;
  }

  Future<bool> _handleConflictOrInvalidTransition(
      WorkOrderOutboxItemRecord item, ApiException error) async {
    final WorkOrderDetail current;
    try {
      current = await _api.getWorkOrder(item.workOrderId);
    } on ApiException {
      await _repository.markTransientFailure(
        item,
        message: error.message,
        nextAttemptAt: _now().toUtc().add(_backoffFor(item.attempts)),
      );
      return false;
    }
    if (await _alreadyApplied(item, current)) {
      await _repository.applyAlreadyApplied(item: item, server: current);
      return true;
    }
    await _repository.markConflict(
        workOrderId: item.workOrderId, serverSnapshot: current);
    return true;
  }

  /// True when the server's current state already matches exactly what this
  /// mutation was trying to set -- an earlier attempt actually succeeded
  /// before the app died mid-request, and this is a replay of that same
  /// attempt rather than a real conflict. Mirrors `SyncEngine._alreadyApplied`.
  ///
  /// `accept` needs more than a status check: unlike inspections' `start`
  /// (whose inspector is fixed at creation), a work order's technician can
  /// change out from under a queued accept via reassignment. Comparing
  /// `current.technicianId` against this device's own still-unmutated local
  /// row (accept never touches `technicianId`, only `status`/`acceptedAt`)
  /// distinguishes "my own accept actually landed" from "someone else was
  /// reassigned and accepted while I was offline" -- the latter must surface
  /// as a real conflict, not be silently swallowed as success.
  Future<bool> _alreadyApplied(
      WorkOrderOutboxItemRecord item, WorkOrderDetail current) async {
    switch (item.mutationType) {
      case WorkOrderOutboxMutationType.accept:
        final local = await _repository.getWorkOrder(item.workOrderId);
        return current.status.name == 'inProgress' &&
            local != null &&
            current.technicianId == local.row.technicianId;
      case WorkOrderOutboxMutationType.submitForReview:
        final request = standardSerializers.deserializeWith(
          SubmitWorkOrderForReviewRequest.serializer,
          jsonDecode(item.row.payload) as Map<String, dynamic>,
        )!;
        return current.status.name == 'pendingReview' &&
            current.completionNotes == request.completionNotes;
    }
  }

  static Duration _backoffFor(int attempts) {
    final doubling = 1 << attempts.clamp(0, 6);
    final seconds = (30 * doubling).clamp(30, 30 * 60);
    return Duration(seconds: seconds);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    _periodicTimer.cancel();
    unawaited(_connectivitySubscription.cancel());
    _repository.removeListener(_recomputePendingOutboxCount);
    super.dispose();
  }
}

class WorkOrderSyncProvider extends InheritedNotifier<WorkOrderSyncEngine> {
  const WorkOrderSyncProvider({
    required WorkOrderSyncEngine engine,
    required this.repository,
    required super.child,
    super.key,
  }) : super(notifier: engine);

  final LocalWorkOrdersRepository repository;

  static WorkOrderSyncEngine engineOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<WorkOrderSyncProvider>();
    assert(provider != null, 'WorkOrderSyncProvider is required');
    return provider!.notifier!;
  }

  static LocalWorkOrdersRepository repositoryOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<WorkOrderSyncProvider>();
    assert(provider != null, 'WorkOrderSyncProvider is required');
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(WorkOrderSyncProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
