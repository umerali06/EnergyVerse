import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../db/app_database.dart';
import '../inspections/local_inspections_repository.dart'
    show dartEnumNameToWire;

enum PermitLocalSyncState {
  synced('synced'),
  pendingSync('pending_sync'),
  conflict('conflict'),
  error('error');

  const PermitLocalSyncState(this.wireValue);
  final String wireValue;
}

final DateTime permitPausedSentinel = DateTime.utc(9999);

class PermitOutboxItemRecord {
  const PermitOutboxItemRecord(this.row);
  final PermitOutboxData row;
  String get id => row.id;
  String get permitId => row.permitId;
  int get attempts => row.attempts;
}

class LocalPermitRecord {
  LocalPermitRecord(this.row)
      : detail = standardSerializers.deserializeWith(
          PermitDetail.serializer,
          jsonDecode(row.detailJson) as Map<String, dynamic>,
        )!;
  final LocalPermit row;
  final PermitDetail detail;
}

class LocalPermitsRepository extends ChangeNotifier {
  LocalPermitsRepository(
      {required AppDatabase db, required PermitApiContract api, Uuid? uuid})
      : _db = db,
        _api = api,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final PermitApiContract _api;
  final Uuid _uuid;

  Stream<List<LocalPermitRecord>> watchPermits() =>
      (_db.select(_db.localPermits)
            ..orderBy([(t) => drift.OrderingTerm.desc(t.updatedAt)]))
          .watch()
          .map((rows) => rows.map(LocalPermitRecord.new).toList());

  Stream<LocalPermitRecord?> watchPermit(String id) =>
      (_db.select(_db.localPermits)..where((t) => t.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : LocalPermitRecord(row));

  Future<LocalPermitRecord?> getPermit(String id) async {
    final row = await (_db.select(_db.localPermits)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : LocalPermitRecord(row);
  }

  Future<void> refreshAssignedFromNetwork(String workerId) async {
    try {
      final assignedIds = <String>{};
      String? cursor;
      do {
        final page = await _api.getPermits(
            workerId: workerId, cursor: cursor, limit: 100);
        for (final item in page.items) {
          assignedIds.add(item.id);
          final existing = await (_db.select(_db.localPermits)
                ..where((t) => t.id.equals(item.id)))
              .getSingleOrNull();
          if (existing != null && existing.syncState != 'synced') continue;
          final detail = await _api.getPermit(item.id);
          await _upsert(detail, PermitLocalSyncState.synced);
        }
        cursor = page.nextCursor;
      } while (cursor != null);

      final stale = await (_db.select(_db.localPermits)
            ..where((t) => t.syncState.equals('synced')))
          .get();
      for (final permit in stale) {
        if (assignedIds.contains(permit.id)) continue;
        await (_db.delete(_db.localPermits)
              ..where((t) => t.id.equals(permit.id)))
            .go();
      }
      notifyListeners();
    } on ApiException {
      // Offline reads retain the last durable snapshot.
    }
  }

  Future<void> refreshDetailFromNetwork(String permitId) async {
    try {
      final existing = await getPermit(permitId);
      if (existing != null && existing.row.syncState != 'synced') return;
      await _upsert(
          await _api.getPermit(permitId), PermitLocalSyncState.synced);
      notifyListeners();
    } on ApiException {
      // Keep the durable snapshot available offline.
    }
  }

  Future<void> acknowledge(
      {required String permitId, String? deviceId, DateTime? signedAt}) async {
    final current = await getPermit(permitId);
    if (current == null) throw StateError('Permit is not cached');
    final request = AcknowledgePermitRequest((b) => b
      ..clientMutationId = _uuid.v4()
      ..clientSignedAt = (signedAt ?? DateTime.now()).toUtc()
      ..deviceId = deviceId
      ..expectedRevision = current.detail.revision
      ..workerAttestation =
          AcknowledgePermitRequestWorkerAttestationEnum.true_);
    await _db.transaction(() async {
      await (_db.update(_db.localPermits)..where((t) => t.id.equals(permitId)))
          .write(
        LocalPermitsCompanion(
            syncState: const drift.Value('pending_sync'),
            errorMessage: const drift.Value(null),
            pendingAcknowledgementJson: drift.Value(jsonEncode(
                standardSerializers.serializeWith(
                    AcknowledgePermitRequest.serializer, request)))),
      );
      await _db.into(_db.permitOutbox).insert(PermitOutboxCompanion.insert(
            id: _uuid.v4(),
            permitId: permitId,
            mutationType: 'acknowledge',
            payload: jsonEncode(standardSerializers.serializeWith(
                AcknowledgePermitRequest.serializer, request)),
            createdAt: DateTime.now().toUtc(),
          ));
    });
    notifyListeners();
  }

  Future<int> outboxCount() async =>
      (await _db.select(_db.permitOutbox).get()).length;

  Future<List<PermitOutboxItemRecord>> queueForDrain(
      {required DateTime now, bool bypassBackoff = false}) async {
    final query = _db.select(_db.permitOutbox)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]);
    query.where((t) => bypassBackoff
        ? t.nextAttemptAt.isNull() |
            t.nextAttemptAt.isSmallerThanValue(permitPausedSentinel)
        : t.nextAttemptAt.isNull() |
            t.nextAttemptAt.isSmallerOrEqualValue(now));
    return (await query.get()).map(PermitOutboxItemRecord.new).toList();
  }

  AcknowledgePermitRequest requestFor(PermitOutboxItemRecord item) =>
      standardSerializers.deserializeWith(AcknowledgePermitRequest.serializer,
          jsonDecode(item.row.payload) as Map<String, dynamic>)!;

  Future<void> applySuccess(
      PermitOutboxItemRecord item, PermitDetail server) async {
    await _db.transaction(() async {
      await (_db.delete(_db.permitOutbox)..where((t) => t.id.equals(item.id)))
          .go();
      await _upsert(server, PermitLocalSyncState.synced);
    });
    notifyListeners();
  }

  Future<void> markTransient(PermitOutboxItemRecord item, String message,
      DateTime nextAttemptAt) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.permitOutbox)..where((t) => t.id.equals(item.id)))
        .write(PermitOutboxCompanion(
            attempts: drift.Value(item.attempts + 1),
            lastAttemptAt: drift.Value(now),
            lastError: drift.Value(message),
            nextAttemptAt: drift.Value(nextAttemptAt)));
    await (_db.update(_db.localPermits)
          ..where((t) => t.id.equals(item.permitId)))
        .write(LocalPermitsCompanion(
            lastAttemptAt: drift.Value(now),
            errorMessage: drift.Value(message)));
    notifyListeners();
  }

  Future<void> markError(PermitOutboxItemRecord item, String message) async {
    await (_db.update(_db.permitOutbox)..where((t) => t.id.equals(item.id)))
        .write(PermitOutboxCompanion(
            attempts: drift.Value(item.attempts + 1),
            lastError: drift.Value(message),
            nextAttemptAt: drift.Value(permitPausedSentinel)));
    await (_db.update(_db.localPermits)
          ..where((t) => t.id.equals(item.permitId)))
        .write(LocalPermitsCompanion(
            syncState: const drift.Value('error'),
            errorMessage: drift.Value(message)));
    notifyListeners();
  }

  Future<void> markConflict(
      PermitOutboxItemRecord item, PermitDetail server) async {
    await _db.transaction(() async {
      await (_db.delete(_db.permitOutbox)
            ..where((t) => t.permitId.equals(item.permitId)))
          .go();
      await (_db.update(_db.localPermits)
            ..where((t) => t.id.equals(item.permitId)))
          .write(LocalPermitsCompanion(
              permitNumber: drift.Value(server.permitNumber),
              title: drift.Value(server.title),
              permitType:
                  drift.Value(dartEnumNameToWire(server.permitType.name)),
              facilityId: drift.Value(server.facilityId),
              status: drift.Value(dartEnumNameToWire(server.status.name)),
              revision: drift.Value(server.revision),
              validFrom: drift.Value(server.validFrom),
              validUntil: drift.Value(server.validUntil),
              updatedAt: drift.Value(server.updatedAt),
              detailJson: drift.Value(_encodeDetail(server)),
              syncState: const drift.Value('conflict'),
              errorMessage: const drift.Value(null),
              conflictServerSnapshot: drift.Value(_encodeDetail(server))));
    });
    notifyListeners();
  }

  Future<void> resolveConflict(String permitId,
      {required bool keepAcknowledgement}) async {
    final local = await (_db.select(_db.localPermits)
          ..where((t) => t.id.equals(permitId)))
        .getSingle();
    final snapshotJson = local.conflictServerSnapshot;
    if (snapshotJson == null) return;
    final server = _decodeDetail(snapshotJson);
    if (!keepAcknowledgement) {
      await _upsert(server, PermitLocalSyncState.synced);
      notifyListeners();
      return;
    }
    final pendingJson = local.pendingAcknowledgementJson;
    if (pendingJson == null) return;
    final pending = standardSerializers.deserializeWith(
        AcknowledgePermitRequest.serializer,
        jsonDecode(pendingJson) as Map<String, dynamic>)!;
    final rebased =
        pending.rebuild((b) => b..expectedRevision = server.revision);
    await _db.transaction(() async {
      await _upsert(server, PermitLocalSyncState.pendingSync,
          pendingAcknowledgementJson: jsonEncode(standardSerializers
              .serializeWith(AcknowledgePermitRequest.serializer, rebased)));
      await _db.into(_db.permitOutbox).insert(PermitOutboxCompanion.insert(
          id: _uuid.v4(),
          permitId: permitId,
          mutationType: 'acknowledge',
          payload: jsonEncode(standardSerializers.serializeWith(
              AcknowledgePermitRequest.serializer, rebased)),
          createdAt: DateTime.now().toUtc()));
    });
    notifyListeners();
  }

  Future<void> _upsert(PermitDetail detail, PermitLocalSyncState state,
          {String? pendingAcknowledgementJson}) =>
      _db.into(_db.localPermits).insertOnConflictUpdate(
          LocalPermitsCompanion.insert(
              id: detail.id,
              permitNumber: detail.permitNumber,
              title: detail.title,
              permitType: dartEnumNameToWire(detail.permitType.name),
              facilityId: detail.facilityId,
              status: dartEnumNameToWire(detail.status.name),
              revision: detail.revision,
              validFrom: detail.validFrom,
              validUntil: detail.validUntil,
              updatedAt: detail.updatedAt,
              detailJson: _encodeDetail(detail),
              syncState: drift.Value(state.wireValue),
              errorMessage: const drift.Value(null),
              conflictServerSnapshot: const drift.Value(null),
              pendingAcknowledgementJson:
                  drift.Value(pendingAcknowledgementJson)));

  static String _encodeDetail(PermitDetail detail) => jsonEncode(
      standardSerializers.serializeWith(PermitDetail.serializer, detail));
  static PermitDetail _decodeDetail(String value) =>
      standardSerializers.deserializeWith(
          PermitDetail.serializer, jsonDecode(value) as Map<String, dynamic>)!;

  static const _ownerKey = 'fev_offline_data_owner_uid_permits';
  Future<void> reconcileSessionOwner(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final owner = preferences.getString(_ownerKey);
    if (owner != null && owner != uid) await wipeAllLocalData();
    await preferences.setString(_ownerKey, uid);
  }

  Future<void> wipeAllLocalData() async {
    await _db.transaction(() async {
      await _db.delete(_db.permitOutbox).go();
      await _db.delete(_db.localPermits).go();
    });
    notifyListeners();
  }
}
