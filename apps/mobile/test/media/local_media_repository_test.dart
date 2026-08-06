import 'dart:io';

import 'package:drift/native.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart' show pausedSentinel;
import 'package:fev_mobile/media/local_media_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('fev_local_media_repository_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('inspectionMediaStoragePath mirrors the backend object_path() formula', () {
    final path = inspectionMediaStoragePath(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      localId: 'local-1',
      filename: 'my photo.jpg',
    );
    expect(path, 'companies/acme-energy/inspections/insp-1/media/local-1_my_photo.jpg');
  });

  test('inspectionVoiceNoteStoragePath mirrors the backend voice_object_path() formula', () {
    final path = inspectionVoiceNoteStoragePath(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      localId: 'local-1',
      filename: 'note.m4a',
    );
    expect(path, 'companies/acme-energy/inspections/insp-1/voice/local-1_note.m4a');
  });

  test('enqueueCapture with kind "audio" stores durationMs and the voice/ storage path',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'audio',
      localFilePath: '/tmp/note.m4a',
      filename: 'note.m4a',
      contentType: 'audio/mp4',
      sizeBytes: 5000,
      capturedAt: DateTime.utc(2026, 8, 1, 10),
      durationMs: 42000,
    );

    final row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingle();
    expect(row.kind, 'audio');
    expect(row.durationMs, 42000);
    expect(row.storagePath, 'companies/acme-energy/inspections/insp-1/voice/${localId}_note.m4a');
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('a queued voice recording persists across an app restart', () async {
    final dbFile = File(p.join(tempDir.path, 'voice_restart_test.sqlite'));

    var db = AppDatabase(NativeDatabase(dbFile));
    var repository = LocalMediaRepository(db: db);
    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'audio',
      localFilePath: '/tmp/note.m4a',
      filename: 'note.m4a',
      contentType: 'audio/mp4',
      sizeBytes: 5000,
      capturedAt: DateTime.utc(2026, 1, 1),
      durationMs: 9000,
    );
    // Simulate the app being killed (e.g. offline in airplane mode) with
    // the recording still queued.
    await db.close();

    db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);
    repository = LocalMediaRepository(db: db);
    final rows = await repository.dueForUpload(now: DateTime.utc(2026, 1, 1, 1));
    expect(rows.map((r) => r.localId), [localId]);
    expect(rows.single.durationMs, 9000);
  });

  test('enqueueCapture inserts a queued row in MediaQueue, not Outbox', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/photo.jpg',
      filename: 'photo.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 12345,
      gpsLat: 29.1,
      gpsLng: -95.2,
      capturedAt: DateTime.utc(2026, 8, 1, 10),
    );

    final row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingle();
    expect(row.inspectionId, 'insp-1');
    expect(row.uploadState, 'queued');
    expect(row.storagePath, 'companies/acme-energy/inspections/insp-1/media/${localId}_photo.jpg');
    expect(row.gpsLat, 29.1);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('watchMediaForInspection only returns rows for that inspection', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);

    await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );
    await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-2',
      kind: 'photo',
      localFilePath: '/tmp/b.jpg',
      filename: 'b.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    final rows = await repository.watchMediaForInspection('insp-1').first;
    expect(rows, hasLength(1));
    expect(rows.single.inspectionId, 'insp-1');
  });

  test('removeBeforeSync deletes the local file and the row, and never touches Outbox', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);
    final file = File(p.join(tempDir.path, 'photo.jpg'))..writeAsStringSync('bytes');

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: file.path,
      filename: 'photo.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 5,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    await repository.removeBeforeSync(localId);

    expect(await db.select(db.mediaQueue).get(), isEmpty);
    expect(file.existsSync(), isFalse);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('setBeforeAfterTag and setChecklistItemId update the row in place', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    await repository.setBeforeAfterTag(localId, 'before');
    await repository.setChecklistItemId(localId, 'vibration_normal');

    final row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingle();
    expect(row.beforeAfterTag, 'before');
    expect(row.checklistItemId, 'vibration_normal');
  });

  test('dueForUpload respects the backoff window, and bypassBackoff respects pausedSentinel', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);
    final now = DateTime.utc(2026, 1, 1, 12);

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: now,
    );

    expect(await repository.dueForUpload(now: now), hasLength(1));

    await repository.markFailed(
      localId,
      message: 'network blip',
      nextAttemptAt: now.add(const Duration(minutes: 5)),
    );
    expect(await repository.dueForUpload(now: now), isEmpty);
    expect(
      await repository.dueForUpload(now: now.add(const Duration(minutes: 10))),
      hasLength(1),
    );
    // Manual "sync now" bypasses an ordinary backoff wait.
    expect(await repository.dueForUpload(now: now, bypassBackoff: true), hasLength(1));

    await repository.markFailed(localId, message: 'permission-denied', nextAttemptAt: pausedSentinel);
    // A paused row is skipped even when bypassing ordinary backoff.
    expect(await repository.dueForUpload(now: now, bypassBackoff: true), isEmpty);

    await repository.retryMediaItem(localId);
    expect(await repository.dueForUpload(now: now), hasLength(1));
  });

  test('markReferenced deletes the row -- the synced inspection.media[] is now the source of truth',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalMediaRepository(db: db);

    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );
    await repository.markUploaded(localId);

    await repository.markReferenced(localId);

    expect(await db.select(db.mediaQueue).get(), isEmpty);
  });

  test('a queued capture persists across an app restart', () async {
    final dbFile = File(p.join(tempDir.path, 'restart_test.sqlite'));

    var db = AppDatabase(NativeDatabase(dbFile));
    var repository = LocalMediaRepository(db: db);
    final localId = await repository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );
    // Simulate the app being killed with the capture still queued.
    await db.close();

    db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(db.close);
    repository = LocalMediaRepository(db: db);
    final rows = await repository.dueForUpload(now: DateTime.utc(2026, 1, 1, 1));
    expect(rows.map((r) => r.localId), [localId]);
  });
}
