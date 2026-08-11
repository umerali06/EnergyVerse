import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../db/app_database.dart';
import '../inspections/local_inspections_repository.dart' show dartEnumNameToWire;

/// Mirrors [LocalSyncState] (`local_inspections_repository.dart`) but a work
/// order never starts `local_only` -- see `LocalWorkOrders`'s class doc.
enum WorkOrderLocalSyncState {
  synced('synced'),
  pendingSync('pending_sync'),
  conflict('conflict'),
  error('error');

  const WorkOrderLocalSyncState(this.wireValue);

  final String wireValue;
}

/// The work-order outbox's mutation kinds -- only the technician-only,
/// field-performed actions ever queue offline (see `WorkOrderOutbox`'s class
/// doc for why `assign`/`close`/`cancel` don't).
enum WorkOrderOutboxMutationType {
  accept('accept'),
  submitForReview('submit_for_review');

  const WorkOrderOutboxMutationType(this.wireValue);

  final String wireValue;

  static WorkOrderOutboxMutationType fromWire(String value) =>
      values.firstWhere((type) => type.wireValue == value);
}

class WorkOrderOutboxItemRecord {
  WorkOrderOutboxItemRecord(this.row);

  final WorkOrderOutboxData row;

  String get id => row.id;
  String get workOrderId => row.workOrderId;
  WorkOrderOutboxMutationType get mutationType =>
      WorkOrderOutboxMutationType.fromWire(row.mutationType);
  int get attempts => row.attempts;
  String? get lastError => row.lastError;
  DateTime? get lastAttemptAt => row.lastAttemptAt;
  DateTime? get nextAttemptAt => row.nextAttemptAt;
}

/// Same sentinel/rationale as `local_inspections_repository.dart`'s
/// `pausedSentinel` -- a permanently-failed row is paused, not deleted, so a
/// manual per-item retry/discard is still possible.
final DateTime workOrderPausedSentinel = DateTime.utc(9999);

class LocalWorkOrderRecord {
  LocalWorkOrderRecord(this.row)
      : materialsUsed = _decodeMaterialsUsed(row.materialsUsed);

  final LocalWorkOrder row;
  final List<String> materialsUsed;
}

List<String> _decodeMaterialsUsed(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list.cast<String>();
}

String _encodeMaterialsUsed(List<String> materials) => jsonEncode(materials);

/// Offline-first facade over the local Drift cache + its own
/// [WorkOrderOutbox] for work orders (Phase 8.2). Unlike
/// [LocalInspectionsRepository], every row here originates from a server
/// fetch (a work order is only ever created by admin, always online) -- read
/// paths serve from cache and refresh best-effort; only `accept`/
/// `submitForReview` (technician-only field actions) write locally first and
/// queue an outbox mutation for [WorkOrderSyncEngine] to replay.
class LocalWorkOrdersRepository extends ChangeNotifier {
  LocalWorkOrdersRepository(
      {required AppDatabase db, required ApiContract api, Uuid? uuid})
      : _db = db,
        _api = api,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final ApiContract _api;
  final Uuid _uuid;

  // ---------------------------------------------------------------- reads

  Stream<List<LocalWorkOrderRecord>> watchWorkOrders({
    String? assetId,
    String? status,
    String? technicianId,
  }) {
    final query = _db.select(_db.localWorkOrders)
      ..orderBy([(t) => drift.OrderingTerm.desc(t.updatedAt)]);
    if (assetId != null) query.where((t) => t.assetId.equals(assetId));
    if (status != null) query.where((t) => t.status.equals(status));
    if (technicianId != null) {
      query.where((t) => t.technicianId.equals(technicianId));
    }
    return query
        .watch()
        .map((rows) => rows.map(LocalWorkOrderRecord.new).toList());
  }

  Stream<LocalWorkOrderRecord?> watchWorkOrder(String id) {
    return (_db.select(_db.localWorkOrders)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : LocalWorkOrderRecord(row));
  }

  Future<LocalWorkOrderRecord?> getWorkOrder(String id) async {
    final row = await (_db.select(_db.localWorkOrders)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : LocalWorkOrderRecord(row);
  }

  /// Best-effort: lists from the server (which only returns
  /// `WorkOrderListItem`, a partial shape), then fetches each item's full
  /// `WorkOrderDetail` -- mirrors `LocalInspectionsRepository.
  /// refreshFromNetwork`'s two-step shape. Skips any row that's
  /// `pending_sync`/`conflict`/`error` locally so a background refresh never
  /// clobbers an in-flight accept/submit-for-review. Swallows network
  /// errors -- callers keep whatever the local cache already has.
  Future<void> refreshFromNetwork({
    String? assetId,
    String? status,
    String? technicianId,
  }) async {
    try {
      final page = await _api.getWorkOrders(
        assetId: assetId,
        status: status,
        technicianId: technicianId,
        limit: 100,
      );
      for (final item in page.items) {
        await _upsertSyncedIfIdle(
          id: item.id,
          fetchDetail: () => _api.getWorkOrder(item.id),
        );
      }
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  Future<void> refreshDetailFromNetwork(String id) async {
    try {
      await _upsertSyncedIfIdle(
          id: id, fetchDetail: () => _api.getWorkOrder(id));
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  Future<void> _upsertSyncedIfIdle({
    required String id,
    required Future<WorkOrderDetail> Function() fetchDetail,
  }) async {
    final current = await (_db.select(_db.localWorkOrders)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (current != null &&
        current.syncState != WorkOrderLocalSyncState.synced.wireValue) {
      return;
    }
    final detail = await fetchDetail();
    await _upsertFromServer(detail, syncState: WorkOrderLocalSyncState.synced);
  }

  Future<void> _upsertFromServer(
    WorkOrderDetail detail, {
    required WorkOrderLocalSyncState syncState,
  }) async {
    await _db.into(_db.localWorkOrders).insertOnConflictUpdate(
          LocalWorkOrdersCompanion.insert(
            id: detail.id,
            assetId: detail.assetId,
            facilityId: detail.facilityId,
            title: detail.title,
            description: drift.Value(detail.description),
            priority: dartEnumNameToWire(detail.priority.name),
            status: dartEnumNameToWire(detail.status.name),
            sourceInspectionId: drift.Value(detail.sourceInspectionId),
            technicianId: drift.Value(detail.technicianId),
            assignedBy: drift.Value(detail.assignedBy),
            assignedAt: drift.Value(detail.assignedAt),
            dueDate: drift.Value(detail.dueDate),
            acceptedAt: drift.Value(detail.acceptedAt),
            laborHours: drift.Value(detail.laborHours?.toDouble()),
            materialsUsed: drift.Value(
                _encodeMaterialsUsed(detail.materialsUsed?.toList() ?? const [])),
            completionNotes: drift.Value(detail.completionNotes),
            submittedAt: drift.Value(detail.submittedAt),
            closedBy: drift.Value(detail.closedBy),
            closedAt: drift.Value(detail.closedAt),
            cancelledAt: drift.Value(detail.cancelledAt),
            revision: drift.Value(detail.revision),
            createdAt: detail.createdAt,
            createdBy: detail.createdBy,
            updatedAt: detail.updatedAt,
            syncState: drift.Value(syncState.wireValue),
            baseRevision: drift.Value(detail.revision),
            errorMessage: const drift.Value(null),
            conflictServerSnapshot: const drift.Value(null),
          ),
        );
  }

  // --------------------------------------------------------------- writes

  /// "Accept Task" -- bodyless, no `expected_revision` (mirrors
  /// `startInspection`/`cancelInspection`'s shape; the backend's
  /// `WorkOrderRepository.accept` carries no revision check at all).
  Future<void> acceptWorkOrder(String id) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.localWorkOrders)..where((t) => t.id.equals(id)))
          .write(
        LocalWorkOrdersCompanion(
          status: const drift.Value('in_progress'),
          acceptedAt: drift.Value(now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(
        workOrderId: id,
        type: WorkOrderOutboxMutationType.accept,
        payload: '{}',
      );
    });
  }

  /// Submits the technician's completed repair for supervisor review --
  /// carries `expected_revision` (mirrors `updateInspection`'s shape).
  Future<void> submitWorkOrderForReview(
    String id, {
    required String completionNotes,
    double? laborHours,
    List<String> materialsUsed = const [],
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      final current = await (_db.select(_db.localWorkOrders)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      await (_db.update(_db.localWorkOrders)..where((t) => t.id.equals(id)))
          .write(
        LocalWorkOrdersCompanion(
          status: const drift.Value('pending_review'),
          completionNotes: drift.Value(completionNotes),
          laborHours: drift.Value(laborHours),
          materialsUsed: drift.Value(_encodeMaterialsUsed(materialsUsed)),
          submittedAt: drift.Value(now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      final request = SubmitWorkOrderForReviewRequest(
        (b) => b
          ..completionNotes = completionNotes
          ..laborHours = laborHours
          ..materialsUsed.replace(materialsUsed)
          ..expectedRevision = current.baseRevision,
      );
      await _enqueue(
        workOrderId: id,
        type: WorkOrderOutboxMutationType.submitForReview,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              SubmitWorkOrderForReviewRequest.serializer, request),
        ),
      );
    });
  }

  /// `keepLocal`: requeues the local completion-notes/labor/materials edit
  /// as a fresh `submit_for_review` against the conflict snapshot's
  /// revision. `!keepLocal`: overwrites the local row from
  /// [LocalWorkOrderRecord]'s `conflictServerSnapshot` and drops every
  /// queued mutation for this work order. Mirrors
  /// `LocalInspectionsRepository.resolveConflict` exactly.
  Future<void> resolveConflict(String id, {required bool keepLocal}) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localWorkOrders)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final snapshotJson = current.conflictServerSnapshot;
      if (snapshotJson == null) return;
      final snapshot = standardSerializers.deserializeWith(
        WorkOrderDetail.serializer,
        jsonDecode(snapshotJson) as Map<String, dynamic>,
      )!;

      if (!keepLocal) {
        await (_db.delete(_db.workOrderOutbox)
              ..where((t) => t.workOrderId.equals(id)))
            .go();
        await _upsertFromServer(snapshot,
            syncState: WorkOrderLocalSyncState.synced);
        return;
      }

      await (_db.update(_db.localWorkOrders)..where((t) => t.id.equals(id)))
          .write(
        LocalWorkOrdersCompanion(
          revision: drift.Value(snapshot.revision),
          baseRevision: drift.Value(snapshot.revision),
          syncState: const drift.Value('pending_sync'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: const drift.Value(null),
        ),
      );
      final request = SubmitWorkOrderForReviewRequest(
        (b) => b
          ..completionNotes = current.completionNotes ?? ''
          ..laborHours = current.laborHours
          ..materialsUsed.replace(_decodeMaterialsUsed(current.materialsUsed))
          ..expectedRevision = snapshot.revision,
      );
      await _enqueue(
        workOrderId: id,
        type: WorkOrderOutboxMutationType.submitForReview,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              SubmitWorkOrderForReviewRequest.serializer, request),
        ),
      );
      notifyListeners();
    });
  }

  Future<void> _enqueue({
    required String workOrderId,
    required WorkOrderOutboxMutationType type,
    required String payload,
  }) async {
    await _db.into(_db.workOrderOutbox).insert(
          WorkOrderOutboxCompanion.insert(
            id: _uuid.v4(),
            workOrderId: workOrderId,
            mutationType: type.wireValue,
            payload: payload,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    notifyListeners();
  }

  // ------------------------------------------------------ sync-engine API

  Future<int> outboxCount() async {
    final rows = await _db.select(_db.workOrderOutbox).get();
    return rows.length;
  }

  Future<List<WorkOrderOutboxItemRecord>> queueForDrain({
    required DateTime now,
    bool bypassBackoff = false,
  }) async {
    final query = _db.select(_db.workOrderOutbox)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]);
    if (bypassBackoff) {
      query.where((t) =>
          t.nextAttemptAt.isNull() |
          t.nextAttemptAt.isSmallerThanValue(workOrderPausedSentinel));
    } else {
      query.where((t) =>
          t.nextAttemptAt.isNull() |
          t.nextAttemptAt.isSmallerOrEqualValue(now));
    }
    final rows = await query.get();
    return rows.map(WorkOrderOutboxItemRecord.new).toList();
  }

  Future<void> applyMutationSuccess({
    required WorkOrderOutboxItemRecord item,
    required WorkOrderDetail server,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.workOrderOutbox)..where((t) => t.id.equals(item.id)))
          .go();
      final remaining = await (_db.select(_db.workOrderOutbox)
            ..where((t) => t.workOrderId.equals(item.workOrderId)))
          .get();
      await _upsertFromServer(
        server,
        syncState: remaining.isEmpty
            ? WorkOrderLocalSyncState.synced
            : WorkOrderLocalSyncState.pendingSync,
      );
    });
  }

  Future<void> markTransientFailure(
    WorkOrderOutboxItemRecord item, {
    required String message,
    required DateTime nextAttemptAt,
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.workOrderOutbox)..where((t) => t.id.equals(item.id)))
          .write(
        WorkOrderOutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(nextAttemptAt),
        ),
      );
      await (_db.update(_db.localWorkOrders)
            ..where((t) => t.id.equals(item.workOrderId)))
          .write(
        LocalWorkOrdersCompanion(
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> markPermanentError(WorkOrderOutboxItemRecord item,
      {required String message}) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.workOrderOutbox)..where((t) => t.id.equals(item.id)))
          .write(
        WorkOrderOutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(workOrderPausedSentinel),
        ),
      );
      await (_db.update(_db.localWorkOrders)
            ..where((t) => t.id.equals(item.workOrderId)))
          .write(
        LocalWorkOrdersCompanion(
          syncState: const drift.Value('error'),
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  /// Same "drop every other queued mutation, surface the fresh snapshot"
  /// posture as `LocalInspectionsRepository.markConflict` -- and the same
  /// care about WHICH fields to sync from the snapshot: only the
  /// status-machinery fields (`status`/`technicianId`/`acceptedAt`) are
  /// overwritten so a stale optimistic status flip never lingers, exactly
  /// like inspections' `complete` conflict handling. `completionNotes`/
  /// `laborHours`/`materialsUsed`/`submittedAt` are deliberately left as
  /// whatever the local optimistic `submitWorkOrderForReview` write already
  /// set -- that's the technician's own real content, and it's exactly what
  /// `resolveConflict(keepLocal: true)` needs to still be there to re-submit.
  /// The server's conflicting version of those fields lives in
  /// `conflictServerSnapshot` for the "use server's" path instead.
  Future<void> markConflict({
    required String workOrderId,
    required WorkOrderDetail serverSnapshot,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.workOrderOutbox)
            ..where((t) => t.workOrderId.equals(workOrderId)))
          .go();
      await (_db.update(_db.localWorkOrders)
            ..where((t) => t.id.equals(workOrderId)))
          .write(
        LocalWorkOrdersCompanion(
          status: drift.Value(dartEnumNameToWire(serverSnapshot.status.name)),
          technicianId: drift.Value(serverSnapshot.technicianId),
          acceptedAt: drift.Value(serverSnapshot.acceptedAt),
          syncState: const drift.Value('conflict'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: drift.Value(
            jsonEncode(standardSerializers.serializeWith(
                WorkOrderDetail.serializer, serverSnapshot)),
          ),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> applyAlreadyApplied({
    required WorkOrderOutboxItemRecord item,
    required WorkOrderDetail server,
  }) =>
      applyMutationSuccess(item: item, server: server);

  // ------------------------------------------------------------- session

  static const _ownerUidKey = 'fev_offline_data_owner_uid_work_orders';

  Future<void> wipeAllLocalData() async {
    await _db.transaction(() async {
      await _db.delete(_db.workOrderOutbox).go();
      await _db.delete(_db.localWorkOrders).go();
    });
    notifyListeners();
  }

  /// Independent tracker from `LocalInspectionsRepository.
  /// reconcileSessionOwner` (its own `shared_preferences` key) -- see this
  /// class's own module-level rationale in the phase's docs for why the two
  /// don't share state: reading/writing the SAME key from two repositories
  /// on every auth change would race on which one observes the stale value.
  Future<void> reconcileSessionOwner(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final lastOwner = preferences.getString(_ownerUidKey);
    if (lastOwner != null && lastOwner != uid) {
      await wipeAllLocalData();
    }
    await preferences.setString(_ownerUidKey, uid);
  }
}
