import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import '../sync/sync_engine.dart'
    show ConnectivityCheck, ConnectivityStreamFactory;
import 'local_safety_evidence_repository.dart';
import 'local_safety_reports_repository.dart';

class SafetyEvidenceUploadWorker extends ChangeNotifier {
  SafetyEvidenceUploadWorker({
    required LocalSafetyEvidenceRepository evidenceRepository,
    required LocalSafetyReportsRepository reportsRepository,
    required SafetyApiContract api,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
  })  : _evidenceRepository = evidenceRepository,
        _reportsRepository = reportsRepository,
        _api = api,
        _now = now ?? DateTime.now {
    _subscription = (connectivityStreamFactory ??
            (() => Connectivity().onConnectivityChanged))()
        .listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) kick();
    });
    _timer = Timer.periodic(periodicInterval, (_) => kick());
    unawaited((checkConnectivity ?? Connectivity().checkConnectivity)().then(
      (results) {
        if (results.any((result) => result != ConnectivityResult.none)) kick();
      },
    ));
  }

  final LocalSafetyEvidenceRepository _evidenceRepository;
  final LocalSafetyReportsRepository _reportsRepository;
  final SafetyApiContract _api;
  final DateTime Function() _now;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  late final Timer _timer;
  bool _running = false;
  bool _disposed = false;

  bool get isRunning => _running;

  void kick() {
    if (!_running) unawaited(_drain());
  }

  Future<void> _drain() async {
    _running = true;
    _notify();
    try {
      final items = await _evidenceRepository.readyForUpload(_now().toUtc());
      for (final item in items) {
        await _evidenceRepository.markUploading(item.row.localId);
        try {
          final detail = await _api.uploadSafetyEvidence(
            reportId: item.row.reportId,
            kind: item.row.kind,
            path: item.row.localFilePath,
            filename: item.row.filename,
          );
          await _evidenceRepository.markSuccess(item.row.localId);
          await _reportsRepository.applyServerSnapshot(detail);
        } on ApiException catch (error) {
          final transient = error.code == 'network_error' ||
              error.code == 'request_cancelled' ||
              (error.statusCode != null && error.statusCode! >= 500);
          await _evidenceRepository.markFailure(
            item,
            message: error.message,
            nextAttemptAt: _now().toUtc().add(_backoff(item.row.attempts)),
            permanent: !transient,
          );
          if (transient) break;
        }
      }
    } finally {
      _running = false;
      _notify();
    }
  }

  static Duration _backoff(int attempts) =>
      Duration(seconds: (30 * (1 << attempts.clamp(0, 6))).clamp(30, 1800));

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer.cancel();
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

class SafetyEvidenceProvider
    extends InheritedNotifier<SafetyEvidenceUploadWorker> {
  const SafetyEvidenceProvider({
    required SafetyEvidenceUploadWorker worker,
    required this.repository,
    required super.child,
    super.key,
  }) : super(notifier: worker);

  final LocalSafetyEvidenceRepository repository;

  static SafetyEvidenceUploadWorker workerOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SafetyEvidenceProvider>()!
      .notifier!;

  static LocalSafetyEvidenceRepository repositoryOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SafetyEvidenceProvider>()!
          .repository;

  @override
  bool updateShouldNotify(SafetyEvidenceProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
