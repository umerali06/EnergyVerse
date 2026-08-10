import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_of/any_of.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_sync_api.dart';

List<SignatureStrokeInput> _testStrokes() => [
      SignatureStrokeInput((b) => b.points.addAll([
            SignaturePointInput((p) => p
              ..x = 0.1
              ..y = 0.2),
            SignaturePointInput((p) => p
              ..x = 0.8
              ..y = 0.6),
          ])),
    ];

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
  late Directory tempDir;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    repository = LocalInspectionsRepository(db: db, api: FakeSyncApi());
    tempDir = Directory.systemTemp
        .createTempSync('fev_local_inspections_repository_test');
  });

  tearDown(() {
    db.close();
    tempDir.deleteSync(recursive: true);
  });

  test('createDraft writes a local_only row and queues a create mutation',
      () async {
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

  test(
      'updateInspection coalesces repeated edits into one not-yet-attempted outbox row',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    // The create outbox row is still attempts=0 too, but a different
    // mutation type -- coalescing only applies within the same type.
    await repository.updateInspection(id, title: 'First edit');
    await repository.updateInspection(id,
        title: 'Second edit', notes: 'Some notes');

    final outbox = await db.select(db.outbox).get();
    final updateRows =
        outbox.where((row) => row.mutationType == 'update').toList();
    expect(updateRows, hasLength(1));

    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.title, 'Second edit');
    expect(row.notes, 'Some notes');
  });

  test(
      'updateInspection appends a new row once the coalesced one has been attempted',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.updateInspection(id, title: 'First edit');
    final firstUpdateRow = (await db.select(db.outbox).get())
        .firstWhere((row) => row.mutationType == 'update');

    // Simulate the sync engine having already attempted (and failed) this row.
    await repository.markTransientFailure(
      OutboxItemRecord(firstUpdateRow),
      message: 'network down',
      nextAttemptAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
    );

    await repository.updateInspection(id, title: 'Second edit');

    final updateRows = (await db.select(db.outbox).get())
        .where((row) => row.mutationType == 'update')
        .toList();
    expect(updateRows, hasLength(2));
  });

  test('completeInspection rejects locally when a required item is unanswered',
      () async {
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
      repository.completeInspection(id, strokes: _testStrokes()),
      throwsA(isA<ChecklistIncompleteError>()),
    );

    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((row) => row.mutationType == 'complete'), isEmpty);
    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.status, isNot('completed'));
    expect(row.pendingSignatureStrokes, isNull);
  });

  test('completeInspection succeeds once the required item is answered',
      () async {
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
                (v) => v.anyOf =
                    AnyOfDynamic(types: const [bool], values: const {0: true}),
              ),
            ),
        ),
      ],
    );

    await repository.completeInspection(id, strokes: _testStrokes());

    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.status, 'completed');
    expect(row.syncState, 'pending_sync');
    // The signature itself isn't known to be server-confirmed yet, but the
    // drawn strokes are visible immediately (survives an app restart too --
    // see the `pendingSignatureStrokes` column doc).
    expect(row.signature, isNull);
    expect(row.pendingSignatureStrokes, isNotNull);
    final outbox = await db.select(db.outbox).get();
    final completeRows =
        outbox.where((r) => r.mutationType == 'complete').toList();
    expect(completeRows, hasLength(1));
    final request = standardSerializers.deserializeWith(
      CompleteInspectionRequest.serializer,
      jsonDecode(completeRows.single.payload) as Map<String, dynamic>,
    )!;
    expect(request.expectedRevision, 0);
    expect(request.strokes, hasLength(1));
  });

  test(
      'completeInspection strokes and status survive being re-read from a fresh repository instance (app-restart persistence)',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.completeInspection(id, strokes: _testStrokes());

    final restarted = LocalInspectionsRepository(db: db, api: FakeSyncApi());
    final row = await restarted.watchInspection(id).first;
    expect(row, isNotNull);
    expect(row!.status, 'completed');
    expect(row.pendingSignatureStrokes, isNotNull);
    expect(row.pendingSignatureStrokes!.single.points.first.x, 0.1);
  });

  test(
      'resolveConflict(keepLocal: true) requeues the local edit against the server revision',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final server = _serverDetailFixture(id: id, revision: 5);
    await repository.markConflict(inspectionId: id, serverSnapshot: server);

    await repository.resolveConflict(id, keepLocal: true);

    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.syncState, 'pending_sync');
    expect(row.baseRevision, 5);
    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((r) => r.mutationType == 'update'), hasLength(1));
  });

  test(
      'resolveConflict(keepLocal: false) adopts the server snapshot and drops queued mutations',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final server =
        _serverDetailFixture(id: id, revision: 5, title: 'Server wins');
    await repository.markConflict(inspectionId: id, serverSnapshot: server);

    await repository.resolveConflict(id, keepLocal: false);

    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.syncState, 'synced');
    expect(row.title, 'Server wins');
    expect(row.revision, 5);
    final outbox = await db.select(db.outbox).get();
    expect(outbox, isEmpty);
  });

  test(
      'markConflict on a stale complete-with-signature reverts the optimistic '
      "'completed' status so the inspector re-signs (Phase 7.8 re-sign flow)",
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    await repository.completeInspection(id, strokes: _testStrokes());
    var row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.status, 'completed');
    expect(row.pendingSignatureStrokes, isNotNull);

    // The server rejected the stale signature (revision moved since the
    // strokes were drawn) -- the sync engine re-fetches the authoritative
    // state, which never actually completed, and reports it here.
    final server = _serverDetailFixture(id: id, revision: 2);
    await repository.markConflict(inspectionId: id, serverSnapshot: server);

    row = await (db.select(db.localInspections)..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.status, 'in_progress');
    expect(row.completedAt, isNull);
    expect(row.pendingSignatureStrokes, isNull);
    expect(row.syncState, 'conflict');
    // Once the inspector reviews and taps Complete again, that's the re-sign.
  });

  test(
      'discardOutboxItem removes the row and marks the inspection error when nothing remains',
      () async {
    final id = await repository.createDraft(
      assetId: 'asset-1',
      inspectorId: 'user-1',
      inspectionType: 'ad_hoc',
    );
    final outboxRow = (await db.select(db.outbox).get()).single;

    await repository.discardOutboxItem(outboxRow.id);

    expect(await db.select(db.outbox).get(), isEmpty);
    final row = await (db.select(db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(row.syncState, 'error');
  });

  test('retryOutboxItem clears backoff so the row is immediately due again',
      () async {
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

    expect(await repository.queueForDrain(now: DateTime.now().toUtc()),
        hasLength(1));
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

  test('reconcileSessionOwner wipes local data when a different uid signs in',
      () async {
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
    test(
        'updateInspection upserts by itemId instead of replacing the whole array',
        () async {
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

      final row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final record = LocalInspectionRecord(row);
      expect(record.checklistResponses, hasLength(2));
      final byItem = {
        for (final r in record.checklistResponses)
          r.itemId: checklistResponseValue(r)
      };
      expect(byItem, {'item-1': true, 'item-2': 140.0});
    });

    test('re-answering an item updates it in place rather than duplicating it',
        () async {
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
      await repository.assignChecklistTemplate(id,
          templateId: 't-1', version: 1, items: [item]);

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

      final row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
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

    test('refreshChecklistTemplatesFromNetwork populates the local cache',
        () async {
      final now = DateTime.utc(2026, 1, 1);
      final api = FakeSyncApi(
        getChecklistTemplates: ({category, cursor, limit = 25}) async =>
            ChecklistTemplateListPage(
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
        getChecklistTemplate: (id) async => templateFixture(
            id: id, category: 'Pumps', version: 1, updatedAt: now),
      );
      final cachingRepository = LocalInspectionsRepository(db: db, api: api);

      await cachingRepository.refreshChecklistTemplatesFromNetwork();

      final match =
          await cachingRepository.selectChecklistTemplateForCategory('Pumps');
      expect(match?.id, 'pumps-1');
    });

    test(
        'selectChecklistTemplateForCategory picks the most-recently-updated match',
        () async {
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

      final match =
          await repository.selectChecklistTemplateForCategory('Pumps');

      expect(match?.id, 'pumps-new');
    });

    test(
        'selectChecklistTemplateForCategory falls back to Generic when no category match',
        () async {
      await db.into(db.localChecklistTemplates).insert(
            LocalChecklistTemplatesCompanion.insert(
              id: 'generic-1',
              category: 'Generic',
              name: 'Generic',
              version: 1,
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );

      final match =
          await repository.selectChecklistTemplateForCategory('Compressors');

      expect(match?.id, 'generic-1');
    });

    test(
        'selectChecklistTemplateForCategory returns null when nothing is cached',
        () async {
      final match =
          await repository.selectChecklistTemplateForCategory('Pumps');
      expect(match, isNull);
    });
  });

  group('annotations (Phase 7.5)', () {
    List<AnnotationPointResponse> rectanglePoints() => [
          AnnotationPointResponse((b) => b
            ..x = 0.1
            ..y = 0.1),
          AnnotationPointResponse((b) => b
            ..x = 0.4
            ..y = 0.4),
        ];

    test(
        'createAnnotation writes to the local annotations blob immediately and queues a '
        'create_annotation mutation', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );

      final annotationId = await repository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'rectangle',
        points: rectanglePoints(),
        color: '#C1123F',
        createdBy: 'user-1',
        damageType: 'corrosion',
        note: 'Visible corrosion on flange',
      );

      final record = await repository.getInspection(id);
      expect(record!.annotations, hasLength(1));
      final annotation = record.annotations.single;
      expect(annotation.id, annotationId);
      expect(annotation.mediaLocalId, 'media-local-1');
      expect(annotation.shape, AnnotationResponseShapeEnum.rectangle);
      expect(annotation.color, '#C1123F');
      expect(annotation.damageType, AnnotationResponseDamageTypeEnum.corrosion);
      expect(annotation.note, 'Visible corrosion on flange');
      expect(annotation.source_, AnnotationResponseSource_Enum.manual);
      expect(annotation.createdBy, 'user-1');

      // Small vector data rides the SAME record outbox as checklist/media
      // metadata mutations -- never the heavy MediaQueue.
      final outbox = await db.select(db.outbox).get();
      expect(outbox, hasLength(2)); // create (draft) + create_annotation
      expect(outbox.last.mutationType, 'create_annotation');
      expect(outbox.last.inspectionId, id);
    });

    test('createAnnotation defaults source to manual with a null confidence',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      await repository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'point',
        points: [
          AnnotationPointResponse((b) => b
            ..x = 0.5
            ..y = 0.5)
        ],
        color: '#C1123F',
        createdBy: 'user-1',
      );

      final record = await repository.getInspection(id);
      final annotation = record!.annotations.single;
      expect(annotation.source_, AnnotationResponseSource_Enum.manual);
      expect(annotation.confidence, isNull);
      expect(annotation.damageType, isNull);
      expect(annotation.note, isNull);
    });

    test('updateAnnotation edits fields in place, preserving unspecified ones',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final annotationId = await repository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'rectangle',
        points: rectanglePoints(),
        color: '#C1123F',
        createdBy: 'user-1',
        damageType: 'corrosion',
        note: 'Original note',
      );

      await repository.updateAnnotation(
        inspectionId: id,
        annotationId: annotationId,
        damageType: 'crack',
      );

      final record = await repository.getInspection(id);
      final annotation = record!.annotations.single;
      expect(annotation.damageType, AnnotationResponseDamageTypeEnum.crack);
      // Untouched fields survive the partial update.
      expect(annotation.color, '#C1123F');
      expect(annotation.note, 'Original note');

      final outbox = await db.select(db.outbox).get();
      expect(outbox.last.mutationType, 'update_annotation');
    });

    test('updateAnnotation moves a shape by replacing its points', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final annotationId = await repository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'rectangle',
        points: rectanglePoints(),
        color: '#C1123F',
        createdBy: 'user-1',
      );

      await repository.updateAnnotation(
        inspectionId: id,
        annotationId: annotationId,
        points: [
          AnnotationPointResponse((b) => b
            ..x = 0.2
            ..y = 0.2),
          AnnotationPointResponse((b) => b
            ..x = 0.5
            ..y = 0.5),
        ],
      );

      final record = await repository.getInspection(id);
      final annotation = record!.annotations.single;
      expect(annotation.points[0].x, 0.2);
      expect(annotation.points[1].x, 0.5);
    });

    test(
        'updateAnnotation is a no-op (no local write, no enqueue) when the id is not found',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final outboxBefore = await db.select(db.outbox).get();

      await repository.updateAnnotation(
        inspectionId: id,
        annotationId: 'does-not-exist',
        note: 'irrelevant',
      );

      final record = await repository.getInspection(id);
      expect(record!.annotations, isEmpty);
      final outboxAfter = await db.select(db.outbox).get();
      expect(outboxAfter, hasLength(outboxBefore.length));
    });

    test(
        'deleteAnnotation removes it from the local blob and queues a delete_annotation '
        'mutation', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final annotationId = await repository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'point',
        points: [
          AnnotationPointResponse((b) => b
            ..x = 0.5
            ..y = 0.5)
        ],
        color: '#C1123F',
        createdBy: 'user-1',
      );

      await repository.deleteAnnotation(
          inspectionId: id, annotationId: annotationId);

      final record = await repository.getInspection(id);
      expect(record!.annotations, isEmpty);
      final outbox = await db.select(db.outbox).get();
      expect(outbox.last.mutationType, 'delete_annotation');
    });

    test('an annotation drawn offline persists across an app restart',
        () async {
      final dbFile = File(p.join(tempDir.path, 'restart_test.sqlite'));

      var firstDb = AppDatabase(NativeDatabase(dbFile));
      var firstRepository =
          LocalInspectionsRepository(db: firstDb, api: FakeSyncApi());
      final id = await firstRepository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final annotationId = await firstRepository.createAnnotation(
        inspectionId: id,
        mediaLocalId: 'media-local-1',
        shape: 'point',
        points: [
          AnnotationPointResponse((b) => b
            ..x = 0.5
            ..y = 0.5)
        ],
        color: '#C1123F',
        createdBy: 'user-1',
        damageType: 'rust',
      );
      // Simulate the app being killed with the annotation still unsynced.
      await firstDb.close();

      final secondDb = AppDatabase(NativeDatabase(dbFile));
      addTearDown(secondDb.close);
      final secondRepository =
          LocalInspectionsRepository(db: secondDb, api: FakeSyncApi());

      final record = await secondRepository.getInspection(id);
      expect(record!.annotations, hasLength(1));
      expect(record.annotations.single.id, annotationId);
      expect(record.annotations.single.damageType,
          AnnotationResponseDamageTypeEnum.rust);
      final resumedOutbox = await secondDb.select(secondDb.outbox).get();
      expect(resumedOutbox.map((r) => r.mutationType),
          contains('create_annotation'));
    });
  });

  group('AR/manual measurements (Phase 7.9)', () {
    test(
        'createMeasurement writes to the local ar_measurements blob immediately and '
        'queues a create_measurement mutation', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );

      final measurementId = await repository.createMeasurement(
        inspectionId: id,
        method: 'manual',
        distanceMeters: 1.25,
        createdBy: 'user-1',
        label: 'Flange gap',
        note: 'Measured with tape',
      );

      final record = await repository.getInspection(id);
      expect(record!.arMeasurements, hasLength(1));
      final measurement = record.arMeasurements.single;
      expect(measurement.id, measurementId);
      expect(measurement.method, ArMeasurementResponseMethodEnum.manual);
      expect(measurement.distanceMeters, 1.25);
      expect(measurement.label, 'Flange gap');
      expect(measurement.note, 'Measured with tape');
      expect(measurement.mediaLocalId, isNull);
      expect(measurement.points, isEmpty);
      expect(measurement.createdBy, 'user-1');

      // Small metadata rides the SAME record outbox as annotations/checklist
      // mutations -- never the heavy MediaQueue.
      final outbox = await db.select(db.outbox).get();
      expect(outbox, hasLength(2)); // create (draft) + create_measurement
      expect(outbox.last.mutationType, 'create_measurement');
      expect(outbox.last.inspectionId, id);
    });

    test(
        'createMeasurement(method: ar) carries its screenshot reference and points',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );

      await repository.createMeasurement(
        inspectionId: id,
        method: 'ar',
        distanceMeters: 0.42,
        createdBy: 'user-1',
        mediaLocalId: 'media-local-1',
        points: [
          AnnotationPointResponse((b) => b
            ..x = 0.2
            ..y = 0.3),
          AnnotationPointResponse((b) => b
            ..x = 0.6
            ..y = 0.7),
        ],
      );

      final record = await repository.getInspection(id);
      final measurement = record!.arMeasurements.single;
      expect(measurement.method, ArMeasurementResponseMethodEnum.ar);
      expect(measurement.mediaLocalId, 'media-local-1');
      expect(measurement.points, hasLength(2));
      expect(measurement.points![0].x, 0.2);
      expect(measurement.points![1].x, 0.6);
    });

    test('updateMeasurement edits label/note in place, preserving distance',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final measurementId = await repository.createMeasurement(
        inspectionId: id,
        method: 'manual',
        distanceMeters: 1.25,
        createdBy: 'user-1',
        label: 'Original label',
      );

      await repository.updateMeasurement(
        inspectionId: id,
        measurementId: measurementId,
        note: 'Re-checked',
      );

      final record = await repository.getInspection(id);
      final measurement = record!.arMeasurements.single;
      expect(measurement.note, 'Re-checked');
      // Untouched fields survive the partial update.
      expect(measurement.label, 'Original label');
      expect(measurement.distanceMeters, 1.25);

      final outbox = await db.select(db.outbox).get();
      expect(outbox.last.mutationType, 'update_measurement');
    });

    test(
        'updateMeasurement is a no-op (no local write, no enqueue) when the id is not found',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final outboxBefore = await db.select(db.outbox).get();

      await repository.updateMeasurement(
        inspectionId: id,
        measurementId: 'does-not-exist',
        note: 'irrelevant',
      );

      final record = await repository.getInspection(id);
      expect(record!.arMeasurements, isEmpty);
      final outboxAfter = await db.select(db.outbox).get();
      expect(outboxAfter, hasLength(outboxBefore.length));
    });

    test(
        'deleteMeasurement removes it from the local blob and queues a delete_measurement '
        'mutation', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final measurementId = await repository.createMeasurement(
        inspectionId: id,
        method: 'manual',
        distanceMeters: 1.25,
        createdBy: 'user-1',
      );

      await repository.deleteMeasurement(
          inspectionId: id, measurementId: measurementId);

      final record = await repository.getInspection(id);
      expect(record!.arMeasurements, isEmpty);
      final outbox = await db.select(db.outbox).get();
      expect(outbox.last.mutationType, 'delete_measurement');
    });

    test('a measurement recorded offline persists across an app restart',
        () async {
      final dbFile =
          File(p.join(tempDir.path, 'measurement_restart_test.sqlite'));

      var firstDb = AppDatabase(NativeDatabase(dbFile));
      var firstRepository =
          LocalInspectionsRepository(db: firstDb, api: FakeSyncApi());
      final id = await firstRepository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      final measurementId = await firstRepository.createMeasurement(
        inspectionId: id,
        method: 'manual',
        distanceMeters: 2.5,
        createdBy: 'user-1',
        label: 'Pipe diameter',
      );
      // Simulate the app being killed with the measurement still unsynced.
      await firstDb.close();

      final secondDb = AppDatabase(NativeDatabase(dbFile));
      addTearDown(secondDb.close);
      final secondRepository =
          LocalInspectionsRepository(db: secondDb, api: FakeSyncApi());

      final record = await secondRepository.getInspection(id);
      expect(record!.arMeasurements, hasLength(1));
      expect(record.arMeasurements.single.id, measurementId);
      expect(record.arMeasurements.single.label, 'Pipe diameter');
      final resumedOutbox = await secondDb.select(secondDb.outbox).get();
      expect(resumedOutbox.map((r) => r.mutationType),
          contains('create_measurement'));
    });
  });

  group('readings (Phase 7.7)', () {
    test(
        'updateInspection(readings:) writes the local blob and coalesces into the '
        'existing update mutation, not a dedicated mutation type', () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );

      await repository.updateInspection(
        id,
        readings: ReadingsInput(
          (b) => b
            ..condition = ReadingsInputConditionEnum.fair
            ..temperatureC = 72.5
            ..pressureBar = 4.1
            ..noiseLevelDb = 88.0
            ..vibrationObservation = 'Slight rattle'
            ..leakObserved = false
            ..operationalStatus = ReadingsInputOperationalStatusEnum.degraded
            ..comments = 'Bearing noise increasing'
            ..recommendations = 'Schedule bearing replacement'
            ..priorityLevel = ReadingsInputPriorityLevelEnum.high,
        ),
      );

      final record = await repository.getInspection(id);
      final readings = record!.readings;
      expect(readings, isNotNull);
      expect(readings!.condition, ReadingsResponseConditionEnum.fair);
      expect(readings.temperatureC, 72.5);
      expect(readings.pressureBar, 4.1);
      expect(readings.noiseLevelDb, 88.0);
      expect(readings.vibrationObservation, 'Slight rattle');
      expect(readings.leakObserved, false);
      expect(readings.operationalStatus,
          ReadingsResponseOperationalStatusEnum.degraded);
      expect(readings.comments, 'Bearing noise increasing');
      expect(readings.recommendations, 'Schedule bearing replacement');
      expect(readings.priorityLevel, ReadingsResponsePriorityLevelEnum.high);
      // Never client-stamped locally -- the server always fills these in.
      expect(readings.recordedAt, isNull);
      expect(readings.recordedBy, isNull);

      final outbox = await db.select(db.outbox).get();
      expect(outbox.where((r) => r.mutationType == 'update'), hasLength(1));
      expect(outbox.where((r) => r.mutationType.contains('reading')), isEmpty);
    });

    test(
        'an unrelated field edit resends the previously-saved readings unchanged',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      await repository.updateInspection(
        id,
        readings: ReadingsInput(
            (b) => b..condition = ReadingsInputConditionEnum.good),
      );

      await repository.updateInspection(id, notes: 'unrelated autosave edit');

      final row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      expect(row.notes, 'unrelated autosave edit');
      final record = LocalInspectionRecord(row);
      expect(record.readings?.condition, ReadingsResponseConditionEnum.good);

      final outbox = await db.select(db.outbox).get();
      final updateRow = outbox.singleWhere((r) => r.mutationType == 'update');
      final request = standardSerializers.deserializeWith(
        UpdateInspectionRequest.serializer,
        jsonDecode(updateRow.payload) as Map<String, dynamic>,
      )!;
      expect(request.readings?.condition, ReadingsInputConditionEnum.good);
    });

    test('a fresh readings save fully replaces the previous one, not merges it',
        () async {
      final id = await repository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      await repository.updateInspection(
        id,
        readings: ReadingsInput(
          (b) => b
            ..condition = ReadingsInputConditionEnum.poor
            ..comments = 'First pass',
        ),
      );

      await repository.updateInspection(
        id,
        readings: ReadingsInput(
            (b) => b..condition = ReadingsInputConditionEnum.good),
      );

      final record = await repository.getInspection(id);
      expect(record!.readings!.condition, ReadingsResponseConditionEnum.good);
      expect(record.readings!.comments, isNull);
    });

    test('readings recorded offline persist across an app restart', () async {
      final dbFile = File(p.join(tempDir.path, 'readings_restart_test.sqlite'));

      final firstDb = AppDatabase(NativeDatabase(dbFile));
      final firstRepository =
          LocalInspectionsRepository(db: firstDb, api: FakeSyncApi());
      final id = await firstRepository.createDraft(
        assetId: 'asset-1',
        inspectorId: 'user-1',
        inspectionType: 'ad_hoc',
      );
      await firstRepository.updateInspection(
        id,
        readings: ReadingsInput(
          (b) => b
            ..condition = ReadingsInputConditionEnum.critical
            ..priorityLevel = ReadingsInputPriorityLevelEnum.critical,
        ),
      );
      // Simulate the app being killed with the readings still unsynced.
      await firstDb.close();

      final secondDb = AppDatabase(NativeDatabase(dbFile));
      addTearDown(secondDb.close);
      final secondRepository =
          LocalInspectionsRepository(db: secondDb, api: FakeSyncApi());

      final record = await secondRepository.getInspection(id);
      expect(
          record!.readings?.condition, ReadingsResponseConditionEnum.critical);
      expect(record.readings?.priorityLevel,
          ReadingsResponsePriorityLevelEnum.critical);
      final resumedOutbox = await secondDb.select(secondDb.outbox).get();
      expect(resumedOutbox.map((r) => r.mutationType), contains('update'));
    });
  });
}
