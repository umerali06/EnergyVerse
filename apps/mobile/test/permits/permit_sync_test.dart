import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/permits/local_permits_repository.dart';
import 'package:fev_mobile/permits/permit_sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

PermitDetail permitDetail(
    {int revision = 4,
    String status = 'pendingSignatures',
    String? mutationId}) {
  final now = DateTime.utc(2026, 8, 19, 12);
  return PermitDetail((b) => b
    ..id = 'permit-1'
    ..permitNumber = 'PTW-20260819-ABCD1234'
    ..title = 'Replace relief valve'
    ..description = 'Controlled replacement'
    ..permitType = PermitDetailPermitTypeEnum.hotWork
    ..facilityId = 'facility-1'
    ..templateId = 'template-1'
    ..templateName = 'Hot work standard'
    ..templateVersion = 3
    ..status = PermitDetailStatusEnum.values
        .firstWhere((value) => value.name == status)
    ..revision = revision
    ..highestResidualRisk = PermitDetailHighestResidualRiskEnum.medium
    ..validFrom = now.subtract(const Duration(hours: 1))
    ..validUntil = now.add(const Duration(hours: 8))
    ..workerIds.replace(['worker-1'])
    ..workerCount = 1
    ..workerAcknowledgements.replace(mutationId == null
        ? []
        : [
            PermitWorkerAcknowledgementResponse((a) => a
              ..workerId = 'worker-1'
              ..clientMutationId = mutationId
              ..clientSignedAt = now
              ..receivedAt = now
              ..signedAt = now
              ..meaning = 'Worker acknowledged permit controls')
          ])
    ..checklistSnapshot.replace([])
    ..approvalSnapshot.replace([])
    ..riskAssessment.replace([])
    ..createdAt = now
    ..updatedAt = now);
}

class FakePermitApi implements PermitApiContract {
  FakePermitApi({required this.getDetail, this.acknowledge});
  final Future<PermitDetail> Function(String id) getDetail;
  final Future<PermitDetail> Function(
      String id, AcknowledgePermitRequest request)? acknowledge;
  AcknowledgePermitRequest? captured;

  @override
  Future<PermitDetail> getPermit(String permitId) => getDetail(permitId);
  @override
  Future<PermitDetail> acknowledgePermit(
      String permitId, AcknowledgePermitRequest request) {
    captured = request;
    return acknowledge?.call(permitId, request) ??
        Future.value(permitDetail(
            revision: request.expectedRevision + 1,
            mutationId: request.clientMutationId));
  }

  @override
  Future<PermitListPage> getPermits(
          {String? workerId, String? cursor, int limit = 25}) =>
      throw UnimplementedError();
}

PermitSyncEngine engine(
        LocalPermitsRepository repository, PermitApiContract api) =>
    PermitSyncEngine(
      repository: repository,
      api: api,
      connectivityStreamFactory: () =>
          const Stream<List<ConnectivityResult>>.empty(),
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
      now: () => DateTime.utc(2026, 8, 19, 12),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('server permit detail is stored as a complete durable offline snapshot',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakePermitApi(getDetail: (_) async => permitDetail());
    final repository = LocalPermitsRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('permit-1');
    final cached = await repository.getPermit('permit-1');
    expect(cached!.detail.templateName, 'Hot work standard');
    expect(cached.row.syncState, 'synced');
    expect(cached.detail.workerIds, ['worker-1']);
  });

  test(
      'offline acknowledgement persists client provenance and a FIFO outbox row',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakePermitApi(getDetail: (_) async => permitDetail());
    final repository =
        LocalPermitsRepository(db: db, api: api, uuid: const Uuid());
    await repository.refreshDetailFromNetwork('permit-1');
    final signedAt = DateTime.utc(2026, 8, 19, 12, 30);
    await repository.acknowledge(
        permitId: 'permit-1', deviceId: 'device-a', signedAt: signedAt);
    final item = (await repository.queueForDrain(now: signedAt)).single;
    final request = repository.requestFor(item);
    expect(request.expectedRevision, 4);
    expect(request.clientSignedAt, signedAt);
    expect(request.deviceId, 'device-a');
    expect((await repository.getPermit('permit-1'))!.row.syncState,
        'pending_sync');
  });

  test(
      'successful replay replaces local state with the server-signed acknowledgement',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = FakePermitApi(getDetail: (_) async => permitDetail());
    final repository = LocalPermitsRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('permit-1');
    await repository.acknowledge(permitId: 'permit-1');
    final sync = engine(repository, api);
    addTearDown(sync.dispose);
    await sync.syncNow();
    expect(await repository.outboxCount(), 0);
    expect(
        (await repository.getPermit('permit-1'))!.detail.workerAcknowledgements,
        hasLength(1));
    expect((await repository.getPermit('permit-1'))!.row.syncState, 'synced');
  });

  test(
      'already-applied mutation replay is accepted without duplicating acknowledgement',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    late FakePermitApi api;
    var fetches = 0;
    api = FakePermitApi(
      getDetail: (_) async => ++fetches == 1
          ? permitDetail()
          : permitDetail(
              revision: 5, mutationId: api.captured!.clientMutationId),
      acknowledge: (_, __) async =>
          throw const ApiException(code: 'revision_conflict', message: 'stale'),
    );
    final repository = LocalPermitsRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('permit-1');
    await repository.acknowledge(permitId: 'permit-1');
    final sync = engine(repository, api);
    addTearDown(sync.dispose);
    await sync.syncNow();
    expect(await repository.outboxCount(), 0);
    expect((await repository.getPermit('permit-1'))!.row.syncState, 'synced');
  });

  test(
      'genuine revision conflict preserves mutation identity and rebases explicitly',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var fetches = 0;
    final api = FakePermitApi(
      getDetail: (_) async => permitDetail(revision: ++fetches == 1 ? 4 : 7),
      acknowledge: (_, __) async =>
          throw const ApiException(code: 'revision_conflict', message: 'stale'),
    );
    final repository = LocalPermitsRepository(db: db, api: api);
    await repository.refreshDetailFromNetwork('permit-1');
    await repository.acknowledge(
        permitId: 'permit-1',
        deviceId: 'device-a',
        signedAt: DateTime.utc(2026, 8, 19, 12, 30));
    final original = repository.requestFor(
        (await repository.queueForDrain(now: DateTime.utc(2026, 8, 19, 13)))
            .single);
    final sync = engine(repository, api);
    addTearDown(sync.dispose);
    await sync.syncNow();
    expect((await repository.getPermit('permit-1'))!.row.syncState, 'conflict');
    await repository.resolveConflict('permit-1', keepAcknowledgement: true);
    final rebased = repository.requestFor(
        (await repository.queueForDrain(now: DateTime.utc(2026, 8, 19, 13)))
            .single);
    expect(rebased.expectedRevision, 7);
    expect(rebased.clientMutationId, original.clientMutationId);
    expect(rebased.clientSignedAt, original.clientSignedAt);
    expect(rebased.deviceId, 'device-a');
  });
}
