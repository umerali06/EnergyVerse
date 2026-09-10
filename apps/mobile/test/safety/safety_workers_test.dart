import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/safety/local_safety_evidence_repository.dart';
import 'package:fev_mobile/safety/local_safety_reports_repository.dart';
import 'package:fev_mobile/safety/safety_evidence_upload_worker.dart';
import 'package:fev_mobile/safety/safety_sync_engine.dart';
import 'package:flutter_test/flutter_test.dart';

SafetyReportDetail detailFixture({
  String id = 'report-1',
  List<CorrectiveActionResponse> actions = const [],
}) {
  final now = DateTime.utc(2026, 8, 19);
  return SafetyReportDetail((b) => b
    ..id = id
    ..category = SafetyReportDetailCategoryEnum.unsafeCondition
    ..severity = SafetyReportDetailSeverityEnum.high
    ..title = 'Missing guard'
    ..description = 'Guard was missing.'
    ..occurredAt = now
    ..reporterId = 'inspector-1'
    ..status = SafetyReportDetailStatusEnum.correctiveAction
    ..revision = 2
    ..createdAt = now
    ..createdBy = 'inspector-1'
    ..updatedAt = now
    ..correctiveActions.replace(actions));
}

CorrectiveActionResponse actionFixture({
  CorrectiveActionResponseStatusEnum status =
      CorrectiveActionResponseStatusEnum.open,
}) {
  final now = DateTime.utc(2026, 8, 19);
  return CorrectiveActionResponse((b) => b
    ..id = 'action-1'
    ..description = 'Replace damaged guard'
    ..assigneeId = 'technician-1'
    ..dueDate = DateTime.utc(2026, 8, 22)
    ..priority = CorrectiveActionResponsePriorityEnum.high
    ..status = status
    ..createdAt = now
    ..createdBy = 'hse-1'
    ..updatedAt = now);
}

class WorkerApi implements SafetyApiContract {
  int uploads = 0;
  UpdateCorrectiveActionRequest? actionRequest;

  @override
  Future<SafetyReportDetail> uploadSafetyEvidence({
    required String reportId,
    required String kind,
    required String path,
    required String filename,
    void Function(int sent, int total)? onProgress,
  }) async {
    uploads += 1;
    return detailFixture(id: reportId);
  }

  @override
  Future<SafetyReportDetail> updateSafetyCorrectiveAction(String reportId,
      String actionId, UpdateCorrectiveActionRequest request) async {
    actionRequest = request;
    return detailFixture(
      id: reportId,
      actions: [
        actionFixture(status: CorrectiveActionResponseStatusEnum.inProgress)
      ],
    );
  }

  @override
  Future<SafetyReportDetail> createSafetyReport(
          CreateSafetyReportRequest request) =>
      throw UnimplementedError();

  @override
  Future<SafetyReportDetail> getSafetyReport(String reportId) async =>
      detailFixture(id: reportId);

  @override
  Future<SafetyReportListPage> getSafetyReports({
    String? status,
    String? category,
    String? severity,
    String? reporterId,
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();
}

Future<void> seedReport(AppDatabase db,
    {String correctiveActions = '[]'}) async {
  final now = DateTime.utc(2026, 8, 19);
  await db.into(db.localSafetyReports).insert(
        LocalSafetyReportsCompanion.insert(
          id: 'report-1',
          category: 'unsafe_condition',
          severity: 'high',
          title: 'Missing guard',
          description: 'Guard was missing.',
          occurredAt: now,
          reporterId: 'inspector-1',
          createdAt: now,
          updatedAt: now,
          syncState: const drift.Value('synced'),
          correctiveActions: drift.Value(correctiveActions),
        ),
      );
}

void main() {
  test('evidence worker uploads then removes durable queue item', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final api = WorkerApi();
    final reports = LocalSafetyReportsRepository(db: db, api: api);
    final evidence = LocalSafetyEvidenceRepository(db: db);
    final connectivity = StreamController<List<ConnectivityResult>>.broadcast();
    final worker = SafetyEvidenceUploadWorker(
      evidenceRepository: evidence,
      reportsRepository: reports,
      api: api,
      connectivityStreamFactory: () => connectivity.stream,
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
    );
    final directory = await Directory.systemTemp.createTemp('fev-worker-');
    addTearDown(() async {
      worker.dispose();
      evidence.dispose();
      reports.dispose();
      await connectivity.close();
      await db.close();
      if (await directory.exists()) await directory.delete(recursive: true);
    });
    await seedReport(db);
    final file = File('${directory.path}${Platform.pathSeparator}evidence.jpg');
    await file.writeAsBytes([1, 2, 3]);
    await evidence.enqueue(
      reportId: 'report-1',
      kind: 'photo',
      localFilePath: file.path,
      filename: 'evidence.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 3,
    );

    worker.kick();
    while (worker.isRunning ||
        (await db.select(db.safetyEvidenceQueue).get()).isNotEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    expect(api.uploads, 1);
    expect(await db.select(db.safetyEvidenceQueue).get(), isEmpty);
  });

  test('safety sync dispatches targeted action and accepts server snapshot',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    final api = WorkerApi();
    final repository = LocalSafetyReportsRepository(db: db, api: api);
    final connectivity = StreamController<List<ConnectivityResult>>.broadcast();
    final action = actionFixture();
    final encoded = jsonEncode([
      standardSerializers.serializeWith(
          CorrectiveActionResponse.serializer, action)
    ]);
    await seedReport(db, correctiveActions: encoded);
    await repository.updateCorrectiveActionOffline(
      reportId: 'report-1',
      actionId: 'action-1',
      status: UpdateCorrectiveActionRequestStatusEnum.inProgress,
    );
    final engine = SafetySyncEngine(
      repository: repository,
      api: api,
      connectivityStreamFactory: () => connectivity.stream,
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
      connectivityDebounce: Duration.zero,
    );
    addTearDown(() async {
      engine.dispose();
      repository.dispose();
      await connectivity.close();
      await db.close();
    });

    await engine.syncNow();

    expect(api.actionRequest?.status,
        UpdateCorrectiveActionRequestStatusEnum.inProgress);
    expect(await repository.outboxCount(), 0);
    final report = await db.select(db.localSafetyReports).getSingle();
    expect(report.syncState, 'synced');
    expect(LocalSafetyReportRecord(report).correctiveActions.single.status,
        CorrectiveActionResponseStatusEnum.inProgress);
  });
}
