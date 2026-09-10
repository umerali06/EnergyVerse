import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../db/app_database.dart';

const int safetyPhotoMaxBytes = 10 * 1024 * 1024;
const int safetyVideoMaxBytes = 250 * 1024 * 1024;
const Set<String> safetyPhotoContentTypes = {'image/jpeg', 'image/png'};
const Set<String> safetyVideoContentTypes = {'video/mp4', 'video/quicktime'};

class SafetyEvidenceQueueRecord {
  const SafetyEvidenceQueueRecord(this.row);
  final SafetyEvidenceQueueData row;
}

class LocalSafetyEvidenceRepository extends ChangeNotifier {
  LocalSafetyEvidenceRepository({required AppDatabase db, Uuid? uuid})
      : _db = db,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  Stream<List<SafetyEvidenceQueueRecord>> watchForReport(String reportId) =>
      (_db.select(_db.safetyEvidenceQueue)
            ..where((row) => row.reportId.equals(reportId))
            ..orderBy([(row) => drift.OrderingTerm.desc(row.createdAt)]))
          .watch()
          .map((rows) => rows.map(SafetyEvidenceQueueRecord.new).toList());

  Future<String> importCapture({
    required String reportId,
    required String kind,
    required String sourcePath,
    required String filename,
    required String contentType,
  }) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw ArgumentError.value(sourcePath, 'sourcePath', 'File not found');
    }
    final size = await source.length();
    _validate(kind: kind, contentType: contentType, sizeBytes: size);
    final localId = _uuid.v4();
    final root = await getApplicationDocumentsDirectory();
    final directory =
        Directory(path.join(root.path, 'safety_evidence', reportId));
    await directory.create(recursive: true);
    final safeFilename = filename.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final destination = path.join(directory.path, '${localId}_$safeFilename');
    await source.copy(destination);
    try {
      await _insert(
        localId: localId,
        reportId: reportId,
        kind: kind,
        localFilePath: destination,
        filename: safeFilename,
        contentType: contentType,
        sizeBytes: size,
      );
    } catch (_) {
      final copied = File(destination);
      if (await copied.exists()) await copied.delete();
      rethrow;
    }
    return localId;
  }

  Future<String> enqueue({
    required String reportId,
    required String kind,
    required String localFilePath,
    required String filename,
    required String contentType,
    required int sizeBytes,
  }) async {
    _validate(kind: kind, contentType: contentType, sizeBytes: sizeBytes);
    final file = File(localFilePath);
    if (!await file.exists()) {
      throw ArgumentError.value(
          localFilePath, 'localFilePath', 'File not found');
    }
    final actualSize = await file.length();
    if (actualSize != sizeBytes) {
      throw ArgumentError('Evidence size changed before it could be queued');
    }
    final localId = _uuid.v4();
    await _insert(
      localId: localId,
      reportId: reportId,
      kind: kind,
      localFilePath: localFilePath,
      filename: filename,
      contentType: contentType,
      sizeBytes: sizeBytes,
    );
    return localId;
  }

  Future<void> _insert({
    required String localId,
    required String reportId,
    required String kind,
    required String localFilePath,
    required String filename,
    required String contentType,
    required int sizeBytes,
  }) async {
    await _db.into(_db.safetyEvidenceQueue).insert(
          SafetyEvidenceQueueCompanion.insert(
            localId: localId,
            reportId: reportId,
            kind: kind,
            localFilePath: localFilePath,
            filename: filename,
            contentType: contentType,
            sizeBytes: sizeBytes,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    notifyListeners();
  }

  void _validate({
    required String kind,
    required String contentType,
    required int sizeBytes,
  }) {
    final allowed = switch (kind) {
      'photo' => safetyPhotoContentTypes,
      'video' => safetyVideoContentTypes,
      _ => throw ArgumentError.value(kind, 'kind', 'Unsupported evidence kind'),
    };
    if (!allowed.contains(contentType)) {
      throw ArgumentError.value(
          contentType, 'contentType', 'Unsupported evidence content type');
    }
    final max = kind == 'photo' ? safetyPhotoMaxBytes : safetyVideoMaxBytes;
    if (sizeBytes <= 0 || sizeBytes > max) {
      throw ArgumentError.value(
          sizeBytes, 'sizeBytes', 'Invalid evidence size');
    }
  }

  Future<List<SafetyEvidenceQueueRecord>> readyForUpload(DateTime now) async {
    final rows = await (_db.select(_db.safetyEvidenceQueue)
          ..where((row) =>
              row.state.equals('pending') &
              (row.nextAttemptAt.isNull() |
                  row.nextAttemptAt.isSmallerOrEqualValue(now)))
          ..orderBy([(row) => drift.OrderingTerm.asc(row.createdAt)]))
        .get();
    final ready = <SafetyEvidenceQueueRecord>[];
    for (final row in rows) {
      final report = await (_db.select(_db.localSafetyReports)
            ..where((candidate) => candidate.id.equals(row.reportId)))
          .getSingleOrNull();
      if (report?.syncState == 'synced') {
        ready.add(SafetyEvidenceQueueRecord(row));
      }
    }
    return ready;
  }

  Future<void> markUploading(String localId) =>
      (_db.update(_db.safetyEvidenceQueue)
            ..where((row) => row.localId.equals(localId)))
          .write(const SafetyEvidenceQueueCompanion(
        state: drift.Value('uploading'),
        lastError: drift.Value(null),
      ));

  Future<void> markSuccess(String localId) async {
    final item = await (_db.select(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(localId)))
        .getSingleOrNull();
    await (_db.delete(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(localId)))
        .go();
    if (item != null) {
      final file = File(item.localFilePath);
      if (await file.exists()) await file.delete();
    }
    notifyListeners();
  }

  Future<void> markFailure(
    SafetyEvidenceQueueRecord item, {
    required String message,
    required DateTime nextAttemptAt,
    bool permanent = false,
  }) async {
    await (_db.update(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(item.row.localId)))
        .write(SafetyEvidenceQueueCompanion(
      state: drift.Value(permanent ? 'error' : 'pending'),
      attempts: drift.Value(item.row.attempts + 1),
      lastAttemptAt: drift.Value(DateTime.now().toUtc()),
      nextAttemptAt:
          drift.Value(permanent ? DateTime.utc(9999) : nextAttemptAt),
      lastError: drift.Value(message),
    ));
    notifyListeners();
  }

  Future<void> retry(String localId) async {
    await (_db.update(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(localId)))
        .write(const SafetyEvidenceQueueCompanion(
      state: drift.Value('pending'),
      nextAttemptAt: drift.Value(null),
      lastError: drift.Value(null),
    ));
    notifyListeners();
  }

  Future<void> discard(String localId) async {
    final item = await (_db.select(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(localId)))
        .getSingleOrNull();
    await (_db.delete(_db.safetyEvidenceQueue)
          ..where((row) => row.localId.equals(localId)))
        .go();
    if (item != null) {
      final file = File(item.localFilePath);
      if (await file.exists()) await file.delete();
    }
    notifyListeners();
  }
}
