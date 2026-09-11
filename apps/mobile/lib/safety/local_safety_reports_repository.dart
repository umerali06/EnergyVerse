import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../db/app_database.dart';
import '../inspections/local_inspections_repository.dart'
    show dartEnumNameToWire;

enum SafetyLocalSyncState {
  localOnly('local_only'),
  pendingSync('pending_sync'),
  synced('synced'),
  error('error');

  const SafetyLocalSyncState(this.wireValue);
  final String wireValue;
}

class LocalSafetyReportRecord {
  LocalSafetyReportRecord(this.row)
      : evidence =
            _decodeModels(row.evidence, SafetyEvidenceResponse.serializer),
        correctiveActions = _decodeModels(
            row.correctiveActions, CorrectiveActionResponse.serializer);
  final LocalSafetyReport row;
  final List<SafetyEvidenceResponse> evidence;
  final List<CorrectiveActionResponse> correctiveActions;
}

List<T> _decodeModels<T>(String value, Serializer<T> serializer) =>
    (jsonDecode(value) as List<dynamic>)
        .map((item) =>
            standardSerializers.deserializeWith(serializer, item as Object)!)
        .toList();

class SafetyOutboxItemRecord {
  const SafetyOutboxItemRecord(this.row);
  final SafetyOutboxData row;
}

final DateTime safetyPausedSentinel = DateTime.utc(9999);

class LocalSafetyReportsRepository extends ChangeNotifier {
  LocalSafetyReportsRepository({
    required AppDatabase db,
    required SafetyApiContract api,
    Uuid? uuid,
  })  : _db = db,
        _api = api,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final SafetyApiContract _api;
  final Uuid _uuid;

  Stream<List<LocalSafetyReportRecord>> watchReports({
    String? status,
    String? severity,
    String? reporterId,
  }) {
    final query = _db.select(_db.localSafetyReports)
      ..orderBy([(t) => drift.OrderingTerm.desc(t.occurredAt)]);
    if (status != null) query.where((t) => t.status.equals(status));
    if (severity != null) query.where((t) => t.severity.equals(severity));
    if (reporterId != null) query.where((t) => t.reporterId.equals(reporterId));
    return query.watch().map(
          (rows) => rows.map(LocalSafetyReportRecord.new).toList(),
        );
  }

  Stream<LocalSafetyReportRecord?> watchReport(String id) =>
      (_db.select(_db.localSafetyReports)..where((t) => t.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : LocalSafetyReportRecord(row));

  Future<void> refreshFromNetwork({
    String? status,
    String? severity,
    String? reporterId,
  }) async {
    try {
      final page = await _api.getSafetyReports(
        status: status,
        severity: severity,
        reporterId: reporterId,
        limit: 100,
      );
      for (final item in page.items) {
        final local = await (_db.select(_db.localSafetyReports)
              ..where((t) => t.id.equals(item.id)))
            .getSingleOrNull();
        if (local != null &&
            local.syncState != SafetyLocalSyncState.synced.wireValue) {
          continue;
        }
        await _upsertServer(await _api.getSafetyReport(item.id));
      }
    } catch (_) {
      // Offline-first read: retain the last durable cache on network failure.
    }
  }

  Future<void> refreshDetailFromNetwork(String id) async {
    try {
      final local = await (_db.select(_db.localSafetyReports)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (local == null ||
          local.syncState == SafetyLocalSyncState.synced.wireValue) {
        await _upsertServer(await _api.getSafetyReport(id));
      }
    } catch (_) {}
  }

  Future<String> createOffline({
    required String reporterId,
    required CreateSafetyReportRequestCategoryEnum category,
    required CreateSafetyReportRequestSeverityEnum severity,
    required String title,
    required String description,
    required DateTime occurredAt,
    double? gpsLat,
    double? gpsLng,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    final request = CreateSafetyReportRequest(
      (b) => b
        ..id = id
        ..category = category
        ..severity = severity
        ..title = title.trim()
        ..description = description.trim()
        ..occurredAt = occurredAt.toUtc()
        ..gpsLat = gpsLat
        ..gpsLng = gpsLng,
    );
    final payload = jsonEncode(
      standardSerializers.serializeWith(
        CreateSafetyReportRequest.serializer,
        request,
      ),
    );
    await _db.transaction(() async {
      await _db.into(_db.localSafetyReports).insert(
            LocalSafetyReportsCompanion.insert(
              id: id,
              category: dartEnumNameToWire(category.name),
              severity: dartEnumNameToWire(severity.name),
              title: title.trim(),
              description: description.trim(),
              occurredAt: occurredAt.toUtc(),
              gpsLat: drift.Value(gpsLat),
              gpsLng: drift.Value(gpsLng),
              reporterId: reporterId,
              createdAt: now,
              updatedAt: now,
              syncState: const drift.Value('local_only'),
            ),
          );
      await _db.into(_db.safetyOutbox).insert(
            SafetyOutboxCompanion.insert(
              id: _uuid.v4(),
              reportId: id,
              mutationType: 'create',
              payload: payload,
              createdAt: now,
            ),
          );
    });
    notifyListeners();
    return id;
  }

  Future<void> updateCorrectiveActionOffline({
    required String reportId,
    required String actionId,
    required UpdateCorrectiveActionRequestStatusEnum status,
    String? completionNotes,
  }) async {
    final request = UpdateCorrectiveActionRequest((b) => b
      ..status = status
      ..completionNotes = completionNotes?.trim());
    await _db.transaction(() async {
      final current = await (_db.select(_db.localSafetyReports)
            ..where((row) => row.id.equals(reportId)))
          .getSingle();
      final actions = _decodeModels(
          current.correctiveActions, CorrectiveActionResponse.serializer);
      final index = actions.indexWhere((action) => action.id == actionId);
      if (index < 0) throw StateError('Corrective action is not cached');
      final now = DateTime.now().toUtc();
      actions[index] = actions[index].rebuild((b) {
        b.status = CorrectiveActionResponseStatusEnum.valueOf(status.name);
        b.updatedAt = now;
        if (status == UpdateCorrectiveActionRequestStatusEnum.inProgress) {
          b.startedAt = now;
        } else {
          b.completedAt = now;
          b.completionNotes = completionNotes?.trim();
        }
      });
      await (_db.update(_db.localSafetyReports)
            ..where((row) => row.id.equals(reportId)))
          .write(LocalSafetyReportsCompanion(
        correctiveActions: drift.Value(
            _encodeModels(actions, CorrectiveActionResponse.serializer)),
        syncState: const drift.Value('pending_sync'),
        updatedAt: drift.Value(now),
      ));
      await _db.into(_db.safetyOutbox).insert(
            SafetyOutboxCompanion.insert(
              id: _uuid.v4(),
              reportId: reportId,
              targetId: drift.Value(actionId),
              mutationType: 'update_action',
              payload: jsonEncode(standardSerializers.serializeWith(
                  UpdateCorrectiveActionRequest.serializer, request)),
              createdAt: now,
            ),
          );
    });
    notifyListeners();
  }

  Future<void> _upsertServer(SafetyReportDetail detail,
      {SafetyLocalSyncState state = SafetyLocalSyncState.synced}) async {
    await _db.into(_db.localSafetyReports).insertOnConflictUpdate(
          LocalSafetyReportsCompanion.insert(
            id: detail.id,
            category: dartEnumNameToWire(detail.category.name),
            severity: dartEnumNameToWire(detail.severity.name),
            title: detail.title,
            description: detail.description,
            occurredAt: detail.occurredAt,
            gpsLat: drift.Value(detail.gpsLat?.toDouble()),
            gpsLng: drift.Value(detail.gpsLng?.toDouble()),
            reporterId: detail.reporterId,
            status: drift.Value(dartEnumNameToWire(detail.status.name)),
            assignedManagerId: drift.Value(detail.assignedManagerId),
            revision: drift.Value(detail.revision),
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt,
            evidence: drift.Value(_encodeModels(
                detail.evidence?.toList() ?? const [],
                SafetyEvidenceResponse.serializer)),
            correctiveActions: drift.Value(_encodeModels(
                detail.correctiveActions?.toList() ?? const [],
                CorrectiveActionResponse.serializer)),
            syncState: drift.Value(state.wireValue),
            errorMessage: const drift.Value(null),
            conflictServerSnapshot: const drift.Value(null),
          ),
        );
  }

  Future<void> applyServerSnapshot(SafetyReportDetail detail) async {
    await _upsertServer(detail);
    notifyListeners();
  }

  String _encodeModels<T>(List<T> values, Serializer<T> serializer) =>
      jsonEncode(values
          .map((value) => standardSerializers.serializeWith(serializer, value))
          .toList());

  Future<int> outboxCount() async =>
      (await _db.select(_db.safetyOutbox).get()).length;

  Future<List<SafetyOutboxItemRecord>> queueForDrain({
    required DateTime now,
    bool bypassBackoff = false,
  }) async {
    final query = _db.select(_db.safetyOutbox)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]);
    query.where((t) => bypassBackoff
        ? t.nextAttemptAt.isNull() |
            t.nextAttemptAt.isSmallerThanValue(safetyPausedSentinel)
        : t.nextAttemptAt.isNull() |
            t.nextAttemptAt.isSmallerOrEqualValue(now));
    return (await query.get()).map(SafetyOutboxItemRecord.new).toList();
  }

  Future<void> applyCreateSuccess(
      SafetyOutboxItemRecord item, SafetyReportDetail detail) async {
    await _db.transaction(() async {
      await (_db.delete(_db.safetyOutbox)
            ..where((t) => t.id.equals(item.row.id)))
          .go();
      await _upsertServer(detail);
    });
    notifyListeners();
  }

  Future<void> applyMutationSuccess(
      SafetyOutboxItemRecord item, SafetyReportDetail detail) async {
    await _db.transaction(() async {
      await (_db.delete(_db.safetyOutbox)
            ..where((row) => row.id.equals(item.row.id)))
          .go();
      final remaining = await (_db.select(_db.safetyOutbox)
            ..where((row) => row.reportId.equals(item.row.reportId)))
          .get();
      await _upsertServer(detail,
          state: remaining.isEmpty
              ? SafetyLocalSyncState.synced
              : SafetyLocalSyncState.pendingSync);
    });
    notifyListeners();
  }

  Future<void> markTransientFailure(SafetyOutboxItemRecord item,
      {required String message, required DateTime nextAttemptAt}) async {
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await (_db.update(_db.safetyOutbox)
            ..where((t) => t.id.equals(item.row.id)))
          .write(SafetyOutboxCompanion(
        attempts: drift.Value(item.row.attempts + 1),
        lastAttemptAt: drift.Value(now),
        lastError: drift.Value(message),
        nextAttemptAt: drift.Value(nextAttemptAt),
      ));
      await (_db.update(_db.localSafetyReports)
            ..where((t) => t.id.equals(item.row.reportId)))
          .write(LocalSafetyReportsCompanion(
        syncState: const drift.Value('pending_sync'),
        errorMessage: drift.Value(message),
        lastAttemptAt: drift.Value(now),
      ));
    });
    notifyListeners();
  }

  Future<void> markPermanentError(SafetyOutboxItemRecord item,
      {required String message}) async {
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await (_db.update(_db.safetyOutbox)
            ..where((t) => t.id.equals(item.row.id)))
          .write(SafetyOutboxCompanion(
        attempts: drift.Value(item.row.attempts + 1),
        lastAttemptAt: drift.Value(now),
        lastError: drift.Value(message),
        nextAttemptAt: drift.Value(safetyPausedSentinel),
      ));
      await (_db.update(_db.localSafetyReports)
            ..where((t) => t.id.equals(item.row.reportId)))
          .write(LocalSafetyReportsCompanion(
        syncState: const drift.Value('error'),
        errorMessage: drift.Value(message),
        lastAttemptAt: drift.Value(now),
      ));
    });
    notifyListeners();
  }

  static const _ownerUidKey = 'fev_offline_data_owner_uid_safety';

  Future<void> reconcileSessionOwner(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final lastOwner = preferences.getString(_ownerUidKey);
    if (lastOwner != null && lastOwner != uid) {
      await _db.transaction(() async {
        await _db.delete(_db.safetyEvidenceQueue).go();
        await _db.delete(_db.safetyOutbox).go();
        await _db.delete(_db.localSafetyReports).go();
      });
      notifyListeners();
    }
    await preferences.setString(_ownerUidKey, uid);
  }
}
