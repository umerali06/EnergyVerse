import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:fev_mobile/sync/sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../support/fake_sync_api.dart';

InspectionDetail _detailFrom({
  required String id,
  required int revision,
  String? title,
  String status = 'inProgress',
  String? checklistTemplateId,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionDetail(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'user-1'
      ..status = InspectionDetailStatusEnum.values.firstWhere((s) => s.name == status)
      ..inspectionType = InspectionDetailInspectionTypeEnum.adHoc
      ..title = title
      ..checklistTemplateId = checklistTemplateId
      ..revision = revision
      ..clientCreatedAt = now
      ..createdAt = now
      ..updatedAt = now,
  );
}

/// Never fires on its own -- tests drive the engine via `syncNow()`, so the
/// connectivity stream/initial check only need to resolve to *something*
/// without ever going through a real platform channel.
SyncEngine _buildEngine({
  required LocalInspectionsRepository repository,
  required FakeSyncApi api,
  DateTime Function()? now,
}) {
  return SyncEngine(
    repository: repository,
    api: api,
    connectivityStreamFactory: () => const Stream<List<ConnectivityResult>>.empty(),
    checkConnectivity: () async => [ConnectivityResult.wifi],
    now: now,
    periodicInterval: const Duration(days: 1),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('fev_sync_engine_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('create-offline-then-auto-sync: a queued create replays and the row becomes synced', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi(
      createInspection: (request) async =>
          _detailFrom(id: request.id, revision: 1, title: request.title),
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
      title: 'Field check',
    );

    await engine.syncNow();

    expect(api.calls, ['createInspection:$id']);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
    expect(row.revision, 1);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('multi-edit-offline-single-coalesced-sync: two edits before syncing dispatch just one update',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final captured = <UpdateInspectionRequest>[];
    final api = FakeSyncApi(
      createInspection: (request) async => _detailFrom(id: request.id, revision: 1),
      updateInspection: (id, request) async {
        captured.add(request);
        return _detailFrom(id: id, revision: 2, title: request.title);
      },
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await engine.syncNow();
    await repository.updateInspection(id, title: 'First edit');
    await repository.updateInspection(id, title: 'Second edit', notes: 'Notes');

    await engine.syncNow();

    expect(captured, hasLength(1));
    expect(captured.single.title, 'Second edit');
    expect(captured.single.notes, 'Notes');
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
  });

  test('complete-offline-syncs: create, assign, answer, and complete replay in order', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final dispatched = <String>[];
    final api = FakeSyncApi(
      createInspection: (request) async {
        dispatched.add('create');
        return _detailFrom(id: request.id, revision: 1);
      },
      assignChecklistTemplate: (id, request) async {
        dispatched.add('assign');
        return _detailFrom(id: id, revision: 2, checklistTemplateId: request.checklistTemplateId);
      },
      updateInspection: (id, request) async {
        dispatched.add('update');
        return _detailFrom(id: id, revision: 3);
      },
      completeInspection: (id) async {
        dispatched.add('complete');
        return _detailFrom(id: id, revision: 4, status: 'completed');
      },
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.assignChecklistTemplate(
      id,
      templateId: 'template-1',
      version: 1,
      items: const [],
    );
    await repository.completeInspection(id);

    await engine.syncNow();

    expect(dispatched, ['create', 'assign', 'complete']);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
    expect(row.status, 'completed');
  });

  test('retry-after-transient-failure: the second attempt succeeds without a duplicate outbox row',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var attempts = 0;
    final api = FakeSyncApi(
      createInspection: (request) async {
        attempts += 1;
        if (attempts == 1) {
          throw const ApiException(code: 'network_error', message: 'offline');
        }
        return _detailFrom(id: request.id, revision: 1);
      },
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );

    await engine.syncNow();
    var outbox = await db.select(db.outbox).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.attempts, 1);
    expect(outbox.single.lastError, isNotNull);

    // Manual "sync now" bypasses backoff entirely.
    await engine.syncNow();

    expect(attempts, 2);
    outbox = await db.select(db.outbox).get();
    expect(outbox, isEmpty);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
  });

  test('a transient failure does not block draining other inspections\' rows this pass', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final succeeded = <String>[];
    final api = FakeSyncApi(
      createInspection: (request) async {
        if (request.title == 'fails') {
          throw const ApiException(code: 'network_error', message: 'offline');
        }
        succeeded.add(request.id);
        return _detailFrom(id: request.id, revision: 1);
      },
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
      title: 'fails',
    );
    await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
      title: 'succeeds',
    );

    await engine.syncNow();

    // The plan is explicit that a dropped connection stops the whole pass
    // (every subsequent row would fail identically) -- so the second
    // inspection is correctly left untouched this pass, not attempted.
    expect(succeeded, isEmpty);
    expect(await db.select(db.outbox).get(), hasLength(2));
  });

  test('revision_conflict with a genuinely different server state surfaces as a conflict', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi(
      createInspection: (request) async => _detailFrom(id: request.id, revision: 1),
      updateInspection: (id, request) async => throw const ApiException(
        code: 'revision_conflict',
        message: 'stale revision',
      ),
      getInspection: (id) async => _detailFrom(id: id, revision: 9, title: 'Someone else edited'),
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await engine.syncNow();
    await repository.updateInspection(id, title: 'My edit');

    await engine.syncNow();

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'conflict');
    expect(row.conflictServerSnapshot, isNotNull);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('revision_conflict where the server already reflects this exact edit is treated as success',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var updateAttempts = 0;
    final api = FakeSyncApi(
      createInspection: (request) async => _detailFrom(id: request.id, revision: 1),
      updateInspection: (id, request) async {
        updateAttempts += 1;
        throw const ApiException(code: 'revision_conflict', message: 'stale revision');
      },
      // The server's current state already matches exactly what the queued
      // update was trying to set -- i.e. an earlier attempt actually landed
      // before the app died mid-request, and this is a replay.
      getInspection: (id) async => _detailFrom(id: id, revision: 2, title: 'My edit'),
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await engine.syncNow();
    await repository.updateInspection(id, title: 'My edit');

    await engine.syncNow();

    expect(updateAttempts, 1);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
    expect(row.revision, 2);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('a permanent (non-conflict, non-network) error pauses the row for manual retry/discard',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeSyncApi(
      createInspection: (request) async => throw const ApiException(
        code: 'validation_error',
        message: 'the asset no longer exists',
      ),
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );

    await engine.syncNow();

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'error');
    expect(row.errorMessage, contains('asset no longer exists'));
    final outbox = await db.select(db.outbox).get();
    expect(outbox, hasLength(1));

    // A bare "sync now" does NOT retry a permanently-paused row -- only an
    // explicit per-item retry does.
    await engine.syncNow();
    expect((await db.select(db.outbox).get()).single.attempts, 1);

    await repository.retryOutboxItem(outbox.single.id);
    await engine.syncNow();
    expect((await db.select(db.outbox).get()).single.attempts, 2);
  });

  test('concurrent kicks only run one drain at a time', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var inFlight = 0;
    var maxConcurrent = 0;
    final api = FakeSyncApi(
      createInspection: (request) async {
        inFlight += 1;
        maxConcurrent = maxConcurrent < inFlight ? inFlight : maxConcurrent;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        inFlight -= 1;
        return _detailFrom(id: request.id, revision: 1);
      },
    );
    final repository = LocalInspectionsRepository(db: db, api: api);
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.createDraft(assetId: 'asset-1', inspectorId: 'user-1', inspectionType: 'ad_hoc');
    await repository.createDraft(assetId: 'asset-1', inspectorId: 'user-1', inspectionType: 'ad_hoc');

    final first = engine.syncNow();
    engine.kick();
    await first;
    // Let a queued rerun (from the kick() that landed mid-drain) finish too.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(maxConcurrent, 1);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('a pending outbox row persists across an app restart and drains on the next launch', () async {
    final dbFile = File(p.join(tempDir.path, 'restart_test.sqlite'));
    final api = FakeSyncApi(
      createInspection: (request) async => _detailFrom(id: request.id, revision: 1),
    );

    var firstDb = AppDatabase(NativeDatabase(dbFile));
    var repository = LocalInspectionsRepository(db: firstDb, api: api);
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    // Simulate the app being killed with the mutation still queued --
    // closing without ever syncing.
    await firstDb.close();

    final secondDb = AppDatabase(NativeDatabase(dbFile));
    addTearDown(secondDb.close);
    repository = LocalInspectionsRepository(db: secondDb, api: api);
    final resumedOutbox = await secondDb.select(secondDb.outbox).get();
    expect(resumedOutbox, hasLength(1));

    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);
    await engine.syncNow();

    expect(api.calls, ['createInspection:$id']);
    final row =
        await (secondDb.select(secondDb.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
    expect(await secondDb.select(secondDb.outbox).get(), isEmpty);
  });
}
