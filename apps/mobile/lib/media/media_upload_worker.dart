import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseException;
import 'package:flutter/widgets.dart';

import '../inspections/local_inspections_repository.dart';
import '../sync/sync_engine.dart' show ConnectivityCheck, ConnectivityStreamFactory, SyncConnectivity;
import 'local_media_repository.dart';
import 'media_uploader.dart';

/// Firebase Storage error codes this worker treats as retryable (a dropped
/// connection, a transient server hiccup) rather than a fundamentally broken
/// request. Everything else (permission-denied, an invalid path, a quota
/// error) is paused instead of endlessly retried -- mirrors `SyncEngine`'s
/// transient-vs-permanent split for the inspection outbox.
const _transientStorageErrorCodes = {
  'retry-limit-exceeded',
  'unknown',
  'server-file-wrong-size',
  'cancelled',
};

/// Drives the media-upload drain loop against [LocalMediaRepository],
/// entirely SEPARATE from [SyncEngine]/the inspection outbox (Phase 7.4's
/// central design constraint: heavy media bytes must never share a drain
/// loop with lightweight inspection-record sync). Mirrors `SyncEngine`'s
/// trigger shape (connectivity-change/app-resume/periodic/manual) and
/// backoff formula, but drains [LocalMediaRepository]'s `MediaQueue` table
/// and uploads directly to Firebase Storage via `putFile`'s resumable
/// protocol, one file at a time.
class MediaUploadWorker extends ChangeNotifier {
  MediaUploadWorker({
    required LocalMediaRepository mediaRepository,
    required LocalInspectionsRepository inspectionsRepository,
    MediaUploader? uploader,
    ConnectivityStreamFactory? connectivityStreamFactory,
    ConnectivityCheck? checkConnectivity,
    DateTime Function()? now,
    Duration periodicInterval = const Duration(minutes: 2),
    Duration connectivityDebounce = const Duration(milliseconds: 500),
  })  : _mediaRepository = mediaRepository,
        _inspectionsRepository = inspectionsRepository,
        _uploader = uploader ?? FirebaseMediaUploader(),
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
    _mediaRepository.addListener(_recomputePendingCount);
    unawaited(_recomputePendingCount());
  }

  final LocalMediaRepository _mediaRepository;
  final LocalInspectionsRepository _inspectionsRepository;
  final MediaUploader _uploader;
  final DateTime Function() _now;
  final Duration _connectivityDebounce;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late final Timer _periodicTimer;
  Timer? _debounceTimer;
  bool _disposed = false;

  SyncConnectivity _connectivity = SyncConnectivity.unknown;
  SyncConnectivity get connectivity => _connectivity;

  int pendingCount = 0;

  bool _draining = false;
  bool get isDraining => _draining;
  bool _rerunKick = false;
  bool _rerunSyncNow = false;

  Future<void> _recomputePendingCount() async {
    final due = await _mediaRepository.dueForUpload(now: _now().toUtc(), bypassBackoff: true);
    if (_disposed) return;
    pendingCount = due.length;
    _notify();
  }

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

  /// Call on every non-user-initiated trigger (connectivity restored, app
  /// resumed, periodic fallback). Respects backoff.
  void kick() {
    if (_draining) {
      _rerunKick = true;
      return;
    }
    unawaited(_runDrain(bypassBackoff: false));
  }

  /// An explicit user action ("sync now" / "retry"): bypasses backoff but
  /// not a permanently paused row.
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
        final items = await _mediaRepository.dueForUpload(now: _now().toUtc(), bypassBackoff: bypass);
        for (final item in items) {
          await _uploadOne(item);
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
      await _recomputePendingCount();
    }
  }

  /// Uploads the bytes (skipped if this row is already `uploaded` -- see
  /// below) then registers the reference. The two steps are deliberately
  /// NOT sharing one try/catch: a failure registering the reference is a
  /// local DB error, not an upload failure, and must never revert an
  /// already-successful upload back to `failed` -- that would force a
  /// pointless full re-upload of bytes that are already sitting in Storage
  /// just because the follow-up local write hiccuped.
  Future<void> _uploadOne(MediaQueueRecord item) async {
    if (item.uploadState != MediaUploadState.uploaded) {
      try {
        await _mediaRepository.markUploading(item.localId, 0);
        final upload = _uploader.upload(item.storagePath, File(item.localFilePath), item.contentType);
        _mediaRepository.registerUpload(item.localId, upload);
        final subscription = upload.bytesTransferred.listen((bytesTransferred) {
          unawaited(_mediaRepository.markUploading(item.localId, bytesTransferred));
        });
        try {
          await upload.done;
        } finally {
          await subscription.cancel();
        }
        await _mediaRepository.markUploaded(item.localId);
      } on FirebaseException catch (error) {
        await _handleUploadError(item, error.code, error.message ?? error.code);
        return;
      } catch (error) {
        await _handleUploadError(item, 'unknown', error.toString());
        return;
      }
    }
    try {
      await _registerReference(item);
    } catch (_) {
      // The file is already up; this retries automatically next drain pass
      // since `dueForUpload` reconsiders `uploaded` rows too (see its doc).
    }
  }

  Future<void> _handleUploadError(MediaQueueRecord item, String code, String message) async {
    final transient = _transientStorageErrorCodes.contains(code);
    await _mediaRepository.markFailed(
      item.localId,
      message: message,
      nextAttemptAt: transient ? _now().toUtc().add(_backoffFor(item.attempts)) : pausedSentinel,
    );
  }

  /// Registers the small metadata reference onto the *inspection* outbox
  /// (Phase 7.2's existing machinery) now that the bytes are up -- this is
  /// the "small reference, not the bytes" sync path. A voice note (Phase
  /// 7.6, `kind == 'audio'`) registers onto `inspection.voiceNotes[]`
  /// instead of `media[]` -- same queue/worker, different reference shape.
  Future<void> _registerReference(MediaQueueRecord item) async {
    if (item.kind == 'audio') {
      final request = AttachVoiceNoteRequest(
        (b) => b
          ..localId = item.localId
          ..filename = item.filename
          ..contentType = item.contentType
          ..size = item.sizeBytes
          ..durationMs = item.durationMs ?? 0
          ..checklistItemId = item.checklistItemId,
      );
      await _inspectionsRepository.enqueueAttachVoiceNote(
        inspectionId: item.inspectionId,
        request: request,
      );
      return;
    }
    final request = AttachInspectionMediaRequest(
      (b) => b
        ..localId = item.localId
        ..filename = item.filename
        ..kind = AttachInspectionMediaRequestKindEnum.valueOf(item.kind)
        ..contentType = item.contentType
        ..size = item.sizeBytes
        ..gpsLat = item.gpsLat
        ..gpsLng = item.gpsLng
        // Drift's DateTimeColumn round-trips a stored instant back as a
        // LOCAL-flagged DateTime (same real instant, `isUtc: false`) even
        // though it was written as UTC -- built_value's JSON serializer
        // requires a strictly UTC-flagged DateTime, so this must be
        // re-flagged (not re-converted; `.toUtc()` on an already-correct
        // instant is a no-op on the value, only the flag changes).
        ..capturedAt = item.capturedAt.toUtc()
        ..checklistItemId = item.checklistItemId
        ..beforeAfterTag = item.beforeAfterTag == null
            ? null
            : AttachInspectionMediaRequestBeforeAfterTagEnum.valueOf(item.beforeAfterTag!),
    );
    await _inspectionsRepository.enqueueAttachMedia(
      inspectionId: item.inspectionId,
      request: request,
    );
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
    _mediaRepository.removeListener(_recomputePendingCount);
    super.dispose();
  }
}

/// Threads [MediaUploadWorker]/[LocalMediaRepository] into the widget tree,
/// mirroring `SyncProvider`'s shape but kept as its own distinct
/// `InheritedNotifier` -- deliberately not folded into `SyncProvider`, so
/// the separate-queue design is visible at the widget-tree level too.
class MediaProvider extends InheritedNotifier<MediaUploadWorker> {
  const MediaProvider({
    required MediaUploadWorker worker,
    required this.repository,
    required super.child,
    super.key,
  }) : super(notifier: worker);

  final LocalMediaRepository repository;

  static MediaUploadWorker workerOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<MediaProvider>();
    assert(provider != null, 'MediaProvider is required');
    return provider!.notifier!;
  }

  static LocalMediaRepository repositoryOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<MediaProvider>();
    assert(provider != null, 'MediaProvider is required');
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(MediaProvider oldWidget) =>
      oldWidget.notifier != notifier || oldWidget.repository != repository;
}
