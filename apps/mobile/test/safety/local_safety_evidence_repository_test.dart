import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/safety/local_safety_evidence_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late LocalSafetyEvidenceRepository repository;
  late Directory temporaryDirectory;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repository = LocalSafetyEvidenceRepository(db: db);
    temporaryDirectory = await Directory.systemTemp.createTemp('fev-safety-');
  });

  tearDown(() async {
    repository.dispose();
    await db.close();
    await temporaryDirectory.delete(recursive: true);
  });

  test('validates real file metadata before durable enqueue', () async {
    final file =
        File('${temporaryDirectory.path}${Platform.pathSeparator}evidence.jpg');
    await file.writeAsBytes([1, 2, 3, 4]);

    final id = await repository.enqueue(
      reportId: 'report-1',
      kind: 'photo',
      localFilePath: file.path,
      filename: 'evidence.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 4,
    );
    final queued = await db.select(db.safetyEvidenceQueue).getSingle();

    expect(queued.localId, id);
    expect(queued.localFilePath, file.path);
    expect(queued.state, 'pending');
    expect(
      () => repository.enqueue(
        reportId: 'report-1',
        kind: 'photo',
        localFilePath: file.path,
        filename: 'evidence.jpg',
        contentType: 'application/octet-stream',
        sizeBytes: 4,
      ),
      throwsArgumentError,
    );
  });

  test('does not upload evidence until its offline report is synced', () async {
    final file =
        File('${temporaryDirectory.path}${Platform.pathSeparator}clip.mp4');
    await file.writeAsBytes([1, 2, 3]);
    final now = DateTime.utc(2026, 8, 16);
    await db.into(db.localSafetyReports).insert(
          LocalSafetyReportsCompanion.insert(
            id: 'report-1',
            category: 'near_miss',
            severity: 'medium',
            title: 'Dropped object',
            description: 'Tool dropped within an exclusion zone.',
            occurredAt: now,
            reporterId: 'inspector-1',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await repository.enqueue(
      reportId: 'report-1',
      kind: 'video',
      localFilePath: file.path,
      filename: 'clip.mp4',
      contentType: 'video/mp4',
      sizeBytes: 3,
    );

    expect(await repository.readyForUpload(now), isEmpty);
    await (db.update(db.localSafetyReports)
          ..where((row) => row.id.equals('report-1')))
        .write(const LocalSafetyReportsCompanion(
      syncState: Value('synced'),
    ));
    expect(await repository.readyForUpload(now), hasLength(1));
  });
}
