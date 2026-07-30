import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../db/app_database.dart';

/// Mirrors the five sync states a locally-cached inspection can be in.
/// `wireValue` is exactly what's persisted in `LocalInspections.syncState`.
enum LocalSyncState {
  localOnly('local_only'),
  pendingSync('pending_sync'),
  synced('synced'),
  conflict('conflict'),
  error('error');

  const LocalSyncState(this.wireValue);

  final String wireValue;

  static LocalSyncState fromWire(String value) => values.firstWhere(
        (state) => state.wireValue == value,
        orElse: () => LocalSyncState.error,
      );
}

/// The outbox's mutation kinds. `uploadMedia` is a reserved value for 7.4+
/// and is intentionally not dispatched anywhere yet.
enum OutboxMutationType {
  create('create'),
  update('update'),
  start('start'),
  complete('complete'),
  cancel('cancel'),
  assignTemplate('assign_template');

  const OutboxMutationType(this.wireValue);

  final String wireValue;

  static OutboxMutationType fromWire(String value) =>
      values.firstWhere((type) => type.wireValue == value);
}

/// Thrown by [LocalInspectionsRepository.completeInspection] when required
/// checklist items are unanswered -- mirrors the server's `checklist_incomplete`
/// check (`InspectionService.complete_inspection`) so a doomed completion
/// never reaches the outbox at all.
class ChecklistIncompleteError implements Exception {
  const ChecklistIncompleteError(this.missingItemIds);

  final List<String> missingItemIds;

  @override
  String toString() => 'ChecklistIncompleteError($missingItemIds)';
}

/// Converts a wire-form enum value (snake_case, e.g. `in_progress`) to the
/// Dart identifier `built_value` generates for it (`inProgress`) -- every
/// generated `*Enum.valueOf()` looks up by that identifier, not the wire
/// value. Every inline enum the OpenAPI generator emits shares this mapping
/// (single-word values are identity), so one generic converter covers
/// `status` and `inspection_type` across all three separately-generated
/// enum classes (`CreateInspectionRequestInspectionTypeEnum`,
/// `UpdateInspectionRequestInspectionTypeEnum`, `InspectionDetailInspectionTypeEnum`).
String wireToDartEnumName(String wireValue) {
  final parts = wireValue.split('_');
  if (parts.length == 1) return wireValue;
  final rest = parts.skip(1).map(
        (part) => part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
      );
  return parts.first + rest.join();
}

List<ChecklistTemplateItem> _decodeChecklistItems(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          ChecklistTemplateItem.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

List<ChecklistResponse> _decodeChecklistResponses(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          ChecklistResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeChecklistItems(List<ChecklistTemplateItem> items) => jsonEncode(
      items
          .map((item) => standardSerializers.serializeWith(ChecklistTemplateItem.serializer, item))
          .toList(),
    );

String _encodeChecklistResponses(List<ChecklistResponse> responses) => jsonEncode(
      responses
          .map((r) => standardSerializers.serializeWith(ChecklistResponse.serializer, r))
          .toList(),
    );

bool _isAnswered(ChecklistResponse response) {
  final value = response.value;
  if (value == null) return false;
  final raw = value.anyOf.values.values.firstWhere(
    (candidate) => candidate != null,
    orElse: () => null,
  );
  if (raw == null) return false;
  if (raw is String && raw.isEmpty) return false;
  return true;
}

/// A local inspection row plus its decoded checklist arrays -- the shape
/// every mobile screen renders, whether the data came from the network or
/// is still `local_only`/`pending_sync`. `status`/`inspectionType` are wire
/// values (e.g. `in_progress`, `ad_hoc`); use [wireToDartEnumName] to feed
/// them into `inspectionStatusFor`/`inspectionStatusLabel`.
class LocalInspectionRecord {
  LocalInspectionRecord(this.row)
      : checklistItemsSnapshot = _decodeChecklistItems(row.checklistItemsSnapshot),
        checklistResponses = _decodeChecklistResponses(row.checklistResponses);

  final LocalInspection row;
  final List<ChecklistTemplateItem> checklistItemsSnapshot;
  final List<ChecklistResponse> checklistResponses;

  String get id => row.id;
  String get assetId => row.assetId;
  String? get facilityId => row.facilityId;
  String? get areaId => row.areaId;
  String get inspectorId => row.inspectorId;
  String get status => row.status;
  String get inspectionType => row.inspectionType;
  String? get title => row.title;
  String? get notes => row.notes;
  String? get checklistTemplateId => row.checklistTemplateId;
  int? get checklistTemplateVersion => row.checklistTemplateVersion;
  DateTime? get startedAt => row.startedAt;
  DateTime? get completedAt => row.completedAt;
  double? get gpsLat => row.gpsLat;
  double? get gpsLng => row.gpsLng;
  DateTime get createdAt => row.createdAt;
  DateTime get updatedAt => row.updatedAt;
  int get revision => row.revision;
  LocalSyncState get syncState => LocalSyncState.fromWire(row.syncState);
  String? get errorMessage => row.errorMessage;
  DateTime? get lastAttemptAt => row.lastAttemptAt;

  InspectionDetail? get conflictServerSnapshot {
    final raw = row.conflictServerSnapshot;
    if (raw == null) return null;
    return standardSerializers.deserializeWith(
      InspectionDetail.serializer,
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}

/// A queued outbox mutation, for the pending-queue screen.
class OutboxItemRecord {
  OutboxItemRecord(this.row);

  final OutboxData row;

  String get id => row.id;
  String get inspectionId => row.inspectionId;
  OutboxMutationType get mutationType => OutboxMutationType.fromWire(row.mutationType);
  int get attempts => row.attempts;
  String? get lastError => row.lastError;
  DateTime? get lastAttemptAt => row.lastAttemptAt;
  DateTime? get nextAttemptAt => row.nextAttemptAt;
}

/// Any outbox row with `nextAttemptAt` at/after this instant is considered
/// permanently paused (a non-retryable error) rather than backed off --
/// there's no separate "paused" column, so this sentinel repurposes the
/// existing backoff column instead of adding one just for this.
final DateTime pausedSentinel = DateTime.utc(9999);

/// Offline-first facade over the local Drift cache + outbox for inspections
/// (Phase 7.2). Read paths serve from the local cache and refresh from the
/// network best-effort; write paths always land locally first and enqueue a
/// matching outbox mutation for [SyncEngine] to replay. `_api` is used only
/// for the best-effort network refresh here -- actual mutation replay is
/// [SyncEngine]'s job, which calls the `apply*`/`mark*` methods below.
/// Extends [ChangeNotifier] purely so [SyncEngine] can recompute a plain,
/// one-shot outbox count after every write without holding its own
/// long-lived `watchOutbox()` subscription -- [ChangeNotifier]'s listener
/// list is plain callbacks, not a Stream, so it never touches Drift's
/// cancel-defers-to-a-Timer stream-query machinery (which is exactly what
/// made `flutter_test`'s pending-timer teardown check trip on almost every
/// widget test once the app shell always had a live outbox subscription).
/// `watchInspections`/`watchOutbox` below are still real Drift streams for
/// screens that render reactively; only this cross-cutting "did anything
/// change" signal avoids them.
class LocalInspectionsRepository extends ChangeNotifier {
  LocalInspectionsRepository({required AppDatabase db, required ApiContract api, Uuid? uuid})
      : _db = db,
        _api = api,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final ApiContract _api;
  final Uuid _uuid;

  // ---------------------------------------------------------------- reads

  Stream<List<LocalInspectionRecord>> watchInspections({String? assetId, String? status}) {
    final query = _db.select(_db.localInspections)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => drift.OrderingTerm.desc(t.updatedAt)]);
    if (assetId != null) query.where((t) => t.assetId.equals(assetId));
    if (status != null) query.where((t) => t.status.equals(status));
    return query.watch().map((rows) => rows.map(LocalInspectionRecord.new).toList());
  }

  Stream<LocalInspectionRecord?> watchInspection(String id) {
    return (_db.select(_db.localInspections)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : LocalInspectionRecord(row));
  }

  /// Best-effort: upserts server results as `synced`, skipping any row
  /// that's `pending_sync`/`conflict`/`error` locally so a background list
  /// refresh never clobbers an in-flight local edit. Swallows network
  /// errors -- callers keep whatever the local cache already has.
  Future<void> refreshFromNetwork({String? assetId, String? status}) async {
    try {
      final page = await _api.getInspections(assetId: assetId, status: status, limit: 100);
      for (final item in page.items) {
        await _upsertSyncedIfIdle(
          id: item.id,
          fetchDetail: () => _api.getInspection(item.id),
        );
      }
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  Future<void> refreshDetailFromNetwork(String id) async {
    try {
      await _upsertSyncedIfIdle(id: id, fetchDetail: () => _api.getInspection(id));
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  Future<void> _upsertSyncedIfIdle({
    required String id,
    required Future<InspectionDetail> Function() fetchDetail,
  }) async {
    final current = await (_db.select(_db.localInspections)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (current != null &&
        current.syncState != LocalSyncState.synced.wireValue &&
        current.syncState != LocalSyncState.localOnly.wireValue) {
      return;
    }
    final detail = await fetchDetail();
    await _upsertFromServer(detail, syncState: LocalSyncState.synced);
  }

  Future<void> _upsertFromServer(
    InspectionDetail detail, {
    required LocalSyncState syncState,
  }) async {
    await _db.into(_db.localInspections).insertOnConflictUpdate(
          LocalInspectionsCompanion.insert(
            id: detail.id,
            assetId: detail.assetId,
            facilityId: drift.Value(detail.facilityId),
            areaId: drift.Value(detail.areaId),
            inspectorId: detail.inspectorId,
            status: detail.status.name,
            inspectionType: detail.inspectionType.name,
            title: drift.Value(detail.title),
            notes: drift.Value(detail.notes),
            checklistTemplateId: drift.Value(detail.checklistTemplateId),
            checklistTemplateVersion: drift.Value(detail.checklistTemplateVersion),
            checklistItemsSnapshot: drift.Value(
              _encodeChecklistItems(detail.checklistItemsSnapshot?.toList() ?? const []),
            ),
            checklistResponses: drift.Value(
              _encodeChecklistResponses(detail.checklistResponses?.toList() ?? const []),
            ),
            startedAt: drift.Value(detail.startedAt),
            completedAt: drift.Value(detail.completedAt),
            gpsLat: drift.Value(detail.gpsLat?.toDouble()),
            gpsLng: drift.Value(detail.gpsLng?.toDouble()),
            clientCreatedAt: detail.clientCreatedAt,
            deviceId: drift.Value(detail.deviceId),
            origin: drift.Value(detail.origin),
            revision: drift.Value(detail.revision),
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt,
            syncState: drift.Value(syncState.wireValue),
            baseRevision: drift.Value(detail.revision),
            errorMessage: const drift.Value(null),
            conflictServerSnapshot: const drift.Value(null),
          ),
        );
  }

  // --------------------------------------------------------------- writes

  Future<String> createDraft({
    required String assetId,
    required String inspectorId,
    required String inspectionType,
    String? title,
    String? notes,
    double? gpsLat,
    double? gpsLng,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await _db.into(_db.localInspections).insert(
            LocalInspectionsCompanion.insert(
              id: id,
              assetId: assetId,
              inspectorId: inspectorId,
              status: 'draft',
              inspectionType: inspectionType,
              title: drift.Value(title),
              notes: drift.Value(notes),
              gpsLat: drift.Value(gpsLat),
              gpsLng: drift.Value(gpsLng),
              clientCreatedAt: now,
              createdAt: now,
              updatedAt: now,
              syncState: const drift.Value('local_only'),
            ),
          );
      final request = CreateInspectionRequest(
        (b) => b
          ..id = id
          ..assetId = assetId
          ..inspectionType = CreateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(inspectionType),
          )
          ..title = title
          ..notes = notes
          ..gpsLat = gpsLat
          ..gpsLng = gpsLng
          ..clientCreatedAt = now,
      );
      await _enqueue(
        inspectionId: id,
        type: OutboxMutationType.create,
        payload: jsonEncode(
          standardSerializers.serializeWith(CreateInspectionRequest.serializer, request),
        ),
      );
    });
    return id;
  }

  /// Merges the given fields over the current local row, marks it
  /// `pending_sync`, and coalesces into the existing not-yet-attempted
  /// `update` outbox row for this inspection (if any) rather than stacking
  /// a duplicate -- a row that already has `attempts > 0` is left alone
  /// (already in flight) and a fresh row is appended instead.
  Future<void> updateInspection(
    String id, {
    String? title,
    String? notes,
    String? inspectionType,
    double? gpsLat,
    double? gpsLng,
    List<ChecklistResponse>? checklistResponses,
  }) async {
    await _db.transaction(() async {
      final current =
          await (_db.select(_db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final mergedTitle = title ?? current.title;
      final mergedNotes = notes ?? current.notes;
      final mergedType = inspectionType ?? current.inspectionType;
      final mergedLat = gpsLat ?? current.gpsLat;
      final mergedLng = gpsLng ?? current.gpsLng;
      final mergedResponses = checklistResponses ??
          _decodeChecklistResponses(current.checklistResponses);

      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          title: drift.Value(mergedTitle),
          notes: drift.Value(mergedNotes),
          inspectionType: drift.Value(mergedType),
          gpsLat: drift.Value(mergedLat),
          gpsLng: drift.Value(mergedLng),
          checklistResponses: drift.Value(_encodeChecklistResponses(mergedResponses)),
          updatedAt: drift.Value(DateTime.now().toUtc()),
          syncState: const drift.Value('pending_sync'),
        ),
      );

      final request = UpdateInspectionRequest(
        (b) => b
          ..title = mergedTitle
          ..notes = mergedNotes
          ..inspectionType = UpdateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(mergedType),
          )
          ..gpsLat = mergedLat
          ..gpsLng = mergedLng
          ..checklistResponses.replace(mergedResponses)
          ..expectedRevision = current.baseRevision,
      );
      final payload = jsonEncode(
        standardSerializers.serializeWith(UpdateInspectionRequest.serializer, request),
      );

      final coalesceTarget = await (_db.select(_db.outbox)
            ..where(
              (t) =>
                  t.inspectionId.equals(id) &
                  t.mutationType.equals(OutboxMutationType.update.wireValue) &
                  t.attempts.equals(0),
            ))
          .getSingleOrNull();
      if (coalesceTarget != null) {
        await (_db.update(_db.outbox)..where((t) => t.id.equals(coalesceTarget.id)))
            .write(OutboxCompanion(payload: drift.Value(payload)));
      } else {
        await _enqueue(inspectionId: id, type: OutboxMutationType.update, payload: payload);
      }
    });
  }

  Future<void> startInspection(String id) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      final current =
          await (_db.select(_db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          status: const drift.Value('in_progress'),
          startedAt: drift.Value(current.startedAt ?? now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(inspectionId: id, type: OutboxMutationType.start, payload: '{}');
    });
  }

  Future<void> completeInspection(String id) async {
    await _db.transaction(() async {
      final current =
          await (_db.select(_db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final items = _decodeChecklistItems(current.checklistItemsSnapshot);
      final responses = _decodeChecklistResponses(current.checklistResponses);
      final missing = [
        for (final item in items)
          if (item.required_ && !responses.any((r) => r.itemId == item.id && _isAnswered(r)))
            item.id,
      ];
      if (missing.isNotEmpty) throw ChecklistIncompleteError(missing);

      final now = DateTime.now().toUtc();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          status: const drift.Value('completed'),
          completedAt: drift.Value(now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(inspectionId: id, type: OutboxMutationType.complete, payload: '{}');
    });
  }

  Future<void> cancelInspection(String id) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          status: const drift.Value('cancelled'),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(inspectionId: id, type: OutboxMutationType.cancel, payload: '{}');
    });
  }

  Future<void> assignChecklistTemplate(
    String id, {
    required String templateId,
    required int version,
    required List<ChecklistTemplateItem> items,
  }) async {
    await _db.transaction(() async {
      final current =
          await (_db.select(_db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final now = DateTime.now().toUtc();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          checklistTemplateId: drift.Value(templateId),
          checklistTemplateVersion: drift.Value(version),
          checklistItemsSnapshot: drift.Value(_encodeChecklistItems(items)),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      final request = AssignChecklistTemplateRequest(
        (b) => b
          ..checklistTemplateId = templateId
          ..expectedRevision = current.baseRevision,
      );
      final payload = jsonEncode(
        standardSerializers.serializeWith(AssignChecklistTemplateRequest.serializer, request),
      );
      await _enqueue(inspectionId: id, type: OutboxMutationType.assignTemplate, payload: payload);
    });
  }

  /// `keepLocal`: requeues the local edit as a fresh `update` against the
  /// conflict snapshot's revision. `!keepLocal`: overwrites the local row
  /// from [LocalInspectionRecord.conflictServerSnapshot] and drops every
  /// queued mutation for this inspection -- the user explicitly chose to
  /// discard the local edit, so replaying it would be exactly the silent
  /// data loss this flow exists to prevent.
  Future<void> resolveConflict(String id, {required bool keepLocal}) async {
    await _db.transaction(() async {
      final current =
          await (_db.select(_db.localInspections)..where((t) => t.id.equals(id))).getSingle();
      final snapshotJson = current.conflictServerSnapshot;
      if (snapshotJson == null) return;
      final snapshot = standardSerializers.deserializeWith(
        InspectionDetail.serializer,
        jsonDecode(snapshotJson) as Map<String, dynamic>,
      )!;

      if (!keepLocal) {
        await (_db.delete(_db.outbox)..where((t) => t.inspectionId.equals(id))).go();
        await _upsertFromServer(snapshot, syncState: LocalSyncState.synced);
        notifyListeners();
        return;
      }

      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id))).write(
        LocalInspectionsCompanion(
          revision: drift.Value(snapshot.revision),
          baseRevision: drift.Value(snapshot.revision),
          syncState: const drift.Value('pending_sync'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: const drift.Value(null),
        ),
      );
      final request = UpdateInspectionRequest(
        (b) => b
          ..title = current.title
          ..notes = current.notes
          ..inspectionType = UpdateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(current.inspectionType),
          )
          ..gpsLat = current.gpsLat
          ..gpsLng = current.gpsLng
          ..checklistResponses.replace(_decodeChecklistResponses(current.checklistResponses))
          ..expectedRevision = snapshot.revision,
      );
      await _enqueue(
        inspectionId: id,
        type: OutboxMutationType.update,
        payload: jsonEncode(
          standardSerializers.serializeWith(UpdateInspectionRequest.serializer, request),
        ),
      );
    });
  }

  // -------------------------------------------------------------- outbox

  Stream<List<OutboxItemRecord>> watchOutbox() {
    return (_db.select(_db.outbox)..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]))
        .watch()
        .map((rows) => rows.map(OutboxItemRecord.new).toList());
  }

  /// A plain one-shot count (not a watch stream) -- for [SyncEngine]'s
  /// [ChangeNotifier]-driven recount, which must never hold its own live
  /// Drift query subscription open (see the constructor's comment).
  Future<int> outboxCount() async {
    final rows = await _db.select(_db.outbox).get();
    return rows.length;
  }

  /// Clears backoff (and any paused-by-permanent-error state) so the next
  /// drain pass picks this row up immediately, bypassing whatever wait it
  /// was under.
  Future<void> retryOutboxItem(String outboxId) async {
    await (_db.update(_db.outbox)..where((t) => t.id.equals(outboxId))).write(
      const OutboxCompanion(nextAttemptAt: drift.Value(null)),
    );
    notifyListeners();
  }

  Future<void> discardOutboxItem(String outboxId) async {
    await _db.transaction(() async {
      final item =
          await (_db.select(_db.outbox)..where((t) => t.id.equals(outboxId))).getSingleOrNull();
      if (item == null) return;
      await (_db.delete(_db.outbox)..where((t) => t.id.equals(outboxId))).go();
      final remaining = await (_db.select(_db.outbox)
            ..where((t) => t.inspectionId.equals(item.inspectionId)))
          .get();
      if (remaining.isEmpty) {
        await (_db.update(_db.localInspections)..where((t) => t.id.equals(item.inspectionId)))
            .write(
          const LocalInspectionsCompanion(
            syncState: drift.Value('error'),
            errorMessage: drift.Value(
              'A pending change was discarded and never reached the server.',
            ),
          ),
        );
      }
    });
    notifyListeners();
  }

  Future<void> _enqueue({
    required String inspectionId,
    required OutboxMutationType type,
    required String payload,
  }) async {
    await _db.into(_db.outbox).insert(
          OutboxCompanion.insert(
            id: _uuid.v4(),
            inspectionId: inspectionId,
            mutationType: type.wireValue,
            payload: payload,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    notifyListeners();
  }

  // ------------------------------------------------------ sync-engine API

  /// Outbox rows due for replay, oldest-first. "Due" excludes both an
  /// active backoff window and the [pausedSentinel] a permanent error sets.
  /// `bypassBackoff: true` (manual "Sync now") skips the backoff wait but
  /// still respects [pausedSentinel] -- a permanently-failed row still
  /// needs an explicit per-item retry, not a bulk "sync now".
  Future<List<OutboxItemRecord>> queueForDrain({
    required DateTime now,
    bool bypassBackoff = false,
  }) async {
    final query = _db.select(_db.outbox)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]);
    if (bypassBackoff) {
      query.where((t) => t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerThanValue(pausedSentinel));
    } else {
      query.where((t) => t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerOrEqualValue(now));
    }
    final rows = await query.get();
    return rows.map(OutboxItemRecord.new).toList();
  }

  /// A mutation round-tripped successfully. Deletes the outbox row; if no
  /// other outbox rows remain queued for this inspection, the local row
  /// becomes `synced` with the server's authoritative fields -- otherwise
  /// it stays `pending_sync` (more mutations are still queued) but still
  /// picks up the server's now-current revision/fields.
  Future<void> applyMutationSuccess({
    required OutboxItemRecord item,
    required InspectionDetail server,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.outbox)..where((t) => t.id.equals(item.id))).go();
      final remaining = await (_db.select(_db.outbox)
            ..where((t) => t.inspectionId.equals(item.inspectionId)))
          .get();
      await _upsertFromServer(
        server,
        syncState: remaining.isEmpty ? LocalSyncState.synced : LocalSyncState.pendingSync,
      );
    });
    notifyListeners();
  }

  Future<void> markTransientFailure(
    OutboxItemRecord item, {
    required String message,
    required DateTime nextAttemptAt,
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.outbox)..where((t) => t.id.equals(item.id))).write(
        OutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(nextAttemptAt),
        ),
      );
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(item.inspectionId))).write(
        LocalInspectionsCompanion(
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  /// A non-retryable failure (validation error, 404, etc.). The outbox row
  /// stays (for manual retry/discard) but is paused via [pausedSentinel] so
  /// the drain loop doesn't immediately retry a mutation that can't
  /// possibly succeed as-is.
  Future<void> markPermanentError(OutboxItemRecord item, {required String message}) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.outbox)..where((t) => t.id.equals(item.id))).write(
        OutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(pausedSentinel),
        ),
      );
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(item.inspectionId))).write(
        LocalInspectionsCompanion(
          syncState: const drift.Value('error'),
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  /// The mutation raced a change already applied elsewhere (stale
  /// `expected_revision`/status). Every other queued mutation for this
  /// inspection is dropped too -- they were all computed against the same
  /// now-stale base and would only conflict again -- and the local row
  /// surfaces the conflict for the user to resolve via [resolveConflict].
  Future<void> markConflict({
    required String inspectionId,
    required InspectionDetail serverSnapshot,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.outbox)..where((t) => t.inspectionId.equals(inspectionId))).go();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(inspectionId))).write(
        LocalInspectionsCompanion(
          syncState: const drift.Value('conflict'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: drift.Value(
            jsonEncode(standardSerializers.serializeWith(InspectionDetail.serializer, serverSnapshot)),
          ),
        ),
      );
    });
    notifyListeners();
  }

  /// A replayed mutation's target already matches what the mutation was
  /// trying to set -- i.e. it actually succeeded before the app died
  /// mid-request, and this is a retry of that same attempt. Treated as
  /// success, not a conflict.
  Future<void> applyAlreadyApplied({
    required OutboxItemRecord item,
    required InspectionDetail server,
  }) =>
      applyMutationSuccess(item: item, server: server);

  // ------------------------------------------------------------- session

  static const _ownerUidKey = 'fev_offline_data_owner_uid';

  Future<void> wipeAllLocalData() async {
    await _db.transaction(() async {
      await _db.delete(_db.outbox).go();
      await _db.delete(_db.localInspections).go();
    });
    notifyListeners();
  }

  /// Compares [uid] to whichever uid last owned this device's local cache
  /// (persisted in `shared_preferences`, independent of Firebase's own
  /// session storage). A different uid wipes local inspections+outbox --
  /// the shared-device tenant boundary (D-004) -- while a same-user
  /// re-sign-in, an app restart, or a token refresh is always a no-op.
  /// Call this after every successful auth resolution, not just sign-out,
  /// since sign-out alone doesn't know who's signing in next.
  Future<void> reconcileSessionOwner(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final lastOwner = preferences.getString(_ownerUidKey);
    if (lastOwner != null && lastOwner != uid) {
      await wipeAllLocalData();
    }
    await preferences.setString(_ownerUidKey, uid);
  }
}
