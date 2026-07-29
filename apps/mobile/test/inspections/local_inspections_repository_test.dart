import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_of/any_of.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_sync_api.dart';

InspectionDetail _serverDetailFixture({
  String id = 'insp-1',
  int revision = 3,
  String title = 'Server title',
}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionDetail(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'user-1'
      ..status = InspectionDetailStatusEnum.inProgress
      ..inspectionType = InspectionDetailInspectionTypeEnum.routine
      ..title = title
      ..revision = revision
      ..clientCreatedAt = now
      ..createdAt = now
      ..updatedAt = now,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late LocalInspectionsRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    repository = LocalInspectionsRepository(db: db, api: FakeSyncApi());
  });

  tearDown(() => db.close());

  test('createDraft writes a local_only row and queues a create mutation', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
      title: 'New draft',
    );

    final rows = await db.select(db.localInspections).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, id);
    expect(rows.single.syncState, 'local_only');
    expect(rows.single.status, 'draft');
    expect(rows.single.inspectionType, 'ad_hoc');

    final outbox = await db.select(db.outbox).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.mutationType, 'create');
    expect(outbox.single.inspectionId, id);
  });

  test('updateInspection coalesces repeated edits into one not-yet-attempted outbox row', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    // The create outbox row is still attempts=0 too, but a different
    // mutation type -- coalescing only applies within the same type.
    await repository.updateInspection(id, title: 'First edit');
    await repository.updateInspection(id, title: 'Second edit', notes: 'Some notes');

    final outbox = await db.select(db.outbox).get();
    final updateRows = outbox.where((row) => row.mutationType == 'update').toList();
    expect(updateRows, hasLength(1));

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.title, 'Second edit');
    expect(row.notes, 'Some notes');
  });

  test('updateInspection appends a new row once the coalesced one has been attempted', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.updateInspection(id, title: 'First edit');
    final firstUpdateRow =
        (await db.select(db.outbox).get()).firstWhere((row) => row.mutationType == 'update');

    // Simulate the sync engine having already attempted (and failed) this row.
    await repository.markTransientFailure(
      OutboxItemRecord(firstUpdateRow),
      message: 'network down',
      nextAttemptAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
    );

    await repository.updateInspection(id, title: 'Second edit');

    final updateRows =
        (await db.select(db.outbox).get()).where((row) => row.mutationType == 'update').toList();
    expect(updateRows, hasLength(2));
  });

  test('completeInspection rejects locally when a required item is unanswered', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.assignChecklistTemplate(
      id,
      templateId: 'template-1',
      version: 1,
      items: [
        ChecklistTemplateItem(
          (b) => b
            ..id = 'item-1'
            ..label = 'Vibration normal'
            ..itemType = ChecklistTemplateItemItemTypeEnum.boolean
            ..required_ = true,
        ),
      ],
    );

    await expectLater(
      repository.completeInspection(id),
      throwsA(isA<ChecklistIncompleteError>()),
    );

    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((row) => row.mutationType == 'complete'), isEmpty);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.status, isNot('completed'));
  });

  test('completeInspection succeeds once the required item is answered', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.assignChecklistTemplate(
      id,
      templateId: 'template-1',
      version: 1,
      items: [
        ChecklistTemplateItem(
          (b) => b
            ..id = 'item-1'
            ..label = 'Vibration normal'
            ..itemType = ChecklistTemplateItemItemTypeEnum.boolean
            ..required_ = true,
        ),
      ],
    );
    await repository.updateInspection(
      id,
      checklistResponses: [
        ChecklistResponse(
          (b) => b
            ..itemId = 'item-1'
            ..value.replace(
              Value(
                (v) => v.anyOf = AnyOfDynamic(types: const [bool], values: const {0: true}),
              ),
            ),
        ),
      ],
    );

    await repository.completeInspection(id);

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.status, 'completed');
    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((r) => r.mutationType == 'complete'), hasLength(1));
  });

  test('resolveConflict(keepLocal: true) requeues the local edit against the server revision', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final server = _serverDetailFixture(id: id, revision: 5);
    await repository.markConflict(inspectionId: id, serverSnapshot: server);

    await repository.resolveConflict(id, keepLocal: true);

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'pending_sync');
    expect(row.baseRevision, 5);
    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((r) => r.mutationType == 'update'), hasLength(1));
  });

  test('resolveConflict(keepLocal: false) adopts the server snapshot and drops queued mutations', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final server = _serverDetailFixture(id: id, revision: 5, title: 'Server wins');
    await repository.markConflict(inspectionId: id, serverSnapshot: server);

    await repository.resolveConflict(id, keepLocal: false);

    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'synced');
    expect(row.title, 'Server wins');
    expect(row.revision, 5);
    final outbox = await db.select(db.outbox).get();
    expect(outbox, isEmpty);
  });

  test('discardOutboxItem removes the row and marks the inspection error when nothing remains', () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final outboxRow = (await db.select(db.outbox).get()).single;

    await repository.discardOutboxItem(outboxRow.id);

    expect(await db.select(db.outbox).get(), isEmpty);
    final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
    expect(row.syncState, 'error');
  });

  test('retryOutboxItem clears backoff so the row is immediately due again', () async {
    await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final outboxRow = (await db.select(db.outbox).get()).single;
    await repository.markTransientFailure(
      OutboxItemRecord(outboxRow),
      message: 'network down',
      nextAttemptAt: DateTime.now().toUtc().add(const Duration(minutes: 30)),
    );
    final farFuture = DateTime.now().toUtc().add(const Duration(minutes: 20));
    expect(await repository.queueForDrain(now: farFuture), isEmpty);

    await repository.retryOutboxItem(outboxRow.id);

    expect(await repository.queueForDrain(now: DateTime.now().toUtc()), hasLength(1));
  });

  test('reconcileSessionOwner preserves local data for the same uid', () async {
    await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.reconcileSessionOwner('user-1');
    await repository.reconcileSessionOwner('user-1');

    expect(await db.select(db.localInspections).get(), hasLength(1));
  });

  test('reconcileSessionOwner wipes local data when a different uid signs in', () async {
    await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.reconcileSessionOwner('user-1');

    await repository.reconcileSessionOwner('user-2');

    expect(await db.select(db.localInspections).get(), isEmpty);
    expect(await db.select(db.outbox).get(), isEmpty);
  });
}
