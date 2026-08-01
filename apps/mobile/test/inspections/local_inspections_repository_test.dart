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

  group('checklist_responses merge (Phase 7.3)', () {
    test('updateInspection upserts by itemId instead of replacing the whole array', () async {
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
          ChecklistTemplateItem(
            (b) => b
              ..id = 'item-2'
              ..label = 'Bearing temp'
              ..itemType = ChecklistTemplateItemItemTypeEnum.numeric
              ..required_ = true,
          ),
        ],
      );

      await repository.updateInspection(
        id,
        checklistResponses: [
          buildChecklistResponse(
            itemId: 'item-1',
            itemType: ChecklistTemplateItemItemTypeEnum.boolean,
            rawValue: true,
          ),
        ],
      );
      await repository.updateInspection(
        id,
        checklistResponses: [
          buildChecklistResponse(
            itemId: 'item-2',
            itemType: ChecklistTemplateItemItemTypeEnum.numeric,
            rawValue: 140.0,
          ),
        ],
      );

      final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final record = LocalInspectionRecord(row);
      expect(record.checklistResponses, hasLength(2));
      final byItem = {for (final r in record.checklistResponses) r.itemId: checklistResponseValue(r)};
      expect(byItem, {'item-1': true, 'item-2': 140.0});
    });

    test('re-answering an item updates it in place rather than duplicating it', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final item = ChecklistTemplateItem(
        (b) => b
          ..id = 'item-1'
          ..label = 'Vibration normal'
          ..itemType = ChecklistTemplateItemItemTypeEnum.boolean
          ..required_ = true,
      );
      await repository.assignChecklistTemplate(id, templateId: 't-1', version: 1, items: [item]);

      await repository.updateInspection(
        id,
        checklistResponses: [
          buildChecklistResponse(
            itemId: 'item-1',
            itemType: ChecklistTemplateItemItemTypeEnum.boolean,
            rawValue: true,
          ),
        ],
      );
      await repository.updateInspection(
        id,
        checklistResponses: [
          buildChecklistResponse(
            itemId: 'item-1',
            itemType: ChecklistTemplateItemItemTypeEnum.boolean,
            rawValue: false,
          ),
        ],
      );

      final row = await (db.select(db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final record = LocalInspectionRecord(row);
      expect(record.checklistResponses, hasLength(1));
      expect(checklistResponseValue(record.checklistResponses.single), false);
    });
  });

  group('checklist template auto-selection (Phase 7.3)', () {
    ChecklistTemplateDetail templateFixture({
      required String id,
      required String category,
      required int version,
      required DateTime updatedAt,
    }) {
      return ChecklistTemplateDetail(
        (b) => b
          ..id = id
          ..category = category
          ..name = '$category template'
          ..version = version
          ..createdAt = updatedAt
          ..updatedAt = updatedAt,
      );
    }

    test('refreshChecklistTemplatesFromNetwork populates the local cache', () async {
      final now = DateTime.utc(2026, 1, 1);
      final api = FakeSyncApi(
        getChecklistTemplates: ({category, cursor, limit = 25}) async => ChecklistTemplateListPage(
          (b) => b
            ..items.add(
              ChecklistTemplateListItem(
                (i) => i
                  ..id = 'pumps-1'
                  ..category = 'Pumps'
                  ..name = 'Pumps template'
                  ..version = 1
                  ..createdAt = now
                  ..updatedAt = now,
              ),
            ),
        ),
        getChecklistTemplate: (id) async =>
            templateFixture(id: id, category: 'Pumps', version: 1, updatedAt: now),
      );
      final cachingRepository = LocalInspectionsRepository(db: db, api: api);

      await cachingRepository.refreshChecklistTemplatesFromNetwork();

      final match = await cachingRepository.selectChecklistTemplateForCategory('Pumps');
      expect(match?.id, 'pumps-1');
    });

    test('selectChecklistTemplateForCategory picks the most-recently-updated match', () async {
      await db.into(db.localChecklistTemplates).insert(
            LocalChecklistTemplatesCompanion.insert(
              id: 'pumps-old',
              category: 'Pumps',
              name: 'Older',
              version: 1,
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );
      await db.into(db.localChecklistTemplates).insert(
            LocalChecklistTemplatesCompanion.insert(
              id: 'pumps-new',
              category: 'Pumps',
              name: 'Newer',
              version: 2,
              updatedAt: DateTime.utc(2026, 6, 1),
            ),
          );

      final match = await repository.selectChecklistTemplateForCategory('Pumps');

      expect(match?.id, 'pumps-new');
    });

    test('selectChecklistTemplateForCategory falls back to Generic when no category match', () async {
      await db.into(db.localChecklistTemplates).insert(
            LocalChecklistTemplatesCompanion.insert(
              id: 'generic-1',
              category: 'Generic',
              name: 'Generic',
              version: 1,
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );

      final match = await repository.selectChecklistTemplateForCategory('Compressors');

      expect(match?.id, 'generic-1');
    });

    test('selectChecklistTemplateForCategory returns null when nothing is cached', () async {
      final match = await repository.selectChecklistTemplateForCategory('Pumps');
      expect(match, isNull);
    });
  });
}
