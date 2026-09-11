import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import '../sync/sync_engine.dart'
    show ConnectivityCheck, ConnectivityStreamFactory, SyncConnectivity;
import 'local_permits_repository.dart';

class PermitSyncEngine extends ChangeNotifier {
  PermitSyncEngine({
    required LocalPermitsRepository repository,
    required PermitApiContract api,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
  })  : _repository = repository,
        _api = api,
        _now = now ?? DateTime.now {
    _subscription = (connectivityStreamFactory ??
            (() => Connectivity().onConnectivityChanged))()
        .listen(_connectivityChanged);
    _timer = Timer.periodic(periodicInterval, (_) => kick());
    unawaited((checkConnectivity ?? Connectivity().checkConnectivity)()
        .then(_connectivityChanged));
    _repository.addListener(_count);
    unawaited(_count());
  }

  final LocalPermitsRepository _repository;
  final PermitApiContract _api;
  final DateTime Function() _now;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  late final Timer _timer;
  bool _disposed = false;
  bool _draining = false;
  SyncConnectivity connectivity = SyncConnectivity.unknown;
  int pendingOutboxCount = 0;
  bool get isDraining => _draining;

  Future<void> _count() async {
    pendingOutboxCount = await _repository.outboxCount();
    if (!_disposed) notifyListeners();
  }

  void _connectivityChanged(List<ConnectivityResult> values) {
    connectivity = values.any((value) => value != ConnectivityResult.none)
        ? SyncConnectivity.online
        : SyncConnectivity.offline;
    if (!_disposed) notifyListeners();
    if (connectivity == SyncConnectivity.online) kick();
  }

  void kick() {
    if (connectivity != SyncConnectivity.offline && !_draining) {
      unawaited(_drain(false));
    }
  }

  Future<void> syncNow() => _drain(true);

  Future<void> _drain(bool bypassBackoff) async {
    if (_draining) return;
    _draining = true;
    if (!_disposed) notifyListeners();
    try {
      final items = await _repository.queueForDrain(
          now: _now().toUtc(), bypassBackoff: bypassBackoff);
      for (final item in items) {
        try {
          final server = await _api.acknowledgePermit(
              item.permitId, _repository.requestFor(item));
          await _repository.applySuccess(item, server);
        } on ApiException catch (error) {
          if (error.code == 'network_error' ||
              error.code == 'request_cancelled') {
            await _repository.markTransient(item, error.message,
                _now().toUtc().add(_backoff(item.attempts)));
            break;
          }
          if (error.code == 'revision_conflict' ||
              error.code == 'invalid_transition') {
            try {
              final current = await _api.getPermit(item.permitId);
              final request = _repository.requestFor(item);
              final applied = current.workerAcknowledgements.any((entry) =>
                  entry.clientMutationId == request.clientMutationId);
              if (applied) {
                await _repository.applySuccess(item, current);
              } else {
                await _repository.markConflict(item, current);
              }
            } on ApiException {
              await _repository.markTransient(item, error.message,
                  _now().toUtc().add(_backoff(item.attempts)));
              break;
            }
          } else {
            await _repository.markError(item, error.message);
          }
        }
      }
    } finally {
      _draining = false;
      await _count();
    }
  }

  static Duration _backoff(int attempts) =>
      Duration(seconds: (30 * (1 << attempts.clamp(0, 6))).clamp(30, 1800));

  @override
  void dispose() {
    _disposed = true;
    _timer.cancel();
    unawaited(_subscription.cancel());
    _repository.removeListener(_count);
    super.dispose();
  }
}

class PermitSyncProvider extends InheritedNotifier<PermitSyncEngine> {
  const PermitSyncProvider(
      {required PermitSyncEngine engine,
      required this.repository,
      required super.child,
      super.key})
      : super(notifier: engine);
  final LocalPermitsRepository repository;
  static PermitSyncEngine engineOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PermitSyncProvider>()!
      .notifier!;
  static LocalPermitsRepository repositoryOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PermitSyncProvider>()!
      .repository;
  @override
  bool updateShouldNotify(PermitSyncProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
