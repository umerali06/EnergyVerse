import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../inspections/local_inspections_repository.dart' show pausedSentinel;
import 'media_uploader.dart';

/// `queued | uploading | uploaded | referenced | failed` -- mirrors
/// [LocalSyncState]'s wire-value convention, but for a [MediaQueueData] row.
enum MediaUploadState {
  queued('queued'),
  uploading('uploading'),
  uploaded('uploaded'),
  referenced('referenced'),
  failed('failed');

  const MediaUploadState(this.wireValue);

  final String wireValue;

  static MediaUploadState fromWire(String value) => values.firstWhere(
        (state) => state.wireValue == value,
        orElse: () => MediaUploadState.failed,
      );
}

/// A queued media item, for the capture gallery.
class MediaQueueRecord {
  MediaQueueRecord(this.row);

  final MediaQueueData row;

  String get localId => row.localId;
  String get inspectionId => row.inspectionId;
  String? get checklistItemId => row.checklistItemId;
  String get kind => row.kind;
  String get localFilePath => row.localFilePath;
  String get storagePath => row.storagePath;
  String get filename => row.filename;
  String get contentType => row.contentType;
  int get sizeBytes => row.sizeBytes;
  double? get gpsLat => row.gpsLat;
  double? get gpsLng => row.gpsLng;
  DateTime get capturedAt => row.capturedAt;
  String? get beforeAfterTag => row.beforeAfterTag;
  MediaUploadState get uploadState => MediaUploadState.fromWire(row.uploadState);
  int get uploadedBytes => row.uploadedBytes;
  int get attempts => row.attempts;
  String? get lastError => row.lastError;
  DateTime? get nextAttemptAt => row.nextAttemptAt;
}

/// Computes the Storage object path a media capture will upload to --
/// deterministic and computable entirely offline at capture time, mirroring
/// `InspectionMediaStorage.object_path()` on the backend
/// (`apps/api/app/storage/service.py`) field-for-field so the two never
/// disagree on where a given `local_id`/`filename` pair lives.
String inspectionMediaStoragePath({
  required String companyId,
  required String inspectionId,
  required String localId,
  required String filename,
}) {
  final safeName = p.basename(filename).replaceAll(' ', '_');
  return 'companies/$companyId/inspections/$inspectionId/media/${localId}_$safeName';
}

/// The pending-media-upload facade over the local Drift [MediaQueue] table
/// (Phase 7.4) -- deliberately separate from [LocalInspectionsRepository]'s
/// [Outbox]-backed API: media bytes are heavy and must never share a drain
/// loop or transaction with the lightweight inspection-record sync. Extends
/// [ChangeNotifier] for the same reason [LocalInspectionsRepository] does
/// (see its own constructor doc) -- a plain listener list `MediaUploadWorker`
/// and the gallery UI can observe without holding a live Drift stream open.
class LocalMediaRepository extends ChangeNotifier {
  LocalMediaRepository({required AppDatabase db, Uuid? uuid, MediaUploader? uploader})
      : _db = db,
        _uuid = uuid ?? const Uuid(),
        _uploader = uploader ?? FirebaseMediaUploader();

  final AppDatabase _db;
  final Uuid _uuid;
  final MediaUploader _uploader;

  /// In-flight [MediaUpload]s keyed by `localId`, so [removeBeforeSync] can
  /// cancel an upload that's actively in progress. Not persisted -- an
  /// upload in flight when the app is killed simply resumes as a fresh
  /// whole-file upload on the next drain (D-0xx: resumability is Firebase
  /// Storage's own within-session protocol, not custom cross-restart resume).
  final Map<String, MediaUpload> _activeUploads = {};

  // ---------------------------------------------------------------- reads

  Stream<List<MediaQueueRecord>> watchMediaForInspection(String inspectionId) {
    final query = _db.select(_db.mediaQueue)
      ..where((t) => t.inspectionId.equals(inspectionId))
      ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(MediaQueueRecord.new).toList());
  }

  Future<int> pendingCountForInspection(String inspectionId) async {
    final rows = await (_db.select(_db.mediaQueue)
          ..where(
            (t) =>
                t.inspectionId.equals(inspectionId) &
                t.uploadState.isNotValue(MediaUploadState.referenced.wireValue),
          ))
        .get();
    return rows.length;
  }

  // --------------------------------------------------------------- writes

  /// Inserts a `queued` row for a fresh capture/gallery-pick and returns its
  /// `localId`. [companyId] is the signed-in user's own company (the caller
  /// reads it off `AuthController.currentUser`) -- this repository never
  /// reaches into auth state itself.
  Future<String> enqueueCapture({
    required String companyId,
    required String inspectionId,
    required String kind,
    required String localFilePath,
    required String filename,
    required String contentType,
    required int sizeBytes,
    double? gpsLat,
    double? gpsLng,
    required DateTime capturedAt,
    String? checklistItemId,
    String? beforeAfterTag,
  }) async {
    final localId = _uuid.v4();
    final storagePath = inspectionMediaStoragePath(
      companyId: companyId,
      inspectionId: inspectionId,
      localId: localId,
      filename: filename,
    );
    await _db.into(_db.mediaQueue).insert(
          MediaQueueCompanion.insert(
            localId: localId,
            inspectionId: inspectionId,
            checklistItemId: drift.Value(checklistItemId),
            kind: kind,
            localFilePath: localFilePath,
            storagePath: storagePath,
            filename: filename,
            contentType: contentType,
            sizeBytes: sizeBytes,
            gpsLat: drift.Value(gpsLat),
            gpsLng: drift.Value(gpsLng),
            capturedAt: capturedAt,
            beforeAfterTag: drift.Value(beforeAfterTag),
            createdAt: DateTime.now().toUtc(),
          ),
        );
    notifyListeners();
    return localId;
  }

  /// Updates the before/after tag on a not-yet-uploaded local row. Once a
  /// media item has synced (no `MediaQueue` row left), retagging goes
  /// through `LocalInspectionsRepository.enqueueEditMedia` instead.
  Future<void> setBeforeAfterTag(String localId, String? tag) async {
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      MediaQueueCompanion(beforeAfterTag: drift.Value(tag)),
    );
    notifyListeners();
  }

  Future<void> setChecklistItemId(String localId, String? checklistItemId) async {
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      MediaQueueCompanion(checklistItemId: drift.Value(checklistItemId)),
    );
    notifyListeners();
  }

  /// Removes a not-yet-(fully-)synced item: cancels any in-flight upload,
  /// best-effort deletes the Storage object if bytes made it up, deletes the
  /// local file, and drops the row. Never touches the outbox -- nothing was
  /// ever registered server-side for a row still in `MediaQueue`.
  Future<void> removeBeforeSync(String localId) async {
    final row = await (_db.select(_db.mediaQueue)..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
    if (row == null) return;

    final upload = _activeUploads.remove(localId);
    if (upload != null) {
      try {
        await upload.cancel();
      } catch (_) {
        // Already completed/failed; nothing to cancel.
      }
    }
    if (row.uploadState == MediaUploadState.uploaded.wireValue ||
        row.uploadState == MediaUploadState.uploading.wireValue) {
      try {
        await _uploader.delete(row.storagePath);
      } catch (_) {
        // Best-effort; an orphaned blob under an unreferenced path is harmless.
      }
    }
    try {
      final file = File(row.localFilePath);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort local cleanup.
    }
    await (_db.delete(_db.mediaQueue)..where((t) => t.localId.equals(localId))).go();
    notifyListeners();
  }

  // ------------------------------------------------------ upload-worker API

  /// Due rows, oldest-first -- mirrors
  /// `LocalInspectionsRepository.queueForDrain`'s backoff-window shape,
  /// including the [pausedSentinel] convention: `bypassBackoff` (manual
  /// "sync now") skips an active backoff wait but still respects a
  /// permanently-paused row, which needs an explicit [retryMediaItem] call.
  /// Also includes `uploaded` rows -- a row can be stuck there if the bytes
  /// made it to Storage but registering the small metadata reference
  /// failed (a local DB error); `MediaUploadWorker` skips re-uploading a
  /// row already in that state and only retries the reference step.
  Future<List<MediaQueueRecord>> dueForUpload({
    required DateTime now,
    bool bypassBackoff = false,
  }) async {
    final query = _db.select(_db.mediaQueue)
      ..where(
        (t) =>
            t.uploadState.equals(MediaUploadState.queued.wireValue) |
            t.uploadState.equals(MediaUploadState.failed.wireValue) |
            t.uploadState.equals(MediaUploadState.uploaded.wireValue),
      )
      ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]);
    if (bypassBackoff) {
      query.where(
        (t) => t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerThanValue(pausedSentinel),
      );
    } else {
      query.where((t) => t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerOrEqualValue(now));
    }
    final rows = await query.get();
    return rows.map(MediaQueueRecord.new).toList();
  }

  /// Clears backoff/pause so the next drain pass picks this row up
  /// immediately -- mirrors `LocalInspectionsRepository.retryOutboxItem`.
  Future<void> retryMediaItem(String localId) async {
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      const MediaQueueCompanion(nextAttemptAt: drift.Value(null)),
    );
    notifyListeners();
  }

  void registerUpload(String localId, MediaUpload upload) {
    _activeUploads[localId] = upload;
  }

  Future<void> markUploading(String localId, int uploadedBytes) async {
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      MediaQueueCompanion(
        uploadState: drift.Value(MediaUploadState.uploading.wireValue),
        uploadedBytes: drift.Value(uploadedBytes),
      ),
    );
    notifyListeners();
  }

  Future<void> markUploaded(String localId) async {
    _activeUploads.remove(localId);
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      MediaQueueCompanion(uploadState: drift.Value(MediaUploadState.uploaded.wireValue)),
    );
    notifyListeners();
  }

  Future<void> markFailed(
    String localId, {
    required String message,
    required DateTime nextAttemptAt,
  }) async {
    _activeUploads.remove(localId);
    final row =
        await (_db.select(_db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingle();
    await (_db.update(_db.mediaQueue)..where((t) => t.localId.equals(localId))).write(
      MediaQueueCompanion(
        uploadState: drift.Value(MediaUploadState.failed.wireValue),
        attempts: drift.Value(row.attempts + 1),
        lastError: drift.Value(message),
        nextAttemptAt: drift.Value(nextAttemptAt),
      ),
    );
    notifyListeners();
  }

  /// The corresponding server-side reference is now live in
  /// `inspection.media[]` (an `attach_media` outbox row round-tripped
  /// successfully) -- the local queue row is fully redundant, so it's
  /// deleted rather than marked `referenced` and kept around.
  Future<void> markReferenced(String localId) async {
    _activeUploads.remove(localId);
    await (_db.delete(_db.mediaQueue)..where((t) => t.localId.equals(localId))).go();
    notifyListeners();
  }
}
