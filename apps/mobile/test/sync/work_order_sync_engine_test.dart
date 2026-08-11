import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/work_orders/local_work_orders_repository.dart';
import 'package:fev_mobile/work_orders/work_order_sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_work_order_api.dart';

WorkOrderDetail _detailFrom({
  required String id,
  required int revision,
  String status = 'assigned',
  String? technicianId = 'tech-1',
  String? completionNotes,
  num? laborHours,
  List<String> materialsUsed = const [],
}) {
  final now = DateTime.utc(2026, 1, 1);
  return WorkOrderDetail(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..title = 'Replace worn gasket'
      ..priority = WorkOrderDetailPriorityEnum.medium
      ..status = WorkOrderDetailStatusEnum.values.firstWhere((s) => s.name == status)
      ..technicianId = technicianId
      ..completionNotes = completionNotes
      ..laborHours = laborHours
      ..materialsUsed.replace(materialsUsed)
      ..revision = revision
      ..createdAt = now
      ..createdBy = 'supervisor-1'
      ..updatedAt = now,
  );
}

WorkOrderSyncEngine _buildEngine({
  required LocalWorkOrdersRepository repository,
  required FakeWorkOrderApi api,
}) {
  return WorkOrderSyncEngine(
    repository: repository,
    api: api,
    connectivityStreamFactory: () => const Stream<List<ConnectivityResult>>.empty(),
    checkConnectivity: () async => [ConnectivityResult.wifi],
    periodicInterval: const Duration(days: 1),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('fev_work_order_sync_engine_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('accept-offline-then-sync: a queued accept replays and the row becomes synced/in_progress',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(id: id, revision: 1, status: 'assigned'),
      acceptWorkOrder: (id) async =>
          _detailFrom(id: id, revision: 1, status: 'inProgress'),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.acceptWorkOrder('wo-1');
    await engine.syncNow();

    expect(api.calls, contains('acceptWorkOrder:wo-1'));
    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'synced');
    expect(row.status, 'in_progress');
    expect(await db.select(db.workOrderOutbox).get(), isEmpty);
  });

  test(
      'submit-for-review-offline-then-sync: queued completion notes/labor/materials replay correctly',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    SubmitWorkOrderForReviewRequest? captured;
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(id: id, revision: 1, status: 'inProgress'),
      submitWorkOrderForReview: (id, request) async {
        captured = request;
        return _detailFrom(
          id: id,
          revision: 2,
          status: 'pendingReview',
          completionNotes: request.completionNotes,
          laborHours: request.laborHours,
          materialsUsed: request.materialsUsed?.toList() ?? const [],
        );
      },
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.submitWorkOrderForReview(
      'wo-1',
      completionNotes: 'Replaced the gasket and tested for leaks.',
      laborHours: 2.5,
      materialsUsed: const ['Gasket kit'],
    );
    await engine.syncNow();

    expect(captured, isNotNull);
    expect(captured!.completionNotes, 'Replaced the gasket and tested for leaks.');
    expect(captured!.expectedRevision, 1);
    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'synced');
    expect(row.status, 'pending_review');
    expect(row.completionNotes, 'Replaced the gasket and tested for leaks.');
  });

  test(
      'invalid_transition on accept (already accepted/reassigned elsewhere) surfaces as a conflict',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var getCalls = 0;
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async {
        getCalls++;
        // First call seeds the local cache as assigned-to-tech-1; the
        // engine's post-error re-fetch finds it was reassigned and accepted
        // by a different technician while this device was offline.
        if (getCalls == 1) {
          return _detailFrom(id: id, revision: 1, status: 'assigned', technicianId: 'tech-1');
        }
        return _detailFrom(
            id: id, revision: 2, status: 'inProgress', technicianId: 'someone-else');
      },
      acceptWorkOrder: (id) async => throw const ApiException(
        code: 'invalid_transition',
        message: 'Work order cannot be accepted from status \'in_progress\'',
      ),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.acceptWorkOrder('wo-1');
    await engine.syncNow();

    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'conflict');
    expect(row.status, 'in_progress');
    expect(row.technicianId, 'someone-else');
    expect(await db.select(db.workOrderOutbox).get(), isEmpty);
  });

  test(
      'revision_conflict where the server already reflects this exact submission is treated as success',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var submitAttempts = 0;
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async {
        if (submitAttempts == 0) return _detailFrom(id: id, revision: 1, status: 'inProgress');
        return _detailFrom(
          id: id,
          revision: 2,
          status: 'pendingReview',
          completionNotes: 'Fixed it.',
        );
      },
      submitWorkOrderForReview: (id, request) async {
        submitAttempts++;
        throw const ApiException(code: 'revision_conflict', message: 'stale revision');
      },
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.submitWorkOrderForReview('wo-1', completionNotes: 'Fixed it.');
    await engine.syncNow();

    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'synced');
    expect(row.status, 'pending_review');
    expect(await db.select(db.workOrderOutbox).get(), isEmpty);
  });

  test('revision_conflict with a genuinely different server state surfaces as a conflict',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(
        id: id,
        revision: 5,
        status: 'pendingReview',
        completionNotes: 'Someone else already submitted this.',
      ),
      submitWorkOrderForReview: (id, request) async =>
          throw const ApiException(code: 'revision_conflict', message: 'stale revision'),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.submitWorkOrderForReview('wo-1', completionNotes: 'My notes.');
    await engine.syncNow();

    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'conflict');
    // The technician's own submitted notes survive the conflict (so "keep
    // mine" has real content to re-submit) -- the server's conflicting
    // version lives in conflictServerSnapshot instead, not overwritten here.
    expect(row.completionNotes, 'My notes.');
    expect(row.conflictServerSnapshot, contains('Someone else already submitted this.'));
    expect(await db.select(db.workOrderOutbox).get(), isEmpty);
  });

  test('resolveConflict(keepLocal: true) requeues the local edit against the fresh revision',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(id: id, revision: 5, status: 'pendingReview'),
      submitWorkOrderForReview: (id, request) async =>
          throw const ApiException(code: 'revision_conflict', message: 'stale revision'),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.submitWorkOrderForReview('wo-1', completionNotes: 'My notes.');
    await engine.syncNow();
    await repository.resolveConflict('wo-1', keepLocal: true);

    final outboxRows = await db.select(db.workOrderOutbox).get();
    expect(outboxRows, hasLength(1));
    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'pending_sync');
    expect(row.baseRevision, 5);
  });

  test(
      "resolveConflict(keepLocal: false) discards the pending mutation and adopts the server's version",
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(
        id: id,
        revision: 5,
        status: 'pendingReview',
        completionNotes: "Server's version",
      ),
      submitWorkOrderForReview: (id, request) async =>
          throw const ApiException(code: 'revision_conflict', message: 'stale revision'),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.submitWorkOrderForReview('wo-1', completionNotes: 'My notes.');
    await engine.syncNow();
    await repository.resolveConflict('wo-1', keepLocal: false);

    expect(await db.select(db.workOrderOutbox).get(), isEmpty);
    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'synced');
    expect(row.completionNotes, "Server's version");
  });

  test('network_error is a transient failure and stops draining further rows', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakeWorkOrderApi(
      getWorkOrder: (id) async => _detailFrom(id: id, revision: 1, status: 'assigned'),
      acceptWorkOrder: (id) async =>
          throw const ApiException(code: 'network_error', message: 'Unable to reach the API'),
    );
    final repository = LocalWorkOrdersRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('wo-1');
    final engine = _buildEngine(repository: repository, api: api);
    addTearDown(engine.dispose);

    await repository.acceptWorkOrder('wo-1');
    await engine.syncNow();

    final outboxRows = await db.select(db.workOrderOutbox).get();
    expect(outboxRows, hasLength(1));
    expect(outboxRows.single.attempts, 1);
    expect(outboxRows.single.nextAttemptAt, isNotNull);
    final row = await (db.select(db.localWorkOrders)..where((t) => t.id.equals('wo-1')))
        .getSingle();
    expect(row.syncState, 'pending_sync');
    expect(row.errorMessage, 'Unable to reach the API');
  });
}
