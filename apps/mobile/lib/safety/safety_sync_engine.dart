import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import '../sync/sync_engine.dart'
    show ConnectivityCheck, ConnectivityStreamFactory, SyncConnectivity;
import 'local_safety_reports_repository.dart';

class SafetySyncEngine extends ChangeNotifier {
  SafetySyncEngine({
    required LocalSafetyReportsRepository repository,
    required SafetyApiContract api,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
    Duration connectivityDebounce = const Duration(milliseconds: 500),
  })  : _repository = repository,
        _api = api,
        _now = now ?? DateTime.now,
        _connectivityDebounce = connectivityDebounce {
    _connectivitySubscription = (connectivityStreamFactory ??
            (() => Connectivity().onConnectivityChanged))()
        .listen(_onConnectivityEvent);
    _periodicTimer = Timer.periodic(periodicInterval, (_) {
      if (_connectivity != SyncConnectivity.offline) kick();
    });
    unawaited((checkConnectivity ?? Connectivity().checkConnectivity)()
        .then(_onConnectivityEvent));
    _repository.addListener(_recomputeCount);
    unawaited(_recomputeCount());
  }

  final LocalSafetyReportsRepository _repository;
  final SafetyApiContract _api;
  final DateTime Function() _now;
  final Duration _connectivityDebounce;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  late final Timer _periodicTimer;
  Timer? _debounceTimer;
  bool _disposed = false;
  bool _draining = false;
  bool _rerun = false;
  bool _bypassOnRerun = false;
  SyncConnectivity _connectivity = SyncConnectivity.unknown;

  int pendingOutboxCount = 0;
  bool get isDraining => _draining;
  SyncConnectivity get connectivity => _connectivity;

  Future<void> _recomputeCount() async {
    final count = await _repository.outboxCount();
    if (_disposed) return;
    pendingOutboxCount = count;
    notifyListeners();
  }

  void _onConnectivityEvent(List<ConnectivityResult> results) {
    if (_disposed) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_connectivityDebounce, () {
      if (_disposed) return;
      _connectivity = results.any((value) => value != ConnectivityResult.none)
          ? SyncConnectivity.online
          : SyncConnectivity.offline;
      notifyListeners();
      if (_connectivity == SyncConnectivity.online) kick();
    });
  }

  void kick() => unawaited(_startDrain(bypassBackoff: false));
  Future<void> syncNow() => _startDrain(bypassBackoff: true);

  Future<void> _startDrain({required bool bypassBackoff}) async {
    if (_draining) {
      _rerun = true;
      _bypassOnRerun = _bypassOnRerun || bypassBackoff;
      return;
    }
    _draining = true;
    notifyListeners();
    try {
      var bypass = bypassBackoff;
      do {
        _rerun = false;
        final items = await _repository.queueForDrain(
          now: _now().toUtc(),
          bypassBackoff: bypass,
        );
        for (final item in items) {
          if (!await _replay(item)) break;
        }
        bypass = _bypassOnRerun;
        _bypassOnRerun = false;
      } while (_rerun);
    } finally {
      _draining = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> _replay(SafetyOutboxItemRecord item) async {
    try {
      final payload = jsonDecode(item.row.payload) as Map<String, dynamic>;
      final SafetyReportDetail detail;
      if (item.row.mutationType == 'create') {
        final request = standardSerializers.deserializeWith(
          CreateSafetyReportRequest.serializer,
          payload,
        )!;
        detail = await _api.createSafetyReport(request);
      } else if (item.row.mutationType == 'update_action') {
        final actionId = item.row.targetId;
        if (actionId == null) throw StateError('Action mutation has no target');
        final request = standardSerializers.deserializeWith(
          UpdateCorrectiveActionRequest.serializer,
          payload,
        )!;
        detail = await _api.updateSafetyCorrectiveAction(
          item.row.reportId,
          actionId,
          request,
        );
      } else {
        throw StateError(
            'Unsupported safety mutation ${item.row.mutationType}');
      }
      await _repository.applyMutationSuccess(item, detail);
      return true;
    } on ApiException catch (error) {
      if (error.code == 'safety_report_id_conflict') {
        try {
          final detail = await _api.getSafetyReport(item.row.reportId);
          await _repository.applyCreateSuccess(item, detail);
          return true;
        } on ApiException {
          // Treat an unreadable duplicate as transient; never discard content.
        }
      }
      if (error.code == 'network_error' ||
          error.code == 'request_cancelled' ||
          error.code == 'safety_report_id_conflict') {
        await _repository.markTransientFailure(
          item,
          message: error.message,
          nextAttemptAt: _now().toUtc().add(_backoffFor(item.row.attempts)),
        );
        return false;
      }
      await _repository.markPermanentError(item, message: error.message);
      return true;
    }
  }

  static Duration _backoffFor(int attempts) {
    final multiplier = 1 << attempts.clamp(0, 6);
    return Duration(seconds: (30 * multiplier).clamp(30, 1800));
  }

  @override
  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    _periodicTimer.cancel();
    unawaited(_connectivitySubscription.cancel());
    _repository.removeListener(_recomputeCount);
    super.dispose();
  }
}

class SafetySyncProvider extends InheritedNotifier<SafetySyncEngine> {
  const SafetySyncProvider({
    required SafetySyncEngine engine,
    required this.repository,
    required super.child,
    super.key,
  }) : super(notifier: engine);

  final LocalSafetyReportsRepository repository;

  static SafetySyncEngine engineOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SafetySyncProvider>()!
      .notifier!;

  static LocalSafetyReportsRepository repositoryOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SafetySyncProvider>()!
          .repository;

  @override
  bool updateShouldNotify(SafetySyncProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
