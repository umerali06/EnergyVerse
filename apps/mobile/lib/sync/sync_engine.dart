import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../api/api_service.dart';
import '../inspections/local_inspections_repository.dart';
import '../media/local_media_repository.dart';

enum SyncConnectivity { unknown, online, offline }

typedef ConnectivityStreamFactory = Stream<List<ConnectivityResult>> Function();
typedef ConnectivityCheck = Future<List<ConnectivityResult>> Function();

/// Drives the outbox drain loop against [LocalInspectionsRepository]:
/// connectivity-change/app-resume/periodic/manual triggers, a single-flight
/// sequential replay per due row, exponential backoff for transient
/// failures, and last-writer-wins-by-revision conflict detection for
/// `revision_conflict`/`invalid_transition` responses. Mirrors
/// `AuthController`'s `ChangeNotifier` + `InheritedNotifier` shape.
class SyncEngine extends ChangeNotifier {
  SyncEngine({
    required LocalInspectionsRepository repository,
    required ApiContract api,
    LocalMediaRepository? mediaRepository,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
    Duration connectivityDebounce = const Duration(milliseconds: 500),
  })  : _repository = repository,
        _api = api,
        _mediaRepository = mediaRepository,
        _now = now ?? DateTime.now,
        _connectivityDebounce = connectivityDebounce {
    final streamFactory = connectivityStreamFactory ?? (() => Connectivity().onConnectivityChanged);
    _connectivitySubscription = streamFactory().listen(_onConnectivityEvent);
    _periodicTimer = Timer.periodic(periodicInterval, (_) {
      if (_connectivity != SyncConnectivity.offline) kick();
    });
    unawaited(
      (checkConnectivity ?? Connectivity().checkConnectivity)().then(_onConnectivityEvent),
    );
    // A plain ChangeNotifier listener, not `repository.watchOutbox()`: a
    // widget rebuilding its own watch-stream StreamBuilder on every
    // animation tick would subscribe/cancel a fresh Drift query stream each
    // time, and Drift's cancellation defers actual cleanup to a
    // zero-duration Timer -- fine in production, but it makes
    // `flutter_test`'s pending-timer teardown check trip on practically
    // every widget test that mounts the app shell. `repository`'s
    // ChangeNotifier listener list is plain callbacks with no Timer
    // involved, so recomputing the count via one one-shot query per
    // notification avoids that entirely.
    _repository.addListener(_recomputePendingOutboxCount);
    unawaited(_recomputePendingOutboxCount());
  }

  final LocalInspectionsRepository _repository;
  final ApiContract _api;
  final LocalMediaRepository? _mediaRepository;
  final DateTime Function() _now;
  final Duration _connectivityDebounce;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late final Timer _periodicTimer;
  Timer? _debounceTimer;
  bool _disposed = false;

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
    // The debounce timer and the constructor's one-shot initial check can
    // both still be in flight when the widget tree (and this engine) gets
    // disposed mid-test/mid-navigation; without this guard either can
    // create a Timer after dispose() already ran, which nothing then
    // cancels.
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

  /// Call on every trigger that isn't an explicit user action (connectivity
  /// restored, app resumed, periodic fallback). Respects backoff.
  void kick() {
    if (_draining) {
      _rerunKick = true;
      return;
    }
    unawaited(_runDrain(bypassBackoff: false));
  }

  /// The user tapped "Sync now": bypasses backoff (but not a permanently
  /// paused/errored row -- those still need an explicit per-item retry).
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
        final items = await _repository.queueForDrain(now: _now().toUtc(), bypassBackoff: bypass);
        for (final item in items) {
          final keepDrainingOtherInspections = await _replay(item);
          if (!keepDrainingOtherInspections) break;
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

  /// Returns whether the drain loop should keep going to the next row.
  Future<bool> _replay(OutboxItemRecord item) async {
    try {
      final detail = await _dispatch(item);
      await _repository.applyMutationSuccess(item: item, server: detail);
      await _onMutationApplied(item);
      return true;
    } on ApiException catch (error) {
      return _handleError(item, error);
    }
  }

  Future<InspectionDetail> _dispatch(OutboxItemRecord item) {
    final payload = jsonDecode(item.row.payload);
    switch (item.mutationType) {
      case OutboxMutationType.create:
        final request = standardSerializers.deserializeWith(
          CreateInspectionRequest.serializer,
          payload as Map<String, dynamic>,
        )!;
        return _api.createInspection(request);
      case OutboxMutationType.update:
        final request = standardSerializers.deserializeWith(
          UpdateInspectionRequest.serializer,
          payload as Map<String, dynamic>,
        )!;
        return _api.updateInspection(item.inspectionId, request);
      case OutboxMutationType.start:
        return _api.startInspection(item.inspectionId);
      case OutboxMutationType.complete:
        return _api.completeInspection(item.inspectionId);
      case OutboxMutationType.cancel:
        return _api.cancelInspection(item.inspectionId);
      case OutboxMutationType.assignTemplate:
        final request = standardSerializers.deserializeWith(
          AssignChecklistTemplateRequest.serializer,
          payload as Map<String, dynamic>,
        )!;
        return _api.assignChecklistTemplate(item.inspectionId, request);
      case OutboxMutationType.attachMedia:
        final request = standardSerializers.deserializeWith(
          AttachInspectionMediaRequest.serializer,
          payload as Map<String, dynamic>,
        )!;
        return _api.attachInspectionMedia(item.inspectionId, request);
      case OutboxMutationType.editMedia:
        final wrapper = payload as Map<String, dynamic>;
        final request = standardSerializers.deserializeWith(
          UpdateInspectionMediaRequest.serializer,
          wrapper['request'] as Map<String, dynamic>,
        )!;
        return _api.updateInspectionMedia(item.inspectionId, wrapper['media_id'] as String, request);
      case OutboxMutationType.detachMedia:
        final wrapper = payload as Map<String, dynamic>;
        return _api.detachInspectionMedia(item.inspectionId, wrapper['media_id'] as String);
      case OutboxMutationType.createAnnotation:
        final request = standardSerializers.deserializeWith(
          CreateAnnotationRequest.serializer,
          payload as Map<String, dynamic>,
        )!;
        return _api.createInspectionAnnotation(item.inspectionId, request);
      case OutboxMutationType.updateAnnotation:
        final wrapper = payload as Map<String, dynamic>;
        final request = standardSerializers.deserializeWith(
          UpdateAnnotationRequest.serializer,
          wrapper['request'] as Map<String, dynamic>,
        )!;
        return _api.updateInspectionAnnotation(
          item.inspectionId,
          wrapper['annotation_id'] as String,
          request,
        );
      case OutboxMutationType.deleteAnnotation:
        final wrapper = payload as Map<String, dynamic>;
        return _api.deleteInspectionAnnotation(
          item.inspectionId,
          wrapper['annotation_id'] as String,
        );
    }
  }

  /// After a mutation round-trips successfully, `attachMedia` has one extra
  /// step: the local `MediaQueue` row (kept around only for its own
  /// upload-progress UI) is now fully redundant, since `inspection.media[]`
  /// -- just refreshed by `applyMutationSuccess` above -- is the durable
  /// source of truth going forward. `editMedia`/`detachMedia` never leave a
  /// `MediaQueue` row behind in the first place (they only ever target
  /// already-referenced media), so there's nothing to clean up for them.
  Future<void> _onMutationApplied(OutboxItemRecord item) async {
    if (item.mutationType != OutboxMutationType.attachMedia) return;
    final request = standardSerializers.deserializeWith(
      AttachInspectionMediaRequest.serializer,
      jsonDecode(item.row.payload) as Map<String, dynamic>,
    )!;
    await _mediaRepository?.markReferenced(request.localId);
  }

  Future<bool> _handleError(OutboxItemRecord item, ApiException error) async {
    if (error.code == 'network_error' || error.code == 'request_cancelled') {
      await _repository.markTransientFailure(
        item,
        message: error.message,
        nextAttemptAt: _now().toUtc().add(_backoffFor(item.attempts)),
      );
      // A dropped connection would fail every subsequent row identically.
      return false;
    }
    if (error.code == 'revision_conflict' || error.code == 'invalid_transition') {
      return _handleConflictOrInvalidTransition(item, error);
    }
    await _repository.markPermanentError(item, message: error.message);
    return true;
  }

  Future<bool> _handleConflictOrInvalidTransition(OutboxItemRecord item, ApiException error) async {
    final InspectionDetail current;
    try {
      current = await _api.getInspection(item.inspectionId);
    } on ApiException {
      // Couldn't confirm current state either; treat as transient so this
      // gets retried instead of surfacing an unresolvable conflict.
      await _repository.markTransientFailure(
        item,
        message: error.message,
        nextAttemptAt: _now().toUtc().add(_backoffFor(item.attempts)),
      );
      return false;
    }
    if (_alreadyApplied(item, current)) {
      await _repository.applyAlreadyApplied(item: item, server: current);
      return true;
    }
    await _repository.markConflict(inspectionId: item.inspectionId, serverSnapshot: current);
    return true;
  }

  /// True when the server's current state already matches exactly what this
  /// mutation was trying to set -- i.e. an earlier attempt actually
  /// succeeded before the app died mid-request, and this is a replay of
  /// that same attempt rather than a real conflict.
  bool _alreadyApplied(OutboxItemRecord item, InspectionDetail current) {
    switch (item.mutationType) {
      case OutboxMutationType.create:
        return false;
      case OutboxMutationType.start:
        return current.status.name == 'inProgress';
      case OutboxMutationType.complete:
        return current.status.name == 'completed';
      case OutboxMutationType.cancel:
        return current.status.name == 'cancelled';
      case OutboxMutationType.update:
        final request = standardSerializers.deserializeWith(
          UpdateInspectionRequest.serializer,
          jsonDecode(item.row.payload) as Map<String, dynamic>,
        )!;
        return (request.title == null || request.title == current.title) &&
            (request.notes == null || request.notes == current.notes) &&
            (request.gpsLat == null || request.gpsLat == current.gpsLat) &&
            (request.gpsLng == null || request.gpsLng == current.gpsLng) &&
            (request.inspectionType == null ||
                request.inspectionType!.name == current.inspectionType.name) &&
            // `updateInspection` always populates checklistResponses (never
            // null, defaulting to an empty list), so treat null and empty
            // the same on both sides rather than skip the comparison.
            listEquals(
              request.checklistResponses?.toList() ?? const [],
              current.checklistResponses?.toList() ?? const [],
            );
      case OutboxMutationType.assignTemplate:
        final request = standardSerializers.deserializeWith(
          AssignChecklistTemplateRequest.serializer,
          jsonDecode(item.row.payload) as Map<String, dynamic>,
        )!;
        return current.checklistTemplateId == request.checklistTemplateId;
      // attachMedia/editMedia/detachMedia/*Annotation never carry
      // `expected_revision` and the backend is idempotent-by-`local_id`/
      // `media_id`/`annotation_id` for all of them, so they can only ever
      // fully succeed or fail outright -- structurally, `_handleError`
      // never routes a `revision_conflict`/`invalid_transition` code to
      // this method for these mutation types. These cases exist only to
      // satisfy Dart's exhaustive-switch check; don't "helpfully" replace
      // `true` with real comparison logic.
      case OutboxMutationType.attachMedia:
      case OutboxMutationType.editMedia:
      case OutboxMutationType.detachMedia:
      case OutboxMutationType.createAnnotation:
      case OutboxMutationType.updateAnnotation:
      case OutboxMutationType.deleteAnnotation:
        return true;
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

class SyncProvider extends InheritedNotifier<SyncEngine> {
  const SyncProvider({
    required SyncEngine engine,
    required this.repository,
    required super.child,
    super.key,
  }) : super(notifier: engine);

  final LocalInspectionsRepository repository;

  static SyncEngine engineOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<SyncProvider>();
    assert(provider != null, 'SyncProvider is required');
    return provider!.notifier!;
  }

  static LocalInspectionsRepository repositoryOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<SyncProvider>();
    assert(provider != null, 'SyncProvider is required');
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(SyncProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
