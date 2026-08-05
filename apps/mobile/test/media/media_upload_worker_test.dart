import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:fev_mobile/media/local_media_repository.dart';
import 'package:fev_mobile/media/media_upload_worker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_media_uploader.dart';
import '../support/fake_sync_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Never fires on its own -- tests drive the worker via `syncNow()`,
  /// mirroring `sync_engine_test.dart`'s own `_buildEngine` convention.
  MediaUploadWorker buildWorker({
    required LocalMediaRepository mediaRepository,
    required LocalInspectionsRepository inspectionsRepository,
    required FakeMediaUploader uploader,
    DateTime Function()? now,
  }) {
    return MediaUploadWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
      connectivityStreamFactory: () => const Stream<List<ConnectivityResult>>.empty(),
      checkConnectivity: () async => [ConnectivityResult.wifi],
      now: now,
      periodicInterval: const Duration(days: 1),
    );
  }

  test('a successful upload marks uploaded and enqueues attach_media onto the inspection outbox',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi();
    final inspectionsRepository = LocalInspectionsRepository(db: db, api: api);
    final mediaRepository = LocalMediaRepository(db: db);
    final uploader = FakeMediaUploader();
    final worker = buildWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
    );
    addTearDown(worker.dispose);

    final localId = await mediaRepository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/photo.jpg',
      filename: 'photo.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 100,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    await worker.syncNow();

    expect(uploader.uploadedPaths, hasLength(1));
    final outbox = await db.select(db.outbox).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.mutationType, 'attach_media');
    expect(outbox.single.inspectionId, 'insp-1');
    final payload = jsonDecode(outbox.single.payload) as Map<String, dynamic>;
    expect(payload['local_id'], localId);
  });

  test('progress events update MediaQueue.uploadedBytes before completion', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi();
    final inspectionsRepository = LocalInspectionsRepository(db: db, api: api);
    final mediaRepository = LocalMediaRepository(db: db);
    late FakeMediaUpload upload;
    final uploader = FakeMediaUploader(
      onUpload: (path, file, contentType) {
        upload = FakeMediaUpload();
        return upload;
      },
    );
    final worker = buildWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
    );
    addTearDown(worker.dispose);

    final localId = await mediaRepository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'video',
      localFilePath: '/tmp/clip.mp4',
      filename: 'clip.mp4',
      contentType: 'video/mp4',
      sizeBytes: 1000,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    final syncFuture = worker.syncNow();
    await Future<void>.delayed(Duration.zero);
    upload.emitProgress(400);
    await Future<void>.delayed(Duration.zero);

    var row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingleOrNull();
    expect(row?.uploadState, 'uploading');
    expect(row?.uploadedBytes, 400);

    upload.complete();
    await syncFuture;

    // The MediaQueue row survives until the attach_media outbox row this
    // worker just enqueued actually round-trips through SyncEngine (a
    // separate engine this test never runs) and calls markReferenced.
    row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingleOrNull();
    expect(row?.uploadState, 'uploaded');
    final outbox = await db.select(db.outbox).get();
    expect(outbox.single.mutationType, 'attach_media');
  });

  test('a retryable Storage error backs off instead of pausing', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi();
    final inspectionsRepository = LocalInspectionsRepository(db: db, api: api);
    final mediaRepository = LocalMediaRepository(db: db);
    final uploader = FakeMediaUploader(
      onUpload: (path, file, contentType) {
        final upload = FakeMediaUpload();
        scheduleMicrotask(() => upload.fail('retry-limit-exceeded', 'temporary'));
        return upload;
      },
    );
    final now = DateTime.utc(2026, 1, 1, 12);
    final worker = buildWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
      now: () => now,
    );
    addTearDown(worker.dispose);

    final localId = await mediaRepository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: now,
    );

    await worker.syncNow();

    final row = await (db.select(db.mediaQueue)..where((t) => t.localId.equals(localId))).getSingle();
    expect(row.uploadState, 'failed');
    expect(row.nextAttemptAt, isNotNull);
    expect(row.nextAttemptAt!.isAfter(now), isTrue);
    // Retryable -- not paused indefinitely.
    expect(await mediaRepository.dueForUpload(now: now.add(const Duration(hours: 1))), hasLength(1));
  });

  test('a non-retryable Storage error pauses the row for manual retry', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi();
    final inspectionsRepository = LocalInspectionsRepository(db: db, api: api);
    final mediaRepository = LocalMediaRepository(db: db);
    final uploader = FakeMediaUploader(
      onUpload: (path, file, contentType) {
        final upload = FakeMediaUpload();
        scheduleMicrotask(() => upload.fail('unauthorized', 'permission denied'));
        return upload;
      },
    );
    final worker = buildWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
    );
    addTearDown(worker.dispose);

    final localId = await mediaRepository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    await worker.syncNow();

    // A bare "sync now" does not retry a paused row.
    expect(await mediaRepository.dueForUpload(now: DateTime.utc(2026, 1, 2), bypassBackoff: true), isEmpty);

    await mediaRepository.retryMediaItem(localId);
    expect(await mediaRepository.dueForUpload(now: DateTime.utc(2026, 1, 1)), hasLength(1));
  });

  test('removeBeforeSync cancels an actively in-flight upload', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi();
    final inspectionsRepository = LocalInspectionsRepository(db: db, api: api);
    final mediaRepository = LocalMediaRepository(db: db);
    late FakeMediaUpload upload;
    final uploader = FakeMediaUploader(
      onUpload: (path, file, contentType) {
        upload = FakeMediaUpload();
        return upload;
      },
    );
    final worker = buildWorker(
      mediaRepository: mediaRepository,
      inspectionsRepository: inspectionsRepository,
      uploader: uploader,
    );
    addTearDown(worker.dispose);

    final localId = await mediaRepository.enqueueCapture(
      companyId: 'acme-energy',
      inspectionId: 'insp-1',
      kind: 'photo',
      localFilePath: '/tmp/a.jpg',
      filename: 'a.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 1,
      capturedAt: DateTime.utc(2026, 1, 1),
    );

    final syncFuture = worker.syncNow();
    await Future<void>.delayed(Duration.zero);

    await mediaRepository.removeBeforeSync(localId);
    expect(upload.cancelled, isTrue);

    upload.fail('cancelled', 'cancelled');
    await syncFuture;

    expect(await db.select(db.mediaQueue).get(), isEmpty);
  });
}
